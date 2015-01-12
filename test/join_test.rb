require 'test_helper'

class JoinStatementTest < MiniTest::Test

  def setup
    @needle = SQLKnit::Needle.new
  end

  def test_join_on_text
    @needle.from :orders do
      join(:line_items).on('line_items.order_id = orders.id')
    end
    statement = "from orders join line_items on line_items.order_id = orders.id"
    
    assert_equal @needle.from_statement, statement
  end

  def test_join_on_text_with_placeholder
    @needle.from :orders do
      join(:line_items).on(':.order_id = orders.id')
    end
    statement = "from orders join line_items on line_items.order_id = orders.id"
    
    assert_equal @needle.from_statement, statement
  end


#   def test_from_single_table_without_join
#     @needle.sql_from :orders do
#       join(:line_items).on :orders if false
#     end
#     statement = "from orders"

#     assert_equal @needle.from_statement, statement
#   end

#   def test_from_single_table_join_mult_tables
#     @needle.sql_from :orders do
#       join(:line_items).on :orders
#     end

#     @needle.sql_from :orders do
#       join(:variants).on :line_items
#     end

#     @needle.sql_from :orders do
#       join(:products).on :variants
#     end

#     statement = "from orders join line_items on line_items.order_id = orders.id
# join variants on variants.line_item_id = line_items.id
# join products on products.variant_id = variants.id"
    
#     assert_equal @needle.from_statement, statement
    
#   end

#   def test_from_single_table_join_mult_tables_at_once
#     @needle.sql_from :orders do
#       join(:line_items).on :orders
#       join(:variants).on :line_items
#       join(:products).on :variants
#       join(:products_taxons).on :products
#     end

#     statement = "from orders join line_items on line_items.order_id = orders.id
# join variants on variants.line_item_id = line_items.id
# join products on products.variant_id = variants.id
# join products_taxons on products_taxons.product_id = products.id"

#     assert_equal @needle.from_statement, statement
#   end

#   def test_from_mult_tables_without_join
#     @needle.sql_from :orders, :line_items
#     statement = "from orders,
# line_items"
    
#     assert_equal @needle.from_statement, statement
#   end

#   def test_from_mult_tables_join_single_table_at_once
#     @needle.sql_from :orders, :variants do
#       join(:line_items).on :variants
#     end

#     statement = "from orders,
# variants join line_items on line_items.variant_id = variants.id"
    
#     assert_equal @needle.from_statement, statement
#   end

#   def test_from_mult_tables_join_single_table_at_mult_time
#     @needle.sql_from :orders do
#       join(:lineitems).on :orders
#     end

#     @needle.sql_from :variants do
#       join(:products).on :variants
#     end

#     statement = "from orders join lineitems on lineitems.order_id = orders.id,
# variants join products on products.variant_id = variants.id"

#     assert_equal @needle.from_statement, statement
    
#   end

#   def test_from_single_table_join_single_table_chain
#     @needle.sql_from :orders do
#       join :products
#     end
#     statement = "from orders join products on products.order_id = orders.id"

#     assert_equal @needle.from_statement, statement
#   end

#   def test_from_single_table_join_mult_tables_chain
#     @needle.sql_from :orders do
#       join :line_items, :variants, :products, :products_taxons
#     end
#     statement = "from orders join line_items on line_items.order_id = orders.id
# join variants on variants.line_item_id = line_items.id
# join products on products.variant_id = variants.id
# join products_taxons on products_taxons.product_id = products.id"
    
#     assert_equal @needle.from_statement, statement
#   end

#   def test_join_single_table_on_text
#     @needle.sql_from :orders do
#       join(:line_items).on "line_items.order_id = orders.id"
#     end

#     statement = "from orders join line_items on line_items.order_id = orders.id"
#     assert_equal @needle.from_statement, statement
#   end

#   def test_join_single_table_on_text_in_a_block
#     @needle.sql_from :orders do
#       join(:line_items).on do
#         text "line_items.order_id = orders.id"
#       end
#     end

#     statement = "from orders join line_items on line_items.order_id = orders.id"

#     assert_equal @needle.from_statement, statement
#   end

#   def test_join_table_on_table_attributes
#     @needle.sql_from :orders do
#       join(:line_items).on :orders
#       join(:state_events).on do
#         text "state_events.stateful_id = orders.id"
#         sql_and
#         state_events name: 'payment', stateful_type: 'Order', next_state: ['paid', 'credit_owed']
#       end
#     end

#     statement = "from orders join line_items on line_items.order_id = orders.id
# join state_events on state_events.stateful_id = orders.id and state_events.name = 'payment' and state_events.stateful_type = 'Order' and state_events.next_state in ('paid','credit_owed')"

#     assert_equal @needle.from_statement, statement
    
#   end

#   def test_left_join
#     @needle.sql_from :orders do
#       left_join(:line_items).on :orders
#       left_join(:state_events).on do
#         text "state_events.stateful_id = orders.id"
#         sql_and
#         state_events name: 'payment', stateful_type: 'Order', next_state: ['paid', 'credit_owed']
#       end
#     end

#     statement = "from orders left join line_items on [:line_items].order_id = orders.id
# left join state_events on state_events.stateful_id = orders.id and state_events.name = 'payment' and state_events.stateful_type = 'Order' and state_events.next_state in ('paid','credit_owed')"

#     assert_equal @needle.from_statement, statement
#   end

  # def test_from
    
  #   @needle.sql_from :orders do
  #     join(:line_items).on(:orders)
  #     join(:variants).on(:line_items)
  #     join(:products).on(:variants)
  #     join(:products_taxons).on(:products)
  #     join(:state_events).on do
  #       text "state_events.stateful_id = orders.id"
  #       and
  #       state_events name: 'payment',  stateful_type: 'Order', next_state: ['paid', 'credit_owed']
  #     end
  #     left_join(:shipments).on(:orders)
  #     left_join(:warehouses).on(:shipments)
  #     left_join(:users).on(:orders)
  #     left_join(:addresses, as: 'sold_address').on(:users)
  #     left_join(:distributors).on(:users)
  #     left_join(:addresses).on('orders.ship_address_id = :.id')
  #     left_join(:address_addons).on(:addresses)
  #     left_join(:states).on(:addresses)
  #     left_join(:countries).on(:addresses)
  #     left_join(:currencies).on(:orders)
  #     left_join(:adjustments, as: 'shipping_adjustments').on do
  #       shipping_adjustments label: 'Shipping', source_type: 'Shipment'
  #       text "orders.id = :.order_id"
  #       text ":.source_id = shipments.id"
  #     end
  #     left_join(:adjustments, as: 'gst_adjustments').on do
  #       gst_adjustments label: 'gst', source_type: 'Order'
  #       text "orders.id = :.order_id"
  #       text ":.source_id = orders.id"
  #     end
  #     left_join(:adjustments, as: 'gst_shipping_adjustments').on do
  #       gst_shipping_adjustments label: 'gst_shipping', source_type: 'Order'
  #       text "orders.id = :.order_id"
  #       text ":.source_id = orders.id"
  #     end
  #   end

    # puts @needle.from_statement
    
  # end
  
end
