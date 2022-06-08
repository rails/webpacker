namespace :webpacker do
  desc "Verifies if Webpacker is installed"
  task verify_install: [:verify_config, :check_node, :check_yarn, :check_binstubs]
end
