# -*- coding: utf-8 -*-
require 'test_helper'

# examples at https://msdn.microsoft.com/en-us/library/ms187731.aspx
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
    target_sql = "select shipments.number as shipment_number,
variants.sku as sku,
variants.price as price,
variants.weight as weight,
variants.height as height,
variants.width as width,
variants.depth as length,
products.description as product_description,
orders.number as order_number
from orders
join shipments on (shipments.order_id = orders.id)
join line_items on (line_items.order_id = orders.id)
join variants on (line_items.variant_id = variants.id)
join products on (variants.product_id = products.id)
join state_events on (state_events.stateful_id = orders.id and state_events.name = 'payment' and state_events.stateful_type = 'Order' and state_events.next_state in ('paid','credit_owed'))
where orders.state = 'complete' and orders.shipment_state = 'ready' and state_events.created_at >= '2012-10-01' and state_events.created_at <= '2015-03-08' and shipments.warehouse_id = 28"
    
    @sql.select do
      shipments number: 'shipment_number'
      variants :sku, :price, :weight, :height, :width, depth: 'length'
      products description: 'product_description'
      orders number: 'order_number'
    end
      
    @sql.from :orders do
      join :shipments, on: 'shipments.order_id = orders.id'
      join :line_items, on: 'line_items.order_id = orders.id'
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
      orders state: 'complete', shipment_state: 'ready'
      
      con '>=' do
        state_events created_at: begin_date
      end
      con '<=' do
        state_events created_at: end_date
      end
      
      shipments warehouse_id: warehouse_id
    end

    assert_equal @sql.to_s, target_sql
  end

  # bundle exe ruby -Itest test/sql_example_test.rb -n test_003
  def test_003

    target_sql = "select d.id as id,
d.taxnumber as taxnumber,
d.social_security_type as social_security_type,
d.taxnumber_exemption as taxnumber_exemption
from distributors d
left join distributor_addons da on (d.id = da.distributor_id)
where d.id = (11,12,13,14,15,16)
order by d.id"
    
    @sql.select do
      d :id, :taxnumber, :social_security_type, :taxnumber_exemption
    end

    @sql.from(distributors: 'd') do
      left_join distributor_addons: 'da', on: 'd.id = da.distributor_id'
    end

    dist_ids = [11,12,13,14,15,16]
    
    @sql.where do
      d id: dist_ids
    end

    @sql.order('d.id')

    assert_equal @sql.to_s, target_sql
  end

end
