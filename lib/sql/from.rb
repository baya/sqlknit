module SQLKnit
  module SQL
    class From

      attr_reader :statement_chains
      attr_reader :current_join_type
      
      def initialize
        @statement_chains = []
      end

      def contextlize args, &block
        parse_args args
        instance_eval &block if block_given?
      end

      def text str
        statement_chains << str if not statement_chains.include? str
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
      
      def join table_name
        opts = {type: current_join_type}
        join = SQL::Join.new(current_table_name, table_name, opts)
        current_chain << join
        join
      end

      alias_method :join_chain, :join

      def join *table_names
        
        if table_names.size > 1
          table_name_paires = pairelize_table_names table_names
          table_name_paires.unshift [current_table_name, table_names.first]
          table_name_paires.each {|paire|
            on_table_name, join_table_name = paire
            join_chain(join_table_name).on(on_table_name)
          }
        else
          join_chain(table_names.first)
        end

        current_chain.last
      end

      def left_join *table_names
        switch_join_type 'left join'
        join table_names
      end

      def to_statement
        ["from", statement_chains.join(",\n")].join(" ")
      end

    end
  end
end
