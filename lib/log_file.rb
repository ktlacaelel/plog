module Plog

  class LogFile < File

    attr_accessor :name

    def initialize(file, dump_dir)
      @dump_dir = dump_dir
      check_dump_dir_consistency!
      super(file, 'r')
      @name = file
    end

    def check_dump_dir_consistency!
      unless File.exist? objects_recipient_path
        FileUtils.mkdir_p objects_recipient_path
      end
    end

    def validate(file)
      abort 'File not found: ' + file.inspect unless File.exist? file
    end

    def parse_completed_lines!
      each_line do |line|
        CompletedLine.read! line
        parse_completed_line if CompletedLine.valid?
      end
    end

    def parse_completed_line
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
      File.join(objects_recipient_path, CompletedLine.url.hashify)
    end

    def objects_recipient_path
      @objects_recipient_path ||= File.join(@dump_dir, 'objects')
    end

  end

end
