/**
 * Author: Tarun Khandelwal
 * Since: June 17, 2015
 * Name: ViewPartCtrl
 * Description: Controller Class of Part Detail Page.
**/
global with sharing class ViewPartCtrl {
	
	/**
     * Name: getPartInfo
     * Desc: To get Part Inforamtion used in View Part Page
     * @param: (1) partId - String - Id of Part
     * @return: String - JSON string of Part Info. 
    **/
   	@RemoteAction
    global static String getPartInfo(String partId) {
    	try{
    		partId = BPUtility.getDecodedString(partId);
	    	boolean previewMode =  false;
	        List<Part__c> parts = SOQLUtil.getPartDetailRecordsByFieldName('Id', partId);
	        
	        Map<String, String> fieldNameToFieldValueMap = new  Map<String, String>();
	        fieldNameToFieldValueMap.put('Part__c', partId);
	        
	        List<Part_FIFO_Bucket__c> partFIFOBucketList = SOQLUtil.getPartFIFOBucketByPartID(fieldNameToFieldValueMap, previewMode);
	        List<Part_FIFO_Bucket__c> partFIFOBucketTotalPartList = SOQLUtil.getPartFIFOBucketByPartID(fieldNameToFieldValueMap, true);
	        String JSONString = '{}';
	        if(parts.size() > 0) {
	           JSONString = System.JSON.serialize(new PartDetailWrapper(parts[0], getStatisticsCalculation(partId), partFIFOBucketList, partFIFOBucketTotalPartList.size()));
	        }
	        return BPUtility.getEncodedString(JSONString);  
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	} 
    }  
 
 	/**
     * Name: getStatisticsCalculation
     * Desc:  
     * @param: (1) partId - String - Id of Part
     * @return: List<String> 
    **/
 	public static List<String> getStatisticsCalculation(String partId) {
 		List<String> calculatedValuesList = new List<String>();
 		try{
	 		String query = '';
	 		partId = BPUtility.escapeSingleQuotes(partId);
	 		query += 'SELECT Qty__c, Price__c, CO_Invoice_Header__r.LastModifiedDate FROM CO_Invoice_Item__c WHERE CO_Line_Item__r.Part__c = \'' + partId + '\' AND CO_Invoice_Header__r.Invoice_Status__c = \'Closed\' ORDER BY CO_Invoice_Header__r.LastModifiedDate DESC';
	 		if(AccessControl.ifObjectIsAccessible('CO_Invoice_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 		//if(AccessControl.ifObjectIsAccessible('CO_Invoice_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 		List<CO_Invoice_Item__c> coInvoiceItems = Database.query(query);
	 		Decimal soldLifeTimeQty = 0; 
	 		Decimal revenueLifetime = 0;
	 		DateTime lastSoldDate = system.now();
	 		if(coInvoiceItems.size() > 0) {
	 			lastSoldDate = coInvoiceItems[0].CO_Invoice_Header__r.LastModifiedDate;
	 		} 
	 		for(CO_Invoice_Item__c coInvoiceItemRec : coInvoiceItems) {
	 			if(coInvoiceItemRec.Qty__c != null) {
	 				soldLifeTimeQty += coInvoiceItemRec.Qty__c;
	 				revenueLifetime += (coInvoiceItemRec.Qty__c * coInvoiceItemRec.Price__c);
	 			}
	 		}
	 		String lastSoldTime = '';
	 		Long lastSoldDateValue = lastSoldDate.getTime();
	    	Long currentDateValue = system.now().getTime();
	    	lastSoldTime = String.valueOf(Integer.valueOf(((currentDateValue - lastSoldDateValue)/ (1000 * 60 * 60 * 24)) / 30 )) + 'm ';
	    	lastSoldTime += String.valueOf(Integer.valueOf( Math.mod(((currentDateValue - lastSoldDateValue)/ (1000 * 60 * 60 * 24)), 30))) + 'd ';
	    	lastSoldTime += String.valueOf(Integer.valueOf( Math.mod(((currentDateValue - lastSoldDateValue)/ (1000 * 60 * 60)), 24))) + 'h';
	    	//system.assert(false, 'soldLifeTimeQty : ' + soldLifeTimeQty +'\n\n revenueLifetime : ' + revenueLifetime + '\n\n lastSoldTime : ' + lastSoldTime);
	    	
	    	
	    	calculatedValuesList.add(String.valueOf(soldLifeTimeQty));
	    	calculatedValuesList.add(String.valueOf(revenueLifetime));
	    	calculatedValuesList.add(lastSoldTime);
	    	return calculatedValuesList;
 		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return calculatedValuesList;
    	}
 	}   
 	
   	/**
     * Name: increaseAdjustInStock
     * Desc: To get Part Inforamtion used in View Part Page
     * @param: (1) partId - String - Id of Part 
     * @return: String - JSON string of Part Info. 
   	**/
   	@RemoteAction
   	global static String increaseAdjustInStock(String partId, Decimal qtyIn, Decimal cost) {
   		try{
   			partId = BPUtility.getDecodedString(partId);
   			
   			
	   		Decimal maxPartAdjustCount = 0;
	   		if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	 	List<Part_FIFO_Bucket__c> existingPartBucketList = [select Part_Adjust_Number__c from Part_FIFO_Bucket__c order by Part_Adjust_Number__c DESC NULLS LAST limit 1];
	 	  	if(existingPartBucketList.size() > 0) {
	 	  		maxPartAdjustCount = (existingPartBucketList[0].Part_Adjust_Number__c != null) ? existingPartBucketList[0].Part_Adjust_Number__c : 0;
	 	  	}
	 	  	Part_FIFO_Bucket__c partBucketRec = new Part_FIFO_Bucket__c();
	 	  	partBucketRec.Source_Name__c = 'Stock Count';			
	 	  	partBucketRec.Part_Adjust_Number__c = maxPartAdjustCount + 1;
	 	  	partBucketRec.Reference__c = 'Count Adjustment';
	 	  	partBucketRec.Qty_In__c = qtyIn;
	 	  	partBucketRec.Cost__c = cost;
	 	  	partBucketRec.Part__c = partId;
	 	  	partBucketRec.Is_FIFO_Bucket__c = true;
	 	  	if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  	insert partBucketRec;
	        FIFOTransaction.updatePartInStock(new List<String>{partId});
	        
	      	return getPartInfo(BPUtility.getEncodedString(partId));
	      	
   		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
   	}
   	
   	/**
     * Name: increaseAdjustInStock
     * Desc: To get Part Inforamtion used in View Part Page
     * @param: (1) partId - String - Id of Part 
     * @return: String - JSON string of Part Info. 
   	**/
   	@RemoteAction
   	global static String decreaseAdjustInStock(String partId, Decimal qty, String FIFOBucketJSONString) {
   		try{
   			partId = BPUtility.getDecodedString(partId);
   			FIFOBucketJSONString = BPUtility.getDecodedString(FIFOBucketJSONString);
   			
	   		List<PartFifoBucket> partFIFOObjList = (List<PartFifoBucket>)System.JSON.deserialize(FIFOBucketJSONString, List<PartFifoBucket>.class);
	   		List<Part_FIFO_Bucket_Activity_Line_Item__c> partFIFOBucketLineItemList =  new List<Part_FIFO_Bucket_Activity_Line_Item__c>();
	   		
	   		Decimal maxPartAdjustCount = 0;
	   		if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	 	List<Part_FIFO_Bucket__c> existingPartBucketList = [select Part_Adjust_Number__c from Part_FIFO_Bucket__c order by Part_Adjust_Number__c DESC  NULLS LAST limit 1];
	 	  	if(existingPartBucketList.size() > 0) {
	 	  		maxPartAdjustCount = (existingPartBucketList[0].Part_Adjust_Number__c != null) ? existingPartBucketList[0].Part_Adjust_Number__c : 0;
	 	  	}
	 	  	
	 	  	Part_FIFO_Bucket__c partBucketRec = new Part_FIFO_Bucket__c();
	 	  	partBucketRec.Source_Name__c = 'Stock Adjust';			
	 	  	partBucketRec.Part_Adjust_Number__c = maxPartAdjustCount + 1;
	 	  	partBucketRec.Reference__c = 'Stock Adjustment';
	 	  	partBucketRec.Qty_In__c = 0;
	 	  	partBucketRec.Cost__c = 0;
	 	  	partBucketRec.Part__c = partId;
	 	  	partBucketRec.Is_FIFO_Bucket__c = false;
	 	  	if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  	insert partBucketRec;
	   		
	   		for(PartFifoBucket partBucketObj : PartFifoObjList) {
	 	  		if(qty > 0) {
		 	  		Part_FIFO_Bucket_Activity_Line_Item__c partActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
		 	  		partActivityLineItemRec.Part_Adjustment__c = partBucketRec.Id;
		 	  		partActivityLineItemRec.Part_FIFO_Bucket__c = partBucketObj.FIFOBucketId;
		 	  		partActivityLineItemRec.Reference__c = 'Count Adjustment';
	 	  		
	 	  			if((qty - partBucketObj.RemainingQty) > 0) {
	 	  				partActivityLineItemRec.Qty_Out__c = partBucketObj.RemainingQty;
	 	  			} else {
	 	  				partActivityLineItemRec.Qty_Out__c = qty;
	 	  			}
	 	  			qty -= partActivityLineItemRec.Qty_Out__c;
	 	  			partFIFOBucketLineItemList.add(partActivityLineItemRec);
	 	  		} 
	 	  	}
	 	  	
	 	  	if(partFIFOBucketLineItemList.size() > 0) {
	 	  		//if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	  		if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  		insert partFIFOBucketLineItemList;
	 	  	}
	 	  	FIFOTransaction.updatePartInStock(new List<String>{partId});
	      	return getPartInfo(BPUtility.getEncodedString(partId));
   		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	} 	
   	}
   	
   
   	@RemoteAction
   	global static String modifyCostSummary(String FIFOBucketJSONString, Decimal newCost) {
   		try{
   			FIFOBucketJSONString = BPUtility.getDecodedString(FIFOBucketJSONString);
   			
	 	  	List<PartFifoBucket> PartFifoObjList = (List<PartFifoBucket>)System.JSON.deserialize(FIFOBucketJSONString, List<PartFifoBucket>.class); 	
			List<Part_FIFO_Bucket_Activity_Line_Item__c> partFIFOBucketLineItemList =  new List<Part_FIFO_Bucket_Activity_Line_Item__c>();
	 	  	Decimal totalQtyRemaining = 0;
	 	  	String partId;
	 	  	for(PartFifoBucket partBucketObj : PartFifoObjList) {
	 	  		totalQtyRemaining += partBucketObj.RemainingQty;
	 	  		if(partId == null) {
	 	  			partId = partBucketObj.PartId;
	 	  		}
	 	  	}
	 	  	
	 	  	Decimal maxPartAdjustCount = 0;
	 	  	if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	 	List<Part_FIFO_Bucket__c> existingPartBucketList = [select Part_Adjust_Number__c from Part_FIFO_Bucket__c order by Part_Adjust_Number__c DESC  NULLS LAST limit 1];
	 	  	if(existingPartBucketList.size() > 0) {
	 	  		maxPartAdjustCount = (existingPartBucketList[0].Part_Adjust_Number__c != null) ? existingPartBucketList[0].Part_Adjust_Number__c : 0;
	 	  	}
	 	  	
	 	  	
	 	  	Part_FIFO_Bucket__c partBucketRec = new Part_FIFO_Bucket__c();
	 	  	partBucketRec.Source_Name__c = 'Cost Adjust';			
	 	  	partBucketRec.Part_Adjust_Number__c = maxPartAdjustCount + 1;
	 	  	partBucketRec.Reference__c = 'Cost Adjustment';
	 	  	partBucketRec.Qty_In__c = totalQtyRemaining;
	 	  	partBucketRec.Cost__c = newCost;
	 	  	partBucketRec.Part__c = partId;
	 	  	partBucketRec.Is_FIFO_Bucket__c = true;
	 	  	if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
 	  		insert partBucketRec;
 	  	
	 	  	for(PartFifoBucket partBucketObj : PartFifoObjList) {
	 	  		Part_FIFO_Bucket_Activity_Line_Item__c partActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
	 	  		partActivityLineItemRec.Part_Adjustment__c = partBucketRec.Id;
	 	  		partActivityLineItemRec.Part_FIFO_Bucket__c = partBucketObj.FIFOBucketId;
	 	  		partActivityLineItemRec.Reference__c = 'Cost Adjustment';
	 	  		partActivityLineItemRec.Qty_Out__c = partBucketObj.RemainingQty;
	 	  		partBucketObj.PartFIFOActivityLineItemList.add(new PartFifoBucket.PartFIFOActivityLineItem(partActivityLineItemRec));
	 	  		partFIFOBucketLineItemList.add(partActivityLineItemRec);
	 	  	}
	 	  	
	 	  	//PartFifoObjList.add(new PartFifoBucket(partBucketRec));
	 	  	if(partFIFOBucketLineItemList.size() > 0) {
	 	  			//if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	  			//if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  			
	 	  		if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  		insert partFIFOBucketLineItemList;
	 	  	}
	 	  	FIFOTransaction.updatePartInStock(new List<String>{partId});
	      	return getPartInfo(BPUtility.getEncodedString(partId));
   		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}	
   	}
   	
   	@RemoteAction
	global static String saveAdjustedCostDetails(String costDetailsJson,Decimal newCost,Boolean isAdjustedRemaining) {
		try{
			costDetailsJson = BPUtility.getDecodedString(costDetailsJson);
			
	 	  	PartFifoBucket PartFifoBucketobj = (PartFifoBucket)System.JSON.deserialize(costDetailsJson,PartFifoBucket.class);
			List<PartFifoBucket> PartFifoObjList = new List<PartFifoBucket>(); 
			List<Part_FIFO_Bucket_Activity_Line_Item__c> partFIFOBucketLineItemList =  new List<Part_FIFO_Bucket_Activity_Line_Item__c>();
	 	  	FIFOTransaction fifoTransactionObject = new FIFOTransaction();
			String partId;
			partId = PartFifoBucketobj.PartId;
	 	  	Decimal totalQtyRemaining = 0;
	 	 	Decimal maxPartAdjustCount = 0;
	 	 	if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	 	List<Part_FIFO_Bucket__c> existingPartBucketList = [select Part_Adjust_Number__c from Part_FIFO_Bucket__c order by Part_Adjust_Number__c DESC  NULLS LAST limit 1];
	 	  	if(existingPartBucketList.size() > 0) {
	 	  		maxPartAdjustCount = (existingPartBucketList[0].Part_Adjust_Number__c != null) ? existingPartBucketList[0].Part_Adjust_Number__c : 0;
	 	  	}
	 	  	
	 	  	Part_FIFO_Bucket__c partBucketRec = new Part_FIFO_Bucket__c();
	 	  	partBucketRec.Source_Name__c = 'Cost Adjust';			
	 	  	partBucketRec.Reference__c =  'Re:' + PartFifoBucketobj.UniqueId;
	 	  	partBucketRec.Part__c = partId;
	 	  	partBucketRec.Part_Adjust_Number__c = maxPartAdjustCount + 1;
	 	  	if(isAdjustedRemaining){
	 	  		partBucketRec.Qty_In__c = PartFifoBucketobj.RemainingQty;
	 	  	}
	 	  	else{
	 	  		partBucketRec.Qty_In__c = PartFifoBucketobj.QtyIn;
	 	  	}
	 	  	partBucketRec.Cost__c = newCost;
	 	  	partBucketRec.Is_FIFO_Bucket__c = true;
	 	  	if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  	insert partBucketRec;
	 	  	if(!isAdjustedRemaining){
	 	  		Part_FIFO_Bucket_Activity_Line_Item__c partpresoldActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
		 	  	partpresoldActivityLineItemRec.Part_Adjustment__c = partBucketRec.Id;
		 	  	partpresoldActivityLineItemRec.Part_FIFO_Bucket__c = partBucketRec.Id;
		 	  	partpresoldActivityLineItemRec.Reference__c = 'Presold on' + PartFifoBucketobj.UniqueId;
		 	  	partpresoldActivityLineItemRec.Qty_Out__c = PartFifoBucketobj.QtyOut;
		 	  	PartFifoBucketobj.PartFIFOActivityLineItemList.add(new PartFifoBucket.PartFIFOActivityLineItem(partpresoldActivityLineItemRec));
		 	  	partFIFOBucketLineItemList.add(partpresoldActivityLineItemRec);
		 	  	PartFifoObjList.add(new PartFifoBucket(partBucketRec));
	 	  	}  	
	 	  	Part_FIFO_Bucket_Activity_Line_Item__c partActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
		 	partActivityLineItemRec.Part_Adjustment__c = partBucketRec.Id;
		 	partActivityLineItemRec.Part_FIFO_Bucket__c = PartFifoBucketobj.FIFOBucketId;
		 	partActivityLineItemRec.Reference__c = 'Cost Adjustment';
		 	partActivityLineItemRec.Qty_Out__c = PartFifoBucketobj.RemainingQty;
	 	  	PartFifoBucketobj.PartFIFOActivityLineItemList.add(new PartFifoBucket.PartFIFOActivityLineItem(partActivityLineItemRec));
	 	  	partFIFOBucketLineItemList.add(partActivityLineItemRec);
	 	  	PartFifoObjList.add(new PartFifoBucket(partBucketRec));
	 	  	if(partFIFOBucketLineItemList.size()>0)
	 	  	{
	 	  		//if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	  		if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  		insert partFIFOBucketLineItemList;
	 	  	}
	 	  	FIFOTransaction.updatePartInStock(new List<String>{partId});
	 	  	
	  		return getPartInfo(BPUtility.getEncodedString(partId));
		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}	
   	}
	  
	  
	@RemoteAction
	global static String resolveOversoldInStock(String FIFOBucketJSONString) {
		try{
			
	 	  	if(AccessControl.ifObjectFieldIsCreateable('Part_FIFO_Bucket__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
	 	  	
			FIFOBucketJSONString = BPUtility.getDecodedString(FIFOBucketJSONString);
				
	 	  	List<PartFifoBucket> PartFifoObjList = (List<PartFifoBucket>)System.JSON.deserialize(FIFOBucketJSONString, List<PartFifoBucket>.class); 	
	 	  	List<Part_FIFO_Bucket_Activity_Line_Item__c> partFIFOBucketLineItemList =  new List<Part_FIFO_Bucket_Activity_Line_Item__c>();
	 	  	String partId;
	 	  	for(PartFifoBucket partBucketObj : PartFifoObjList) {
	 	  		if(partId == null) {  
	 	  			partId = partBucketObj.PartId;
	 	  		}
	 	  	}
	 	  	
	 	  	Decimal maxPartAdjustCount = 0;
	 	  	if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	  	List<Part_FIFO_Bucket__c> existingPartBucketList = [select Part_Adjust_Number__c from Part_FIFO_Bucket__c order by Part_Adjust_Number__c DESC NULLS LAST limit 1];
	 	  	if(existingPartBucketList.size() > 0) {
	 	  		maxPartAdjustCount = (existingPartBucketList[0].Part_Adjust_Number__c != null) ? existingPartBucketList[0].Part_Adjust_Number__c : 0;
	 	  	}
	 	  	
	 	  	Part_FIFO_Bucket__c partBucketRec = new Part_FIFO_Bucket__c();
	 	  	partBucketRec.Source_Name__c = 'Count Adjust';			
	 	  	partBucketRec.Reference__c = 'Count Adjustment';
	 	  	partBucketRec.Part__c = partId;
	 	  	partBucketRec.Part_Adjust_Number__c = maxPartAdjustCount + 1;
	 	  	insert partBucketRec;
	 	  	
	 	  	for(PartFifoBucket partBucketObj : PartFifoObjList) {
	 	  		
	 	  		Part_FIFO_Bucket_Activity_Line_Item__c partActivityLineItemRec = new Part_FIFO_Bucket_Activity_Line_Item__c();
	 	  		partActivityLineItemRec.Part_Adjustment__c = partBucketRec.Id;
	 	  		partActivityLineItemRec.Part_FIFO_Bucket__c = partBucketObj.FIFOBucketId;
	 	  		partActivityLineItemRec.Reference__c = 'Count Adjustment';
	 	  		partActivityLineItemRec.Qty_Out__c = partBucketObj.RemainingQty;
	 	  		partBucketObj.PartFIFOActivityLineItemList.add(new PartFifoBucket.PartFIFOActivityLineItem(partActivityLineItemRec));
	 	  		partFIFOBucketLineItemList.add(partActivityLineItemRec);
	 	  		
	 	  	}
	 	  	if(partFIFOBucketLineItemList.size()>0)
	 	  	{
	 	  		//if(AccessControl.ifObjectIsAccessible('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	 	  		if(AccessControl.ifObjectIsCreateable('Part_FIFO_Bucket_Activity_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	 	  		insert partFIFOBucketLineItemList;
	 	  	}
	 	  	//PartFifoObjList.add(new PartFifoBucket(partBucketRec));
	 	  	FIFOTransaction.updatePartInStock(new List<String>{partId});
	      	return getPartInfo(BPUtility.getEncodedString(partId));
		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
   	}
   
   @RemoteAction   
	global static String getHistoryRecords(String PartId, boolean previewMode ) {
		try{
			PartId = BPUtility.getDecodedString(PartId);
			
			Map<String, String> fieldNameToFieldValueMap = new  Map<String, String>();
	        fieldNameToFieldValueMap.put('Part__c', partId);
	        List<Part_FIFO_Bucket__c> partFIFOBucketRecList = SOQLUtil.getPartFIFOBucketByPartID(fieldNameToFieldValueMap, previewMode);
	        
	        
	        List<PartFifoBucket> partFIFOBucketList = new List<PartFifoBucket>();
	        for(Part_FIFO_Bucket__c partFIFOBucketRec : partFIFOBucketRecList) {
	            partFIFOBucketList.add(new PartFifoBucket(partFIFOBucketRec));
	        }
	        return BPUtility.getEncodedString(System.JSON.serialize(partFIFOBucketList));  
		}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}  
	}
}