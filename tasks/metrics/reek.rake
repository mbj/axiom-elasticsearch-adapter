begin
  require 'reek/rake/task'

  unless defined?(Rubinius)
    Reek::Rake::Task.new
  else
    task :reek do
      $stderr.puts 'Reek fails under rubinius, fix rubinius and remove guard'
    end
  end
rescue LoadError
  task :reek do
    $stderr.puts 'Reek is not available. In order to run reek, you must: gem install reek'
  end
end
