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
        state_events stateful_id: 'orders.id', name: 'payment'
      end
    end
    
  end
  
end
