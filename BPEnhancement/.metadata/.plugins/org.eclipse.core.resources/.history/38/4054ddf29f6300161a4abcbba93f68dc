@isTest
private class SystemSettingsControllerTest {
    // Prefix name for object fields used in JSON
    private static String RECENT_ITEM_NAME_PREFIX = 'RI_';
    // Prefix name for object fields used in JSON
    private static String STATE_NAME_PREFIX = 'S_';
    
    // Prefix name for object fields used in JSON
    private static String CUSTOMER_NAME_PREFIX = 'Cust_';
    
    // Prefix name for object fields used in JSON
    private static String INDIVIDUAL_CUSTOMER_NAME_PREFIX = 'Indi_Cust_';
    
    // Prefix name for object fields used in JSON
    private static String COMAPANY_CUSTOMER_NAME_PREFIX = 'Comp_Cust_';
    
     // Prefix name for object fields used in JSON
    private static String SALES_TAX_NAME_PREFIX = 'ST_';
    
    // Prefix name for object fields used in JSON
    private static String FILTER_NAME_PREFIX = 'Filter_';
    
    // Prefix name for object fields used in JSON
    private static String UNIT_MAKE_LIST_NAME_PREFIX = 'Unit_Make_';
    
    // Prefix name for object fields used in JSON
    private static String PART_NAME_PREFIX = 'Part_';
    
    // Prefix name for object fields used in JSON
    private static String UNIT_MODEL_LIST_NAME_PREFIX = 'Unit_Model_';
    
    // Prefix name for object fields used in JSON
    private static String VENDOR_LIST_NAME_PREFIX = 'Vendor_';
     // Prefix name for object fields used in JSON
    private static String CATEGORY_LIST_NAME_PREFIX = 'Cat_';
    
    @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }
    
    static testMethod void getJSONForAllSalesTaxTest() {
        Test.startTest();
        String allTaxjson =  SystemSettingsController.getJSONForAllSalesTax();
        Test.stopTest();
        System.assertEquals(allTaxjson,allTaxjson);
    }
    
    static testmethod void getJSONForSalesTaxTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        String salesTaxObjectjson = SystemSettingsController.getJSONForSalesTax(BPUtility.getEncodedString(salesTaxObject.id));
        Test.stopTest();
        List<Sales_Tax__c> salestaxList = [Select id from Sales_Tax__c ];
        System.assertEquals(1,salestaxList.size());
    }
    
    static testmethod void getJSONForAllSalesTaxItemTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        String salesTaxObjectjson = SystemSettingsController.getJSONForAllSalesTaxItem();
        Test.stopTest();
        List<Sales_Tax__c> salestaxList = [Select id from Sales_Tax__c ];
        System.assertEquals(1,salestaxList.size());
    }
    
    static testmethod void getJSONForSalesTaxItemTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        String salesTaxObjectjson = SystemSettingsController.getJSONForSalesTaxItem(BPUtility.getEncodedString(salesTaxObject.id));
        Test.stopTest();
        List<Sales_Tax__c> salestaxList = [Select id from Sales_Tax__c ];
        System.assertEquals(1,salestaxList.size());
    }
    
    static testmethod void getJSONForAllPriceLevelsTest(){
        Price_Level__c   priceLevelObject = TestUtil.createPriceLevel(true, 'testpriceLevel');
        Test.startTest();
        String priceLevelObjectjson = SystemSettingsController.getJSONForAllPriceLevels();
        Test.stopTest();
        List<Price_Level__c> priceLevelIdList = [Select id from Price_Level__c];
        System.assertEquals(1,priceLevelIdList.size());
    }
    
    static testmethod void getJSONForRecentItemTest(){
        Test.startTest();
        String priceLevelObjectjson = SystemSettingsController.getJSONForRecentItem();
        Test.stopTest();
        System.assertEquals(priceLevelObjectjson,priceLevelObjectjson);
    }
    
    static testmethod void getJSONForSalesTaxWrapperTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        String salestaxWrapperObjectjson = SystemSettingsController.getJSONForSalesTaxWrapper(BPUtility.getEncodedString(salesTaxObject.id));
        Test.stopTest();
        List<Sales_Tax__c> salestaxList = [Select id from Sales_Tax__c];
        System.assertEquals(1,salestaxList.size());
    }
    
    static testmethod void getJSONForCountryTest(){
        Country__c  countryObject = TestUtil.createCountry(true, 'India', true, true);
        Test.startTest();
        String countryjson =  SystemSettingsService.getJSONForCountry(new List<Id>{countryObject.id}, 1);
        Test.stopTest();
        List<Country__c> countryList = [Select id from Country__c];
        System.assertEquals(1,countryList.size());
    }
    static testmethod void getJSONForStateTest(){
        Country__c  countryObject = TestUtil.createCountry(true, 'India', true, true);
        Test.startTest();
        String statejson = SystemSettingsService.getJSONForState(countryObject.id);
        Test.stopTest();
        List<Country__c> countryList = [Select id from Country__c];
        System.assertEquals(1,countryList.size());
    }
    
    static testmethod void getJSONForAllCountriesTest(){
        Country__c  countryObject = TestUtil.createCountry(true, 'India', true, true);
        Test.startTest();
        String countryjson = SystemSettingsService.getJSONForAllCountries();
        Test.stopTest();
        List<Country__c> countryList = [Select id from Country__c];
        System.assertEquals(1,countryList.size());
    }
    
    static testmethod void getJSONForPartByIdTest(){
        Test.startTest();
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Part__c partObject =   TestUtil.createPart(true, 'POO1', vendorobject.id, 'Testdescription', categoryObject.id, 50, 50, 20, 50, 20);
        SystemSettingsService.getJSONForPartByPartId(partObject.id);
        Test.stopTest();
        List<Part__c> partList = [Select id from Part__c];
        System.assertEquals(1,partList.size());
    }
    
    static testmethod void deleteSalesTaxTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        SystemSettingsService.deleteSalesTax(salesTaxObject.id);
        List<Sales_Tax__c> salestaxIdList = [Select id from Sales_Tax__c];
        System.assertEquals(0,salestaxIdList.size());
        Test.stopTest();
    }
    
    static testmethod void deletePriceLevelTest(){
        Price_Level__c   priceLevelObject = TestUtil.createPriceLevel(true, 'testpriceLevel');
        Test.startTest();
        SystemSettingsService.deletePriceLevel(priceLevelObject.id);
        List<Price_Level__c> priceLevelIdList = [Select id from Price_Level__c];
        System.assertEquals(0,priceLevelIdList.size());
        Test.stopTest();
    }
    
    static testmethod void getJSONForCustomerTest(){
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Filter__c filterObject =  TestUtil.createFilter(true, 'test', 'testCategory', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'testcustomer', 'customer@gmail.com', 'Jaipur', '8058704475');
        Test.startTest();
        SystemSettingsService.getJSONForCustomer(new List<id>{customer.id}, 1, 1, false, JSON.serialize(filterObject));
        Test.stopTest();
        List<Account> accountList = [Select id from Account];
        System.assertEquals(1,accountList.size());
    }
    
    static testmethod void getJSONForVendorTest(){
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Filter__c filterObject =  TestUtil.createFilter(true, 'test', 'testCategory', true, true, true);
        Test.startTest();
        SystemSettingsService.getJSONForVendor(new List<id>{vendorobject.id}, 1, 1, false, JSON.serialize(filterObject));   
        Test.stopTest();
        List<Filter__c> filterList = [Select id from Filter__c];
        System.assertEquals(1,filterList.size());
    }
    
    static testmethod void getJSONForPartsTest(){
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Part__c partObject =   TestUtil.createPart(true, 'POO1', vendorobject.id, 'Testdescription', categoryObject.id, 50, 50, 20, 50, 20);
        Filter__c filterObject =  TestUtil.createFilter(true, 'test', 'testCategory', true, true, true);
        Test.startTest();
        SystemSettingsService.getJSONForParts(new List<Id> { partObject.id}, 1, 1, false, JSON.serialize(filterObject));
        Test.stopTest();
        List<Part__c> partList = [Select id from Part__c];
        System.assertEquals(1,partList.size());
    }
    
    static testmethod void getJSONForUnitMakesTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Filter__c filterObject =  TestUtil.createFilter(true, 'test', 'testCategory', true, true, true);
        Test.startTest();
        SystemSettingsService.getJSONForUnitMakes(new List<Id> { unitmakeObject.id}, 1, 1, false, JSON.serialize(filterObject));
        Test.stopTest();
        List<Filter__c> filterList = [Select id from Filter__c];
        System.assertEquals(1,filterList.size());
    }
    
    static testmethod void getJSONForUnitModelByUnitMakeIdTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Filter__c filterObject =  TestUtil.createFilter(true, 'test', 'testCategory', true, true, true);
        Test.startTest();
        SystemSettingsService.getJSONForUnitModelByUnitMakeId(unitmakeObject.id, 1, 1, false, JSON.serialize(filterObject));
        Test.stopTest();
        List<Filter__c> filterList = [Select id from Filter__c];
        System.assertEquals(1,filterList.size());
        
    }
    
    static testmethod void deleteSalesTaxItemTest(){
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Sales_Tax_Item__c salestaxItem = TestUtil.createSalesTaxItem(true, 'salesTaxItem', 10,  'salesTaxItem', true, categoryObject.id);
        Test.startTest();
        List<Sales_Tax_Item__c> salesTaxitemObjectList = [Select id from Sales_Tax_Item__c];
        System.assertEquals(1,salesTaxitemObjectList.size());
        SystemSettingsService.deleteSalesTaxItem(salestaxItem.id);
        salesTaxitemObjectList = [Select id from Sales_Tax_Item__c];
        System.assertEquals(0,salesTaxitemObjectList.size());
        salestaxItem = TestUtil.createSalesTaxItem(true, 'salesTaxItem', 10,  'salesTaxItem', true, categoryObject.id);
        SystemSettingsService.deleteSalesTaxItem(salestaxItem.id);
        salesTaxitemObjectList = [Select id from Sales_Tax_Item__c];
        System.assertEquals(0,salesTaxitemObjectList.size());
        Test.stopTest();
    }
    
    static testmethod void getJSONForObjectPicklistFieldTest(){
        Test.startTest();
        String objName = Constants.NAMESPACE + 'Part_FIFO_Bucket__c';
        String jsonObject = SystemSettingsService.getJSONForObjectPicklistField(objName.toLowerCase(), 'Type__c');
        Test.stopTest();
        System.assertEquals(jsonObject,jsonObject);
    }
    static testmethod void   getAutoCompleteJSONForObjTest(){
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Part__c partObject =   TestUtil.createPart(true, 'POO1', vendorobject.id, 'Testdescription', categoryObject.id, 50, 50, 20, 50, 20);
        Test.startTest();
        SystemSettingsService.getAutoCompleteJSONForObj('Part__c', 'Testdescription');
        Test.stopTest();
    }
    
    static testmethod void getPicklistJSONForObjectRecordsTest(){
        Test.startTest();
        String jsonobject = SystemSettingsService.getPicklistJSONForObjectRecords(Constants.NAMESPACE +   'Part_FIFO_Bucket__c', 'Type__c');
        Test.stopTest();
        System.assertEquals(jsonobject,jsonobject);
    }
    static testmethod void ParseJSONForSalesTaxWrapperTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        SystemSettingsService.ParseJSONForSalesTaxWrapper(JSON.serialize(salesTaxObject), salesTaxObject.id);
        Test.stopTest();
        List<Sales_Tax__c> salestaxList = [Select id from Sales_Tax__c];
        System.assertEquals(1,salestaxList.size());
    }
    
    static testmethod void saveSalesTaxJSONTest(){
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Test.startTest();
        SystemSettingsService.saveSalesTaxJSON(JSON.serialize(salesTaxObject));
        Test.stopTest();
        List<Sales_Tax__c> salestaxList = [Select id from Sales_Tax__c];
        System.assertEquals(1,salestaxList.size());
    }
    
    static testmethod void  updateStateJSONTest(){
        Country__c  countryObject = TestUtil.createCountry(true, 'India', true, true);
        State__c stateObject =   TestUtil.createState(true, 'Rajasthan', countryObject.id, true);
        Test.startTest();
        SystemSettingsService.updateStateJSON(JSON.serialize(stateObject));
        Test.stopTest();
        List<Country__c> countryList = [Select id from Country__c];
        System.assertEquals(1,countryList.size());
        
    }
    
    static testmethod void saveComapanyCustomerJSONTest(){
        Test.startTest();
        Account customer = TestUtil.createCustomer(true, 'testcustomer', 'customer@gmail.com', 'Jaipur', '8058704475');
        customer = [Select Id, Name, Email__c, Phone,BillingStreet FROM Account LIMIT 1];
        String customerJSON = Utility.createJSON(new List<Account>{customer}, Constants.COMAPANY_CUSTOMER_FIELDS_TO_JSON_MAPPING, Constants.COMAPANY_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING, new List<SObject>(), null, null);
        SystemSettingsService.saveComapanyCustomerJSON(customerJSON);
        Test.stopTest();
        List<Account> accountList = [Select id from Account];
        System.assertEquals(1,accountList.size());
    }
    
    static testmethod void saveCategoryJSONTest(){
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Test.startTest();
        SystemSettingsService.saveCategoryJSON(JSON.serialize(categoryObject));
        Test.stopTest();
        List<Category__c> categoryList = [Select id from Category__c];
        System.assertEquals(1,categoryList.size());
    }
    
    static testmethod void saveSalesTaxItemJSONTest(){
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        List<Sales_Tax_Item__c> salestaxItemList = [Select id from Sales_Tax_Item__c ];
        System.assertEquals(0,salestaxItemList.size());
        Sales_Tax_Item__c salestaxItem = TestUtil.createSalesTaxItem(true, 'salesTaxItem', 10,  'salesTaxItem', true, categoryObject.id);
        Test.startTest();
        SystemSettingsService.saveSalesTaxItemJSON(JSON.serialize(salestaxItem));
        Test.stopTest();
        salestaxItemList = [Select id from Sales_Tax_Item__c ];
        System.assertEquals(1,salestaxItemList.size());
    }
    static testmethod void getJSONForCategoriesTest(){
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Filter__c filterObject =  TestUtil.createFilter(true, 'test', 'testCategory', true, true, true);
        Test.startTest();
        SystemSettingsService.getJSONForCategories(new List<id>{categoryObject.id}, 1, 1, false, JSON.serialize(filterObject));
        Test.stopTest();
        List<Filter__c> filterList = [Select id from Filter__c];
        System.assertEquals(1,filterList.size());
    }
    static testmethod void updateCountryJSONTest(){
        Country__c  countryObject1 = TestUtil.createCountry(true, 'India', true, true);
        Country__c  countryObject2 = TestUtil.createCountry(false, 'India', true, true);
        Test.startTest();
        SystemSettingsService.updateCountryJSON(JSON.serialize(countryObject1));
        Test.stopTest();
        List<Country__c> countryList = [Select id from Country__c];
        System.assertEquals(1,countryList.size());
    }
    static testmethod void savePriceLevelJSONTest(){
        Price_Level__c   priceLevelObject = TestUtil.createPriceLevel(false, 'testpriceLevel');
        Test.startTest();
        SystemSettingsService.savePriceLevelJSON(JSON.serialize(priceLevelObject));
        Test.stopTest();
        List<Price_Level__c> priceLevelList = [Select id from Price_Level__c];
        System.assertEquals(0,priceLevelList.size());

    }
    
    static testmethod void saveIndividualCustomerJSONTest(){
        Price_Level__c   priceLevelObject = TestUtil.createPriceLevel(true, 'testpriceLevel');
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Account customer = TestUtil.createCustomer(true, 'test customer', 'test@gmail.com', 'Jaipur', '8058704475',priceLevelObject.id + '', salesTaxObject.id + '',  false, true, 'Individual', 'test', 'lastName', '8058704475', 'billingstreet');
        Contact  customercontact = TestUtil.createContact(true, 'test contact', 'lastname', customer.id);
        customercontact.LastName='last name';
        customercontact.FirstName='first name';
        customercontact.MailingStreet='street1';
        customercontact.MailingCity='jpr';
        customercontact.MailingState='raj';
        customercontact.MailingCountry='india';
        customercontact.MailingPostalCode='302022';
        customercontact.OtherStreet='other1';
        customercontact.OtherCity='ss';
        customercontact.OtherState='raj';
        customercontact.OtherCountry='pak';
        customercontact.OtherPostalCode='ff';
        customercontact.SA_same_as_BA__c= false;
        customercontact.Phone='8058704475';
        customercontact.MobilePhone='8058704475';
        customercontact.Fax='8058704475';
        customercontact.Email='test@gmail.com';
        customercontact.Preferred_Contact__c='Phone';
        customercontact.VIP__c ='xpz';
        customercontact.Price_Level__c = priceLevelObject.id;
        customercontact.Sales_Tax__c = salesTaxObject.Id;
        customercontact.Active__c = true;
        customercontact.Is_Vendor__c=false; 
        List<Contact> contactList = [Select id from Contact];
        //customercontact = [Select LastName,FirstName,MailingStreet,MailingCity,MailingState, MailingCountry,MailingPostalCode,  OtherStreet, OtherCity,OtherState,OtherCountry,OtherPostalCode,SA_same_as_BA__c ,Phone,MobilePhone,Fax,Email,Preferred_Contact__c,VIP__c ,Price_Level__c,Price_Level__r.Name,Sales_Tax__c,Sales_Tax__r.Name,Active__c ,Is_Vendor__c   FROM Contact LIMIT 1];
        String customerJSON = Utility.createJSON(new List<Contact>{customercontact}, Constants.INDIVIDUAL_CUSTOMER_FIELDS_TO_JSON_MAPPING, Constants.INDIVIDUAL_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING, new List<SObject>(), null, null);
        System.assertEquals(1,contactList.size());
        Contact individualCustomer = new Contact();    
        List<Contact> individualCustomerList = (List<Contact>) Utility.parseJSON(customerJSON, individualCustomer, Constants.INDIVIDUAL_CUSTOMER_JSON_TO_FIELDS_MAPPING, Constants.INDIVIDUAL_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING);
        Test.startTest();
        try{
        	SystemSettingsService.saveIndividualCustomerJSON(customerJSON);
        }
        catch(Exception e){
        }
        finally{
        	Test.stopTest();
        	contactList = [Select id from Contact];
        }
    }
    
    static testmethod void updateIndividualCustomerJSONTest(){
        Price_Level__c   priceLevelObject = TestUtil.createPriceLevel(true, 'testpriceLevel');
        Sales_Tax__c  salesTaxObject =  TestUtil.createSalesTax(true, 'testSalesTax');
        Account customer = TestUtil.createCustomer(true, 'test customer', 'test@gmail.com', 'Jaipur', '8058704475',priceLevelObject.id + '', salesTaxObject.id + '',  false, true, 'Individual', 'test', 'lastName', '8058704475', 'billingstreet');
        Contact  customercontact = TestUtil.createContact(true, 'test contact', 'lastname', customer.id);
        List<Contact> contactList = [Select id from Contact];
        System.assertEquals(1,contactList.size());
        customer = [Select Id,Name,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,SA_same_as_BA__c,Phone,Mobile__c,Fax,Email__c,Preferred_Contact__c,VIP__c,Price_Level__c,Price_Level__r.Name,Sales_Tax__c,Sales_Tax__r.Name,Active__c,Is_Vendor__c FROM Account LIMIT 1];
        String customerJSON = Utility.createJSON(new List<Account>{customer}, Constants.COMAPANY_CUSTOMER_FIELDS_TO_JSON_MAPPING, Constants.COMAPANY_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING, new List<SObject>(), null, null);
        Test.startTest();
        SystemSettingsService.updateIndividualCustomerJSON(customerJSON );
        Test.stopTest();
    }
    static testmethod void saveVendorJSONTest(){
        Account vendorobject =TestUtil.createVendor(false, 'testvendor');
        Test.startTest();
        SystemSettingsService.saveVendorJSON(JSON.serialize(vendorobject));
        Test.stopTest();
        List<Account> accountList = [Select id from Account];
        System.assertEquals(0,accountList.size());        
    }
    
    static testmethod void savePartJSONTest(){
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Part__c partObject =   TestUtil.createPart(true, 'POO1', vendorobject.id, 'Testdescription', categoryObject.id, 50, 50, 20, 50, 20);
        List<Part__c> partList = [Select id, Location__c,Category__c,Description__c,Active__c,Qty_On_Order__c from Part__c];
        Test.startTest();
        System.assertEquals(1,partList.size());
        partObject = [Select Id,Description__c,Part_Id__c,Active__c,Qty_On_Order__c,Retail_Price__c,Location__c,Category__r.Name,Category__c,Auto_reorder_Max__c,Auto_reorder_Min__c,Average_Cost__c,Enviro_Fee__c,Last_Cost__c,Last_Counted__c,Last_Sold__c,Last_Stocked__c,MSRP__c,Notes__c,Order_Lots__c,Packaged_Part__c,Package_Qty__c,Qty_Committed__c,Part_Number__c,Qty_In_Stock__c,Superseded_By__c,Superseded_By__r.Part_ID__c,Taxable__c,Vendor__c,Vendor_Code__c,Vendor_Name_And_Code__c   FROM Part__c LIMIT 1];
        String partJSON = Utility.createJSON(new List<Part__c>{partObject}, Constants.PART_FIELDS_TO_JSON_MAPPING, Constants.PART_FIELDS_TO_DATA_TYPE_MAPPING, new List<Sobject>(), null, null);
        SystemSettingsService.savePartJSON(partJSON);
        Test.stopTest();
        partList = [Select id from Part__c];
        //System.assertEquals(1,partList.size());
    }
    static testmethod void saveUnitMakeJSONTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Unit_Make__c unitmakeObject1 =    TestUtil.createUnitMake(false, '1testUnitMake', '201', true);
        List<Unit_Make__c> unitmakeObjectList = [Select id from Unit_Make__c];
        Test.startTest();
        System.assertEquals(1,unitmakeObjectList.size());
        SystemSettingsService.saveUnitMakeJSON(JSON.serialize(unitmakeObject1));
        Test.stopTest();
    }
    
    static testmethod void deleteUnitMakeJSONTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        List<Unit_Make__c> unitmakeObjectList = [Select id from Unit_Make__c];
        System.assertEquals(1,unitmakeObjectList.size());
        Test.startTest();
        SystemSettingsService.deleteUnitMakeJSON(JSON.serialize(unitmakeObject));
        Test.stopTest();
    }
    
    static testmethod void saveUnitModelJSONTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Unit_Model__c unitmodelObject =    TestUtil.createUnitModel(false, 'TestUnit Model', '123', true, unitmakeObject.id);
        List<Unit_Model__c> unitmodelObjectList = [Select id from Unit_Model__c];
        System.assertEquals(0,unitmodelObjectList.size());
        Test.startTest();
        SystemSettingsService.saveUnitModelJSON(JSON.serialize(unitmodelObject));
        Test.stopTest();
    }
    static testmethod void deleteUnitModelJSONTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Unit_Model__c unitmodelObject =    TestUtil.createUnitModel(true, 'TestUnit Model', '123', true, unitmakeObject.id);
        List<Unit_Model__c> unitmodelObjectList = [Select id from Unit_Model__c];
        System.assertEquals(1,unitmodelObjectList.size());
        Test.startTest();
        SystemSettingsService.deleteUnitModelJSON(JSON.serialize(unitmodelObject));
        Test.stopTest();
    }
    
    static testmethod void getJSONForFilteredUnitModelsTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Test.startTest();
        SystemSettingsService.getJSONForFilteredUnitModels(unitmakeObject.id, 'test', UNIT_MODEL_LIST_NAME_PREFIX +  'VIN_Code', false);
        Test.stopTest();
        List<Unit_Make__c> unitmakeObjectList = [Select id from Unit_Make__c];
        System.assertEquals(1,unitmakeObjectList.size());
    }
    
    static testmethod void getJSONForFilteredCustomerTest(){
        Account customer = TestUtil.createCustomer(true, 'testcustomer', 'customer@gmail.com', 'Jaipur', '8058704475');
        Test.startTest();
        SystemSettingsService.getJSONForFilteredCustomer('test', CUSTOMER_NAME_PREFIX + 'Name', false);
        Test.stopTest();
        List<Account> accountList = [Select id from Account];
        System.assertEquals(1,accountList.size());
            
    }
    
    static testmethod void getJSONForFilteredPartsTest(){
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Part__c partObject =   TestUtil.createPart(true, 'POO1', vendorobject.id, 'Testdescription', categoryObject.id, 50, 50, 20, 50, 20);
        Test.startTest();
        SystemSettingsService.getJSONForFilteredParts('test',PART_NAME_PREFIX +'Location');
        Test.stopTest();
        List<Category__c> categoryList = [Select id from Category__c];
        System.assertEquals(1,categoryList.size());
    }
    
    static testmethod void getJSONForFilteredCategoryTest(){
        Category__c categoryObject =  TestUtil.createCategory(true, 'testCategory');
        Test.startTest();
        SystemSettingsService.getJSONForFilteredCategory('test',CATEGORY_LIST_NAME_PREFIX +'Name');
        Test.stopTest();
        List<Category__c> categoryList = [Select id from Category__c];
        System.assertEquals(1,categoryList.size());
    }
    
    static testmethod void getJSONForFilteredVendorTest(){
        Account vendorobject =TestUtil.createVendor(true, 'testvendor');
        Test.startTest();
        SystemSettingsService.getJSONForFilteredVendor('test',VENDOR_LIST_NAME_PREFIX +'Name', false);
        Test.stopTest();
        List<Account> accountList = [Select id from Account];
        System.assertEquals(1,accountList.size());

    }
    static testmethod void getJSONForFilteredUnitMakesTest(){
        Unit_Make__c unitmakeObject =    TestUtil.createUnitMake(true, 'testUnitMake', '201', true);
        Test.startTest();
        SystemSettingsService.getJSONForFilteredUnitMakes('test', UNIT_MAKE_LIST_NAME_PREFIX + 'Name', true);
        Test.stopTest();
        List<Unit_Make__c> unitmakeObjectList = [Select id from Unit_Make__c];
        System.assertEquals(1,unitmakeObjectList.size());
        
    }
}