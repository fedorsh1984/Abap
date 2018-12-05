*&---------------------------------------------------------------------*
*& Report zbip_generate_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbip_generate_products.

PARAMETERS:prname TYPE zbip_products-name,
           category TYPE zbip_products-category,
           price TYPE zbip_products-price,
           curr TYPE zbip_products-currency_code.

DATA
    :ls_product TYPE zbip_products
    .

 ls_product-product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
 ls_product-category = category.
 ls_product-price = price.
 ls_product-currency_code = curr.
 ls_product-price = price.
 ls_product-name = prname.

 INSERT INTO zbip_products VALUES ls_product.
