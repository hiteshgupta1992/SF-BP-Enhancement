/**
 * Author: Tarun Khandelwal
 * Since: Nov 19, 2015
 * Name: ViewKitCtrl
 * Description: Apex class to handle JSON related oprations of View Kit
 **/
global with sharing class ViewKitCtrl {
	 
	
	public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
	
    /**
     * Name: getKitDetails 
     * Desc: To get Kit Header Record JSON String
     * @param:  (1) kitHeaderId - String - Kit Header Record Id
     *          (2) gridName - String - Name of Grid which JSON grid is needed. If null, all Grids JSON is returned
     * @return: String - Kit Header JSON String.
     **/
    @remoteAction
    global static String getKitDetails(String kitHeaderId, String gridName, Errorhandler error, String kitContentPageSortAttrsJSON, String activeOrderPageSortAttrsJSON) {
    	try{
    		kitHeaderId = BPUtility.getDecodedString(kitHeaderId);
    		gridName = BPUtility.getDecodedString(gridName);
    		kitContentPageSortAttrsJSON = BPUtility.getDecodedString(kitContentPageSortAttrsJSON);
    		activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
    		
	        List < Kit_Header__c > kitHeaderList = SOQLUtil.getKitHeaderRec(new Map <String, String> { 'Id' => kitHeaderId });
	        List < Kit_Header_Line_Item__c > khLineItemList = new List < Kit_Header_Line_Item__c > ();
	        List<Service_Order_Kit_Header__c> sokhList = new List<Service_Order_Kit_Header__c>();
	        
	        PaginationSorting kitContentPageSortAttrs = PaginationSorting.parsePageAttrs(kitContentPageSortAttrsJSON);
	        PaginationSorting activeOrderPageSortAttrs = PaginationSorting.parsePageAttrs(activeOrderPageSortAttrsJSON);
	        
	        Integer totalKHLineItem = 0;
	        if (gridName == null || gridName.toLowerCase() == 'lineitems') {
	            khLineItemList = SOQLUtil.getKHLineItemRec(new Map <String, String> { 'Kit_Header__c' => kitHeaderId });
	            totalKHLineItem = khLineItemList.size();
	            
	            // getPaginated Records
	            khLineItemList = TaxExemption.getPaginatedRecords(khLineItemList, kitContentPageSortAttrs.CurrentPage, kitContentPageSortAttrs.PageSize);
	        }
	        
	        if (gridName == null || gridName.toLowerCase() == 'activeorder') {
	            sokhList = SOQLUtil.getActiveOrdersForKit(kitHeaderId);
	            //totalKHLineItem = khLineItemList.size();
	            
	            // getPaginated Records
	            //khLineItemList = TaxExemption.getPaginatedRecords(khLineItemList, kitContentPageSortAttrs.CurrentPage, kitContentPageSortAttrs.PageSize);
	        }
	        
	        if (kitHeaderList.size() == 0) {
	            return BPUtility.getEncodedString('{}');
	        }
	        
	        
	        List<CO_Line_Item__c> colilist = SOQLUtil.getCOLIDetailsForKitId(kitHeaderId, null);
	        KitHeaderWrapper kitHeaderWrapperObj = new KitHeaderWrapper(kitHeaderList[0], khLineItemList, sokhList, error, activeOrderPageSortAttrs,colilist);
	        kitHeaderWrapperObj.TotalLineItem = totalKHLineItem;
	        return BPUtility.getEncodedString(System.JSON.serialize(kitHeaderWrapperObj));
    	}
    	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
    }

    /**
     * Name: getMasterDataForKitCreation
     * Desc: To get Master Data (Transactions Type, Make, Model, Submodel) JSON String
     * @param:
     * @return: String - Master Data JSON String.
     **/
    @remoteAction
    global static String getMasterDataForKitCreation() {
    	try{
    		List < Unit_Make__c > unitMakeList = SOQLUtil.getUnitMake(new List < Id > ());
	        List < Unit_Make__c > unitMakeWrapperList = SOQLUtil.getUnitMakeWrapper();
	        List < Transaction_Type__c > ttList = SOQLUtil.getTransactionTypes(new List < Id > ());
	
	        COUFieldWrapper cOUFieldWrapperObj = new COUFieldWrapper(unitMakeList, unitMakeWrapperList, new List < Category__c > (), ttList);
	        return BPUtility.getEncodedString(System.JSON.serialize(cOUFieldWrapperObj));
    	}
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
    }

    /**
     * Name: saveKitHeader
     * Desc: To save Kit Header Record
     * @param:
     * @return: String - get Main JSON data.
     **/
    @remoteAction
    global static String saveKitHeader(String jsonString, String activeOrderPageSortAttrsJSON) {
    	String errMsg = '';
    	try{
    		jsonString = BPUtility.getDecodedString(jsonString);
    		activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
    		
	        KitHeader kitHeaderObj = KitHeader.parse(jsonString);
	        Kit_Header__c kitHeaderToUpsert = (Kit_Header__c)setKitHeaderFields(kitHeaderObj);
	
	        //system.assert(false, kitHeaderToUpsert);
	       	Savepoint sp = Database.setSavepoint();
	       	if(AccessControl.ifObjectIsUpdateable('Kit_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	       	if(AccessControl.ifObjectFieldIsCreateable('Kit_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	        try{
	        	upsert kitHeaderToUpsert;
	        }catch(exception e){ 
        		if(e.getMessage().contains('duplicate value found: Code__c duplicates value')){
        			throw new BlackPurlException('This Code already exists, please enter unique code');
        		}
	        }
	
	        // Query all Kit_Transaction_Type_Junction__c
	        if(AccessControl.ifObjectIsAccessible('Kit_Transaction_Type_Junction__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	        List < Kit_Transaction_Type_Junction__c > existingKTTJRecs = [select Transaction_Type__c from Kit_Transaction_Type_Junction__c Where Kit_Header__c =  : kitHeaderToUpsert.Id];
	        Map<Id, Id> TTypeIdToKTJJIdMap = new Map<Id, Id>();
	        for (Kit_Transaction_Type_Junction__c kttj : existingKTTJRecs) {
	            TTypeIdToKTJJIdMap.put(kttj.Transaction_Type__c, kttj.Id);
	        }
	
	        List < Id > existingTTIdList = new List < Id > ();
	        List < Id > newTTIdList = new List < Id > ();
	        List < Kit_Transaction_Type_Junction__c > kitHeaderToTTJunRecList = new List < Kit_Transaction_Type_Junction__c > ();
	        for (KitHeader.TransactionType ttRec : kitHeaderObj.TransactionTypeList) {
	            Kit_Transaction_Type_Junction__c kitHeaderToTTJunRec = new Kit_Transaction_Type_Junction__c();
	            kitHeaderToTTJunRec.Kit_Header__c = kitHeaderToUpsert.Id;
	            if (TTypeIdToKTJJIdMap.containsKey(ttRec.Id)) {
	                existingTTIdList.add(ttRec.Id);
	                continue;
	            }
	            kitHeaderToTTJunRec.Transaction_Type__c = ttRec.Id;
	            newTTIdList.add(ttRec.Id);
	            kitHeaderToTTJunRecList.add(kitHeaderToTTJunRec);
	        }
	
	        if (kitHeaderToTTJunRecList.size() > 0) {
	        	if(AccessControl.ifObjectIsCreateable('Kit_Transaction_Type_Junction__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	            insert kitHeaderToTTJunRecList;
	        }
	
	        List < Kit_Transaction_Type_Junction__c > kttjListToDel = [select Id from Kit_Transaction_Type_Junction__c Where Transaction_Type__c NOT IN : existingTTIdList AND Transaction_Type__c NOT IN : newTTIdList];
	        if (kttjListToDel.size() > 0) {
	        	if(AccessControl.ifObjectIsDeletable('Kit_Transaction_Type_Junction__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
	            delete kttjListToDel;
	        }
	
	        //Database.rollback(sp);
	        return getKitDetails(BPUtility.getEncodedString(kitHeaderToUpsert.Id), BPUtility.getEncodedString('Info'), null, BPUtility.getEncodedString('{}'), BPUtility.getEncodedString(activeOrderPageSortAttrsJSON));
    	}
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
        
    }

    /**
     * Name: getSimilarKits
     * Desc: To get similar Kit Header Records
     * @param:
     * @return: String - get Main JSON data.
     **/
    @remoteAction
    global static String getSimilarKits(String jsonString) {
    	try{
    		jsonString = BPUtility.getDecodedString(jsonString);
    		
    		KitHeader kitHeaderObj = KitHeader.parse(jsonString);
	        Kit_Header__c kitHeaderFilterValue = (Kit_Header__c)setKitHeaderFields(kitHeaderObj);
	        List < Kit_Header__c > kitHeaders = SOQLUtil.getSimilarKits(kitHeaderFilterValue);
	        List < KitHeaderSuggestion > kitHeaderSuggestionList = new List < KitHeaderSuggestion > ();
	        //system.assert(false, kitHeaders);
	
	        for (Kit_Header__c kitHeaderRec : kitHeaders) {
	            if (kitHeaderRec.Code__c == kitHeaderFilterValue.Code__c) {
	                kitHeaderSuggestionList.add(new KitHeaderSuggestion(kitHeaderRec, 1));
	            } else if (kitHeaderRec.Description__c == kitHeaderFilterValue.Description__c) {
	                kitHeaderSuggestionList.add(new KitHeaderSuggestion(kitHeaderRec, 2));
	            } else {
	                kitHeaderSuggestionList.add(new KitHeaderSuggestion(kitHeaderRec, 3));
	            }
	        }
	
	        kitHeaderSuggestionList.sort();
	        Integer listSizeLimit = 15;
	        if (kitHeaderSuggestionList.size() > listSizeLimit) {
	            List < KitHeaderSuggestion > kitHeaderSuggestionLimitedList = new List < KitHeaderSuggestion > ();
	            for (Integer i = 0; i < listSizeLimit; i++) {
	                kitHeaderSuggestionLimitedList.add(kitHeaderSuggestionList[i]);
	            }
	            kitHeaderSuggestionList = new List < KitHeaderSuggestion > ();
	            kitHeaderSuggestionList.addAll(kitHeaderSuggestionLimitedList);
	        }
	        return BPUtility.getEncodedString(System.JSON.serialize(kitHeaderSuggestionList));
    	}
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
        
    }

    /**
     * Name: setKitHeaderFields
     * Desc: Method to set fields of Customer Object
     * @param:  (1) kitHeaderObj - KitHeader - Kit Header Obj
     * @return:  Sobject - Sobject with populated values of Kit Header object
     **/
    private static Sobject setKitHeaderFields(KitHeader kitHeaderObj) {
        Kit_Header__c kitHeaderRec = new Kit_Header__c();

        kitHeaderRec.Code__c = kitHeaderObj.Code;
        kitHeaderRec.Description__c = kitHeaderObj.Description;
        kitHeaderRec.Can_Split__c = kitHeaderObj.CanItSplit;
        kitHeaderRec.Service_Kit__c = kitHeaderObj.IsServiceKit;

        if (kitHeaderObj.Concern.size() == 0) {
            kitHeaderRec.Concern__c = null;
        }
        if (kitHeaderObj.Correction.size() == 0) {
            kitHeaderRec.Correction__c = null;
        }
        if (kitHeaderObj.Cause.size() == 0) {
            kitHeaderRec.Cause__c = null;
        }

        for (String concernStr : kitHeaderObj.Concern) {
            concernStr = (concernStr.contains('\n')) ? concernStr.replaceAll('\n', '') : concernStr;
            if (kitHeaderRec.Concern__c == null) {
                kitHeaderRec.Concern__c = '';
            }
            kitHeaderRec.Concern__c += concernStr + '\n';
        }

        for (String correctionStr : kitHeaderObj.Correction) {
            correctionStr = (correctionStr.contains('\n')) ? correctionStr.replaceAll('\n', '') : correctionStr;
            if (kitHeaderRec.Correction__c == null) {
                kitHeaderRec.Correction__c = '';
            }
            kitHeaderRec.Correction__c += correctionStr + '\n';
        }
        for (String causeStr : kitHeaderObj.Cause) {
            causeStr = (causeStr.contains('\n')) ? causeStr.replaceAll('\n', '') : causeStr;
            if (kitHeaderRec.Cause__c == null) {
                kitHeaderRec.Cause__c = '';
            }
            kitHeaderRec.Cause__c += causeStr + '\n';
        }

        kitHeaderRec.Make__c = kitHeaderObj.MakeId;
        kitHeaderRec.Model__c = kitHeaderObj.ModelId;
        kitHeaderRec.SubModel__c = kitHeaderObj.SubModelId;
        kitHeaderRec.Active__c = kitHeaderObj.IsActive;
        if (kitHeaderObj.Id != null && kitHeaderObj.Id != '') {
            kitHeaderRec.Id = kitHeaderObj.Id;
        }
        return kitHeaderRec;
    }

    /**
     * Name: updateKitHeader
     * Desc: Update Kit header
     * @param:
     * @return: String - get Main JSON data.
     **/
    @remoteAction
    global static String updateKitHeader(String kitHeaderId, String Json, String kitContentPageSortAttrsJSON, String activeOrderPageSortAttrsJSON) {
        try{
        	kitHeaderId = BPUtility.getDecodedString(kitHeaderId);
        	Json = BPUtility.getDecodedString(Json);
        	kitContentPageSortAttrsJSON = BPUtility.getDecodedString(kitContentPageSortAttrsJSON);
        	activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
        	
	        KitHeader kitHeaderObj = KitHeader.parse(Json);
	        Kit_Header__c kitHeaderRec = new Kit_Header__c();
	        kitHeaderRec.Id = kitHeaderObj.Id;
	        kitHeaderRec.Fixed_Price__c = kitHeaderObj.FixedPrice;
	        kitHeaderRec.Fixed_Price_Flag__c = kitHeaderObj.IsFixedPrice;
	        Errorhandler error = validateKitHeader(kitHeaderObj);
	        if (kitHeaderRec.Id != null && error.ResponseCode == '200') {
	        	//if(AccessControl.ifObjectIsAccessible('Kit_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	        	if(AccessControl.ifObjectIsUpdateable('Kit_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	            update kitHeaderRec;
	        }
	        
	        return getKitDetails(BPUtility.getEncodedString(kitHeaderId), BPUtility.getEncodedString(null), error, BPUtility.getEncodedString(kitContentPageSortAttrsJSON), BPUtility.getEncodedString(activeOrderPageSortAttrsJSON));
        }
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
    }

    /**
     * Name: insertKitLineItem
     * Desc: Insert New Kit Line Item from search to add
     * @param:
     * @return: String - get Main JSON data.
     **/

    @remoteAction
    global static String insertKitLineItem(String kitHeaderId, String parenObjId, String kitContentPageSortAttrsJSON, String activeOrderPageSortAttrsJSON) {
    	try{
    		kitHeaderId = BPUtility.getDecodedString(kitHeaderId);
    		parenObjId = BPUtility.getDecodedString(parenObjId);
    		kitContentPageSortAttrsJSON = BPUtility.getDecodedString(kitContentPageSortAttrsJSON);
    		activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
    		
	        String objectName = '';
	        if (parenObjId != null && parenObjId != 'Customer' && parenObjId != 'Vendor' && !parenObjId.contains('__c')) {
	            objectName = (Id.valueOf(parenObjId)).getSObjectType().getDescribe().getName();
	        } else {
	        	return BPUtility.getEncodedString('{}');
	        }
			
	        Kit_Header_Line_Item__c kitLineItemToInsert = new Kit_Header_Line_Item__c();
	        kitLineItemToInsert.Kit_Header__c = kitHeaderId;
	        if (objectName == Constants.NAMESPACE + 'Part__c') {
	            kitLineItemToInsert.Part__c = parenObjId;
	        } else if (objectName == Constants.NAMESPACE + 'Labour_Code__c') {
	            kitLineItemToInsert.Labour_Code__c = parenObjId;
	            if(AccessControl.ifObjectIsAccessible('Labour_Code__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	            parenObjId = BPUtility.escapeSingleQuotes(parenObjId);
	            List<Labour_Code__c> labourCodeList = [select Fixed_Rate__c from Labour_Code__c where Id =: parenObjId AND Fixed_Rate__c = true];
	            if(labourCodeList.size() > 0) {
	            	kitLineItemToInsert.Fixed_Price__c = true;
	            }
	        }
	        
	        Errorhandler error = validateKitLineItemOnInsert(kitHeaderId, kitLineItemToInsert);
	        if (kitLineItemToInsert.Kit_Header__c != null && error.ResponseCode == '200') {
	        	//if(AccessControl.ifObjectIsAccessible('Kit_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	        	//if(AccessControl.ifObjectIsCreateable('Kit_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	        	if(AccessControl.ifObjectIsCreateable('Kit_Header_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	        	
	            insert kitLineItemToInsert;
	        }
	
	        return getKitDetails(BPUtility.getEncodedString(kitHeaderId), BPUtility.getEncodedString(null), error, BPUtility.getEncodedString(kitContentPageSortAttrsJSON), BPUtility.getEncodedString(activeOrderPageSortAttrsJSON));
    	}
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}');
    }

    /**
     * Name: removeKitLineItem
     * Desc: Remove Kit Line Item
     * @param:
     * @return: String - get Main JSON data.
     **/
    @remoteAction
    global static String removeKitLineItem(String kitLineItemId, String kitHeaderId, String kitContentPageSortAttrsJSON, String activeOrderPageSortAttrsJSON) {
    	try{
    		kitLineItemId = BPUtility.getDecodedString(kitLineItemId);
    		kitHeaderId = BPUtility.getDecodedString(kitHeaderId);
    		kitContentPageSortAttrsJSON = BPUtility.getDecodedString(kitContentPageSortAttrsJSON);
    		activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
    		
    		if(AccessControl.ifObjectIsAccessible('Kit_Header_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		kitLineItemId = BPUtility.escapeSingleQuotes(kitLineItemId);
    		List < Kit_Header_Line_Item__c > kitLineItemList = [select Id from Kit_Header_Line_Item__c where Id =  : kitLineItemId];
	        if (kitLineItemList.size() > 0) {
	        	if(AccessControl.ifObjectIsDeletable('Kit_Header_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
	            delete kitLineItemList;
	        }
	        return getKitDetails(BPUtility.getEncodedString(kitHeaderId), BPUtility.getEncodedString(null), null, BPUtility.getEncodedString(kitContentPageSortAttrsJSON), BPUtility.getEncodedString(activeOrderPageSortAttrsJSON));
    	}
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
        
    }

    /**
     * Name: removeKitLineItem
     * Desc: Remove Kit Line Item
     * @param:
     * @return: String - get Main JSON data.
     **/
    @remoteAction
    global static String updateKitLineItem(String jsonString, String kitHeaderId, String kitContentPageSortAttrsJSON, String activeOrderPageSortAttrsJSON) {
    	try{
    		jsonString = BPUtility.getDecodedString(jsonString);
    		kitHeaderId = BPUtility.getDecodedString(kitHeaderId);
    		kitContentPageSortAttrsJSON = BPUtility.getDecodedString(kitContentPageSortAttrsJSON);
    		activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
    		
    		KitHeaderLineItem kitLineItemObj = (KitHeaderLineItem) System.JSON.deserialize(jsonString, KitHeaderLineItem.class);
	        Kit_Header_Line_Item__c kitLineItemRec = new Kit_Header_Line_Item__c();
	        kitLineItemRec.Id = kitLineItemObj.Id;
	        kitLineItemRec.Fixed_Price__c = kitLineItemObj.IsFixedPrice;
	        kitLineItemRec.Qty_Needed__c = kitLineItemObj.QtyNeeded;
	        kitLineItemRec.Kit_Price__c = kitLineItemObj.KitPrice;
	        
	        Errorhandler error = validateKitLineItemOnUpdate(kitHeaderId, kitLineItemObj);
	        if (kitHeaderId != null && error.ResponseCode == '200') {
	        	if(AccessControl.ifObjectIsUpdateable('Kit_Header_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	            update kitLineItemRec;
	        }
	        
	        return getKitDetails(BPUtility.getEncodedString(kitHeaderId), BPUtility.getEncodedString(null), error, BPUtility.getEncodedString(kitContentPageSortAttrsJSON), BPUtility.getEncodedString(activeOrderPageSortAttrsJSON));
    	}
       	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}'); 
        
    }
    
    /**
     * Name: validateKitHeader
     * Desc: Validate kit Header record being updated here
     * @param: KitHeader kitHeaderObj
     * @return: Errorhandler response result by validation
     **/
    private static Errorhandler validateKitHeader(KitHeader kitHeaderObj) {
       try{
        List<Kit_Header__c> khList = SOQLUtil.getKitHeaderRec(new Map<String, String> { 'Id' => kitHeaderObj.Id });
        Kit_Header__c databseKHRecoord = (khList.size() > 0) ? khList[0] : null;
        
        String errorMessage = '';
        if (databseKHRecoord != null) {
            Integer countUnfixedLineItems = 0;
            Decimal totalFixedPrice = 0;
            
            // 1. If Kit header fixed price checkbox is set to false, then there is no need to check validations as price is always total of line items here
            // 2. Else Kit header fixed price checkbox is set to true, then valid conditions are:
            //      A) Kit header does not have any kit line items in database
            //      B) Total price of fixed price line items should be less than or equal to Kit header fixed price
            //      C) there should be atleast 1 kit line with fixed price set to false
            if(kitHeaderObj.IsFixedPrice && databseKHRecoord.Kit_Header_Line_Items__r != null){
                for (Kit_Header_Line_Item__c khLineItemRec : databseKHRecoord.Kit_Header_Line_Items__r) {
                    if (!khLineItemRec.Fixed_Price__c) {
                        countUnfixedLineItems++;
                    } else {
                        totalFixedPrice += khLineItemRec.Total__c;
                    }
                }
                
                if(kitHeaderObj.FixedPrice == totalFixedPrice && countUnfixedLineItems == 0){
                    errorMessage = '';
                } else if(kitHeaderObj.FixedPrice != totalFixedPrice && countUnfixedLineItems == 0){
                    errorMessage = Label.Kit_Header_Less_fixed_price_amount;
                } else if(countUnfixedLineItems == 0) {
                    errorMessage = Label.Kit_Header_No_unfixed_Line_Items;
                }
            }
        }
        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
       }catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return new Errorhandler('300', 'Exception');
    	}
    }
    
    /**
     * Name: validateKitLineItemOnInsert
     * Desc: Validate kit Line Item record being inserted here
     * @param: Id kitHeaderId, Kit_Header_Line_Item__c khliNew
     * @return: Errorhandler response result by validation
     **/
    private static Errorhandler validateKitLineItemOnInsert(Id kitHeaderId, Kit_Header_Line_Item__c khliNew) {
    	try{
	        List<Kit_Header__c> khList = SOQLUtil.getKitHeaderRec(new Map<String, String> { 'Id' => kitHeaderId });
	        Kit_Header__c databseKHRecoord = (khList.size() > 0) ? khList[0] : null;
	        
	        String errorMessage = '';
	        if (databseKHRecoord != null) {
	            Decimal totalFixedPrice = 0;
	            
	            // 1. If Kit header fixed price checkbox is set to false, then there is no need to check validations as price is always total of line items here
	            // 2. Else Kit header fixed price checkbox is set to true, then valid conditions are:
	            //      A) Total price of fixed price line items should be less than or equal to Kit header fixed price
	            if(databseKHRecoord.Fixed_Price_Flag__c && databseKHRecoord.Kit_Header_Line_Items__r != null){
	                for (Kit_Header_Line_Item__c khLineItemRec : databseKHRecoord.Kit_Header_Line_Items__r) {
	                    if (khLineItemRec.Fixed_Price__c) {
	                        totalFixedPrice += khLineItemRec.Total__c;
	                    }
	                }
	                
	                if(databseKHRecoord.Fixed_Price__c > totalFixedPrice && khliNew.Fixed_Price__c){
	                    errorMessage = Label.Kit_Line_Item_Exceeded_Total_Price;
	                } else if(databseKHRecoord.Fixed_Price__c < totalFixedPrice){
	                    errorMessage = Label.Kit_Header_Less_fixed_price_amount;
	                }
	            }
	        }
	        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return  new Errorhandler('300', 'Exception');
    	} 
    }
    
    /**
     * Name: validateKitLineItemOnUpdate
     * Desc: Validate kit Line Item record being updated here
     * @param: KitHeader kitHeaderObj
     * @return: Errorhandler response result by validation
     **/
    private static Errorhandler validateKitLineItemOnUpdate(Id kitHeaderId, KitHeaderLineItem khliNew) {
    	try{
	        List<Kit_Header__c> khList = SOQLUtil.getKitHeaderRec(new Map<String, String> { 'Id' => kitHeaderId });
	        Kit_Header__c databseKHRecoord = (khList.size() > 0) ? khList[0] : null;
	        
	        String errorMessage = '';
	        if (databseKHRecoord != null) {
	            Integer countUnfixedLineItems = 0;
	            Decimal totalFixedPrice = 0;
	            
	            // 1. If Kit header fixed price checkbox is set to false, then there is no need to check validations as price is always total of line items here
	            // 2. Else Kit header fixed price checkbox is set to true, then valid conditions are:
	            //      A) Total price of fixed price line items should be less than or equal to Kit header fixed price
	            //      B) there should be atleast 1 kit line with fixed price set to false
	            if(databseKHRecoord.Fixed_Price_Flag__c && databseKHRecoord.Kit_Header_Line_Items__r != null){
	                for (Kit_Header_Line_Item__c khLineItemRec : databseKHRecoord.Kit_Header_Line_Items__r) {
	                    // Update current updating record
	                    if(khLineItemRec.Id == khliNew.Id){
	                        khLineItemRec.Fixed_Price__c = khliNew.IsFixedPrice;
	                        khLineItemRec.Qty_Needed__c = khliNew.QtyNeeded;
	                        khLineItemRec.Kit_Price__c = khliNew.KitPrice;
	                    }
	                    
	                    if (!khLineItemRec.Fixed_Price__c) {
	                        countUnfixedLineItems++;
	                    } else {
	                        totalFixedPrice += khLineItemRec.Qty_Needed__c * khLineItemRec.Kit_Price__c;
	                    }
	                }
	                
	                if(totalFixedPrice <= databseKHRecoord.Fixed_Price__c && countUnfixedLineItems != 0){
	                    errorMessage = '';
	                } else if(totalFixedPrice > databseKHRecoord.Fixed_Price__c){
	                    errorMessage = Label.Kit_Line_Item_Exceeded_Total_Price;
	                } else if(countUnfixedLineItems == 0) {
	                    errorMessage = Label.Kit_Line_Item_No_Unfixed_Line_Item;
	                }
	            }
	        }
	        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return  new Errorhandler('300', 'Exception');
    	} 
    }

    public static List < String > getKitLineItemFields() {
        List < String > kitLineItemFields = new List < String > {
            'Item_Desc__c',
            'Part__c',
            'Part__r.AvailableParts__c',
            'Qty_Needed__c',
            'Retail_Price__c',
            'Kit_Price__c',
            'Total__c',
            'Labour_Code__c',
            'Labour_Code__r.Fixed_Rate__c',
            'Fixed_Price__c'
        };

        return kitLineItemFields;
    }
    
    public static List<ViewKitCtrl.ActiveOrder> getPaginatedRecords(List<ViewKitCtrl.ActiveOrder> allrecords, Integer currentPage, integer pageSize) {
    	List<ViewKitCtrl.ActiveOrder> objRecords = new List<ViewKitCtrl.ActiveOrder>();
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
    
    public class KitHeaderWrapper {
        public KitHeader KitHeaderRec;
        public List < KitHeaderLineItem > KitHeaderLineItemList;
        public List<ViewKitCtrl.ActiveOrder> ActiveOrderList;
        public Errorhandler ResponseDetails;
        public Integer TotalLineItem;
        public Integer TotalActiveOrder;
       

        public KitHeaderWrapper(Kit_Header__c kitHeaderRec, List<Kit_Header_Line_Item__c> khLineItemList, List<Service_Order_Kit_Header__c> sokhList, Errorhandler error,
        										 PaginationSorting activeOrderPageSortAttrs, List<CO_Line_Item__c> coliList) {
            this.KitHeaderRec = new KitHeader(kitHeaderRec);
            this.KitHeaderLineItemList = new List < KitHeaderLineItem > ();
            for (Kit_Header_Line_Item__c khliRec : khLineItemList) {
                this.KitHeaderLineItemList.add(new KitHeaderLineItem(khliRec));
            }
            
            this.ActiveOrderList = new List<ViewKitCtrl.ActiveOrder>();
            Set<Id> coHeaderIdSet = new Set<Id>();
            for(Service_Order_Kit_Header__c sokhRec : sokhList) {
                if(sokhRec.Service_Order_Header__c == null || sokhRec.Service_Order_Header__r.CO_Header__c == null) {
                    continue;
                }
                
                if(!coHeaderIdSet.contains(sokhRec.Service_Order_Header__r.CO_Header__c) && sokhRec.Service_Order_Header__r.CO_Header__r.Order_status__c == 'Open') {
                    this.ActiveOrderList.add(new ViewKitCtrl.ActiveOrder(sokhRec));
                    coHeaderIdSet.add(sokhRec.Service_Order_Header__r.CO_Header__c);
                }
            }
            
             for(CO_Line_Item__c coli : colilist) {
                if(!coHeaderIdSet.contains(coli.CO_Header__c) && coli.CO_Header__r.Order_status__c == 'Open') {
                    this.ActiveOrderList.add(new ViewKitCtrl.ActiveOrder(coli));
                    coHeaderIdSet.add(coli.CO_Header__c);
                }
            }
            this.TotalActiveOrder = this.ActiveOrderList.size();
            this.ActiveOrderList = getPaginatedRecords(this.ActiveOrderList, activeOrderPageSortAttrs.CurrentPage, activeOrderPageSortAttrs.PageSize);
            
            ResponseDetails = (error != null) ? new Errorhandler(error) : new Errorhandler('200', 'Success');
        }
        
        public KitHeaderWrapper(Errorhandler error){
            ResponseDetails = new Errorhandler(error);
        }
    }
    
    public class KitHeaderLineItem {
        public String ItemDesc;
        public String Status;
        public Decimal QtyNeeded;
        public Decimal ReatilPrice;
        public Decimal KitPrice;
        public Decimal TotalPrice;
        public Boolean IsFixedPrice;
        public Decimal AvailableParts;
        public String Id;
        public Boolean isPart;
        public String partId;

        public KitHeaderLineItem(Kit_Header_Line_Item__c khLineItemRec) {
            this.ItemDesc = khLineItemRec.Item_Desc__c;
            if (khLineItemRec.Part__c != null) {
                if (khLineItemRec.Part__r.AvailableParts__c > 0) {
                    this.Status = 'In Stock';
                } else {
                    this.Status = 'Out of Stock';
                }
            } else {
                this.Status = '';
            }

            this.QtyNeeded = khLineItemRec.Qty_Needed__c;
            this.ReatilPrice = khLineItemRec.Retail_Price__c;
            this.KitPrice = khLineItemRec.Kit_Price__c;
            this.TotalPrice = khLineItemRec.Total__c;
            this.IsFixedPrice = khLineItemRec.Fixed_Price__c;
            this.Id = khLineItemRec.Id;
            if(khLineItemRec.Part__c != null) {
                this.AvailableParts = khLineItemRec.Part__r.AvailableParts__c;
                this.isPart = true;
                this.partId = khLineItemRec.Part__c; 
            }else{
            	this.isPart = false;
            }
        }
    }
    
    // error handling class
    global class Errorhandler {
        public string ResponseCode;
        public string ResponseMeassage;
        
        public Errorhandler(string ResponseCode, string ResponseMeassage){
            this.ResponseCode = ResponseCode;
            this.ResponseMeassage = ResponseMeassage;
        }
        
        public Errorhandler(Errorhandler errorHandler){
            this.ResponseCode = errorHandler.ResponseCode;
            this.ResponseMeassage = errorHandler.ResponseMeassage;
        }
    }
    
    public class ActiveOrder {
        
        public String COHeaderNumber;
        public String COHeaderId;
        public String CustomerName;
        public String OwnerName;
        public String Status; 
        
        public ActiveOrder(Service_Order_Kit_Header__c sokhRec) {
            this.COHeaderNumber = sokhRec.Service_Order_Header__r.CO_Header__r.Name;
            this.COHeaderId = sokhRec.Service_Order_Header__r.CO_Header__c;
            this.CustomerName = (sokhRec.Service_Order_Header__r.CO_Header__r.Customer__c != null) ? sokhRec.Service_Order_Header__r.CO_Header__r.Customer__r.Name : null;
            this.OwnerName = (sokhRec.Service_Order_Header__r.CO_Header__r.Owner__c != null) ? sokhRec.Service_Order_Header__r.CO_Header__r.Owner__r.Name : null;
            this.Status = sokhRec.Service_Order_Header__r.CO_Header__r.Order_status__c;
        }
        
         public ActiveOrder(CO_Line_Item__c coli) {
            this.COHeaderNumber = coli.CO_Header__r.Name;
            this.COHeaderId = coli.CO_Header__c;
            this.CustomerName = (coli.CO_Header__r.Customer__c != null) ? coli.CO_Header__r.Customer__r.Name : null;
            this.OwnerName = (coli.CO_Header__r.Owner__c != null) ? coli.CO_Header__r.Owner__r.Name : null;
            this.Status = coli.CO_Header__r.Order_status__c;
        }
    }
}