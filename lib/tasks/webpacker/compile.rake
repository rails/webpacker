require "webpacker/env"
require "webpacker/configuration"
REGEX_MAP = /\A.*\.map\z/

namespace :webpacker do
  desc "Compile javascript packs using webpack for production with digests"
  task compile: ["webpacker:verify_install", :environment] do
    puts "Compiling webpacker assets 🎉"
    result = `NODE_ENV=#{Webpacker::Env.current} ./bin/webpack`

    unless $?.success?
      puts JSON.parse(result)["errors"]
      exit! $?.exitstatus
    end

    puts "Compiled digests for all packs in #{Webpacker::Configuration.output_path}: "
    puts JSON.parse(File.read(Webpacker::Configuration.manifest_path))
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    unless Rake::Task.task_defined?("yarn:install")
      # For Rails < 5.1
      Rake::Task["webpacker:yarn_install"].invoke
    end
    Rake::Task["webpacker:compile"].invoke
  end
end
