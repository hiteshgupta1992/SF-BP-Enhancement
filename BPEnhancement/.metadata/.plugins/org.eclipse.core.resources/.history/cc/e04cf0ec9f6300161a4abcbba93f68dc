public with sharing class PartOverviewCtrl_Kendo {

  public String partPN {get;set;}
  public String PartId{get;set;}
  
  public PartOverviewCtrl_Kendo()
  {
    partPN = ApexPages.currentPage().getParameters().get('partpageno');
    partPN = String.escapeSingleQuotes(partPN);
    
    PartId = ApexPages.currentPage().getParameters().get('Part_ID');
    PartId = String.escapeSingleQuotes(PartId);
  }

}