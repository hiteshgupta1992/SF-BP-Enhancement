@isTest
private class SOInfoPrintPreviewPDFCtrlTest {
	@testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }

    static testMethod void SOInfoPrintPreviewPDFCtrlTest() {
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, false, unitMake.Id, unitModel.Id);
        Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, null, Part.Id, 500, 5.0); 
        String insertKitHeaderInMerchGridDetails = BPUtility.getDecodedString(CustomerOrderCtrl.insertKitHeaderInMerchGrid(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(coHeader.Id)));
        
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
		SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
		CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), 
										BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id));
        Service_Order_Header__c soHeaderRec = new Service_Order_Header__c(Id = soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id);
        
        PageReference soInfoPreviewPage = Page.SOInfoPrintPreviewPDF;
        soInfoPreviewPage.getParameters().put('id',soHeaderRec.id);
		Test.startTest();
		Test.setCurrentPage(soInfoPreviewPage);
		SOInfoPrintPreviewPDFCtrl soInfoCprintPreviewPDFCtrlObject = new SOInfoPrintPreviewPDFCtrl();
		Test.stopTest();
    	List<Service_Order_Header__c> soheaderList = [Select id from Service_Order_Header__c LIMIT 1];
    	System.assertEquals(1,soheaderList.size());
		
    }
}