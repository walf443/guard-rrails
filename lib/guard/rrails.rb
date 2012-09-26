require 'guard'
require 'guard/guard'
require 'rrails/server'

module Guard
  class RemoteRails < Guard
    def initialize(watchers=[], options={ :rails_env => "development" })
      super
      @options = options
    end

    def start
      @pid = fork do
        $0 = "guard[rrails][#{@options[:rails_env]}]"
        ::RemoteRails::Server.new(@options).start
      end
    end

    def reload
      self.stop
      self.start
    end

    def run_on_changes(paths_or_symbol)
      self.reload
    end

    def stop
      Process.kill('HUP', @pid)
      @pid = nil
    end
  end

  Rrails = RemoteRails # for guard init.
end
