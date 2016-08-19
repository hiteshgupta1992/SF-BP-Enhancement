/**
 * Author: Durga Singh
 * Since: July 15, 2015
 * Name: ViewPartCtrltest
 * Description: Test for Controller Class of Part Detail Page.
**/
@isTest
private class ViewVendorCtrlTest {

    /**
     * Name: ViewVendorCtrlTest 
     * Desc: Test to fetch vendor information on vendorId.
     * @param: 
     * @return: 
    **/
    static testMethod void getVendorInfoTest() {
        
        General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
        Account Vendor1 = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        
        String venderinfo = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor1.Id)));
        
        
        VendorDetail Vendor = (VendorDetail) System.JSON.deserialize(venderinfo, VendorDetail.class);
        system.assertEquals(Vendor.VendorDetailRec.VendorName , 'customerName');
        system.assertEquals(Vendor.VendorDetailRec.HomeEmail , 'abc@abc.com');
   
    }
    
     /**
     * Name: ViewVendorCtrlTest 
     * Desc: Test to fetch similar vendors for a vendor.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getOtherSimilarVendorTest() {
        
        General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
        
        Account Vendor =  TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764660', 'abc1');
        Account Vendor1 = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764660', 'abc1');
        Account Vendor11 = TestUtil.createCustomer(true, 'customerName', 'abc@abcd.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764660', 'abc');
        Account Vendor12 = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual', 'ds', 'rathore1', '9783764669', 'abc');
        Account Vendor2 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Business', 'ds1', 'rathore', '9783764669', 'abc');
        Account Vendor21 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Business', 'ds', 'rathore', '9783764669', 'abc');
        Account Vendor22 = TestUtil.createCustomer(true, 'customerName1', 'abc@abcd.com', 'Agra', '1111111111', null, null, true, false,'Business', 'ds', 'rathore', '9783764669', 'abc');
       	Account Vendor23 = TestUtil.createCustomer(true, 'customerName2', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Business', 'ds', 'rathore', '9783764669', 'abc');
       
        Test.startTest();
        String vendorJSONString = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor.Id)));
        VendorDetail vendorDetailList = (VendorDetail) System.JSON.deserialize(vendorJSONString, VendorDetail.class);
        String rootVendorJSONString = System.JSON.serialize(vendorDetailList.VendorDetailRec);
        String similarvendors = BPUtility.getDecodedString(ViewVendorCtrl.getOtherSimilarVendor(BPUtility.getEncodedString(rootVendorJSONString) ));
        Test.stopTest();
        
        List<VendorSuggestion> vendorSuggestionList = (List<VendorSuggestion>) System.JSON.deserialize(similarvendors, List<VendorSuggestion>.class);
        system.assertEquals(vendorSuggestionList.size(), 7);
     
        
       	String vendorJSONString1 = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor23.Id)));
       	
        VendorDetail vendorDetailList1 = (VendorDetail) System.JSON.deserialize(vendorJSONString1, VendorDetail.class);
        String rootVendorJSONString1 = System.JSON.serialize(vendorDetailList1.VendorDetailRec);
        
        String similarvendors1 = BPUtility.getDecodedString(ViewVendorCtrl.getOtherSimilarVendor(BPUtility.getEncodedString(rootVendorJSONString1 )));
        
       	List<VendorSuggestion> vendorSuggestionList1 = (List<VendorSuggestion>) System.JSON.deserialize(similarvendors1, List<VendorSuggestion>.class);
        //system.assertEquals(vendorSuggestionList1.size(), 7);
    }
    
     /**
     * Name: ViewVendorCtrlTest 
     * Desc: Test to fetch similar vendors for a vendor on other condiditon like mobile , street.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getOtherSimilarVendorTestA() {
        
        General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
        
        Account Vendor =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, true, false, 'Individual', 'ds', 'rathore', '9783764669', 'abc');
        Account Vendor1 = TestUtil.createCustomer(true, 'BST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway');
        Account Vendor11 = TestUtil.createCustomer(true, 'AST', 'abc1@abcd.com', 'up', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764669', 'highway');
        Account Vendor12 = TestUtil.createCustomer(true, 'AKT', 'abc2@gmail.com', 'mh', '1111111112', null, null, true, false,'Individual', 'ds', 'rathore1', '9783764661', 'kingsway');
        
       
        Test.startTest();
        String vendorJSONString = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor11.Id)));
        VendorDetail vendorDetailList = (VendorDetail) System.JSON.deserialize(vendorJSONString, VendorDetail.class);
        String rootVendorJSONString = System.JSON.serialize(vendorDetailList.VendorDetailRec);
        String similarvendors = BPUtility.getDecodedString(ViewVendorCtrl.getOtherSimilarVendor(BPUtility.getEncodedString(rootVendorJSONString )));
        Test.stopTest();
        
        List<VendorSuggestion> vendorSuggestionList = (List<VendorSuggestion>) System.JSON.deserialize(similarvendors, List<VendorSuggestion>.class);
        //system.assertEquals(vendorSuggestionList.size(), 2);
        
        String vendorJSONString1 = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor1.Id)));
        VendorDetail vendorDetailList1 = (VendorDetail) System.JSON.deserialize(vendorJSONString1, VendorDetail.class);
        String rootVendorJSONString1 = System.JSON.serialize(vendorDetailList1.VendorDetailRec);
        String similarvendors1 = BPUtility.getDecodedString(ViewVendorCtrl.getOtherSimilarVendor(BPUtility.getEncodedString(rootVendorJSONString1 )));
        
        List<VendorSuggestion> vendorSuggestionList1 = (List<VendorSuggestion>) System.JSON.deserialize(similarvendors1, List<VendorSuggestion>.class);
        //system.assertEquals(vendorSuggestionList1.size(), 2);
    }
    
    /**
     * Name: ViewVendorCtrlTest 
     * Desc: Test to fetch similar vendors for a vendor on other condiditon like social sites, other email and phone.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getOtherSimilarVendorTestB() {
        
        General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
        
        Account Vendor =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, true, false, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
        Account Vendor1 = TestUtil.createCustomer(true, 'AST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work@work.com','other1@other.com','1234567891', 'facebook1', 'twitter1', 'linkedin1');
        Account Vendor2 = TestUtil.createCustomer(true, 'BST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work1@work.com','work@work.com','1234567891', 'facebook1', 'twitter1', 'linkedin1');
        Account Vendor3 = TestUtil.createCustomer(true, 'CST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work1@work.com','other@other.com','1234567891', 'facebook1', 'twitter1', 'linkedin1');
        Account Vendor4 = TestUtil.createCustomer(true, 'EST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work1@work.com','other2@other.com','1234567890', 'facebook1', 'twitter1', 'linkedin1');
        Account Vendor5 = TestUtil.createCustomer(true, 'FST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work1@work.com','other2@other.com','1234567891', 'facebook', 'twitter1', 'linkedin1');
        Account Vendor6 = TestUtil.createCustomer(true, 'GST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work1@work.com','other2@other.com','1234567891', 'facebook1', 'twitter', 'linkedin1');
        Account Vendor7 = TestUtil.createCustomer(true, 'HST', 'abc@abc.com', 'Agra', '1111111111', null, null, true, false,'Individual', 'ds', 'rathore', '9783764668', 'kingsway', 'work1@work.com','other2@other.com','1234567891', 'facebook1', 'twitter1', 'linkedin');
        Test.startTest();
        String vendorJSONString = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor.Id)));
        VendorDetail vendorDetailList = (VendorDetail) System.JSON.deserialize(vendorJSONString, VendorDetail.class);
        String rootVendorJSONString = System.JSON.serialize(vendorDetailList.VendorDetailRec);
        String similarvendors = BPUtility.getDecodedString(ViewVendorCtrl.getOtherSimilarVendor(BPUtility.getEncodedString(rootVendorJSONString )));
        Test.stopTest();
        
        List<VendorSuggestion> vendorSuggestionList = (List<VendorSuggestion>) System.JSON.deserialize(similarvendors, List<VendorSuggestion>.class);
        //system.assertEquals(vendorSuggestionList.size(), 7);
       
    }
     
     /**
     * Name: saveVendorTest
     * Desc: Test to save vendoe with any updated name.
     * @param: 
     * @return: 
    **/
    
     static testMethod void saveVendorTest() {
    	General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
    	Account Vendor =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, true, false, 'Individual', 'ds', 'rathore', '9783764669', 'abc');
    	
    	String vendorJSONString = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor.Id)));
        VendorDetail vendorDetailList = (VendorDetail) System.JSON.deserialize(vendorJSONString, VendorDetail.class);
        vendorDetailList.VendorDetailRec.VendorName = 'AST' ;
        
        String rootVendorJSONString = System.JSON.serialize(vendorDetailList.VendorDetailRec);
        String newvendor = BPUtility.getDecodedString(ViewVendorCtrl.saveVendor(BPUtility.getEncodedString(rootVendorJSONString)));
        system.assertEquals(newvendor.contains('AST'), true );
        
        }
        
        /**
     * Name: getAllLookupFieldsJSONTest
     * Desc: Test to get all look up fields.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getAllLookupFieldsJSONTest() {
    	
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Country__c testcountry = TestUtil.createCountry(true, 'Australia', true, false);
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	
    	string allList = BPUtility.getDecodedString(ViewVendorCtrl.getAllLookupFieldsJSON());
       	system.assertEquals(allList.contains('Australia'), true);
        }
        
          /**
     * Name: setVendorFieldsTest
     * Desc: Test to set all vendors field.
     * @param: 
     * @return: 
    **/
    
     static testMethod void setVendorFieldsTest() {
    	General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
    	Account Vendor =  TestUtil.createCustomer(false, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, true, false, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
    	
    	vendor.SA_same_as_BA__c = true;
    	vendor.Preferred_Email__c = vendor.Other_Email__c;
    	vendor.Preferred_Phone__c = vendor.Work_Number__c;
    	vendor.Preferred_SMS__c = vendor.Work_Number__c;
    	vendor.shippingstreet = 'Abcs';
    	vendor.shippingcity = 'jaipurcity';
    	vendor.shippingstate = 'Raj';
    	vendor.shippingpostalcode = '302012';
    	vendor.shippingcountry = 'India';
    	insert vendor ;

    	
    	
    	String vendorJSONString = BPUtility.getDecodedString(ViewVendorCtrl.getVendorInfo(BPUtility.getEncodedString(Vendor.Id)));
        VendorDetail vendorDetailList = (VendorDetail) System.JSON.deserialize(vendorJSONString, VendorDetail.class);
        vendorDetailList.VendorDetailRec.VendorName = 'AST' ;
        
        String rootVendorJSONString = System.JSON.serialize(vendorDetailList.VendorDetailRec);
        String newvendor = BPUtility.getDecodedString(ViewVendorCtrl.saveVendor(BPUtility.getEncodedString(rootVendorJSONString)));
        system.assertEquals(newvendor.contains('AST'), true );
        }
}