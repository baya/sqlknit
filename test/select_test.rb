require 'test_helper'

class SelectStatementTest < MiniTest::Test

  def setup
    @needle = SQLKnit::Needle.new
  end

  def test_select
    
    @needle.sql_select do
      text "coalesce(addresses.address1, '') as shipto_address1"
      text "coalesce(addresses.address2, '') as shipto_address2"
      addresses city: 'shipto_city', zipcode: 'shipto_zip'
      states name: 'shipto_state', abbr: 'shipto_state_abbr'
      countries iso: 'shipto_country'
      orders email: 'shipto_email'
      addresses phone: 'shipto_phone'
      distributors id: 'distributor_id'
    end

    select_statement = "select coalesce(addresses.address1, '') as shipto_address1,
coalesce(addresses.address2, '') as shipto_address2,
addresses.city as shipto_city,
addresses.zipcode as shipto_zip,
states.name as shipto_state,
states.abbr as shipto_state_abbr,
countries.iso as shipto_country,
orders.email as shipto_email,
addresses.phone as shipto_phone,
distributors.id as distributor_id"
    
    assert_equal @needle.select_statement, select_statement
    
  end
  
end
