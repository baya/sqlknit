module SQLKnit
  module SQL
    class Select

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
        args.each {|col| text col }
      end
      
      def to_statement
        ["select", statement_chains.join(",\n")].join(" ")
      end

      private
      
      def method_missing relation_name, *args

        create_method relation_name do |*args|
          args.each {|arg|
            if arg.is_a? Hash
              arg.each {|col, as_col|
                relation_col = build_relation_col relation_name, col
                text "#{relation_col} as #{as_col}"
              }
            else
              relation_col = build_relation_col relation_name, arg
              text "#{relation_col} as #{arg}"
            end
          }
        end

        send relation_name, *args
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

      def double_quote value
        "\"#{value}\""
      end

      def build_relation_col relation_name, col
        [relation_name, col].join(".")
      end

    end
  end
end
