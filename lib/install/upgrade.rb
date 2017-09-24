require "webpacker/configuration"

puts "Upgrading binstubs..."
run "bundle binstubs webpacker --force"

puts "Upgrading @rails/webpacker module..."
run "yarn upgrade @rails/webpacker --latest"

puts "Webpacker successfully installed 🎉 🍰"
puts "Please check in any changes in binstubs, package.json or yarn.lock."
