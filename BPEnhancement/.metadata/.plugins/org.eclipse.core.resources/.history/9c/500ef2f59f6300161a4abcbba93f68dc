/**
 * Author: Durga Singh
 * Since: August 6, 2015
 * Name: VendorOrderCtrlTest
 * Description: test Class for complete vendor order functionality .
**/
@isTest
private class VendorOrderCtrlTest {

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
																							
		
		system.runas(DefaultUser)	{
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
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        insert part;
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), 
        							 		BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        Test.stopTest();
        system.assertEquals(voLineItems.TotalLineItemGroups, 1);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 50);
		 }																									
   // }
    
         /**
     * Name: getPaginatedItemsForVOHeaderForCustomerTest 
     * Desc: Test to find Line item for customer.
     * @param: 
     * @return: 
    **/
    
    static testMethod void  getPaginatedItemsForVOHeaderForCustomerTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
       
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(true, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(true, Vendor.Id);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.getPaginatedItemsForVOHeader(BPUtility.getEncodedString('Customers'), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems.VOLineItemRequiredForCustomer[0].Need, 50);
		 
    } 
    /**
     * Name: getPaginatedItemsForVOHeaderForStocksTest
     * Desc: Test to find Line item for stock
     * @param: 
     * @return: 
    **/
    
    static testMethod void  getPaginatedItemsForVOHeaderForStocksTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.getPaginatedItemsForVOHeader(BPUtility.getEncodedString('Stocks'), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems.VOLineItemRequiredForStock[0].Need, 110);																							
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
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
     * Name: addVOLineItemFromSearchToAddTestA 
     * Desc: Test to add VOLineItem from search to add and part is part of package.
     * @param: 
     * @return: 
    **/
    
    static testMethod void  addVOLineItemFromSearchToAddTestA () {
     
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
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, Vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 120, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
         VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
        String LineItemFromAddToSearch1 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 60, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), false));
       	VendorOrderLineItemWrapper voLineItems21 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch1, VendorOrderLineItemWrapper.class);
       	
       	List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c];
       	
       	system.assertEquals(voliList[0].Qty_Needed__c, 60 );
       	system.assertEquals(voliList[1].Qty_Needed__c, 6 );
       	
       	List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	
       	system.assertEquals(partList[0].Qty_On_Order__c, 66 );
       	
       	
       	
        system.assertEquals(voLineItems21.VendorOrderLineItemGroupList[0].Need, 66);
        system.assertEquals(voLineItems21.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Need, 60);
        system.assertEquals(voLineItems21.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].IsExcess, false);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems2 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        
        //system.assert(false, voLineItems2 );
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList1[0].Qty_On_Order__c, 0);
																		
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
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
     * Name: groupAllVOLineItemTestA
     * Desc: Test to group all VOLineItems where VOLIs are created from COLI and search to add.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  groupAllVOLineItemTestA () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        /*part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 1;
        insert part;*/
		Test.StartTest();
		PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        Test.StopTest();
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 1, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
		//system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        system.assertEquals(voLineItems.TotalLineItemGroups, 1);																							
    }
    
            /**
     * Name: groupAllVOLineItemTestB
     * Desc: Test to group all VOLineItems from different customers.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  groupAllVOLineItemTestB () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Account customer1 = 	TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        

        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part.Id, 130);
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, Vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.TotalLineItemGroups, 1);
        system.assertEquals(voLineItems.TotalRequiredForStocks, 1);																							
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
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
     * Name: removeGroupFromOrderTest
     * Desc: Test to remove group from vendor order on part basis added from COLI
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  removeGroupFromOrderTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 1;
        insert part1;
        

        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part1.Id, 120);
        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        Test.startTest();
        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        
        List<CO_Line_Item__c> coli123 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli123[0].VO_Status__c, 'On Order');
        system.assertEquals(coli123[0].Status__c, 'Ordered');
        
        String partId = part.Id;
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:partId];
        system.assertEquals(partList[0].Qty_On_Order__c, 126);
        
        
        String similarlineitem1 = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part1.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem1, VendorOrderLineItemWrapper.class);
        
       	//Vendor_Order_Line_Item_Group__c vendorOrderGroup = TestUtil.createVendorOrderLineItemGroup(true, voHeader.Id, part.Id);
        //Vendor_Order_Line_Item_Group__c vendorOrderGroup1 = TestUtil.createVendorOrderLineItemGroup(true, voHeader.Id, part1.Id);
        
        String similarlineitem3 = BPUtility.getDecodedString(VendorOrderCtrl.removeGroupFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems2 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem3, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems2.TotalLineItemGroups, 1);				
        
        Test.stopTest();
        
        
        List<CO_Line_Item__c> coli1234 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli1234[0].VO_Status__c, null);
        system.assertEquals(coli1234[0].Status__c, 'Required');
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:part.Id];
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        																		
    }
    
    
                        /**
     * Name: removeGroupFromOrderTestA
     * Desc: Test to remove group from vendor order on part added from search to add. Part is also part of package.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  removeGroupFromOrderTestA () {
     
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
        Part.Packaged_Part__c = true ;
        Part.Package_Qty__c = 22 ;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;

        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
       	String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 120, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems );
        
        String similarlineitem3 = BPUtility.getDecodedString(VendorOrderCtrl.removeGroupFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem3, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems1.TotalLineItemGroups, 0);																				
    }
    
                            /**
     * Name: removeGroupFromOrderTestB
     * Desc: Test to remove group from vendor order on part added from search to add. Part does not belong to package.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  removeGroupFromOrderTestB () {
     
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

        
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
       	String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 120, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems );
        
        String similarlineitem3 = BPUtility.getDecodedString(VendorOrderCtrl.removeGroupFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem3, VendorOrderLineItemWrapper.class);
        system.assertEquals(voLineItems1.TotalLineItemGroups, 0);																				
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
     * Name: removeLineItemFromOrderTestA
     * Desc: Test to remove lineitem from vendor order where line item contains a packaged part.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  removeLineItemFromOrderTestA () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        List<CO_Line_Item__c> coli123 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli123[0].VO_Status__c, 'On Order');
        system.assertEquals(coli123[0].Status__c, 'Ordered');
        
        String partId = part.Id;
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:partId];
        system.assertEquals(partList[0].Qty_On_Order__c, 126);
        Test.StartTest();
        String similarlineitem1 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));																						
    	VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem1, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems1);
        system.assertEquals(voLineItems1.VendorOrderLineItemGroupList[0].Need, 110);
        
        List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c where Is_required_For_Customer__c = false AND Is_Excess__c = false];
        
        String similarlineitem2 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voliList[0].Id), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));																						
    	VendorOrderLineItemWrapper voLineItems2 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem2, VendorOrderLineItemWrapper.class);
      	//system.assert(false, voLineItems2);
      	Test.StopTest();
        system.assertEquals(voLineItems2.TotalLineItemGroups, 0);
        List<CO_Line_Item__c> coli1234 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli1234[0].VO_Status__c, null);
        system.assertEquals(coli1234[0].Status__c, 'Required');
        
        //String partId = part.Id;
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:partId];
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
        
    }
    
                               /**
     * Name: removeLineItemFromOrderTestB
     * Desc: Test to remove lineitem from vendor order where line item contains a packaged part and also removed isExcess quantity.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  removeLineItemFromOrderTestB () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        String similarlineitem1 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));																						
    	VendorOrderLineItemWrapper voLineItems1 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem1, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems1);
        system.assertEquals(voLineItems1.VendorOrderLineItemGroupList[0].Need, 110);
        
        String similarlineitem2 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[1].Id), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));																						
    	VendorOrderLineItemWrapper voLineItems2 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem2, VendorOrderLineItemWrapper.class);
      	//system.assert(false, voLineItems2);
        system.assertEquals(voLineItems2.TotalLineItemGroups, 0);
        
        
    }
    
        static testMethod void  removeLineItemFromOrderTestC () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        List<CO_Line_Item__c> coli123 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli123[0].VO_Status__c, 'On Order');
        system.assertEquals(coli123[0].Status__c, 'Ordered');
        
        String partId = part.Id;
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:partId];
        system.assertEquals(partList[0].Qty_On_Order__c, 126);
        
        
        
        Test.starttest();
       	
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 120, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
        
        List<Part__c> partList12 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList12[0].Qty_On_Order__c, 126);
       	
        
        VendorOrderLineItemWrapper voLineItems3 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
       	
       	
       	
       	List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c];
       	//system.assert(false, voliList);
       	system.assertEquals(voliList.size(), 4 );
       	

        String similarlineitem3 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems4 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem3, VendorOrderLineItemWrapper.class);
        
        //system.assert(false, voLineItems4 );
        
        List<Part__c> partList3 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	
       	system.assertEquals(partList3[0].Qty_On_Order__c, 110 );
       	
       	
       	Test.stopTest();
        
    }
    
    
                               /**
     * Name: qtyOnOrderLogicTest
     * Desc: Test to check qty on order when item added as this item only. further remove and check again on qty on order.
     * @param: 
     * @return: 
    **/
    
  static testMethod void  qtyOnOrderLogicTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        /*String similarlineitem = VendorOrderCtrl.groupAllSimilarVOLineItem(vendor.Id, part.Id, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        List<CO_Line_Item__c> coli123 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli123[0].VO_Status__c, 'On Order');
        system.assertEquals(coli123[0].Status__c, 'Ordered');
        
        String partId = part.Id;
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:partId];
        system.assertEquals(partList[0].Qty_On_Order__c, 126);*/
        
        
        
        Test.starttest();
        
        List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c where Is_required_For_Customer__c = true];
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 50, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voliList[0].Id), false));
        
        List<Part__c> partList12 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList12[0].Qty_On_Order__c, 16);
       	
       	voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c where Is_required_For_Customer__c = false AND Is_Excess__c = false];
       	String LineItemFromAddToSearch1 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 110, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voliList[0].Id), false));
       	
       	List<Part__c> partList123 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList123[0].Qty_On_Order__c, 126);
        
       	List<Vendor_Order_Line_Item__c> voliList1 = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c];
       	system.assertEquals(voliList1.size(), 3 );
       	
       	VendorOrderLineItemWrapper voLineItems3 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);	
        
        String similarlineitem3 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems3.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems3.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems4 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem3, VendorOrderLineItemWrapper.class);
        
        //system.assert(false, voLineItems4 );
        
        List<Part__c> partList3 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList3[0].Qty_On_Order__c, 110 );
       	
       	Test.stopTest();
        
    }
    
    
    
                               /**
     * Name: qtyOnOrderLogicTest
     * Desc: Test to check qty on order when item added as this item only AND from search to add. further remove and check again on qty on order.
     * @param: 
     * @return: 
    **/
    
  static testMethod void  qtyOnOrderLogicTestA () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        /*String similarlineitem = VendorOrderCtrl.groupAllSimilarVOLineItem(vendor.Id, part.Id, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        List<CO_Line_Item__c> coli123 = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c];
        system.assertEquals(coli123[0].VO_Status__c, 'On Order');
        system.assertEquals(coli123[0].Status__c, 'Ordered');
        
        String partId = part.Id;
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c where Id =:partId];
        system.assertEquals(partList[0].Qty_On_Order__c, 126);*/
        
        
        
        Test.starttest();
        
        List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c where Is_required_For_Customer__c = true];
       	//system.assert(false, voliList);
       	
        String LineItemFromAddToSearch = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 50, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voliList[0].Id), false));
        
        List<Part__c> partList12 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList12[0].Qty_On_Order__c, 16);
       	
       	
       	voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c where Is_required_For_Customer__c = false AND Is_Excess__c = false];
       	String LineItemFromAddToSearch1 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 110, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(voliList[0].Id), false));
       	
       	List<Part__c> partList123 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList123[0].Qty_On_Order__c, 126);
       	
       		
       	String LineItemFromAddToSearch2 = BPUtility.getDecodedString(VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), 1, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(null), true));
       	
       	List<Part__c> partList1234 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	system.assertEquals(partList1234[0].Qty_On_Order__c, 126);
        
        VendorOrderLineItemWrapper voLineItems3 = (VendorOrderLineItemWrapper) System.JSON.deserialize(LineItemFromAddToSearch, VendorOrderLineItemWrapper.class);
       	
       	
       	
       	List<Vendor_Order_Line_Item__c> voliList1 = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c];
       	//system.assert(false, voliList);
       	system.assertEquals(voliList1.size(), 4 );
       	
        Test.stopTest();
        String similarlineitem3 = BPUtility.getDecodedString(VendorOrderCtrl.removeLineItemFromOrder(BPUtility.getEncodedString(voLineItems3.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[0].Id), BPUtility.getEncodedString(voLineItems3.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderLineItemWrapper voLineItems4 = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem3, VendorOrderLineItemWrapper.class);
        
        //system.assert(false, voLineItems4 );
        
        List<Part__c> partList3 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
       	
       	system.assertEquals(partList3[0].Qty_On_Order__c, 110);
       	
       	
        
    }
                                   /**
     * Name: getGroupRecDetailTest
     * Desc: Test to get details about group record
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  getGroupRecDetailTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        String voGroupDetails = BPUtility.getDecodedString(VendorOrderCtrl.getGroupRecDetail(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id), BPUtility.getEncodedString(voHeader.Id)));																						
    	List<VendorOrderCtrl.VOGroupDetail> voGroupDetailsList = (List<VendorOrderCtrl.VOGroupDetail>) System.JSON.deserialize(voGroupDetails, List<VendorOrderCtrl.VOGroupDetail>.class);
        system.assertEquals(voGroupDetailsList[0].OrderQty, 176);
        system.assertEquals(voGroupDetailsList[0].RequriedForCustomer, 50);
        system.assertEquals(voGroupDetailsList[0].RequriedForStock, 110);
        system.assertEquals(voGroupDetailsList[0].TotalExcess, 16);
        system.assertEquals(voGroupDetailsList[0].TotalRequried, 160);
        }
        
        
                                           /**
     * Name: getStockRecDetailTest
     * Desc: Test to get details about stock
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  getStockRecDetailTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        //system.assert(false, voLineItems);
        system.assertEquals(voLineItems.VendorOrderLineItemGroupList[0].Need, 176);
        
        String stockRecDetails = BPUtility.getDecodedString(VendorOrderCtrl.getStockRecDetail(BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].VendorOrderLineItemList[1].Id)));																						
    	List<VendorOrderCtrl.StockRecDetail> stockRecDetailsList = (List<VendorOrderCtrl.StockRecDetail>) System.JSON.deserialize(stockRecDetails, List<VendorOrderCtrl.StockRecDetail>.class);
        //system.assert(false, stockRecDetailsList);
        system.assertEquals(stockRecDetailsList[0].AutoReprderAt, 0);
        system.assertEquals(stockRecDetailsList[0].AutoReprderTo, 100);
        system.assertEquals(stockRecDetailsList[0].PackageQty, 5);
        system.assertEquals(stockRecDetailsList[0].TotalNeed, 110);
        }
        
                                                   /**
     * Name: getPartByPartIdTest
     * Desc: Test to get details about part and other object like coHeader
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  getPartByPartIdTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String similarlineitem = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        String partdetails = BPUtility.getDecodedString(VendorOrderCtrl.getPartByPartId(BPUtility.getEncodedString(Part.Id)));
        String coHeaderDetails = BPUtility.getDecodedString(VendorOrderCtrl.getCoHeaderById(BPUtility.getEncodedString(coHeader.Id)));																				
        system.assertEquals(partdetails.contains('partNumberP01'), true);
        system.assertEquals(coHeaderDetails.contains('customerName'), true);
        }
        
                                                           /**
     * Name: updateVOHederOrderTypeTest 
     * Desc: Test to update VoHeadertype
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void  updateVOHederOrderTypeTest () {
     
     	VendorPaginationSorting pageSort = new VendorPaginationSorting();
        pageSort.ChangesCount = 0;
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        //System.JSON.serialize(pageSort)
        General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
        

        String updatedVoHeaderType = BPUtility.getDecodedString(VendorOrderCtrl.updateVOHederOrderType(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(POType.Id), BPUtility.getEncodedString('Open')));
        
        String updatedVoHeaderType1 = BPUtility.getDecodedString(VendorOrderCtrl.updateVOHederOrderType(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(POType.Id), BPUtility.getEncodedString('Locked')));
        //system.assert(false, updatedVoHeaderType1);
        system.assertEquals(updatedVoHeaderType1, POType.Id);
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
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
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
}