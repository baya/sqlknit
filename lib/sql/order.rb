module SQLKnit
  module SQL
    class Order

      ORDER_WORDS = ['ASC', 'DESC']

      attr_reader :statement_chains

      def initialize
        @statement_chains = []
      end

      def contextlize args, &block
        parse_args args
        instance_eval &block if block_given?
      end

      def parse_args args
        args.each {|col| text col }
      end

      def method_missing relation_name, *args
        create_method relation_name do |*args|
          order_word = args.last.upcase
          if ORDER_WORDS.include? order_word
            args[0..-2].each {|col|
              text "#{build_relation_col(relation_name, col)} #{order_word}"
            }
          else
            order_word = 'ASC'
            args.each {|col|
              text "#{build_relation_col(relation_name, col)} #{order_word}"
            }
          end
        end

        send relation_name, *args
      end

      def to_statement
        if statement_chains.length > 0
          ["order by", statement_chains.join(",")].join(" ")
        end
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

      def build_relation_col relation_name, col
        [double_quote(relation_name), double_quote(col)].join(".")
      end

      def text str, *args
        statement = str
        args.each {|arg|
          statement = statement.sub(/\?/, arg.to_s)
        }
        statement_chains << statement if not statement_chains.include? statement
      end

      def double_quote value
        "\"#{value}\""
      end

    end
  end
end
