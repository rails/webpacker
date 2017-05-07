require "rake"
require "webpacker"

module Webpacker::TestHelper
  extend ActiveSupport::Concern

  included do
    setup :compile_webpack_assets
  end

  def compile_webpack_assets
    Rails.cache.fetch(["webpacker", "manifest", checksum]) do
      @load_rakefile ||= Rake.load_rakefile(Rails.root.join("Rakefile"))
      Rake::Task["webpacker:compile"].invoke
      Rake::Task["webpacker:compile"].reenable
    end
  end

  private

    def checksum
      files = Dir["#{Webpacker::Configuration.source}/**/*"].reject { |f| File.directory?(f) }
      files.map { |f| File.mtime(f).utc.to_i }.max.to_s
    end
end
