say "Appending Stimulus setup code to #{Webpacker.config.source_entry_path}/application.js"
inject_into_file "#{Webpacker.config.source_entry_path}/application.js", :after => "console.log('Hello World from Webpacker')" do
  open("#{__dir__}/examples/stimulus/setup.js").read
end

say "Creating controllers directory"
directory "#{__dir__}/examples/stimulus/controllers", "#{Webpacker.config.source_entry_path}/controllers"

say "Installing all Stimulus dependencies"
run "yarn add stimulus"

say "Webpacker now supports Stimulus.js 🎉", :green
