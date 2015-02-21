module SQLKnit
  module SQL
    class Order

      ORDER_WORDS = ['ASC', 'DESC']

      attr_reader :statement_chains

      def initialize
        @statement_chains = []
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
        ["order by", statement_chains.join(",")].join(" ")
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

      def build_relation_col relation_name, col
        [double_quote(relation_name), double_quote(col)].join(".")
      end

      def text str
        statement_chains << str if not statement_chains.include? str
      end

      def double_quote value
        "\"#{value}\""
      end

    end
  end
end
