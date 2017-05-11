namespace :webpacker do
  desc "Support for older Rails versions.Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install do
    system("./bin/yarn")
  end
end
