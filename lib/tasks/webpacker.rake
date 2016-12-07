PACKS_PATH        = Rails.root.join('public/packs')
PACK_DIGESTS_PATH = PACKS_PATH.join('digests.json')

WEBPACKER_APP_TEMPLATE_PATH = File.expand_path('../install/template.rb', File.dirname(__FILE__))

namespace :webpacker do
  desc "compile javascript packs using webpack for production with digests"
  task :compile do
    webpack_digests_json = JSON.parse(`WEBPACK_ENV=production ./bin/webpack --json`)['assetsByChunkName'].to_json

    FileUtils.mkdir_p(PACKS_PATH)
    File.open(PACK_DIGESTS_PATH, 'w+') { |file| file.write webpack_digests_json }

    puts "Compiled digests for all packs in #{PACK_DIGESTS_PATH}: "
    puts webpack_digests_json
  end

  desc "install webpacker in this application"
  task :install do
    exec "./bin/rails app:template LOCATION=#{WEBPACKER_APP_TEMPLATE_PATH}"
  end
end
