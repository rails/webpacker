tasks = {
  'webpacker:install' => 'Installs and setup webpack with yarn',
  'webpacker:compile' => 'Compiles webpack bundles based on environment',
  'webpacker:install:react' => 'Installs and setup example react component',
  'webpacker:install:vue' => 'Installs and setup example vue component',
  'webpacker:install:angular' => 'Installs and setup example angular2 component'
}.freeze

desc 'Lists available tasks under webpacker'
task :webpacker do
  puts 'Available webpacker tasks are:'
  tasks.each { |task, message| puts task.ljust(30) + message }
end
