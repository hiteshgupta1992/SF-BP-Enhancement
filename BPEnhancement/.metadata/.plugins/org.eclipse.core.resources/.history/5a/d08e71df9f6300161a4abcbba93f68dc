/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 // Used In Kendo.
@isTest
private class BlackPurlContentCtrlTest {
	
	@testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
	
	/**
     * Name: mainFunctionalityTest
     * Desc: Testing the main functionality of controller
     * @param: 
     * @return: 
    **/
    static testMethod void mainFunctionalityTest() {
        
        // Insert Data
        Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, true, true);
        Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Testing Sales Tax 2', true, false, true);
        Sales_Tax__c salesTax3 = TestUtil.createSalesTax(true, 'Testing Sales Tax 3'); 
        
        Category__c category1 = TestUtil.createCategory(true, 'Testing Category 1');
        
        Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 1', 10, 'Testing Form Label 1', true, category1.Id);
        Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 2', 15, 'Testing Form Label 2', true, null);
        Sales_Tax_Item__c salesTaxItem3 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 3');
        
        
        Price_Level__c priceLevel1 = TestUtil.createPriceLevel(true, 'Test Price Level 1', 'Cost', true, true);
        Price_Level__c priceLevel2 = TestUtil.createPriceLevel(true, 'Test Price Level 2', 'Price', false, true);
        Price_Level__c priceLevel3 = TestUtil.createPriceLevel(true, 'Test Price Level 3');
        Price_Level__c priceLevel4 = TestUtil.createPriceLevel(true, 'Test Price Level 4', 'Cost');
        
        Applicable_Taxes__c applicableTax = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem1.Id); 
        
        
        
        // Create Instance of class
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
         
        // Call Methods
        bpContentCtrl.setDisplaySystemWideSettings();
        bpContentCtrl.selectedSWSLink = 'Price Levels';
        bpContentCtrl.initDisplaySWSContent();
        bpContentCtrl.setDisplayDefaultsANDCustomization();
        bpContentCtrl.setDisplaySecurityANDPermission();
        bpContentCtrl.setDisplayTools();
        bpContentCtrl.setDisplaySystemWideSettings();
        bpContentCtrl.selectedSWSLink = 'Sales Taxes';
        bpContentCtrl.initDisplaySWSContent();
        bpContentCtrl.selectedSWSLink = 'Country & State/Province';
        bpContentCtrl.initDisplaySWSContent();
        
        String salesTaxJSON = BlackPurlContentCtrl.getJSONForAllSalesTax();
        system.assertEquals(true, salesTaxJSON.length() > 0);
        
        String salesTaxItemJSON = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForSalesTaxWrapper(BPUtility.getEncodedString(String.valueOf(salesTax1.Id))));
        system.assertEquals(true, salesTaxItemJSON.length() > 0);
        
        
        String priceLevelJSON = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForAllPriceLevels());
        system.assertEquals(true, priceLevelJSON.length() > 0);
        
        BlackPurlContentCtrl.deleteSalesTax(BPUtility.getEncodedString(salesTax2.Id));
        List<Sales_Tax__c> currentSalesTaxList = [select Id, Name__c from Sales_Tax__c limit 100];
        system.assertEquals(2, currentSalesTaxList.size());
        
        BlackPurlContentCtrl.deleteSalesTaxItem(BPUtility.getEncodedString(salesTaxItem2.Id));
        List<Sales_Tax_Item__c> currentSalesTaxItemList = [select Id, Name__c from Sales_Tax_Item__c limit 100];
        system.assertEquals(2, currentSalesTaxItemList.size());
        
        BlackPurlContentCtrl.deletePriceLevel(BPUtility.getEncodedString(priceLevel2.Id));
        List<Price_Level__c> currentPriceLevelList = [select Id, Name__c from Price_Level__c limit 100];
        system.assertEquals(3, currentPriceLevelList.size());
        
        
        BlackPurlContentCtrl.saveSalesTaxJSON(BPUtility.getEncodedString(generateTestJSON('ST_')));
        currentSalesTaxList = [select Id, Name__c from Sales_Tax__c limit 100];
        system.assertEquals(3, currentSalesTaxList.size());
        
        BlackPurlContentCtrl.savePriceLevelJSON(BPUtility.getEncodedString(generateTestJSON('PL_')));
        currentPriceLevelList = [select Id, Name__c from Price_Level__c limit 100];
        system.assertEquals(4, currentPriceLevelList.size());
        
        salesTaxItemJSON = SystemSettingsService.getJSONForSalesTaxItem(new List<Id>());
        system.assertEquals(true, salesTaxItemJSON.length() > 0);
        
        String recentItemsJSON = SystemSettingsService.getJSONForRecentItem();
        system.assertEquals(true, recentItemsJSON.length() > 0);
        
        
        BlackPurlContentCtrl.saveSalesTaxItemJSON(BlackPurlContentCtrl.getJSONForSalesTaxWrapper(BPUtility.getEncodedString(salesTax1.Id)));
        
       
        Utility.createJSON(SOQLUtil.getSalesTax(new List<Id>{salesTax1.Id}), Constants.SALES_TAX_FIELDS_TO_JSON_MAPPING, Constants.SALES_TAX_FIELDS_TO_DATA_TYPE_MAPPING, 
                                SOQLUtil.getSalesTaxItems(new List<Id>{salesTaxItem1.Id}), Constants.SALES_TAX_ITEM_FIELDS_TO_JSON_MAPPING, Constants.SALES_TAX_ITEM_FIELDS_TO_DATA_TYPE_MAPPING);
        
        String priceBookPickListValueJSON = BPUtility.getDecodedString(BlackPurlContentCtrl.getPriceLevelPriceBookPicklistValues());
        system.assertEquals(true, priceBookPickListValueJSON.length() > 0);
        
        SOQLUtil.removeApplicableTax(String.valueOf(salesTax1.Id), String.valueOf(salesTaxItem1.Id));
    }
        
   /**
     * Name: countryStateFunctionalityTest
     * Desc: Testing of country State functionality
     * @param: 
     * @return: 
    **/
   	static testMethod void countryStateFunctionalityTest() {
   		
   		// Create Instance of class
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
   		
   		Country__c country1 = TestUtil.createCountry(true, 'Test Country 1', true, true);
        Country__c country2 = TestUtil.createCountry(true, 'Test Country 2', true, false);
        
        State__c state1 = TestUtil.createState(true, 'Test State 1', country1.Id, true);
        State__c state2 = TestUtil.createState(true, 'Test State 2', country1.Id, false);
        
        String countryJSON = BlackPurlContentCtrl.generateJSONForCountries(null);
        system.assertEquals(true, countryJSON.length() > 0);
        
        String stateJSON = BlackPurlContentCtrl.getJSONForStateByCountry(BPUtility.getEncodedString(country1.Id));
        system.assertEquals(true, stateJSON.length() > 0);
        
        String moreCountryJSON = BlackPurlContentCtrl.increaseCountries(1);
        system.assertEquals(true, moreCountryJSON.length() > 0);
        
        moreCountryJSON = BlackPurlContentCtrl.increaseCountries(1);
        system.assertEquals(true, moreCountryJSON.length() > 0);
        
        String categoryName = BPUtility.getDecodedString(BlackPurlContentCtrl.getCategoryPicklistValues());
        system.assertEquals(true, categoryName.length() > 0);
        
        BlackPurlContentCtrl.saveCountryJSON(BPUtility.getEncodedString(generateTestJSONForCountry(country2.Id)));
        List<Country__c> updatedCountry = [select Name__c from Country__c where Name__c = 'Test Country'];
        system.assertEquals(updatedCountry.size(), 1);
        
        BlackPurlContentCtrl.saveStateJSON(BPUtility.getEncodedString(generateTestJSONForState(country1.Id, state1.Id)));
        List<State__c> updatedState = [select Name__c from State__c where Name__c = 'Test State'];
        system.assertEquals(updatedState.size(), 1);
    }
    
    /**
     * Name: customerFunctionalityTest
     * Desc: Testing of customer functionality
     * @param: 
     * @return: 
    **/
    /*
   	static testMethod void customerFunctionalityTest() {
   		// Create Instance of class
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
        
        List<Account> customerListToBeInsert = new List<Account>();
        for(Integer counter = 0; counter < 20 ; counter++) {
        	Account customer = new Account();
        	customer.Name = 'Testing Customer ' + counter;
        	customerListToBeInsert.add(customer);
        }
        insert customerListToBeInsert;
        
        
        Account customer1 = TestUtil.createCustomer(true, 'Test Customer 1', 'test1@gmail.com', 'Jaipur', '1800111265');
        Account customer2 = TestUtil.createCustomer(true, 'Test Customer 2', 'test2@gmail.com', 'Kota', '18001112365');
        Account customer3 = TestUtil.createCustomer(true, 'Test Customer 3', 'test3@gmail.com', 'Chennai', '1800111266');
        Account customer4 = TestUtil.createCustomer(true, 'Test Customer 4', 'test4@gmail.com', 'Kolkata', '1800111255');
        Account customer5 = TestUtil.createCustomer(true, 'Test Customer 5', 'test5@gmail.com', 'Jodhpur', '1800111275');
        Account customer6 = TestUtil.createCustomer(true, 'Test Customer 6', 'test6@gmail.com', 'Jaipur', '1800111285');
        
        
        bpContentCtrl.displayCustomers = true;
        bpContentCtrl.initDisplayCustomers();
        
        BlackPurlContentCtrl.dropDownSelectedNumber = null;
        Configurations__c config = Configurations__c.getInstance();
        
        config.NumberOfCustomersRecordPageSize__c = 0;
        insert config;
        System.assertEquals(BlackPurlContentCtrl.currentNoOfCustomerByCustomSetting, 20);
        
        config.NumberOfCustomersRecordPageSize__c = 101;
        update config;
        System.assertEquals(BlackPurlContentCtrl.currentNoOfCustomerByCustomSetting, 100);
        
        BlackPurlContentCtrl.dropDownSelectedNumber = 20;
        bpContentCtrl.setCustomerCustomSetting();
        
        String customerJSONString = BlackPurlContentCtrl.getJSONForAllCustomer(21, 20, true, '[]');
        system.assertEquals(customerJSONString.length() > 0, true);
        
        //String incresedCustJSON = BlackPurlContentCtrl.increaseCustomer(21, 20, true, '[]');
        //system.assertEquals(incresedCustJSON.length() > 0, true);
        
        BlackPurlContentCtrl.selectedCustomerId = customer1.Id;
        BlackPurlContentCtrl.createRecentCustomerRecord();
        
        String filteredCustomer = BlackPurlContentCtrl.getJSONForFilteredCustomer('Test', 'Cust_Name', true);
        system.assertEquals(filteredCustomer.length() > 0, true);
        
        filteredCustomer = BlackPurlContentCtrl.getJSONForFilteredCustomer('Jaipur', 'Cust_BillingCity', true);
        system.assertEquals(filteredCustomer.length() > 0, true);
        
        String singleCustomerJSON = generateTestJSONForCustomer(customer1.Id, 'Business');
        BlackPurlContentCtrl.saveCustomerJSON(customer1.Id, 'Business', singleCustomerJSON);
        List<Account> customers = [select Id from Account];
        system.assertEquals(customers.size(), 26);
        
        Contact indiCustomer = TestUtil.createIndividaulCustomer(true, 'Test Indi Cust');
        Account indiRelatedCustomer = [select Id from Account where Name = 'null Test Indi Cust'];
        
        singleCustomerJSON = generateTestJSONForCustomer(indiRelatedCustomer.Id, 'Business');
        BlackPurlContentCtrl.saveCustomerJSON(indiRelatedCustomer.Id, 'Individual', singleCustomerJSON);
        customers = [select Id from Account];
        system.assertEquals(customers.size(), 27);
        
        String newIndiCustomerJSON = generateTestJSONForCustomer(null, 'Individual');
        BlackPurlContentCtrl.saveCustomerJSON(null, 'Individual', newIndiCustomerJSON);
        List<Contact> allIndiCustomers = [select Id from Contact];
        system.assertEquals(allIndiCustomers.size(), 2);
    }
    */
    /**
     * Name: partFunctionalityTest
     * Desc: Testing of part functionality
     * @param: 
     * @return: 
    **/
   	static testMethod void partFunctionalityTest() {
    	Account vendor = TestUtil.createVendor(true, 'First Vendor ');
        Category__c testCategory = TestUtil.createCategory(true, 'Testing Category');
        
        Test.startTest();
        Part__c testPart1 = TestUtil.createPart(true, '1452369', vendor.Id, 'Test Desc', testCategory.Id);
        Part__c testPart2 = TestUtil.createPart(true, '1452369ds', vendor.Id, 'Test Desc', testCategory.Id);
        Part__c testPart3 = TestUtil.createPart(true, '145236s', vendor.Id, 'Test Desc', testCategory.Id);
        
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
        bpContentCtrl.displayParts = true;
        bpContentCtrl.initDisplayParts();
        bpContentCtrl.setCustomerCustomSetting();
        BlackPurlContentCtrl.dropDownSelectedNumber = 20;
        bpContentCtrl.setCustomerCustomSetting();
        
        String allPartsJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForParts(22, 20, true, BPUtility.getEncodedString('[]')));
        system.assertEquals(allPartsJSONString.length() > 0, true);
        
        String partJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForPartByPartId(BPUtility.getEncodedString(testPart1.Id)));
        system.assertEquals(partJSONString.length() > 0, true);
        
        partJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.increaseParts(20, 20, false, BPUtility.getEncodedString('[]')));
        system.assertEquals(partJSONString.length() > 0, true);
        
        BlackPurlContentCtrl.selectedPartId = testPart2.Id;
        BlackPurlContentCtrl.createRecentPartRecord();
        
        List<Recent_Part__c> recentParts = [select Id from Recent_Part__c limit 100];
        //system.assertEquals(recentParts.size(), 3);
    }
    
    /**
     * Name: categoryFunctionalityTest
     * Desc: Testing of Category functionality
     * @param: 
     * @return: 
    **/
   	static testMethod void categoryFunctionalityTest() {
   		
        Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Unit', 'Testing 1 ', true, true);
        Category__c testCategory2 = TestUtil.createCategory(true, 'Test Category 2', 'Tax', 'Testing 2 ', true, true);
        Category__c testCategory3 = TestUtil.createCategory(true, 'Test Category 3', 'Unit', 'Testing 3 ', false, false);
        
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
        
        Test.startTest();
        String allCategoryJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForCategories(22, 20, true, BPUtility.getEncodedString('[]')));
        system.assertEquals(allCategoryJSONString.length() > 0, true);
        
        String moreCatgeoryJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.increaseCategories(20, 20, false, BPUtility.getEncodedString('[]')));
        system.assertEquals(moreCatgeoryJSONString.length() > 0, true);
        
        String filterCategory = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForFilteredCategory(BPUtility.getEncodedString('Test'), BPUtility.getEncodedString('Cat_Name')));
        system.assertEquals(filterCategory.length() > 0, true);
        
        String filterCategoryJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForCategories(22, 20, true, BPUtility.getEncodedString('[{"field":"Cat_Name","operator":"startswith","value":"Test"}]')));
        system.assertEquals(filterCategoryJSONString.length() > 0, true);
        
        filterCategoryJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForCategories(22, 20, true, BPUtility.getEncodedString('[{"field":"Cat_Default","operator":"eq","value":"true"}]')));
        system.assertEquals(filterCategoryJSONString.length() > 3, true);
        
        Test.stopTest();
    }
	
	/**
     * Name: vendorFunctionalityTest
     * Desc: Testing of Category functionality
     * @param: 
     * @return: 
    **/
   	static testMethod void vendorFunctionalityTest() {
        
        Test.startTest();
        Account testVendor1 = TestUtil.createVendor(true, 'Test Vendor 1', 'test1@gmail.com', 'Jaipur', '123456');
        Account testVendor2 = TestUtil.createVendor(true, 'Test Vendor 2', 'test2@gmail.com', 'Kota', '456123');
        Account testVendor3 = TestUtil.createVendor(true, 'Test Vendor 3', 'test3@gmail.com', 'Bareli', '789456');
        
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
        
        String allVendorJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForVendor(22, 20, true, BPUtility.getEncodedString('[]')));
        system.assertEquals(allVendorJSONString.length() > 0, true);
        
        String moreVendorJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.increaseVendor(20, 20, true, BPUtility.getEncodedString('[]')));
        system.assertEquals(moreVendorJSONString.length() > 0, true);
        
        String filterVendor = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForFilteredVendor(BPUtility.getEncodedString('Test'), BPUtility.getEncodedString('Vendor_Name'),true));
        system.assertEquals(filterVendor.length() > 0, true);
        
        String filterVendorJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForVendor(22, 20, true, BPUtility.getEncodedString('[{"field":"Vendor_Name","operator":"startswith","value":"vendor"}]')));
        system.assertEquals(filterVendorJSONString.length() > 3, false);
        
        filterVendorJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForVendor(22, 20, true, BPUtility.getEncodedString('[{"field":"Vendor_Email","operator":"eq","value":"test1@gmail.com"}]')));
        system.assertEquals(filterVendorJSONString.length() > 0, true);
        
        Test.stopTest();
    }
    
    /**
     * Name: unitMakeFunctionalityTest
     * Desc: Testing of Unit Make functionality
     * @param: 
     * @return: 
    **/
   	static testMethod void unitMakeFunctionalityTest() {
        
        Unit_Make__c testUnitMake1 = TestUtil.createUnitMake(true, 'Test Unit Make 1', 'TE1', true);
        Unit_Make__c testUnitMake2 = TestUtil.createUnitMake(true, 'Test Unit Make 2', 'TE2', true);
        Unit_Make__c testUnitMake3 = TestUtil.createUnitMake(true, 'Test Unit Make 3', 'TE3', true);
        
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
        
        Test.startTest();
        String allUnitMakeJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForUnitMakes(22, 20, true, BPUtility.getEncodedString('[]')));
        system.assertEquals(allUnitMakeJSONString.length() > 0, true);
        
        String moreUnitMakeJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.increaseUnitMakes(20, 20, false, BPUtility.getEncodedString('[]')));
        system.assertEquals(moreUnitMakeJSONString.length() > 0, true);
        
        String filterUnitMake = BlackPurlContentCtrl.getJSONForFilteredUnitMakes(BPUtility.getEncodedString('Test'), BPUtility.getEncodedString('Unit_Make_Name'), true);
        system.assertEquals(filterUnitMake.length() > 0, true);
        
        String filterUnitMakeJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForUnitMakes(22, 20, true, BPUtility.getEncodedString('[{"field":"Unit_Make_Name","operator":"startswith","value":"Test"}]')));
        system.assertEquals(filterUnitMakeJSONString.length() > 0, true);
        
        filterUnitMakeJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForUnitMakes(22, 20, true, BPUtility.getEncodedString('[{"field":"Unit_Make_Active","operator":"eq","value":"true"}]')));
        system.assertEquals(filterUnitMakeJSONString.length() > 3, true);
        
        Test.stopTest();
    }
    
	/**
     * Name: unitMakeFunctionalityTest
     * Desc: Testing of Unit Make functionality
     * @param: 
     * @return: 
    **/
   	static testMethod void unitModelFunctionalityTest() {
        
        Unit_Make__c testUnitMake1 = TestUtil.createUnitMake(true, 'Test Unit Make 1', 'TE1', true);
        
        Unit_Model__c testUnitModel1 = TestUtil.createUnitModel(true, 'Test Unit Model 1', 'TE2', true, testUnitMake1.Id);
        Unit_Model__c testUnitModel2 = TestUtil.createUnitModel(true, 'Test Unit Model 2', 'TE2', true, testUnitMake1.Id);
        Unit_Model__c testUnitModel3 = TestUtil.createUnitModel(true, 'Test Unit Model 3', 'TE2', true, testUnitMake1.Id);
        
        BlackPurlContentCtrl bpContentCtrl = new BlackPurlContentCtrl();
        
        Test.startTest();
        String allUnitModelJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForUnitModelByUnitMakeId(BPUtility.getEncodedString(testUnitMake1.Id), 22, 20, true, BPUtility.getEncodedString('[]')));
        system.assertEquals(allUnitModelJSONString.length() > 0, true);
        
        String moreUnitModelJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.increaseUnitModels((BPUtility.getEncodedString(testUnitMake1.Id)), 20, 20, false, BPUtility.getEncodedString('[]')));
        system.assertEquals(moreUnitModelJSONString.length() > 0, true);
        
        String filterUnitModel = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForFilteredUnitModels(BPUtility.getEncodedString(testUnitMake1.Id), BPUtility.getEncodedString('Test'), BPUtility.getEncodedString('Unit_Model_Name'), true));
        system.assertEquals(filterUnitModel.length() > 0, true);
        
        String filterUnitModelJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForUnitModelByUnitMakeId(BPUtility.getEncodedString(testUnitMake1.Id), 22, 20, true, BPUtility.getEncodedString('[{"field":"Unit_Model_Name","operator":"startswith","value":"Test"}]')));
        system.assertEquals(filterUnitModelJSONString.length() > 0, true);
        
        filterUnitModelJSONString = BPUtility.getDecodedString(BlackPurlContentCtrl.getJSONForUnitModelByUnitMakeId(BPUtility.getEncodedString(testUnitMake1.Id), 22, 20, true, BPUtility.getEncodedString('[{"field":"Unit_Model_Active","operator":"eq","value":"true"}]')));
        system.assertEquals(filterUnitModelJSONString.length() > 3, true);
        
        Test.stopTest();
    }  
	
    /**
     * Name: generateTestJSON
     * Desc: generate JSON for sales Tax and Price Level 
     * @param: 
     * @return: 
    **/
    private static String generateTestJSON(String prefix){
        System.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(prefix + 'Name','Test Name');
        gen.writeBooleanField(prefix + 'Active', true);
        if(prefix == 'ST_') {
            gen.writeStringField(prefix + 'Forms_Label','Test Label');
            gen.writeNumberField(prefix + 'Rate', 5.0);
        } else if(prefix == 'PL_' ) {
            gen.writeStringField(prefix + 'Part_Price_Base' , 'Cost');
        }
        gen.writeEndObject();
        return gen.getAsString();
    }
    
    /**
     * Name: generateTestJSONForCountry
     * Desc: generate JSON for country
     * @param: 
     * @return: 
    **/
    private static String generateTestJSONForCountry(String countryId){
        String prefix = 'C_';
        System.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(prefix + 'Name','Test Country');
        gen.writeBooleanField(prefix + 'Default', false);
        gen.writeBooleanField(prefix + 'Visible',true);
        gen.writeStringField(prefix + 'Id', countryId);
        gen.writeEndObject();
        return gen.getAsString();
    }
    
    /**
     * Name: generateTestJSONForState
     * Desc: generate JSON for state
     * @param: 
     * @return: 
    **/
    private static String generateTestJSONForState(String countryId, String stateId){
        String prefix = 'S_';
        System.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(prefix + 'Name','Test State');
        gen.writeBooleanField(prefix + 'Default', false);
        gen.writeStringField(prefix + 'Country', countryId);
        gen.writeStringField(prefix + 'Id', stateId);
        gen.writeEndObject();
        return gen.getAsString();
    }
    
    /**
     * Name: generateTestJSONForCustomer
     * Desc: generate JSON for customer
     * @param: customerId - Id of customer
     * @return: 
    **/
    private static String generateTestJSONForCustomer(String customerId, String customerType){
        String prefix;
        if(customerType == 'Business') {
        	prefix = 'Comp_Cust_';
        } else {
        	prefix = 'Indi_Cust_';
        }
        System.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        if(customerType == 'Business') {
        	gen.writeStringField(prefix + 'Name','Test Customer');
        } else {
        	gen.writeStringField(prefix + 'LastName','Test Customer');
        }
        if(customerType == 'Business') {
	        gen.writeStringField(prefix + 'BillingCity', 'Jaipur');
	        gen.writeBooleanField(prefix + 'Is_Vendor', true);
	        gen.writeStringField(prefix + 'Id', customerId);
        }
        
        gen.writeEndObject();
        return gen.getAsString();
    }
    
}