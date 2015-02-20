module SQLKnit
  
  class Builder

    def initialize
      @sql_select = SQL::Select.new
      @sql_from   = SQL::From.new
      @sql_where  = SQL::Where.new
    end

    def select &block
      @sql_select.instance_eval &block if block_given?
      self
    end

    def from *args, &block
      @sql_from.contextlize args, &block
      self
    end

    def where &block
      @sql_where.instance_eval &block if block_given?
      self
    end

    def select_statement
      @sql_select.to_statement
    end

    def from_statement
      @sql_from.to_statement
    end

    def where_statement
      @sql_where.to_statement
    end

  end
end

