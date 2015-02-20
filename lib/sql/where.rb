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

      def pair k, v
        text [k, v].join(" #{op} ")
        text conjunction
      end

      def quote value
        "'#{value}'"
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
      
    end
  end
end
