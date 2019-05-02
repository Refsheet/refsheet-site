require 'rainbow'

module Refsheet
  class Logger < Ougai::Logger
    include ActiveSupport::LoggerThreadSafeLevel
    include ActiveSupport::TaggedLogging
    include LoggerSilence

    def initialize(*args)
      super
      after_initialize if respond_to? :after_initialize
    end

    def create_formatter
      Refsheet::Logger::Formatter.new
    end

    class Formatter < Ougai::Formatters::Base
      include ActiveSupport::TaggedLogging::Formatter

      def initialize
        super

        @rainbow = Rainbow.new.tap do |r|
          r.enabled = true
        end

        @gcloud_logger = extend_gcloud
      end

      def call(severity, time, progname, data)
        data[:message] = data.delete(:msg)

        message = {
            name: progname || @app_name,
            hostname: @hostname,
            pid: $$,
            level: to_level(severity),
            time: time.to_datetime.rfc3339(3),
            version: Refsheet::VERSION,
            tags: current_tags.dup,
            labels: {}
        }.merge(data)

        current_tags.each do |tag|
          if tag =~ /^(\w+):(.*)$/
            message[:labels][$1] = $2
          end
        end

        send_to_gcloud(to_level(severity), message, progname)

        output  = c("[%s] ").white % message[:time]
        output += c("%6s -- " % message[:level]).color(to_color(message[:level]))

        if message[:tags].any?
          output += c("[#{message[:tags].join(", ")}] ").cyan
        end

        output += message[:message]
        output + "\n"
      end

      def to_level(severity)
        levels = {
            debug: "DEBUG",
            info: "INFO",
            notice: "NOTICE",
            warn: "WARN",
            error: "ERROR",
            fatal: "CRITICAL",
            alert: "ALERT",
            emergency: "EMERGENCY"
        }

        levels[severity.downcase.to_sym] || "DEFAULT"
      end

      def to_color(severity)
        case severity
        when "DEBUG"
          :blue
        when "INFO"
          :green
        when "NOTICE"
          :yellow
        when "WARN"
          :yellow
        when "ERROR"
          :red
        when "CRITICAL"
          :red
        when "FATAL"
          [:red, :bright]
        when "ALERT"
          [:red, :bright]
        else
          :black
        end
      end

      private

      def c(string)
        @rainbow.wrap(string)
      end

      def send_to_gcloud(severity, json, progname)
        return unless @gcloud_logger
        payload = json.dup
        payload[:message] = Rainbow::StringUtils.uncolor payload[:message]
        @gcloud_logger.log(severity, payload, progname)
      end

      def extend_gcloud
        project_id = Rails.configuration.google_cloud.project_id

        return unless project_id

        credentials = Rails.configuration.google_cloud.keyfile
        log_name = Rails.configuration.google_cloud.logging.log_name
        env = Rails.env.to_s
        resource = Rails.configuration.google_cloud.logging.resource

        gcloud = Google::Cloud::Logging.new project_id: project_id,
                                            credentials: credentials

        resource = gcloud.resource resource
        gcloud.logger log_name, resource, env: env
      rescue => e
        puts(e)
        nil
      end
    end
  end
end