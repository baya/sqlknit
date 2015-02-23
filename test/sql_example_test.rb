# -*- coding: utf-8 -*-
require 'test_helper'

class SqlExampleTest < MiniTest::Test

  def setup
    @sql = SQLKnit::Builder.new
  end

  # bundle exe ruby -Itest test/sql_example_test.rb -n test_001
  def test_001
    target_sql = "select *
from Production.Product
order by Name ASC"
    
    @sql.select('*').from('Production.Product').order('Name ASC')

    assert_equal @sql.to_s, target_sql
  end

end
