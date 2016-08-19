/**
 * Author: Tarun Khandelwal
 * Since: 
 * Name: ConfigurationScript
 * Description: Apex class to delete all default data in org
**/
global without sharing class ConfigurationScript {
    public static boolean isPostInstallRunning = false;
     global static void runAll() {
         isPostInstallRunning = true;
        //deleteNativeRecords();
       // deleteConfigurations();
        createConfigurations();
        createWidgets();
        createGlAccount();
        createAccountingDataMigration();
        createTransactionTypes();
        createUserDependentFeature();
     }
     
    /**
     * Name: deleteNativeRecords
     * Desc: Method to delete all default data in salesforce org
     * @param:  
     * @return: 
    **/
    global static void deleteNativeRecords()  {
        List<String> objNamesList = new List<String>{'Lead', 'Case', 'Contact', 'Opportunity', 'Account'};
        
        if(AccessControl.ifObjectFieldIsAccessible(objNamesList) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectIsDeletable(objNamesList) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        
        List<sobject> sobjectList =  new List<sobject>();
        List<sobject> leadList = [select id from Lead LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
        sobjectList.addAll(leadList);
        List<sobject> caseList = [select id from Case LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
        sobjectList.addAll(caseList);
        List<sobject> contactList = [select id from Contact LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
        sobjectList.addAll(contactList);
        List<sobject> opportunityList = [select id from Opportunity LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
        sobjectList.addAll(opportunityList);
        List<sobject> accountList = [Select Id from Account LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
        sobjectList.addAll(accountList);
        
        if(sobjectList.size() > 0) {
            delete sobjectList ;
        }
    }  
    
    /**
     * Name: deleteConfigurations
     * Desc: Method to configure custom default settings
     * @param:  
     * @return: 
    **/
    global static void deleteConfigurations() {
        isPostInstallRunning = true;
        List<String> objNamesList = new List<String>{'General_Configurations__c', 'Configurations__c', 'SearchConfigurations__c', 'Australian_Market__c'};
        if(AccessControl.ifObjectFieldIsAccessible(objNamesList) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectIsDeletable(objNamesList) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        
        List<Configurations__c> config = [Select Id from Configurations__c where Sent_From_Email_Id__c != null];
        if(config.size() > 0) {
            delete config ;
        }
        
        List<General_Configurations__c> genConfig = [Select Id from General_Configurations__c where Home_Search_Grid_Page_Size__c != null];
        if(genConfig.size() > 0) {
            delete genConfig ;
        }
        
        List<SearchConfigurations__c> searchConfig = [Select Id from SearchConfigurations__c where Name != null];
        if(searchConfig.size() > 0) {
            delete searchConfig ;
        }
        
        List<Australian_Market__c> ausMarket = [Select Id from Australian_Market__c where Sales_Tax_Rate__c != null];
        if(ausMarket.size() > 0) {
            delete ausMarket ;
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Reporting__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectIsDeletable('Reporting__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Reporting__c> emailReport = [Select Id from Reporting__c where Reporting_Objects__c != null];
        if(emailReport.size() > 0) {
            delete emailReport ;
        }
    }
    
    /**
     * Name: createConfigurations
     * Desc: Method to configure custom default settings
     * @param:  
     * @return: 
    **/
    global static void createConfigurations() {
        isPostInstallRunning = true;
        List<String> objNamesList = new List<String>{'General_Configurations__c', 'Configurations__c', 'SearchConfigurations__c', 'Australian_Market__c','Reporting__c'};
        if(AccessControl.ifObjectFieldIsCreateable(objNamesList) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        if(AccessControl.ifObjectFieldIsUpdateable(objNamesList) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        
        Configurations__c config = Configurations__c.getOrgDefaults();
        config.SearchMinCharLength__c = 2;
        config.Sent_From_Email_Id__c = 'ashish.garg@metacube.com';
        config.NumberOfCustomersRecordPageSize__c = 20;
        upsert config ;
        
        General_Configurations__c generalConfig = General_Configurations__c.getOrgDefaults();
        generalConfig.Load_New_Customer_Order__c =  true ;
        generalConfig.Load_New_View_Customer__c = true;
        generalConfig.Home_Search_Grid_Page_Size__c = 50;
        generalConfig.Load_New_UI__c = true;
        generalConfig.Related_List_Page_Size__c = 25 ;
        upsert generalConfig ;
        
        String nameSpace = PostInstallClass.NAMESPACE;
        
        List<SearchConfigurations__c> searchConfigList = new List<SearchConfigurations__c>();
        searchConfigList.add(insertSearchConfigurationRecords('Customer', 'Name', '', 'Customer', 1, 'Name'));
        searchConfigList.add(insertSearchConfigurationRecords('Vendor', 'Name', '', 'Vendor', 2, 'Name'));
        searchConfigList.add(insertSearchConfigurationRecords('User', 'Name', '', 'User', 3, 'Name'));
        searchConfigList.add(insertSearchConfigurationRecords('Part__c', 'Part_Id__c', '{Description__c}', nameSpace + 'Part__c', 4, 'Part_Number__c,Description__c,Part_Id__c, Qty_In_Stock__c, Qty_Committed__c, Retail_Price__c, Name, Vendor__c'));
        searchConfigList.add(insertSearchConfigurationRecords('Category__c', 'Name', '', nameSpace + 'Category__c', 5, 'Name'));
        searchConfigList.add(insertSearchConfigurationRecords('Sales_Tax_Item__c', 'Name__c', '', nameSpace + 'Sales_Tax_Item__c', 6, 'Name__c'));
        searchConfigList.add(insertSearchConfigurationRecords('Labour','Name__c', '', nameSpace + 'Labour_Code__c', 7, 'Name__c, Name, Description__c, Code__c'));
        searchConfigList.add(insertSearchConfigurationRecords('Kit Header', 'Kit_Unique_Name__c', '', nameSpace + 'Kit_Header__c', 8, 'Name, Description__c, Kit_Unique_Name__c, Code__c,Service_Kit__c'));
        searchConfigList.add(insertSearchConfigurationRecords('Fee', 'Fee_Unique_Name__c', '', nameSpace + 'Fee__c', 9, 'Name, Description__c, Fee_Unique_Name__c, Code__c'));
        upsert searchConfigList;
        
        Australian_Market__c ausMarket = Australian_Market__c.getOrgDefaults();
        ausMarket.Sales_Tax_Rate__c = 10;
        upsert ausMarket;
        
        Reporting__c reportingObj = Reporting__c.getOrgDefaults();
        reportingObj.Is_Reporting__c =  true;
        reportingObj.Receipient_Email__c = 'Keith.obrien@blackpurl.com;cathyp@dealervu.com;briank@dealervu.com;markb@dealervu.com;shantanu.sharma@metacube.com;ashish.garg@metacube.com';
        reportingObj.Reporting_Objects__c = 'Customer;Vendor;CO_Header__c;Part__c;Vendor_Order_Header__c';
        upsert reportingObj;
        
    }
    
    /**
     * Name: insertSearchConfigurationRecords
     * Desc: Method to insert search configuration record
     * @param:      (1) name - record name
     *              (2) displayFieldForAutoComplete - Display Field For Auto Complete
     *              (3) displayInfo -  Display Information String
     *              (4) objectName - Object Name
     *              (5) Order - Order Number
     *              (6) searchableFieldForAutoComplete - Search Field For Auto Complete
     * @return: SearchConfigurations__c record
    **/
    private static SearchConfigurations__c insertSearchConfigurationRecords(String name, String displayFieldForAutoComplete, String displayInfo, String objectName, Integer Order, String searchableFieldForAutoComplete ) {
        SearchConfigurations__c searchConfig = new SearchConfigurations__c();
        searchConfig.Name = name;
        searchConfig.Display_Field__c = displayFieldForAutoComplete;
        searchConfig.Display_Info__c = displayInfo;
        searchConfig.Object_Name__c = objectName;
        searchConfig.Order__c = Order;
        searchConfig.Searchable_Field__c = searchableFieldForAutoComplete;    
        return searchConfig;
    } 
    
    /**
     * Name: createWidgets
     * Desc: Method to create widget records
     * @param:  
     * @return: 
    **/
    global static void createWidgets() {
        if(AccessControl.ifObjectFieldIsCreateable('Widget__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        
        List<Widget__c> widgetList  = new List<Widget__c>();
        widgetList.add(insertWidget(1, 'Selling'));
        widgetList.add(insertWidget(2, 'Ordering'));
        widgetList.add(insertWidget(3, 'MyProfile'));
        widgetList.add(insertWidget(4, 'Tasks'));
        widgetList.add(insertWidget(5, 'Actions'));
        widgetList.add(insertWidget(6, 'Chatter'));
        widgetList.add(insertWidget(7, 'News'));
        widgetList.add(insertWidget(8, 'Alerts'));
        insert widgetList;
    }
    
     /**
     * Name: insertWidget
     * Desc: Method to insert widget record
     * @param:      (1) orderNumber - Order Number
     *              (2) widgetName - Widget Name
     * @return: Widget__c record
    **/
    private static Widget__c insertWidget(Integer orderNumber, String widgetName) {
        Widget__c widgetRec = new Widget__c();
        widgetRec.Order_Number__c = orderNumber;
        widgetRec.Widget_Name__c = widgetName;
        return widgetRec;
        
    }
    
    /**
     * Name: createTransactionTypes
     * Desc: Method to create Transaction Type records
     * @param:  
     * @return: 
    **/
    global static void createTransactionTypes() {
        if(AccessControl.ifObjectFieldIsCreateable('Transaction_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        
        List<Transaction_Type__c> ttList  = new List<Transaction_Type__c>();
        ttList.add(new Transaction_Type__c(Code__c = 'Customer Pay', Type__c = 'Customer'));
        ttList.add(new Transaction_Type__c(Code__c = 'Warranty', Type__c = 'Third-Party'));
        ttList.add(new Transaction_Type__c(Code__c = 'Internal', Type__c = 'Internal'));
        
        insert ttList;
    }
    
    
    global static void createGlAccount(){
        if(AccessControl.ifObjectFieldIsCreateable('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        List<GL_Account__c> GLAccountList =  new List<GL_Account__c>();
        GLAccountList.add(new GL_Account__c(MYOB_Account_Name__c =  'A/P Accrual - Inventory', MYOB_Account_Number__c = '2-1530',  Type__c = 'Received Inventory Accrual'));
        GLAccountList.add(new GL_Account__c(MYOB_Account_Name__c =  'BP Customer Deposits', MYOB_Account_Number__c = '1-1250',  Type__c = 'Deposit Allocation Account'));
        GLAccountList.add( new GL_Account__c(MYOB_Account_Name__c =  'Other Income', MYOB_Account_Number__c = '4-4200',  Type__c = '    Sales Invoice Account'));
        GLAccountList.add( new GL_Account__c(MYOB_Account_Name__c =  'Undeposited Funds Account', MYOB_Account_Number__c = '1-1210',  Type__c = 'Deposit Account'));
            
        insert GLAccountList;
    }
    
    
    global static void createAccountingDataMigration(){
        if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        List<Accounting_Data_Migration__c> AccountingDataMigrationList =  new List<Accounting_Data_Migration__c>();
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'Customers Card', MYOB_Object_Name__c = 'Customer Cards'));
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'ReceiveMoneyTxn_Deposit', MYOB_Object_Name__c = 'Receive Money'));
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'ReceiveMoneyTxn_Payment', MYOB_Object_Name__c ='Receive Money'));
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'Customer Order Sales Invoices', MYOB_Object_Name__c ='Sales - Miscellaneous Sales, Receive Payments, General Journal Entries'));
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'Supplier Card', MYOB_Object_Name__c ='Supplier Cards'));
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'General Journal Entries', MYOB_Object_Name__c ='General Journal Entries'));
        AccountingDataMigrationList.add( new Accounting_Data_Migration__c(Object_Name__c = 'Vendor Invoicing', MYOB_Object_Name__c = 'Purchases - Miscellaneous Purchases'));
        
        insert AccountingDataMigrationList;
    }
    
    
    global static void createUserDependentFeature(){
        if(AccessControl.ifObjectFieldIsAccessible('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<User> userRecList =  [SELECT Id From User limit: SOQLUtil.getAvailableQueryRowsLimit()];
        List<Id> userIdList =  new List<Id>();
        for(User userRec : userRecList) {
            userIdList.add(userRec.Id);
        }
        UserTriggerHelper.createWidgetJunction(userIdList);
        UserTriggerHelper.createFilters(userIdList);
    }
    
}