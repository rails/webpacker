require "webpacker/version"

namespace :webpacker do
  desc "Provide information on Webpacker's environment"
  task :info do
    $stdout.puts "Ruby: #{`ruby --version`}"
    $stdout.puts "Rails: #{Rails.version}"
    $stdout.puts "Webpacker: #{Webpacker::VERSION}"
    $stdout.puts "Node: #{`node --version`}"
    $stdout.puts "Yarn: #{`yarn --version`}"

    $stdout.puts "\n"
    $stdout.puts "@rails/webpacker: \n#{`npm list @rails/webpacker version`}"

    
    $stdout.puts "Is bin/webpack present?: #{present? 'bin/webpack'}"
    $stdout.puts "Is bin/webpack-dev-server present?: #{present? 'bin/webpack-dev-server'}"
    $stdout.puts "Is bin/yarn present?: #{present? 'bin/yarn'}"
  end
end

def present? path
  File.exist? path 
end