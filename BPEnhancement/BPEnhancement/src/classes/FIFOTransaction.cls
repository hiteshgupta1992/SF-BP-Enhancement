public with sharing class FIFOTransaction {
	
	public static Map<String, String> sourceIdToApi = new Map<String, String> { 'Part Created' => 'Part__r.Name',
																				  'Vendor Invoice' => 'Vendor_Invoicing_Header__r.Name',
																				  'Vendor Receving' => 'Vendor_Receiving_Header__r.Name',
																				  'Stock Count' => 'Stock_Count__r.Name'
																				};	
																				
		public static Map<String, String> sourceRefrenceToApi = new Map<String, String> { 'Part Created' => 'Part__r.Name',
																				  'Vendor Invoice' => 'Vendor_Invoicing_Header__r.Name',
																				  'Vendor Receving' => 'Vendor_Receiving_Header__r.Name',
																				  'Stock Count' => ''
																				};																				
																					
		public static Map<String, String> sourceLookupToApi = new Map<String, String> { 'Part Created' => null,
																				  'Vendor Invoice' => 'Vendor_Invoicing_Header__c',
																				  'Vendor Receving' => 'Vendor_Receiving_Header__c',
																				  'Stock Count' => 'Stock_Count__c'
																				};																				
	/*
	 * create bucket for Part
	 */											  																													
	public static void createFIFOBucketForPart(List<Part__c> partRecList, String source) {  
		if(AccessControl.ifObjectFieldIsCreateable('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		List<Part_FIFO_Bucket__c> bucketList = new List<Part_FIFO_Bucket__c>();
		for(Part__c partRec : partRecList){
			Part_FIFO_Bucket__c bucket = new Part_FIFO_Bucket__c();
			bucket.Source_Name__c = source;
			//bucket.Reference__c = '';
			bucket.Qty_In__c = partRec.Qty_In_Stock__c;
			bucket.Cost__c =  partRec.Last_Cost__c;
			bucket.Is_FIFO_Bucket__c = true;
			bucket.Part__c = partRec.Id;
			bucketList.add(bucket);
		}
		if(bucketList.size() > 0){
			insert bucketList;
		}
	}
	
	/*
	 * create bucket for Part create from popup
	 */		
	public static void createFIFOBucketForPartCreate(List<Part__c> partRecList){
		createFIFOBucketForPart(partRecList , 'Part Created');
	}
	
	/*
	 * create bucket for Part import
	 */		
	public static void createFIFOBucketForPartImport(List<Part__c> partRecList){
		createFIFOBucketForPart(partRecList , 'Part Imported');
	}
	
	/*
	 * create bucket for on vendor receiving
	 */
	public static void createFIFOBucketForVendorReceiving(List<Part__c> partRecList, String vrHeaderId ,map<Id,Part__c> updateOnOrderIdtoPartMap) {
		if(AccessControl.ifObjectFieldIsCreateable('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		List<Part_FIFO_Bucket__c> bucketList = new List<Part_FIFO_Bucket__c>();
		Set<String> partIdSet = new Set<String>();
		for(Part__c partRec : partRecList){
			partIdSet.add(partRec.Id);
			Part_FIFO_Bucket__c bucket = new Part_FIFO_Bucket__c();
			bucket.Source_Name__c = 'Vendor Receiving';
			//bucket.Reference__c = '';
			bucket.Qty_In__c = partRec.Qty_In_Stock__c;
			bucket.Cost__c =  partRec.Last_Cost__c;
			bucket.Is_FIFO_Bucket__c = true;
			bucket.Vendor_Receiving_Header__c = vrHeaderId;
			bucket.Part__c = partRec.Id;
			bucketList.add(bucket);
		}
		if(bucketList.size() > 0){
			insert bucketList;
		}
		if(partIdSet.size() > 0){
			updatePartOnOrderInStock(new List<String>(partIdSet),updateOnOrderIdtoPartMap);
			//updatePartInStock(new List<String>(partIdSet));
		}
	}
	
	
	/*
	 * create bucket for on vendor Invoicing
	 */
	public static void updateFIFOBucketForVendorInvoicing(Map<Id, List<Part__c>> vendorReceivingHeaderToPartMap, String viHeaderId) {
		if(AccessControl.ifObjectFieldIsAccessible('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		List<Part_FIFO_Bucket__c> bucketsList = [select Id, Part__r.Id, Part__c, Cost__c, Vendor_Receiving_Header__c from Part_FIFO_Bucket__c
													where Vendor_Receiving_Header__c IN :vendorReceivingHeaderToPartMap.keySet()];
													
		Set<String> partIdSet = new Set<String>();
		for(Part_FIFO_Bucket__c bucket : bucketsList){ 
			for(Part__c partRec : vendorReceivingHeaderToPartMap.get(bucket.Vendor_Receiving_Header__c)){
				if(partRec.Id == bucket.Part__c){
					partIdSet.add(bucket.Part__c);
					bucket.Source_Name__c = 'Vendor Invoice';
					bucket.Cost__c =  partRec.Last_Cost__c;
					bucket.Vendor_Invoicing_Header__c = viHeaderId;
					bucket.Vendor_Receiving_Header__c = null;
				}
			}
			
		}
		if(bucketsList.size() > 0){
			update bucketsList;
		}
		if(partIdSet.size() > 0){
			updatePartInStock(new List<String>(partIdSet));
		}
	}
	
	/*  
	 * create bucket for on Customer Return
	 */   
	public static void createFIFOBucketForCustomerReturn(List<Part__c> partRecList, String CoInvoiceHeader) {
		if(AccessControl.ifObjectFieldIsCreateable('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		List<Part_FIFO_Bucket__c> bucketList = new List<Part_FIFO_Bucket__c>();
		Set<String> PartIdSet = new Set<String>(); 
		for(Part__c partRec : partRecList){
				PartIdSet.add(partRec.Id);
				Part_FIFO_Bucket__c bucket = new Part_FIFO_Bucket__c();
				bucket.Source_Name__c = 'Customer Return';
				bucket.Qty_In__c = partRec.Qty_In_Stock__c;
				bucket.Cost__c =  partRec.Last_Cost__c;
				bucket.Customer_Return__c = CoInvoiceHeader;
				bucket.Part__c = partRec.Id;
				bucket.Is_FIFO_Bucket__c = true;
				bucketList.add(bucket);
		}
		if(bucketList.size() > 0){
			insert bucketList;
			List<String> partIdList = new List<String>();
			partIdList.addAll(PartIdSet);
			updatePartInStock(partIdList); 
		}
	}

	
	 
	   
	// For Creating Buckets Activity Line Items
	public static String CreateFiFoBucketActivityForInvoice( Map<Id,List<Part_FIFO_Bucket__c>> PartToFIFOBucketMap ,String invoiceHeaderId ,List<Part__c> ActivityPartList,Map<Id,Part__c> updateStockedMap){
		if(AccessControl.ifObjectFieldIsCreateable('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Part_FIFO_Bucket_Activity_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		List<Part_FIFO_Bucket_Activity_Line_Item__c> partFifoActivityLineItem = new List<Part_FIFO_Bucket_Activity_Line_Item__c>();
		List<Part_FIFO_Bucket__c> FifoBucketListToInsert = new List<Part_FIFO_Bucket__c>();
		set<String> PartIdset = new set<String>();
		for(Part__c partRec : ActivityPartList){ 
			
			if(partRec.Qty_In_Stock__c > 0 ){
				PartIdset.add(partRec.Id);
				if(PartToFIFOBucketMap.ContainsKey(partRec.Id))
				{
						List<Part_FIFO_Bucket__c> FifoBucketList = PartToFIFOBucketMap.get(partRec.Id);
						for(Part_FIFO_Bucket__c FifoBucketRec : FifoBucketList){ 
							 
							if(FifoBucketRec.Remaining_Qty__c >= partRec.Qty_In_Stock__c ){
								Part_FIFO_Bucket_Activity_Line_Item__c objFifoActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
								objFifoActivityLineItemRec.CO_Invoice_Header__c = invoiceHeaderId;
								objFifoActivityLineItemRec.Part_FIFO_Bucket__c = FifoBucketRec.Id;
								objFifoActivityLineItemRec.Qty_Out__c = partRec.Qty_In_Stock__c;
								objFifoActivityLineItemRec.Reference__c = '';
								objFifoActivityLineItemRec.Type__c = 'Customer Invoice';
								partFifoActivityLineItem.add(objFifoActivityLineItemRec);
								partRec.Qty_In_Stock__c = 0;
								break;	
							}
							else{  
								Part_FIFO_Bucket_Activity_Line_Item__c objFifoActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
								objFifoActivityLineItemRec.CO_Invoice_Header__c = invoiceHeaderId;
								objFifoActivityLineItemRec.Part_FIFO_Bucket__c = FifoBucketRec.Id;
								partRec.Qty_In_Stock__c = partRec.Qty_In_Stock__c - FifoBucketRec.Remaining_Qty__c;
								objFifoActivityLineItemRec.Qty_Out__c =   FifoBucketRec.Remaining_Qty__c;
								objFifoActivityLineItemRec.Reference__c = '';
								objFifoActivityLineItemRec.Type__c = 'Customer Invoice';
								partFifoActivityLineItem.add(objFifoActivityLineItemRec); 
							}  				
						}
				}
				if(partRec.Qty_In_Stock__c > 0 ){
					PartIdset.add(partRec.Id);
					Part_FIFO_Bucket__c bucket = new Part_FIFO_Bucket__c();  
					bucket.Source_Name__c = 'Oversold';
					bucket.Qty_In__c =-partRec.Qty_In_Stock__c;
					bucket.Cost__c =  partRec.Last_Cost__c;
					bucket.Customer_Return__c = invoiceHeaderId;
					bucket.Part__c = partRec.Id;
					bucket.Is_FIFO_Bucket__c = true;
					FifoBucketListToInsert.add(bucket);
				}
			}
			//system.assert(false,FifoBucketList);
		}
		
		
		if(FifoBucketListToInsert.size() >0 ){
			insert	FifoBucketListToInsert;
		}
		if(partFifoActivityLineItem.size() > 0 ){
			insert partFifoActivityLineItem;
		}
		//
		List<String> PartIdList = new List<String>();
		for(String  Str: PartIdset ){
			PartIdList.add(Str);
		}
		updatePartCommitedInStock(PartIdList,updateStockedMap);
		return 'success';
	}
	
	/*
	 * create bucket for Part
	 */											  																													
	public static void updatePartCommitedInStock(List<String> partRecList,Map<Id,Part__c> updateStockedMap) {
		if(AccessControl.ifObjectFieldIsAccessible('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		List<Part_FIFO_Bucket__c> fifoBucketList = [select Remaining_Qty__c, Part__c, Total__c
													from Part_FIFO_Bucket__c
													where Part__c = :partRecList and Is_FIFO_Bucket__c = true and Remaining_Qty__c !=0];
		Decimal totalCost;
		Decimal totalRemainingQty; 
		List<part__c> partListToUpdate = new List<Part__c>();
		for(String partId : partRecList){
			totalCost = 0;
			totalRemainingQty = 0;
			Part__c PartRec = new Part__c();
			PartRec.Id = partId; 
			PartRec.Qty_In_Stock__c = 0;
			for(Part_FIFO_Bucket__c bucket : fifoBucketList){
				if(bucket.Part__c == partId){
					bucket.recalculateFormulas();
					PartRec.Qty_In_Stock__c += (bucket.Remaining_Qty__c != null ? bucket.Remaining_Qty__c : 0);
					totalCost += bucket.Total__c;
					totalRemainingQty += (bucket.Remaining_Qty__c != null ? bucket.Remaining_Qty__c : 0);
				}
			}
			if(updateStockedMap.containsKey(PartRec.Id)){
				PartRec.Qty_Committed__c = updateStockedMap.get(PartRec.Id).Qty_Committed__c;
			}
			PartRec.Average_Cost__c = totalRemainingQty != 0 ? (totalCost/totalRemainingQty) : 0;
			partListToUpdate.add(PartRec);
		}
		if(partListToUpdate.size() > 0){
			update partListToUpdate;			
		}
	}
		/*
	 * create bucket for Part
	 */											  																													
	public static void updatePartOnOrderInStock(List<String> partRecList,Map<Id,Part__c> updateOnOrderMap) {
		if(AccessControl.ifObjectFieldIsAccessible('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		List<Part_FIFO_Bucket__c> fifoBucketList = [select Remaining_Qty__c, Part__c, Total__c
													from Part_FIFO_Bucket__c
													where Part__c = :partRecList and Is_FIFO_Bucket__c = true and Remaining_Qty__c !=0];
		Decimal totalCost;
		Decimal totalRemainingQty; 
		List<part__c> partListToUpdate = new List<Part__c>();
		for(String partId : partRecList){
			totalCost = 0;
			totalRemainingQty = 0;
			Part__c PartRec = new Part__c(); 
			PartRec.Id = partId; 
			PartRec.Qty_In_Stock__c = 0;
			for(Part_FIFO_Bucket__c bucket : fifoBucketList){
				if(bucket.Part__c == partId){
					bucket.recalculateFormulas();
					PartRec.Qty_In_Stock__c += (bucket.Remaining_Qty__c != null ? bucket.Remaining_Qty__c : 0);
					totalCost += bucket.Total__c;
					totalRemainingQty += (bucket.Remaining_Qty__c != null ? bucket.Remaining_Qty__c : 0);
				}
			}
			if(updateOnOrderMap.containsKey(PartRec.Id)){
				PartRec.Qty_On_Order__c = updateOnOrderMap.get(PartRec.Id).Qty_On_Order__c;
			}
			PartRec.Average_Cost__c = totalRemainingQty != 0 ? (totalCost/totalRemainingQty) : 0;
			partListToUpdate.add(PartRec);
		}
		if(partListToUpdate.size() > 0){
			update partListToUpdate;			
		}
	}

	/*
	 * create bucket for Part
	 */											  																													
	public static void updatePartInStock(List<String> partRecList) {
		if(AccessControl.ifObjectFieldIsAccessible('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		List<Part_FIFO_Bucket__c> fifoBucketList = [select Remaining_Qty__c, Part__c, Total__c
													from Part_FIFO_Bucket__c
													where Part__c = :partRecList and Is_FIFO_Bucket__c = true and Remaining_Qty__c !=0];
		Decimal totalCost;
		Decimal totalRemainingQty;
		List<part__c> partListToUpdate = new List<Part__c>();
		for(String partId : partRecList){
			totalCost = 0;
			totalRemainingQty = 0;
			Part__c PartRec = new Part__c();
			PartRec.Id = partId;
			PartRec.Qty_In_Stock__c = 0;
			for(Part_FIFO_Bucket__c bucket : fifoBucketList){
				if(bucket.Part__c == partId){
					PartRec.Qty_In_Stock__c += (bucket.Remaining_Qty__c != null ? bucket.Remaining_Qty__c : 0);
					totalCost += bucket.Total__c;
					totalRemainingQty += (bucket.Remaining_Qty__c != null ? bucket.Remaining_Qty__c : 0);
				}
			}
			PartRec.Average_Cost__c = totalRemainingQty != 0 ? (totalCost/totalRemainingQty) : 0;
			partListToUpdate.add(PartRec);
		}
		
		if(partListToUpdate.size() > 0){
			update partListToUpdate;			
		}
	}
	 	
	// Insert Activity and Deduction from Buckets
	public String insertBucketActivity(){
		return null;
	}
	
	// Get Bucket Records 
	public String getBucket(String PartId,boolean ShowHistory){
		return null;
	}

}