module Plog

  class CompletedLine

    TIME_REGEX = /(Completed in )(\d+)ms........(\d+)......(\d+)(.*)/
    URL_REGEX = /([^\[]+)(\[)([^\]]+)(.*)/

    def self.url
      URL.new(@url)
    end

    def self.read!(string_line)
      @line = string_line
      validate
    end

    def self.db_time
      @db_time.to_i
    end

    def self.view_time
      @view_time.to_i
    end

    def self.total_time
      @total_time.to_i
    end

    protected

    def self.validate
      fragmentize!
      extract_time!
      extract_status_and_url!
    end

    def self.fragmentize!
      @first_fragment, @second_fragment = @line.split('|')
    end

    def self.extract_time!
      @total_time, @view_time, @db_time = extract_time
    end

    def self.extract_time
      @first_fragment.gsub(TIME_REGEX, '\2,\3,\4').split(',')
    end

    def self.extract_status_and_url!
      @url = @second_fragment.gsub(URL_REGEX, '\3')
    end

  end

end
