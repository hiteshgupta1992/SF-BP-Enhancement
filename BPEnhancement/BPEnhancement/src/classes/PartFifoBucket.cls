public with sharing class PartFifoBucket {

	public String FIFOBucketId;
	public String UniqueId;
	public String SourceName;
	public String PartId;
	public String PartName;
	public Decimal QtyIn;
	public Decimal QtyOut;
	public Decimal RemainingQty;
	public Decimal Cost;
	public Decimal Total;
	public String Type;
	public String Reference;
	public String CreatedDate;
	public boolean IsFiFoBucket;
	public String vendorInvoicingVendorName;
	public String VendorRecievingVendorName;
	public List<PartFIFOActivityLineItem> PartFIFOActivityLineItemList;
	
	public PartFifoBucket(Part_FIFO_Bucket__c partFifoBucketRec){
		this.FIFOBucketId =  partFifoBucketRec.Id;
		this.SourceName = partFifoBucketRec.Source_Name__c;
		this.PartId = partFifoBucketRec.Part__c;
		this.PartName = (partFifoBucketRec.Part__c != null) ? partFifoBucketRec.Part__r.Part_Number__c : null;
		this.QtyIn = partFifoBucketRec.Qty_In__c;
		this.QtyOut = partFifoBucketRec.Qty_Out__c;
		this.RemainingQty = (partFifoBucketRec.Remaining_Qty__c != null ) ? partFifoBucketRec.Remaining_Qty__c : 0;
		this.Cost = partFifoBucketRec.Cost__c;
		this.Total = partFifoBucketRec.Total__c;
		this.Type = partFifoBucketRec.Type__c;
		this.CreatedDate = partFifoBucketRec.CreatedDate!= null ? partFifoBucketRec.CreatedDate.format('MMM dd, yyyy') : System.now().format('MMM dd, yyyy') ;
		this.PartFIFOActivityLineItemList = new List<PartFIFOActivityLineItem>();
		if(partFifoBucketRec.Vendor_Invoicing_Header__c!= null){
			this.UniqueId =  partFifoBucketRec.Vendor_Invoicing_Header__c!= null?partFifoBucketRec.Vendor_Invoicing_Header__r.Name : null;
			this.Reference =  partFifoBucketRec.Vendor_Invoicing_Header__c!= null?(partFifoBucketRec.Vendor_Invoicing_Header__r.Vendor__c!= null? partFifoBucketRec.Vendor_Invoicing_Header__r.Vendor__r.Name : null ): null;
		}else if(partFifoBucketRec.Vendor_Receiving_Header__c != null){
			this.UniqueId =  partFifoBucketRec.Vendor_Receiving_Header__c!= null?partFifoBucketRec.Vendor_Receiving_Header__r.Packing_Slip_Number__c : null;
			this.Reference = partFifoBucketRec.Vendor_Receiving_Header__c!= null?(partFifoBucketRec.Vendor_Receiving_Header__r.Vendor__c!= null? partFifoBucketRec.Vendor_Receiving_Header__r.Vendor__r.Name : null ): null;
		}else if(partFifoBucketRec.Customer_Return__c != null){
			this.UniqueId =  (partFifoBucketRec.Customer_Return__c != null) ? partFifoBucketRec.Customer_Return__r.Name : null;
			this.Reference =   (partFifoBucketRec.Customer_Return__c != null) ? (partFifoBucketRec.Customer_Return__r.CO_Header__c!= null? partFifoBucketRec.Customer_Return__r.CO_Header__r.Customer__r.Name: null ): null;
		}else if(partFifoBucketRec.Source_Name__c.equalsIgnoreCase('Cost Adjust') || partFifoBucketRec.Source_Name__c.equalsIgnoreCase('Oversold') || partFifoBucketRec.Source_Name__c.equalsIgnoreCase('Count Adjust') || partFifoBucketRec.Source_Name__c.equalsIgnoreCase('Stock Count') ){
			this.UniqueId = partFifoBucketRec.Unique_Id__c;
			this.Reference = partFifoBucketRec.Reference__c;
		}else{
			this.UniqueId = 'Add Part';
			this.Reference = 'Stock Adjustment';
		}
		for(Part_FIFO_Bucket_Activity_Line_Item__c partFIFOActivityRec : partFifoBucketRec.Part_FIFO_Bucket_Activity_Line_Items__r){
			this.PartFIFOActivityLineItemList.add(new PartFifoActivityLineItem(partFIFOActivityRec));
		}
		this.IsFiFoBucket = partFifoBucketRec.Is_FIFO_Bucket__c;
	}
	
	public PartFifoBucket(){
		
	}

	public class PartFIFOActivityLineItem{
		public String PartFIFOBucketId;
		public String COLineItemId;
		public Decimal QtyOut;
		public String Type;
		public String Reference;
		public String CreatedDate;
		public String PartAdjustment;
		public String UniqueId;
		public PartFIFOActivityLineItem(Part_FIFO_Bucket_Activity_Line_Item__c partFifoActivityLineItemRec){
			this.PartFIFOBucketId = partFifoActivityLineItemRec.Part_FIFO_Bucket__c;
			this.COLineItemId = partFifoActivityLineItemRec.CO_Line_Item__c;
			this.QtyOut = partFifoActivityLineItemRec.Qty_Out__c;
			if(partFifoActivityLineItemRec.Part_Adjustment__c != null){
				this.Reference = partFifoActivityLineItemRec.Reference__c;
				this.UniqueId = (partFifoActivityLineItemRec.Part_Adjustment__c != null) ? partFifoActivityLineItemRec.Part_Adjustment__r.Unique_Id__c :  null;
			} else if(partFifoActivityLineItemRec.CO_Invoice_Header__c != null) {
				this.UniqueId = (partFifoActivityLineItemRec.CO_Invoice_Header__c != null) ? partFifoActivityLineItemRec.CO_Invoice_Header__r.Invoice_Number__c : null;
				this.Reference = (partFifoActivityLineItemRec.CO_Invoice_Header__c != null) ? (partFifoActivityLineItemRec.CO_Invoice_Header__r.CO_Header__c!= null? partFifoActivityLineItemRec.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name: null ): null;
			}
			
			this.Type = partFifoActivityLineItemRec.Type__c;
			this.CreatedDate = partFifoActivityLineItemRec.CreatedDate!= null ? partFifoActivityLineItemRec.CreatedDate.format('MMM dd, yyyy') : System.now().format('MMM dd, yyyy') ;
		}
	}
	
	
	public static List<String> getPartFIFOBucketList(){
        List<String> partFIFOBucketFields = new List<String>{ 	'Id',
			                                                    'Source_Name__c',
			                                                    'Qty_In__c',
			                                                    'Qty_Out__c',
			                                                    'Remaining_Qty__c',
			                                                    'Cost__c',
			                                                    'Total__c',
			                                                    'Name',
			                                                    'Reference__c',
			                                                    'Type__c',
			                                                    'Part__r.Part_Number__c',
			                                                    'CreatedDate',
			                                                    'Part__c',
			                                                    'Vendor_Invoicing_Header__r.Vendor__r.Name',
			                                                    'Vendor_Invoicing_Header__r.Name',
			                                                    'Vendor_Receiving_Header__r.Vendor__r.Name',
			                                                    'Vendor_Receiving_Header__r.Name',
			                                                    'Vendor_Receiving_Header__r.Packing_Slip_Number__c',
			                                                    'Customer_Return__r.Name',
			                                                    'Customer_Return__r.CO_Header__r.Customer__r.Name',
			                                                    'Is_FIFO_Bucket__c',
			                                                    'Unique_Id__c'
			                                                };   
        return partFIFOBucketFields;
    }
    
    public static List<String> getPartFIFOBucketLineItemList(){
        List<String> partFIFOBucketLineItemFields = new List<String>{ 	'Id',
					                                                    'Part_FIFO_Bucket__c',
					                                                    'CO_Line_Item__c',
					                                                    'Qty_Out__c',
					                                                    'Name',
					                                                    'Reference__c',
					                                                    'CreatedDate ',
					                                                    'Type__c',
					                                                    'CO_Line_Item__r.Name',
					                                                    'CO_Line_Item__r.CO_Header__r.Customer__r.Name',
					                                                    'Part_Adjustment__c',
					                                                    'Part_Adjustment__r.Source_Name__c',
					                                                    'Part_Adjustment__r.Unique_Id__c',
					                                                    'Unique_Id__c',
					                                                    'CO_Invoice_Header__r.Name',
					                                                    'CO_Invoice_Header__r.Invoice_Number__c',
					                                                    'CO_Invoice_Header__r.CO_Header__r.Customer__r.Name'
					                                                };  
        return partFIFOBucketLineItemFields;
    }  
}