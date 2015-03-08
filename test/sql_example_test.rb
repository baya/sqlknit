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

  # bundle exe ruby -Itest test/sql_example_test.rb -n test_002
  def test_002
    
    @sql.select do
      shipments number: 'shipment_number'
      variants :sku, :price, :weight, :height, :width, depth: 'length'
      products description: 'product_description'
      orders number: 'order_number'
    end
      
    @sql.from :orders do
      join :shipments, on: 'shipments.order_id = orders.id'
      join :linte_items, on: 'line_items.order_id = orders.id'
      join :variants, on: 'line_items.variant_id = variants.id'
      join :products, on: 'variants.product_id = products.id'
      join :state_events do
        state_events stateful_id: :'orders.id',
        name: 'payment',
        stateful_type: 'Order',
        next_state: %w(paid credit_owed)
      end
    end

    begin_date = '2012-10-01'
    end_date = '2015-03-08'
    warehouse_id = 28
    @sql.where do
      orders state: 'complete',
      shipment_state: 'ready'
      
      con '>=' do
        state_events created_at: begin_date
      end
      con '<=' do
        state_events created_at: end_date
      end
      
      shipments warehouse_id: warehouse_id
    end

    puts @sql
  end

end
