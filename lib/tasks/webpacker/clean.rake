$stdout.sync = true

require "webpacker/configuration"

namespace :webpacker do
  desc "Remove old compiled webpacks"
  task :clean, [:keep] => ["webpacker:verify_install", :environment] do |_, args|
    Webpacker.ensure_log_goes_to_stdout do
      Webpacker.clean(Integer(args.keep || 2))
    end
  end
end

# Run clean if the assets:clean is run
if Rake::Task.task_defined?("assets:clean")
  Rake::Task["assets:clean"].enhance do
    Rake::Task["webpacker:clean"].invoke
  end
end
