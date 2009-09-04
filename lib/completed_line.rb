module Plog

  class CompletedLine

    TOTAL_TIME_REGEX = /^(Completed in )(\d+)ms/         # \2
    VIEW_TIME_REGEX = /([^\(]+)([^V]+)(View: )(\d+)(.*)/ # \4
    DB_TIME_REGEX = /([^\(]+)([^D]+)(DB: )(\d+)(.*)/     # \4
    URL_REGEX = /([^\[]+)(\[)([^\]]+)(.*)/
    STATUS_REGEX = /(\s)(\d+)(\s)(\w+)(\s)(\[)(.*)/      # \2, \4
    COMPLETED_TIME_REGEX = /^Completed/

    def self.url
      URL.new(@url)
    end

    def self.valid?
      completed_line?
    end

    def self.completed_line?
      return false unless @line.is_a? String
      return false unless COMPLETED_TIME_REGEX =~ @line
      return false unless DB_TIME_REGEX =~ @line
      return false if @line.size < 10
      true
    end

    def self.read!(string_line)
      @line = string_line
      validate
    end

    def self.db_time
      @db_time
    end

    def self.view_time
      @view_time
    end

    def self.total_time
      @total_time
    end

    def self.status_string
      @status_string
    end

    def self.status_number
      @status_number
    end

    def self.to_csv
      [total_time, view_time, db_time, url.simplify].join(',')
    end

    def self.merge(view, db)
      @view_time += view.to_i
      @db_time += db.to_i
      @total_time = (@view_time + @db_time)
    end

    protected

    def self.validate
      return unless completed_line?
      fragmentize!
      extract_time!
      extract_url!
    end

    def self.fragmentize!
      @first_fragment, @second_fragment = @line.split('|')
    end

    def self.extract_time!
      @total_time = extract_total_time
      @view_time = extract_view_time
      @db_time = extract_db_time
      @status_number, @status_string = extract_status_number_and_string
      nil
    end

    def self.extract_total_time
      return 0 unless TOTAL_TIME_REGEX =~ @first_fragment
      @first_fragment.gsub(TOTAL_TIME_REGEX, '\2').to_i
    end

    def self.extract_db_time
      return 0 unless DB_TIME_REGEX =~ @first_fragment
      @first_fragment.gsub(DB_TIME_REGEX, '\4').to_i
    end

    def self.extract_view_time
      return 0 unless VIEW_TIME_REGEX =~ @first_fragment
      @first_fragment.gsub(VIEW_TIME_REGEX, '\4').to_i
    end

    def self.extract_status_number_and_string
      return 0 unless STATUS_REGEX =~ @second_fragment
      @second_fragment.gsub(STATUS_REGEX, '\2,\4').split(',')
    end

    def self.extract_url!
      @url = @second_fragment.gsub(URL_REGEX, '\3')
    end

  end

end
