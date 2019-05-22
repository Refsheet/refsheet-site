module ActiveJob
  module QueueAdapters
    class SplitQueueAdapter
      GOOGLE_PERCENT = (ENV.fetch('ACTIVE_JOB_GOOGLE_PERCENT') { 0 }).to_i

      def enqueue(job)
        pick_queue(job).enqueue(job)
      end

      def enqueue_at(job, timestamp)
        pick_queue(job).enqueue_at(job, timestamp)
      end

      private

      def lookup(name)
        ActiveJob::QueueAdapters.lookup(name).new
      end

      def guess_user(job)
        Rails.logger.info job.class.name.inspect

        if job.class.name == "DelayedPaperclip::ProcessJob"
          klass = Object.const_get(job.arguments[0])
          inst = klass.find(job.arguments[1])

          if inst.is_a? User
            return inst
          elsif inst.respond_to? :user
            return inst.user
          end
        end

        job.arguments.each do |arg|
          if arg.is_a? User
            return arg
          elsif arg.respond_to? :user
            return arg.user
          end
        end

        nil
      rescue => e
        puts e.message
        return nil
      end

      def redis_available?
        ENV['REDIS_HOST'].present?
      end

      def priority_queue?(job)
        job.queue_name && job.queue_name.to_s == 'priority'
      end

      def experiment_hit?(job)
        user = guess_user(job)
        roll = rand(1..100) <= GOOGLE_PERCENT

        roll || user&.admin? || priority_queue?(job)
      end

      def pick_queue(job)
        if Rails.env.test?
          return lookup(Rails.configuration.active_job.queue_adapter)
        end

        queue = if redis_available? && experiment_hit?(job)
                  Rails.logger.info("Experiment hit")
                  lookup(:resque)
                else
                  lookup(Rails.configuration.active_job.queue_adapter)
                end

        Rails.logger.info("Queuing job on #{queue.class.name}")
        queue
      end
    end
  end
end