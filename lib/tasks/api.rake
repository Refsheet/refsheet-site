namespace :api do
  desc "Generate API Docs"
  task :generate do
    ENV['PATTERN'] = "spec/integration/**/*_spec.rb"
    ENV['SWAGGER_HACK'] = '1'
    Rake::Task['rswag:specs:swaggerize'].invoke
  end

  desc "Publish API docs [do not use]"
  task :publish do
    Rake::Task['rswag:ui:copy_assets'].invoke(Rails.root.join("public/api-docs"))
  end
end