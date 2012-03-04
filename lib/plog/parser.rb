module Plog

  class Parser

    class << Parser

      attr_reader :data

      def reset
      end

      def crunch data
        load_data data
      end

      def load_data(value)
        reset
        @data = value
        self
      end

      def is_candidate?
        raise 'You must implement a is_candidate? method in your tokenizer class'
      end

    end

  end

end

