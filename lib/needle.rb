module SQLKnit
  
  class Needle

    def initialize
      @sql_select = SQL::Select.new
    end

    def sql_select &block
      @sql_select.instance_eval &block
    end

    def sql_from table_name, &block
    end

    def select_statement
      @sql_select.to_statement
    end

  end
end
