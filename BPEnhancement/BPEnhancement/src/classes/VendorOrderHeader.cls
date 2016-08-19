/**
 * Author: Tarun Khandelwal
 * Since: July 22, 2015
 * Name: VendorOrderHeader
 * Description: Apex class to handle JSON related oprations of VO Header object.
**/
public with sharing class VendorOrderHeader implements Comparable{
    public String VOName;
    
    public String VendorName;
    
    public String VendorId;
    
    public String OwnerId;
    
    public String OwnerName;
    
    public String Status;
    
    public OrderTypeWrapper OrderType;
    
    public String OrderedDate;
    
    public String ExpectedDate;
    
    public String ReceivedDate;
    
    public String CreatedDate;
    
    // Variables required in Vendor Order Receiving page
    public String InProgressVR;
    public String InProgressVRId;
    public decimal QtyUnreceived;
    public List<VendorOrderLineItemGroup> VOLIGroups;
    public String Id;
    
    public Decimal PercentRecieved;
    public Decimal QtyReceived;
    public Decimal QtyNeeded;
    
    // Constructor
    public VendorOrderHeader(Id voHeaderId) {
    	List<Vendor_Order_Header__c> voHeaders = SOQLUtil.getVendorOrderHeaderRecords('Id', voHeaderId, null, false);
		if(voHeaders.size() > 0){
			this.populateVendorOrder(voHeaders[0]);
		}
    }
    
    // Constructor
    public VendorOrderHeader(Vendor_Order_Header__c voHeader) {
		this.populateVendorOrder(voHeader);
    }
    
    private void populateVendorOrder(Vendor_Order_Header__c voHeader){
    	this.Id = voHeader.Id;
    	VOName = voHeader.Name;
		VendorName = voHeader.Vendor__r.Name;
		VendorId = voHeader.Vendor__c;
		OwnerName = voHeader.Owner.Name;
		OwnerId = voHeader.OwnerId;
		Status = voHeader.Status__c;
		OrderType = new OrderTypeWrapper(voHeader.Purchase_Order_Type__c, voHeader.Purchase_Order_Type__r.Code__c, voHeader.Purchase_Order_Type__r.Lead_Time__c);
		if(voHeader.Ordered_Date__c != null) {
			OrderedDate = (datetime.newInstance(voHeader.Ordered_Date__c.year(), voHeader.Ordered_Date__c.month(),voHeader.Ordered_Date__c.day())).format('MM/dd/YYYY');
		}
		if(voHeader.Expected_Date__c != null) {
			ExpectedDate = (datetime.newInstance(voHeader.Expected_Date__c.year(), voHeader.Expected_Date__c.month(),voHeader.Expected_Date__c.day())).format('MM/dd/YYYY');
		}
		if(voHeader.Received_Date__c != null) {
			ReceivedDate = (datetime.newInstance(voHeader.Received_Date__c.year(), voHeader.Received_Date__c.month(),voHeader.Received_Date__c.day())).format('MM/dd/YYYY');
		}
		CreatedDate = voHeader.CreatedDate.format('MM/dd/YYYY');
		
		// Variables required in Vendor Order Receiving page
		for(In_Progress_VR__c inProgressVRRec : voHeader.In_Progress_VRs__r) {
			//system.assert(false, inProgressVRRec);
			InProgressVR = inProgressVRRec.Vendor_Receiving_Header__r.Name;
			InProgressVRId = inProgressVRRec.Vendor_Receiving_Header__c;
		}
		
    }
    
    /**
     * Name: populateVendorOrderGroups
     * Desc: Method to populate vendor order groups records for this vendor header
     * @param:  (1) voHeader - Vendor_Order_Header__c 
     * @return: 
    **/
    public void populateVendorOrderGroups(Vendor_Order_Header__c voHeader){
    	QtyUnreceived = 0;
    	QtyReceived = 0;
    	VOLIGroups = new List<VendorOrderLineItemGroup>();
    	for(Vendor_Order_Line_Item_Group__c voliG : voHeader.Vendor_Order_Line_Item_Groups__r){
    		VendorOrderLineItemGroup voliGroup = new VendorOrderLineItemGroup(voliG, this);
    		QtyUnreceived += voliG.Unreceived_Qty__c;
    		QtyReceived += voliG.Received_Qty__c;
    		VOLIGroups.add(voliGroup);
    	}
    	if(QtyUnreceived < 0) {
    		QtyUnreceived = 0;
    		PercentRecieved =100;
    	} else {
    		PercentRecieved = (QtyReceived == 0) 
    						  ? 0
    						  : (QtyReceived / (QtyReceived + QtyUnreceived)) * 100;
    	}
    	
    	system.debug('QtyReceived  ' + QtyReceived  + '\nQtyUnreceived' + QtyUnreceived + '\nPercentRecieved ' + PercentRecieved);
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: VendorOrderHeader - Class Object
    **/
    public static VendorOrderHeader parse(String json) {
        return (VendorOrderHeader) System.JSON.deserialize(json, VendorOrderHeader.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> voHeaderFieldsList = new List<String>{	'Id', 
        													'Vendor__c',
        													'Vendor__r.Name', 
        													'Status__c', 
        													'Received_Date__c', 
        													'Purchase_Order_Type__c',
        													'Purchase_Order_Type__r.Code__c',
        													'Purchase_Order_Type__r.Lead_Time__c', 
        													'Owner__c', 
        													'Ordered_Date__c', 
        													'Expected_Date__c', 
        													'CreatedDate',
        													'Name',
        													'Owner.Name',
        													'Owner.Id',
        													'In_Progress_VR__c',
        													'In_Progress_VR__r.Name'
        												};
        return voHeaderFieldsList;
    }
    
    /**
     * Name: getPaginatedRecords
     * Desc: Method to paginate entity records list
     * @param:  
     * @return:
    **/
    public static List<VendorOrderHeader> getPaginatedRecords(List<VendorOrderHeader> allrecords, Integer currentPage, integer pageSize) {
    	List<VendorOrderHeader> objRecords = new List<VendorOrderHeader>();
    	if(currentPage == null || currentPage == 0){
    		currentPage = 1;
    	}
    	if(pageSize == null || pageSize == 0){
    		pageSize = (Integer) General_Configurations__c.getInstance().Related_List_Page_Size__c;
    	}
    	
    	for(Integer i = (currentPage * pageSize - pageSize); i < (currentPage * pageSize); i++){
    		if(allrecords.size() > i){
    			objRecords.add(allrecords.get(i));
    		}
    	}
    	return objRecords;
    }
    
    /**
     * Name: compareTo
     * Desc: Overrided Method to sort the collection to move all those vendor orders in last which are already part of any other vendor receiving records
     * @param:  
     * @return:
    **/
    public Integer compareTo(object compareTo){
        VendorOrderHeader compareToObj = ((VendorOrderHeader)compareTo);
        Integer returnVal = 0;
        					
		if(this.InProgressVRId == compareToObj.InProgressVRId || (this.InProgressVRId == null && compareToObj.InProgressVRId == null)){
			returnVal = (this.VOName == compareToObj.VOName)
						? 0
						:(
							(VendorOrderReceivingCtrl.VO_Sort_Order.toUpperCase() == 'ASC')
							?	((this.VOName < compareToObj.VOName) ? -1 : 1)
							:	(VendorOrderReceivingCtrl.VO_Sort_Order.toUpperCase() == 'DESC')
								?	((this.VOName < compareToObj.VOName) ? 1 : -1)
								:	0
						);
		} else if(this.InProgressVRId == null) {
			returnVal = (compareToObj.InProgressVRId == VendorOrderReceivingCtrl.Vendor_Order_Receiving_Id)
						?	1
						:	-1;
		} else if(compareToObj.InProgressVRId == null) {
			returnVal = (this.InProgressVRId == VendorOrderReceivingCtrl.Vendor_Order_Receiving_Id)
						?	-1
						:	1;
		} else {
			returnVal = (this.InProgressVRId == VendorOrderReceivingCtrl.Vendor_Order_Receiving_Id)
						?	-1
						:(
							(compareToObj.InProgressVRId == VendorOrderReceivingCtrl.Vendor_Order_Receiving_Id)
							?	1
							:(
								(VendorOrderReceivingCtrl.VO_Sort_Order.toUpperCase() == 'ASC')
								?	((this.VOName < compareToObj.VOName) ? -1 : 1)
								:	(VendorOrderReceivingCtrl.VO_Sort_Order.toUpperCase() == 'DESC')
									?	((this.VOName < compareToObj.VOName) ? 1 : -1)
									:	0
							)
						);
		}
        
        //System.debug('@@@\n' + this.InProgressVRId + '  ' + this.VOName + '\n' + compareToObj.InProgressVRId + '  ' + compareToObj.VOName + '\n' + returnVal + '\n' + VendorOrderReceivingCtrl.Vendor_Order_Receiving_Id);
        return returnVal;
    }
    
    // Order Type wrapper
    public class OrderTypeWrapper {
    	//PO Type Id
    	public String Id;
    	
    	// POType Name
    	public String Name;
    	
    	// Lead Time
    	public Integer LeadTime;
    	
    	public OrderTypeWrapper(String Id, String Name, decimal LeadTime){
    		this.Id = Id;
    		this.Name = Name;
    		this.LeadTime = (LeadTime == null) ? 0 : Integer.valueOf(LeadTime);
    	}
    }
}