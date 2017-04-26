# Install webpacker
puts "Copying webpack configuration files"
directory "#{__dir__}/config/webpack", "config/webpack"

puts "Creating javascript app source directory"
directory "#{__dir__}/javascript", "#{Webpacker::Configuration.source}"

puts "Copying binstubs"
template "#{__dir__}/bin/webpack-dev-server", "bin/webpack-dev-server"
template "#{__dir__}/bin/webpack-watcher", "bin/webpack-watcher"
template "#{__dir__}/bin/webpack", "bin/webpack"
if !File.exist?("bin/yarn")
  puts "Copying yarn"
  template "#{__dir__}/bin/yarn", "bin/yarn"
end
chmod "bin", 0755 & ~File.umask, verbose: false

puts "Copying babel and postcss config"
copy_file "#{__dir__}/examples/javascript/.babelrc", ".babelrc"
copy_file "#{__dir__}/config/.postcssrc.yml", ".postcssrc.yml"

if File.exists?(".gitignore")
  puts "Updating .gitignore"
  append_to_file ".gitignore", <<-EOS
/public/packs
/node_modules
EOS
end

puts "Installing webpacker-scripts"
run "./bin/yarn add webpacker-scripts"
puts "Webpacker successfully installed 🎉 🍰"
