@AbapCatalog.sqlViewName: 'ZBIP_SNWD_BPA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'SNWD_BPA'
define view ZBIP_SNWD_BPA_CDS as select from snwd_bpa {
  *
} 
 