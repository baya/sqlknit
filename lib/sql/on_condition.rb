class OnCondition

  attr_reader :join_table_name, :on_table_name, :texts, :current_logic_op

  def initialize join_table_name, on_table_name = nil
    @join_table_name = join_table_name
    @on_table_name   = on_table_name
    @texts = []
    @curent_logic_op = 'and'
    add_default_relation_text
  end

  def add_default_relation_text
    add_text default_relation_text if default_relation_text
  end

  def text str
    add_text str
  end

  def add_text text
    if not texts.include? text
      if texts.size > 0
        texts << [current_logic_op, text].join(" ")
      else
        texts << text 
      end
    end
  end

  def to_statement
    statement = texts.join(" ")
    [join_table_name, "on", statement].join(" ")
  end

  def default_relation_text
    if on_table_name
      foreign_key = get_foreign_key on_table_name
      "#{join_table_name}.#{foreign_key} = #{on_table_name}.id"
    end
  end

  private

  def sql_and
    @current_logic_op = 'and'
  end

  def sql_or
    @current_logic_op = 'or'
  end

  def get_foreign_key table_name
    "#{table_name.to_s.singularize}_id"
  end

  def method_missing table_name, values_mapper
    create_method table_name do |values_mapper|
      statement = values_mapper.map {|col, value|
        if value.is_a? Array or value.is_a? Range
          range = value.map {|v| quote v}.join(',')
          "#{table_name}.#{col} in (#{range})"
        else
          "#{table_name}.#{col} = #{quote(value)}"
        end
      }.join(" and ")
      
      text statement
    end
    
   send table_name, values_mapper
  end

  def quote value
    if value.is_a? String
      ["'", value, "'"].join
    else
      value
    end
  end

  def create_method name, &block
    self.class.send :define_method, name, &block
  end
  
end
