# SqlKnit

SqlKnit is a SQL builder.

## Example

### 001

```ruby
    @sql = SQLKnit::Builder.new
	
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

```

will outupt:

```sql
select shipments.number as shipment_number,
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
join linte_items on (line_items.order_id = orders.id)
join variants on (line_items.variant_id = variants.id)
join products on (variants.product_id = products.id)
join state_events on (state_events.stateful_id = orders.id and state_events.name = 'payment' and state_events.stateful_type = 'Order' and state_events.next_state in ('paid','credit_owed'))
where orders.state = 'complete' and orders.shipment_state = 'ready' and state_events.created_at >= '2012-10-01' and state_events.created_at <= '2015-03-08' and shipments.warehouse_id = 28
```
