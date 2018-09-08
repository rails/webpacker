installers = {
  "Angular": :angular,
  "Elm": :elm,
  "React": :react,
  "Vue": :vue,
  "Erb": :erb,
  "Coffee": :coffee,
  "Typescript": :typescript,
  "Svelte": :svelte,
  "Stimulus": :stimulus
}.freeze

dependencies = {
  "Angular": [:typescript]
}

bin_path = ENV["BUNDLE_BIN"] || Rails.root.join("bin")

namespace :webpacker do
  namespace :install do
    installers.each do |name, task_name|
      desc "Install everything needed for #{name}"
      task task_name => ["webpacker:verify_install"] do |task|
        prefix = task.name.split(/#|webpacker:install/).first

        template = File.expand_path("../install/#{task_name}.rb", __dir__)
        base_path =
          if Rails::VERSION::MAJOR >= 5
            "#{RbConfig.ruby} #{bin_path}/rails #{prefix}app:template"
          else
            "#{RbConfig.ruby} #{bin_path}/rake #{prefix}rails:template"
          end

        dependencies[name] ||= []
        dependencies[name].each do |dependency|
          dependency_template = File.expand_path("../install/#{dependency}.rb", __dir__)
          system "#{base_path} LOCATION=#{dependency_template}"
        end

        exec "#{base_path} LOCATION=#{template}"
      end
    end
  end
end
