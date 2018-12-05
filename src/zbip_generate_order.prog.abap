*&---------------------------------------------------------------------*
*& Report zbip_generate_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbip_generate_order.

DATA
    :ls_order TYPE zbip_orders
    ,lt_items TYPE STANDARD TABLE OF zbip_orders_i
    .

  ls_order-order_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
  ls_order-customer_name = 'Walkin Customer'.
  ls_order-order_id = 1.
  ls_order-currency_code = 'USD'.
  ls_order-total_amount = 0.
  ls_order-order_date = sy-datum.

  INSERT INTO zbip_orders VALUES ls_order.
*  order_id = ls_order-order_id
  lt_items = VALUE #(
    order_id = ls_order-order_id
    ( item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( )
      item_no = 1
      product_id = '0800277315C01EE8AAC0B965A3050465'
      qty = 1
      uom = 'ST' )
    ( item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( )
      item_no = 2
      product_id = '0800277315C01EE8AAC107FB19550469'
      qty = 2
      uom = 'ST' )
    ( item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( )
      item_no = 3
      product_id = '0800277315C01EE8AAC11B6A09F8846D'
      qty = 6
      uom = 'ST' )
    ).

  INSERT zbip_orders_i FROM TABLE lt_items.

*  INTO table zbip_orders fr lt_items.



* ls_product-product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
