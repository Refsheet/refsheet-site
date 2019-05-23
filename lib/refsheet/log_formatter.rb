module Refsheet
  class LogFormatter < SemanticLogger::Formatters::Json
    def initialize
      super(log_application: false)
    end

    def level
      # Map to Google Cloud levels:

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

      hash[:level] = levels[log.level.downcase.to_sym] || "DEFAULT"
      hash[:level_index] = log.level_index
    end
  end
end