# -*- coding: utf-8 -*-
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

    # puts @sql.select_statement
  end

  def test_002
    
    @sql.select do
      text "to_char(current_month, 'yyyy-mm-01') period"
      t1 :distributor_id
      t4 :firstname, :lastname, :joint_firstname, :joint_lastname
      t5 name: 'country'
      text "case when t1.curr_pvq>=450 then 2 else 0 end star_points"
      text "case when t1.is_superstar is true then 2 else 0 end super_star_points"
      text "null order_number_1st_level"
      text "0 child_id_1st_level"
      text "0 pack_points_1"
      text "null order_number_2nd_level"
      text "0 child_id_2nd_level"
      text "0 pack_points"
    end

    @sql.from distributor_ge_450: 't1',
    distributors: 't2',
    users: 't3',
    addresses: 't4',
    countries: 't5'

    @sql.where do
      
      cond '>=' do
        pair 't1.current_month', quote('2015-02-01')
        pair 't3.entry_date', quote('2015-02-01')
      end

      cond '=' do
        pair 't1.distributor_id', 't2.id'
        pair 't2.user_id', 't3.id'
        pair 't3.sold_address_id', 't4.id'
        pair 't4.country_id', 't5.id'
      end
      
    end

    puts @sql.select_statement

    puts @sql.from_statement

    puts @sql.where_statement
  end
  
end
