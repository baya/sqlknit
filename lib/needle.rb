module SQLKnit
  
  class Needle

    def initialize
      @sql_select = SQL::Select.new
      @sql_from   = SQL::From.new
    end

    def sql_select &block
      @sql_select.instance_eval &block
    end

    def sql_from table_name, &block
      @sql_from.instance_eval &block
    end

    def select_statement
      @sql_select.to_statement
    end

  end
end

