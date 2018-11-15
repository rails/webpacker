say "Appending Stimulus setup code to #{Webpacker.config.source_entry_path}/application.js"
append_to_file "#{Webpacker.config.source_entry_path}/application.js" do
  "\n" + open("#{File.dirname(File.realpath(__FILE__))}/examples/stimulus/application.js").read
end

say "Creating controllers directory"
directory "#{File.dirname(File.realpath(__FILE__))}/examples/stimulus/controllers", "#{Webpacker.config.source_path}/controllers"

say "Installing all Stimulus dependencies"
run "yarn add stimulus"

say "Webpacker now supports Stimulus.js 🎉", :green
