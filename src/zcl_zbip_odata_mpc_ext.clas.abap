class ZCL_ZBIP_ODATA_MPC_EXT definition
  public
  inheriting from ZCL_ZBIP_ODATA_MPC
  create public .

public section.

  types:
    BEGIN OF ts_deep_entity.
        INCLUDE TYPE zbip_orders.
        TYPES:navorderitems TYPE STANDARD TABLE OF zbip_orders_i
                WITH DEFAULT KEY
          ,
        END OF ts_deep_entity .
PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_ZBIP_ODATA_MPC_EXT IMPLEMENTATION.
ENDCLASS.
