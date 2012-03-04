module Plog

  class RecordAbstraction

    class << RecordAbstraction

      def setup(table)
        @table = table
      end

      def migration_name
        "#{record_name}Migration"
      end

      def record_name
        "#{@table[:table_name].to_s.camelize}"
      end

      def record_class
        "
        class ::#{record_name} < ActiveRecord::Base
          set_table_name :#{record_name.underscore}
        end
        "
      end

      def migration_class
        "
        class ::#{migration_name} < ActiveRecord::Migration
          def self.up
            create_table :#{@table[:table_name]} do |t|
              #{@table[:fields].map { |field, type| 't.' + type.to_s + ' :' + field.to_s } * "\n            " }
              t.timestamps
            end
          end
        end
        "
      end

      def record_constant
        eval(record_class)
        eval('::' + record_name)
      end

      def migration_constant
        eval(migration_class)
        eval('::' + migration_name)
      end

      def record_exists?
        ActiveRecord::Base.connection.execute('show tables').each do |record|
          return true if record.first == @table[:table_name].to_s
        end
        false
      end

    end

  end

end

