tasks = {
  "webpacker:info"                    => "Provides information on Webpacker's environment",
  "webpacker:install"                 => "Installs and setup webpack with Yarn",
  "webpacker:compile"                 => "Compiles webpack bundles based on environment",
  "webpacker:clean"                   => "Remove old compiled webpacks",
  "webpacker:clobber"                 => "Removes the webpack compiled output directory",
  "webpacker:check_node"              => "Verifies if Node.js is installed",
  "webpacker:check_yarn"              => "Verifies if Yarn is installed",
  "webpacker:check_binstubs"          => "Verifies that bin/webpack is present",
  "webpacker:binstubs"                => "Installs Webpacker binstubs in this application",
  "webpacker:verify_install"          => "Verifies if Webpacker is installed",
  "webpacker:yarn_install"            => "Support for older Rails versions. Install all JavaScript dependencies as specified via Yarn"
}.freeze

desc "Lists all available tasks in Webpacker"
task :webpacker do
  puts "Available Webpacker tasks are:"
  tasks.each { |task, message| puts task.ljust(30) + message }
end
