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
      @data = ''
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
      return if read == ''
      @total_hits, @total_time, @view_time, @db_time, @simplified_url = read.split(',')
    end

  end

end
