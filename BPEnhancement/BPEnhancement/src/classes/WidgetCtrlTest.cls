/**
 * Author: Durga Singh
 * Since: June 8, 2016
 * Name: WidgetCtrlTest test
 * Description: Controller test Class of WidgetCtrl.
**/
@isTest
private class WidgetCtrlTest {

   static testMethod void getWidgetRecordTest() {
        Account testCustomer = TestUtil.createCustomer(true, 'Test Customer', 'a.b@gmail.com', 'Jaipur', '987456123');
    	User testUser = TestUtil.createUser(true, 'a@b.c', 'Sharma', 'en_US', 'Shantanu.Sharma@metacube.com', 'sshar');
    	Widget__c widget = TestUtil.createWidget(true, 'widgetName' );
    	Widget_User_Junction__c widgetJunction = TestUtil.createWidgetJunction(true, widget.Id, 1, true, testUser.Id);
    	
    	Test.startTest();
    	String widgetRecord = BPUtility.getDecodedString( WidgetCtrl.showHideWidget(BPUtility.getEncodedString(widgetJunction.Id), true));
    	List<WidgetCtrl.WidgetWrapper> widgetRecordDetails = (List<WidgetCtrl.WidgetWrapper>) System.JSON.deserialize(widgetRecord, List<WidgetCtrl.WidgetWrapper>.class);
    	Test.stopTest();
    	
    	system.assertEquals(widgetRecordDetails.size(), 0);
    	
    	String widgetRecord1 = BPUtility.getDecodedString(WidgetCtrl.showHideWidget(BPUtility.getEncodedString(widgetJunction.Id), false));
    	List<WidgetCtrl.WidgetWrapper> widgetRecordDetails1 = (List<WidgetCtrl.WidgetWrapper>) System.JSON.deserialize(widgetRecord1, List<WidgetCtrl.WidgetWrapper>.class);
    	system.assertEquals(widgetRecordDetails1.size(), 0);
    }
    

	static testMethod void getCustomerOrderWidgetUpdateTest() {
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
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        Vendor_Order_Header__c voHeader1 = TestUtil.createVendorOrderHeader(true, Vendor.Id);
    	
    	Test.startTest();
    	String widgetRecord = BPUtility.getDecodedString(WidgetCtrl.getCustomerOrderWidgetUpdate());
    	WidgetCtrl.CustomerOrderWidgetWrapper widgetRecordDetails = (WidgetCtrl.CustomerOrderWidgetWrapper) System.JSON.deserialize(widgetRecord, WidgetCtrl.CustomerOrderWidgetWrapper.class);
    	Test.stopTest();
    	system.assertEquals(widgetRecordDetails.CountActiveOrder, 1);
    	User testUser = TestUtil.createUser(true, 'a@b.c', 'Sharma', 'en_US', 'Shantanu.Sharma@metacube.com', 'sshar');
    	Widget__c widget = TestUtil.createWidget(true, 'widgetName' );
    	Widget_User_Junction__c widgetJunction = TestUtil.createWidgetJunction(true, widget.Id, 1, true, testUser.Id);
    	
    	String widgetRecord1 = BPUtility.getDecodedString(WidgetCtrl.getWidgetRecord());
    	List<WidgetCtrl.WidgetWrapper> widgetRecordDetails1 = (List<WidgetCtrl.WidgetWrapper>) System.JSON.deserialize(widgetRecord1, List<WidgetCtrl.WidgetWrapper>.class);
    	//Widget__c colineitem12 = [select id from Widget__c];
    	//system.assert(false, widgetRecordDetails1);
    	system.assertEquals(widgetRecordDetails1.size(), 0);
    }
    
       static testMethod void widgetOrderUpdateTest() {
        Account testCustomer = TestUtil.createCustomer(true, 'Test Customer', 'a.b@gmail.com', 'Jaipur', '987456123');
    	User testUser = TestUtil.createUser(true, 'a@b.c', 'Sharma', 'en_US', 'Shantanu.Sharma@metacube.com', 'sshar');
    	Widget__c widget = TestUtil.createWidget(true, 'widgetName' );
    	Widget_User_Junction__c widgetJunction = TestUtil.createWidgetJunction(true, widget.Id, 1, true, testUser.Id);
    	
    	Test.startTest();
    	String widgetRecord = BPUtility.getDecodedString( WidgetCtrl.showHideWidget(BPUtility.getEncodedString(widgetJunction.Id), true));
    	List<WidgetCtrl.WidgetWrapper> widgetRecordDetails = (List<WidgetCtrl.WidgetWrapper>) System.JSON.deserialize(widgetRecord, List<WidgetCtrl.WidgetWrapper>.class);
    	Test.stopTest();
    	
    	system.assertEquals(widgetRecordDetails.size(), 0);
    	
    	string changeOrder = BPUtility.getDecodedString(WidgetCtrl.widgetOrderUpdate(BPUtility.getEncodedString(System.JSON.serialize(widgetRecordDetails))));
    	List<WidgetCtrl.WidgetWrapper> widgetRecordDetails1 = (List<WidgetCtrl.WidgetWrapper>) System.JSON.deserialize(changeOrder, List<WidgetCtrl.WidgetWrapper>.class);
    	system.assertEquals(widgetRecordDetails1.size(), 0);
    }
    		
}