module Plog

  class Dir < Dir

    def log_files
      Dir.glob('*.log')
    end

  end

end
