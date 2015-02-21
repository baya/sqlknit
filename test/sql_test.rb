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

    query_params = {lookup_distributor_id: 1000876}

    @sql.where do

       cond '>=' do
         t1 :current_month, "2015-02-01"
         t3 :entry_date, "2015-02-01"
       end

      cond '=' do
        t1 :distributor_id, t2: 'id'
        t2 :user_id, t3: 'id'
        t3 :sold_address_id, t4: 'id'
        t4 :country_id, t5: 'id'
        t1 :distributor_id, query_params[:lookup_distributor_id]
      end
      
    end

    @sql.order do
      t1 :distributor_id, 'desc'
      t2 :order_id, :customer_id
    end

    puts @sql.select_statement

    puts @sql.from_statement

    puts @sql.where_statement

    puts @sql.order_statement

    puts @sql
  end
  
end
