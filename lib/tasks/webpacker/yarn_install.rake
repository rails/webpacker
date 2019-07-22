namespace :webpacker do
  desc "Support for older Rails versions. Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install do
    system "yarn install --no-progress"

    exit(1) unless $?.success?
  end
end

# safe workaround for adding action
namespace :yarn do
  task :install do
    Rake::Task["yarn:install"].enhance do
      exit(1) unless $?.success?
    end
  end
end
