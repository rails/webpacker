namespace :webpacker do
  desc "Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install do
    system("./bin/yarn")
  end
end

# Run Yarn prior to Sprockets assets precompilation, so dependencies are available for use.
if Rake::Task.task_defined?("assets:precompile")
  unless Rake::Task.task_defined?("yarn:install")
    Rake::Task["assets:precompile"].enhance["webpacker:yarn_install"]
  end
end
