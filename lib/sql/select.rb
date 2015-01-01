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
        "select #{statement_chains.join(",\n")}"
      end

      private
      
      def method_missing table_name, as_mapper

        create_method table_name do |as_mapper|
          as_mapper.each {|col, as_col|  text "#{table_name}.#{col} as #{as_col}"}
        end

        send table_name, as_mapper
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

    end
  end
end
