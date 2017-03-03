WEBPACKER_APP_TEMPLATE_PATH = File.expand_path('../../install/template.rb', __dir__)

namespace :webpacker do
  desc "Install webpacker in this application"
  task :install do
    # Calling exec before invoking app:tempalte will not proceed
    # exec 'yarn --version'
    # Checking yarn binstub - will not work because yarn binstub will not exist yet
    # `./bin/yarn --version`
    # Check yarn global - could work, but we are already depning on the yarn binstub,
    # so why not utilize it as the central point truth for existence of yarn global?
    # `yarn --version`
    if Rails::VERSION::MAJOR >= 5
      exec "./bin/rails app:template LOCATION=#{WEBPACKER_APP_TEMPLATE_PATH}"
    else
      exec "./bin/rake rails:template LOCATION=#{WEBPACKER_APP_TEMPLATE_PATH}"
    end
  end
end
