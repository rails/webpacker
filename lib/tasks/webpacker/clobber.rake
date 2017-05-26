require "webpacker/configuration"

namespace :webpacker do
  desc "Remove the webpack compiled output directory"
  task clobber: ["webpacker:verify_install", :environment] do
    output_path = Webpacker::Configuration.output_path
    FileUtils.rm_r(output_path) if File.exist?(output_path)
    puts "Removed webpack output path directory #{output_path}"
  end
end

# Run clobber if the assets:clobber is run
if Rake::Task.task_defined?("assets:clobber")
  Rake::Task["assets:clobber"].enhance do
    Rake::Task["webpacker:clobber"].invoke
  end
end
