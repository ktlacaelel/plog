module Plog

  class Scanner

    class << Scanner

      def load(io, config, &block)
        @config = config
        @config.each do |table|
          RecordAbstraction.setup(table)
          unless RecordAbstraction.record_exists?
            RecordAbstraction.migration_constant.up
          end
        end
        io.each_line { |line| yield(line, self) }
      end

      def record table_name
        constant(table_name).new
      end

      # TODO: optimize
      def constant table_name
        config = @config.find { |hash| hash[:table_name] == table_name }
        RecordAbstraction.setup(config)
        RecordAbstraction.record_constant
      end

    end

  end

end
