module ActiveJob
  module QueueAdapters
    class SplitQueueAdapter
      GOOGLE_PERCENT = (ENV.fetch('ACTIVE_JOB_GOOGLE_PERCENT') { 0 }).to_i

      def enqueue(job)
        pick_queue.enqueue(job)
      end

      def enqueue_at(*args)
        pick_queue.enqueue_at(*args)
      end

      private

      def lookup(name)
        ActiveJob::QueueAdapters.lookup(name).new
      end

      def pick_queue
        queue = if rand(0..100) > GOOGLE_PERCENT
                  lookup(Rails.configuration.active_job.queue_adapter)
                else
                  Rails.logger.info("Experiment hit")
                  lookup(:resque)
                end

        Rails.logger.info("Queuing job on #{queue.class.name}")
        queue
      end
    end
  end
end