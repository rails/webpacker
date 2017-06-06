require "rake"

module Webpacker::Compiler
  extend self

  def compile
    compile_task.invoke
    compile_task.reenable
  end

  private
    def compile_task
      @compile_task ||= load_rake_task("webpacker:compile")
    end

    def load_rake_task(name)
      load_rakefile unless Rake::Task.task_defined?(name)
      Rake::Task[name]
    end

    def load_rakefile
      @load_rakefile ||= Rake.load_rakefile(Rails.root.join("Rakefile"))
    end
end
