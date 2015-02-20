module SQLKnit
  module SQL
    class Select

      attr_reader :statement_chains
      
      def initialize
        @statement_chains = []
      end

      def text str
        statement_chains << str if not statement_chains.include? str
      end

      def to_statement
        ["select", statement_chains.join(",\n")].join(" ")
      end

      private
      
      def method_missing relation_name, *args

        create_method relation_name do |*args|
          as_mapper = args.last
          if as_mapper.is_a? Hash
            as_mapper.each {|col, as_col|  text "#{relation_name}.#{col} as #{as_col}"}
          else
            args.each {|col| text "#{relation_name}.#{col}"}
          end
        end

        send relation_name, *args
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

    end
  end
end
