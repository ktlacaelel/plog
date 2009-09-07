module Plog

  class Cli

    attr_reader :source_directory, :log_files

    LOG_FILE = 'statistics.txt'

    # ==========================================================================
    # CLIENT INTERFACE
    # ==========================================================================

    def initialize(source_directory, target_directory)
      @log_files = []
      @source_directory = source_directory
      @target_directory = target_directory
      check_directory_consistency!
      preload_log_files!
    end

    def run!
      stdout count_of_logs_banner(@log_files.size)
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
        stdout parsing_log_file_banner(log_file.name)
        log_file.parse_completed_lines!
      end
    end

    def parse_object_files
      Dir.glob(object_file_pattern).each do |object_file|
        file = File.new(statistic_file_path, 'a+')
        file.puts trim(ObjectFile.new(object_file).export)
        file.close
      end
    end

    def object_file_pattern
      File.join(@target_directory, 'objects') + '/*'
    end

    def statistic_file_path
      File.join(@target_directory, LOG_FILE)
    end

    def destroy_old_log_file
      FileUtils.touch statistic_file_path
      FileUtils.rm statistic_file_path
    end

    def append_headers_to_log_file
      file = File.new(statistic_file_path, 'a+')
      file.puts trim(ObjectFile.formated_headers)
      file.close
    end

    def check_directory_consistency!
      abort directory_not_found_banner unless File.exist? @source_directory
    end

    def preload_log_files!
      Dir.glob(File.join(@source_directory, '*.log')).each do |log_file|
        puts @target_directory
        @log_files << LogFile.new(log_file, @target_directory)
        stdout loading_log_file_banner(log_file)
      end
    end

    def stdout(string)
      puts ' ---> ' + string
    end

    # ==========================================================================
    # BANNERS
    # ==========================================================================

    def notice_banner
      'Parsing logs...
      This may take a long-while, go get yourself a coffee!
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
      'No such dir: %s' % @source_directory
    end

  end

end
