/**
 * Author: Durga Singh
 * Since: Sep 29, 2015
 * Name: ScenarioBasedTests
 * Description: It includes scenario based test cases.
**/
@isTest
private class ScenarioBasedTests {
 
// ------------------------------------Scenarios included for Part functionalities-----------------------------------------------------
 
    @testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
    
 
//------------------------------Scenarios Included for VendorOrder Functionalities----------------------------------------------------------------------

 /**
     * Name: groupAllSimilarVOLineItemTest 
     * Desc: Test to group all similar VOLineItems.
     * @param: 
     * @return: 
    **/
    
    static testMethod void groupAllSimilarVOLineItemTest() {
     
        VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        //System.JSON.serialize(pageSort)
        boolean user = new VendorOrderCtrl().isPermittedToEditVOHeader ;
        /*User Defaultuser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U');
        List<PermissionSetAssignment> voHeaderPermissionAssignments = [SELECT PermissionSet.Name, 
                                                                                                                          PermissionSetId, 
                                                                                                                          AssigneeId 
                                                                                                                          FROM PermissionSetAssignment 
                                                                                                                          WHERE PermissionSet.Name = 'Vendor_Order_Header_Updates'
                                                                                                                ];
                                                                                            
        
        system.runas(DefaultUser)   {
            Test.startTest();
         PermissionSetAssignment psa = new PermissionSetAssignment(); 
         psa.AssigneeId = Defaultuser.Id; 
         psa.PermissionSetId = voHeaderPermissionAssignments[0].PermissionSetId; 
         insert psa;*/
         
        Test.startTest();
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer =  TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        insert part;
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        Test.stopTest();
        system.assertEquals(voLineItems.TotalLineItemGroups, 1);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 50);
         }  
         
         
         
                /**
     * Name: getPaginatedItemsForVOHeaderForItemsTest
     * Desc: Test to find Line item for Items
     * @param: 
     * @return: 
    **/
    
    static testMethod void  getPaginatedItemsForVOHeaderForItemsTest () {
        
        VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
       
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer =  TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(true, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.getPaginatedItemsForVOHeader(BPUtility.getEncodedString('Items'), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.TotalLineItemGroups, 0);                                                                                            
    }
    
    /*
     * Name: addVOLineItemFromSearchToAddTest 
     * Desc: Test to add VOLineItem from search.
     * @param: 
     * @return: 
    **/
    
   static testMethod void  addVOLineItemFromSearchToAddTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
		 
		
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 1;
        insert part;
        
        Part__c part1 = TestUtil.createPart(false, 'partNumberP012', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 1;
        insert part1;

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 60, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
        String LineItemFromAddToSearch1 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 60, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), false));
        VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch1, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems1.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Need, 60);
       
        
        
       
        
        String LineItemFromAddToSearch2 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 30, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems21 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch2, VendorOrderLineItemWrapper.class);
        String LineItemFromAddToSearch21 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 30, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voLineItems21.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), false));
        VendorOrderLineItemWrapper voLineItems22 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch21, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems22.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Need, 30);

       
    }
    
            /**
     * Name: groupAllVOLineItemTest
     * Desc: Test to group all VOLineItems from COLI for different part.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  groupAllVOLineItemTest () {
     
        VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer =  TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        part.Qty_On_Order__c = 0;
        insert part;
        
        Part__c part1 = TestUtil.createPart(false, 'partNumberP011', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part1.Packaged_Part__c = true ;
        Part1.Package_Qty__c = 22 ;
        Part1.Auto_reorder_Min__c = 0;
        part1.Auto_reorder_Max__c = 100;
        part1.Order_Lots__c = 1;
        part1.Qty_On_Order__c = 0;
        insert part1;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part1.Id, 130);
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, Vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        
       /* Part__c part2 = TestUtil.createPart(false, 'partNumberP012', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part2.Packaged_Part__c = true ;
        Part2.Package_Qty__c = 22 ;
        Part2.Auto_reorder_Min__c = 0;
        part2.Auto_reorder_Max__c = 100;
        part2.Order_Lots__c = 1;
        part2.Qty_On_Order__c = 0;
        insert part2;
        
        CO_Line_Item__c coLineItem2 = TestUtil.createCOLineItem(true, coHeader.Id, part1.Id, 135);
        String similarlineitem1 = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem1, VendorOrderLineItemWrapper.class);
        */
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.TotalLineItemGroups, 2);
        system.assertEquals(voLineItems.TotalRequiredForStocks, 2);
        system.assertEquals(voLineItems.TotalRequiredForCustomers, 0);
    }
    
                    /**
     * Name: addVendorTest
     * Desc: Test to add vendor and create vendor order
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  addVendorTest () {
     
        VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer =  TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        

        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.TotalRequiredForStocks, 1); 
        system.assertEquals(voLineItems.TotalRequiredForCustomers, 1);                                                                                      
    }
    
                            /**
     * Name: removeLineItemFromOrderTest
     * Desc: Test to remove lineitem from vendor order.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  removeLineItemFromOrderTest () {
     
        VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
       /* Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;*/
        
        Part__c part = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 1;
        insert part;
        
       Part__c part1 = TestUtil.createPart(false, 'partNumberP03', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 1;
        insert part1;

        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 60, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
        
        String LineItemFromAddToSearch1 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part1.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 100, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch1, VendorOrderLineItemWrapper.class);
        
        
        /*Vendor_Order_Line_Item_Group__c vendorOrderGroup = TestUtil.createVendorOrderLineItemGroup(true, voHeader.Id, part.Id);
        Vendor_Order_Line_Item__c VendorOrderLineItem = TestUtil.createVendorOrderLineItem(false, voHeader.Id, part.Id, 200);
        VendorOrderLineItem.Qty_Needed__c = 200 ;
        insert VendorOrderLineItem;
        
        Vendor_Order_Line_Item_Group__c vendorOrderGroup1 = TestUtil.createVendorOrderLineItemGroup(true, voHeader.Id, part1.Id);
        Vendor_Order_Line_Item__c VendorOrderLineItem1 = TestUtil.createVendorOrderLineItem(false, voHeader.Id, part1.Id, 200);
        VendorOrderLineItem1.Qty_Needed__c = 300 ;
        insert VendorOrderLineItem1;*/
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems1.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems1.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems2 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems2.TotalLineItemGroups, 1);                                                                                       
    }
    
            
                                       /**
     * Name: finalizeVendorOrderTest
     * Desc: Test to check COLI order status and part records status after finalized vendor order.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  finalizeVendorOrderTest () {
     
        VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer =  TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;


        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
       
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        

        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        
        
    }
         
              /**
     * Name: parsePageAttrs
     * Desc: Method to Parse JSON String to class instance for Pagination and sort attributes
     * @param:  (1) JSONString - String - JSON String 
     * @return: RelatedListPaginationSorting - Class Object
    **/
    public static VendorPaginationSorting parsePageAttrs(String json) {
        return (VendorPaginationSorting) System.JSON.deserialize(json, VendorPaginationSorting.class);
    }
    
    // Wrapper class for related list pagination and sorting combination
    public class VendorPaginationSorting {
        
        // Change count
        public Integer ChangesCount;
        
        // Current page number
        public Integer CurrentPage;
        
        // page size
        public Integer PageSize;
        
        // Sorting Attrs
        public List<SortAttrs> Sorting;
    }
    
    // SortAttrs for sorting attributes
    public class SortAttrs {
        
        // Field name
        public String FieldName;
        
        // Sort direction
        public String SortDirection;
        
        public SortAttrs(String FieldName, String SortDirection){
            this.FieldName = FieldName;
            this.SortDirection = SortDirection;
        }
    }
   // --------------------------------------------------------Complete Workflow Cases for various scenarios---------------------------------------------------------------




    
     static testMethod void commitRecevingActionTestforCustomer() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        //Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        //CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
            Test.startTest();
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(part.id), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 10, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
    
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        Test.stopTest();
        
        //system.assert(false, partList);
        system.assertEquals(partList[0].Qty_In_Stock__c, 320.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        
        List<CO_Line_Item__c> colineitem12 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c];
        system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c,    Vendor__c from Vendor_Order_Header__c];
        //system.assert(false, voHeader12);
    }
  
static testMethod void commitRecevingActionTestforStock() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        //Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        //CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), false,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        //List<Vendor_Receiving_Group__c> vrg = [select Id, Recieved__c, (select Qty_Needed__c, Received__c from Vendor_Order_Line_Items__r) from Vendor_Receiving_Group__c];
        //system.assert(false, vrg[0].Vendor_Order_Line_Items__r);
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        Test.startTest();
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(part.id), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 9, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        //system.assert(false, voLineReceiveItems);
        
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
         List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c];
        //system.assert(false, voliList);
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        Test.stopTest();
        
        //system.assert(false, partList);
        system.assertEquals(partList[0].Qty_In_Stock__c, 298.00);
        system.assertEquals(partList[0].Qty_Committed__c, 100.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 22);
        
        List<CO_Line_Item__c> colineitem12 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c];
        system.assertEquals(colineitem12[0].Qty_Committed__c, 100.00);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c,    Vendor__c from Vendor_Order_Header__c];
        //system.assert(false, voHeader12);
    }
    
 static testMethod void commitRecevingActionTestforCustomerPartialReceive() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        Test.startTest();
        
        VendorOrderReceivingCtrl_PartialTest.createExcessTestData(vendor.Id, vorId, voHeader.Id, part.Id);

        //VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems2 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        Test.stopTest();
        
        List<Vendor_Order_Header__c> voHeaderList = [select Status__c from Vendor_Order_Header__c];
        //system.assert(false, voHeaderList);
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList1);
        system.assertEquals(partList1[0].Qty_In_Stock__c, 166.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
    }
    

static testMethod void commitRecevingActionTestforStockPartialReceive() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), false,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        Test.startTest();
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataforStock(vendor.Id, vorId, voHeader.Id, part.Id);

        //VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems2 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        Test.stopTest();
        

        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList1);
        system.assertEquals(partList1[0].Qty_In_Stock__c, 320.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 100.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
    }
    
static testMethod void commitRecevingActionTestforBothCustomerAndStockPartialReceive() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        String vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        Test.startTest();
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataforBothStockAndCustomer(vendor.Id, vorId, voHeader.Id, part.Id);

        //VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems2 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        Test.stopTest();
        

        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList1);
        system.assertEquals(partList1[0].Qty_In_Stock__c, 386.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
    }
    
    static testMethod void commitRecevingActionTestforBothCustomerAndStockForMultipleCustomerOrder() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part.Id, 100);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        Test.startTest();
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataforBothStockAndCustomerforMultipleCO(vendor.Id, vorId, voHeader.Id, part.Id);

        //VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems2 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        Test.stopTest();
        

        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList1);
        system.assertEquals(partList1[0].Qty_In_Stock__c, 474.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 250.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
    }
    
    static testMethod void commitRecevingActionTestforCustomerHavingMultiParts() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 116);


        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        Test.startTest();
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataMultiParts(vendor.Id, vorId, voHeader.Id, part.Id, part2.Id);

        //VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems2 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        Test.stopTest();
        
        List<Vendor_Order_Header__c> voHeaderList = [select Status__c from Vendor_Order_Header__c];
        system.assertEquals(voHeaderList[0].Status__c, 'Partially Received');
        
        /*List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList1);
        system.assertEquals(partList1[0].Qty_In_Stock__c, 166.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        system.assertEquals(partList1[1].Qty_In_Stock__c, 116.00);
        system.assertEquals(partList1[1].Qty_Committed__c, 116.00);
        system.assertEquals(partList1[1].Qty_On_Order__c, 0);
        
        List<Vendor_Order_Line_Item_Group__c> volig = [select Need__c, Received_Qty__c, Part__c from Vendor_Order_Line_Item_Group__c];
        //system.assert(false, volig);
        system.assertEquals(volig[0].Need__c, 66.000);
        system.assertEquals(volig[0].Received_Qty__c, 66.000);
        system.assertEquals(volig[1].Need__c, 66.000);
        system.assertEquals(volig[1].Received_Qty__c, 66.000);*/  
        
    }
    
    static testMethod void commitRecevingActionTestforVOGDetails() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        List<CO_Line_Item__c> coli123 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli123[0].VO_Status__c, 'On Order');
        system.assertEquals(coli123[0].Status__c, 'Ordered');
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList[0].Qty_On_Order__c, 236);
        
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(finalizedLineItems, VendorOrderLineItemWrapper.class);
        
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
        
        Test.startTest();
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataforVOGDetails(vendor.Id, vorId, voHeader.Id, part.Id);

        //VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems2 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        Test.stopTest();
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList1);
        system.assertEquals(partList1[0].Qty_In_Stock__c, 386.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
        List<Vendor_Order_Line_Item_Group__c> volig = [select Need__c, Received_Qty__c, Part__c from Vendor_Order_Line_Item_Group__c];
        system.assertEquals(volig[0].Need__c, 286);
        system.assertEquals(volig[0].Received_Qty__c, 286);

        
    }
    
    /*
     * Name: SOCompleteFlowTest
     * Desc: Test to check complete flow for SO.
     * @param: 
     * @return: 
    **
     static testMethod void SOCompleteFlowTest() {
     	
     	//Created test data to check scenario
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        
           //Price level of 10% on MSRP
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        
           // Part with available qty 100 and having MSRP $50
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        	// created customer order
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        	// Created Service order
        String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, 'soHeader');
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        	// Add part to Service order
        String lineitems = CustomerOrderCtrl.addLineItems(part.Id, soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id, coHeader.Id, customer.Id);
        
        	// Adding 500 qty for part in SO
        String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
        String SOHeaderDetails2 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
        
        system.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded, 500.00);
        
        	// create PO type and vendor order
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        Test.StartTest();
        	//  group all required parts for vendor
        String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        	// vendor order submitted
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendor.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
			// checking qty on order to vendor
		List<CO_Line_Item__c> colineitems = [select  Qty_Committed__c, Qty__c, Qty_To_Order__c from CO_Line_Item__c];
        system.assertEquals(colineitems[0].Qty_To_Order__c, 400.00);
        system.assertEquals(colineitems[0].Qty_Committed__c, 100.00);
        	// created vendorOrderReceive header
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendor.Id, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
        	// Add all lineitem for receiving
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, null, voLineItems.VendorOrderLineItemGroupList[0].Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        	//  receiving all parts from vendor
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);

         	// checking part details after receiving parts from vendor
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        	// committed qty should be  500 as same is required for customer for SO.
        system.assertEquals(partList[0].Qty_In_Stock__c, 500.00);
        system.assertEquals(partList[0].Qty_Committed__c, 500.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        Test.StopTest();	
        	// Getting customer order details again
        String details = CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
        COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
        // pricing should be = (50 * 110/100) * 500 = $27500
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 27500.000);
         	// adding payments on CO
         	
         	
        String savedCOInvoicePayment = CustomerOrderCtrl.saveCOInvoicePayment('[{"ReverseLink":null,"PaymentMethod":"Cash","Amount":"27500.000","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'"}]');
        
        	// Closing invoice
        	
        String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction('[{"Total":27500.000,"TaxAmount":null,"Saving":null,"RetailPrice":null,"QtyRequired":null,"Qty":null,"Price":null,"Item":"Service Order 1","IsInvoiceable":true,"IsActive":true,"COLineItemId":null,"COInvoiceItemNumber":null,"COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[0].COInvoiceItemId+'","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","$$hashKey":"object:56"}]', coHeader.Id, 'Customer');
        	// checking on invoice history details
        COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(closedInvoiceAction, COHeaderWrapper.class);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].NumberOfItems, 1);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Total, 27500);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Tax, 0);
        system.assertEquals(coHeaderDetails1.COInvoiceItemRecs.size(), 0);
        

    }
    
    
        /*
     * Name: SOCompleteFlowTest
     * Desc: Test to check SO complete flow where Kit is part of SO.
     * @param: 
     * @return: 
    **
     static testMethod void SOCompleteFlowTestA() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 100, 'LabourCodeName', 100, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, false, false, unitMake.Id, unitModel.Id);
        //Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1000, 5.0); 
        Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 5.0, null, Part.Id, 1000, 5.0);
        //Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, null, 1000, 5.0);       
        
        String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, 'soHeader');
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = CustomerOrderCtrl.addLineItems(kitHeader.Id, soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id, coHeader.Id, customer.Id);*/
        /*List<CO_Invoice_Item__c> coii1 = [select Is_Invoiceable__c, Price__c, Qty__c, Tax__c, isActive__c from CO_Invoice_Item__c];
        system.assert(false, coii1);
        list<Service_Order_Line_Item__c> solis = [select  Qty_Needed__c, Kit_Price__c,  Retail_Price__c, qty_committed__c from Service_Order_Line_Item__c];
        
        system.assert(false, solis);
        */
        /*String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        //list<Service_Order_Line_Item__c> solis = [select  Qty_Needed__c, Kit_Price__c,    Retail_Price__c, qty_committed__c from Service_Order_Line_Item__c];
        
        //system.assert(false, solis);
        
        String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
        
       
        //String SOHeaderDetails2 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        //SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
        
        //system.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded, 1000.00);
        
        
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        */
        /*List<Kit_Header__c> kitheader1 = [select Id, Fixed_Price__c, Number_of_Labours__c from Kit_Header__c];
        system.assert(false, kitheader1);*/
        
        /*List<Service_Order_Kit_Header__c> SOKitheader1 = [select Id, Fixed_Price__c from Service_Order_Kit_Header__c];
        system.assert(false, SOKitheader1);*/
        
        /*List<Service_Order_Line_Item__c> SOli1 = [select Id, Fixed_Price__c, Total__c from Service_Order_Line_Item__c];
        system.assert(false, SOli1);*/
        /*
        Test.StartTest();
        String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendor.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
         
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendor.Id, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, null, voLineItems.VendorOrderLineItemGroupList[0].Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        */
        /*List<Service_Order_Header__c> soh = [select Total__c from Service_Order_Header__c];
        list<Service_Order_Line_Item__c> solis = [select  Qty_Needed__c, Kit_Price__c,  Retail_Price__c, qty_committed__c from Service_Order_Line_Item__c];
        
        system.assert(false, soh + '\n\n\n' + solis);*/
        
        /*List<CO_Line_Item__c> colineitems = [select  Qty_Committed__c, Qty__c from CO_Line_Item__c];
        system.assert(false, colineitems);*/
         /*
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList[0].Qty_In_Stock__c, 500.00);
        system.assertEquals(partList[0].Qty_Committed__c, 500.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        Test.StopTest();
        String details = CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
        COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
        
        
        //system.assert(false, coHeaderDetails);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 50000);
        
        String savedCOInvoicePayment = CustomerOrderCtrl.saveCOInvoicePayment('[{"ReverseLink":null,"PaymentMethod":"Cash","Amount":"27500.000","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'"}]');
        //system.assert(false, savedCOInvoicePayment);
        
        String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction('[{"Total":27500.000,"TaxAmount":null,"Saving":null,"RetailPrice":null,"QtyRequired":null,"Qty":null,"Price":null,"Item":"Service Order 1","IsInvoiceable":true,"IsActive":true,"COLineItemId":null,"COInvoiceItemNumber":null,"COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[0].COInvoiceItemId+'","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","$$hashKey":"object:56"}]', coHeader.Id, 'Customer');
        
        COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(closedInvoiceAction, COHeaderWrapper.class);
        //system.assert(false, coHeaderDetails1);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].NumberOfItems, 1);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Total, 50000);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Tax, 0);
        system.assertEquals(coHeaderDetails1.COInvoiceItemRecs.size(), 0);
    }
    
            /*
     * Name: SOCompleteFlowTest
     * Desc: Test to check SO complete flow where Kit is part of SO and also part belongs to merch section.
     * @param: 
     * @return: 
    **
     static testMethod void SOCompleteFlowTestB() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 100, 'LabourCodeName', 100, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, false, false, unitMake.Id, unitModel.Id);
        //Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1000, 5.0); 
        Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 5.0, null, Part.Id, 1000, 5.0);
        //Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, null, 1000, 5.0);       
        
        String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, 'soHeader');
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = CustomerOrderCtrl.addLineItems(kitHeader.Id, soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id, coHeader.Id, customer.Id);
        
        //String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        //SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        //soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 200);
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        //String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
        //String SOHeaderDetails2 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        //SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
        
        //system.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded, 1000.00);
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        */
        /*List<Kit_Header__c> kitheader1 = [select Id, Fixed_Price__c, Number_of_Labours__c from Kit_Header__c];
        system.assert(false, kitheader1);*/
        
        /*List<Service_Order_Kit_Header__c> SOKitheader1 = [select Id, Fixed_Price__c from Service_Order_Kit_Header__c];
        system.assert(false, SOKitheader1);*/
        
        /*List<Service_Order_Line_Item__c> SOli1 = [select Id, Fixed_Price__c, Total__c from Service_Order_Line_Item__c];
        system.assert(false, SOli1);*/
        
        /*
        String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        Test.StartTest();
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendor.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendor.Id, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, null, voLineItems.VendorOrderLineItemGroupList[0].Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        */
        
        /*List<CO_Line_Item__c> colineitems = [select  Qty_Committed__c, Qty__c from CO_Line_Item__c];
        system.assert(false, colineitems);*/
         
        
        /*
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList[0].Qty_In_Stock__c, 1200.00);
        system.assertEquals(partList[0].Qty_Committed__c, 1200.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        Test.StopTest();*/
        
        /*String details = CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
        COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
        
        //system.assert(false, coHeaderDetails);
        String savedCOInvoicePayment = CustomerOrderCtrl.saveCOInvoicePayment('[{"ReverseLink":null,"PaymentMethod":"Cash","Amount":"27500.000","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'"}]');
        String updatedCOInvoicePayment = CustomerOrderCtrl.updateCOInvoiceItem(true, '{"COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[1].COInvoiceItemId+'","COLineItemId":"'+coHeaderDetails.allCOLineItemRecs[0].CoLineItemId+'"}', 'b');
        //system.assert(false, savedCOInvoicePayment);
        
        //String details1 = CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
        //COHeaderWrapper coHeaderDetails2 = (COHeaderWrapper) System.JSON.deserialize(details1, COHeaderWrapper.class);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 100000.000);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[1].Total, 11000.000);
        
        String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction('[{"Total":27500.000,"TaxAmount":null,"Saving":null,"RetailPrice":null,"QtyRequired":null,"Qty":null,"Price":null,"Item":"Service Order 1","IsInvoiceable":true,"IsActive":true,"COLineItemId":null,"COInvoiceItemNumber":null,"COInvoiceItemId":null,"COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","$$hashKey":"object:56"}]', coHeader.Id);
        
        
        COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(closedInvoiceAction, COHeaderWrapper.class);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].NumberOfItems, 2);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Total, 111000.00);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Tax, 0);
        system.assertEquals(coHeaderDetails1.COInvoiceItemRecs.size(), 0);*/
    //}
    
        /*
     * Name: SOCompleteFlowTest
     * Desc: Test to check SO complete flow.
     * @param: 
     * @return: 
    **/
     static testMethod void SOCompleteFlow_partialReceiveTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Transaction_Type__c transactionType =  TestUtil.createTransactionType(true, 'Customer', 'Customer');
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        //Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
        //Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);    
        
        String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        //SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        Service_Order_Header__c soHeaderRec = new Service_Order_Header__c(Id = soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id);
        soHeaderRec.Transaction_Type__c = transactionType.Id;
        update soHeaderRec;
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
        String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        
        Test.StartTest();
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        String updatedSOLI = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails2 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
        
        system.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded, 500.00);
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        /*List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);*/
        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
     
        /*
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataA(vendor.Id, vorId, voHeader.Id, part.Id, coHeader.Id);
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataABCD(vendor.Id, vorId, voHeader.Id, part.Id, coHeader.Id);
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, null, voLineItems.VendorOrderLineItemGroupList[0].Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
        
        List<CO_Line_Item__c> colineitems = [select  Qty_Committed__c, Qty__c from CO_Line_Item__c];
        system.assert(false, colineitems);
         
        List<Service_Order_Line_Item__c> SOli1 = [select Id, Fixed_Price__c, Total__c from Service_Order_Line_Item__c];
        system.assert(false, SOli1);*/
        
        
        
        
        
        
        
        
        Test.StopTest();
        String details1 = BPUtility.getDecodedString(CustomerOrderCtrl.getCOHeaderDetails(BPUtility.getEncodedString(coHeader.Id)));
        COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(details1, COHeaderWrapper.class);
        //system.assert(false, coHeaderDetails1);
        /*system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].NumberOfItems, 1);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Total, 27500.000);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Tax, 0);
        system.assertEquals(coHeaderDetails1.COInvoiceItemRecs.size(), 0);
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList1[0].Qty_In_Stock__c, 0.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 0.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        */
    }
    
    /*
    static testMethod void SOCompleteFlowTest_SamePartInMultipleSO_TK() {
        
        
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataTK();
        
       
    }*/
    
      static testMethod void SOCompleteFlowTest_SamePartInMultipleSO_partialReceive() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Transaction_Type__c transactionType =  TestUtil.createTransactionType(true, 'Customer', 'Customer');
        Part__c part = TestUtil.createPart(false, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        insert part;
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        //Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        //Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
        //Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);    
        
        String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        
        List<Service_Order_Header__c> soh = [select Id from Service_Order_Header__c limit 1];
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(soh[0].Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
        String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        //SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        Service_Order_Header__c soHeaderRec = new Service_Order_Header__c(Id = soHeaderDetailsObj1.SOList[0].SOHeaderInfo.Id);
        soHeaderRec.Transaction_Type__c = transactionType.Id;
        update soHeaderRec;
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        String updatedSOLI = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));

        
        Test.startTest();
        
        // Create one more SO
        String soHeader1 = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        
        soh = [select Id from Service_Order_Header__c where Name__c = 'Service Order 2'];
        String lineitems1 = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(soh[0].Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
        
        String SOHeaderDetails3 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        //SOHeaderWrapper soHeaderDetailsObj3 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails3, SOHeaderWrapper.class);
        SOHeaderWrapper soHeaderDetailsObj3 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails3, SOHeaderWrapper.class);
        Service_Order_Header__c soHeaderRec1 = new Service_Order_Header__c(Id = soHeaderDetailsObj3.SOList[0].SOHeaderInfo.Id);
        soHeaderRec1.Transaction_Type__c = transactionType.Id;
        update soHeaderRec1;
        
        soHeaderDetailsObj3.SOList[1].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 200.00 ;
        
        
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        String updatedSOLI1 = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj3.SOList[1].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 300);
        
        
        
        VendorOrderReceivingCtrl_PartialTest.SamePartInMultipleSO_partialReceive(vendor.Id, part.Id, coHeader.Id);
        
       
        
        
        
        /*
        List<CO_Invoice_Item__c> coinvoice13 = [select Price__c, Service_Order_Header__c, Qty__c, Is_Invoiceable__c from CO_Invoice_Item__c];
        system.assert(false, coinvoice13 );*/
         


        
       
    }
    /*
     static testMethod void SOCompleteFlowTest_SamePartInMultipleSO_partialReceiveA() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(false, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        insert part;
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        //Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        //Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
        //Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);    
        
        String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        
        List<Service_Order_Header__c> soh = [select Id from Service_Order_Header__c limit 1];
        String lineitems = CustomerOrderCtrl.addLineItems(part.Id, soh[0].Id, coHeader.Id, customer.Id);
        
        String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);

        
        Test.startTest();
        
        // Create one more SO
        String soHeader1 = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        
        soh = [select Id from Service_Order_Header__c where Name__c = 'Service Order 2'];
        String lineitems1 = CustomerOrderCtrl.addLineItems(part.Id, soh[0].Id, coHeader.Id, customer.Id);
        
        
        String SOHeaderDetails3 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj3 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails3, SOHeaderWrapper.class);
        
        soHeaderDetailsObj3.SOList[1].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 200.00 ;
        
        
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        String updatedSOLI1 = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj3.SOList[1].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 300);
        
        
        
        VendorOrderReceivingCtrl_PartialTest.SamePartInMultipleSO_partialReceiveA(vendor.Id, part.Id, coHeader.Id);
        Test.stopTest();
        
       	String details = CustomerOrderCtrl.getCOHeaderDetailsByGridName(coHeader.Id, null);
        COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
        //system.assert(false, coHeaderDetails);
        
        
        
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 27500.000);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[1].Total, 11000.000);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[2].Total, 16500.000);
       
        */
        
        
        /*
        List<CO_Invoice_Item__c> coinvoice13 = [select Price__c, Service_Order_Header__c, Qty__c, Is_Invoiceable__c from CO_Invoice_Item__c];
        system.assert(false, coinvoice13 );*/
         


        
       
    //}
    
     static testMethod void ScenarioForMerchsection() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Fee__c fee = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
         Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'code', 'Customer');
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, false, unitMake.Id, unitModel.Id);
        Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, null, Part.Id, 500, 5.0); 
        
        String insertKitHeaderInMerchGridDetails = BPUtility.getDecodedString(CustomerOrderCtrl.insertKitHeaderInMerchGrid( BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(coHeader.Id)));
        COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(insertKitHeaderInMerchGridDetails, COHeaderWrapper.class);
        system.assertEquals(coHeaderDetails1.allCOLineItemRecs[0].Item, 'TestPart - TestPart');
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 300);
        
        
        
        VendorOrderReceivingCtrl_PartialTest.ScenarioForMecrhsection_partialReceive(vendor.Id, part.Id, coHeader.Id);
    }
 /*   
static testMethod void ScenarioForMerchAndSOsectionHavingSameKit() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Fee__c fee = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
         Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'code', 'Customer');
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, false, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, null, Part.Id, 500, 5.0);	
        
        //Created SO Having Kit
        String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        
        List<Service_Order_Header__c> soh = [select Id from Service_Order_Header__c limit 1];
        String lineitems = CustomerOrderCtrl.addLineItems(part.Id, soh[0].Id, coHeader.Id, customer.Id);
        
    	String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
		
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
      	
      	Test.starttest();
      	//Kit is added in Merch Section
      	String insertKitHeaderInMerchGridDetails = CustomerOrderCtrl.insertKitHeaderInMerchGrid( kitHeader.Id, coHeader.Id);
      	//COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(insertKitHeaderInMerchGridDetails, COHeaderWrapper.class);
      	//system.assertEquals(coHeaderDetails1.allCOLineItemRecs[0].Item, 'TestPart - TestPart');
      	 
      	
      	
      	// Part is added into merch section. Same part is also asscoiated with Kit
      	CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 300);
        
        
        
        VendorOrderReceivingCtrl_PartialTest.ScenarioForMecrhsection_partialReceiveA(vendor.Id, part.Id, coHeader.Id);
        Test.stoptest();
    }
    
        /*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingKitToSOTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part1.Id, 1, null);		
    	
    	CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 5);
    	
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	Test.StartTest();
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 180);
        //System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice, 120);
        //System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[1].KitPrice, 60);
        
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice = 130;
		
		Test.StopTest();
        String updatedSOKH = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));
		String SOHeaderDetails2 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
   		//System.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.FixedPrice, 190);
   	}
   	
   	        /*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingKitToMerchTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, false, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part1.Id, 1, null);		
    	
    	CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 5);
    	String insertKitHeaderInMerchGridDetails = BPUtility.getDecodedString(CustomerOrderCtrl.insertKitHeaderInMerchGrid( BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(coHeader.Id)));
    	
    	String COHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getCOHeaderDetails(BPUtility.getEncodedString(coHeader.Id)));
        COHeaderWrapper coHeaderDetailsObj1 = (COHeaderWrapper) System.JSON.deserialize(COHeaderDetails1, COHeaderWrapper.class);
        //system.assert(false, coHeaderDetailsObj1.coInvoiceItemRecs);
        System.assertEquals(coHeaderDetailsObj1.COKHList[1].Price, 180);
        system.assertEquals(coHeaderDetailsObj1.coInvoiceItemRecs[0].IsInvoiceable, true);
        system.assertEquals(coHeaderDetailsObj1.coInvoiceItemRecs[1].IsInvoiceable, true);
		
		List<CO_Invoice_Item__c> COII = [select Is_Invoiceable__c from CO_Invoice_Item__c  where CO_Kit_Header__c != null limit 100];
        system.assertEquals(COII[0].Is_Invoiceable__c, true);
        
   	}
   	
   	        /*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingFixedKitToSOTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 200, true, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part1.Id, 1, null);		
    	
    	CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 5);
    	
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	Test.StartTest();
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
        System.assertEquals(SOHeaderDetails1.contains('66'), true);
        System.assertEquals(SOHeaderDetails1.contains('133'), true);
        
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice = 120;
        Test.StopTest();

        String updatedSOKH = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));
		String SOHeaderDetails2 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
   		System.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
   		system.assertEquals(SOHeaderDetails2.contains('80'), true);
   	}
   	   	        /*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingFixedKitlineitemToSOTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 100, null, Part1.Id, 1, 100);		
    	
    	KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
    	kitHeaderLineItem1.Kit_Price__c = 100;
    	update kitHeaderLineItem1;
    	

    	
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 220);
        System.assertEquals(SOHeaderDetails1.contains('100'), true);
        System.assertEquals(SOHeaderDetails1.contains('120'), true);
        
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice = 130;

        String updatedSOKH = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));
		String SOHeaderDetails2 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
   		//System.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.FixedPrice, 230);
   		//system.assert(false, soHeaderDetailsObj2 );
   		system.assertEquals(SOHeaderDetails2.contains('130'), true);
   		//system.assertEquals(SOHeaderDetails2.contains('100'), true);
   	}
   	
   	
   	   	   	        /*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingFixedKitlineitemAndFixedKitHeaderToSOTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 100, null, Part1.Id, 1, 100);		
    	
    	KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
    	kitHeaderLineItem1.Kit_Price__c = 100;
    	update kitHeaderLineItem1;
    	kitHeader.Fixed_Price__c = 200;
    	kitHeader.Fixed_Price_Flag__c= true;
    	update kitHeader ;
    	

    	
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
        System.assertEquals(SOHeaderDetails1.contains('100'), true);
        
        
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice = 80;
        String updatedSOKH = BPUtility.getDecodedString(CustomerOrderCtrl.updateSOLineItems(BPUtility.getEncodedString(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0])), BPUtility.getEncodedString(coHeader.Id)));
		String SOHeaderDetails2 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
   		System.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
   		system.assertEquals(SOHeaderDetails2.contains('100'), true);
   	}
   	
   		   	   	        /*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingServiceKitToSOTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part1.Id, 1, null);		
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem2 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 10, labourCode.Id, null, 1, 10);		
    	
    	/*
    	KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
    	kitHeaderLineItem1.Kit_Price__c = 100;
    	update kitHeaderLineItem1;
    	
    	kitHeader.Fixed_Price__c = 200;
    	kitHeader.Fixed_Price_Flag__c= true;
    	update kitHeader ;
    	*/
    	
    	//System.assert(false, [SELect Id, Fixed_Price__c, Fixed_Price_Flag__c, Service_Kit__c FROM Kit_Header__c ]);
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 190);
        //System.assert(false, soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList);
        System.assertEquals(SOHeaderDetails1.contains('120'), true);
        System.assertEquals(SOHeaderDetails1.contains('60'), true);
        System.assertEquals(SOHeaderDetails1.contains('0'), true);
        
        
        
        /*soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice = 80;

        String updatedSOKH = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
		String SOHeaderDetails2 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
   		System.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
   		system.assertEquals(SOHeaderDetails2.contains('100'), true);*/
   	}
   	
   	/*
    * Name: updateSOKHLineItem
     * Desc: Test to update SOKH
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingServiceKitToSOTestA() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 1, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part1.Id, 1, null);		
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	Kit_Header_Line_Item__c kitHeaderLineItem2 = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 10, labourCode.Id, null, 1, 10);		
    	
    	/*
    	KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
    	kitHeaderLineItem1.Kit_Price__c = 100;
    	update kitHeaderLineItem1;
    	*/
    	
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	kitHeader.Fixed_Price__c = 200;
    	kitHeader.Fixed_Price_Flag__c= true;
    	update kitHeader ;
    	
    	
    	//System.assert(false, [SELect Id, Fixed_Price__c, Kit_Price__c, Qty_Needed__c FROM Kit_Header_Line_Item__c ]);
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
        System.assertEquals(SOHeaderDetails1.contains('125'), true);
        System.assertEquals(SOHeaderDetails1.contains('62.50'), true);
        System.assertEquals(SOHeaderDetails1.contains('12.50'), true);
        
        
        /*soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].KitPrice = 80;

        String updatedSOKH = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
		String SOHeaderDetails2 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
   		System.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.FixedPrice, 200);
   		system.assertEquals(SOHeaderDetails2.contains('100'), true);*/
   	}
   	
   	        /*
    * Name: RecalculationLogicOnAddingKitToSOCoverBugTest
     * Desc: Bug covered when kit is added to SO and total price for kit line item is not correct
     * @param: 
     * @return: 
    **/
     static testMethod void RecalculationLogicOnAddingKitToSOCoverBugTest() {
     	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'Average Cost', 20 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, 'TestPart1', vendor.Id, 'TestPart1', testCategory.Id, 5, 10, 25, 50, 50);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', defaultPriceLevel.Id, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        // fixed price flag for kit header is false and kit is service kit
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', null, false, true, unitMake.Id, unitModel.Id);
    	// fixed price and flag both are false for both line item 
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, null, null, Part.Id, 5, null);
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    			
    	
    	
    	
    	/*
    	String kitHeaderLineItem = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
    	String kitHeaderLineItem1 = ViewKitCtrl.insertKitLineItem(kitHeader.Id, part1.Id, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}', System.JSON.serialize(pageSort));
    	*/
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString('soHeader')));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
        
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.FixedPrice, 600);
        //System.assert(false, soHeaderDetailsObj1 );
        System.assertEquals(soHeaderDetailsObj1.SOList[0].SOHeaderInfo.Total, 600);
        
        list<Service_Order_Line_Item__c> solis = [select  Qty_Needed__c, Kit_Price__c,  Retail_Price__c, qty_committed__c, 	Total__c from Service_Order_Line_Item__c];
        
        system.assertEquals(solis[0].Total__c, 600);
        
        


   	}
   	
   	        /*
     * Name: SOCompleteFlowSpecialOrderBreakUp
     * Desc: Test to check SO Complete flow and special order breakup on partial receiving.
     * @param: 
     * @return: 
    **
     static testMethod void SOCompleteFlowSpecialOrderBreakUp() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        //Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
        //Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);    
        
        String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, 'soHeader');
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = CustomerOrderCtrl.addLineItems(part.Id, soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id, coHeader.Id, customer.Id);
        
        String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
        
        ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
        COLineItemTriggerHelper.isTriggerExecute = false;
        COTriggerHelper.isTriggerExecute = false;
        
        String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);
        String SOHeaderDetails2 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj2 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails2, SOHeaderWrapper.class);
        
        system.assertEquals(soHeaderDetailsObj2.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded, 500.00);
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        Test.StartTest();
        String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendor.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
   
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendor.Id, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
     
        
        VendorOrderReceivingCtrl_PartialTest.createExcessTestDataSpecialOrder(vendor.Id, vorId, voHeader.Id, part.Id, coHeader.Id);
        
        Test.StopTest();
    }*/
}