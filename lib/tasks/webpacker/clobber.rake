require "webpacker/configuration"

namespace :webpacker do
  desc "Remove the webpack compiled output directory"
  task clobber: ["webpacker:verify_install", :environment] do
    entry_path = Webpacker::Configuration.entry_path
    FileUtils.rm_r(entry_path) if File.exist?(entry_path)
    puts "Removed webpack output path directory #{entry_path}"
  end
end

# Run clobber if the assets:clobber is run
if Rake::Task.task_defined?("assets:clobber")
  Rake::Task["assets:clobber"].enhance do
    Rake::Task["webpacker:clobber"].invoke
  end
end
