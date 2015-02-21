module SQLKnit
  
  class Builder

    def initialize
      @sql_select = SQL::Select.new
      @sql_from   = SQL::From.new
      @sql_where  = SQL::Where.new
      @sql_order  = SQL::Order.new
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

    def order &block
      @sql_order.instance_eval &block if block_given?
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

    def order_statement
      @sql_order.to_statement
    end

    def to_s
      [select_statement,
       from_statement,
       where_statement,
       order_statement
      ].join("\n")
    end

  end
end

