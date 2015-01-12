module SQLKnit
  module SQL
    class From

      attr_reader :statement_chains, :current_chain, :current_table_name
      attr_reader :current_join_type
      
      def initialize
        @statement_chains = Hash.new {|hash, key| hash[key] = []}
      end

      def contextlize table_name, &block
        switch_to table_name
        instance_eval &block if block_given?
      end

      def text str
        statement_chains << str if not statement_chains.include? str
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

      def pairelize_table_names table_names
        last_index = table_names.length - 1
        (0..(last_index-1)).map {|i| table_names[i..i+1] }
      end

      def to_statement
        statement = statement_chains.map {|table_name, joins|
          if joins.size > 0
          "#{table_name} #{joins.map(&:to_statement).join("\n")}"
          else
            table_name.to_s
          end
        }.join(",\n")

        ["from", statement].join(" ")
      end

      def add_table table_name
        statement_chains[table_name] if not statement_chains.has_key? table_name
      end

      private

      def switch_join_type type
        @current_join_type = type
      end
      
      def switch_to table_name
        @current_table_name = table_name
        @current_chain = @statement_chains[table_name]
      end

    end
  end
end
