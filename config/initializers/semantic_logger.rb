module SemanticLogger
  class Logger < Base
    def log(log, message = nil, progname = nil, &block)
      # Compatibility with ::Logger
      if defined? Google
        log.instance_variable_set("@_trace", Thread.current[Google::Cloud::Trace::THREAD_KEY])
      end

      return add(log, message, progname, &block) unless log.is_a?(SemanticLogger::Log)

      Logger.call_subscribers(log)

      Logger.processor.log(log)
    end
  end
end