/**
* Author: Tarun Khandelwal
* Since: March 13, 2015
* Name: CustomerOrderCtrl
* Description: Apex class which contains all remoted methods related to Customer Order Page.
**/
global with sharing class CustomerOrderCtrl {
    public static SO_KLI_Recalculation.Errorhandler error;
    
    public Decimal Home_Search_Grid_Page_Size { get{return GeneralConfiguration.getHomeSearchGridPageSize();} private set;}
    public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
    public boolean Is_Widget_Removeable {get{return GeneralConfiguration.isWidgetRemoveable();}}
    public boolean Load_New_Customer_Order {get{return GeneralConfiguration.isLoadNewCustomerOrder();} private set;}
    public boolean Load_New_UI {get{return GeneralConfiguration.isLoadNewUI();} private set;}
    public boolean Load_New_View_Customer {get{return GeneralConfiguration.isLoadNewViewCustomer();} private set;}
    public Decimal Sales_Tax_Rate {get{return GeneralConfiguration.getAustralianMarketSalesTaxRate();} private set;}

    private static final String USE_DEPOSIT =  'Use Deposit';

    /**
     * Name: getSearchResults
     * Desc: Method which gives records according to the search critaria
     * @param:  (1) JSONString - String - JSON String of searched Value
     * @return: String - JSON String of searched records
    **/
    @RemoteAction
    global static String getSearchResults(String JSONString) {
        // Parse the search JSON for object label and searc string
        JSONString = BPUtility.getDecodedString(JSONString);
        SearchSuggestionJSON.QueryJSON searchQueryJSON = SearchSuggestionJSON.parseQuery(JSONString);
        String searchJSONString = '';
        try{
            searchJSONString = SearchSuggestionUtil.getSearchSuggestionJSON(searchQueryJSON);
        }catch(Exception e){
            return BPUtility.getEncodedString('');


        }
        return BPUtility.getEncodedString(searchJSONString);
    }
 
    /**
    * Name: getRecordById
    * Desc: Method which gives Sobject Record By its Id
    * @param:  (1) recordId - String - record Id 
    * @return: String - JSON String of searched records
    **/
    @RemoteAction
    global static String getRecordById(String recordId){
    	recordId = BPUtility.getDecodedString(recordId);
        try{
            String objectName = String.valueOf(Id.valueOf(recordId).getSobjectType());
            Map<String, String> objectFieldsToJsonMap;
            Map<String, String> objectFieldsToDataTypeMap;
            if(objectName == 'Account') {
                objectFieldsToJsonMap = Constants.CUSTOMER_FIELDS_TO_JSON_MAPPING;
                objectFieldsToDataTypeMap = Constants.CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING;
            } else if(objectName == 'User') {
                objectFieldsToJsonMap = Constants.USER_FIELDS_TO_JSON_MAPPING;
                objectFieldsToDataTypeMap = Constants.USER_FIELDS_TO_DATA_TYPE_MAPPING;
            }
            List<Sobject> sobjectRecords = SOQLUtil.getRecordById(new List<String>{recordId}, objectFieldsToJsonMap, objectName);
            return BPUtility.getEncodedString(Utility.createJSON(sobjectRecords, objectFieldsToJsonMap, objectFieldsToDataTypeMap, new List<Sobject>(), new map<String, String>(), new map<String, String>()));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }

    /**
    * Name: getPartDetails
    * Desc: Method which gives a part detail as per part Id
    * @param:  (1) partId - String - Id for the part record
    * @return: String - JSON String of part detail
    **/
    @RemoteAction
    global static String getPartDetails(String partId){
    	partId = BPUtility.getDecodedString(partId);
        try{
            List<Part__c> partRecords = SOQLUtil.getPartRecord(new List<Id>{partId});
            if(partRecords.size() == 0){
                return BPUtility.getEncodedString('');


            }
            Part partDetail = new Part(partRecords[0]);
            return BPUtility.getEncodedString(System.JSON.serialize(partDetail));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }

    /**
    * Name: getCOHeaderDetails
    * Desc: Method to get json string of All parameters used in Customer Order Page
    * @param:  (1) coHeaderId - String - Id of CO Header Record
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction  
    global static String getCOHeaderDetails(String coHeaderId){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }

            List<CO_Header__c> coHeaderRec = SOQLUtil.getCOHeaderDetails(coHeaderId) ;
            List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeaderId);
            List<CO_Kit_Header__c> coKitHeaders = SOQLUtil.getCOKHByCOHeaderId(coHeaderId);
            List<Vendor_Order_Line_Item__c> specialOrders = SOQLUtil.getSpecialOrderByCOHeaderId(coHeaderId);   
            List<User> currentUser = SOQLUtil.getCurrentUserInfo();
            List<CO_Deposit__c> coDeposits = SOQLUtil.getCODepositByCOHeaderId(coHeaderId);
            List<CO_Invoice_Header__c> coInvoiceHeaders = SOQLUtil.getCOInvoiceHeaderByCOHeaderId(coHeaderId);     
            List<CO_Invoice_Payment__c> coInvoicePayments = new List<CO_Invoice_Payment__c>();
            List<CO_Invoice_Item__c> coInvoiceItems = new List<CO_Invoice_Item__c>();
            List<CO_Invoice_Header__c> closedCOInvoiceHeaders = SOQLUtil.getInvoiceHistory(coHeaderId);
            
            List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
            if(coHeaderRec.size() > 0 && coHeaderRec[0].Customer__c != null) {
                couRecords = SOQLUtil.getCOUListByCustomerId(coHeaderRec[0].Customer__c);
            }
            
            if(coLineItems == null) {
                coLineItems = new List<CO_Line_Item__c>();
            }
            if(coDeposits == null) {
                coDeposits = new List<CO_Deposit__c>();
            }
            if(coInvoiceHeaders == null) {
                coInvoiceHeaders = new List<CO_Invoice_Header__c>();
            } else if(coInvoiceHeaders.size() > 0) {
                coInvoicePayments = SOQLUtil.getCOInvoicePaymentsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
                coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
            }
            
            List<Id> vendorIdList = new List<Id>();
            for(CO_Line_Item__c coLineItemRec : coLineItems) {
                if(coLineItemRec.Part__r != null && coLineItemRec.Part__r.Vendor__c != null) {
                    vendorIdList.add(coLineItemRec.Part__r.Vendor__c);
                }
            }
            
            List<Vendor_Order_Header__c> voHeaderList = SOQLUtil.getVOHeaderByFieldName(new Map<String, List<String>>{'Vendor__c'=> vendorIdList});
            Map<Id, List<Vendor_Order_Header__c>> vendorIdToVOHeadesListMap = new Map<Id, List<Vendor_Order_Header__c>>();
            List<Vendor_Order_Header__c> voHeadersList;
            
            for(Vendor_Order_Header__c voHeaderRec : voHeaderList) {
                if(!vendorIdToVOHeadesListMap.containsKey(voHeaderRec.Vendor__c)) {
                    voHeadersList = new List<Vendor_Order_Header__c>();
                } else {
                    voHeadersList = vendorIdToVOHeadesListMap.get(voHeaderRec.Vendor__c);
                }
                voHeadersList.add(voHeaderRec);
                vendorIdToVOHeadesListMap.put(voHeaderRec.Vendor__c, voHeadersList);
            }

            COHeaderWrapper coHeaderWrapperObj;
            if(coHeaderRec.size() > 0) {
                coHeaderWrapperObj = new COHeaderWrapper(coHeaderRec[0], coLineItems, coKitHeaders, currentUser[0].LocaleSidKey, coDeposits, coInvoiceHeaders, 
                                                            coInvoicePayments, coInvoiceItems, closedCOInvoiceHeaders, vendorIdToVOHeadesListMap, couRecords, specialOrders);
            }
            if(coHeaderRec.size() > 0 && coHeaderRec[0].Owner__c == currentUser[0].Id){
                CO_Header__c currentCOHeader = new CO_Header__c(Id = coHeaderId);
                currentCOHeader.Owner_Last_Visited__c = System.now();
                update currentCOHeader;
                
            }
            return BPUtility.getEncodedString(System.JSON.serialize(coHeaderWrapperObj));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
    /**
    * Name: getCOHeaderDetailsByGridName
    * Desc: Method to get json string of All parameters used in Customer Order Page
    * @param:  (1) coHeaderId - String - Id of CO Header Record 
               (2) gridName - String - name of grid
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction 
    global static String getCOHeaderDetailsByGridName(String coHeaderId, String gridName){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	gridName = BPUtility.getDecodedString(gridName);
        try{            
            List<CO_Header__c> coHeaderRec = new List<CO_Header__c>();
            List<CO_Line_Item__c> coLineItems = new List<CO_Line_Item__c>();
            List<CO_Kit_Header__c> coKitHeaders = new List<CO_Kit_Header__c>();
            List<Vendor_Order_Line_Item__c> specialOrders = new List<Vendor_Order_Line_Item__c>();
            List<User> currentUser = new List<User>();
            List<CO_Deposit__c> coDeposits = new List<CO_Deposit__c>();
            List<CO_Invoice_Header__c> coInvoiceHeaders = new List<CO_Invoice_Header__c>();
            List<CO_Invoice_Payment__c> coInvoicePayments = new List<CO_Invoice_Payment__c>();
            List<CO_Invoice_Item__c> coInvoiceItems = new List<CO_Invoice_Item__c>();
            List<CO_Invoice_Header__c> closedCOInvoiceHeaders = new List<CO_Invoice_Header__c>();
            List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
            if(gridName == null || gridName.contains('coHeader')) {
                coHeaderRec = SOQLUtil.getCOHeaderDetails(coHeaderId) ;
            }
            if(gridName == null || gridName.contains('coLineItem')) {
                coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeaderId);
                coKitHeaders = SOQLUtil.getCOKHByCOHeaderId(coHeaderId);
            }
            
            if(gridName == null || gridName.contains('specialOrder')) {
                specialOrders = SOQLUtil.getSpecialOrderByCOHeaderId(coHeaderId);
            }
            if(gridName == null ||  gridName.contains('user')) {
                currentUser = SOQLUtil.getCurrentUserInfo();
            }
            if(gridName == null ||  gridName.contains('coDeposit')) {
                coDeposits = SOQLUtil.getCODepositByCOHeaderId(coHeaderId);
            }
            if(gridName == null || gridName.contains('coInvoiceHeader')) {
                coInvoiceHeaders = SOQLUtil.getCOInvoiceHeaderByCOHeaderId(coHeaderId);
            }
            if(gridName == null || gridName.contains('closedCOInvoiceHeader')) {
                closedCOInvoiceHeaders = SOQLUtil.getInvoiceHistory(coHeaderId);
            }
            if(gridName == null || gridName.contains('cou')) {
                if(coHeaderRec.size() > 0 && coHeaderRec[0].Customer__c != null) {
                    couRecords = SOQLUtil.getCOUListByCustomerId(coHeaderRec[0].Customer__c);
                }
            }
            
            
            if(coInvoiceHeaders.size() > 0) {
                coInvoicePayments = SOQLUtil.getCOInvoicePaymentsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
                coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
            }
            
            Map<Id, List<Vendor_Order_Header__c>> vendorIdToVOHeadesListMap = new Map<Id, List<Vendor_Order_Header__c>>();
            if(gridName == null || gridName.contains('coLineItem')) {
                List<Id> vendorIdList = new List<Id>();
                for(CO_Line_Item__c coLineItemRec : coLineItems) {
                    if(coLineItemRec.Part__r != null && coLineItemRec.Part__r.Vendor__c != null) {
                        vendorIdList.add(coLineItemRec.Part__r.Vendor__c);
                    }
                }
                List<Vendor_Order_Header__c> voHeaderList = SOQLUtil.getVOHeaderByFieldName(new Map<String, List<String>>{'Vendor__c'=> vendorIdList});
                List<Vendor_Order_Header__c> voHeadersList;
                
                for(Vendor_Order_Header__c voHeaderRec : voHeaderList) {
                    if(!vendorIdToVOHeadesListMap.containsKey(voHeaderRec.Vendor__c)) {
                        voHeadersList = new List<Vendor_Order_Header__c>();
                    } else {
                        voHeadersList = vendorIdToVOHeadesListMap.get(voHeaderRec.Vendor__c);
                    }
                    voHeadersList.add(voHeaderRec);
                    vendorIdToVOHeadesListMap.put(voHeaderRec.Vendor__c, voHeadersList);
                }
            }
            
            COHeaderWrapper coHeaderWrapperObj;
            if(coHeaderRec.size() > 0) {
                coHeaderWrapperObj = new COHeaderWrapper(coHeaderRec[0], coLineItems, coKitHeaders, currentUser[0].LocaleSidKey, coDeposits, coInvoiceHeaders, 
                                                            coInvoicePayments, coInvoiceItems, closedCOInvoiceHeaders, vendorIdToVOHeadesListMap, couRecords, specialOrders);
            } else {
                coHeaderWrapperObj = new COHeaderWrapper(null, coLineItems, coKitHeaders, currentUser[0].LocaleSidKey, coDeposits, coInvoiceHeaders, 
                                                            coInvoicePayments, coInvoiceItems, closedCOInvoiceHeaders, vendorIdToVOHeadesListMap, couRecords, specialOrders);
            }
            //system.assert(false, coHeaderWrapperObj);   
            return BPUtility.getEncodedString(System.JSON.serialize(coHeaderWrapperObj));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    

    /**
    * Name: getSOHeaderDetails
    * Desc: Method to get json string related to Service Header Order
    * @param:  (1) coHeaderId - String - Id of CO Header Record
               (2) gridName - String - name of grid
    * @return: String - JSON String of SO Header Detail Record
    **/
    @RemoteAction 
    global static String getSOHeaderDetails(String coHeaderId, String gridName){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	gridName = BPUtility.getDecodedString(gridName);
        try{
            List<Service_Order_Header__c> soHeaderRecList = new List<Service_Order_Header__c>();
            List<Service_Order_Kit_Header__c> soKitHeaderList = new List<Service_Order_Kit_Header__c>();
            List<CO_Invoice_Header__c> coInvoiceHeaders = new List<CO_Invoice_Header__c>();
            List<CO_Invoice_Item__c> coInvoiceItems = new List<CO_Invoice_Item__c>();
            List<Vendor_Order_Line_Item__c> specialOrders = new List<Vendor_Order_Line_Item__c>();
            List<CO_Line_Item__c> coLineItems = new List<CO_Line_Item__c>();
            
            Map<Id, List<Service_Order_Line_Item__c>> soHeaderIdToSOLIListMap = new Map<Id, List<Service_Order_Line_Item__c>>();
            Map<Id, List<Service_Order_Kit_Header__c>> soHeaderIdToSOKHListMap = new Map<Id, List<Service_Order_Kit_Header__c>>();
            
            List<String> pinItems = new List<String>();
            
            if(gridName == null || gridName.contains('soHeader')) {
                soHeaderRecList = SOQLUtil.getSODetailsByFieldName(new Map<String, String>{'CO_Header__c' => coHeaderId});
            }
            //system.assert(false, soHeaderRecList);
            
            if(gridName == null || gridName.contains('pinItems')) {
                List<User> currentUserInfo = SOQLUtil.getCurrentUserInfo();
                if(currentUserInfo.size() > 0 && currentUserInfo[0].SO_Pinned_Info__c != null) {
                    pinItems = currentUserInfo[0].SO_Pinned_Info__c.split(',');
                }
            }
            
            Map<Id, List<Service_Order_Kit_Header__c>> soHeaderIdToSOKIListMap = new Map<Id, List<Service_Order_Kit_Header__c>>();
            
            if(gridName == null || gridName.contains('soItemGrid')) {
                soKitHeaderList = SOQLUtil.getSOKitHeaderByFieldName(new Map<String, String>{'Service_Order_Header__r.CO_Header__c' => coHeaderId});
                for(Service_Order_Kit_Header__c soKitHeaderRec : soKitHeaderList) {
                    List<Service_Order_Kit_Header__c> sokhList;
                    if(!soHeaderIdToSOKIListMap.containsKey(soKitHeaderRec.Service_Order_Header__c)) {
                        sokhList = new List<Service_Order_Kit_Header__c>();
                    } else {
                        sokhList = soHeaderIdToSOKIListMap.get(soKitHeaderRec.Service_Order_Header__c);
                    }
                    sokhList.add(soKitHeaderRec);
                    soHeaderIdToSOKIListMap.put(soKitHeaderRec.Service_Order_Header__c, sokhList);
                }
            }
            
            if(gridName == null || gridName.contains('checkOut')) {
                coInvoiceHeaders = SOQLUtil.getCOInvoiceHeaderByCOHeaderId(coHeaderId);
                if(coInvoiceHeaders.size() > 0) {
                    coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
                }
            }
            
            if(gridName == null || gridName.contains('specialOrder')) {
                specialOrders = SOQLUtil.getSpecialOrderByCOHeaderId(coHeaderId);
            }
            
            SOHeaderWrapper soHeaderObj = new SOHeaderWrapper(soHeaderRecList, pinItems, soHeaderIdToSOKIListMap, coInvoiceHeaders, coInvoiceItems, specialOrders);
            //system.assert(false, soHeaderObj);
            system.debug('###############\n\n' + soHeaderObj.SOList);
            return BPUtility.getEncodedString(System.JSON.serialize(soHeaderObj));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


         
    }
      /*
      *Name : getVendorOrderByVendorId
    * Desc : get vendor by id of the vendor
    * param : vendorId- String - id of vendor
    * return : Json  string list of vendor order
    */
     @RemoteAction 
    global static String getVendorOrderByVendorId(string vendorId){
    	vendorId = BPUtility.getDecodedString(vendorId);
        try{
            List<Vendor_Order_Header__c> voHeaderList = SOQLUtil.getVOHeaderByFieldId(new Map<String, String> {'Vendor__c'=> vendorId} );
            List<Map<String, String>> vendorOrderListToJSON = new List<Map<String, String>>();
            
            for(Vendor_Order_Header__c voHeaderRec :  voHeaderList){
                Map<String, String> voJsonMap = new Map<String, String>();
                voJsonMap.put('VOId',voheaderrec.Id);
                voJsonMap.put('VOName',voheaderrec.Name);
                vendorOrderListToJSON.add(voJsonMap);
            }
            return BPUtility.getEncodedString(System.JSON.serialize(vendorOrderListToJSON)); 
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString(''); 


     } 
     
    
    /**
    * Name: getSOMasterData
    * Desc: Method to get json string related to Service Header Order
    * @param:  (1) coHeaderId - String - Id of CO Header Record
    * @return: String - JSON String of SO Header Detail Record
    **/
    @RemoteAction 
    global static String getSOMasterData(String coHeaderId) {
    	if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            List<CO_Header__c> coHeaderRec = SOQLUtil.getCOHeaderDetails(coHeaderId);
            List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
            
            if(coHeaderRec.size() > 0 && coHeaderRec[0].Customer__c != null) {
                couRecords = SOQLUtil.getCOUListByCustomerId(coHeaderRec[0].Customer__c);
            }
            
            List<Transaction_Type__c> ttList = SOQLUtil.getTransactionTypesWithProvider(new List<Id>());
            List<Account> providerList = SOQLUtil.getProviderList();
            List<Category__c> internalDefaultCategoryList = [select Id, Name, Default__c from Category__c where Type__c = 'Internal Expense' AND Default__c = true];
            
            SOHeaderWrapper.SOMasterData masterDateObj = new SOHeaderWrapper.SOMasterData(ttList, couRecords, providerList, internalDefaultCategoryList);
            return BPUtility.getEncodedString(System.JSON.serialize(masterDateObj));  
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: saveSOHeaderInfo
    * Desc: Method Which saves CO Line Items in Database 
    * @param:   (1) coHeaderId - String - CO Header record Id
    *           (2) jSONString - String - JSON String of CO Line Items
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction
    global static String saveSOHeaderInfo(String coHeaderId, String jSONString) {
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	jSONString = BPUtility.getDecodedString(jSONString);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            //System.assert(false, 'abc');
            SOHeaderWrapper.SOHeader soHeaderObj = (SOHeaderWrapper.SOHeader) System.JSON.deserialize(jSONString, SOHeaderWrapper.SOHeader.class);
            Service_Order_Header__c soHeaderRec = new Service_Order_Header__c();
            String soHeaderId = soHeaderObj.Id;
            soHeaderRec.Id = soHeaderObj.Id;
            soHeaderRec.Name__c = soHeaderObj.Name;
            //soHeaderRec.Total__c = soHeaderObj.Total;
            
            soHeaderRec.Customer_Owned_Unit__c = soHeaderObj.COUId;
            soHeaderRec.Transaction_Type__c = soHeaderObj.TransactionTypeId;
            soHeaderRec.Category__c = soHeaderObj.CategoryId;
            
            if(soHeaderObj.TransactionType == 'Internal') {
            	if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                List<Category__c> categoryList = [select Id, Name, Default__c from Category__c where Type__c = 'Internal Expense' AND Default__c = true];
                String defaultCategoryId;
                if(categoryList.size() > 0) {
                    defaultCategoryId = categoryList[0].Id;
                }
                soHeaderRec.Category__c = defaultCategoryId;
            }
            
            soHeaderRec.Provider__c = soHeaderObj.ProviderId;
            soHeaderRec.Estimated_Hours__c = soHeaderObj.EstimatedHours;
            if(soHeaderObj.PromisedBy != null) {
                DateTime promisedByDateTime = SOHeaderWrapper.getDateTimeFromString(soHeaderObj.PromisedBy);
                //system.assert(false, promisedByDateTime);
                if(promisedByDateTime >= system.Now()) {
                    soHeaderRec.Promised_By__c = promisedByDateTime;
                    //soHeaderRec.Estimated_Hours__c = ((soHeaderRec.Promised_By__c.getTime() - system.Now().getTime()) / (1000.0 * 60.0 * 60.0));
                    soHeaderRec.IsPromisedBy_AmPm__c = soHeaderObj.IsPromisedByAmPm;
                }
            }
            
            if(soHeaderObj.ManualConcern.size() == 0) {
                soHeaderRec.Concern__c = null;
            }
            if(soHeaderObj.ManualCorrection.size() == 0) {
                soHeaderRec.Correction__c = null;
            }
            if(soHeaderObj.ManualCause.size() == 0) {
                soHeaderRec.Cause__c = null;
            }
            
            for(String concernStr : soHeaderObj.ManualConcern) {
                concernStr = (concernStr.contains('\n')) ? concernStr.replaceAll('\n', '') : concernStr;
                if (soHeaderRec.Concern__c == null) {
                    soHeaderRec.Concern__c = '';
                }
                soHeaderRec.Concern__c += concernStr + '\n';
            }
    
            for(String correctionStr : soHeaderObj.ManualCorrection) {
                correctionStr = (correctionStr.contains('\n')) ? correctionStr.replaceAll('\n', '') : correctionStr;
                if (soHeaderRec.Correction__c == null) {
                    soHeaderRec.Correction__c = '';
                }
                soHeaderRec.Correction__c += correctionStr + '\n';
            }
            for (String causeStr : soHeaderObj.ManualCause) {
                causeStr = (causeStr.contains('\n')) ? causeStr.replaceAll('\n', '') : causeStr;
                if (soHeaderRec.Cause__c == null) {
                    soHeaderRec.Cause__c = '';
                }
                soHeaderRec.Cause__c += causeStr + '\n';
            }
            
            //system.assert(false, soHeaderRec);
            if(soHeaderRec.Id != null) {
                update soHeaderRec;
            }
            
            List<Service_Order_Header__c> soHeaderRecList = SOQLUtil.getSODetailsByFieldName(new Map<String, String>{'Id' => soHeaderId});
            if(soHeaderRecList.size() == 0) {
                return BPUtility.getEncodedString('{}');


            }
            
            return BPUtility.getEncodedString(System.JSON.serialize(new SOHeaderWrapper.SOHeader(soHeaderRecList[0])));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


        
        // return JSON
        //return getSOHeaderDetails(coHeaderId, null);
    }
    
    
    /**
    * Name: saveSOSignIn
    * Desc: Method Which saves CO Line Items in Database 
    * @param:   (1) coHeaderId - String - CO Header record Id
    *           (2) jSONString - String - JSON String of CO Line Items
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction
    global static String saveSOSignIn(String coHeaderId, String jSONString){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	jSONString = BPUtility.getDecodedString(jSONString);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            SOHeaderWrapper.SOSignIn soSignInObj = (SOHeaderWrapper.SOSignIn) System.JSON.deserialize(jSONString, SOHeaderWrapper.SOSignIn.class);
            
            String soHeaderId = soSignInObj.Id;
            soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
            List<Service_Order_Header__c> soHeaderList = [select Status__c from Service_Order_Header__c where Id =: soHeaderId];
            if(soHeaderList.size() > 0) {
                Service_Order_Header__c soHeaderRec = soHeaderList[0];
                soHeaderRec.Odometer_on_Arrival__c = soSignInObj.Odometer;
                if(Constants.SOStatusToPriorityMap.get(soHeaderRec.Status__c) < 2) {
                    soHeaderRec.Status__c = 'Ready';
                }
                update soHeaderRec;
            }


            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString(null));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: saveSOReviewInfo
    * Desc: Method Which saves CO Line Items in Database 
    * @param:   (1) coHeaderId - String - CO Header record Id
    *           (2) jSONString - String - JSON String of CO Line Items
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction
    global static String saveSOReviewInfo(String coHeaderId, String jSONString){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	jSONString = BPUtility.getDecodedString(jSONString);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

            SOHeaderWrapper.SOReview soReviewObj = (SOHeaderWrapper.SOReview) System.JSON.deserialize(jSONString, SOHeaderWrapper.SOReview.class);
            String soHeaderId = soReviewObj.Id;
            soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
            List<Service_Order_Header__c> soHeaderList = [select Status__c, Odometer_on_Departure__c, Odometer_on_Arrival__c, Notes_For_Customer__c from Service_Order_Header__c where Id =: soHeaderId]; 
            
            if(soHeaderList.size() > 0) {
                Service_Order_Header__c soHeaderRec = soHeaderList[0];
                if(soReviewObj.OdometerOnDeparture >= soHeaderRec.Odometer_on_Arrival__c) {
                    soHeaderRec.Odometer_on_Departure__c = soReviewObj.OdometerOnDeparture;
                } 
                
                if(soReviewObj.ManualNotes.size() == 0) {
                    soHeaderRec.Notes_For_Customer__c = null;
                }
                
                for(String notesStr : soReviewObj.ManualNotes) {
                    notesStr = (notesStr.contains('\n')) ? notesStr.replaceAll('\n', '') : notesStr;
                    if (soHeaderRec.Notes_For_Customer__c == null) {
                        soHeaderRec.Notes_For_Customer__c = '';
                    }
                    soHeaderRec.Notes_For_Customer__c += notesStr + '\n';
                }
                
                for(String notesStr : soReviewObj.KitHeaderNotes) {
                    notesStr = (notesStr.contains('\n')) ? notesStr.replaceAll('\n', '') : notesStr;
                    if (soHeaderRec.Notes__c == null) {
                        soHeaderRec.Notes__c = '';
                    }
                    soHeaderRec.Notes__c += notesStr + '\n';
                }
                
                if(soHeaderRec.Notes_For_Customer__c != null) {
                    if(soHeaderRec.Notes__c == null) {
                        soHeaderRec.Notes__c = '';
                    }
                    soHeaderRec.Notes__c += soHeaderRec.Notes_For_Customer__c + '\n';
                }
                
                
                if(soHeaderRec.Notes__c != null && soHeaderRec.Odometer_on_Departure__c != null && Constants.SOStatusToPriorityMap.get(soHeaderRec.Status__c) < 5) {
                    soHeaderRec.Status__c = 'Reviewed';
                }
                
                update soHeaderRec;
            }
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString(null));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: saveSOName
    * Desc: Method Which saves CO Line Items in Database 
    * @param:   (1) coHeaderId - String - CO Header record Id
                (2) soName - String - name of Service Order
                (3) soId - String - id of Service Order
    * @return: String - service order record is update or not
    **/
    @RemoteAction
    global static String saveSOName(String coHeaderId, String soName, String soId){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	soName = BPUtility.getDecodedString(soName);
    	soId = BPUtility.getDecodedString(soId);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            Service_Order_Header__c soHeaderRec = new Service_Order_Header__c();
            soHeaderRec.Id = soId;
            soHeaderRec.Name__c = soName;
            
            if(soHeaderRec.Id != null) {
                update soHeaderRec;
            }
            return BPUtility.getEncodedString('Saved');


        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: addCustomer
    * Desc: Methos which adds customer in CO Header Record
    * @param:   (1) coHeaderId - String - CO Header record Id
    *           (2) customerId - String - Id of customer Record
    * @return: String - JSON String of all CO Line Items of CO Header Record
    **/
    @RemoteAction
    global static String addCustomer(String COHeaderId, String customerId){
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	COHeaderId = BPUtility.getDecodedString(COHeaderId);
    	customerId = BPUtility.getDecodedString(customerId);
        try{
            if(String.isBlank(COHeaderId)) {
                COHeaderId = BPUtility.getDecodedString(BPGlobalHeaderCtrl.createCustomerOrder());  
            }
            COHeaderId = BPUtility.escapeSingleQuotes(COHeaderId);
            List<CO_Invoice_Header__c> coInvoiceHeaderList = [select Id, (select Id from CO_Invoice_Payments__r) 
                                                                    from CO_Invoice_Header__c 
                                                                    where Invoice_Status__c = 'Active' AND CO_Header__c =:COHeaderId];
            
            if(coInvoiceHeaderList.size() > 0 && coInvoiceHeaderList[0].CO_Invoice_Payments__r.size() > 0 ) {
                throw new BlackPurlException(BlackPurlException.getErrorMessage('Customer Can\'t be changed since payment is already added', null));
            }
            
            SOQLUtil.updateCOHeader(COHeaderId, customerId);
            
            // Recalculation Logice - Method to calculate kit price for all Service Orders under csutomer order Id passed in parameters.
            SO_KLI_Recalculation.SOPriceCalcultaionByPriceLevel(customerId, COHeaderId);
             
            COKH_Recalcualtion.AddCustomerCoForKititemUpdate(customerId, COHeaderId);
            
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coHeader,coLineItem,cou,user,specialOrder'));
        //return getCOHeaderDetails(COHeaderId);
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }

    /**
    * Name: getCOLineItemByCOHeaderId
    * Desc: Method which give JSOn string of all CO Line Items Records
    * @param:  (1) coHeaderId - String - CO Header record Id
    * @return: String - JSON String of all CO Line Items of CO Header Record
    **/
    @RemoteAction
    global static String getCOLineItemByCOHeaderId(String coHeaderId){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeaderId);
            List<COLineItem> coLineItemObjList = new List<COLineItem>();
            for(CO_Line_Item__c coLineItemRec : coLineItems) {
                coLineItemObjList.add(new COLineItem(coLineItemRec));
            }
            return BPUtility.getEncodedString(System.JSON.serialize(coLineItemObjList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }

    /**
    * Name: saveCOLineItem
    * Desc: Method Which saves CO Line Items in Database 
    * @param:   (1) coHeaderId - String - CO Header record Id
    *           (2) jSONString - String - JSON String of CO Line Items
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction
    global static String saveCOLineItem(String coHeaderId, String jSONString) {
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	jSONString = BPUtility.getDecodedString(jSONString);
    	Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        try{

        	if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
			if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
			


            //system.assert(false, jSONString);
            if(String.isBlank(COHeaderId)) {
                COHeaderId = BPUtility.getDecodedString(BPGlobalHeaderCtrl.createCustomerOrder());  
            }
            
            System.debug('@@@ jSONString jSONString jSONString:\n'+ jSONString);
            List<COLineItem> coLineItemObjList = (List<COLineItem>) System.JSON.deserialize(jSONString, List<COLineItem>.class);
            List<CO_Line_Item__c> coLineItemListToUpdate = new List<CO_Line_Item__c>();
            for(COLineItem coLineItemObj : coLineItemObjList) {
                CO_Line_Item__c coLineItemRec = new CO_Line_Item__c();
                coLineItemRec.Qty__c = coLineItemObj.Qty ;
				if(isTaxIncludingPricing) {
                    if(coLineItemObj.Tax == null) {
                        coLineItemObj.Tax = 0;
                    }   
                    coLineItemRec.Price__c = (coLineItemObj.Price / (1 + (coLineItemObj.Tax / 100)));
                } else {
                    coLineItemRec.Price__c = coLineItemObj.Price;
                }
                coLineItemRec.CO_Header__c = coHeaderId;
                coLineItemRec.Part__c = (coLineItemObj.PartId != '') ? coLineItemObj.PartId : null;
                coLineItemRec.Fee__c = (coLineItemObj.FeeId != '') ? coLineItemObj.FeeId : null;
                
                if(coLineItemObj.isSpecialOrder == null) {
                    coLineItemRec.Special_Order__c = false; // Special Order Flag
                } else {
                    coLineItemRec.Special_Order__c = coLineItemObj.isSpecialOrder; // Special Order Flag
                }
                if(coLineItemObj.CoLineItemId != null) {
                    coLineItemRec.Id = coLineItemObj.CoLineItemId;
                }
                if(coLineItemObj.QtyCommitted != null && coLineItemObj.Qty > 0) {
                    if( coLineItemObj.QtyCommitted  > coLineItemObj.Qty) {
                        coLineItemRec.Qty_Committed__c = coLineItemObj.Qty;
                    } else {
                        coLineItemRec.Qty_Committed__c = coLineItemObj.QtyCommitted;    
                    }
                }
                coLineItemListToUpdate.add(coLineItemRec);
            }
            if(coLineItemListToUpdate.size() > 0) {
                upsert coLineItemListToUpdate;
            }
            
            //system.assert(false, getCOHeaderDetailsByGridName(coHeaderId, 'coHeader,coLineItem,user,coInvoiceHeader,specialOrder'));
            // return JSON
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coHeader,coLineItem,user,coInvoiceHeader,specialOrder'));
            /*List<CO_Header__c> coHeaderRec = SOQLUtil.getCOHeaderDetails(coHeaderId) ;
            List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeaderId);
            List<CO_Invoice_Header__c> coInvoiceHeaders = SOQLUtil.getCOInvoiceHeaderByCOHeaderId(coHeaderId);
            List<CO_Invoice_Item__c> coInvoiceItems = new List<CO_Invoice_Item__c>();
            if(coLineItems == null) {
                coLineItems = new List<CO_Line_Item__c>();
            }
            if(coInvoiceHeaders == null) {
                coInvoiceHeaders = new List<CO_Invoice_Header__c>();
            } else if(coInvoiceHeaders.size() > 0) {
                coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
            }
            
            COHeaderWrapper coHeaderWrapperObj;
            if(coHeaderRec.size() > 0) {
                coHeaderWrapperObj = new COHeaderWrapper(coHeaderRec[0], coLineItems, null, new List<CO_Deposit__c>(), coInvoiceHeaders, 
                                                            new List<CO_Invoice_Payment__c>(), coInvoiceItems, new List<CO_Invoice_Header__c>(), 
                                                            new Map<Id, List<Vendor_Order_Header__c>>(), new List<Customer_Owned_Unit__c>());
            }
            return System.JSON.serialize(coHeaderWrapperObj);*/
            //return getCOHeaderDetails(coHeaderId);
        }catch(Exception e){

            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');



    }

    /**
    * Name: deleteCOLineItem
    * Desc: Method to delete CO Line items From database
    * @param:   (1) coLineItemId - String - CO Line Item Id hich is to be deleted.
    *           (2) coHeaderId - String - CO Header record Id
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction
    global static String deleteCOLineItem(String coLineItemId, String coHeaderId){
    	coLineItemId = BPUtility.getDecodedString(coLineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	
			coLineItemId = BPUtility.escapeSingleQuotes(coLineItemId);
            List<CO_Line_Item__c> coLineItemToDelete = [select Id from CO_Line_Item__c where Id = :coLineItemId];
            if(coLineItemToDelete.size() > 0) {
            	if(AccessControl.ifObjectIsDeletable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
                delete coLineItemToDelete;
            }
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }

    /**
     * Name: getCODepositByCOHeaderId
     * Desc: Method to get CO Deposits from CO Header Record Id
     * @param:  (1) coHeaderId - String - CO Header record Id
     * @return: String - JSON String of all CO Deposits 
     **/
    @RemoteAction
    global static String getCODepositByCOHeaderId(String coHeaderId){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            List<CO_Deposit__c> coDeposits = SOQLUtil.getCODepositByCOHeaderId(coHeaderId);
            List<CODeposit> coDepositObjList = new List<CODeposit>();
            for(CO_Deposit__c coDepositRec : coDeposits) {
                coDepositObjList.add(new CODeposit(coDepositRec));
            }
            return BPUtility.getEncodedString(System.JSON.serialize(coDepositObjList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }

    /**
    * Name: saveCODeposit
    * Desc: Method to save CO Deposits in database
    * @param:  (1) jsonString - String - jsonString of CO Deposits which is to be saved.
    * @return: String - JSON String of all CO Deposits 
    **/
    @RemoteAction
    global static String saveCODeposit(String jsonString){
    	jsonString = BPUtility.getDecodedString(jsonString);
        try{
            List<CODeposit> coDepositObjList = CODeposit.parse(jsonString);
            List<CO_Deposit__c> coDepositListToUpdate = new List<CO_Deposit__c>();
            for(CODeposit coDepositObj : coDepositObjList) {
                CO_Deposit__c coDepositRec = new CO_Deposit__c();
                coDepositRec.Amount__c = coDepositObj.Amount ;
                coDepositRec.Payment_Method__c = coDepositObj.PaymentMethod ;
                coDepositRec.CO_Header__c = coDepositObj.coHeaderId;
    
                if(coDepositObj.CODepositId != null) {
                    coDepositRec.Id = coDepositObj.CODepositId ;
                }
                coDepositListToUpdate.add(coDepositRec);
            }
            if(coDepositListToUpdate.size() > 0) {
            	if(AccessControl.ifObjectFieldIsCreateable('CO_Deposit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
				if(AccessControl.ifObjectFieldIsUpdateable('CO_Deposit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
				

                upsert coDepositListToUpdate;
            }
            String coHeaderId;
            if(coDepositObjList.size() > 0) {
                coHeaderId = coDepositObjList[0].COHeaderId;
            } else {
                COHeaderId = null;
            }
            return getCODepositByCOHeaderId(BPUtility.getEncodedString(coHeaderId));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: getCOInvoicePaymentsByCOInvoiceHedaerId
     * Desc: Method to get All CO Invoice Payments from CO Header Id
     * @param:  (1) COInvoiceHeaderId - String - CO Invoice Header Id
     * @return: String - JSON String of all CO Invoice Payments
     **/
    @RemoteAction
    global static String getCOInvoicePaymentsByCOInvoiceHedaerId(String COInvoiceHeaderId){
    	COInvoiceHeaderId = BPUtility.getDecodedString(COInvoiceHeaderId);
        try{
            List<CO_Invoice_Payment__c> coInvoicePayments = SOQLUtil.getCOInvoicePaymentsByCOInvoiceHeaderId(COInvoiceHeaderId);
            List<COInvoicePayment> coInvoicePaymentList = new List<COInvoicePayment>();
            for(CO_Invoice_Payment__c coInvoicePaymentRec : coInvoicePayments) {
                coInvoicePaymentList.add(new COInvoicePayment(coInvoicePaymentRec));
            }
            return BPUtility.getEncodedString(System.JSON.serialize(coInvoicePaymentList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: saveCOInvoicePayment
     * Desc: Method to save CO Invoice Payment in database
     * @param:  (1) jsonString - String - jsonString of all CO Invoice Payments Records
     * @return: String - JSON String of all CO Invoice Payments
    **/
    @RemoteAction
    global static String saveCOInvoicePayment(String jsonString){
    	jsonString = BPUtility.getDecodedString(jsonString);
        try{
            List<COInvoicePayment> coInvoicePaymentsObjList = COInvoicePayment.parse(jsonString);
            List<CO_Invoice_Payment__c> coInvoicePaymentListToUpdate = new List<CO_Invoice_Payment__c>();
            List<Id> reversePaymentIds = new List<Id>();
             
            for(COInvoicePayment coInvoicePaymentObj : coInvoicePaymentsObjList) {
                CO_Invoice_Payment__c coInvoicePaymentRec = new CO_Invoice_Payment__c();
                coInvoicePaymentRec.Amount__c = coInvoicePaymentObj.Amount ;
                coInvoicePaymentRec.Payment_Method__c = coInvoicePaymentObj.PaymentMethod ;
                coInvoicePaymentRec.CO_Invoice_Header__c = coInvoicePaymentObj.COInvoiceHeaderId;
                if(coInvoicePaymentObj.COInvoicePaymentId != null) {
                    coInvoicePaymentRec.Id = coInvoicePaymentObj.COInvoicePaymentId ;
                }
                if(coInvoicePaymentObj.ReverseLink != null) {
                    reversePaymentIds.add(coInvoicePaymentObj.ReverseLink);
                }
                coInvoicePaymentListToUpdate.add(coInvoicePaymentRec);
            }
            if(coInvoicePaymentListToUpdate.size() > 0) {
            	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
				if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
				

                upsert coInvoicePaymentListToUpdate;
            }
            if(reversePaymentIds.size() > 0) {
            	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                List<CO_Invoice_Payment__c> COInvoicePaymentsToBeReversed = [select Id, Reverse_Link__c from CO_Invoice_Payment__c where Id IN :reversePaymentIds];
                for(CO_Invoice_Payment__c coInvoicePaymentRec : COInvoicePaymentsToBeReversed) {
                    coInvoicePaymentRec.Reverse_Link__c = coInvoicePaymentListToUpdate[0].Id;
					coInvoicePaymentRec.Reverse_Payment_From__c = coInvoicePaymentListToUpdate[0].Id;
                }
                if(COInvoicePaymentsToBeReversed.size() > 0) {
					if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update COInvoicePaymentsToBeReversed;
                }
            }
            
            String COInvoiceHeaderId;
            if(coInvoicePaymentsObjList.size() > 0) {
                COInvoiceHeaderId = coInvoicePaymentsObjList[0].COInvoiceHeaderId;
            } else {
                COInvoiceHeaderId = null;
            }
            return getCOInvoicePaymentsByCOInvoiceHedaerId(BPUtility.getEncodedString(COInvoiceHeaderId));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: getCOInvoiceItemsByCOInvoiceHeaderId
     * Desc: Method to get all CO Invoice Items from Co Invoice Header Id
     * @param:  (1) coInvoiceHeaderId - String - CO Invoice Header Id
     * @return: String - JSON String of all CO Invoice Item List
    **/
    @RemoteAction
    global static String getCOInvoiceItemsByCOInvoiceHeaderId(String coInvoiceHeaderId){
    	coInvoiceHeaderId = BPUtility.getDecodedString(coInvoiceHeaderId);
        try{
            List<CO_Invoice_Item__c> coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaderId);
            List<COInvoiceItem> coInvoiceItemList = new List<COInvoiceItem>();
            for(CO_Invoice_Item__c coInvoiceItemRec : coInvoiceItems) {
                coInvoiceItemList.add(new COInvoiceItem(coInvoiceItemRec));
            }
            return BPUtility.getEncodedString(System.JSON.serialize(coInvoiceItemList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: getCOInvoiceItemsByCOInvoiceHeaderId
     * Desc: 
     * @param:  
     * @return: 
    **/
    /*private static List<COInvoiceItemWrapper> getCOInvoiceItemWrapperList(String coHeaderId, String coInvoiceHeaderId){
        //List<CO_Invoice_Item__c> coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaderId);
        List<CO_Line_Item__c> coLineItems = [select Qty_Committed__c, Price__c, Item_ID__c, Part__c, Part__r.Name, 
                                                (select Id, CO_Invoice_Header__c from CO_Invoice_Items__r Where CO_Invoice_Header__c = :coInvoiceHeaderId) 
                                                 from CO_Line_Item__c where CO_Header__c = :coHeaderId];
        
        Map<String, List<Sobject>> coLineItemIdToCOInvoiceItemsMap = new Map<String, List<Sobject>>();
        for(CO_Line_Item__c coLineItemRec : coLineItems) {
            List<Sobject> coInvoiceItemsList = new List<Sobject>();
            for(CO_Invoice_Item__c coInvoiceItem : coLineItemRec.CO_Invoice_Items__r) {
                coInvoiceItemsList.add(coInvoiceItem);
            }
            coLineItemIdToCOInvoiceItemsMap.put(coLineItemRec.Id, coInvoiceItemsList);
        }
        List<COInvoiceItemWrapper> coInvoiceItemWrapperList = new List<COInvoiceItemWrapper>();
        for(CO_Line_Item__c coLineItemRec : coLineItems) {
            if(coLineItemRec.Qty_Committed__c > 0) {
                coInvoiceItemWrapperList.add(new COInvoiceItemWrapper(coLineItemRec, coLineItemIdToCOInvoiceItemsMap));
            }
        }
        //system.assert(false, coInvoiceItemWrapperList);
        return coInvoiceItemWrapperList;
    }*/
    
    /**
     * Name: updateCOInvoiceItem
     * Desc: Method to update CO Invoice Item 
     * @param:  (1) isActive - Boolean - Is Invoice Item be added in CO Invoice Header
     *          (2) jsonString - String - jSONString of CO Invoice Items
     *          (3) b - String - Arbitary Parameter
     * @return: String - JSON String of all CO Invoice Item List
     * update by :Subhrant 06/04/2016
    **/
     @RemoteAction
    global static String updateCOInvoiceItem(String jsonString, String coHeaderId){
    	jsonString = BPUtility.getDecodedString(jsonString);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            List<COInvoiceItem> coInvoiceItemObjList = (List<COInvoiceItem>) System.JSON.deserialize(jsonString, List<COInvoiceItem>.class);
            List<CO_Invoice_Item__c> coInvoiceItemListToUpdate = new List<CO_Invoice_Item__c>();
                

            for(COInvoiceItem coIIObj : coInvoiceItemObjList) {
                CO_Invoice_Item__c coInvoiceItemRec = new CO_Invoice_Item__c(Id = coIIObj.COInvoiceItemId);
                if(coIIObj.IsActive != null) {
                    coInvoiceItemRec.IsActive__c = coIIObj.IsActive;
                } else {

                    coInvoiceItemRec.IsActive__c = false;
                }

                coInvoiceItemListToUpdate.add(coInvoiceItemRec);
            }
            
            if(coInvoiceItemListToUpdate.size() > 0) {
            	if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update coInvoiceItemListToUpdate;
            }
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('checkOut'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }  
         
         //<> coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceItemRec.CO_Invoice_Header__c);
        //return getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceItemObj.COInvoiceHeaderId);
    }
    
    /**
     * Name: getInvoiceHistoryWrapperList
     * Desc: Method to get Invoice History Wrapper List
     * @param:  (1) coInvoiceHeaderId - String - Id of Co Invoice Header Record
     * @return:  String - JSON String of CO Invoice History List
    **/
    @RemoteAction
    global static String getInvoiceHistoryWrapperList(String coInvoiceHeaderId){
    	coInvoiceHeaderId = BPUtility.getDecodedString(coInvoiceHeaderId);
        try{
            CO_Invoice_Header__c coInvoiceHeader = (CO_Invoice_Header__c)SOQLUtil.getCOInvoiceHeaderRecord(coInvoiceHeaderId);
            List<CO_Invoice_Item__c> coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaderId);
            List<COInvoiceHistoryWrapper> coInvoiceHistoryWrapperList = new List<COInvoiceHistoryWrapper>();
            coInvoiceHistoryWrapperList.add(new COInvoiceHistoryWrapper(coInvoiceHeader, coInvoiceItems));
            return BPUtility.getEncodedString(System.JSON.serialize(coInvoiceHistoryWrapperList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    Name:closedOrderAction
    
    **/
    @RemoteAction
    global static String closedOrderAction(String coInvoiceItemsJsonString, String coHeaderId, String currentCheckoutType){
    	
    if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
      coInvoiceItemsJsonString = BPUtility.getDecodedString(coInvoiceItemsJsonString);
      coHeaderId = BPUtility.getDecodedString(coHeaderId);
      currentCheckoutType = BPUtility.getDecodedString(currentCheckoutType);


       Savepoint sp = Database.setSavepoint();
        try{
            List<COInvoiceItem> coInvoiceItemObjList = (List<COInvoiceItem>) System.JSON.deserialize(coInvoiceItemsJsonString, List<COInvoiceItem>.class);
            Set<Id> coLineItemIdSet = new Set<Id>();
            for(COInvoiceItem coInvoiceItemObj : coInvoiceItemObjList) {
               coLineItemIdSet.add(coInvoiceItemObj.COLineItemId);
            }

            String activeCOInvoiceHeaderId = coInvoiceItemObjList[0].COInvoiceHeaderId;
            activeCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(activeCOInvoiceHeaderId);
            if(activeCOInvoiceHeaderId == null ||  activeCOInvoiceHeaderId == ''){
                 return getCOHeaderDetails(BPUtility.getEncodedString(coHeaderId));
            }
				if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                Map<String,List<CO_Invoice_Item__c>> coInvoiceTypeToLineItemMap =  new Map<String,List<CO_Invoice_Item__c>>();
                List<CO_Invoice_Item__c> closedCOInvoicItemList = [select   CO_Invoice_Header__c,SO_Payment_Role__c, CO_Kit_Header__c,Service_Order_Header__c,CO_Line_Item__c,CO_Line_Item__r.Closed_CO_Invoice_link__c, CO_Invoice_Header__r.Name from CO_Invoice_Item__c where CO_Invoice_Header__c = :activeCOInvoiceHeaderId];
                List<CO_Line_Item__c> coLineItemsToUpdated = new List<CO_Line_Item__c>();
                

                Map<Id,CO_Invoice_Item__c> invoicedServiceOrderHeaderMap =new  Map<Id,CO_Invoice_Item__c>();
                Map<Id, CO_Invoice_Item__c > invoicedCoLineItemMap = new Map<Id, CO_Invoice_Item__c >();
                Map<Id, CO_Invoice_Item__c > invoicedCOKHMap = new Map<Id, CO_Invoice_Item__c >();
                 Map<Id, CO_Invoice_Item__c > invoicedSoPaymentMap = new Map<Id, CO_Invoice_Item__c >();
                List<Part__c> PartForPartReturnBuckets = new  List<Part__c>();
                for(CO_Invoice_Item__c coInoiceItemRec : closedCOInvoicItemList) {
                        if(coInoiceItemRec.CO_Line_Item__c != null) {
                            if(!coInvoiceTypeToLineItemMap.ContainsKey('ColiInvoice'))
                            {

                                coInvoiceTypeToLineItemMap.Put('ColiInvoice',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                            }

                            coInvoiceTypeToLineItemMap.get('ColiInvoice').add(coInoiceItemRec);
                            invoicedCoLineItemMap.Put(coInoiceItemRec.CO_Line_Item__c,coInoiceItemRec );
                        }

                        else if( coInoiceItemRec.CO_Kit_Header__c !=null){
                            if(!coInvoiceTypeToLineItemMap.ContainsKey('CoKitInvoice'))
                            {

                                coInvoiceTypeToLineItemMap.Put('CoKitInvoice',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                            }

                            coInvoiceTypeToLineItemMap.get('CoKitInvoice').add(coInoiceItemRec);
                            invoicedCOKHMap.Put(coInoiceItemRec.CO_Kit_Header__c,coInoiceItemRec );
                        
                        }


                        else if( coInoiceItemRec.Service_Order_Header__c !=null && coInoiceItemRec.SO_Payment_Role__c ==null){
                            

                            if(!coInvoiceTypeToLineItemMap.ContainsKey('SoKitInvoice'))
                            {

                                coInvoiceTypeToLineItemMap.Put('SoKitInvoice',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                            }

                            coInvoiceTypeToLineItemMap.get('SoKitInvoice').add(coInoiceItemRec);
                            invoicedServiceOrderHeaderMap.Put(coInoiceItemRec.Service_Order_Header__c,coInoiceItemRec );
                       }

                       else if( coInoiceItemRec.SO_Payment_Role__c !=null){
                            if(!coInvoiceTypeToLineItemMap.ContainsKey('SoPayment'))
                            {

                                coInvoiceTypeToLineItemMap.Put('SoPayment',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                            }

                            coInvoiceTypeToLineItemMap.get('SoPayment').add(coInoiceItemRec);
                            invoicedSoPaymentMap.Put(coInoiceItemRec.SO_Payment_Role__c , coInoiceItemRec );
                        }
                }
                
                




                // for Service order records 
                

                if( coInvoiceTypeToLineItemMap.containsKey('SoKitInvoice') ){
                	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

                    List<Service_Order_Line_Item__c> serviceOrderLineItemFromInvoiceList  = new List<Service_Order_Line_Item__c>([Select Service_Order_Header__c,(Select Qty__c, Qty_Committed__c, Status__c, Price__c, part__c,part__r.Qty_In_Stock__c,
                                                                                                                                part__r.Qty_Committed__c,part__r.Last_Cost__c, Closed_CO_Invoice_link__c,Oversold_Qty__c From CO_Line_Items__r),CO_Line_Item__c
                                                                                                                                 From Service_Order_Line_Item__c  where  Service_Order_Header__c  =: invoicedServiceOrderHeaderMap.KeySet()]);
                        for( Service_Order_Line_Item__c serviceOrderLineItemFromInvoiceRec : serviceOrderLineItemFromInvoiceList  ){
                            if(invoicedServiceOrderHeaderMap.containsKey(serviceOrderLineItemFromInvoiceRec.Service_Order_Header__c)){
                            CO_Invoice_Item__c   closedCOInvoiceItem =  invoicedServiceOrderHeaderMap.get(serviceOrderLineItemFromInvoiceRec.Service_Order_Header__c);
                            

                                List<CO_Line_Item__c> coliUpdateFromServiceOrderInvoiceList = new   List<CO_Line_Item__c>(serviceOrderLineItemFromInvoiceRec.CO_Line_Items__r);
                                    for(CO_Line_Item__c colirec : coliUpdateFromServiceOrderInvoiceList ){
                                        colirec.Closed_CO_Invoice_link__c = closedCOInvoiceItem.CO_Invoice_Header__r.Name;
                                        coLineItemsToUpdated.add(colirec);
                            }
                        }
                    }
                }
                    





                if(coInvoiceTypeToLineItemMap.containsKey('ColiInvoice')){
                	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	

                    List<CO_Line_Item__c> ColiFromInvoiceList = new   List<CO_Line_Item__c>([Select Qty__c, Qty_Committed__c, Price__c, Status__c,part__c,part__r.Qty_In_Stock__c,
                                                                                        part__r.Qty_Committed__c,part__r.Last_Cost__c,closed_CO_Invoice_link__c,Oversold_Qty__c From CO_Line_Item__c where  Id =: invoicedCoLineItemMap.KeySet()]);
                    for(CO_Line_Item__c colirec : ColiFromInvoiceList ){
                            CO_Invoice_Item__c   closedCOInvoiceItem = invoicedCoLineItemMap.get(colirec.Id);
                            colirec.Closed_CO_Invoice_link__c = closedCOInvoiceItem.CO_Invoice_Header__r.Name;
                            coLineItemsToUpdated.add(colirec);
                    }
                }   


                 if(coInvoiceTypeToLineItemMap.containsKey('CoKitInvoice')){
                 	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                 	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	

                    List<CO_Kit_Header__c> ColiFromInvoiceList = new   List<CO_Kit_Header__c>([Select Id,(Select Qty__c, Qty_Committed__c, Price__c, Status__c,part__c,part__r.Qty_In_Stock__c,
                                                                                            part__r.Qty_Committed__c,part__r.Last_Cost__c, Closed_CO_Invoice_link__c,Oversold_Qty__c From CO_Line_Items__r)
                                                                                            From CO_Kit_Header__c where  Id =: invoicedCOKHMap.KeySet()]);
                                                                                            

                        for( CO_Kit_Header__c coKitHeaderFromInvoiceRec : ColiFromInvoiceList ){
                            if(invoicedCOKHMap.containsKey(coKitHeaderFromInvoiceRec.Id)){
                            CO_Invoice_Item__c   closedCOInvoiceItem =  invoicedCOKHMap.get(coKitHeaderFromInvoiceRec.Id);
                                List<CO_Line_Item__c> coliUpdateFromServiceOrderInvoiceList = new   List<CO_Line_Item__c>(coKitHeaderFromInvoiceRec.CO_Line_Items__r);
                                    for(CO_Line_Item__c colirec : coliUpdateFromServiceOrderInvoiceList ){
                                        colirec.Closed_CO_Invoice_link__c = closedCOInvoiceItem.CO_Invoice_Header__r.Name;
                                        coLineItemsToUpdated.add(colirec);
                            }
                        }
                    }
                    
                }   





                Map<Id,Part__c> updateStockedMap = new Map<Id,Part__c>();
                Map<Id,Part__c> updateStockBucketMap = new Map<Id,Part__c>();
                set<Service_Order_Header__c> ServiceOrderInvoiceStatusSet = new   set<Service_Order_Header__c>();
                List<So_Payment_Role__c> SoPaymentRoleList  = new List<So_Payment_Role__c>();
                if(coInvoiceTypeToLineItemMap.containsKey('SoPayment')){  
                	if(AccessControl.ifObjectFieldIsAccessible('So_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                	if(AccessControl.ifObjectFieldIsAccessible('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

                	SoPaymentRoleList  = new List<So_Payment_Role__c>([Select Id,RecordType.DeveloperName,(select Id,Is_Variance__c,Approved_Qty__c,
                                                                                                Variance_Qty__c,Service_Order_Line_Item__c,Approved_Price__c, Service_Order_Line_Item__r.part__c,Service_Order_Line_Item__r.part__r.Qty_In_Stock__c,
                                                                                                Service_Order_Line_Item__r.part__r.Qty_Committed__c ,Service_Order_Line_Item__r.CO_Line_Item__r.Oversold_Qty__c,Service_Order_Line_Item__r.part__r.Last_Cost__c   From Claim_Line_Items__r)
                                                                                                From So_Payment_Role__c  where  Id  IN : invoicedSoPaymentMap.KeySet()]);
                         

                        for(So_Payment_Role__c SoPaymentRec: SoPaymentRoleList){
                                if(SoPaymentRec.RecordType.DeveloperName == 'Third_Party' ){
                                    for(Claim_Line_Item__c ClaimLineItemrec : SoPaymentRec.Claim_Line_Items__r ){
                                        if(ClaimLineItemrec.Service_Order_Line_Item__r.part__c!=null){
                                            Part__c partRec = new part__c();
                                            partRec.Id =  ClaimLineItemrec.Service_Order_Line_Item__r.part__c;
                                            partRec.Qty_In_Stock__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_In_Stock__c;
                                            partRec.Qty_Committed__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_Committed__c;
                                            Decimal qtyNeed = ClaimLineItemrec.Approved_Qty__c;
                                            Decimal quantityComitted = ClaimLineItemrec.Approved_Qty__c;
                                            Decimal qtyOverSold = 0;
                                            Decimal ReturnCost = ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c !=null ?  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c : 0 ; 






                                           


                                            AddPartToPartMap(updateStockedMap,updateStockBucketMap,qtyNeed,quantityComitted,partRec, PartForPartReturnBuckets, ReturnCost,qtyOverSold );
                                        }
                                    }


                                    SoPaymentRec.Status__c = 'Invoiced';    
                                }       

                                else if(SoPaymentRec.RecordType.DeveloperName == 'Customer' ){
                                    for(Claim_Line_Item__c ClaimLineItemrec : SoPaymentRec.Claim_Line_Items__r ){
                                        if(ClaimLineItemrec.Service_Order_Line_Item__r.part__c!=null){
                                            Part__c partRec = new part__c();
                                            partRec.Id =  ClaimLineItemrec.Service_Order_Line_Item__r.part__c;
                                            partRec.Qty_In_Stock__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_In_Stock__c;
                                            partRec.Qty_Committed__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_Committed__c;
                                            Decimal qtyNeed = ClaimLineItemrec.Variance_Qty__c;
                                            Decimal quantityComitted = ClaimLineItemrec.Variance_Qty__c;
                                            Decimal qtyOverSold = 0;
                                            Decimal ReturnCost = ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c !=null ?  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c : 0 ; 

                                            AddPartToPartMap(updateStockedMap,updateStockBucketMap,qtyNeed,quantityComitted,partRec, PartForPartReturnBuckets, ReturnCost,qtyOverSold );
                                        }
                                    }

                                    SoPaymentRec.Status__c = 'Invoiced';    
                                }else if(SoPaymentRec.RecordType.DeveloperName == 'Internal'){
                                    for(Claim_Line_Item__c ClaimLineItemrec : SoPaymentRec.Claim_Line_Items__r ){
                                        if(ClaimLineItemrec.Service_Order_Line_Item__r.part__c!=null){
                                            Part__c partRec = new part__c();
                                            partRec.Id =  ClaimLineItemrec.Service_Order_Line_Item__r.part__c;
                                            partRec.Qty_In_Stock__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_In_Stock__c;
                                            partRec.Qty_Committed__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_Committed__c;
                                            Decimal qtyNeed = ClaimLineItemrec.Variance_Qty__c;
                                            Decimal quantityComitted = ClaimLineItemrec.Variance_Qty__c;
                                            Decimal qtyOverSold = 0;
                                            Decimal ReturnCost = ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c !=null ?  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c : 0 ; 

                                            AddPartToPartMap(updateStockedMap,updateStockBucketMap,qtyNeed,quantityComitted,partRec, PartForPartReturnBuckets, ClaimLineItemrec.Approved_Price__c,qtyOverSold );
                                        }
                                    }

                                    SoPaymentRec.Status__c = 'Invoiced'; 
                                }

                                else if(SoPaymentRec.RecordType.DeveloperName == 'deductible'){
                                        SoPaymentRec.Deductible_Status__c = 'Paid';
                                        SoPaymentRec.Status__c = 'Invoiced'; 
                                } 
                        }                                                                                                    
                    }
                




                //Map<Id,Part__c> updateStockedMap = new Map<Id,Part__c>();
               
                  for(CO_Line_Item__c coLineItemsToUpdatedRec : coLineItemsToUpdated){
                            if(coLineItemsToUpdatedRec.part__c !=null){
                                Decimal quantityComitted = coLineItemsToUpdatedRec.Qty_Committed__c  ==null ? 0 :coLineItemsToUpdatedRec.Qty_Committed__c;
                                Decimal qtyNeed = coLineItemsToUpdatedRec.Qty__c  ==null ? 0 :coLineItemsToUpdatedRec.Qty__c;
                                Decimal qtyOverSold = coLineItemsToUpdatedRec.Oversold_Qty__c;
                                Part__c  ObjPart = coLineItemsToUpdatedRec.part__r;
								Decimal ReturnCost = coLineItemsToUpdatedRec.part__r.last_cost__c !=null ?  coLineItemsToUpdatedRec.part__r.last_cost__c : 0 ;
                                AddPartToPartMap(updateStockedMap,  updateStockBucketMap,qtyNeed,quantityComitted,ObjPart,
                                         PartForPartReturnBuckets,ReturnCost,qtyOverSold);
                            }
                   }    
                
                   if(PartForPartReturnBuckets.size() > 0){
                        FIFOTransaction.createFIFOBucketForCustomerReturn(PartForPartReturnBuckets, activeCOInvoiceHeaderId);
                   } 
                  


                  List<Part_FIFO_Bucket__c>  PartFifoList=  SOQLUtil.getPartFIFOBucketByPartList(updateStockedMap.keySet());
                  Map<Id,List<Part_FIFO_Bucket__c>> PartToFIFOBucketMap   = new Map<Id,List<Part_FIFO_Bucket__c>>();
                  for(Part_FIFO_Bucket__c partFifoRec : PartFifoList){
                    if(PartToFIFOBucketMap.containsKey(partFifoRec.part__c)){
                            PartToFIFOBucketMap.get(partFifoRec.part__c).add(partFifoRec);
                    }else{ 

                            List<Part_FIFO_Bucket__c> listpartFifo  = new List<Part_FIFO_Bucket__c>();
                            listpartFifo.add(partFifoRec);
                            PartToFIFOBucketMap.put(partFifoRec.part__c, listpartFifo);
                    } 
                  } 
              


                List<Part__c> partFifoBucketValueToUpdate = new List<Part__c>(); 
                if(updateStockBucketMap.size()> 0){
                    String Result =  FIFOTransaction.CreateFiFoBucketActivityForInvoice(PartToFIFOBucketMap, activeCOInvoiceHeaderId,updateStockBucketMap.values(),updateStockedMap);
                }
                               


                if(coLineItemsToUpdated.size() > 0) {
                	if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update coLineItemsToUpdated; 
                   // update updateStockedMap.values();
                } 

                if(SoPaymentRoleList.Size()>0){
                	if(AccessControl.ifObjectFieldIsUpdateable('So_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update SoPaymentRoleList;
                }

            List<CO_Invoice_Payment__c> coInvoicePayments = new List<CO_Invoice_Payment__c>();
            activeCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(activeCOInvoiceHeaderId);
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            coInvoicePayments = [select Id, Payment_Method__c, Amount__c, CO_Invoice_Header__c, CO_Invoice_Header__r.CO_Header__c from CO_Invoice_Payment__c where Payment_Method__c =: USE_DEPOSIT AND CO_Invoice_Header__c =:activeCOInvoiceHeaderId];
            
            List<CO_Deposit__c> coDepositsListToInsert = new List<CO_Deposit__c>();
            for(CO_Invoice_Payment__c coInvoicePaymentRec : coInvoicePayments) {
                CO_Deposit__c coDepositRec = new CO_Deposit__c();
                coDepositRec.Payment_Method__c = 'Invoice';
                coDepositRec.CO_Invoice_Header__c = coInvoicePaymentRec.CO_Invoice_Header__c;
                coDepositRec.CO_Header__c = coInvoicePaymentRec.CO_Invoice_Header__r.CO_Header__c;
                coDepositRec.Amount__c = -1 * coInvoicePaymentRec.Amount__c;
                coDepositsListToInsert.add(coDepositRec);
            }

            if(coDepositsListToInsert.size() > 0) {
            	if(AccessControl.ifObjectFieldIsCreateable('CO_Deposit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                insert coDepositsListToInsert;
            }
            coHeaderId = BPUtility.escapeSingleQuotes(coHeaderId);
            activeCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(activeCOInvoiceHeaderId);
            if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            CO_Header__c coHeaderRec =[select Id,Order_status__c  from CO_Header__c  where Id = :coHeaderId ];
            CO_Invoice_Header__c coInvoiceHeaderRec = [select Invoice_Status__c from CO_Invoice_Header__c where Id = :activeCOInvoiceHeaderId];

            if(coInvoiceHeaderRec !=null &&  coHeaderRec != null ){
            	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            	if(AccessControl.ifObjectFieldIsCreateable('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            	

                coInvoiceHeaderRec.Invoice_Status__c = 'Closed';
                coInvoiceHeaderRec.Checkout_Type__c = currentCheckoutType;
                coHeaderRec.Order_status__c='Closed';
				if(AccessControl.ifObjectIsCreateable('AutoNumberHolder__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
				AutoNumberHolder__c AutonumberRec = new AutoNumberHolder__c();
	            insert AutonumberRec;
	            if(AutonumberRec.Id !=null){
	            	coInvoiceHeaderRec.AutoNumberHolder__c = AutonumberRec.Id;
	            	if(AccessControl.ifObjectFieldIsUpdateable('coHeaderRec') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	            	update coInvoiceHeaderRec;
	            	update coHeaderRec;  

	            }
	            else{
	          		  throw new BlackPurlException('Unable to generate Invoice');
	            }
            }

            return getCOHeaderDetails(BPUtility.getEncodedString(coHeaderId));
        }catch(Exception e){
            Database.rollback(sp);
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
    }
    
    
    /**
     * Name: closedInvoiceAction
     * Desc: Method to do calculation after Closed Invoice Button click.
     * @param:  (1) coInvoiceItemsJsonString - String - json string of coInvoice items
     *          (2) coHeaderId -String - id of coHeader
     * @return:  String - JSON String of CO Invoice History List
    **/
  @RemoteAction
  global static String closedInvoiceAction(String coInvoiceItemsJsonString, String coHeaderId, String currentCheckoutType){
  		coInvoiceItemsJsonString = BPUtility.getDecodedString(coInvoiceItemsJsonString);
  		coHeaderId = BPUtility.getDecodedString(coHeaderId);
  		currentCheckoutType = BPUtility.getDecodedString(currentCheckoutType);
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	


        Savepoint sp = Database.setSavepoint();
        try{
            List<COInvoiceItem> coInvoiceItemObjList = (List<COInvoiceItem>) System.JSON.deserialize(coInvoiceItemsJsonString, List<COInvoiceItem>.class);
            Set<Id> coLineItemIdSet = new Set<Id>();
            Set<Id> returnCOLineItemIdSet = new Set<Id>(); 
            for(COInvoiceItem coInvoiceItemObj : coInvoiceItemObjList) {
                if(coInvoiceItemObj.COLineItemId != null && coInvoiceItemObj.IsActive && coInvoiceItemObj.QtyRequired > coInvoiceItemObj.Qty && coInvoiceItemObj.Qty != 0 )  {
                    coLineItemIdSet.add(coInvoiceItemObj.COLineItemId);
                } else if(coInvoiceItemObj.COLineItemId != null && coInvoiceItemObj.QtyRequired < 0){
                    
                }
            }
            List<CO_Line_Item__c> coLineItemRecList = [select Qty__c, Qty_Committed__c, Part__c, CO_Header__c, Price__c, Tax__c from CO_Line_Item__c where Id IN : coLineItemIdSet ];
            List<CO_Line_Item__c> coLineItemRecToUpdated = new List<CO_Line_Item__c>();
            List<CO_Line_Item__c> coLineItemRecToInserted = new List<CO_Line_Item__c>();
            
            for(CO_Line_Item__c coLineItemRec : coLineItemRecList) {
                if(coLineItemRec.Qty__c > coLineItemRec.Qty_Committed__c) {
                    CO_Line_Item__c coLineItemDuplicate = new CO_Line_Item__c();
                    coLineItemDuplicate = coLineItemRec.clone(false, true, false, false);
                    coLineItemDuplicate.Qty__c = coLineItemRec.Qty_Committed__c;
                    coLineItemRec.Qty__c = coLineItemRec.Qty__c - coLineItemRec.Qty_Committed__c;
                    coLineItemRec.Qty_Committed__c = 0;
                    coLineItemRecToUpdated.add(coLineItemRec);
                    coLineItemRecToInserted.add(coLineItemDuplicate);  
                }
            }
            //system.assert(false,coLineItemRecToUpdated);
            if(coLineItemRecToUpdated.size() > 0) {
                update coLineItemRecToUpdated;
            }
            if(coLineItemRecToInserted.size() > 0) {
                insert coLineItemRecToInserted;
            }
            for(Integer i=0 ; i < coLineItemRecToInserted.size() ; i++ ) {
                coLineItemRecToInserted[i].price__c = coLineItemRecToUpdated[i].price__c;
            }
            if(coLineItemRecToInserted.size() > 0) {
                update coLineItemRecToInserted;
            }
            
            Set<Id> newInsertedCOLineItemIdSet = new Set<Id>();
            for(CO_Line_Item__c coLineItemRec : coLineItemRecToInserted) {
                newInsertedCOLineItemIdSet.add(coLineItemRec.Id); 
            }
            
            
            // Close Invoice Header
            String activeCOInvoiceHeaderId = '';
            String closedCOInvoiceHeaderId = '';
            if(coInvoiceItemObjList.size() == 0) {
                return BPUtility.getEncodedString('');


            }
            activeCOInvoiceHeaderId = coInvoiceItemObjList[0].COInvoiceHeaderId;
            List<CO_Invoice_Header__c> coInvoiceHeaderRecToUpdate = new List<CO_Invoice_Header__c>();
            activeCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(activeCOInvoiceHeaderId);
            CO_Invoice_Header__c coInvoiceHeaderRec = [select Invoice_Status__c from CO_Invoice_Header__c where Id = :activeCOInvoiceHeaderId];
            coInvoiceHeaderRec.Invoice_Status__c = 'Closed';
            coInvoiceHeaderRec.Checkout_Type__c = currentCheckoutType;
            coInvoiceHeaderRecToUpdate.add(coInvoiceHeaderRec);
            closedCOInvoiceHeaderId = activeCOInvoiceHeaderId;
            
            CO_Invoice_Header__c coInvoiceHeaderRecToInsert = new CO_Invoice_Header__c();
            coInvoiceHeaderRecToInsert.Invoice_Status__c = 'Active';
            coInvoiceHeaderRecToInsert.CO_Header__c = coHeaderId; 
            coInvoiceHeaderRecToUpdate.add(coInvoiceHeaderRecToInsert);
            
            if(coInvoiceHeaderRecToUpdate.size() > 0) {
				map<Id,AutoNumberHolder__c>  InvoiceToAutoNumbermap =new  map<Id,AutoNumberHolder__c>();
            	for(CO_Invoice_Header__c coInvoiceHeaderRecNew :   coInvoiceHeaderRecToUpdate){
            		if(coInvoiceHeaderRecNew.Invoice_Status__c == 'Closed'){
            			AutoNumberHolder__c objnewAutonumber = new AutoNumberHolder__c();
            			InvoiceToAutoNumbermap.put(coInvoiceHeaderRecNew.Id,objnewAutonumber);
            		} 
            	}
            	if(InvoiceToAutoNumbermap.size() > 0){
            		if(AccessControl.ifObjectFieldIsCreateable('AutoNumberHolder__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            		insert InvoiceToAutoNumbermap.values();
            		for(CO_Invoice_Header__c coInvoiceHeaderRecNew :   coInvoiceHeaderRecToUpdate){
            			if(coInvoiceHeaderRecNew.Invoice_Status__c == 'Closed'){
            				AutoNumberHolder__c objnewAutonumber =InvoiceToAutoNumbermap.get(coInvoiceHeaderRecNew.Id);
            				coInvoiceHeaderRecNew.AutoNumberHolder__c = objnewAutonumber.Id;
            			}
            		}   
            	}
                upsert coInvoiceHeaderRecToUpdate;
            } 
            
            String activeInvoiceHeaderId;
            for(CO_Invoice_Header__c coInvoiceHeader : coInvoiceHeaderRecToUpdate) {
                if(coInvoiceHeader.Invoice_Status__c == 'Active') {
                    activeInvoiceHeaderId = coInvoiceHeader.Id;
                }
            }
            closedCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(closedCOInvoiceHeaderId);
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<CO_Invoice_Item__c> coInvoiceItems = [select isActive__c, CO_Invoice_Header__c, CO_Kit_Header__c,Service_Order_Header__c,CO_Line_Item__c,CO_Line_Item__r.Closed_CO_Invoice_link__c, CO_Invoice_Header__r.Name from CO_Invoice_Item__c 
                                                            where (CO_Invoice_Header__c = :closedCOInvoiceHeaderId AND isActive__c = false) 
                                                                        OR CO_Line_Item__c IN : coLineItemIdSet];
                                                                        
            for(CO_Invoice_Item__c coInoiceItemRec : coInvoiceItems) {
                if(coInoiceItemRec.CO_Line_Item__c == null) {
                    // coInoiceItemRec.isActive__c = false;
                     coInoiceItemRec.CO_Invoice_Header__c = activeInvoiceHeaderId;
                     continue;
                }
                if(newInsertedCOLineItemIdSet.contains(coInoiceItemRec.CO_Line_Item__c)) {  
                    coInoiceItemRec.isActive__c = true;
                } else {
                    coInoiceItemRec.isActive__c = false;  
                    coInoiceItemRec.CO_Invoice_Header__c = activeInvoiceHeaderId;
                }
            }
            if(coInvoiceItems.size() > 0) { 
            	if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update coInvoiceItems;
            }
            
            Map<String,List<CO_Invoice_Item__c>> coInvoiceTypeToLineItemMap =  new Map<String,List<CO_Invoice_Item__c>>();
            closedCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(closedCOInvoiceHeaderId);
            List<CO_Invoice_Item__c> closedCOInvoicItemList = [select   CO_Invoice_Header__c,SO_Payment_Role__c, CO_Kit_Header__c,Service_Order_Header__c,CO_Line_Item__c,CO_Line_Item__r.Closed_CO_Invoice_link__c, CO_Invoice_Header__r.Name from CO_Invoice_Item__c where CO_Invoice_Header__c = :closedCOInvoiceHeaderId];
            List<CO_Line_Item__c> coLineItemsToUpdated = new List<CO_Line_Item__c>();
            
            Map<Id,CO_Invoice_Item__c> invoicedServiceOrderHeaderMap =new  Map<Id,CO_Invoice_Item__c>();
            Map<Id, CO_Invoice_Item__c > invoicedCoLineItemMap = new Map<Id, CO_Invoice_Item__c >();
            Map<Id, CO_Invoice_Item__c > invoicedCOKHMap = new Map<Id, CO_Invoice_Item__c >();
             Map<Id, CO_Invoice_Item__c > invoicedSoPaymentMap = new Map<Id, CO_Invoice_Item__c >();
            List<Part__c> PartForPartReturnBuckets = new  List<Part__c>();
            for(CO_Invoice_Item__c coInoiceItemRec : closedCOInvoicItemList) {
                    if(coInoiceItemRec.CO_Line_Item__c != null) {
                        if(!coInvoiceTypeToLineItemMap.ContainsKey('ColiInvoice'))
                        {
                            coInvoiceTypeToLineItemMap.Put('ColiInvoice',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                        }
                        coInvoiceTypeToLineItemMap.get('ColiInvoice').add(coInoiceItemRec);
                        invoicedCoLineItemMap.Put(coInoiceItemRec.CO_Line_Item__c,coInoiceItemRec );
                    }
                    else if( coInoiceItemRec.CO_Kit_Header__c !=null){
                        if(!coInvoiceTypeToLineItemMap.ContainsKey('CoKitInvoice'))
                        {
                            coInvoiceTypeToLineItemMap.Put('CoKitInvoice',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                        }
                        coInvoiceTypeToLineItemMap.get('CoKitInvoice').add(coInoiceItemRec);
                        invoicedCOKHMap.Put(coInoiceItemRec.CO_Kit_Header__c,coInoiceItemRec );
                    
                    }
                    else if( coInoiceItemRec.Service_Order_Header__c !=null && coInoiceItemRec.SO_Payment_Role__c ==null){
                        
                        if(!coInvoiceTypeToLineItemMap.ContainsKey('SoKitInvoice'))
                        {
                            coInvoiceTypeToLineItemMap.Put('SoKitInvoice',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                        }
                        coInvoiceTypeToLineItemMap.get('SoKitInvoice').add(coInoiceItemRec);
                        invoicedServiceOrderHeaderMap.Put(coInoiceItemRec.Service_Order_Header__c,coInoiceItemRec );
                   }
                   else if( coInoiceItemRec.SO_Payment_Role__c !=null){
                        if(!coInvoiceTypeToLineItemMap.ContainsKey('SoPayment'))
                        {
                            coInvoiceTypeToLineItemMap.Put('SoPayment',new List<CO_Invoice_Item__c>{ coInoiceItemRec});
                        }
                        coInvoiceTypeToLineItemMap.get('SoPayment').add(coInoiceItemRec);
                        invoicedSoPaymentMap.Put(coInoiceItemRec.SO_Payment_Role__c , coInoiceItemRec );
                    }
            }
            
            
            // for Service order records 
            
            if( coInvoiceTypeToLineItemMap.containsKey('SoKitInvoice') ){
            	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

                List<Service_Order_Line_Item__c> serviceOrderLineItemFromInvoiceList  = new List<Service_Order_Line_Item__c>([Select Service_Order_Header__c,(Select Qty__c, Qty_Committed__c, Status__c, Price__c, part__c,part__r.Qty_In_Stock__c,
                                                                                                                            part__r.Qty_Committed__c,part__r.Last_Cost__c, Closed_CO_Invoice_link__c,Oversold_Qty__c From CO_Line_Items__r),CO_Line_Item__c
                                                                                                                             From Service_Order_Line_Item__c  where  Service_Order_Header__c  =: invoicedServiceOrderHeaderMap.KeySet()]);
                    for( Service_Order_Line_Item__c serviceOrderLineItemFromInvoiceRec : serviceOrderLineItemFromInvoiceList  ){
                        if(invoicedServiceOrderHeaderMap.containsKey(serviceOrderLineItemFromInvoiceRec.Service_Order_Header__c)){
                        CO_Invoice_Item__c   closedCOInvoiceItem =  invoicedServiceOrderHeaderMap.get(serviceOrderLineItemFromInvoiceRec.Service_Order_Header__c);
                        
                            List<CO_Line_Item__c> coliUpdateFromServiceOrderInvoiceList = new   List<CO_Line_Item__c>(serviceOrderLineItemFromInvoiceRec.CO_Line_Items__r);
                                for(CO_Line_Item__c colirec : coliUpdateFromServiceOrderInvoiceList ){
                                    colirec.Closed_CO_Invoice_link__c = closedCOInvoiceItem.CO_Invoice_Header__r.Name;
                                    coLineItemsToUpdated.add(colirec);
                        }
                    }
                }
            }
                
            if(coInvoiceTypeToLineItemMap.containsKey('ColiInvoice')){
            	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	

                List<CO_Line_Item__c> ColiFromInvoiceList = new   List<CO_Line_Item__c>([Select Qty__c, Qty_Committed__c, Price__c, Status__c,part__c,part__r.Qty_In_Stock__c,
                                                                                    part__r.Qty_Committed__c,part__r.Last_Cost__c,closed_CO_Invoice_link__c,Oversold_Qty__c From CO_Line_Item__c where  Id =: invoicedCoLineItemMap.KeySet()]);
                for(CO_Line_Item__c colirec : ColiFromInvoiceList ){
                        CO_Invoice_Item__c   closedCOInvoiceItem = invoicedCoLineItemMap.get(colirec.Id);
                        colirec.Closed_CO_Invoice_link__c = closedCOInvoiceItem.CO_Invoice_Header__r.Name;
                        coLineItemsToUpdated.add(colirec);
                }
            }   
             if(coInvoiceTypeToLineItemMap.containsKey('CoKitInvoice')){
             	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

                List<CO_Kit_Header__c> ColiFromInvoiceList = new   List<CO_Kit_Header__c>([Select Id,(Select Qty__c, Qty_Committed__c, Price__c, Status__c,part__c,part__r.Qty_In_Stock__c,
                                                                                        part__r.Qty_Committed__c,part__r.Last_Cost__c, Closed_CO_Invoice_link__c,Oversold_Qty__c From CO_Line_Items__r)
                                                                                        From CO_Kit_Header__c where  Id =: invoicedCOKHMap.KeySet()]);
                                                                                        

                    for( CO_Kit_Header__c coKitHeaderFromInvoiceRec : ColiFromInvoiceList ){
                        if(invoicedCOKHMap.containsKey(coKitHeaderFromInvoiceRec.Id)){
                        CO_Invoice_Item__c   closedCOInvoiceItem =  invoicedCOKHMap.get(coKitHeaderFromInvoiceRec.Id);
                            List<CO_Line_Item__c> coliUpdateFromServiceOrderInvoiceList = new   List<CO_Line_Item__c>(coKitHeaderFromInvoiceRec.CO_Line_Items__r);
                                for(CO_Line_Item__c colirec : coliUpdateFromServiceOrderInvoiceList ){
                                    colirec.Closed_CO_Invoice_link__c = closedCOInvoiceItem.CO_Invoice_Header__r.Name;
                                    coLineItemsToUpdated.add(colirec);
                        }
                    }
                }
                
            }   





            Map<Id,Part__c> updateStockedMap = new Map<Id,Part__c>();
            Map<Id,Part__c> updateStockBucketMap = new Map<Id,Part__c>();
            set<Service_Order_Header__c> ServiceOrderInvoiceStatusSet = new   set<Service_Order_Header__c>();
            List<So_Payment_Role__c> SoPaymentRoleList  = new List<So_Payment_Role__c>();
            if(coInvoiceTypeToLineItemMap.containsKey('SoPayment')){  
            	

            	if(AccessControl.ifObjectFieldIsAccessible('So_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	if(AccessControl.ifObjectFieldIsAccessible('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	

            SoPaymentRoleList  = new List<So_Payment_Role__c>([Select Id,RecordType.DeveloperName,(select Id,Is_Variance__c,Approved_Qty__c,
                                                                                            Variance_Qty__c,Service_Order_Line_Item__c,Approved_Price__c, Service_Order_Line_Item__r.part__c,Service_Order_Line_Item__r.part__r.Qty_In_Stock__c,
																							Service_Order_Line_Item__r.part__r.last_cost__c,Service_Order_Line_Item__r.part__r.Qty_Committed__c ,
	            																			Service_Order_Line_Item__r.CO_Line_Item__r.Oversold_Qty__c  From Claim_Line_Items__r)
                                                                                            From So_Payment_Role__c  where  Id  IN : invoicedSoPaymentMap.KeySet()]);
                     
                    for(So_Payment_Role__c SoPaymentRec: SoPaymentRoleList){
                            if(SoPaymentRec.RecordType.DeveloperName == 'Third_Party' ){
                                for(Claim_Line_Item__c ClaimLineItemrec : SoPaymentRec.Claim_Line_Items__r ){
                                    if(ClaimLineItemrec.Service_Order_Line_Item__r.part__c!=null){
                                        Part__c partRec = new part__c();
                                        partRec.Id =  ClaimLineItemrec.Service_Order_Line_Item__r.part__c;
                                        partRec.Qty_In_Stock__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_In_Stock__c;
                                        partRec.Qty_Committed__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_Committed__c;
                                        Decimal qtyNeed = ClaimLineItemrec.Approved_Qty__c;
                                        Decimal quantityComitted = ClaimLineItemrec.Approved_Qty__c;
                                        Decimal qtyOverSold = 0;
										Decimal ReturnCost = ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c !=null ?  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c : 0 ; 

                                        AddPartToPartMap(updateStockedMap,updateStockBucketMap,qtyNeed,quantityComitted,partRec, PartForPartReturnBuckets, ReturnCost,qtyOverSold );
                                    }
                                }


                                SoPaymentRec.Status__c = 'Invoiced';    
                            }       

                            else if(SoPaymentRec.RecordType.DeveloperName == 'Customer' ){
                                for(Claim_Line_Item__c ClaimLineItemrec : SoPaymentRec.Claim_Line_Items__r ){
                                    if(ClaimLineItemrec.Service_Order_Line_Item__r.part__c!=null){
                                        Part__c partRec = new part__c();
                                        partRec.Id =  ClaimLineItemrec.Service_Order_Line_Item__r.part__c;
                                        partRec.Qty_In_Stock__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_In_Stock__c;
                                        partRec.Qty_Committed__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_Committed__c;
                                        Decimal qtyNeed = ClaimLineItemrec.Variance_Qty__c;
                                        Decimal quantityComitted = ClaimLineItemrec.Variance_Qty__c;
                                        Decimal qtyOverSold = 0;
										Decimal ReturnCost = ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c !=null ?  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c : 0 ;

                                        AddPartToPartMap(updateStockedMap,updateStockBucketMap,qtyNeed,quantityComitted,partRec, PartForPartReturnBuckets, ClaimLineItemrec.Approved_Price__c,qtyOverSold );
                                    }
                                }


                                SoPaymentRec.Status__c = 'Invoiced';    
                            }else if(SoPaymentRec.RecordType.DeveloperName == 'Internal'){
                                for(Claim_Line_Item__c ClaimLineItemrec : SoPaymentRec.Claim_Line_Items__r ){
                                    if(ClaimLineItemrec.Service_Order_Line_Item__r.part__c!=null){
                                        Part__c partRec = new part__c();
                                        partRec.Id =  ClaimLineItemrec.Service_Order_Line_Item__r.part__c;
                                        partRec.Qty_In_Stock__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_In_Stock__c;
                                        partRec.Qty_Committed__c =  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.Qty_Committed__c;
                                        Decimal qtyNeed = ClaimLineItemrec.Variance_Qty__c;
                                        Decimal quantityComitted = ClaimLineItemrec.Variance_Qty__c;
                                        Decimal qtyOverSold = 0;
										Decimal ReturnCost = ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c !=null ?  ClaimLineItemrec.Service_Order_Line_Item__r.part__r.last_cost__c : 0 ;

                                        AddPartToPartMap(updateStockedMap,updateStockBucketMap,qtyNeed,quantityComitted,partRec, PartForPartReturnBuckets,ReturnCost,qtyOverSold );
                                    }
                                }


                                SoPaymentRec.Status__c = 'Invoiced'; 
                            }

                            else if(SoPaymentRec.RecordType.DeveloperName == 'deductible'){
                                    SoPaymentRec.Deductible_Status__c = 'Paid';
                                    SoPaymentRec.Status__c = 'Invoiced'; 
                            } 
                    }                                                                                                    


                }
             
            //Map<Id,Part__c> updateStockedMap = new Map<Id,Part__c>();
           
              for(CO_Line_Item__c coLineItemsToUpdatedRec : coLineItemsToUpdated){
                        if(coLineItemsToUpdatedRec.part__c !=null){
                            Decimal quantityComitted = coLineItemsToUpdatedRec.Qty_Committed__c  ==null ? 0 :coLineItemsToUpdatedRec.Qty_Committed__c;
                            Decimal qtyNeed = coLineItemsToUpdatedRec.Qty__c  ==null ? 0 :coLineItemsToUpdatedRec.Qty__c;
                            Decimal qtyOverSold = coLineItemsToUpdatedRec.Oversold_Qty__c;
							Decimal ReturnCost = coLineItemsToUpdatedRec.part__r.last_cost__c !=null ?  coLineItemsToUpdatedRec.part__r.last_cost__c : 0 ;
                            AddPartToPartMap(updateStockedMap,  updateStockBucketMap,qtyNeed,quantityComitted,coLineItemsToUpdatedRec.part__r,
                                     PartForPartReturnBuckets,ReturnCost,qtyOverSold);
                        }
               }    


              
               if(PartForPartReturnBuckets.size() > 0){
                    FIFOTransaction.createFIFOBucketForCustomerReturn(PartForPartReturnBuckets, closedCOInvoiceHeaderId);
               } 

              
              List<Part_FIFO_Bucket__c>  PartFifoList=  SOQLUtil.getPartFIFOBucketByPartList(updateStockedMap.keySet());
              Map<Id,List<Part_FIFO_Bucket__c>> PartToFIFOBucketMap   = new Map<Id,List<Part_FIFO_Bucket__c>>();
              for(Part_FIFO_Bucket__c partFifoRec : PartFifoList){
                if(PartToFIFOBucketMap.containsKey(partFifoRec.part__c)){
                        PartToFIFOBucketMap.get(partFifoRec.part__c).add(partFifoRec);
                }else{ 

                        List<Part_FIFO_Bucket__c> listpartFifo  = new List<Part_FIFO_Bucket__c>();
                        listpartFifo.add(partFifoRec);
                        PartToFIFOBucketMap.put(partFifoRec.part__c, listpartFifo);
                } 
              } 
            



            List<Part__c> partFifoBucketValueToUpdate = new List<Part__c>(); 
            if(updateStockBucketMap.size()> 0){
                String Result = FIFOTransaction.CreateFiFoBucketActivityForInvoice(PartToFIFOBucketMap, closedCOInvoiceHeaderId,updateStockBucketMap.values(),updateStockedMap);
            }
                        
            



            if(coLineItemsToUpdated.size() > 0) {
            	if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            	

                update coLineItemsToUpdated; 
                //update updateStockedMap.values();
            }  
            if(SoPaymentRoleList.Size()>0){
            	if(AccessControl.ifObjectFieldIsUpdateable('So_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update SoPaymentRoleList;
            }
             


             // Reverse Entry of Payment in Deposit if Payment is done from deposits.
             
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

            List<CO_Invoice_Payment__c> coInvoicePayments = new List<CO_Invoice_Payment__c>();
            closedCOInvoiceHeaderId = BPUtility.escapeSingleQuotes(closedCOInvoiceHeaderId);
            coInvoicePayments = [select Id, Payment_Method__c, Amount__c, CO_Invoice_Header__c, CO_Invoice_Header__r.CO_Header__c from CO_Invoice_Payment__c where Payment_Method__c =: USE_DEPOSIT  AND CO_Invoice_Header__c =:closedCOInvoiceHeaderId];
            
            List<CO_Deposit__c> coDepositsListToInsert = new List<CO_Deposit__c>();
            for(CO_Invoice_Payment__c coInvoicePaymentRec : coInvoicePayments) {
                CO_Deposit__c coDepositRec = new CO_Deposit__c();
                coDepositRec.Payment_Method__c = 'Invoice';
                coDepositRec.CO_Invoice_Header__c = coInvoicePaymentRec.CO_Invoice_Header__c;
                coDepositRec.CO_Header__c = coInvoicePaymentRec.CO_Invoice_Header__r.CO_Header__c;
                coDepositRec.Amount__c = -1 * coInvoicePaymentRec.Amount__c;
                coDepositsListToInsert.add(coDepositRec);
            }
            if(coDepositsListToInsert.size() > 0) {
            	if(AccessControl.ifObjectFieldIsCreateable('CO_Deposit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                insert coDepositsListToInsert;
            }
           
           
            return getCOHeaderDetails(BPUtility.getEncodedString(coHeaderId));
            
        }catch(Exception e){
            Database.rollback(sp);
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
            
             
        }
        
        return BPUtility.getEncodedString('');


    }
    
    /*
    * Name : AddPartTopartMap to create part Part Map to inventory
    */ 
  /*  public static void AddPartToPartMap( Map<Id,Part__c> updateStockedMap, Map<Id,Part__c> updateStockBucketMap ,decimal QuantityNeed,decimal quantityComitted ,Part__c PartRecordObj , List<Part__c> PartForPartReturnBuckets  ,decimal PartReturnPrice,decimal qtyOverSold){
        Part__c PartRecord = PartRecordObj.clone(false, false, false, false);
        PartRecord.Id = PartRecordObj.Id;
              if(updateStockedMap.containsKey(PartRecordObj.Id)){
                if(QuantityNeed > 0 ) {
                        quantityComitted = quantityComitted;
                        decimal CommitedOverSold = quantityComitted - (qtyOverSold !=null ? qtyOverSold: 0);
                        updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c = updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c - quantityComitted;
                        //updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c = updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c - quantityComitted;
                         updateStockBucketMap.get(PartRecord.Id).Qty_In_Stock__c = updateStockBucketMap.get(PartRecord.Id).Qty_In_Stock__c + quantityComitted;
                         updateStockBucketMap.get(PartRecord.Id).Qty_Committed__c = updateStockBucketMap.get(PartRecord.Id).Qty_Committed__c + quantityComitted;
                         //part__c partRecForBucket  = new part__c( Id = PartRecord.Id,Qty_In_Stock__c =  - qtyOverSold, Last_Cost__c =  PartReturnPrice,Description__c ='OverSold');
                         //PartForPartReturnBuckets.add(partRecForBucket);
                        

                        
                    }
                    else {
                            updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c = updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c - QuantityNeed;
                            part__c partRecForBucket  = new part__c( Id = PartRecord.Id,Qty_In_Stock__c =  - (QuantityNeed!=null ? QuantityNeed : 0), Last_Cost__c =  PartReturnPrice , Description__c ='Part Return');
                            PartForPartReturnBuckets.add(partRecForBucket);  
                 }          
              }else{


                    updateStockedMap.put(PartRecordObj.Id,PartRecordObj);
                    if(QuantityNeed > 0 ) {
                                quantityComitted = quantityComitted;
                                decimal CommitedOverSold = quantityComitted - (qtyOverSold !=null ? qtyOverSold: 0);
                                updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c = updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c - quantityComitted;
                               // updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c = updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c - quantityComitted;
                                if(CommitedOverSold > 0){
                                    updateStockBucketMap.put(PartRecord.Id,PartRecord);
                                    updateStockBucketMap.get(PartRecord.Id).Qty_In_Stock__c = CommitedOverSold;
                                    updateStockBucketMap.get(PartRecord.Id).Qty_Committed__c = CommitedOverSold;
                                }   

                                 if(qtyOverSold !=null && qtyOverSold > 0){
                                     part__c partRecForBucket  = new part__c( Id = PartRecord.Id,Qty_In_Stock__c =  - qtyOverSold, Last_Cost__c =  PartReturnPrice , Description__c ='OverSold');
                                     PartForPartReturnBuckets.add(partRecForBucket);
                                }
                    } else {


                                updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c = updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c - QuantityNeed;
                                part__c partRecForBucket  = new part__c( Id = PartRecord.Id,Qty_In_Stock__c =  - (QuantityNeed!=null ? QuantityNeed : 0), Last_Cost__c =  PartReturnPrice,Description__c ='Customer Return');
                                PartForPartReturnBuckets.add(partRecForBucket);
                    }   
              }
          



    }*/
    
      public static void AddPartToPartMap( Map<Id,Part__c> updateStockedMap, Map<Id,Part__c> updateStockBucketMap ,decimal QuantityNeed,decimal quantityComitted ,Part__c PartRecordObj , List<Part__c> PartForPartReturnBuckets  ,decimal PartReturnPrice,decimal qtyOverSold){
        if(AccessControl.ifObjectFieldIsCreateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        
        Part__c PartRecord = PartRecordObj.clone(false, false, false, false);
        PartRecord.Id = PartRecordObj.Id;
         if(updateStockedMap.containsKey(PartRecordObj.Id)){
                    if(QuantityNeed > 0 ) {
                         updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c = updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c - quantityComitted;
                         updateStockBucketMap.get(PartRecord.Id).Qty_In_Stock__c = updateStockBucketMap.get(PartRecord.Id).Qty_In_Stock__c + quantityComitted;
                         updateStockBucketMap.get(PartRecord.Id).Qty_Committed__c = updateStockBucketMap.get(PartRecord.Id).Qty_Committed__c + quantityComitted;
                    }else{

                        updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c = updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c - QuantityNeed;
                        part__c partRecForBucket  = new part__c( Id = PartRecord.Id,Qty_In_Stock__c =  - (QuantityNeed!=null ? QuantityNeed : 0), Last_Cost__c =  PartReturnPrice , Description__c ='Part Return');
                        PartForPartReturnBuckets.add(partRecForBucket);  
                    
                    }


        }
        else{
                

                updateStockedMap.put(PartRecordObj.Id,PartRecordObj);
                if(QuantityNeed > 0 ) {
                    updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c = updateStockedMap.get(PartRecordObj.Id).Qty_Committed__c - quantityComitted;
                    updateStockBucketMap.put(PartRecord.Id,PartRecord);
                    updateStockBucketMap.get(PartRecord.Id).Qty_In_Stock__c = quantityComitted;
                    updateStockBucketMap.get(PartRecord.Id).Qty_Committed__c = quantityComitted;
                }else{

                         updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c = updateStockedMap.get(PartRecordObj.Id).Qty_In_Stock__c - QuantityNeed;
                         part__c partRecForBucket  = new part__c( Id = PartRecord.Id,Qty_In_Stock__c =  - (QuantityNeed!=null ? QuantityNeed : 0), Last_Cost__c =  PartReturnPrice,Description__c ='Customer Return');
                         PartForPartReturnBuckets.add(partRecForBucket);
                
                }   


        }
      }
    /**
     * Name: getCustomer
     * Desc: Method to get Customer From customer Id
     * @param:  (1) customerId - String - Customer Id
     * @return:  String - JSON String of Customer Record
    **/
    @RemoteAction
    global static String getCustomer(String customerId){
    	customerId = BPUtility.getDecodedString(customerId);
        try{
            List<Account> customers = SOQLUtil.getCustomer(customerId, 'Customer');
            List<Customer> customerList = new List<Customer>();
            for(Account customerRec : customers) {
                customerList.add(new Customer(customerRec));
            }
            return BPUtility.getEncodedString(System.JSON.serialize(customerList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: getOtherSimilarCustomer
     * Desc: Method to find similar Customer. Defination of Similar customer will be given in corresponding user story
     * @param:  (1) customerJSONString - Customer JSON String on which search has to be performed
     * @return:  String - Filtered Customers JSON String
    **/
   @RemoteAction
    global static String getOtherSimilarCustomer(String customerJSONString){
    	customerJSONString = BPUtility.getDecodedString(customerJSONString);
        try{
            Customer customerObj = (Customer) System.JSON.deserialize(customerJSONString, Customer.class);
            Account customerRecordFilterValue = (Account) setCustomerfields(customerObj, customerObj.Type);
            List<Account> customers = SOQLUtil.getOtherSimilarCustomer(customerRecordFilterValue);
    
            List<CustomerSuggestion> customerSuggestionList = new List<CustomerSuggestion>();
            for(Account customerRec : customers) {
                if(customerRec.Type__c == 'Individual') {
                    if(customerRec.LastName__c != null && customerRec.LastName__c != '' && customerRec.LastName__c == customerRecordFilterValue.LastName__c) {
                        if(customerRec.FirstName__c == customerRecordFilterValue.FirstName__c) {
                            customerSuggestionList.add(new CustomerSuggestion(customerRec, 4));
                            continue;
                        } else if(customerRec.FirstName__c != null && customerRec.FirstName__c.length() > 1 && customerRec.FirstName__c.subString(0,1) == customerRecordFilterValue.FirstName__c) {
                            customerSuggestionList.add(new CustomerSuggestion(customerRec, 5));
                            continue;
                        } else {
                            customerSuggestionList.add(new CustomerSuggestion(customerRec, 6));
                            continue;
                        }
                    } 
                } else if(customerRec.Type__c == 'Business') {
                    if(customerRec.Name ==  customerRecordFilterValue.Name) {
                        customerSuggestionList.add(new CustomerSuggestion(customerRec, 4));
                        continue;
                    }
                }
                if(( customerRec.Email__c !=null  && customerRec.Email__c !='' && (customerRec.Email__c == customerRecordFilterValue.Email__c || 
                                                                                    customerRec.Email__c == customerRecordFilterValue.Other_Email__c))  || 
                                                                                    
                        (customerRec.Work_Email__c != null && customerRec.Work_Email__c != '' && (customerRec.Work_Email__c == customerRecordFilterValue.Work_Email__c ||
                                                                                                  customerRec.Work_Email__c == customerRecordFilterValue.Other_Email__c)) ||
                            
                        (customerRec.Other_Email__c != null && customerRec.Other_Email__c != '' && (customerRec.Other_Email__c == customerRecordFilterValue.Other_Email__c ||
                                                                                                     customerRec.Other_Email__c == customerRecordFilterValue.Work_Email__c || 
                                                                                                     customerRec.Other_Email__c == customerRecordFilterValue.Email__c))) {
                    
                    customerSuggestionList.add(new CustomerSuggestion(customerRec, 1));
                    continue;
                }
                
                if((customerRec.Home_Number__c != null && customerRec.Home_Number__c != '' && (customerRec.Home_Number__c == customerRecordFilterValue.Home_Number__c  ||
                                                                                               customerRec.Home_Number__c == customerRecordFilterValue.Mobile__c )) || 
                                                                                               
                        (customerRec.Work_Number__c != null && customerRec.Work_Number__c != '' && (customerRec.Work_Number__c == customerRecordFilterValue.Work_Number__c || 
                                                                                                    customerRec.Work_Number__c == customerRecordFilterValue.Mobile__c))  ||
                                                                                                     
                        (customerRec.Mobile__c != null && customerRec.Mobile__c != '' && (customerRec.Mobile__c == customerRecordFilterValue.Mobile__c ||
                                                                                          customerRec.Mobile__c == customerRecordFilterValue.Home_Number__c ||
                                                                                          customerRec.Mobile__c == customerRecordFilterValue.Work_Number__c ))) {
                            
                    customerSuggestionList.add(new CustomerSuggestion(customerRec, 2));
                    continue;
                }
                
                if((customerRec.Facebook__c != null && customerRec.Facebook__c != '' && customerRec.Facebook__c == customerRecordFilterValue.Facebook__c) || 
                        (customerRec.Twitter__c != null && customerRec.Twitter__c != '' && customerRec.Twitter__c == customerRecordFilterValue.Twitter__c) || 
                        (customerRec.LinkedIn__c != null && customerRec.LinkedIn__c != '' && customerRec.LinkedIn__c == customerRecordFilterValue.LinkedIn__c)) {
                    customerSuggestionList.add(new CustomerSuggestion(customerRec, 3));
                    continue;
                }
                
                String billingStreet = (customerRec.BillingStreet == null ) ? '' : customerRec.BillingStreet;
                List<String> bsList = billingStreet.split('\n');
                String billingStreet1 = (bsList.size() > 0) ? bsList[0] : '';
                
                String filterBillingStreet = (customerRecordFilterValue.BillingStreet == null ) ? '' : customerRecordFilterValue.BillingStreet;
                List<String> filterBSList = filterBillingStreet.split('\n');
                String filterBillingStreet1 = (filterBSList.size() > 0) ? filterBSList[0] : '';
                if(filterBillingStreet1 != '' && filterBillingStreet1 != null && filterBillingStreet1 != 'null' && filterBillingStreet1 == billingStreet1) {
                    customerSuggestionList.add(new CustomerSuggestion(customerRec, 7));
                }
            }
            //system.assert(false, customerSuggestionList);
            customerSuggestionList.sort();
            Integer listSizeLimit = 7;
            if(customerSuggestionList.size() > listSizeLimit) {
                List<CustomerSuggestion> customerSuggestionLimitedList = new List<CustomerSuggestion>();
                for(Integer i = 0 ; i < listSizeLimit ; i++) {
                    customerSuggestionLimitedList.add(customerSuggestionList[i]);
                }
                customerSuggestionList = new List<CustomerSuggestion>();
                customerSuggestionList.addAll(customerSuggestionLimitedList);
            }
            //system.assert(false, customerSuggestionList);
            return BPUtility.getEncodedString(System.JSON.serialize(customerSuggestionList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: getSimilarCOUs
     * Desc: Method to get Similar COUs based on VIN Number
     * @param:  (1) VINNumber - String - VInNumber as String
     * @return:  String - JSONString of similar COUs.
    **/
   @RemoteAction
    global static String getSimilarCOUs(String VINNumber){
    	VINNumber = BPUtility.getDecodedString(VINNumber);
        try{
            List<Customer_Owned_Unit__c> custOwnedUnits = SOQLUtil.getSimilarCOUs(VINNumber);
            List<CustomerOwnedUnit> custOwnedUnitList = new List<CustomerOwnedUnit>();
            for(Customer_Owned_Unit__c custOwnedUnitRec : custOwnedUnits) {
                if(custOwnedUnitRec.VIN__c != null && custOwnedUnitRec.VIN__c != '') {
                    custOwnedUnitList.add(new CustomerOwnedUnit(custOwnedUnitRec));
                }
            }
            return BPUtility.getEncodedString(System.JSON.serialize(custOwnedUnitList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: getAllLookupFieldsJSON
    * Desc: Method to get JSON String of all look up fields JSON
    * @param:  
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String getAllLookupFieldsJSON(){
        try{
            List<Country__c> countryList = SOQLUtil.getAllCountry();
            List<Country__c> countryWrapperList = SOQLUtil.getAllCountryWrapper();
            List<Sales_Tax__c> salesTaxList = SOQLUtil.getSalesTax(new List<Id>());
            List<Price_Level__c> priceLevelList = SOQLUtil.getPriceLevel(new List<Id>());
            List<Unit_Make__c> unitMakeList = SOQLUtil.getUnitMake(new List<Id>());
            List<Unit_Make__c> unitMakeWrapperList = SOQLUtil.getUnitMakeWrapper();
            
            COUFieldWrapper cOUFieldWrapperObj = new COUFieldWrapper(countryList, countryWrapperList, salesTaxList, priceLevelList, unitMakeList, unitMakeWrapperList, new List<Category__c>());
            return BPUtility.getEncodedString(System.JSON.serialize(cOUFieldWrapperObj));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: saveCustomer
     * Desc: Method to save customer into Database
     * @param:  (1) customerJSONString - String - customer JSOn String 
     *          (2) couJSONString - String - Customer Ownend Unit String
     * @return:  String - JSON String of Customer with ID and Name of Customer
    **/
    @RemoteAction
    global static String saveCustomer(String customerJSONString, String couJSONString){
    	customerJSONString = BPUtility.getDecodedString(customerJSONString);
    	couJSONString = BPUtility.getDecodedString(couJSONString);
        try{
        	if(AccessControl.ifObjectFieldIsCreateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Customer_Owned_Unit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	

            Customer customerObj = Customer.parse(customerJSONString);
            System.debug(couJSONString);
            List<CustomerOwnedUnit> couObjList = CustomerOwnedUnit.parse(couJSONString);
            Account customerToInsert = new Account();
            customerToInsert = (Account) setCustomerfields(customerObj, customerObj.Type);
            if(customerToInsert.Name != null ) {
                upsert customerToInsert;
            }
            String customerId = customerToInsert.Id;
            
            List<Customer_Owned_Unit__c> couListToInsert = new List<Customer_Owned_Unit__c>();
            for(CustomerOwnedUnit couObj : couObjList) {
                if(String.isNotBlank(couObj.VIN)) {
                    Customer_Owned_Unit__c couRec = new Customer_Owned_Unit__c();
                    couRec.VIN__c = couObj.VIN;
                    couRec.Account__c = customerId;
                    couRec.Colour__c = couObj.Color;
                    couRec.Mileage__c = couObj.Mileage;
                    couRec.Plate__c = couObj.Plate;
                    couRec.Submodel__c = couObj.SubModel;
                    couRec.Unit_Make__c = couObj.Make;
                    couRec.Unit_Model__c = couObj.Model;
                    couRec.Year__c = couObj.Year;
                    couListToInsert.add(couRec);
                }
             }
             if(couListToInsert.size() > 0) {
                insert couListToInsert ;
             }
             JSONGenerator gen = JSON.createGenerator(true);
             gen.writeStartObject();
             gen.writeStringField('Id', customerId);
             gen.writeStringField('CustomerName', customerToInsert.Name);
             gen.writeEndObject();
             return BPUtility.getEncodedString(gen.getAsString());


        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
     * Name: setCustomerfields
     * Desc: Method to set fields of Customer Object
     * @param:  (1) custObj - Customer - Customer Obj
     *          (2) typeOfCustomer - String - Type of Customer in Database
     * @return:  Sobject - Sobject with populated values of account object
    **/
    private static Sobject setCustomerfields(Customer custObj, String typeOfCustomer){
        try{
            SObject customerToInsert = new Account();
            
            if(typeOfCustomer == 'Individual') {
                customerToInsert.put('FirstName__c', custObj.FirstName);
                customerToInsert.put('LastName__c', BPUtility.escapeSingleQuotes(custObj.LastName));
                if(custObj.FirstName != null && custObj.LastName != null) {
                    customerToInsert.put('Name', custObj.FirstName + ' ' + custObj.LastName);
                }
                customerToInsert.put('Company_Name__c', custObj.Company);
                customerToInsert.put('Job_Title__c', custObj.JobTitle);
                customerToInsert.put('Nickname__c', custObj.Nickname);
            } else if(typeOfCustomer == 'Business'){
                customerToInsert.put('Name', custObj.BusinessName);
            }
            
            customerToInsert.put('Home_Number__c', custObj.HomeNumber);
            customerToInsert.put('Mobile__c', custObj.OtherPhone);
            customerToInsert.put('Work_Number__c', custObj.WorkNumber);
            customerToInsert.put('Email__c', custObj.HomeEmail);
            
            if(custObj.BirthDay != null && custObj.BirthMonth != null && custObj.BirthYear != null) {
                Date birth_Date = Date.newInstance(custObj.BirthYear, custObj.BirthMonth, custObj.BirthDay);
                customerToInsert.put('Birth_Date__c', birth_Date);
            } else {
                customerToInsert.put('Birth_Date__c', null);
            }
                
            customerToInsert.put('Type__c', custObj.Type);
            customerToInsert.put('Active__c', custObj.Active);
            customerToInsert.put('Is_Customer__c', custObj.IsCustomer);
            customerToInsert.put('Is_Vendor__c', custObj.IsVendor);
            customerToInsert.put('Work_Email__c', custObj.WorkEmail);
            customerToInsert.put('Other_Email__c', custObj.OtherEmail);
            customerToInsert.put('SA_same_as_BA__c', custObj.IsBothAddressSame);
            
            customerToInsert.put('Home_Number_SMS__c', custObj.HomeNumberSMS);
            customerToInsert.put('Work_Number_SMS__c', custObj.WorkNumberSMS);
            customerToInsert.put('Mobile_Number_SMS__c', custObj.MobileNumberSMS);
            
            if(custObj.PreferredEmail == 'HomeEmail') {
                customerToInsert.put('Preferred_Email__c', custObj.HomeEmail);
            } else if(custObj.PreferredEmail == 'WorkEmail') {
                customerToInsert.put('Preferred_Email__c', custObj.WorkEmail);
            } else if(custObj.PreferredEmail == 'OtherEmail') {
                customerToInsert.put('Preferred_Email__c', custObj.OtherEmail);
            } else if(custObj.PreferredEmail == '') {
                customerToInsert.put('Preferred_Email__c', null);
            }
            
            if(custObj.PreferredPhone == 'HomeNumber') {
                customerToInsert.put('Preferred_Phone__c', custObj.HomeNumber);
            } else if(custObj.PreferredPhone == 'OtherPhone') {
                customerToInsert.put('Preferred_Phone__c', custObj.OtherPhone);
            } else if(custObj.PreferredPhone == 'WorkNumber') {
                customerToInsert.put('Preferred_Phone__c', custObj.WorkNumber);
            } else if(custObj.PreferredPhone == '') {
                customerToInsert.put('Preferred_Phone__c', null);
            } 
            
            if(custObj.PreferredSMS == 'HomeNumber') {
                customerToInsert.put('Preferred_SMS__c', custObj.HomeNumber);
            } else if(custObj.PreferredSMS == 'OtherPhone') {
                customerToInsert.put('Preferred_SMS__c', custObj.OtherPhone);
            } else if(custObj.PreferredSMS == 'WorkNumber') {
                customerToInsert.put('Preferred_SMS__c', custObj.WorkNumber);
            } else if(custObj.PreferredSMS == '') {
                customerToInsert.put('Preferred_SMS__c', null);
            } 
            
            customerToInsert.put('Facebook__c', custObj.FacebookLink);
            customerToInsert.put('Twitter__c', custObj.TwitterLink);
            customerToInsert.put('LinkedIn__c', custObj.LinkedInLink);
            
            if(custObj.BillingStreet1 == null && custObj.BillingStreet2 != null) {
                customerToInsert.put('BillingStreet', '\n' + custObj.BillingStreet2);
            } else if(custObj.BillingStreet2 == null && custObj.BillingStreet1 != null) {
                customerToInsert.put('BillingStreet', custObj.BillingStreet1 + '\n');
            } else if(custObj.BillingStreet1 != null && custObj.BillingStreet2 != null) {
                customerToInsert.put('BillingStreet', custObj.BillingStreet1 + '\n' + custObj.BillingStreet2);
            }
            customerToInsert.put('BillingCity', custObj.BillingCity);
            customerToInsert.put('BillingCountry', custObj.BillingCountry);
            customerToInsert.put('BillingState', custObj.BillingState);
            customerToInsert.put('BillingPostalCode', custObj.BillingPostalCode);
            
            if(!custObj.IsBothAddressSame) {
                if(custObj.ShippingStreet1 == null && custObj.ShippingStreet2 != null) {
                    customerToInsert.put('ShippingStreet', '\n' + custObj.ShippingStreet2);
                } else if(custObj.ShippingStreet2 == null && custObj.ShippingStreet1 != null) {
                    customerToInsert.put('ShippingStreet', custObj.ShippingStreet1 + '\n');
                } else if(custObj.ShippingStreet1 != null && custObj.ShippingStreet2 != null) {
                    customerToInsert.put('ShippingStreet', custObj.ShippingStreet1 + '\n' + custObj.ShippingStreet2);
                }
                customerToInsert.put('ShippingCity', custObj.ShippingCity);
                customerToInsert.put('ShippingCountry', custObj.ShippingCountry);
                customerToInsert.put('ShippingState', custObj.ShippingState);
                customerToInsert.put('ShippingPostalCode', custObj.ShippingPostalCode);
            } else {
                customerToInsert.put('ShippingStreet', customerToInsert.get('BillingStreet'));
                customerToInsert.put('ShippingCity', custObj.BillingCity);
                customerToInsert.put('ShippingCountry', custObj.BillingCountry);
                customerToInsert.put('ShippingState', custObj.BillingState);
                customerToInsert.put('ShippingPostalCode', custObj.BillingPostalCode);
            }

            customerToInsert.put('Price_Level__c', custObj.PriceLevelId);
            customerToInsert.put('Sales_Tax__c', custObj.SalesTaxId);
            customerToInsert.put('Purchase_Tax__c', custObj.PurchaseTaxId);
             if(custObj.PriceLevelId == null && String.isBlank(custObj.Id)) {
             	if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	List<Price_Level__c> defaultPriceLevel = [select Id from Price_Level__c where Default__c = true];
            	if(defaultPriceLevel.size() > 0) {
            		customerToInsert.put('Price_Level__c', defaultPriceLevel[0].Id);
            	}
            }
            
            if(custObj.SalesTaxId == null && String.isBlank(custObj.Id)) {
            	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	List<Sales_Tax__c> defaultSalesTax = [select Id from Sales_Tax__c where Default__c = true];
            	if(defaultSalesTax.size() > 0) {
            		customerToInsert.put('Sales_Tax__c', defaultSalesTax[0].Id);
            	}
            }
            if(custObj.Id != null && custObj.Id != '') {
                customerToInsert.put('Id', custObj.Id);
            }   
            return customerToInsert;
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return null;
    }
    
    /**
    * Name: addVOHeaderToCOLI
    * Desc: Method to add VO Header Rec to Special Order CO Line Item Rec.
    * @param:   (1) partId - String - Id of Part
    *           (2) coliId - Id -CO Line Item record Id
    *           (3) voHeaderId - String - id of voHeader
    *           (4) coHeaderId - String - id of coHeader
    *           (5)itemsPageSortAttrsJSON - String - page sort attributes of item
    *           (6)customersPageSortAttrsJSON- String - page sort attributes of customer
    *           (7)stocksPageSortAttrsJSON- String - page sort attributes of stock
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String addVOHeaderToCOLI(String partId, String coliId, String voHeaderId, String coHeaderId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON){
        partId = BPUtility.getDecodedString(partId);
        coliId = BPUtility.getDecodedString(coliId);
        voHeaderId = BPUtility.getDecodedString(voHeaderId);  
        coHeaderId = BPUtility.getDecodedString(coHeaderId);
        itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
         try{

          if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
          

			voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
            Vendor_Order_Header__c voh = [Select Id, Name, Status__c, Vendor__c from Vendor_Order_Header__c where Id =: voHeaderId];
            CO_Line_Item__c coli = new CO_Line_Item__c(Id = coliId);
            coli.VO_Number__c = voh.Name;
            coli.VO_Status__c = voh.Status__c;
            update coli;
            
            VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(voh.Vendor__c), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON),
            											BPUtility.getEncodedString( customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON));
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,user,coInvoiceHeader,specialOrder'));
        }
        catch(Exception e){

            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    

    
    /**
    * Name: addVOHeaderToCOLIServiceOrder
    * Desc: Method to add VO Header Rec to Special Order CO Line Item Rec.
    * @param: (1) partId - String - Id of Part
    *         (2) coliId - Id -CO Line Item record Id
    *         (3) voHeaderId - String - id of voHeader
    *         (4) coHeaderId - String - id of coHeader
    *         (5)itemsPageSortAttrsJSON - String - page sort attributes of item
    *         (6)customersPageSortAttrsJSON- String - page sort attributes of customer
    *         (7)stocksPageSortAttrsJSON- String - page sort attributes of stock
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
   
    @RemoteAction
    global static String addVOHeaderToCOLIServiceOrder (String partId,String coliId, String voHeaderId, String coHeaderId,String itemsPageSortAttrsJSON,String customersPageSortAttrsJSON,String stocksPageSortAttrsJSON) {
    	partId = BPUtility.getDecodedString(partId);
        coliId = BPUtility.getDecodedString(coliId);
        voHeaderId = BPUtility.getDecodedString(voHeaderId);
        coHeaderId = BPUtility.getDecodedString(coHeaderId);
        itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	
			voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
            Vendor_Order_Header__c voh = [Select Id, Name, Status__c, Vendor__c from Vendor_Order_Header__c where Id =: voHeaderId];
            CO_Line_Item__c coli = new CO_Line_Item__c(Id = coliId);
            coli.VO_Number__c = voh.Name;  
            coli.VO_Status__c = voh.Status__c;  
            update coli;
            VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(voh.Vendor__c), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voHeaderId), 
            										 BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON));
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


        
    }
    
    // ALL SO related Methods
    /**
    * Name: createSOHeader
    * Desc: Method to add VO Header Rec to Special Order CO Line Item Rec.
    * @param:   (1) coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String createSOHeader(String coHeaderId){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('AggregateResult') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			coHeaderId = BPUtility.escapeSingleQuotes(coHeaderId);
            List<AggregateResult> soHeaderList = [select count(Id) from Service_Order_Header__c where CO_Header__c = :coHeaderId];
            Integer totalSO = Integer.valueOf(soHeaderList[0].get('expr0'));
            
            List<Category__c> categoryList = [select Id, Name, Default__c from Category__c where Type__c = 'Internal Expense' AND Default__c = true];
            String defaultCategoryId;
            if(categoryList.size() > 0) {
                defaultCategoryId = categoryList[0].Id;
            }
            
            Service_Order_Header__c soHeaderToInsert = new Service_Order_Header__c();
            soHeaderToInsert.Name__c = 'Service Order ' + (totalSO + 1);
            soHeaderToInsert.CO_Header__c = coHeaderId;
            soHeaderToInsert.Status__c = 'New';
            soHeaderToInsert.Work_Status__c = 'New';
            soHeaderToInsert.Category__c = defaultCategoryId;
            insert soHeaderToInsert;
            
            //system.assert(false, soHeaderToInsert);
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,pinItems,checkOut'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: saveCOU
    * Desc: Method to add VO Header Rec to Special Order CO Line Item Rec.
    * @param:   (1)couJSONString - String - customer owned unit string
    *           (2)customerId - String - id of Customer Record
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String saveCOU(String couJSONString, String customerId) {
    	couJSONString = BPUtility.getDecodedString(couJSONString);
    	customerId = BPUtility.getDecodedString(customerId);
        try{
        	if(AccessControl.ifObjectFieldIsCreateable('Customer_Owned_Unit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	

            List<CustomerOwnedUnit> couObjList = CustomerOwnedUnit.parse(couJSONString);
            List<Customer_Owned_Unit__c> couListToInsert = new List<Customer_Owned_Unit__c>();
            for(CustomerOwnedUnit couObj : couObjList) {
                Customer_Owned_Unit__c couRec = new Customer_Owned_Unit__c();
                couRec.VIN__c = couObj.VIN;
                couRec.Account__c = customerId;
                couRec.Colour__c = couObj.Color;
                couRec.Mileage__c = couObj.Mileage;
                couRec.Plate__c = couObj.Plate;
                couRec.Submodel__c = couObj.SubModel;
                couRec.Unit_Make__c = couObj.Make;
                couRec.Unit_Model__c = couObj.Model;
                couRec.Year__c = couObj.Year;
                couListToInsert.add(couRec);
            }
            if(couListToInsert.size() > 0) {
                insert couListToInsert ;
            }
            
            List<Customer_Owned_Unit__c> couRecords = SOQLUtil.getCOUListByCustomerId(customerId);
            SOHeaderWrapper.SOMasterData masterDateObj = new SOHeaderWrapper.SOMasterData(new List<Transaction_Type__c>(), couRecords, new List<Account>(), new List<Category__c>());
            return BPUtility.getEncodedString(System.JSON.serialize(masterDateObj)); 
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: savePinItems
    * Desc: Method to add VO Header Rec to Special Order CO Line Item Rec.
    * @param:  (1)pinItemsJSONStr - String - pin items string 
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String savePinItems(String pinItemsJSONStr){
    	pinItemsJSONStr = BPUtility.getDecodedString(pinItemsJSONStr);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            SOHeaderWrapper soHeaderObj = (SOHeaderWrapper) System.JSON.deserialize(pinItemsJSONStr, SOHeaderWrapper.class);
            User currentUser = new User();
            currentUser.Id = UserInfo.getUserId();
            
            String pinItemStr = '';
            for(Integer i = 0; i < soHeaderObj.PinnedItemList.size(); i++) {
                if(i == soHeaderObj.PinnedItemList.size() - 1) {
                    pinItemStr += soHeaderObj.PinnedItemList[i];
                } else {
                    pinItemStr += soHeaderObj.PinnedItemList[i] + ',';
                }
            }
            
            currentUser.SO_Pinned_Info__c = pinItemStr;
            update currentUser;
            
            return BPUtility.getEncodedString('Saved');


        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: addLineItems
    * Desc: Method to add Line Items in Items Grid.
    * @param:   (1) lineItemId - String - id of line item
    *           (2) soHeaderId - String - id of Service Order Header
    *           (3) coHeaderId - String - id of coHeader
    *           (4) customerId - String - id of Customer 
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String addLineItems(String lineItemId, String soHeaderId, String coHeaderId, String customerId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	customerId = BPUtility.getDecodedString(customerId);
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            String objectName = (Id.valueOf(lineItemId)).getSObjectType().getDescribe().getName();
            if(objectName == Constants.NAMESPACE + 'Kit_Header__c') {
                Id soKHId = insertKitHeaderInGrid(lineItemId, soHeaderId);
                SO_KLI_Recalculation.SOPriceCalcultaionByPriceLevelForSOKitHeaders(customerId, coHeaderId, new List<Id>{soKHId}, soHeaderId);
            } else if(objectName == Constants.NAMESPACE + 'Part__c') {
                insertPartInGrid(lineItemId, soHeaderId);
            } else if(objectName == Constants.NAMESPACE + 'Labour_Code__c') {
                insertLabourInGrid(lineItemId, soHeaderId);
            } else if(objectName == Constants.NAMESPACE + 'Fee__c') {
                insertFeeInGrid(lineItemId, soHeaderId);  
            }
            
            soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
            if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Service_Order_Header__c> soHeaderList = [select Status__c, (select Id,Kit_Price__c,Actual_Kit_Price__c,Qty_Needed__c from Service_Order_Line_Items__r) from Service_Order_Header__c where Id =: soHeaderId];
            if(soHeaderList.size() > 0 && soHeaderList[0].Service_Order_Line_Items__r != null && soHeaderList[0].Service_Order_Line_Items__r.size() > 0) {
                if(Constants.SOStatusToPriorityMap.get(soHeaderList[0].Status__c) < 3) {
                    soHeaderList[0].Status__c = 'In Progress';
                }
                update soHeaderList[0];
            }
            
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    
    /**
    * Name: changeSOHeaderStatusToComplete
    * Desc: change status of service order header
    * @param:  (1) soHeaderId - String - id of Service Order Header
    *          (2) coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String changeSOHeaderStatusToComplete(String soHeaderId, String coHeaderId) {
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	
			soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
            List<Service_Order_Header__c> soHeaderList = [select Status__c from Service_Order_Header__c where Id =: soHeaderId];
            if(soHeaderList.size() > 0 && Constants.SOStatusToPriorityMap.get(soHeaderList[0].Status__c) < 4) {
                soHeaderList[0].Status__c = 'Complete';
                update soHeaderList[0];
            }
            
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,checkOut'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    
    /**
    * Name: updateSOLineItems
    * Desc: update service order line items
    * @param:   (1)lineItemJSON - String - line item string
    *           (2) coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String updateSOLineItems(String lineItemJSON, String coHeaderId) {
    	lineItemJSON = BPUtility.getDecodedString(lineItemJSON);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        try{
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            SOHeaderWrapper.SOLineItem soHeaderObj = (SOHeaderWrapper.SOLineItem) System.JSON.deserialize(lineItemJSON, SOHeaderWrapper.SOLineItem.class);
            //System.assert(false,soHeaderObj);
            if(soHeaderObj.Id == null) {
                return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
            } 
            

            error = SO_KLI_Recalculation.updateSOKitLineItem(soHeaderObj);
            system.debug('!!!!!!!!!!!!!!!!' + error);
            if(error == null || error.ResponseCode == '200') {
                // Special condition :- Related to updation of service order kit line items fixed price value
                Service_Order_Line_Item__c soliToUpdate = new Service_Order_Line_Item__c();
                soliToUpdate.Id = soHeaderObj.Id;
                soliToUpdate.Qty_Needed__c = soHeaderObj.QtyNeeded;
                if(soHeaderObj.StockCommited > soHeaderObj.QtyNeeded) {
                    soliToUpdate.Qty_Committed__c = soHeaderObj.QtyNeeded;
                } else {  
                    soliToUpdate.Qty_Committed__c = soHeaderObj.StockCommited;
                }
				if(isTaxIncludingPricing) {
                    if(soHeaderObj.Tax == -100) { // To Prevent Divide by zero error
                        soHeaderObj.Tax = 0;
                    }
                    soliToUpdate.kit_Price__c = (soHeaderObj.KitPrice / (1 + soHeaderObj.Tax / 100 ));

                } else {
                    soliToUpdate.kit_Price__c = soHeaderObj.KitPrice;
                }
                update soliToUpdate;

            }
            
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: updateSOKHLineItems
    * Desc: Method to update service order kit header line items
    * @param:       (1)soKHItemJSON - String service order kit header
                    (2) coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String updateSOKHLineItems(String soKHItemJSON, String coHeaderId) {
    	soKHItemJSON = BPUtility.getDecodedString(soKHItemJSON);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            SOHeaderWrapper.SOGrid soGridObj = (SOHeaderWrapper.SOGrid) System.JSON.deserialize(soKHItemJSON, SOHeaderWrapper.SOGrid.class);
            SOHeaderWrapper.SOKitHeader sokhObj = soGridObj.SOKH;
    
            if(sokhObj.Id != null) {
            	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	
                Service_Order_Kit_Header__c soKH = [SELECT Id, Fixed_Price__c FROM Service_Order_Kit_Header__c WHERE Id =: sokhObj.Id];
                if(soKH.Fixed_Price__c.SetScale(3) != sokhObj.FixedPrice) {
                    error = SO_KLI_Recalculation.updateSOKitHeader(sokhObj);
                }
            }
            
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    



    /**
    * Name: removeLineItems
    * Desc: Method to remove Line Items in Items Grid.
    * @param:   (1) lineItemId - String - id of line item
                (2) coHeaderId - String - id of coHeader
                (3) soHeaderId - String - id of Service Order Header
    *         
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String removeLineItems(String lineItemId, String coHeaderId, String soHeaderId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            String objectName = (Id.valueOf(lineItemId)).getSObjectType().getDescribe().getName();
            if(objectName == CONSTANTS.NAMESPACE + 'Service_Order_Line_Item__c') {
                removeSOLineItem(lineItemId);
            } else if(objectName == CONSTANTS.NAMESPACE + 'Service_Order_Kit_Header__c') {
                removeSOKHItems(lineItemId);
            }
            soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
            List<Service_Order_Header__c> soHeaderList = [select Status__c, (select Id from Service_Order_Line_Items__r) from Service_Order_Header__c where Id =: soHeaderId];
            if(soHeaderList.size() > 0 && soHeaderList[0].Service_Order_Line_Items__r != null && soHeaderList[0].Service_Order_Line_Items__r.size() == 0 && Constants.SOStatusToPriorityMap.get(soHeaderList[0].Status__c) < 2) {
                soHeaderList[0].Status__c = 'Ready';
                update soHeaderList[0];
            }
            
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: splitSOKHItem
    * Desc: Method to split service order kit header 
    * @param:   (1)lineItemId - String - id of line item
                (2) coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String splitSOKHItem(String lineItemId, String coHeaderId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectIsDeletable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	if(AccessControl.ifObjectIsDeletable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }

			lineItemId = BPUtility.escapeSingleQuotes(lineItemId);
            List<Service_Order_Kit_Header__c> sokhList = [select Id,
                                                             (select Actual_Kit_Price__c, Kit_Price__c, Labour_Code__c, Fee__c, Part__c, Qty_Needed__c, Service_Order_Header__c from Service_Order_Line_Items__r)
                                                             from Service_Order_Kit_Header__c where Id =: lineItemId];
                                                             
            List<Service_Order_Line_Item__c> soLineItemListToInsert = new List<Service_Order_Line_Item__c>();
            List<Service_Order_Line_Item__c> soLineItemListToDelete = new List<Service_Order_Line_Item__c>();
            
            for(Service_Order_Kit_Header__c sokhRec : sokhList) {
                for(Service_Order_Line_Item__c soliRec : sokhRec.Service_Order_Line_Items__r) {
                    Service_Order_Line_Item__c newSOLIRec = new Service_Order_Line_Item__c();
                    newSOLIRec.Service_Order_Header__c = soliRec.Service_Order_Header__c;
                    
                    newSOLIRec.Labour_Code__c = soliRec.Labour_Code__c;
                    newSOLIRec.Fee__c = soliRec.Fee__c;
                    newSOLIRec.Part__c = soliRec.Part__c;
                    newSOLIRec.Qty_Needed__c = soliRec.Qty_Needed__c;
                    if(newSOLIRec.Labour_Code__c != null) {
                        newSOLIRec.Kit_Price__c = soliRec.Actual_Kit_Price__c;
                        newSOLIRec.Actual_Kit_Price__c = soliRec.Actual_Kit_Price__c;
                    }
                    //CO_Line_Item__c newCOLIRec = coliRec.clone(false, true, false, false);
                    soLineItemListToInsert.add(newSOLIRec);
                    soLineItemListToDelete.add(soliRec);
                }
            }
            
            if(soLineItemListToDelete.size() > 0) {
                delete soLineItemListToDelete;
            }
                                                             
            if(sokhList.size() > 0) {
                delete sokhList;
            }
            
            if(soLineItemListToInsert.size() > 0) {
                insert soLineItemListToInsert;
            }
            
            return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: removeSOLineItem
    * Desc: Method to remove service order line item
    * @param:  (1)lineItemId - String - id of line item
    * @return: void
    **/
    private static void removeSOLineItem(String lineItemId) {
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	lineItemId = BPUtility.escapeSingleQuotes(lineItemId);

        List<Service_Order_Line_Item__c> soliList = [select Id from Service_Order_Line_Item__c where Id =: lineItemId];
        if(AccessControl.ifObjectIsDeletable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        if(soliList.size() > 0) {
            delete soliList;
        }
    }
    
    /**
    * Name: removeSOKHItems
    * Desc: Method to add Line Items in Items Grid.
    * @param:  (1)lineItemId - String - id of line item
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    private static void removeSOKHItems(String lineItemId) {
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectIsDeletable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	if(AccessControl.ifObjectIsDeletable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	
    	lineItemId = BPUtility.escapeSingleQuotes(lineItemId);

        List<Service_Order_Kit_Header__c> sokhList = [select Id, (Select Id from Service_Order_Line_Items__r) from Service_Order_Kit_Header__c where Id =: lineItemId];
        
        List<Service_Order_Line_Item__c> soliListToDelete = new List<Service_Order_Line_Item__c>();
        for(Service_Order_Kit_Header__c sokhRec : sokhList) {
            if(sokhRec.Service_Order_Line_Items__r != null && sokhRec.Service_Order_Line_Items__r.size() > 0) {
                soliListToDelete.addAll(sokhRec.Service_Order_Line_Items__r);
            }
        }
        
        if(soliListToDelete.size() > 0) {
            delete soliListToDelete;
        }
        if(sokhList.size() > 0) {
            delete sokhList;
        }
    } 
    
    /**
    * Name: insertKitHeaderInGrid
    * Desc: Method to insert kit header in Grid
    * @param:   (1)lineItemId - String - id of line item
    *           (2)soHeaderId - String - id of Service Order Header
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    private static Id insertKitHeaderInGrid(String lineItemId, String soHeaderId) {
    	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        List<Kit_Header__c> kitHeaderList = SOQLUtil.getKitHeaderRec(new Map<String, String>{ 'Id' => lineItemId });
        if(kitHeaderList.size() == 0) {
            return null;
        }
        Service_Order_Kit_Header__c sokhRec = new Service_Order_Kit_Header__c();
        sokhRec.Service_Order_Header__c = soHeaderId;
        sokhRec.Kit_Header__c = kitHeaderList[0].Id;
        sokhRec.Can_Split__c = kitHeaderList[0].Can_Split__c;
        sokhRec.Code__c = kitHeaderList[0].Code__c;
        sokhRec.Description__c = kitHeaderList[0].Description__c;
        sokhRec.Fixed_Price__c = kitHeaderList[0].Fixed_Price__c;
        sokhRec.Fixed_Price_Flag__c = kitHeaderList[0].Fixed_Price_Flag__c;
        sokhRec.Is_Fixed_Kit_Header_SO__c = kitHeaderList[0].Fixed_Price_Flag__c;
        sokhRec.Service_Kit__c = kitHeaderList[0].Service_Kit__c;
        sokhRec.Actual_Kit_Price__c = kitHeaderList[0].Fixed_Price__c;
        insert sokhRec;
        insertAllKitLineItems(lineItemId, soHeaderId, sokhRec.Id);
        
        // system.assert(false,soliListToInsert);
        return sokhRec.Id;
    }
    
    /**
    * Name: insertAllKitLineItems
    * Desc: Method to add Kit Line Items in Items Grid.
    * @param:   (1)lineItemId - String - id of line item
    *           (2)soHeaderId - String - id of Service Order Header
    *           (3)sokhRecId - String - id of service order kit header
    * @return: void
    **/
    private static void insertAllKitLineItems(String lineItemId, String soHeaderId, String sokhRecId) {
    	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        List<Kit_Header_Line_Item__c> khLineItemList = SOQLUtil.getKHLineItemRec(new Map<String, String>{ 'Kit_Header__c' => lineItemId });
        if(khLineItemList.size() == 0) {
            return;
        }
        //system.assert(false,khLineItemList);  
        List<Service_Order_Line_Item__c> soliListToInsert = new List<Service_Order_Line_Item__c>();
        for(Kit_Header_Line_Item__c khliRec : khLineItemList) {
            Service_Order_Line_Item__c soliRec = new Service_Order_Line_Item__c();
            
            soliRec.Service_Order_Header__c = soHeaderId;
            soliRec.Service_Order_Kit_Header__c = sokhRecId;
            soliRec.Fixed_Price__c = khliRec.Fixed_Price__c;
            soliRec.Is_Fixed_Kit_LineItem_SO__c = khliRec.Fixed_Price__c;
            soliRec.Part__c = khliRec.Part__c;
            soliRec.Labour_Code__c = khliRec.Labour_Code__c;
            if(khliRec.Labour_Code__c != null) {
                soliRec.Fixed_Price__c = khliRec.Labour_Code__r.Fixed_Rate__c;
            }
            soliRec.Kit_Price__c = (khliRec.Kit_Price__c != null) ? khliRec.Kit_Price__c : 0;
            soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
            soliRec.Qty_Needed__c = khliRec.Qty_Needed__c;
            soliListToInsert.add(soliRec);
        }
        //system.assert(false, soliListToInsert);
        
        if(soliListToInsert.size() > 0) {
            insert soliListToInsert;
        }


    }
    
    /**
    * Name: insertPartInGrid
    * Desc: Method to insert part in Grid.
    * @param:   (1)lineItemId - String - id of line item
    *           (2)soHeaderId - String - id of Service Order Header
    * @return: void
    **/
    private static void insertPartInGrid(String lineItemId, String soHeaderId) {
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        List<Part__c> partList = SOQLUtil.getPartDetailRecordsByFieldName('Id', lineItemId);
        if(partList.size() == 0) {
            return;
        }
        
        Service_Order_Line_Item__c soliRec = new Service_Order_Line_Item__c();
        soliRec.Service_Order_Header__c = soHeaderId;
        soliRec.Part__c = partList[0].Id;
        soliRec.Qty_Needed__c = 1;
        //soliRec.Kit_Price__c = (partList[0].Retail_Price__c != null) ? partList[0].Retail_Price__c : 0;
        ///soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
        ///soliRec.Actual_Kit_Price__c 
        insert soliRec;
    }
    
    
    /**
    * Name: insertLabourInGrid
    * Desc: Method to insert labour in Grid
    * @param:   (1)lineItemId - String - id of line item
    *           (2)soHeaderId - String - id of Service Order Header
    * @return: void
    **/
    private static void insertLabourInGrid(String lineItemId, String soHeaderId) {
    	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        List<Labour_Code__c> labourList = SOQLUtil.getLabourRecords(new Set<Id>{lineItemId}, null);
        if(labourList.size() == 0) {
            return;
        }
        
        Service_Order_Line_Item__c soliRec = new Service_Order_Line_Item__c();
        soliRec.Service_Order_Header__c = soHeaderId;
        soliRec.Labour_Code__c = labourList[0].Id;
        soliRec.Qty_Needed__c = 1;
        soliRec.Qty_Committed__c = 1;
        soliRec.Kit_Price__c = (labourList[0].Rate__c != null) ? labourList[0].Rate__c : 0;
        soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
        insert soliRec;
    }
    
    /**
    * Name: insertFeeInGrid
    * Desc: Method to insert fee in Grid
    * @param:   (1)lineItemId - String - id of line item
    *           (2)soHeaderId - String - id of Service Order Header
    * @return: void
    **/
    private static void insertFeeInGrid(String lineItemId, String soHeaderId) {
    	if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        List<Fee__c> feeList = SOQLUtil.getFeeByFieldName(new Map<String, String>{'Id' => lineItemId});
        if(feeList.size() == 0) {
            return;
        }
        
        Service_Order_Line_Item__c soliRec = new Service_Order_Line_Item__c();
        soliRec.Service_Order_Header__c = soHeaderId;
        soliRec.Fee__c = feeList[0].Id;
        soliRec.Qty_Needed__c = 1;
        soliRec.Qty_Committed__c = 1;
        soliRec.Kit_Price__c = (feeList[0].Price__c != null) ? feeList[0].Price__c : 0;
        soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
        insert soliRec;
    }
    
    /**
    * Name: saveHoursLogged
    * Desc: Method to save hours logged
    * @param:   (1)hoursLoggedJSONString - String - hours Logged 
    *           (2)coHeaderId - String - id of coHeader
    * @return: String -Hours Logged List
    **/
    @remoteAction
    global static String saveHoursLogged(String hoursLoggedJSONString, String coHeaderId) {
    	hoursLoggedJSONString = BPUtility.getDecodedString(hoursLoggedJSONString);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);    	
        try{
        	if(AccessControl.ifObjectFieldIsCreateable('Hours_Logged__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('Hours_Logged__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            SOHeaderWrapper.HoursLogged hoursLoggedObj = (SOHeaderWrapper.HoursLogged) System.JSON.deserialize(hoursLoggedJSONString, SOHeaderWrapper.HoursLogged.class);
            Hours_Logged__c hours = new Hours_Logged__c();
            if(hoursLoggedObj.Id != null) {
                hours.Id = hoursLoggedObj.Id;
            }
             
            hours.Employee__c = hoursLoggedObj.EmployeeId;
            hours.Notes__c = hoursLoggedObj.Notes;
            hours.Remaining_Estimate_d__c = hoursLoggedObj.RemainingEstimate_D;
            hours.Remaining_Estimate_h__c = hoursLoggedObj.RemainingEstimate_H;
            hours.Remaining_Estimate_m__c = hoursLoggedObj.RemainingEstimate_M;
            hours.Original_Estimate__c = hoursLoggedObj.OriginalEstimate;
            hours.Previously_Logged__c = hoursLoggedObj.PreviouslyLogged;
            
            hours.Service_Order_Header__c = hoursLoggedObj.SOHeaderId;
            hours.Time_Spent_d__c = hoursLoggedObj.TimeSpent_D;
            hours.Time_Spent_h__c = hoursLoggedObj.TimeSpent_H;
            hours.Time_Spent_m__c = hoursLoggedObj.TimeSpent_M;
            
            if(hoursLoggedObj.WorkPerformedDate != null) {
                Integer day = Integer.valueOf(hoursLoggedObj.WorkPerformedDate.split('/')[1]);
                Integer month = Integer.valueOf(hoursLoggedObj.WorkPerformedDate.split('/')[0]);
                Integer year = Integer.valueOf(hoursLoggedObj.WorkPerformedDate.split('/')[2]);
                hours.Work_Performed_Date__c = Date.newInstance(year, month, day);
            } else {
                hours.Work_Performed_Date__c = null;
            }
            hours.Notes_Required__c = hoursLoggedObj.NotesRequired;
            
            upsert hours;
            
            
            // Return Hours Logged List in JSON Format for current SO Header Record.
            String soHeaderId = hoursLoggedObj.SOHeaderId;
            List<Service_Order_Header__c> soHeaderRecList = SOQLUtil.getSODetailsByFieldName(new Map<String, String>{'Id' => soHeaderId});
            if(soHeaderRecList.size() == 0) {
                return BPUtility.getEncodedString('[]');


            }
            
            Service_Order_Header__c soHeaderRec = soHeaderRecList[0];
            if(Constants.SOStatusToPriorityMap.get(soHeaderRec.Status__c) < 3) {
                soHeaderRec.Status__c = 'In Progress';
                update soHeaderRec;
            }
            
            
            List<SOHeaderWrapper.HoursLogged> hoursLoggedList = new List<SOHeaderWrapper.HoursLogged>();
            for(Hours_Logged__c hourLoggedRec : soHeaderRec.Hours_Logged__r) {
                hoursLoggedList.add(new SOHeaderWrapper.HoursLogged(hourLoggedRec));
            }
            
            return BPUtility.getEncodedString(System.JSON.serialize(hoursLoggedList));  
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    
    // Merchandise section
   /**
    * Name: insertFeeInMerchGrid
    * Desc: Method to insert Fee in Merch Grid
    * @param:   (1)lineItemId - String - id of line item
                (2)coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @remoteAction
    global static String insertFeeInMerchGrid(String lineItemId, String coHeaderId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	

            List<Fee__c> feeList = SOQLUtil.getFeeByFieldName(new Map<String, String>{'Id' => lineItemId});
            if(feeList.size() == 0) {
                return getCOHeaderDetailsByGridName(coHeaderId, 'coHeader,coLineItem,user,coInvoiceHeader,checkOut,specialOrder');
            }
            
            if(String.isBlank(coHeaderId)) {
                coHeaderId = BPUtility.getDecodedString(BPGlobalHeaderCtrl.createCustomerOrder());  
            }
            
            CO_Line_Item__c coliRec = new CO_Line_Item__c();
            coliRec.CO_Header__c = coHeaderId;
            coliRec.Fee__c = feeList[0].Id;
            coliRec.Qty__c = 1;
            coliRec.Qty_Committed__c = coliRec.Qty__c;
            coliRec.Price__c = (feeList[0].Price__c != null) ? feeList[0].Price__c : 0;
            coliRec.Retail__c = coliRec.Price__c;
            insert coliRec;
            
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coHeader,coLineItem,user,coInvoiceHeader,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    
    /**
    * Name: insertKitHeaderInMerchGrid
    * Desc: Method to insert kit header Merch Grid
    * @param:   (1) lineItemId - String - id of line item
                (2) coHeaderId - String - id of coHeader 
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @remoteAction
    global static String insertKitHeaderInMerchGrid(String lineItemId, String coHeaderId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	
        	if(String.isBlank(coHeaderId)) {
                coHeaderId = BPUtility.getDecodedString(BPGlobalHeaderCtrl.createCustomerOrder());  
            }

            List<Kit_Header__c> kitHeaderList = SOQLUtil.getKitHeaderRec(new Map<String, String>{ 'Id' => lineItemId });
            if(kitHeaderList.size() == 0 || kitHeaderList[0].Service_Kit__c) {
                return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,user,coInvoiceHeader,checkOut,specialOrder'));
            }
            
            CO_Kit_Header__c cokhRec = new CO_Kit_Header__c();
            cokhRec.CO_Header__c = coHeaderId;
            cokhRec.Kit_Header__c = kitHeaderList[0].Id;
            cokhRec.Price__c = kitHeaderList[0].Fixed_Price__c;
            cokhRec.Actual_Kit_Price__c = kitHeaderList[0].Fixed_Price__c;
            cokhRec.Can_Split__c = kitHeaderList[0].Can_Split__c;
            cokhRec.Fixed_Price_Flag__c = kitHeaderList[0].Fixed_Price_Flag__c;
            cokhRec.Service_Kit__c = kitHeaderList[0].Service_Kit__c;
            
            insert cokhRec;
            insertAllKitLineItemsInMerchGrid(lineItemId, coHeaderId, cokhRec.Id);
            
            COKH_Recalcualtion.CoKitInsert(cokhRec.Id, coHeaderId) ;
            
            coHeaderId = BPUtility.escapeSingleQuotes(coHeaderId);
            List<CO_Kit_Header__c> coKitHeaderList = [SELECT Price__c, (Select Id, Price__c From CO_Line_Items__r) From CO_Kit_Header__c Where 
                                                                 CO_Header__c = : coHeaderId and Id =: cokhRec.Id];
            List<CO_Line_Item__c> coliList =  [SELECT Id, Price__c  From CO_Line_Item__c Where  CO_Header__c = : coHeaderId and CO_Kit_Header__c = null];
            //coKitHeaderList.CO_Line_Items__r[0].addall(coliList);
            List<CO_Line_Item__c> coliListToUpdate = new List<CO_Line_Item__c>();   
            if(coKitHeaderList.size() > 0) {
                for(CO_Line_Item__c coliRec : coKitHeaderList[0].CO_Line_Items__r ){
                    CO_Line_Item__c coliRecord = new CO_Line_Item__c(Id = coliRec.Id, Kit_Price_With_Price_Level__c = coliRec.Price__c );
                    coliListToUpdate.add(coliRecord);
                }
            }
            if(coliList.size() > 0){
                for(CO_Line_Item__c coliRec : coliList ){
                    CO_Line_Item__c coliRecord = new CO_Line_Item__c(Id = coliRec.Id, Kit_Price_With_Price_Level__c = coliRec.Price__c );
                    coliListToUpdate.add(coliRecord);
                }
            }
            
            if(coliListToUpdate.size() > 0){
                update coliListToUpdate;
            }
            
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,user,coInvoiceHeader,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: insertAllKitLineItemsInMerchGrid
    * Desc: Method to insert all line item in merch Grid
    * @param:   (1) lineItemId - String - id of line item
                (2) coHeaderId - String - id of coHeader 
                (3) cokhRecId - String - id of co kit header 
    * @return: void 
    **/
    private static void insertAllKitLineItemsInMerchGrid(String lineItemId, String coHeaderId, String cokhRecId) {
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        List<Kit_Header_Line_Item__c> khLineItemList = SOQLUtil.getKHLineItemRec(new Map<String, String>{ 'Kit_Header__c' => lineItemId });
        if(khLineItemList.size() == 0) {
            return;
        }
        //system.assert(false,khLineItemList);
        List<CO_Line_Item__c> coliListToInsert = new List<CO_Line_Item__c>();
        for(Kit_Header_Line_Item__c khliRec : khLineItemList) {
            CO_Line_Item__c coliRec = new CO_Line_Item__c();
            
            coliRec.CO_Header__c = coHeaderId;
            coliRec.CO_Kit_Header__c = cokhRecId;
            coliRec.Price__c = khliRec.Kit_Price__c;
            if(khliRec.Part__c != null) {
                coliRec.Part__c = khliRec.Part__c;
            } /*else if(khliRec.Fee__c != null) {
                //coliRec.Fee__c = khliRec.Fee__c;
            }*/
            coliRec.Fixed_Price__c = khliRec.Fixed_Price__c;
            coliRec.Actual_Kit_Price__c = khliRec.Kit_Price__c;
            coliRec.Qty__c = khliRec.Qty_Needed__c;
            coliListToInsert.add(coliRec);
        }
        
        if(coliListToInsert.size() > 0) {
            insert coliListToInsert;
        }
    }
    
    
    /**
    * Name: updateCOKHLineItems
    * Desc: Method to update line items.
    * @param:   (1)coKHItemJSON - String - kit header string 
                (2)coHeaderId - String - id of coHeader
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String updateCOKHLineItems(String coKHItemJSON, String coHeaderId) {
    	coKHItemJSON = BPUtility.getDecodedString(coKHItemJSON);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            COHeaderWrapper.COKitHeader coGridObj = (COHeaderWrapper.COKitHeader) System.JSON.deserialize(coKHItemJSON, COHeaderWrapper.COKitHeader.class);
    
            if(coGridObj.Id == null) {
                return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user,checkOut,specialOrder'));
            }
            
            //error = SO_KLI_Recalculation.updateSOKitHeader(sokhObj);
            
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user,checkOut,specialOrder'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    
     /**
    * Name: updateCOKHLineItemsRecalculation
    * Desc: Method to add Line Items in Items Grid.
    * @param:   (1) coKHItemJSON - String - kit header items string
                (2) coHeaderId - id of coHeader
                (3) CokHLineItemJson -  kit header line items 
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String updateCOKHLineItemsRecalculation(String coKHItemJSON, String coHeaderId,String CokHLineItemJson) {
    	coKHItemJSON = BPUtility.getDecodedString(coKHItemJSON);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	CokHLineItemJson = BPUtility.getDecodedString(CokHLineItemJson);
        try{
            COHeaderWrapper.COKitHeader coGridObj = (COHeaderWrapper.COKitHeader) System.JSON.deserialize(coKHItemJSON, COHeaderWrapper.COKitHeader.class);
            
            if (CokHLineItemJson != 'null'){    
                 COLineItem  coLi = (COLineItem) System.JSON.deserialize(CokHLineItemJson,COLineItem.class);
                    if(!coLi.IsFixedPrice && coLi.partId !=null ){
                        String Result = COKH_Recalcualtion.UpdateKitLineItem(coGridObj,coLi,coHeaderId);
                        if(Result != 'Success'){
                                error =new SO_KLI_Recalculation.Errorhandler('300',Result);
                        }else{
                            error =new SO_KLI_Recalculation.Errorhandler('200','Saved Successfully');
                        
                            }
                            
                        }   
                }else{    
                            if(!coGridObj.IsFixedPrice){
                                 String Result = COKH_Recalcualtion.UpdateKitHeader(coGridObj);
                                
                                    if(Result != 'Success'){
                                        error =new SO_KLI_Recalculation.Errorhandler('300',Result);
                                    }else{
                                        error =new SO_KLI_Recalculation.Errorhandler('200','Saved Successfully');
                                    
                                    }
                        }  
            }
                
            if(coGridObj.Id == null) {
                return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user'));
            }
            
            //error = SO_KLI_Recalculation.updateSOKitHeader(sokhObj);
            
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    
    /**
    * Name: removeLineItemsInMerchGrid
    * Desc: Method to remove line items in Merch Grid
    * @param:   (1) lineItemId - String - id of line item
                (2) coHeaderId - String - id of coHeader 
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String removeLineItemsInMerchGrid(String lineItemId, String coHeaderId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
            String objectName = (Id.valueOf(lineItemId)).getSObjectType().getDescribe().getName();
            if(objectName == CONSTANTS.NAMESPACE + 'CO_Line_Item__c') {
                return deleteCOLineItem(BPUtility.getEncodedString(lineItemId), BPUtility.getEncodedString(coHeaderId));
            } else if(objectName == CONSTANTS.NAMESPACE + 'CO_Kit_Header__c') {
                removeCOKHItems(lineItemId);
            } 
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
   /**
    * Name: removeCOKHItems
    * Desc: Method to remove kit header items
    * @param:   (1) lineItemId - String - id of line item
    * @return: void
    **/
    private static void removeCOKHItems(String lineItemId) {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectIsDeletable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	if(AccessControl.ifObjectIsDeletable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	
		lineItemId = BPUtility.escapeSingleQuotes(lineItemId);
        List<CO_Kit_Header__c> cokhList = [select Id, (Select Id from CO_Line_Items__r) from CO_Kit_Header__c where Id =: lineItemId];

        List<CO_Line_Item__c> coliListToDelete = new List<CO_Line_Item__c>();
        for(CO_Kit_Header__c cokhRec : cokhList) {
            if(cokhRec.CO_Line_Items__r != null && cokhRec.CO_Line_Items__r.size() > 0) {
                coliListToDelete.addAll(cokhRec.CO_Line_Items__r);
            }
        }
        
        if(coliListToDelete.size() > 0) {
            delete coliListToDelete;
        }
        if(cokhList.size() > 0) {
            delete cokhList;
        }
    } 
    
    /**
    * Name: splitCOKHItem
    * Desc: Method to split kit header itmes
    * @param:   (1) lineItemId - String - id of line item
                (2) coHeaderId - String - id of coHeader 
    * @return: String - Wrapper JSON String of all Lookup fields of Customer
    **/
    @RemoteAction
    global static String splitCOKHItem(String lineItemId, String coHeaderId) {
    	lineItemId = BPUtility.getDecodedString(lineItemId);
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectIsDeletable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	if(AccessControl.ifObjectIsDeletable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	
			lineItemId = BPUtility.escapeSingleQuotes(lineItemId);
            List<CO_Kit_Header__c> cokhList = [select Id,
                                                (select CO_Header__c, Qty__c, Part__c, Fee__c from CO_Line_items__r)     
                                                from CO_Kit_Header__c where Id =: lineItemId];
            
            List<CO_Line_Item__c> coLineItemListToInsert = new List<CO_Line_Item__c>();
            List<CO_Line_Item__c> coLineItemListToDelete = new List<CO_Line_Item__c>();
            
            for(CO_Kit_Header__c cokhRec : cokhList) {
                for(CO_Line_Item__c coliRec : cokhRec.CO_Line_items__r) {
                    CO_Line_Item__c newCOLIRec = new CO_Line_Item__c();
                    newCOLIRec.CO_Header__c = coliRec.CO_Header__c;
                    newCOLIRec.Qty__c = coliRec.Qty__c;
                    newCOLIRec.Part__c = coliRec.Part__c;
                    newCOLIRec.Fee__c = coliRec.Fee__c;
                    //CO_Line_Item__c newCOLIRec = coliRec.clone(false, true, false, false);
                    coLineItemListToInsert.add(newCOLIRec);
                    coLineItemListToDelete.add(coliRec);
                }
            }
            
            if(coLineItemListToDelete.size() > 0) {
                delete coLineItemListToDelete;
            }
            
            if(cokhList.size() > 0) {
                delete cokhList;
            }
            
            if(coLineItemListToInsert.size() > 0) {
                insert coLineItemListToInsert;
            }
            
            return getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('coLineItem,coInvoiceHeader,user'));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');


    }
    
    /**
    * Name: getGridTotal
    * Desc: Method to get grid total    
    * @param:   (1) coHeaderId - String - id of coHeader
                (2) gridId - String - id of grid
                (3) gridName - String - name of grid
                (4) isAustralianMarket - Boolean - is australian markert or not 
    * @return: String - grid total
    **/
    @RemoteAction
    global static String getGridTotal(String coHeaderId, String gridId, String gridName, Boolean isAustralianMarket) {
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	gridId = BPUtility.getDecodedString(gridId);
    	gridName = BPUtility.getDecodedString(gridName);
        try{
            Decimal total = 0;
            Decimal salesTax = 0;
            Decimal priceOverrides = 0;
            
            Decimal total_Part = 0;
            Decimal total_Laobur = 0;
            Decimal total_Sublet = 0;
            Decimal total_Fee = 0;
 
            
            Map<String, Decimal> salesTaxNameToTaxValue = new Map<String, Decimal>();
            Map<String, Decimal> salesTaxNameToTaxRateValue = new Map<String, Decimal>();            
            //Decimal australianMarketTaxRate = (Australian_Market__c.getInstance().get(Constants.NAMESPACE + 'Sales_Tax_Rate__c') != null) ? 
                                                //Decimal.valueOf(String.valueOf(Australian_Market__c.getInstance().get(Constants.NAMESPACE + 'Sales_Tax_Rate__c'))) : 0;
            Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            Boolean isCalcTax_Invoice = GeneralConfiguration.getCalcTax_Invoice();
            Boolean isCalcTax_LineItem = GeneralConfiguration.getCalcTax_LineItem();
            
            if(gridId == null && gridName == 'merchandise') {
                List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeaderId); 
                for(CO_Line_Item__c coLineItemRec : coLineItems) {
                    coLineItemRec.Qty__c = (coLineItemRec.Qty__c == null) ? 0 : coLineItemRec.Qty__c;
                    coLineItemRec.Price__c = (coLineItemRec.Price__c == null) ? 0 : coLineItemRec.Price__c;
                    coLineItemRec.Retail__c = (coLineItemRec.Retail__c == null) ? 0 : coLineItemRec.Retail__c;
                    coLineItemRec.Tax__c = (coLineItemRec.Tax__c == null) ? 0 : coLineItemRec.Tax__c;
                    

                    for(Individual_Tax__c individualTaxRec : coLineItemRec.Individual_Taxes__r) {
                        Decimal taxValue;
                        if(salesTaxNameToTaxValue.containsKey(individualTaxRec.Sales_Tax_Item_Name__c)) {
                            taxValue = salesTaxNameToTaxValue.get(individualTaxRec.Sales_Tax_Item_Name__c);
                        } else {
                            taxValue = 0;
                        }
                        if(!isTaxIncludingPricing && isCalcTax_Invoice) {
                        	taxValue += (coLineItemRec.Qty__c * coLineItemRec.Price__c);

                        	if(!salesTaxNameToTaxRateValue.containsKey(individualTaxRec.Sales_Tax_Item_Name__c)) {
                        		salesTaxNameToTaxRateValue.put(individualTaxRec.Sales_Tax_Item_Name__c, individualTaxRec.Tax_Rate__c);
                        	}
                        } else {
	                        taxValue += ((individualTaxRec.Tax_Rate__c * coLineItemRec.Qty__c * coLineItemRec.Price__c) / 100).setScale(2);
                        }
                        salesTaxNameToTaxValue.put(individualTaxRec.Sales_Tax_Item_Name__c, taxValue);
                    }
                    
                    if(!isTaxIncludingPricing && isCalcTax_Invoice) {
                    	for(String stName : salesTaxNameToTaxRateValue.keyset()) {
                    		Decimal rate = salesTaxNameToTaxRateValue.get(stName);
                    		if(salesTaxNameToTaxValue.containsKey(stName)) {
                    			Decimal taxValue = ((salesTaxNameToTaxValue.get(stName) * rate) / 100).setScale(2);
                    			salesTaxNameToTaxValue.put(stName, taxValue);
                    		}
                    	}
                    }
                    
                    if(coLineItemRec.Kit_Price_With_Price_Level__c == null  ){
                        coLineItemRec.Kit_Price_With_Price_Level__c = coLineItemRec.Price__c;
                    }
                    if(coLineItemRec.CO_Kit_Header__c != null ){
                        priceOverrides += coLineItemRec.Qty__c * (coLineItemRec.Price__c - coLineItemRec.Kit_Price_With_Price_Level__c);

                    }else If(coLineItemRec.CO_Kit_Header__c == null ){
                        priceOverrides += coLineItemRec.Qty__c * (coLineItemRec.Price__c - coLineItemRec.Actual_Kit_Price__c);
                    }
                    
                    if(!isTaxIncludingPricing) {
                        if(coLineItemRec.Part__c != null) {
                            total_Part += coLineItemRec.Qty__c * coLineItemRec.Price__c;
                        }
                        if(coLineItemRec.Fee__c != null) {
                            total_Fee += coLineItemRec.Qty__c * coLineItemRec.Price__c;
                        }
                        total += coLineItemRec.Qty__c * coLineItemRec.Price__c;
                        salesTax += (coLineItemRec.Qty__c * coLineItemRec.Price__c * coLineItemRec.Tax__c) / 100;


                    } else {
                        if(coLineItemRec.Part__c != null) {
                            total_Part += coLineItemRec.Sub_Total_With_Tax__c;
                        }
                        if(coLineItemRec.Fee__c != null) {



                            total_Fee += coLineItemRec.Sub_Total_With_Tax__c;
                        }






                        total += coLineItemRec.Sub_Total_With_Tax__c;
                    }
                }
                
            } else if(gridId != null) {



                List<Service_Order_Line_Item__c> soLineItemList = SOQLUtil.getServiceOrderLineItemBySOHeader(gridId);
                if(soLineItemList.size() > 0) {
                    for(Service_Order_Line_Item__c soliRec : soLineItemList) {

                        if(soliRec.Tax_Percent__c == null) {
                            soliRec.Tax_Percent__c = 0;
                        }
                        if(soliRec.Labour_Code__c != null ) {
                            total_Laobur += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
                            salesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;

                            if(isTaxIncludingPricing) {
                                total_Laobur += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                            }
                        } else if(soliRec.Part__c != null) {
                            salesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                            total_Part += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
                            if(isTaxIncludingPricing) {
                                total_Part += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                            }
                        } else if(soliRec.Fee__c != null) {
                            total_Fee += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
                            salesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                            if(isTaxIncludingPricing) {
                                total_Fee += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                            }
                        }
                        
                        for(Individual_Tax__c individualTaxRec : soliRec.Individual_Taxes__r) {
                            Decimal taxValue;
                            if(salesTaxNameToTaxValue.containsKey(individualTaxRec.Sales_Tax_Item_Name__c)) {
                                taxValue = salesTaxNameToTaxValue.get(individualTaxRec.Sales_Tax_Item_Name__c);
                            } else {
                                taxValue = 0;
                            }
                            taxValue += (individualTaxRec.Tax_Rate__c * soliRec.Qty_Needed__c * soliRec.Kit_Price__c) / 100;
                            salesTaxNameToTaxValue.put(individualTaxRec.Sales_Tax_Item_Name__c, taxValue);
                        }
                    
                        if(soliRec.Service_Order_Kit_Header__c == null){
                            //system.assert(false,soliRec.Service_Order_Kit_Header__c);
                            priceOverrides += soliRec.Qty_Needed__c * (soliRec.Kit_Price__c - soliRec.Actual_Kit_Price__c );
                        }else if(soliRec.Service_Order_Kit_Header__c != null){
                            //system.assert(false,soliRec.Service_Order_Kit_Header__c);
                            if(soliRec.Kit_Price_With_Price_Level__c == null  ){
                                soliRec.Kit_Price_With_Price_Level__c = soliRec.Kit_Price__c;
                            }
                            priceOverrides += soliRec.Qty_Needed__c * (soliRec.Kit_Price__c - soliRec.Kit_Price_With_Price_Level__c );
                        }
                    }
                    /*for(Service_Order_Kit_Header__c sokhRec : soHeaderRecList[0].Service_Order_Kit_Headers__r) {
                        priceOverrides += (sokhRec.Fixed_Price__c - sokhRec.Actual_Kit_Price__c);
                    }*/
                }   
                if(isTaxIncludingPricing) {
                    salesTax = 0;
                }
                total = total_Part + total_Laobur + total_Sublet + total_Fee;
                //salesTaxNameToTaxValue = new Map<String, Decimal>{'' => 0}; 
            }
            
            
            COHeaderWrapper.GridTotal gridTotal = new COHeaderWrapper.GridTotal(total, salesTax, priceOverrides, total_Part, total_Laobur, total_Sublet, total_Fee, salesTaxNameToTaxValue);
            return BPUtility.getEncodedString(System.JSON.serialize(gridTotal)); 
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString(''); 


    }
    
    
	public static void UpdateServiceOrderTotals(Id ServiceOrderHeaderId, Id CoheaderId) {
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		ServiceOrderHeaderId = BPUtility.escapeSingleQuotes(ServiceOrderHeaderId);

		list <Service_Order_Header__c> serviceOrderKitHeaderListToMove = new list <Service_Order_Header__c> ([select Id, Total__c, Tax_Amount__c,
																												(select Id, Total__c, Tax_Amount__c from Service_Order_Line_Items__r)
																												from Service_Order_Header__c
																												where Id =  : ServiceOrderHeaderId]
																											);

		for (Service_Order_Header__c serviceOrderHeaderRec : serviceOrderKitHeaderListToMove) {
			decimal total = 0;
			decimal taxAmount = 0;
			for (Service_Order_Line_Item__c serviceItemRec : serviceOrderHeaderRec.Service_Order_Line_Items__r) {
				total += serviceItemRec.Total__c;
				taxAmount += serviceItemRec.Tax_Amount__c;
			}


			serviceOrderHeaderRec.Total__c = total;
			serviceOrderHeaderRec.Tax_Amount__c = taxAmount;
		}
	


		if (serviceOrderKitHeaderListToMove.size() > 0) {
			update serviceOrderKitHeaderListToMove;
		}
	
	}



    






    public static String MoveFromSokhCOKH(String kitIdToMove,String sectionToMove,String CoheaderId){
        Savepoint sp = Database.setSavepoint();
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		

		if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		

		if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsCreateable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		

		if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		if(AccessControl.ifObjectIsDeletable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		if(AccessControl.ifObjectIsDeletable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		
		kitIdToMove = BPUtility.escapeSingleQuotes(kitIdToMove);
        list<Service_Order_Kit_Header__c> serviceOrderKitHeaderListToMove = new list<Service_Order_Kit_Header__c>([select Id,Actual_Kit_Price__c,Can_Split__c,Code__c,Description__c,Fixed_Price__c,
                                                                                                                Fixed_Price_Flag__c,Is_Fixed_Kit_Header_SO__c,Kit_Header__c,Service_Kit__c,
                                                                                                                Service_Order_Header__c, (Select Id,Service_Order_Header__c,CO_Line_Item__c,Actual_Kit_Price__c  From Service_Order_Line_Items__r)
                                                                                                                 from Service_Order_Kit_Header__c where  Id =:kitIdToMove]);
                                                                                                                
        if(sectionToMove!=null){
                    Id serviceOrderHeaderOldId = serviceOrderKitHeaderListToMove[0].Service_Order_Header__c;
                    if(serviceOrderKitHeaderListToMove.size() > 0 ){ 

                            list<Service_Order_Line_Item__c> serviceOrderLineItemListToMove =new  list<Service_Order_Line_Item__c>();
                            Service_Order_Kit_Header__c serviceOrderKitHeaderRecToMove = serviceOrderKitHeaderListToMove[0];
                            serviceOrderKitHeaderRecToMove.Service_Order_Header__c = sectionToMove;
                            serviceOrderKitHeaderRecToMove.Fixed_Price__c = serviceOrderKitHeaderRecToMove.Actual_Kit_Price__c;
                            for(Service_Order_Line_Item__c soliItemToMoveRec : serviceOrderKitHeaderRecToMove.Service_Order_Line_Items__r ) {
                                soliItemToMoveRec.Service_Order_Header__c = sectionToMove;
                                soliItemToMoveRec.Kit_Price__c= soliItemToMoveRec.Actual_Kit_Price__c;
                                serviceOrderLineItemListToMove.add(soliItemToMoveRec );
                            } 
                            
                            
                            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
                            update serviceOrderKitHeaderRecToMove;
                            if(serviceOrderLineItemListToMove.Size() > 0){
                                update serviceOrderLineItemListToMove;                              
                            }
                            sectionToMove = BPUtility.escapeSingleQuotes(sectionToMove);
                            list<Service_Order_Header__c> serviceOrderList =[select Id,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),CO_Header__c
                                                                         from  Service_Order_Header__c where Id =:sectionToMove ];
                            Service_Order_Header__c ServiceOrderHeaderRec=  serviceOrderList[0];                                                  
                            if(ServiceOrderHeaderRec.CO_Invoice_Items__r.size()==0){
                            		CoheaderId = BPUtility.escapeSingleQuotes(CoheaderId);
                                    list<CO_Invoice_Header__c>  coInvoiceHeaderRec =new list<CO_Invoice_Header__c>([select Id from  CO_Invoice_Header__c where 
                                                                                                            CO_Header__c =:CoheaderId and status__c =:'Active' ]);
                                    CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
                                    if(coInvoiceHeaderRec.size() > 0 ){  
                                        coInvoiceItem.CO_Invoice_Header__c = coInvoiceHeaderRec[0].Id;
                                        coInvoiceItem.isActive__c = true;
                                        coInvoiceItem.Is_Invoiceable__c = true;
                                        for(Service_Order_Line_Item__c serviceOrderLineItemRec :  ServiceOrderHeaderRec.Service_Order_Line_Items__r){
                                            if(serviceOrderLineItemRec.Qty_To_Order__c > 0){
                                                coInvoiceItem.Is_Invoiceable__c =false;
                                                break;
                                            }
                                        }
                                        coInvoiceItem.Service_Order_Header__c = ServiceOrderHeaderRec.Id;
                                        insert coInvoiceItem;
                                    }
                                
                            }
                            
                                //Remove CheckOut 
                                
                                
                                serviceOrderHeaderOldId = BPUtility.escapeSingleQuotes(serviceOrderHeaderOldId);
                                list <CO_Invoice_Item__c> invoiceItemToDelete= new  list <CO_Invoice_Item__c>();
                                list<Service_Order_Header__c> ServiceOrderHeaderOldRecList =  new list<Service_Order_Header__c>([Select Id,CO_Header__c,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),
                                                                                             (Select Id,Qty_To_Order__c,Actual_Kit_Price__c From Service_Order_Line_Items__r)  
                                                                                             from Service_Order_Header__c
                                                                                             where  Id =: serviceOrderHeaderOldId]);
                            
                                Service_Order_Header__c ServiceOrderHeaderOldRec = ServiceOrderHeaderOldRecList[0];
                                if(ServiceOrderHeaderOldRec.Service_Order_Line_Items__r.size() == 0 ){
                                    for(CO_Invoice_Item__c coInvoiceItem : ServiceOrderHeaderOldRec.CO_Invoice_Items__r ){
                                        invoiceItemToDelete.add( coInvoiceItem);
                                    }
                                    if(invoiceItemToDelete.size() > 0 ){
                                        
                                        delete invoiceItemToDelete;
                                        ///system.assert(false,invoiceItemToDelete +'\n\n\n\n\n'+ ServiceOrderHeaderOldRecList);
                                        
                                    }
                                }
                            UpdateServiceOrderTotals( ServiceOrderHeaderRec.Id ,null );
                    }
                    
                    UpdateServiceOrderTotals( Id.valueOf(serviceOrderHeaderOldId) , null);
                    
        }
        else{
                    if(serviceOrderKitHeaderListToMove.size() > 0 ){
                            list<Service_Order_Line_Item__c> serviceOrderLineItemListToMove =new  list<Service_Order_Line_Item__c>();
                            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
                            
                            list<CO_Kit_Header__c> coKitHeaderToInsert = new list<CO_Kit_Header__c>();
                            Service_Order_Kit_Header__c serviceOrderKitHeaderRecToMove = serviceOrderKitHeaderListToMove[0];
                            for(Service_Order_Kit_Header__c serviceOrderKitHeaderRec  : serviceOrderKitHeaderListToMove){
                                CO_Kit_Header__c coKitHeaderRec = new CO_Kit_Header__c();
                                coKitHeaderRec.Actual_Kit_Price__c =  serviceOrderKitHeaderRec.Actual_Kit_Price__c;
                                coKitHeaderRec.Can_Split__c= serviceOrderKitHeaderRec.Can_Split__c ;
                                coKitHeaderRec.Price__c =(serviceOrderKitHeaderRec.Actual_Kit_Price__c  != 0 || serviceOrderKitHeaderRec.Actual_Kit_Price__c !=null) ?  serviceOrderKitHeaderRec.Actual_Kit_Price__c : serviceOrderKitHeaderRec.Fixed_Price__c ; 
                                coKitHeaderRec.Fixed_Price_Flag__c = serviceOrderKitHeaderRec.Fixed_Price_Flag__c ;
                                coKitHeaderRec.CO_Fixed_KitHeader__c = false ;
                                coKitHeaderRec.Kit_Header__c = serviceOrderKitHeaderRec.Kit_Header__c;
                                coKitHeaderRec.Service_Kit__c =serviceOrderKitHeaderRec.Service_Kit__c ; 
                                coKitHeaderRec.CO_Header__c = CoheaderId;
                                coKitHeaderToInsert.add(coKitHeaderRec);
                            } 
                            
                            
                            map<Id,Service_Order_Line_Item__c> coliIdToSoliMap =  new map<Id,Service_Order_Line_Item__c>();
                            for(Service_Order_Line_Item__c soliItemToMoveRec : serviceOrderKitHeaderRecToMove.Service_Order_Line_Items__r ) {
                                serviceOrderLineItemListToMove.add(soliItemToMoveRec );
                                coliIdToSoliMap.put(soliItemToMoveRec.CO_Line_Item__c ,soliItemToMoveRec);
                            }
                            
                            list<CO_Line_Item__c> coliItemListForNewCOKitHeader  = new list<CO_Line_Item__c>([select Id,CO_Kit_Header__c,Qty_To_Order__c from CO_Line_Item__c where Id IN : coliIdToSoliMap.keySet()]);
                            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
                            if(coKitHeaderToInsert.size() > 0 && coliItemListForNewCOKitHeader.size() > 0){
                                insert coKitHeaderToInsert;
                                CO_Kit_Header__c CokitHeaderRecInserted = coKitHeaderToInsert[0];
                                for(CO_Line_Item__c  coliRec: coliItemListForNewCOKitHeader ){
                                    coliRec.CO_Kit_Header__c = CokitHeaderRecInserted.Id;
                                    if(coliIdToSoliMap.ContainsKey(coliRec.Id)){
                                        Service_Order_Line_Item__c  ServiceOrderRec = coliIdToSoliMap.get(coliRec.Id);
                                        coliRec.Price__c = ServiceOrderRec.Actual_Kit_Price__c;
                                    }
                                    
                                }
                                
                                update coliItemListForNewCOKitHeader;
                                
                            }
                            
                            Id serviceOrderHeaderId = serviceOrderKitHeaderListToMove[0].Service_Order_Header__c;
                                                        
                            if(serviceOrderLineItemListToMove.Size() > 0){
                                delete serviceOrderLineItemListToMove;  
                                list <CO_Invoice_Item__c> invoiceItemToDelete= new  list <CO_Invoice_Item__c>();
                                serviceOrderHeaderId = BPUtility.escapeSingleQuotes(serviceOrderHeaderId);
                                list<Service_Order_Header__c> ServiceOrderHeaderRecList =  new list<Service_Order_Header__c>([Select Id,CO_Header__c,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),
                                                                                             (Select Id,Qty_To_Order__c From Service_Order_Line_Items__r)  
                                                                                             from Service_Order_Header__c
                                                                                             where  Id =: serviceOrderHeaderId]);
                            
                                Service_Order_Header__c ServiceOrderHeaderRec =ServiceOrderHeaderRecList[0];
                                if(ServiceOrderHeaderRec.Service_Order_Line_Items__r.size() == 0 ){
                                    for(CO_Invoice_Item__c coInvoiceItem : ServiceOrderHeaderRec.CO_Invoice_Items__r ){
                                        invoiceItemToDelete.add( coInvoiceItem);
                                    }
                                    if(invoiceItemToDelete.size() > 0 ){
                                        delete invoiceItemToDelete;
                                    }
                                }
                                                            
                            }
                             
                            delete serviceOrderKitHeaderListToMove;
                            UpdateServiceOrderTotals( Id.valueOf(serviceOrderHeaderId) , null);
                    }   
        }   
        return null;                                                                                                        
                     
     }
    
    // function to move kit item
    public static String MoveFromCokhSokh(String kitIdToMove,String sectionToMove){
            Savepoint sp = Database.setSavepoint();
            if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			if(AccessControl.ifObjectFieldIsAccessible('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

			if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
			if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
			

			if(AccessControl.ifObjectIsDeletable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            
            kitIdToMove = BPUtility.escapeSingleQuotes(kitIdToMove);
            list<CO_Kit_Header__c> coKitHeaderToMovelist =new  list<CO_Kit_Header__c>([select Id,Actual_Kit_Price__c,Can_Split__c,CO_Fixed_KitHeader__c,Kit_Header__r.Code__c,
                                                                                      Kit_Header__r.Description__c,CO_Header__c,Fixed_Price_Flag__c,Kit_Header__c,Price__c,Service_Kit__c,
                                                                                      (select Id,Actual_Kit_Price__c,Fixed_Price__c,CO_Fixed_KitLineItem__c,Price__c,
                                                                                        Qty_Committed__c,Qty__c,Qty_To_Order__c,Part__c, Tax__c from CO_Line_Items__r ) ,
                                                                                      (Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r)                       
                                                                                      from CO_Kit_Header__c where Id =: kitIdToMove]);
            
            list<Service_Order_Kit_Header__c> serviceOrderKitHeaderToInsertList = new list<Service_Order_Kit_Header__c>();
            
            for(CO_Kit_Header__c coKitHeaderToMoveRec : coKitHeaderToMovelist){
                Service_Order_Kit_Header__c serviceOrderKitHeaderRec = new Service_Order_Kit_Header__c();
                serviceOrderKitHeaderRec.Actual_Kit_Price__c =  coKitHeaderToMoveRec.Actual_Kit_Price__c;
                serviceOrderKitHeaderRec.Can_Split__c =  coKitHeaderToMoveRec.Can_Split__c;
                serviceOrderKitHeaderRec.Code__c = coKitHeaderToMoveRec.Kit_Header__r.Code__c;
                serviceOrderKitHeaderRec.Description__c = coKitHeaderToMoveRec.Kit_Header__r.Description__c;
                serviceOrderKitHeaderRec.Fixed_Price__c = (coKitHeaderToMoveRec.Actual_Kit_Price__c !=null && coKitHeaderToMoveRec.Actual_Kit_Price__c !=0) ? coKitHeaderToMoveRec.Actual_Kit_Price__c : coKitHeaderToMoveRec.Price__c;
                serviceOrderKitHeaderRec.Fixed_Price_Flag__c = coKitHeaderToMoveRec.Fixed_Price_Flag__c;
                serviceOrderKitHeaderRec.Is_Fixed_Kit_Header_SO__c = false;
                serviceOrderKitHeaderRec.Kit_Header__c = coKitHeaderToMoveRec.Kit_Header__c;
                serviceOrderKitHeaderRec.Service_Kit__c = coKitHeaderToMoveRec.Service_Kit__c;
                serviceOrderKitHeaderRec.Service_Order_Header__c = sectionToMove;
                serviceOrderKitHeaderToInsertList.add(serviceOrderKitHeaderRec);
            } 
            
            if(serviceOrderKitHeaderToInsertList.size() > 0){
                insert serviceOrderKitHeaderToInsertList;
            }
            
            
            list<CO_Line_Item__c> coliListToMove  =new list<CO_Line_Item__c>();
            for(CO_Kit_Header__c  cokhRec: coKitHeaderToMovelist ){
                    for(CO_Line_Item__c  coliRec : cokhRec.CO_Line_Items__r){
                            coliListToMove.add(coliRec);
                    }
                    
            }
            
            
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
            map<Id,Id> coliToSoliMap = new map<Id,Id>();
            string soKitheader =  serviceOrderKitHeaderToInsertList[0].Id;
            String ServiceOrderId = sectionToMove;
            list<Service_Order_Line_Item__c> soliListToInsert ;
            if(coliListToMove.size() > 0){
                 soliListToInsert = CreateSoliForColi( coliToSoliMap,coliListToMove,soKitheader,ServiceOrderId);
            }
            
            if(coKitHeaderToMovelist.size()>0 ){
                delete coKitHeaderToMovelist;
            }
            ServiceOrderId = BPUtility.escapeSingleQuotes(ServiceOrderId);
            list<Service_Order_Header__c> serviceOrderList =[select Id,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),CO_Header__c
                                                                         from  Service_Order_Header__c where Id =:ServiceOrderId ];
            Service_Order_Header__c ServiceOrderHeaderRec=  serviceOrderList[0];                                                  
            if(ServiceOrderHeaderRec.CO_Invoice_Items__r.size()==0){
                    list<CO_Invoice_Header__c>  coInvoiceHeaderRec =new list<CO_Invoice_Header__c>([select Id from  CO_Invoice_Header__c where 
                                                                                            CO_Header__c =:ServiceOrderHeaderRec.CO_Header__c and status__c =:'Active' ]);
                    CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
                    if(coInvoiceHeaderRec.size() > 0 ){
                        coInvoiceItem.CO_Invoice_Header__c = coInvoiceHeaderRec[0].Id;
                        coInvoiceItem.isActive__c = true;
                        coInvoiceItem.Is_Invoiceable__c = true;
                        for(Service_Order_Line_Item__c serviceOrderLineItemRec :  ServiceOrderHeaderRec.Service_Order_Line_Items__r){
                            if(serviceOrderLineItemRec.Qty_To_Order__c > 0){
                                coInvoiceItem.Is_Invoiceable__c =false;
                                break;
                            }
                        }
                        coInvoiceItem.Service_Order_Header__c = ServiceOrderHeaderRec.Id;
                        insert coInvoiceItem;
                    }
                
            }
        UpdateServiceOrderTotals(Id.valueOf(ServiceOrderId) , null);
        //Database.rollback(sp);
        //list<Service_Order_Header__c> serviceOrderListetst =[select Id,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),CO_Header__c
                                                                        // from  Service_Order_Header__c where Id =:ServiceOrderId ];
        //system.assert(false, serviceOrderKitHeaderToInsertList + '\n\n\n\n\n\n\n' +  soliListToInsert +'\n\n\n\\n\n\n\n'  + serviceOrderListetst);    
        return null;
    }   
    
     //Fucntion to soli to coli
     public static String  MoveFromSoliToColi(String soliToMove,String sectionToMove) {
        Savepoint sp = Database.setSavepoint();
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }

		if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		

		if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		

		if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		if(AccessControl.ifObjectIsDeletable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        soliToMove = BPUtility.escapeSingleQuotes(soliToMove);
        List<Service_Order_Line_Item__c>  soliItemToMovelist = new List<Service_Order_Line_Item__c>([select Id,Actual_Kit_Price__c,Service_Order_Header__c,CO_Line_Item__c,Service_Order_Header__r.CO_Header__c
                                                                                                    from Service_Order_Line_Item__c where Id =:soliToMove]);
        
        if(sectionToMove!=null){
            Id sectionFromHeaderId =null;
            if(soliItemToMovelist.size() >  0){
                sectionFromHeaderId = soliItemToMovelist[0].Service_Order_Header__c;
            }
            
            for(Service_Order_Line_Item__c soliItemToMoveRec : soliItemToMovelist ) {
                soliItemToMoveRec.Service_Order_Header__c = sectionToMove;
                soliItemToMoveRec.Kit_Price__c = soliItemToMoveRec.Actual_Kit_Price__c;
            }   
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
            if(soliItemToMovelist.size()>0){
                
                update soliItemToMovelist;
            }
            sectionToMove = BPUtility.escapeSingleQuotes(sectionToMove);
            list<Service_Order_Header__c> serviceOrderList =[select Id,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),CO_Header__c
                                                             from  Service_Order_Header__c where Id =:sectionToMove ];
            Id customerOrderHeader =  soliItemToMovelist[0].Service_Order_Header__r.CO_Header__c;                                                
            Service_Order_Header__c ServiceOrderHeaderRec=  serviceOrderList[0];                                                  
            if(ServiceOrderHeaderRec.CO_Invoice_Items__r.size()==0){
                    list<CO_Invoice_Header__c>  coInvoiceHeaderRec =new list<CO_Invoice_Header__c>([select Id from  CO_Invoice_Header__c where 
                                                                                            CO_Header__c =:customerOrderHeader and status__c =:'Active' ]);
                    CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
                    if(coInvoiceHeaderRec.size() > 0 ){
                        coInvoiceItem.CO_Invoice_Header__c = coInvoiceHeaderRec[0].Id;
                        coInvoiceItem.isActive__c = true;
                        coInvoiceItem.Is_Invoiceable__c = true;
                        for(Service_Order_Line_Item__c serviceOrderLineItemRec :  ServiceOrderHeaderRec.Service_Order_Line_Items__r){
                            if(serviceOrderLineItemRec.Qty_To_Order__c > 0){
                                coInvoiceItem.Is_Invoiceable__c =false;
                                break;
                            }
                        }
                        coInvoiceItem.Service_Order_Header__c = ServiceOrderHeaderRec.Id;
                        insert coInvoiceItem;
                    }
                    
            }
                
                
             list<Service_Order_Header__c> serviceOrderToMovelist =     [select Id,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),CO_Header__c,
                                                            ( Select Id,Qty_To_Order__c From Service_Order_Line_Items__r)   
                                                         from  Service_Order_Header__c where Id =:sectionFromHeaderId ];
            Service_Order_Header__c serviceOrderToMove;
            if(serviceOrderToMovelist.size() > 0){
                serviceOrderToMove = serviceOrderToMovelist[0];
            }
            list<CO_Invoice_Item__c> CoinvoiceToRemove =new  list<CO_Invoice_Item__c>();                                         
            if(serviceOrderToMove.Service_Order_Line_Items__r.Size() == 0 && serviceOrderToMovelist.size() >0 ){
                for(CO_Invoice_Item__c  CoinvoiceRec : serviceOrderToMove.CO_Invoice_Items__r){
                    CoinvoiceToRemove.add(CoinvoiceRec);
                }
                if(CoinvoiceToRemove.size()>0){
                    delete CoinvoiceToRemove;
                }
                
            }
            
            UpdateServiceOrderTotals( Id.valueOf(sectionFromHeaderId) , null);
            UpdateServiceOrderTotals( Id.valueOf(sectionToMove) , null);
                    
                                                                                            
        }else{
             
             
            if(soliItemToMovelist.size() == 0 ){
                return null;
            }   
                                                                                                
            Id customerOrderHeader =  soliItemToMovelist[0].Service_Order_Header__r.CO_Header__c;                                                                                       
        
            
            Id serviceOrderHeaderId = null;
            Id coliForSoliToMove  = null;
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
            if(soliItemToMovelist.Size() > 0 ){
                
                serviceOrderHeaderId = soliItemToMovelist[0].Service_Order_Header__c;
                coliForSoliToMove  = soliItemToMovelist[0].CO_Line_Item__c;
                delete soliItemToMovelist;
            }
    
            list<Service_Order_Line_Item__c> reaminingSoliList  = new   list<Service_Order_Line_Item__c>();
            list<CO_Invoice_Item__c> SoInvoiceItem  = new   list<CO_Invoice_Item__c>();
            
            if(serviceOrderHeaderId != null ){
                        list<Service_Order_Header__c> ServiceOrderHeaderRecList =  new list<Service_Order_Header__c>([Select Id,CO_Header__c,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),
                                                                                             (Select Id,Qty_To_Order__c From Service_Order_Line_Items__r)  
                                                                                             from Service_Order_Header__c
                                                                                             where  Id =: serviceOrderHeaderId]);
                                                                                             
                        for(Service_Order_Header__c ServiceOrderHeaderRec : ServiceOrderHeaderRecList){
                                for(Service_Order_Line_Item__c soliRec : ServiceOrderHeaderRec.Service_Order_Line_Items__r){
                                            reaminingSoliList.add(soliRec); 
                                }
                                for(CO_Invoice_Item__c coInvoiceItemRec : ServiceOrderHeaderRec.CO_Invoice_Items__r ){
                                        SoInvoiceItem.add(coInvoiceItemRec);
                                }
                        }                                                                    
            }
            if(reaminingSoliList.size() == 0){
                    delete SoInvoiceItem;
            }
            
            
            
            if(coliForSoliToMove !=null  ){
                        list<CO_Line_Item__c> coliItemForInvoiceList = new  list<CO_Line_Item__c>([select Id,CO_Header__c,Qty_To_Order__c from CO_Line_Item__c where Id =:  coliForSoliToMove]);
    
                        list<CO_Invoice_Header__c>  coInvoiceHeaderRec =new list<CO_Invoice_Header__c>([select Id from  CO_Invoice_Header__c where 
                                                                                                CO_Header__c =: customerOrderHeader and status__c =:'Active' ]);
                        CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
                        if(coInvoiceHeaderRec.size() > 0 ){
                            coInvoiceItem.CO_Invoice_Header__c = coInvoiceHeaderRec[0].Id;
                            coInvoiceItem.isActive__c = true;
                            for(CO_Line_Item__c coliItemForInvoiceRec :  coliItemForInvoiceList){
                                if(coliItemForInvoiceRec.Qty_To_Order__c > 0){
                                    coInvoiceItem.Is_Invoiceable__c =false;
                                    coInvoiceItem.CO_Line_Item__c = coliItemForInvoiceRec.Id;
                                }
                                else{
                                    coInvoiceItem.Is_Invoiceable__c =true;
                                    coInvoiceItem.CO_Line_Item__c = coliItemForInvoiceRec.Id;
                                }
                            }
                            insert coInvoiceItem;
                        }
            }
            UpdateServiceOrderTotals( Id.valueOf(serviceOrderHeaderId) , null);
            
        }
        return null; 
     }
     
     //function to create SoliForColi
     public static list<Service_Order_Line_Item__c> CreateSoliForColi(map<Id,Id> coliToSoliMap,list<CO_Line_Item__c> coliListToMove,String soKitheader,String ServiceOrderId ){
            if(AccessControl.ifObjectFieldIsCreateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            
            list<Service_Order_Line_Item__c> soliListToInsert = new list<Service_Order_Line_Item__c>();
            for(CO_Line_Item__c coliRecToMove : coliListToMove ){
                Service_Order_Line_Item__c solirec = new Service_Order_Line_Item__c();
                solirec.CO_Line_Item__c= coliRecToMove.Id;
                solirec.Actual_Kit_Price__c =coliRecToMove.Actual_Kit_Price__c;     
                solirec.Fee__c = null;
                solirec.Fixed_Price__c = coliRecToMove.Fixed_Price__c;
                solirec.Is_Fixed_Kit_LineItem_SO__c = coliRecToMove.CO_Fixed_KitLineItem__c;
                solirec.Kit_Price__c =(coliRecToMove.Actual_Kit_Price__c != 0 && coliRecToMove.Actual_Kit_Price__c != null) ? coliRecToMove.Actual_Kit_Price__c : coliRecToMove.Price__c;
                solirec.Part__c = coliRecToMove.Part__c;
                solirec.Qty_Committed__c = coliRecToMove.Qty_Committed__c;
                solirec.Qty_Needed__c =  coliRecToMove.Qty__c;
				solirec.Tax_Percent__c =  coliRecToMove.Tax__c;
                solirec.Service_Order_Header__c = Id.valueOf(ServiceOrderId);
                solirec.Service_Order_Kit_Header__c = soKitheader;
                soliListToInsert.add(solirec);
            }       
            
            if(soliListToInsert.size()>0){
                ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
                insert soliListToInsert;
            }
            
            for(Service_Order_Line_Item__c solirec: soliListToInsert ){
                coliToSoliMap.put(solirec.CO_Line_Item__c,solirec.Id );
            }   
            
            for(CO_Line_Item__c coliRecToMove : coliListToMove ){
                coliRecToMove.Service_Order_Line_Item__c = coliToSoliMap.get(coliRecToMove.Id);
            }                               
            
            if(coliListToMove.Size()>0 ){
                update coliListToMove;
            }
            return soliListToInsert;
     }
     
     
     //Function to move coli to soli  
     public static String  MoveFromColiToSoli(String coliToMove,String ServiceOrderId) {
            Savepoint sp = Database.setSavepoint();
            if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            coliToMove = BPUtility.escapeSingleQuotes(coliToMove);
            ServiceOrderId = BPUtility.escapeSingleQuotes(ServiceOrderId);
            List<CO_Line_Item__c>  coliListToMove = new List<CO_Line_Item__c>([select Id,Actual_Kit_Price__c,Fixed_Price__c,CO_Fixed_KitLineItem__c,Price__c,
                                                                                Qty_Committed__c,Qty__c,Qty_To_Order__c,Part__c, Tax__c,
                                                                                (Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r) 
                                                                                from CO_Line_Item__c where Id =:coliToMove]);
                                                                    
            list<Service_Order_Header__c> ServiceOrderHeaderRecList =  new list<Service_Order_Header__c>([Select Id,CO_Header__c,(Select Id, CO_Invoice_Header__c, isActive__c From CO_Invoice_Items__r),
                                                                                         (Select Qty_To_Order__c From Service_Order_Line_Items__r)  
                                                                                         from Service_Order_Header__c
                                                                                         where  Id =: ServiceOrderId]);
            Service_Order_Header__c ServiceOrderHeaderRec;
            if(ServiceOrderHeaderRecList.size() > 0){
                 ServiceOrderHeaderRec= ServiceOrderHeaderRecList[0];
            }else{
                return 'errorId';
            }                                                                        
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
            map<Id,Id> coliToSoliMap = new map<Id,Id>();
            list<Service_Order_Line_Item__c> soliListToInsert =  CreateSoliForColi( coliToSoliMap,coliListToMove,null,ServiceOrderId);
            List<CO_Invoice_Item__c> coInvoiceItemToDelete = new List<CO_Invoice_Item__c>();
            for(CO_Line_Item__c coliRecToMove : coliListToMove  ){
                for(CO_Invoice_Item__c colInvoiceRec:  coliRecToMove.CO_Invoice_Items__r){
                    coInvoiceItemToDelete.add(colInvoiceRec);
                } 
            }
            if( coInvoiceItemToDelete.size() > 0){
                delete coInvoiceItemToDelete;
            }
            if(ServiceOrderHeaderRec.CO_Invoice_Items__r.size()==0){
                    list<CO_Invoice_Header__c>  coInvoiceHeaderRec =new list<CO_Invoice_Header__c>([select Id from  CO_Invoice_Header__c where 
                                                                                            CO_Header__c =:ServiceOrderHeaderRec.CO_Header__c and status__c =:'Active' ]);
                    CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
                    if(coInvoiceHeaderRec.size() > 0 ){
                        coInvoiceItem.CO_Invoice_Header__c = coInvoiceHeaderRec[0].Id;
                        coInvoiceItem.isActive__c = true;
                        coInvoiceItem.Is_Invoiceable__c = true;
                        for(Service_Order_Line_Item__c serviceOrderLineItemRec :  ServiceOrderHeaderRec.Service_Order_Line_Items__r){
                            if(serviceOrderLineItemRec.Qty_To_Order__c > 0){
                                coInvoiceItem.Is_Invoiceable__c =false;
                                break;
                            }
                        }
                        coInvoiceItem.Service_Order_Header__c = ServiceOrderHeaderRec.Id;
                        insert coInvoiceItem;
                    }
                
            }
            
        UpdateServiceOrderTotals( ServiceOrderId , null);
        //Database.rollback( sp );
        return 'Sucess';
     }  
     
     // Function to Move COLI   
    @RemoteAction
    global static String moveLineItem(String sectionFrom,String sectionTo,String idToMove,String CoHeaderId) {
    	sectionFrom = BPUtility.getDecodedString(sectionFrom);
    	sectionTo = BPUtility.getDecodedString(sectionTo);
    	idToMove = BPUtility.getDecodedString(idToMove);
    	CoHeaderId = BPUtility.getDecodedString(CoHeaderId);
            // set Swap Flag
            String objectAPIName = Id.valueOf(idToMove).getSObjectType().getDescribe().getName();
            if(sectionFrom == 'Merchandise'){ 
                    if(objectAPIName == CONSTANTS.NAMESPACE + 'CO_Line_Item__c'){
                        String  Result= MoveFromColiToSoli(idToMove,sectionTo);
                    } 
                    else if( objectAPIName == CONSTANTS.NAMESPACE + 'CO_Kit_Header__c' ){
                         String  Result =   MoveFromCokhSokh(idToMove,sectionTo);
                    }
            }else if(sectionTo =='Merchandise' ){
                        if(objectAPIName == CONSTANTS.NAMESPACE + 'Service_Order_Line_Item__c'){
                            String result = MoveFromSoliToColi(idToMove ,null);
                        }else if ( objectAPIName == CONSTANTS.NAMESPACE + 'Service_Order_Kit_Header__c'){
                            String result = MoveFromSokhCOKH(idToMove,null,CoheaderId);
                        }
            }
            else{
                        if(objectAPIName == CONSTANTS.NAMESPACE + 'Service_Order_Line_Item__c'){
                                String result = MoveFromSoliToColi(idToMove ,sectionTo);
                        }else if (objectAPIName == CONSTANTS.NAMESPACE + 'Service_Order_Kit_Header__c'){
                                String result = MoveFromSokhCOKH(idToMove,sectionTo,CoheaderId);
                        }
            }
            return  getCOHeaderDetailsByGridName(BPUtility.getEncodedString(CoHeaderId), BPUtility.getEncodedString(null));
    }
    
    
     /**
    * Name: deleteServiceOrder
    * Desc: Method to delete Service Order From database
    * @param:   (1) coLineItemId - String - CO Line Item Id hich is to be deleted.
    *           (2) coHeaderId - String - CO Header record Id
    * @return: String - JSON String of CO Header Detail Record
    **/
    @RemoteAction
    global static String deleteServiceOrder(String coHeaderId, String soHeaderId){
    	coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
        try{
        	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        	if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	if(AccessControl.ifObjectIsDeletable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	

            List<Service_Order_Header__c> soHeaderRecList = new List<Service_Order_Header__c>();
            soHeaderRecList = SOQLUtil.getSODetailsByFieldName(new Map<String, String>{'Id' => soHeaderId});
            
            if(soHeaderRecList != null && soHeaderRecList.size() > 0 && soHeaderRecList[0].Status__c!= 'Complete' && 
                soHeaderRecList[0].Status__c!= 'Reviewed' && soHeaderRecList[0].Hours_Logged__r.size() == 0 &&
                 soHeaderRecList[0].Service_Order_Line_Items__r.size() == 0)
            {
                List<CO_Header__c> coHeader = SOQLUtil.getCOHeaderDetails(coHeaderId);
                 
                if(coHeader[0].Status__c == 'Open')
                {
                	soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
                	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                    List<CO_Invoice_Item__c> coInvoiceItems = [Select Id From CO_Invoice_Item__c where Service_Order_Header__c =:soHeaderId];
                                                                        
                    if(coInvoiceItems.size() > 0 ){
                            delete coInvoiceItems;
                    }
                    delete soHeaderRecList;
                }
                else
                    throw new BlackPurlException('Please check Status of Servious order');
            
            }
            else
            {
                throw new BlackPurlException('Please check Line itme ');
            }
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return getSOHeaderDetails(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('soHeader,soItemGrid,checkOut,specialOrder'));
    }    
    
  /*  @remoteAction
    global static String getOverridenStatusResults(String workStatus) {
        String overridenStatus = '';
        if(overridenStatusToNextStatusMap.containsKey(workStatus)){
            overridenStatus = overridenStatusToNextStatusMap.get(workStatus);
        }
        return overridenStatus;
    }*/
     
    
    /**
     * Name: insertLogRecord
     * Desc: Method which gives Inserts the record 
     * @param:  (1) jSONString - String - JSON String of Value to be Inserted
     * @return: String - Id Of the Record  Inserted
    **/
   @RemoteAction
    global static String insertLogRecord(String jSONString, String statusType){
    	jSONString = BPUtility.getDecodedString(jSONString);
    	statusType = BPUtility.getDecodedString(statusType);
    	if(AccessControl.ifObjectFieldIsCreateable('App_Log__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        //system.assert(false,jSONString);
        SOWizard.AppLog appLogObj = (SOWizard.AppLog)System.JSON.deserialize(jSONString, SOWizard.AppLog.class);
        
        boolean errorMsg = false;
        if((appLogObj.NewStatus).equalsIgnoreCase('Set As Complete') || (appLogObj.NewStatus).equalsIgnoreCase('Complete') || (appLogObj.NewStatus).equalsIgnoreCase('Signed Out')){
            List<Service_Order_Header__c> SOHeaderList =  [SELECT Id, (SELECT Id, Qty_Needed__c, Part__c, Qty_Committed__c From Service_Order_Line_Items__r) From Service_Order_Header__c where Id = :appLogObj.SOHeaderId];
            for(Service_Order_Line_Item__c SOLineItemRec : SOHeaderList[0].Service_Order_Line_Items__r){
                if(SOLineItemRec.Qty_Needed__c > SOLineItemRec.Qty_Committed__c && SOLineItemRec.Part__c != null){
                    errorMsg = true;
                    break;
                }
            }

            if(errorMsg && (appLogObj.NewStatus).equalsIgnoreCase('Complete')){




        		return Label.SetAsCompleteErrorMessage;
        	} else if(errorMsg && (appLogObj.NewStatus).equalsIgnoreCase('Signed Out')){
        		return Label.SignedOutErrorMessage;
        	}


        }
        
        //system.assert(false,appLogObj);
        App_Log__c appLogRec = new App_Log__c();
        appLogRec.Field__c = appLogObj.Field;
        appLogRec.Old_Value__c = appLogObj.OldStatus;
        appLogRec.New_Value__c = appLogObj.NewStatus;
        appLogRec.Notes__c = appLogObj.Notes;
        appLogRec.Service_Order_Header__c = appLogObj.SOHeaderId;
        
        insert appLogRec;
        
        changeStatus(BPUtility.getEncodedString(appLogObj.SOHeaderId),  BPUtility.getEncodedString(appLogRec.New_Value__c), BPUtility.getEncodedString(statusType));
        return BPUtility.getEncodedString('');   


    }
    
    
    /**
     * Name: getStatusResults
     * Desc: Method which gives records according to the Status Specified Of Work And Claim
     * @param:  (1) JSONString - String - JSON String of searched Value
     * @return: String - JSON String of Work And CLaim
    **/
    @remoteAction
    global static String getStatusResults(String workStatus, String claimStatus) {
    	workStatus = BPUtility.getDecodedString(workStatus);
    	claimStatus = BPUtility.getDecodedString(claimStatus);
        List<String> availableWorkStatusList = new List<String>();
        List<String> availableClaimStatusList = new List<String>();
        if(Constants.workStatusToAvailableStatusMap.containsKey(workStatus)){
            availableWorkStatusList = Constants.workStatusToAvailableStatusMap.get(workStatus);
        }
        if(Constants.claimStatusToAvailableStatusMap.containsKey(claimStatus)){
            availableClaimStatusList = Constants.claimStatusToAvailableStatusMap.get(claimStatus);
        }
        //system.assert(false, new SOInfoWrapper(workStatus, claimStatus, availableWorkStatusList, availableClaimStatusList));
        return BPUtility.getEncodedString(JSON.serialize(new SOWizard.SOInfoWrapper(workStatus, claimStatus, availableWorkStatusList, availableClaimStatusList)));
    }
    
    /**
     * Name: getAppLogRecById
     * Desc: Method which gives records according to the Id
     * @param:  (1) appLogId - String - Id Of App Log
     * @return: String - JSON String of the Object of the Id Specified.
    **/
    @RemoteAction
    global static String getAppLogRecById(String appLogId){
    	appLogId = BPUtility.getDecodedString(appLogId);
        List<App_Log__c> appLogRecList = SOQLUtil.getAppLogRecById(appLogId); 
        List<SOWizard.AppLog> applogObjList = new List<SOWizard.AppLog>();
        for(App_Log__c appLogRec : appLogRecList) {
            applogObjList.add(new SOWizard.AppLog(appLogRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(applogObjList));
    }
    
    @RemoteAction
    global static String getWizardInfo(String soHeaderId, String wizardName) {
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	wizardName = BPUtility.getDecodedString(wizardName);
        if(wizardName == 'Claim_Response'|| wizardName == 'View_Claim_Response' ){
                return getClaimRecById(BPUtility.getEncodedString(soHeaderId));
        
        }else{
            List<Service_Order_Header__c> soHeaderList = SOQLUtil.getSOHeaderById(soHeaderId, wizardName);
            if(soHeaderList.size() == 0) {
                return BPUtility.getEncodedString('{}');


            }
            Service_Order_Header__c soHeaderRec = soHeaderList[0];
            return BPUtility.getEncodedString(System.JSON.serialize(new SOWizard(soHeaderRec, wizardName)));
        }   
    }
    
    /**
     * Name: saveWizardDetails
     * Desc: Save Wizard info to Db
     * @param:  (1) Wizard name to save,Json Pameter
     * @return: Retun Service records
    **/
    @remoteAction
    global static String saveWizardDetails(String soHeaderId, String wizardKey, String wizardJsonToSave, String deleteRecordsJson) {
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	wizardKey = BPUtility.getDecodedString(wizardKey);
    	wizardJsonToSave = BPUtility.getDecodedString(wizardJsonToSave);
    	deleteRecordsJson = BPUtility.getDecodedString(deleteRecordsJson);
        SOWizard.SOSignInWizard SOSignInWizardSOInfoObj = (SOWizard.SOSignInWizard) System.JSON.deserialize(wizardJsonToSave, SOWizard.SOSignInWizard.class);
        List<CustomerApproval> approvalList = SOSignInWizardSOInfoObj.Approval_Method;
        
        if(wizardKey == 'Sign_In'){
            // Save Approval Type List
            saveCustomerApprovalInfo(soHeaderId, wizardKey, approvalList, 'Ready');
        } else if(wizardKey == 'Service_Sign_Out') {
            
            saveCustomerApprovalInfo(soHeaderId, wizardKey, approvalList, 'Signed Out');
        
        } else if(wizardKey == 'Claim_Submission') {
            saveCustomerApprovalInfo(soHeaderId, wizardKey, approvalList, 'Ready to Submit');
        }
        return getWizardInfo(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString(wizardKey));
    }
    
     


    private static void saveCustomerApprovalInfo(String soHeaderId, String wizardKey, List<CustomerApproval> approvalList, String newWorkStatus) {
    	if(AccessControl.ifObjectFieldIsAccessible('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectIsDeletable('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	
		soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
        List<CustomerApproval__c> existingApprovalList = [select Id, Section_key__c, ApprovalType__c 
                                                                                            from CustomerApproval__c where Service_Order_Header__c =: soHeaderId
                                                                                            and Section_key__c =: wizardKey]; 
        
        Map<String, CustomerApproval__c> approvalTypeToApprovalRecordMap = new Map<String, CustomerApproval__c>();
        for(CustomerApproval__c custApprovalRec : existingApprovalList) {
            approvalTypeToApprovalRecordMap.put(custApprovalRec.ApprovalType__c, custApprovalRec);
        }                                                   
        
        List<CustomerApproval__c> approvalListToUpsert = new List<CustomerApproval__c>();
        Boolean isStatusToBeChanged = false;
        for(CustomerApproval custApprovalObj : approvalList) {
            CustomerApproval__c custApprovalRec = new CustomerApproval__c();
            custApprovalRec.Service_Order_Header__c = soHeaderId;
            custApprovalRec.Section_key__c = wizardKey;
            custApprovalRec.Section_Name__c = (wizardKey != null) ? wizardKey.replaceAll('_', '-') : null;
            
            if(custApprovalObj.IsApprovalObtained != null && custApprovalObj.IsApprovalObtained) {
                custApprovalRec.Status__c = 'Approved';
                isStatusToBeChanged = true;
            } else {
                custApprovalRec.Status__c = 'Pending';
            }
            custApprovalRec.Notes__c = custApprovalObj.Notes;
            custApprovalRec.ApprovalType__c = custApprovalObj.ApprovalType;
            if(approvalTypeToApprovalRecordMap.containsKey(custApprovalObj.ApprovalType)) {
                custApprovalRec.Id = approvalTypeToApprovalRecordMap.get(custApprovalObj.ApprovalType).Id;
                approvalTypeToApprovalRecordMap.remove(custApprovalObj.ApprovalType);
            } 
            approvalListToUpsert.add(custApprovalRec);
        }
        
        if(approvalListToUpsert.size() > 0) {
            upsert approvalListToUpsert;
        }
        if(approvalTypeToApprovalRecordMap.values().size() > 0) {
            delete approvalTypeToApprovalRecordMap.values();
        }
        if(isStatusToBeChanged) {
            if(wizardKey == 'Claim_Submission') {
                changeStatus(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString(newWorkStatus), BPUtility.getEncodedString('claim'));


            } else {
                changeStatus(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString(newWorkStatus), BPUtility.getEncodedString('work'));


            }
        }
    }
    
    
    @remoteAction
    global static String sendOnSignInWizard(String custJsonStr, String notes, String soHeaderId, String customerName) {
    	custJsonStr = BPUtility.getDecodedString(custJsonStr);
    	notes = BPUtility.getDecodedString(notes);
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	customerName = BPUtility.getDecodedString(customerName);
    	if(AccessControl.ifObjectFieldIsAccessible('Organization') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	

        List<SOWizard.CustInfo> custJSONList = (List<SOWizard.CustInfo>) System.JSON.deserialize(custJsonStr, List<SOWizard.CustInfo>.class);
        List<String> emailStrList = new List<String>();
        
        for(SOWizard.CustInfo custInfoObj : custJSONList) {
            if(custInfoObj.IsSelected && custInfoObj.Label != null && custInfoObj.Type == 'EMAIL' && custInfoObj.Value != null) {
                emailStrList.add(custInfoObj.Value);
            } 
        }
        
        List<Organization> companyInformationList = [SELECT Id, LanguageLocaleKey, Name, Phone FROM Organization where Id = :UserInfo.getOrganizationId()];
        if(companyInformationList.size() == 0) {
            return BPUtility.getEncodedString('Please set Company Information first');
        }
        
        Organization company = companyInformationList[0];
        
        String subject = company.Name + ' - Service Update';
        String body = 'Hello '+ customerName +'<br/><br/>We need to get your approval before continuing to service your unit.  Please review the following information and let us know if we can proceed.<br/><br/>';
        body += 'If you have any questions on anything you see, don\'t hesitate to contact us. <br/><br/> Looking forward to hearing from you soon,<br/><br/>';
        body += UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + '<br/>' + company.Name + '<br/>' + company.Phone + '<br/>';
        try {
            SendEmail.send(emailStrList, subject, body, soHeaderId);
            if(emailStrList.size() > 0) {
                return BPUtility.getEncodedString('Sent');

            }


        } catch(Exception e) {
            

        }
        return BPUtility.getEncodedString('Not Sent');


    }
    
    
    @remoteAction
    global static void changeStatus(String soHeaderId, String newStatus, String statusType) {
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	newStatus = BPUtility.getDecodedString(newStatus);
    	statusType = BPUtility.getDecodedString(statusType);
        if(String.isNotBlank(soHeaderId)) {
        	if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

            Service_Order_Header__c soHeader = new Service_Order_Header__c(Id = soHeaderId);
            if(statusType.equalsIgnoreCase('work')) {
                soHeader.Work_Status__c = newStatus;
            } else {
                soHeader.Claim_Status__c = newStatus;
            }
            update soHeader;
        } 


    }
    
    @RemoteAction
    global static string addDeductibleAmount(String deductibleJson) {
    	deductibleJson = BPUtility.getDecodedString(deductibleJson);
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	

        SOHeaderWrapper.Deductible soPaymentWrapperObj = (SOHeaderWrapper.Deductible)System.JSON.deserialize(deductibleJson, SOHeaderWrapper.Deductible.class);
        List<RecordType> deductibleRecordTypeIdList =  SOQLUtil.getRecordTypeId(Constants.NAMESPACE + 'SO_Payment_Role__c', 'Deductible');
        String RecordTypeDeductible = deductibleRecordTypeIdList[0].Id;
        Integer nullStatusDeductibleRec = 0;
        Integer OwingStatusDeductibleRec = 0;
         
        //System.Assert(false,soPaymentWrapperObj.DeductibleStatus);
        List<SO_Payment_Role__c> soPaymentRoleRecList = SOQLUtil.getSOPaymentWrapperById(soPaymentWrapperObj.SoHeaderId, null);
        for(SO_Payment_Role__c soPaymentRec: soPaymentRoleRecList ){
            if(soPaymentRec.Deductible_Status__c == null && soPaymentRec.RecordTypeId == RecordTypeDeductible){
                nullStatusDeductibleRec += 1;
                break;
            } else if(soPaymentRec.Deductible_Status__c == 'Owing' && soPaymentRec.RecordTypeId == RecordTypeDeductible){
                OwingStatusDeductibleRec += 1;
                break;
            }
        }
        
        List<CO_Invoice_Header__c> coInvoiceHeaderList = [Select Id  From CO_Invoice_Header__c where CO_Header__c =:soPaymentWrapperObj.CoHeaderId and Status__c = 'Active'];
        SO_Payment_Role__c soPaymentRoleRec = new SO_Payment_Role__c();
        soPaymentRoleRec.Total_Amount__c = soPaymentWrapperObj.DeductibleAmount;
        soPaymentRoleRec.RecordTypeId =deductibleRecordTypeIdList[0].Id;
        soPaymentRoleRec.Service_Order_Header__c = soPaymentWrapperObj.SoHeaderId;
        String coInvoiceHeaderId = '';
        if(nullStatusDeductibleRec > 0 && soPaymentWrapperObj.DeductibleStatus == null ){
            soPaymentRoleRec.Id = soPaymentWrapperObj.DeductibleId;
            update soPaymentRoleRec;
        } else if((OwingStatusDeductibleRec > 0) && ((soPaymentWrapperObj.DeductibleStatus == 'Adjust') || (soPaymentWrapperObj.DeductibleStatus == 'Owing') )){
            soPaymentRoleRec.Id = soPaymentWrapperObj.DeductibleId;  
            if(soPaymentWrapperObj.DeductibleStatus == 'Adjust'){
                soPaymentRoleRec.Deductible_Status__c = 'Owing';
            }
            update soPaymentRoleRec;
            
        } else{
            if(soPaymentWrapperObj.DeductibleStatus == 'Adjust'){
                soPaymentRoleRec.Deductible_Status__c = 'Owing';   
            } else {
                soPaymentRoleRec.Deductible_Status__c = soPaymentWrapperObj.DeductibleStatus;
            }
            insert soPaymentRoleRec;
        }
        
        return getSOHeaderDetails(BPUtility.getEncodedString(soPaymentWrapperObj.coHeaderId), BPUtility.getEncodedString('checkOut'));
    }
    
    @RemoteAction
    global static String getSoPaymentRoleById(String soHeaderId){
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
        List<SO_Payment_Role__c> soPaymentRoleRecList = SOQLUtil.getSOPaymentWrapperById(soHeaderId , 'Owing');
        List<SOPaymentWrapper> soPaymentRoleObjList = new List<SOPaymentWrapper>();
        for(SO_Payment_Role__c soPaymentRoleRec : soPaymentRoleRecList) {
            soPaymentRoleObjList.add(new SOPaymentWrapper(soPaymentRoleRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(soPaymentRoleObjList));
    }
    
    
    @remoteAction
    global static String getAttachmentListByParentId(String parentId) {
    	parentId = BPUtility.getDecodedString(parentId);
    	parentId = BPUtility.escapeSingleQuotes(parentId);
    	if(AccessControl.ifObjectFieldIsAccessible('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Attachment> attList = [select Description, Name, CreatedDate from Attachment where ParentId = : parentId];
        if(attList.size() == 0) {
            return BPUtility.getEncodedString('{}');


        }
        
        List<SOHeaderWrapper.Attachments> attachList = new List<SOHeaderWrapper.Attachments>();
        for(Attachment att : attList) {
            attachList.add(new SOHeaderWrapper.Attachments(att));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(attachList));
    }
    
    @remoteAction
    global static String removeAttachment(String attachmentId, String soHeaderId) {
    	attachmentId = BPUtility.getDecodedString(attachmentId);
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	if(AccessControl.ifObjectIsDeletable('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	attachmentId = BPUtility.escapeSingleQuotes(attachmentId);
        List<Attachment> attList = [select Id from Attachment where Id = : attachmentId];
        if(attList.size() > 0) {
            delete attList;
        }
        return getAttachmentListByParentId(BPUtility.getEncodedString(soHeaderId));
    }
    
    @RemoteAction
    global static String uploadAttachment(String filename, String fileData, String recordId, String description) {
    	filename = BPUtility.getDecodedString(filename);
    	fileData = BPUtility.getDecodedString(fileData);
    	recordId = BPUtility.getDecodedString(recordId);
    	description = BPUtility.getDecodedString(description);
    	if(AccessControl.ifObjectFieldIsCreateable('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	

        String user = UserInfo.getUserID();
        if(fileData == null) {
            return BPUtility.getEncodedString(String.valueOf('Invalid file data.'));
        }
        String base64 = fileData.substring(fileData.indexOf(',') + 1);
        Blob actualdata = EncodingUtil.base64Decode(base64);
        if(actualdata.size()<=0) {
            return BPUtility.getEncodedString(String.valueOf('File size cannot be greater then 10 MB.'));
        }
        
        Attachment att = new Attachment(ParentId = recordId, Body = actualdata);
        att.Name = filename;
        att.Description = description;
        insert(att);
        
        return getAttachmentListByParentId(BPUtility.getEncodedString(recordId));
    }
    
      
    @RemoteAction
    global static String getClaimRecById(String soHeaderId){
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
        List<Claim__c> claimRecList = SOQLUtil.getClaimDetailsBySOHeaderId(soHeaderId); 
        if(claimRecList.size() == 0) {
            return BPUtility.getEncodedString('{}');


        }
        List<SO_Payment_Role__c> soPaymentRoles = SOQLUtil.getSOPaymentWrapperById(soHeaderId, null);
        List<Category__c> internalCategoryList = SOQLUtil.getCategoryById('Internal Expense');
        List<SO_Payment_Role__c> deductibleList = new List<SO_Payment_Role__c>();
        
        for(SO_Payment_Role__c soPaymentRec : soPaymentRoles) {
            if(soPaymentRec.RecordType.DeveloperName == 'Deductible') {
                deductibleList.add(soPaymentRec);
            }
        }
        ClaimWizard claimObj = new ClaimWizard(claimRecList[0], deductibleList,internalCategoryList);
        return BPUtility.getEncodedString(System.JSON.serialize(claimObj));
    }
    
    @RemoteAction
    global static String getCustomerApprovalInfo(String soHeaderId, String sectionKey, Decimal approvalCount){
    	if(AccessControl.ifObjectFieldIsAccessible('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	sectionKey = BPUtility.getDecodedString(sectionKey);
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);

        List<CustomerApproval> custApprovalList = new List<CustomerApproval>();
        List<CustomerApproval__c> customerApprovalList = new List<CustomerApproval__c>();
        
        if(sectionKey == 'Get_Approval' && approvalCount != null) {
            customerApprovalList = [select Approval_Count__c, ApprovalDetailJson__c, ApprovalType__c, Notes__c, Section_key__c, Name, LastModifiedDate,
                                                Section_Name__c, Service_Order_Header__c, Status__c from CustomerApproval__c 
                                                where Service_Order_Header__c =: soHeaderId AND Approval_Count__c = :approvalCount];
        
        } else if(sectionKey != 'Get_Approval') {
            customerApprovalList = [select Approval_Count__c, ApprovalDetailJson__c, ApprovalType__c, Notes__c, Section_key__c, Name, LastModifiedDate,
                                                Section_Name__c, Service_Order_Header__c, Status__c from CustomerApproval__c 
                                                where Service_Order_Header__c =: soHeaderId AND Section_key__c =: sectionKey];
        
        } 
        
        for(CustomerApproval__c custApproval : customerApprovalList) {
            custApprovalList.add(new CustomerApproval(custApproval));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(custApprovalList));
    }
    
    @RemoteAction
    global static String saveCustomerApprovalInfo(String soHeaderId, String JSONString) {
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	JSONString = BPUtility.getDecodedString(JSONString);
    	if(AccessControl.ifObjectFieldIsAccessible('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectIsDeletable('CustomerApproval__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
        List<CustomerApproval> custApprovalObjList = (List<CustomerApproval>)System.JSON.deserialize(JSONString, List<CustomerApproval>.class);
        List<CustomerApproval__c> custApprovalList = new List<CustomerApproval__c>();
        Decimal approvalCount;
        for(CustomerApproval custApprovalObj : custApprovalObjList) {
            //soHeaderId = custApprovalObj.ServiceOrderHeader;
            if(custApprovalObj.ApprovalCount != null) {
                approvalCount = custApprovalObj.ApprovalCount;
            }   
        }
        List<CustomerApproval__c> existingApprovalList;
        if(approvalCount == null) {
        	
            existingApprovalList = [select Id, Approval_Count__c from CustomerApproval__c where Service_Order_Header__c =: soHeaderId 
                                                                        AND Section_key__c = 'Get_Approval'

                                                                        Order By Approval_Count__c DESC nulls last];
            approvalCount = (existingApprovalList.size() == 0) ? 1 : (existingApprovalList[0].Approval_Count__c + 1);                                                      
        }
        
        
        existingApprovalList = [select Id, Section_key__c, ApprovalType__c, Approval_Count__c
                                        from CustomerApproval__c where Service_Order_Header__c =: soHeaderId
                                        and Approval_Count__c =: approvalCount]; 
        
        Map<String, CustomerApproval__c> approvalTypeToApprovalRecordMap = new Map<String, CustomerApproval__c>();
        for(CustomerApproval__c custApprovalRec : existingApprovalList) {
            approvalTypeToApprovalRecordMap.put(custApprovalRec.ApprovalType__c, custApprovalRec);
        }                                                   
        
        List<CustomerApproval__c> approvalListToUpsert = new List<CustomerApproval__c>();
        for(CustomerApproval custApprovalObj : custApprovalObjList) {
            CustomerApproval__c custApprovalRec = new CustomerApproval__c();
            custApprovalRec.Service_Order_Header__c = soHeaderId;
            custApprovalRec.Section_key__c = 'Get_Approval';
            custApprovalRec.Section_Name__c = 'Get-Approval';
            
            if(custApprovalObj.IsApprovalObtained != null && custApprovalObj.IsApprovalObtained) {
                custApprovalRec.Status__c = 'Approved';
            } else {
                custApprovalRec.Status__c = 'Pending';
            }
            custApprovalRec.Notes__c = custApprovalObj.Notes;
            custApprovalRec.ApprovalType__c = custApprovalObj.ApprovalType;
            custApprovalRec.Approval_Count__c = approvalCount;
            if(approvalTypeToApprovalRecordMap.containsKey(custApprovalObj.ApprovalType)) {
                custApprovalRec.Id = approvalTypeToApprovalRecordMap.get(custApprovalObj.ApprovalType).Id;
                approvalTypeToApprovalRecordMap.remove(custApprovalObj.ApprovalType);
            } 
            approvalListToUpsert.add(custApprovalRec);
        }
        
        if(approvalListToUpsert.size() > 0) {
            upsert approvalListToUpsert;
        }
        if(approvalTypeToApprovalRecordMap.values().size() > 0) {
            delete approvalTypeToApprovalRecordMap.values();
        }
        
        return getCustomerApprovalInfo(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString('Get_Approval'),approvalCount);
    }
    
    @RemoteAction
    global static String getProviderInfo(String vendorId){
    	vendorId = BPUtility.getDecodedString(vendorId);
        return ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(vendorId));    
    }
    
    @RemoteAction
    global static String getPrintingInfo(String soHeaderId){
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
        return SOHeaderPrintPreviewCtrl.getPrinitngInfo(BPUtility.getEncodedString(soHeaderId));    
    }
    
    
    @RemoteAction
    global static void createClaim(Service_Order_Header__c soHeaderRec){
        Claim__c claimRec = new Claim__c(Service_Order_Header__c = soHeaderRec.Id);
        if(AccessControl.ifObjectFieldIsCreateable('Claim__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        insert claimRec;
    }
    
    
    @RemoteAction
    global static String submitClaimRecords(String soHeaderId) {
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	if(AccessControl.ifObjectFieldIsAccessible('Claim__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('Claim__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	
		soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);
        List<Service_Order_Line_Item__c> soLineItemList = SOQlUtil.getServiceOrderLineItemBySoHeader(soHeaderId);
        List<Claim__c> claimRecords = [select Id from Claim__c where Service_Order_Header__c =: soHeaderId];
        if(claimRecords.size() > 0 || soLineItemList.size() == 0) {
            return BPUtility.getEncodedString('{}');


        }  
        
        Claim__c claimRec = new Claim__c();
        claimRec.Service_Order_Header__c = soHeaderId;
        claimRec.Claim_Disposition__c = 'Accepted';
        insert claimRec;
        
        List<RecordType> ThirdPartRecordTypeList =  SOQLUtil.getRecordTypeId(Constants.NAMESPACE + 'SO_Payment_Role__c', 'Third_Party');
        SO_Payment_Role__c sopaymetntRoleRec = new SO_Payment_Role__c(Service_Order_Header__c = soHeaderId, Claim__c = claimRec.Id,
                                                                        RecordTypeId = ThirdPartRecordTypeList[0].Id);
        insert sopaymetntRoleRec;                                                               
        
        List<Claim_Line_Item__c> claimLineItemList = new List<Claim_Line_Item__c>();
        Decimal TotalAmount = 0;
        Decimal TotalTaxamount = 0;
        for(Service_Order_Line_Item__c soLineItemRec : soLineItemList) {
            Claim_Line_Item__c  claimLineItemRec= new Claim_Line_Item__c();
            Decimal Amount = 0;
            claimLineItemRec.Approved_Price__c = soLineItemRec.Kit_Price__c;
            claimLineItemRec.Approved_Qty__c = soLineItemRec.Qty_Needed__c;
            claimLineItemRec.Claimed_Price__c = soLineItemRec.Kit_Price__c;
            claimLineItemRec.Claimed_Qty__c = soLineItemRec.Qty_Needed__c;
            claimLineItemRec.Item_Desc__c = soLineItemRec.Item_Desc__c ;
            claimLineItemRec.Service_Order_Line_Item__c = soLineItemRec.Id;
            claimLineItemRec.SO_Payment_Role__c = sopaymetntRoleRec.Id;
            claimLineItemRec.Tax__c = soLineItemRec.Tax__c;
            claimLineItemRec.Claim__c = claimRec.Id;
            Amount = (soLineItemRec.Kit_Price__c !=null) ? soLineItemRec.Kit_Price__c : 0;
            TotalAmount += (Amount *claimLineItemRec.Approved_Qty__c);
            TotalTaxamount += Amount * ((soLineItemRec.Tax__c != null) ? soLineItemRec.Tax__c : 0) / 100;
            claimLineItemList.add(claimLineItemRec);
        }
                
        if(claimLineItemList.size() > 0){
            insert claimLineItemList;
        }
        
        if(claimLineItemList.size() > 0 && sopaymetntRoleRec.Id !=null){
            sopaymetntRoleRec.Total_Amount__c = TotalAmount;
            sopaymetntRoleRec.Tax_Amount__c = TotalTaxamount;
            update sopaymetntRoleRec;
        }
        changeStatus(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString('Submitted'), BPUtility.getEncodedString('claim'));
        return BPUtility.getEncodedString('{}');




    }
    
      @RemoteAction
    global static String saveClaimResponse(String soHeaderId,String ClaimWizardJson,String StepNumber){
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	ClaimWizardJson = BPUtility.getDecodedString(ClaimWizardJson);
    	StepNumber = BPUtility.getDecodedString(StepNumber);
        if(StepNumber == '1'){
        	if(AccessControl.ifObjectFieldIsUpdateable('Claim__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        	

             ClaimWizard claimWizardObj = (ClaimWizard)System.JSON.deserialize(ClaimWizardJson, ClaimWizard.class);
             
             if(claimWizardObj.ClaimId != null ){
                Claim__c claimRec =  new  Claim__c();
                claimRec.Id = claimWizardObj.ClaimId;
                claimRec.Provider_Claim_Number__c = claimWizardObj.ProviderClaimNumber;
                claimRec.Notes__c =claimWizardObj.Notes;
                //claimRec.Response_Date__c = DateTime.valueOf(claimWizardObj.ResponseDate).format('MM/dd/yyyy');
                claimRec.Claim_Disposition__c =claimWizardObj.ClaimDisposition;
                claimRec.Service_Order_Header__c = soHeaderId;
                update claimRec;
             }
        }
        if(StepNumber == '2'){
            CreateNewVariance( soHeaderId, ClaimWizardJson);
        }
        else if(StepNumber == '3'){
             updateVariance(soHeaderId,ClaimWizardJson);
             changeStatus(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString('Approved'), BPUtility.getEncodedString('claim'));


        }
        return getWizardInfo(BPUtility.getEncodedString(soHeaderId), BPUtility.getEncodedString('Claim_Response'));
    }
    
    // Update Bill to information for Variable
     public Static String updateVariance(String soHeaderId,String ClaimWizardJson){
		if(AccessControl.ifObjectFieldIsAccessible('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('RecordType') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Claim_Line_item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		

		if(AccessControl.ifObjectFieldIsCreateable('So_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		

		if(AccessControl.ifObjectFieldIsUpdateable('So_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		

		if(AccessControl.ifObjectIsDeletable('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		
		soHeaderId = BPUtility.escapeSingleQuotes(soHeaderId);

            ClaimWizard claimWizardObj = (ClaimWizard)System.JSON.deserialize(ClaimWizardJson, ClaimWizard.class);
            List<ClaimWizard.ClaimLineItem>  claimLineItemClassList = claimWizardObj.VarianceLineItemList;
            map<Id,SO_Payment_Role__c> CategoryToSoPaymentRoleMap = new   map<Id,SO_Payment_Role__c>();
            if( claimWizardObj.ClaimId ==null){
                return 'ID Doesnt Exits';
            }  
            else{
                map<Id,Claim_Line_Item__c> claimLineOldmap=new map<Id,Claim_Line_Item__c> ([select Id,SO_Payment_Role__r.Status__c, Approved_Price__c,Is_Variance__c,
                                                                                            Approved_Qty__c,Variance_Qty__c,Variance_Amount__c ,Service_Order_Line_Item__c,
                                                                                            SO_Payment_Role__c,SO_Payment_Role__r.RecordType.DeveloperName
                                                                                            From Claim_Line_Item__c where  Claim__c =: claimWizardObj.ClaimId and Is_Variance__c = true]);
                                                                                            
                List<SO_Payment_Role__c> SoPaymentList = [select Id,Status__c,RecordType.DeveloperName,Category__c from SO_Payment_Role__c where Service_Order_Header__c =: soHeaderId and
                                                         RecordType.DeveloperName ='Internal' and Status__c !='Invoiced' order by LastModifiedDate];
                
                
                
                List<RecordType> RecordTypeList =([select Id,DeveloperName from RecordType where RecordType.DeveloperName ='Internal' or  RecordType.DeveloperName ='customer']);
                
                String CustomerRecordType;
                String InternalRecordType;
                
                for(RecordType recordItem :  RecordTypeList){
                    if(recordItem.DeveloperName =='Internal' ){
                        InternalRecordType = recordItem.Id;
                    }
                    else if(recordItem.DeveloperName =='Customer' ){
                        CustomerRecordType = recordItem.Id;
                    }
                }
                
                for(SO_Payment_Role__c SoPaymentRecord : SoPaymentList){
                        if(SoPaymentRecord.Category__c != null) {
                            CategoryToSoPaymentRoleMap.put(SoPaymentRecord.Category__c,SoPaymentRecord);
                        }
                        
                }
                List<Claim_Line_Item__c> InternalSoPaymentClaimLineItemList = new List<Claim_Line_Item__c>();
                map<Id,SO_Payment_Role__c> ClaimLineItemIdToSopayment = new map<Id,SO_Payment_Role__c>();
                map<Id,Claim_Line_Item__c> IdToClaimLineItemMap = new map<Id,Claim_Line_Item__c>();
                List<Claim_Line_Item__C> CategoryIdToClaimLineList=  new   List<Claim_Line_Item__C> ();
                
                for(ClaimWizard.ClaimLineItem ClaimLineItemVarianceRec :  claimLineItemClassList){
                    if(claimLineOldmap.ContainsKey(ClaimLineItemVarianceRec.Id)){
                        Claim_Line_Item__c claimRec =  claimLineOldmap.get(ClaimLineItemVarianceRec.Id);
                         if(claimRec.SO_Payment_Role__r.RecordType.DeveloperName !=  ClaimLineItemVarianceRec.BillTo){
                                Claim_Line_Item__c ClaimRecordsTosave =  new Claim_Line_Item__c();
                                ClaimRecordsTosave.Id= ClaimLineItemVarianceRec.Id;
                                ClaimRecordsTosave.Variance_Amount__c= ClaimLineItemVarianceRec.VarianceAmount; 
                                ClaimRecordsTosave.Variance_Qty__c= ClaimLineItemVarianceRec.VarianceQuantity;
                                ClaimRecordsTosave.Claim__c = ClaimLineItemVarianceRec.Claim;
                                ClaimRecordsTosave.Category__c = ClaimLineItemVarianceRec.Category;  
                                ClaimRecordsTosave.Total_Variance_Amount__c = ClaimLineItemVarianceRec.TotalVariance;  
                                ClaimRecordsTosave.Tax__c =  (((ClaimLineItemVarianceRec.Tax ) /100) * ClaimLineItemVarianceRec.TotalVariance);
                                if(ClaimLineItemVarianceRec.BillTo =='Customer'){
                                    SO_Payment_Role__c soPaymentRec = new SO_Payment_Role__c(Service_Order_Header__c = claimWizardObj.soHeaderId,RecordTypeId = CustomerRecordType,Status__c='Pending',
                                    Claim__c =ClaimRecordsTosave.Claim__c, Total_Amount__c =  ClaimRecordsTosave.Total_Variance_Amount__c,
                                    Qty__c = ClaimRecordsTosave.Variance_Qty__c,Tax_Amount__c = ClaimRecordsTosave.Tax__c);
                                    ClaimLineItemIdToSopayment.put(ClaimRecordsTosave.Id ,soPaymentRec );
                                    IdToClaimLineItemMap.put(ClaimRecordsTosave.Id ,ClaimRecordsTosave );
                                }

                                else if(ClaimLineItemVarianceRec.BillTo =='Internal'){
                                        if(CategoryToSoPaymentRoleMap.containsKey(ClaimRecordsTosave.Category__c)){
                                                CategoryIdToClaimLineList.add(ClaimRecordsTosave);
                                        }
                                        else{


                                            SO_Payment_Role__c soPaymentRec = new SO_Payment_Role__c(Service_Order_Header__c = claimWizardObj.soHeaderId
                                            ,RecordTypeId = InternalRecordType,Status__c='Pending',Category__c = ClaimRecordsTosave.Category__c,
                                            Claim__c =ClaimRecordsTosave.Claim__c); 
                                            CategoryToSoPaymentRoleMap.put(ClaimRecordsTosave.Category__c,soPaymentRec);
                                            CategoryIdToClaimLineList.add(ClaimRecordsTosave);
                                            }
                                        }
                                }



                        }
                    }
                
               
                List<Claim_Line_Item__c> ClaimLineItemListToUpdate = new List<Claim_Line_Item__c>();
                List<So_Payment_Role__c>  SoPaymentRoleInternal =new  List<So_Payment_Role__c>();
               
                if(CategoryToSoPaymentRoleMap.Size() > 0 ){
                    upsert CategoryToSoPaymentRoleMap.Values();  
                    

                    for(Claim_Line_Item__c claimLineItemRec :  CategoryIdToClaimLineList){
                            So_Payment_Role__C SopaymentRec = CategoryToSoPaymentRoleMap.get(claimLineItemRec.Category__c);
                            claimLineItemRec.SO_Payment_Role__c = SopaymentRec.Id;
                            ClaimLineItemListToUpdate.add(claimLineItemRec);
                     }

                    
                    update ClaimLineItemListToUpdate;
                }
                
               if(ClaimLineItemIdToSopayment.Size() > 0 ){
                    List<Claim_Line_Item__c> ClaimlineItemToUpdate =new  List<Claim_Line_Item__c>();
                    insert ClaimLineItemIdToSopayment.Values();
                    for(String ClaimId : ClaimLineItemIdToSopayment.KeySet()){
                        SO_Payment_Role__c SoPaymentRec = ClaimLineItemIdToSopayment.get(ClaimId);
                        Claim_Line_Item__c ClaimLineItemRec = IdToClaimLineItemMap.get(ClaimId);
                        ClaimLineItemRec.SO_Payment_Role__c = SoPaymentRec.Id;
                        ClaimlineItemToUpdate.add(ClaimLineItemRec);
                    }
                    update ClaimlineItemToUpdate;
                }
                  
                List<SO_Payment_Role__c> SoPaymentAllList =[select Id,Total_Amount__c,Tax_Amount__c ,RecordType.DeveloperName,(select Id,Approved_Qty__c,Approved_Price__c,Tax__c,
                                                            Variance_Qty__c,Variance_Amount__c,
                                                            Total_Variance_Amount__c

                                                            from Claim_Line_items__r ) from SO_Payment_Role__c where 
                                                            Service_Order_Header__c =: soHeaderId  and RecordType.DeveloperName !='Deductible'];

            

                List<SO_Payment_Role__c> SoPaymentListToDelete = new  List<SO_Payment_Role__c>();
                List<SO_Payment_Role__c> SoPaymentListToUpdate = new  List<SO_Payment_Role__c>();
                

                for(SO_Payment_Role__c  SolPayemtRec : SoPaymentAllList){
                    if(SolPayemtRec.Claim_Line_Items__r.size()==0){
                        SoPaymentListToDelete.add(SolPayemtRec);
                    }
                    else{
                        SoPaymentListToUpdate.add(SolPayemtRec);
                    }
                }
                
                UpdateSoPaymentTotal(SoPaymentListToUpdate);
                
                if(SoPaymentListToDelete.size() > 0 ){
                    delete SoPaymentListToDelete;
                }                   
            }
            return '{}';
     }
    
     
     // create new Variance For SOLI's
     public Static String CreateNewVariance(String soHeaderId, String ClaimWizardJson){
     	if(AccessControl.ifObjectFieldIsAccessible('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
     	if(AccessControl.ifObjectFieldIsAccessible('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
     	

     	if(AccessControl.ifObjectFieldIsCreateable('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
     	if(AccessControl.ifObjectFieldIsUpdateable('Claim__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
     	if(AccessControl.ifObjectIsDeletable('Claim_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
     	

        ClaimWizard claimWizardObj = (ClaimWizard)System.JSON.deserialize(ClaimWizardJson, ClaimWizard.class);
        Claim__c claimRec =  new  Claim__c();
        claimRec.Id = claimWizardObj.ClaimId;
        claimRec.Claim_Number__c =  claimWizardObj.ClaimNumber;
        claimRec.Provider_Claim_Number__c = claimWizardObj.ProviderClaimNumber;
        claimRec.Notes__c =claimWizardObj.Notes;
        //claimRec.Response_Date__c = DateTime.valueOf(claimWizardObj.ResponseDate).format('MM/dd/yyyy');
        claimRec.Claim_Disposition__c =claimWizardObj.ClaimDisposition;
        claimRec.Service_Order_Header__c = soHeaderId;
        update claimRec;
        
        List<ClaimWizard.ClaimLineItem>  claimLineItemClassList = claimWizardObj.NonVarianceLineItemList ;
        
        List<Claim_Line_Item__c> claimLineOldList=new List<Claim_Line_Item__c> ([select Id,SO_Payment_Role__r.Status__c, Approved_Price__c,Is_Variance__c,
                                                                                SO_Payment_Role__r.RecordType.DeveloperName,Approved_Qty__c,Variance_Qty__c,
                                                                                Variance_Amount__c ,Service_Order_Line_Item__c
                                                                                From Claim_Line_Item__c where  Claim__c =: claimRec.Id]);
   
        Map<Id,Claim_Line_Item__c> SoliToClaimLineItemMap =  new Map<Id,Claim_Line_Item__c>();  
        Map<Id,Claim_Line_Item__c> SoliToCaimVarinceLineItemMap =  new Map<Id,Claim_Line_Item__c>();  
        set<Id> SoPaymentRoleToUpdateSet = new set<Id>();
        for(Claim_Line_Item__c claimLineItemRec : claimLineOldList){
                if(claimLineItemRec.Is_Variance__c){
                    SoliToCaimVarinceLineItemMap.put(claimLineItemRec.Service_Order_Line_Item__c,claimLineItemRec );
                }
                else{
                    if(claimLineItemRec.SO_Payment_Role__c !=null ){
                        SoPaymentRoleToUpdateSet.add(claimLineItemRec.SO_Payment_Role__c);
                    }

                    SoliToClaimLineItemMap.put(claimLineItemRec.Service_Order_Line_Item__c,claimLineItemRec );
                }
        } 
        
        List<Claim_Line_Item__c> claimLineItemList = new List<Claim_Line_Item__c>();
        List<Claim_Line_Item__c> claimLineItemVarianceList = new List<Claim_Line_Item__c>();
        List<Claim_Line_Item__c> claimLineItemVarianceListToDelete = new List<Claim_Line_Item__c>();
        
        for(ClaimWizard.ClaimLineItem  claimLineItemobj :claimLineItemClassList  ){
            Claim_Line_Item__c claimLineItemRec = new Claim_Line_Item__c();
            Claim_Line_Item__c claimLineItemVarRec = new Claim_Line_Item__c();
            Claim_Line_Item__c claimLineItemVarRecToDelete = new Claim_Line_Item__c();
            
            if( SoliToClaimLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).Approved_Price__c != claimLineItemobj.ApprovedPrice ||  
                SoliToClaimLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).Approved_Qty__c != claimLineItemobj.ApprovedQty  ){
                    
                if(  SoliToClaimLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).SO_Payment_Role__r.Status__c =='Invoiced'){
                
                    return'{}';
                }
                else if( SoliToCaimVarinceLineItemMap.containsKey(claimLineItemobj.ServiceOrderLineItem) && SoliToCaimVarinceLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).SO_Payment_Role__c  !=null && SoliToCaimVarinceLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).SO_Payment_Role__r.Status__c  =='Invoiced'  ){
                        
                            return'{}';
                        
                }
                else{   
                            

                            claimLineItemRec.Id = claimLineItemobj.Id; 
                            claimLineItemRec.Approved_Price__c =  claimLineItemobj.ApprovedPrice;
                            claimLineItemRec.Approved_Qty__c   =  claimLineItemobj.ApprovedQty;  
                            if(claimLineItemobj.ClaimedQty > claimLineItemobj.ApprovedQty ||  claimLineItemobj.ClaimedPrice >  claimLineItemobj.ApprovedPrice){
                                if( SoliToCaimVarinceLineItemMap.ContainsKey(claimLineItemobj.ServiceOrderLineItem)){
                                    claimLineItemVarRec.Id = SoliToCaimVarinceLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).Id;
                                }
                                claimLineItemVarRec.Item_Desc__c =  claimLineItemobj.Itemdesc;
                                claimLineItemVarRec.Claim__c = claimWizardObj.ClaimId;
                                claimLineItemVarRec.Approved_Qty__c   =  claimLineItemobj.ApprovedQty;  
                                claimLineItemVarRec.Approved_Price__c =  claimLineItemobj.ApprovedPrice;
                                claimLineItemVarRec.Variance_Amount__c = claimLineItemobj.ClaimedPrice -claimLineItemobj.ApprovedPrice;
                                claimLineItemVarRec.Variance_Qty__c = claimLineItemobj.ClaimedQty - claimLineItemobj.ApprovedQty;
                                claimLineItemVarRec.Is_Variance__c= true;
                                claimLineItemVarRec.Service_Order_Line_Item__c = claimLineItemobj.ServiceOrderLineItem;
                                claimLineItemVarRec.Total_Variance_Amount__c   =
                                ((claimLineItemobj.ClaimedPrice * claimLineItemobj.ClaimedQty) - (claimLineItemobj.ApprovedPrice *  ((claimLineItemobj.ApprovedQty == 0) ? 1 : claimLineItemobj.ApprovedQty)));
                                claimLineItemVarRec.Tax__c   = claimLineItemobj.Tax;
                                claimLineItemVarianceList.add(claimLineItemVarRec);
                                

                            }
                            else{
                                 if(SoliToCaimVarinceLineItemMap.containsKey(claimLineItemobj.ServiceOrderLineItem)){
                                    claimLineItemVarRecToDelete.Id = SoliToCaimVarinceLineItemMap.get(claimLineItemobj.ServiceOrderLineItem).Id;
                                    claimLineItemVarianceListToDelete.add(claimLineItemVarRecToDelete);
                                 }
                            }
                        claimLineItemList.add(claimLineItemRec);
                }
            }
        }
      
        

      
        if(claimLineItemList.size() > 0){
            upsert claimLineItemList;
        }
        
      
        if(claimLineItemVarianceList.size() > 0){
            upsert claimLineItemVarianceList;
        } 
        
        if(claimLineItemVarianceListToDelete.size() > 0){
            delete claimLineItemVarianceListToDelete;
        }
        
        List<SO_Payment_Role__c>  SoPaymentListToUpdate = ([select Id,Total_Amount__c,Tax_Amount__c ,RecordType.DeveloperName,(select Id,Approved_Qty__c,Approved_Price__c,Tax__c,
                                                            Variance_Qty__c,Variance_Amount__c,
                                                            Total_Variance_Amount__c

                                                            from Claim_Line_items__r)  From  SO_Payment_Role__c where Id IN:SoPaymentRoleToUpdateSet]);
            

       
       
        UpdateSoPaymentTotal(SoPaymentListToUpdate);
        //
        return'{}';
                
    
    }



    public Static List<So_Payment_Role__c> UpdateSoPaymentTotal(List<So_Payment_Role__c> SoPaymentListToUpdate)
    {
    	if(AccessControl.ifObjectFieldIsUpdateable('SO_Payment_Role__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	


        for(SO_Payment_Role__c SoRolePaymentRec :  SoPaymentListToUpdate){
            decimal Amount = 0.00;
            decimal Tax = 0.00; 
            if(SoRolePaymentRec.RecordType.DeveloperName == 'Third_Party' ){    
                for(Claim_Line_item__c ClaimLineItemRec :  SoRolePaymentRec.Claim_Line_items__r){
                    Amount += ClaimLineItemRec.Approved_Qty__c * ClaimLineItemRec.Approved_Price__c;
                    Tax += (ClaimLineItemRec.Approved_Qty__c * ClaimLineItemRec.Approved_Price__c) *(ClaimLineItemRec.Tax__c/100);
                    
                }


            }else if( SoRolePaymentRec.RecordType.DeveloperName == 'Customer'){
                for(Claim_Line_item__c ClaimLineItemRec :  SoRolePaymentRec.Claim_Line_items__r){
                    Amount += ClaimLineItemRec.Total_Variance_Amount__c;
                    Tax += ClaimLineItemRec.Total_Variance_Amount__c *( ClaimLineItemRec.Tax__c/100);
                }
            


            }else if(SoRolePaymentRec.RecordType.DeveloperName == 'Internal'){
                for(Claim_Line_item__c ClaimLineItemRec :  SoRolePaymentRec.Claim_Line_items__r){
                    Amount += ClaimLineItemRec.Total_Variance_Amount__c;
                    Tax += ClaimLineItemRec.Total_Variance_Amount__c *(ClaimLineItemRec.Tax__c/100);
                }
            }   


            SoRolePaymentRec.Total_Amount__c = Amount;
            SoRolePaymentRec.Tax_Amount__c = Tax;
        }
        
        if(SoPaymentListToUpdate.Size() > 0){
            update SoPaymentListToUpdate;
        }
        
        return SoPaymentListToUpdate;
    }

}