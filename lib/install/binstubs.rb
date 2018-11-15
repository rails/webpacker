say "Copying binstubs"
directory "#{File.dirname(File.realpath(__FILE__))}/bin", "bin"

chmod "bin", 0755 & ~File.umask, verbose: false
