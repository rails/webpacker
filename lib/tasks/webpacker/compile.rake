require "webpacker/package_json"
REGEX_MAP = /\A.*\.map\z/

namespace :webpacker do
  desc "Compile javascript packs using webpack for production with digests"
  task compile: ["webpacker:install:verify", :environment] do
    webpacker_config = Webpacker::PackageJson.webpacker
    result = `WEBPACK_DIST_DIR=#{webpacker_config[:distDir]} NODE_ENV=production ./bin/webpack`

    unless $?.success?
      puts JSON.parse(result)["errors"]
      exit! $?.exitstatus
    end

    packs_path = Rails.root.join("public", webpacker_config[:distDir])
    packs_digests_path = Rails.root.join(webpacker_config[:distPath], webpacker_config[:digestFileName])
    webpack_digests = JSON.parse(File.read(packs_digests_path))

    puts "Compiled digests for all packs in #{packs_digests_path}: "
    puts webpack_digests
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["webpacker:compile"].invoke
  end
end
