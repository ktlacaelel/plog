module Plog

  class LogFile < File

    DUMP_DIR = 'objects'

    attr_accessor :name

    def initialize(file)
      unless File.exist? DUMP_DIR
        Dir.mkdir DUMP_DIR
      end
      super(file, 'r')
      @name = file
    end

    def validate(file)
      abort 'File not found: ' + file.inspect unless File.exist? file
    end

    def parse_completed_lines!
      each_line do |line|
        CompletedLine.read! line
        parse_completed_line
      end
    end

    def parse_completed_line
      return unless CompletedLine.valid?
      of = ObjectFile.new(object_path, 'w+')
      of.simplified_url = CompletedLine.url.simplify
      of.append_total_time CompletedLine.total_time
      of.append_db_time CompletedLine.db_time
      of.append_view_time CompletedLine.view_time
      of.append_hits 1
      of.save_changes!
      of.close
    end

    def object_path
      File.join(DUMP_DIR, CompletedLine.url.hashify)
    end

  end

end
