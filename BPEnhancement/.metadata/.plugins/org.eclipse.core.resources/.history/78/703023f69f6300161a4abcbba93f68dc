@isTest
private class VendorOrderHeaderTest {

    static testMethod void VendorOrderHeaderTestSortAscending() {
		Account vendor1 = TestUtil.createVendor(true, 'Test Vendor1');
	   	Account vendor2 = TestUtil.createVendor(true, 'Test Vendor2');
	   	VendorOrderHeader vendorOrderHeaderRecord1 = new VendorOrderHeader(TestUtil.createVendorOrderHeader(true, vendor1.Id).id);
	   	VendorOrderHeader vendorOrderHeaderRecord2 = new VendorOrderHeader(TestUtil.createVendorOrderHeader(true, vendor2.Id).id);
	   	List<VendorOrderHeader> vendororderHeaderList = new List<VendorOrderHeader>{vendorOrderHeaderRecord1,vendorOrderHeaderRecord2};
	   	VendorOrderReceivingCtrl.VO_Sort_Order = 'ASC';
	   	Test.startTest();
	   	vendororderHeaderList.sort();
	    Test.stopTest();
    }
    
    static testMethod void VendorOrderHeaderTestSortDescending() {
		Account vendor1 = TestUtil.createVendor(true, 'Test Vendor1');
	   	Account vendor2 = TestUtil.createVendor(true, 'Test Vendor2');
	   	VendorOrderHeader vendorOrderHeaderRecord1 = new VendorOrderHeader(TestUtil.createVendorOrderHeader(true, vendor1.Id).id);
	   	VendorOrderHeader vendorOrderHeaderRecord2 = new VendorOrderHeader(TestUtil.createVendorOrderHeader(true, vendor2.Id).id);
	   	List<VendorOrderHeader> vendororderHeaderList = new List<VendorOrderHeader>{vendorOrderHeaderRecord1,vendorOrderHeaderRecord2};
	   	VendorOrderReceivingCtrl.VO_Sort_Order = 'DESC';
	   	Test.startTest();
	   	vendororderHeaderList.sort();
	    Test.stopTest();
    }
    
    static testMethod void VendorOrderHeaderTestSort(){
	    Account vendor1 = TestUtil.createVendor(true, 'Test Vendor1');
	   	Account vendor2 = TestUtil.createVendor(true, 'Test Vendor2');
	   	VendorOrderHeader vendorOrderHeaderRecord1 = new VendorOrderHeader(TestUtil.createVendorOrderHeader(true, vendor1.Id).id);
	   	vendorOrderHeaderRecord1.VOName='testVO';
	   	VendorOrderHeader vendorOrderHeaderRecord2 = new VendorOrderHeader(TestUtil.createVendorOrderHeader(true, vendor2.Id).id);
	   	List<VendorOrderHeader> vendororderHeaderList = new List<VendorOrderHeader>{vendorOrderHeaderRecord1,vendorOrderHeaderRecord2};
	   	VendorOrderReceivingCtrl.VO_Sort_Order  = 'DESC';
	   	Test.startTest();
	   	vendororderHeaderList.sort();
	    Test.stopTest();
    }
}