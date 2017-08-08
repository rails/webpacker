require "webpacker/configuration"

namespace :webpacker do
  desc "Remove the webpack compiled output directory"
  task clobber: ["webpacker:verify_install", :environment] do
    output_path = Webpacker::Configuration.output_path
    FileUtils.rm_r(output_path) if File.exist?(output_path)
    $stdout.puts "Removed webpack output path directory #{output_path}"
  end
end
