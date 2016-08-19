/**
 * Author: Tarun Khandelwal
 * Since: June 17, 2015
 * Name: PartDetailWrapper
 * Description: Apex class to handle JSON related oprations of Customer Detail Page.
**/
public with sharing class PartDetailWrapper {
	
	// Part Detail
	public PartDetail PartDetailRec;
	
	// Part related Info
	public PartRelatedLists PartRelatedInfo;
	
	// Total Number of Qty sold
	public String SoldLifeTime;
	
	// Total Dollar Value of Qty Sold
	public String RevenueLifeTime;
	
	// Time duration since the part was last sold
	public String LastSold;
	public Decimal TotalValuation;
	public Decimal AverageCost;
	public Decimal QtyInStock;
	public Decimal OversoldValuation;
	public Decimal OversoldQty;
	
	public Decimal TotalFIFORecords;
	public List<PartFifoBucket> PartFIFOBucketList;
	
	// Constructor   
    public PartDetailWrapper(Part__c partRec, List<String> calculatedValuesList, List<Part_FIFO_Bucket__c> partFIFOBucketRec, Integer totalFIFORecords) {
    	this.PartDetailRec = new PartDetail(partRec);
    	this.PartRelatedInfo = new PartRelatedLists(partRec.Id);
    	this.PartFIFOBucketList = new List<PartFifoBucket>();
    	this.TotalValuation = 0;
    	this.AverageCost = 0;
    	this.QtyInStock = 0;
    	this.OversoldValuation = 0;  
    	this.OversoldQty = 0;
    	this.TotalFIFORecords = totalFIFORecords;
    	
    	if(calculatedValuesList.size() == 3) {
    		this.SoldLifeTime = calculatedValuesList[0];
    		this.RevenueLifeTime = calculatedValuesList[1];
    		this.LastSold = calculatedValuesList[2];
    	}
    	for(Part_FIFO_Bucket__c partFIFOBucketItem  :  partFIFOBucketRec){
    		if(!String.isBlank(partFIFOBucketItem.Source_Name__c) && (partFIFOBucketItem.Source_Name__c.equalsIgnoreCase('Oversold') || partFIFOBucketItem.Remaining_Qty__c < 0)){
    			this.OversoldValuation += (partFIFOBucketItem.Total__c != null ) ? -(partFIFOBucketItem.Total__c) : 0;
    			this.OversoldQty += (partFIFOBucketItem.Remaining_Qty__c != null ) ? -(partFIFOBucketItem.Remaining_Qty__c) : 0;
    		} else {
    			this.TotalValuation  += (partFIFOBucketItem.Total__c != null ) ? partFIFOBucketItem.Total__c : 0;
    			this.QtyInStock += (partFIFOBucketItem.Remaining_Qty__c != null ) ? partFIFOBucketItem.Remaining_Qty__c : 0;
    		}
        	this.PartFIFOBucketList.add(new PartFifoBucket(partFIFOBucketItem) );
        }
        if(QtyInStock > 0) {
        	this.AverageCost = TotalValuation / QtyInStock;
        } else {
        	this.AverageCost = 0;
        }
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: PartDetailWrapper - Class Object
    **/
    public static PartDetailWrapper parse(String json) {
        return (PartDetailWrapper) System.JSON.deserialize(json, PartDetailWrapper.class);
    }
    
    // Wrapper class for part related info lists
    public class PartRelatedLists {
    	// List for Active Orders
    	public List<ActiveOrder> ActiveOrders;
    	
    	// Total count for Active Orders
    	public Integer TotalActiveOrders;
    	
    	// List for Active Sales Orders 
    	public List<ActiveSalesOrder> ActiveSalesOrders;
    	
    	// Total count for Active Sales Orders
    	public Integer TotalActiveSalesOrders;
    	
    	// List for Alternate Parts
    	public List<AlternatePart> AlternateParts;
    	
    	// Total count for Alternate Parts
    	public Integer TotalAlternateParts;
    	  
    	// List for Tax Exemptions
    	public List<TaxExemption> TaxExemptions;
    	
    	// Total count for Tax Exemptions
    	public Integer TotalTaxExemptions;
    	
    	// Constructor
    	public PartRelatedLists(Id partId) {
    		// Active Orders
    		List<ActiveOrder> allActiveOrders = activeorder.getAllActiveOrdersForPart(partId, System.JSON.serialize(new ActiveOrder.RelatedListPaginationSorting()) );
    		this.ActiveOrders = allActiveOrders;
    		this.TotalActiveOrders = ActiveOrder.getTotalActiveOrdersForPart(partId);
    		
    		// Active Sales Orders
    		List<ActiveSalesOrder> allActiveSalesOrders = ActiveSalesOrder.getAllActiveSalesOrdersForPart(partId, System.JSON.serialize(new ActiveSalesOrder.RelatedListPaginationSorting()) );
    		this.ActiveSalesOrders = allActiveSalesOrders;
    		this.TotalActiveSalesOrders = ActiveSalesOrder.getTotalActiveSalesOrdersForPart(partId);
    		
    		// Alternate Parts
    		List<AlternatePart> allParts = AlternatePart.getAllAlternatePartsForPart( partId, System.JSON.serialize(new AlternatePart.RelatedListPaginationSorting()) );
    		this.AlternateParts = allParts;
    		this.TotalAlternateParts = AlternatePart.getTotalAlternatePartsForPart(partId);
    		
    		// Tax Exemptions
    		this.TaxExemptions = new List<TaxExemption>();
    		this.TotalTaxExemptions = 0;
    		//List<TaxExemption> allTaxExemption = TaxExemption.getAllTaxExemptionsForPart( partId, System.JSON.serialize(new AlternatePart.RelatedListPaginationSorting()) );
    		//this.TaxExemptions = allTaxExemption;
    		//this.TotalTaxExemptions = TaxExemption.getTotalTaxExemptionsForPart(partId);
    	}
    }
}