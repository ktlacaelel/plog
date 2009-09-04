module Plog

  class Cli

    attr_reader :directory, :log_files

    LOG_FILE = 'log_statistics.txt'

    # ==========================================================================
    # CLIENT INTERFACE
    # ==========================================================================

    def initialize(directory)
      @directory = directory
      @log_files = []
      validate!
      load_log_files!
    end

    def run!
      stdout count_of_logs_banner @log_files.size
      stdout notice_banner
      create_object_files
      destroy_old_log_file
      append_headers_to_log_file
      parse_object_files
    end

    # ==========================================================================
    # INTERNAL INTERFACE
    # ==========================================================================

    protected

    def trim(string)
      return '' unless string.is_a? String
      string.gsub(/^\s+/, '').gsub(/\s+$/, '')
    end

    def create_object_files
      @log_files.each do |log_file|
        stdout parsing_log_file_banner log_file.name
        log_file.parse_completed_lines!
      end
    end

    def parse_object_files
      Dir.glob('objects/*').each do |object_file|
        file = File.new(LOG_FILE, 'a+')
        file.puts trim(ObjectFile.new(object_file).export)
        file.close
      end
    end

    def destroy_old_log_file
      FileUtils.touch LOG_FILE
      FileUtils.rm LOG_FILE
    end

    def append_headers_to_log_file
      file = File.new(LOG_FILE, 'a+')
      file.puts trim(ObjectFile.formated_headers)
      file.close
    end

    def validate!
      abort directory_not_found_banner unless File.exist? @directory
    end

    def load_log_files!
      Dir.glob(File.join(@directory, '*.log')).each do |log_file|
        @log_files << LogFile.new(log_file)
        stdout loading_log_file_banner log_file
      end
    end

    def stdout(string)
      puts ' ** ' + string
    end

    # ==========================================================================
    # BANNERS
    # ==========================================================================

    def notice_banner
      '
      NOTICE:

      Parsing logs, this may take a logn-while go get yourself a coffe!
      While I hanlde this stuff for you.
      '
    end

    def count_of_logs_banner(size)
      'Count of loaded logs : %s ' % size
    end

    def parsing_log_file_banner(file)
      'Parsing log located at : %s ' % file
    end

    def loading_log_file_banner(file)
      'Initializing log file: %s' % file
    end

    def directory_not_found_banner
      'No such dir: %s' % @directory
    end

  end

end
