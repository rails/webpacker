require "webpacker/configuration"
REGEX_MAP = /\A.*\.map\z/

namespace :webpacker do
  desc "Compile javascript packs using webpack for production with digests"
  task compile: ["webpacker:install:verify", :environment] do
    result = `NODE_ENV=production ./bin/webpack`

    unless $?.success?
      puts JSON.parse(result)["errors"]
      exit! $?.exitstatus
    end

    puts "Compiled digests for all packs in #{Webpacker::Configuration.packs_path}: "
    puts JSON.parse(File.read(Webpacker::Configuration.manifest_path))
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["webpacker:compile"].invoke
  end
end
