require 'guard'
require 'guard/guard'
require 'rrails/server'

module Guard
  class RemoteRails < Guard
    def initialize(watchers=[], options={})
      super
      @options = options
    end

    def start
      @pid = fork do
        RemoteRails::Server.new(@options).start
      end
      loop do
        break if Process.waitpid(@pid, Process::WNOHANG)
      end
    end

    def reload
      self.stop
      self.start
    end

    def run_on_change(paths_or_symbol)
      self.reload
    end

    def stop
      Process.kill(@pid)
      @pid = nil
    end
  end
end
