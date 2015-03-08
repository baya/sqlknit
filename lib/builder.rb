module SQLKnit
  
  class Builder

    def initialize
      @sql_select = SQL::Select.new
      @sql_from   = SQL::From.new
      @sql_where  = SQL::Where.new
      @sql_order  = SQL::Order.new
    end

    def select *args, &block
      @sql_select.contextlize args, &block
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

    def order *args, &block
      @sql_order.contextlize args, &block
      self
    end

    def select_statement
      @sql_select.to_statement
    end

    def from_statement
      @sql_from.to_s
    end

    def where_statement
      @sql_where.to_s
    end

    def order_statement
      @sql_order.to_statement
    end

    def to_s
      [select_statement,
       from_statement,
       where_statement,
       order_statement
      ].compact.delete_if(&:empty?).join("\n")
    end

  end
end

