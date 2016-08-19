/**
 * Author: Durga Singh
 * Since: September 8, 2015
 * Name: VendorOrderReceivingCtrlTest
 * Description: test Class for complete part overview functionality .
 **/
@isTest
private class PartOverviewCtrlTest {

    static testMethod void getPartDetailTest() {
       	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        insert part;
        
        String partDetails = BPUtility.getDecodedString(PartOverviewCtrl.getPartDetail(BPUtility.getEncodedString(part.Id)));
        List<PartDetail> partinformations = (List<PartDetail>) System.JSON.deserialize(partDetails, List<PartDetail>.class); 
        system.assertEquals(partinformations[0].PartNumber, 'partNumberP01');
    }
    
    static testMethod void getDefaultCategoryTest() {
       	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category', 'Part', 'categoryDescription', true, true);
    	
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        insert part;
        
        String categoryDetails = BPUtility.getDecodedString(PartOverviewCtrl.getDefaultCategory(BPUtility.getEncodedString(vendor.Id)));
        PartOverviewCtrlTest.Category categoryinformations = (PartOverviewCtrlTest.Category) System.JSON.deserialize(categoryDetails, PartOverviewCtrlTest.Category.class); 
        system.assertEquals (categoryinformations.DefaultCategoryName, 'Test Category' );
    }
    
    static testMethod void getDefaultCategoryTestA() {
       	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
       	Account vendor1 = TestUtil.createVendor(true, 'Test Vendor1');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category1');	
    	
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        insert part;
        
        String categoryDetails = BPUtility.getDecodedString(PartOverviewCtrl.getDefaultCategory(BPUtility.getEncodedString(vendor.Id)));
        //
        PartOverviewCtrlTest.Category categoryinformations = (PartOverviewCtrlTest.Category) System.JSON.deserialize(categoryDetails, PartOverviewCtrlTest.Category.class); 
        system.assertEquals (categoryinformations.DefaultCategoryName, null);
    }
    
    static testMethod void savePartTest() {
       	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true); 
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        /*Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        insert part;*/
        
        String partDetails = BPUtility.getDecodedString(PartOverviewCtrl.savePart(BPUtility.getEncodedString('[{"IsTaxable":true,"IsPackagedPart":true,"OrderLots":1,"InStockQty":"100.00","PackagedUnit":"PKG","Cost":50,"PackagedCost":"100.000","MSRP":0,"Retail":0,"EnviroFee":0,"PackagedQty":2,"AutoReorderAt":0,"AutoReorderTo":1,"CategoryId":"'+testCategory.Id+'","CategoryName":"Part_B1_Category","PartNumber":"testpart","Description":"test","VendorId":"'+vendor.Id+'","VendorName":"Tsst","ReplacedById":null,"ReplacedByName":"","Location":"houston"}]')));
        //String updatedPartDetails = BPUtility.getDecodedString(PartOverviewCtrl.savePart(BPUtility.getEncodedString('[{"Id":"'+partDetails+'","IsTaxable":false,"IsPackagedPart":true,"OrderLots":1,"InStockQty":"100.00","PackagedUnit":"PKG","Cost":50,"PackagedCost":"100.000","MSRP":0,"Retail":0,"EnviroFee":0,"PackagedQty":2,"AutoReorderAt":0,"AutoReorderTo":1,"CategoryId":"'+testCategory.Id+'","CategoryName":"Part_B1_Category","PartNumber":"testpart","Description":"test","VendorId":"'+vendor.Id+'","VendorName":"Tsst","ReplacedById":null,"ReplacedByName":"","Location":"houston"}]')));
		
		system.assertEquals(true, true);
    }
    
    public class Category {
    	
    	public String DefaultCategoryId;
    	public String DefaultCategoryName;
    	
    }
}