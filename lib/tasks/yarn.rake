# frozen_string_literal: true

# Duplicate of the yarn tasks still present in Rails until Webpacker <5 have been deprecated

namespace :yarn do
  desc "Install all JavaScript dependencies as specified via Yarn"
  task :install do
    # Install only production deps when for not usual envs.
    valid_node_envs = %w[test development production]
    node_env = ENV.fetch("NODE_ENV") do
      valid_node_envs.include?(Rails.env) ? Rails.env : "production"
    end

    yarn_flags =
      if `#{RbConfig.ruby} "#{Rails.root}/bin/yarn" --version`.start_with?("1")
        "--no-progress --frozen-lockfile"
      else
        "--immutable"
      end

    system(
      { "NODE_ENV" => node_env },
      "#{RbConfig.ruby} \"#{Rails.root}/bin/yarn\" install #{yarn_flags}",
      exception: true
    )
  rescue Errno::ENOENT
    $stderr.puts "bin/yarn was not found."
    $stderr.puts "Please run `bundle exec rails app:update:bin` to create it."
    exit 1
  end
end

# Run Yarn prior to Sprockets assets precompilation, so dependencies are available for use.
if Rake::Task.task_defined?("assets:precompile") && File.exist?(Rails.root.join("bin", "yarn"))
  Rake::Task["assets:precompile"].enhance [ "yarn:install" ]
end
