require 'test_helper'

class SqlTest < MiniTest::Test

  def setup
    @sql = SQLKnit::Builder.new
  end

  def test_001
    
    @sql.select do
      text "coalesce(addresses.address1, '') as shipto_address1"
      addresses city: 'shipto_city', zipcode: 'shipto_zip'
      orders :number, email: 'shipto_email'
      orders :user_id, :status
    end

    puts @sql.select.to_statement
  end
  
end
