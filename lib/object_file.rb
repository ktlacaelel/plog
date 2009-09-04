module Plog

  class ObjectFile < File

    DEFAULT_VALUES = {
      :@total_hits => 0,
      :@total_time => 0,
      :@view_time => 0,
      :@db_time => 0,
      :@simplified_url => 'default'
    }

    KEY_ORDER = [
      :@total_hits,
      :@total_time,
      :@view_time,
      :@db_time,
      :@simplified_url
    ]

    attr_accessor :simplified_url
    attr_reader :view_time, :total_time, :db_time, :total_hits

    def initialize(*args)
      raw_data(args.first)
      super(*args)
      setup!
    end

    def setup!
      unpack_default_values if ObjectFile.zero? path
      load_changes!
    end

    def unpack_default_values
      DEFAULT_VALUES.each do |k, v|
        instance_variable_set k, v
      end
    end

    def append_view_time(value)
      @view_time += value.to_i
    end

    def append_db_time(value)
      @db_time += value.to_i
    end

    def append_total_time(value)
      @total_time += value
    end

    def append_hits(value)
      @total_hits += value
    end

    def save_changes!
      puts serialize_changes
    end

    def serialize_changes
      KEY_ORDER.collect { |key| instance_variable_get key }.join(',')
    end

    def load_changes!
      return if @raw_data == ''
      @total_hits, @total_time, @view_time, @db_time, @simplified_url = @raw_data.split(',')
      intify!
    end

    def intify!
      @total_hits = @total_hits.to_i
      @total_time = @total_time.to_i
      @db_time = @db_time.to_i
      @view_time = @view_time.to_i
    end

    def raw_data(some_string)
      if File.exist? some_string
        @raw_data = File.new(some_string).read
      else
        @raw_data = ''
      end
    end

    def export_settings
      [
        [@total_hits, [:left, 10]],
        [@total_time, [:left, 10]],
        [avg_total_time, [:left, 10]],
        [@db_time, [:left, 10]],
        [avg_db_time, [:left, 10]],
        [@view_time, [:left, 10]],
        [avg_view_time, [:left, 10]],
        [simplified_url, [:left, 40]],
      ]
    end

    def self.export_header_settings
      [
        ['Hits', [:left, 10]],
        ['Time', [:left, 10]],
        ['Avg-Time', [:left, 10]],
        ['DbTime', [:left, 10]],
        ['Avg-DB', [:left, 10]],
        ['View', [:left, 10]],
        ['Avg-View', [:left, 10]],
        ['Url', [:left, 40]],
      ]
    end

    def self.formated_headers
      export_header_settings.collect do |value, setting|
        if setting.first == :left
          value.to_s.ljust(setting[1])
        else
          value.to_s.rjust(setting[1])
        end
      end.join('') + "\n"
    end

    def export_headers
      export_header_settings.collect { |header| header.ljust(20) }.join('')
    end

    def export
      export_settings.collect do |value, setting|
        if setting.first == :left
          value.to_s.ljust(setting[1])
        else
          value.to_s.rjust(setting[1])
        end
      end.join('')
    end

    def avg_total_time
      return 0 if @total_time == 0
      (@total_time / @total_hits / 1000.0)
    end

    def avg_view_time
      return 0 if @view_time == 0
      (@view_time / @total_hits / 1000.0)
    end

    def avg_db_time
      return 0 if @db_time == 0
      (@db_time / @total_hits / 1000.0)
    end

  end

end
