namespace :webpacker do
  desc "Support for older Rails versions. Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install do
    system "yarn install --no-progress"

    exit(1) unless $?.success?
  end
end

def enhance_yarn_install
  Rake::Task["yarn:install"].enhance do
    exit(1) unless $?.success?
  end
end

if Rake::Task.task_defined?("yarn:install")
  enhance_yarn_install
else
  # this is mainly for pre-5.x era
  Rake::Task.define_task("yarn:install" => "webpacker:yarn_install")
end
