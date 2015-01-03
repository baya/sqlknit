class OnCondition

  attr_reader :join_table_name, :on_table_name, :text

  def initialize join_table_name, on_table_name, text = nil
    @join_table_name = join_table_name
    @on_table_name   = on_table_name
    @text = text
  end

  def to_statement
    "#{join_table_name} on #{text || default_relation_text}"
  end

  def default_relation_text
    @default_relation_text ||= \
    if on_table_name
      foreign_key = get_foreign_key on_table_name
      "#{join_table_name}.#{foreign_key} = #{on_table_name}.id"
    end
  end

  def get_foreign_key table_name
    "#{table_name.to_s.singularize}_id"
  end
  
end
