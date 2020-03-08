module Refsheet
  class LogFormatter < SemanticLogger::Formatters::Json
    def initialize
      super(log_application: false)
    end

    def level
      # Map to Google Cloud levels:
      Thread.current[Google::Cloud::Trace::THREAD_KEY] = log.instance_variable_get("@_trace")

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

      hash[:severity] = levels[log.level.downcase.to_sym] || "DEFAULT"
      hash[:level_index] = log.level_index
      hash[:trace] = ""
      hash[:span_id] = ""

      begin
        trace_or_span = Google::Cloud::Trace.get
        unless trace_or_span.nil?
          trace = trace_or_span.is_a?(Google::Cloud::Trace) ? trace_or_span : trace_or_span.trace
          span = trace_or_span.is_a?(Google::Cloud::Trace) ? nil : trace_or_span

          hash[:trace] = "projects/refsheet-239409/traces/" + trace&.trace_id
          hash[:span_id] = span&.span_id
        end
      rescue => e
        puts e.inspect
      end

      log.level_index
    end
  end
end