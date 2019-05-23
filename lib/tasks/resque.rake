require 'resque/tasks'
task 'resque:setup' => :environment do
  Resque.before_fork = Proc.new {
    ActiveRecord::Base.establish_connectoin
    SemanticLogger.reopen
    STDOUT.sync = true
  }
end
