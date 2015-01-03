module SQLKnit
  module SQL
    class Join

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

      def on table_name_or_text = nil, &block
        if table_name_or_text.is_a? Symbol
          @on_table_name = table_name_or_text
        elsif table_name_or_text.to_s.include? "="
          text = table_name_or_text
        else
          @on_table_name = table_name_or_text
        end

        on_condition = OnCondition.new join_table_name, on_table_name, text
        on_conditions << on_condition
        instance_eval &block if block_given?
      end

      def text str
      end

      def to_statement
        if on_conditions.size == 0
          on_conditions << OnCondition.new(join_table_name, head_table_name)
        end
        statement = on_conditions.map(&:to_statement).join("\n")
        
        [type, statement].join(" ")
      end

      
    end
  end
end
