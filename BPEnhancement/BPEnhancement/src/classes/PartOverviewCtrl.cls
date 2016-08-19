/**
 * Author: Tarun Khandelwal
 * Since: June 05, 2015
 * Name: PartOverviewCtrl
 * Description: Controller Class of Part Detail Page.
**/
global with sharing class PartOverviewCtrl {

	/**
     * Name: getPartDetail
     * Desc: To get Part Details on Edit Part Pop Up window
     * @param: (1) partRecordId - String - Id of Part 
     * @return: String - JSON string of Part info. 
    **/
    @RemoteAction
    global static String getPartDetail(String partRecordId) {
    	partRecordId = BPUtility.getDecodedString(partRecordId);
        List<Part__c> partList = SOQLUtil.getPartDetailRecordsByFieldName('Id', partRecordId);
        List<PartDetail> partObjList = new List<PartDetail>();
        for(Part__c partRec : partList) {
            partObjList.add(new PartDetail(partRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(partObjList));
    }
	
	/**
     * Name: getApplicableTaxList
     * Desc: To get Part Details on Edit Part Pop Up window
     * @param: (1) partRecordId - String - Id of Part 
     * @return: String - JSON string of Part info. 
    **/
    @RemoteAction
    global static String getApplicableTaxList() {
        String defaultPartTaxId = Configurations__c.getOrgDefaults().Default_Tax_on_Part__c;
        return BPUtility.getEncodedString(TaxUtility.getApplicableList(defaultPartTaxId));
    }
    
	/**
     * Name: savePart
     * Desc: To save Part Record in database 
     * @param: (1) partJSONString - String - JSON String of Part Record
     * @return: String - Id of Inserted or updated part Record. 
    **/
    @RemoteAction
    global static String savePart(String partJSONString) {
    	partJSONString = BPUtility.getDecodedString(partJSONString);
    	if(AccessControl.ifObjectFieldIsCreateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
		if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        List<PartDetail> partObjList = PartDetail.parse(partJSONString);
        
        System.debug('####' + 'Got HERE !');
        
        Boolean isInsert = true;
        List<Part__c> partListToInsert = new List<Part__c>();
        Part__c partRec;
        
        for(PartDetail partObj : partObjList) {
            partRec = new Part__c();
            
            partRec.Part_Number__c = partObj.PartNumber;
            partRec.Description__c = partObj.Description;
            partRec.Vendor__c = partObj.VendorId;
            partRec.Category__c = partObj.CategoryId;
            //partRec.Superseded_By__c = partObj.ReplacedById;
            partRec.Packaged_Part__c = partObj.IsPackagedPart;
            if(!partRec.Packaged_Part__c){
            	partRec.Package_Qty__c = 0;
            	partRec.Package_Unit__c = null;
            	partRec.Package_Cost__c = 0;
            }else{
            partRec.Package_Qty__c = partObj.PackagedQty;
            partRec.Package_Unit__c = partObj.PackagedUnit;
            	partRec.Package_Cost__c = partObj.PackagedCost;
            }
            partRec.Qty_In_Stock__c = partObj.InStockQty;
            partRec.Taxable__c = partObj.IsTaxable;
            if(partObj.IsTaxable) {
            	partRec.Applicable_Tax__c = partObj.ApplicableTaxId;
            } else {
            	partRec.Applicable_Tax__c = null;
            }
            partRec.Is_OrderLot__c = partObj.IsOrderLot;
            if(partRec.Is_OrderLot__c){
            	partRec.Order_Lots__c = partObj.OrderLots;
            }else{
            	partRec.Order_Lots__c = 0; 
            }
            partRec.Location__c = partObj.Location;
            partRec.Last_Cost__c = partObj.Cost;
            partRec.Package_Cost__c = partObj.PackagedCost;
            partRec.MSRP__c = partObj.MSRP;
            partRec.Retail_Price__c = partObj.Retail;
            partRec.Enviro_Fee__c = partObj.EnviroFee;
            partRec.Auto_reorder_Min__c = partObj.AutoReorderAt;
            partRec.Auto_reorder_Max__c = partObj.AutoReorderTo;
            partRec.Order_Lots__c = partObj.OrderLots;
            
            if(partObj.Id != null) {
            	isInsert = false;
                partRec.Id = partObj.Id;
            }else{
            	partRec.Average_Cost__c = partObj.Cost;
            }
            if(partRec.Superseded_By__c != null && partRec.Id == partRec.Superseded_By__c) {
            	return BPUtility.getEncodedString('1001');
            }
            partListToInsert.add(partRec);
        }
        String upsertedPartRecordId = ''; 
        if(partListToInsert.size() > 0) {
            try {
            	PartTriggerHelper.isPartFromImport = false;
            	upsert partListToInsert;
            	if(isInsert){
            		FIFOTransaction.createFIFOBucketForPartCreate(partListToInsert);
            	}
            } catch(Exception e) {
            	return BPUtility.getEncodedString('1002');
            }
            upsertedPartRecordId = partListToInsert[0].Id;
        }
        return BPUtility.getEncodedString(upsertedPartRecordId);
    }
    
    /**
     * Name: getJSONForFilteredUnitMakes
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     		   (3) isInactiveIncluded - Boolean - true if Inactive records are included 
     * @return: String - JSON Fromatted String of filtered Unit Makes records
    **/
    /*@RemoteAction
    global static String getJSONForSuggestion(String searchingString, String ObjectName) {
		searchingString = String.escapeSingleQuotes(searchingString);
		
		String fieldAPIName = Constants.UNIT_MAKE_LIST_JSON_TO_FIELDS_MAPPING.get(fieldName);
		List<Unit_Make__c> searchedUnitMakes = SOQLUtil.getFilteredUnitMakes(searchingString, fieldAPIName, isInactiveIncluded);
    	return Utility.createJSONForFilteredResult(searchedUnitMakes, fieldAPIName);
    }*/
    
    /**
     * Name: getJSONForFilteredUnitMakes
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     		   (3) isInactiveIncluded - Boolean - true if Inactive records are included 
     * @return: String - JSON Fromatted String of filtered Unit Makes records
    **/
    @RemoteAction
    global static String getDefaultCategory(String vendorId) {
    	vendorId = BPUtility.getDecodedString(vendorId);
    	vendorId = BPUtility.escapeSingleQuotes(vendorId);
    	if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Category__c> categoryList = new List<Category__c>();
		if(vendorId == '') {
			categoryList = [select Id, Name from Category__c WHERE default__c = true and Type__c = 'Part'];
		} else {
			List<Account> vendorList = [select Id, Part_Category_Default__c, Part_Category_Default__r.Name from Account where Id = :vendorId AND Is_Vendor__c = true];
			if(vendorList.size() > 0 && vendorList[0].Part_Category_Default__c != null) {
				Category__c categoryRec = new Category__c (Name = vendorList[0].Part_Category_Default__r.Name, Id = vendorList[0].Part_Category_Default__c);
				categoryList.add(categoryRec);
			} else {
				categoryList = [select Id, Name from Category__c WHERE default__c = true and Type__c = 'Part'];
			}
		} 
		String jsonString = '{}'; 
		if(categoryList.size() > 0) {
			JSONGenerator gen = JSON.createGenerator(true);
	        gen.writeStartObject();
	        gen.writeStringField('DefaultCategoryId', categoryList[0].Id); 
	        gen.writeStringField('DefaultCategoryName', categoryList[0].Name);
	        gen.writeEndObject();
	        jsonString = gen.getAsString();
		}
    	return BPUtility.getEncodedString(jsonString);
    }
}