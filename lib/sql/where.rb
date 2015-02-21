module SQLKnit
  module SQL
    class Where

      CONJ_WORDS = ['AND', 'OR']

      attr_reader :statement_chains
      attr_reader :op, :conjunction

      def initialize
        @statement_chains = []
        @conjunction = 'AND'
      end

      def cond op, &block
        @op = op
        instance_eval &block
      end

      def AND
        @conjunction = 'AND'
      end

      def OR
        @conjunction = 'OR'
      end

      def quote value
        "'#{value}'"
      end

      def double_quote value
        "\"#{value}\""
      end

      def text str
        if not statement_chains.include?(str) or CONJ_WORDS.include?(str)
          statement_chains << str 
        end
      end

      def to_statement
        if CONJ_WORDS.include? statement_chains.last
          chains = statement_chains[0..-2]
        else
          chains = statement_chains
        end
        ["where", chains.join("\n")].join(" ")
      end

      private

      def method_missing relation_name, *args
        create_method relation_name do |*args|
          col, mapper = args
          l_relation_col = build_relation_col relation_name, col
          
          if mapper.is_a? Hash
            relation_col = mapper.map {|k, v| build_relation_col k, v }.join
            text "#{l_relation_col} #{op} #{relation_col}"
          else
            if mapper.is_a? String
              text "#{l_relation_col} #{op} #{quote mapper}"
            else
              text "#{l_relation_col} #{op} #{mapper}"
            end
          end
          text conjunction
        end

        send relation_name, *args
      end

      def build_relation_col relation_name, col
        [double_quote(relation_name), double_quote(col)].join(".")
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end
      
    end
  end
end
