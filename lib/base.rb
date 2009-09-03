module Plog

  class Base

    attr_accessor :directories, :cli, :config

    def initialize(directories, cli, config)
      @directories = directories
      @cli = cli
      @config = config
    end

  end

end
