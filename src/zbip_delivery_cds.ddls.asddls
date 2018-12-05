@AbapCatalog.sqlViewName: 'ZBIP_DELIVERY_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZBIP_DELIVERY'
define view ZBIP_DELIVERY_CDS
  as select from zbip_delivery
{
  *
} 
 