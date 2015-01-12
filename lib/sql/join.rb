module SQLKnit
  module SQL
    class Join

      TableAbbrSymbol = ':'

      attr_reader :head_table_name, :join_table_name, :on_table_name
      attr_reader :type
      attr_reader :on_conditions
      attr_reader :statement_chains
      
      def initialize head_table_name, table_name, opts = {}
        @head_table_name = head_table_name
        @join_table_name = table_name
        @on_conditions = []
        @type = opts[:type] || 'join'
        @statement_chains = []
      end

      def on text = nil, &block

        if text.include? TableAbbrSymbol
          join_text = text.gsub(TableAbbrSymbol, join_table_name.to_s)
        else
          join_text = text
        end
        
        on_condition = OnCondition.new join_table_name
        on_condition.add_text join_text
        
        on_conditions << on_condition
        on_condition.instance_eval &block if block_given?
      end

      def to_statement
        statement = on_conditions.map(&:to_statement).join("\n")
        [type, statement].join(" ")
      end

    end
  end
end
