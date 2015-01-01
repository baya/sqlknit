require 'test_helper'

class FromStatementTest < Test::Unit::TestCase

  def setup
    @needle = SQLKnit::Needle.new
  end

  def test_from
    
    @needle.sql_from :orders do
      join(:line_items).on(:orders)
      join(:variants).on(:line_items)
      join(:products).on(:variants)
      join(:products_taxons).on(:products)
      join(:state_events).on do
        text "state_events.stateful_id = orders.id"
        and
        state_events name: 'payment',  stateful_type: 'Order', next_state: ['paid', 'credit_owed']
      end
      left_join(:shipments).on(:orders)
      left_join(:warehouses).on(:shipments)
      left_join(:users).on(:orders)
      left_join(:addresses, as: 'sold_address').on(:users)
      left_join(:distributors).on(:users)
      left_join(:addresses).on('orders.ship_address_id = addresses.id')
      left_join(:address_addons).on(:addresses)
      left_join(:states).on(:addresses)
      left_join(:countries).on(:addresses)
      left_join(:currencies).on(:orders)
      left_join(:adjustments, as: 'shipping_adjustments').on do
        shipping_adjustments label: 'Shipping', source_type: 'Shipment'
        text "orders.id = :.order_id"
        text ":.source_id = shipments.id"
      end
      left_join(:adjustments, as: 'gst_adjustments').on do
        gst_adjustments label: 'gst', source_type: 'Order'
        text "orders.id = :.order_id"
        text ":.source_id = orders.id"
      end
      left_join(:adjustments, as: 'gst_shipping_adjustments').on do
        gst_shipping_adjustments label: 'gst_shipping', source_type: 'Order'
        text "orders.id = :.order_id"
        text ":.source_id = orders.id"
      end
    end

    puts @needle.from_statement
    
  end
  
end
