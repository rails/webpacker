namespace :webpacker do
  desc "Support for older Rails versions. Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install do
    if ENV["RAILS_ENV"] == "production"
      system "yarn install --no-progress --frozen-lockfile --production"
    else
      system "yarn install --no-progress"
    end
  end
end
