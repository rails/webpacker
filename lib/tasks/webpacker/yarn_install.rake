namespace :webpacker do
  desc "Support for older Rails versions. Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install do
    system "yarn install --no-progress --frozen-lockfile --production --network-timeout 1000000"
  end
end
