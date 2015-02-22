module SQLKnit
  module SQL
    
    class From

      attr_reader :statement_chains
      
      def initialize
        @statement_chains = []
      end

      def contextlize args, &block
        parse_args args
        instance_eval &block if block_given?
      end

      def text str, *args
        statement = str
        args.each {|arg|
          statement = statement.sub(/\?/, arg.to_s)
        }
        statement_chains << statement if not statement_chains.include? statement
      end

      def parse_args args
        args.each {|relation_name|
          if relation_name.is_a? Hash
            parse_alias_relation relation_name
          else
            text relation_name
          end
        }
      end

      def parse_alias_relation relation_name
        relation_name.each {|k, v| text [k, v].join(' ') }
      end

      def left_join &block
        join = Join.new type: 'left'
        join.instance_eval &block if block_given?
        text join.to_statement
      end
      
      def to_statement
        ["from", statement_chains.join(",\n")].join(" ")
      end

    end
  end
end
