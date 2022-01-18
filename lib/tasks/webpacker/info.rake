require "webpacker/version"

namespace :webpacker do
  desc "Provide information on Webpacker's environment"
  task :info do
    Dir.chdir(Rails.root) do
      $stdout.puts "Ruby: #{`ruby --version`}"
      $stdout.puts "Rails: #{Rails.version}"
      $stdout.puts "Webpacker: #{Webpacker::VERSION}"
      $stdout.puts "Node: #{`node --version`}"
      $stdout.puts "Yarn: #{`yarn --version`}"

      $stdout.puts "\n"
      $stdout.puts "@rails/webpacker: \n#{`npm list @rails/webpacker version`}"

      $stdout.puts "Is bin/webpacker present?: #{File.exist? 'bin/webpacker'}"
      $stdout.puts "Is bin/webpacker-dev-server present?: #{File.exist? 'bin/webpacker-dev-server'}"
      $stdout.puts "Is bin/yarn present?: #{File.exist? 'bin/yarn'}"
    end
  end
end
