require "open3"
require "webpacker/env"
require "webpacker/configuration"

namespace :webpacker do
  desc "Compile javascript packs using webpack for production with digests"
  task compile: ["webpacker:verify_install", :environment] do
    new_line = "\n\n"
    puts "[Webpacker] Compiling assets 🎉" + new_line

    asset_host = ActionController::Base.helpers.compute_asset_host
    env = { "NODE_ENV" => Webpacker.env, "ASSET_HOST" => asset_host }.freeze

    _, stderr_str, status = Open3.capture3(env, "./bin/webpack")

    if status.success?
      puts "[Webpacker] Compiled digests for all packs in #{Webpacker::Configuration.entry_path}:" + new_line
      puts JSON.parse(File.read(Webpacker::Configuration.manifest_path))
    else
      $stderr.puts "[Webpacker] [FAIL]" + new_line
      $stderr.puts stderr_str
      exit!
    end
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
