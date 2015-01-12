module SQLKnit
  
  class Needle

    def initialize
      @sql_select = SQL::Select.new
      @sql_from   = SQL::From.new
    end

    def select &block
      @sql_select.instance_eval &block
    end

    def from *table_names, &block
      table_names[0..-2].each {|table_name| @sql_from.add_table table_name }
      @sql_from.contextlize table_names.last, &block
    end

    def select_statement
      @sql_select.to_statement
    end

    def from_statement
      @sql_from.to_statement
    end  

  end
end

