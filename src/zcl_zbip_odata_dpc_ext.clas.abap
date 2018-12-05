CLASS zcl_zbip_odata_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zbip_odata_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~create_deep_entity
        REDEFINITION .
    METHODS /iwbep/if_mgw_core_srv_runtime~changeset_begin
        REDEFINITION .
    METHODS /iwbep/if_mgw_core_srv_runtime~changeset_end
        REDEFINITION .
  PROTECTED SECTION.

    METHODS customerset_get_entity
        REDEFINITION .
    METHODS customerset_get_entityset
        REDEFINITION .
    METHODS deliverydetailss_get_entity
        REDEFINITION .
    METHODS deliverydetailss_get_entityset
        REDEFINITION .
    METHODS orderitemsset_create_entity
        REDEFINITION .
    METHODS orderitemsset_delete_entity
        REDEFINITION .
    METHODS orderitemsset_get_entity
        REDEFINITION .
    METHODS orderitemsset_get_entityset
        REDEFINITION .
    METHODS orderitemsset_update_entity
        REDEFINITION .
    METHODS ordersset_create_entity
        REDEFINITION .
    METHODS ordersset_delete_entity
        REDEFINITION .
    METHODS ordersset_get_entity
        REDEFINITION .
    METHODS ordersset_get_entityset
        REDEFINITION .
    METHODS ordersset_update_entity
        REDEFINITION .
    METHODS productattachmen_create_entity
        REDEFINITION .
    METHODS productattachmen_get_entity
        REDEFINITION .
    METHODS productsset_create_entity
        REDEFINITION .
    METHODS productsset_delete_entity
        REDEFINITION .
    METHODS productsset_get_entity
        REDEFINITION .
    METHODS productsset_get_entityset
        REDEFINITION .
    METHODS productsset_update_entity
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zbip_odata_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA
          :ls_deep_entity   TYPE zcl_zbip_odata_mpc_ext=>ts_deep_entity
          ,ls_orders        TYPE zbip_orders
          ,lt_orders_i      TYPE STANDARD TABLE OF zbip_orders_i
            WITH DEFAULT KEY

          .


    io_data_provider->read_entry_data(
      IMPORTING
        es_data                      = ls_deep_entity
    ).
    ls_orders = CORRESPONDING #( ls_deep_entity ).
    ls_orders-order_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    INSERT INTO zbip_orders VALUES ls_orders.
    lt_orders_i = CORRESPONDING #( ls_deep_entity-navorderitems ).
    LOOP AT lt_orders_i ASSIGNING FIELD-SYMBOL(<fs_orders_i>).
      <fs_orders_i>-order_id = ls_orders-order_id.
      <fs_orders_i>-item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      <fs_orders_i>-item_no = sy-tabix.
    ENDLOOP.

    INSERT zbip_orders_i FROM TABLE lt_orders_i.
    ls_deep_entity-order_id = ls_orders-order_id.
    me->copy_data_to_ref(
      EXPORTING
        is_data = ls_deep_entity
      CHANGING
        cr_data = er_deep_entity
    ).


    BREAK-POINT.

*      CATCH /iwbep/cx_mgw_tech_exception.    "

**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IO_DATA_PROVIDER        =
**    it_key_tab              =
**    it_navigation_path      =
*    IO_EXPAND               =
**    io_tech_request_context =
**  IMPORTING
**    er_deep_entity          =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_core_srv_runtime~changeset_begin.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
*  EXPORTING
*    IT_OPERATION_INFO  =
**    it_changeset_input =
**  CHANGING
**    cv_defer_mode      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_core_srv_runtime~changeset_end.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD customerset_get_entity.


    READ TABLE io_tech_request_context->get_navigation_path( ) TRANSPORTING NO FIELDS
      WITH KEY nav_prop = 'TOORDERCUSTOMER'.
    IF sy-subrc = 0.
      READ TABLE io_tech_request_context->get_source_keys( )
        WITH KEY name = 'ORDER_ID' INTO DATA(ls_key).
      IF sy-subrc = 0.
        SELECT SINGLE *
          FROM snwd_bpa
          INTO @er_entity
          WHERE node_key IN (
            SELECT customer_name
              FROM zbip_orders
              WHERE order_id = @ls_key-value
          ).

      ENDIF.

    ENDIF.

**TRY.
*CALL METHOD SUPER->CUSTOMERSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD customerset_get_entityset.

    BREAK-POINT.
    READ TABLE io_tech_request_context->get_navigation_path( )
      WITH KEY nav_prop = '' TRANSPORTING NO FIELDS.


*     lt_nav_path = io_tech_request_context->get_navigation_path( ).
*
*   read table lt_nav_path into ls_nav_path with key nav_prop = SalesOrderItems'.
*
*   if sy-subrc = 0.
*
*     lt_key = io_tech_request_context->get_source_keys( )..
*
*     read table lt_key with key name = 'SoID' into ls_key.
*
*     lv_orderid = ls_key-value.
*
*" ditto for position key.....
*
*   endif.

**TRY.
*CALL METHOD SUPER->CUSTOMERSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD deliverydetailss_get_entity.

    READ TABLE io_tech_request_context->get_navigation_path( ) TRANSPORTING NO FIELDS
      WITH KEY nav_prop = 'TOORDERDELIVERY_2'.
    IF sy-subrc = 0.
      READ TABLE io_tech_request_context->get_source_keys( )
        WITH KEY name = 'ORDER_ID' INTO DATA(ls_key).
      IF sy-subrc = 0.
        SELECT SINGLE *
          FROM zbip_delivery
          INTO @er_entity
          WHERE order_id = @ls_key-value.
      ENDIF.

    ENDIF.

**TRY.
*CALL METHOD SUPER->DELIVERYDETAILSS_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD deliverydetailss_get_entityset.

    DATA(lv_order_id) = it_key_tab[ 1 ]-value.

    SELECT *
      FROM zbip_delivery
      INTO TABLE @et_entityset
      WHERE order_id = @lv_order_id.

**TRY.
*CALL METHOD SUPER->DELIVERYDETAILSS_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD orderitemsset_create_entity.

    DATA:ls_data    TYPE zcl_zbip_odata_mpc=>ts_orderitems
         ,ls_order_i TYPE zbip_orders_i.


    io_data_provider->read_entry_data(
      IMPORTING
        es_data                      = ls_data
    ).
    ls_order_i = CORRESPONDING #( ls_data ).
    ls_order_i-item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    INSERT INTO zbip_orders_i VALUES ls_order_i.

  ENDMETHOD.


  METHOD orderitemsset_delete_entity.


    DATA(lv_product_id) = it_key_tab[ 1 ]-value.
    DELETE FROM zbip_products
       WHERE product_id =  lv_product_id.

    DELETE FROM zbip_prodict_pic
       WHERE product_id =  lv_product_id.
**TRY.
*CALL METHOD SUPER->ORDERITEMSSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD orderitemsset_get_entity.
**TRY.
*CALL METHOD SUPER->ORDERITEMSSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD orderitemsset_get_entityset.

    DATA(lv_order_id) = it_key_tab[ 1 ]-value.

    SELECT *
      FROM zbip_orders_i
      INTO TABLE @et_entityset
      WHERE order_id = @lv_order_id.

  ENDMETHOD.


  METHOD orderitemsset_update_entity.
**TRY.
*CALL METHOD SUPER->ORDERITEMSSET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD ordersset_create_entity.

    DATA:ls_data  TYPE zcl_zbip_odata_mpc=>ts_orders
         ,ls_order TYPE zbip_orders.


    io_data_provider->read_entry_data(
      IMPORTING
        es_data                      = ls_data
    ).
    ls_order = CORRESPONDING #( ls_data ).
    ls_order-order_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    INSERT INTO zbip_orders VALUES ls_order.

**TRY.
*CALL METHOD SUPER->ORDERSSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD ordersset_delete_entity.
**TRY.
*CALL METHOD SUPER->ORDERSSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD ordersset_get_entity.

    ASSIGN it_key_tab[ 1 ] TO FIELD-SYMBOL(<fs_key_tab>).
    IF sy-subrc = 0.
      SELECT SINGLE *
        FROM zbip_orders
        WHERE order_id = @<fs_key_tab>-value
        INTO @er_entity.
    ENDIF.

  ENDMETHOD.


  METHOD ordersset_get_entityset.

    SELECT *
      FROM zbip_orders
      INTO TABLE et_entityset.

**TRY.
*CALL METHOD SUPER->ORDERSSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD ordersset_update_entity.
**TRY.
*CALL METHOD SUPER->ORDERSSET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD productattachmen_create_entity.

    DATA
        :ls_entity    TYPE zcl_zbip_odata_mpc=>ts_productattachment
        ,ls_product   TYPE zbip_prodict_pic
        .

    io_data_provider->read_entry_data(
      IMPORTING
        es_data                      = ls_entity
    ).

    ls_product = CORRESPONDING #( ls_entity ).

    MODIFY zbip_prodict_pic FROM ls_product.

    er_entity  = ls_product.

*      CATCH /iwbep/cx_mgw_tech_exception.    "

  ENDMETHOD.


  METHOD productattachmen_get_entity.
**TRY.
*CALL METHOD SUPER->PRODUCTATTACHMEN_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD productsset_create_entity.
**TRY.
*CALL METHOD SUPER->PRODUCTSSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD productsset_delete_entity.

    DATA(lv_product_id) = it_key_tab[ 1 ]-value.
    DELETE FROM zbip_products
       WHERE product_id =  lv_product_id.

    DELETE FROM zbip_prodict_pic
       WHERE product_id =  lv_product_id.

**TRY.
*CALL METHOD SUPER->PRODUCTSSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD productsset_get_entity.

    ASSIGN it_key_tab[ 1 ] TO FIELD-SYMBOL(<fs_key_tab>).
    IF sy-subrc = 0.
      SELECT SINGLE *
        FROM zbip_products
        WHERE product_id = @<fs_key_tab>-value
        INTO @er_entity.
    ENDIF.

  ENDMETHOD.


  METHOD productsset_get_entityset.


    DATA(lo_untility) = NEW cl_http_utility( ).
    SELECT *
      FROM zbip_products
      INTO TABLE et_entityset.
    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<fs_entityset>).
      SELECT SINGLE content FROM zbip_prodict_pic
        WHERE product_id = @<fs_entityset>-product_id
        INTO @DATA(lv_content).
      CHECK sy-subrc = 0.
      lv_content = lo_untility->decode_base64( encoded = lv_content ).
      CONCATENATE 'data:image/png;base64,' lv_content INTO <fs_entityset>-content.

    ENDLOOP.
  ENDMETHOD.


  METHOD productsset_update_entity.
**TRY.
*CALL METHOD SUPER->PRODUCTSSET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA
          :ls_product       TYPE zcl_zbip_odata_mpc_ext=>ts_products
          .
    io_data_provider->read_entry_data(
      IMPORTING
        es_data                      = ls_product
    ).
*      CATCH /iwbep/cx_mgw_tech_exception.    "
    MODIFY zbip_products FROM ls_product.

  ENDMETHOD.
ENDCLASS.
