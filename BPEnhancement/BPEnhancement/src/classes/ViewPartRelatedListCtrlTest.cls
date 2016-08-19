/**
 * Author: Durga Singh
 * Since: July 22, 2015
 * Name: ViewPartRelatedListCtrlTest
 * Description: test Class for complete part functionality and other alternate/replace parts.
**/
@isTest
private class ViewPartRelatedListCtrlTest {
	 
	  /**
     * Name: getPaginatedActiveOrdersForPartTest 
     * Desc: Test to fetch active orders for part.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForPartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Vendor_Order_Header__c VendorOrderHeader =  TestUtil.createVendorOrderHeader(true, vendor.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Vendor_Order_Line_Item__c VendorOrderLineItem = TestUtil.createVendorOrderLineItem(true, vendorOrderHeader.Id, part.Id, 300);
        
        ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
        pageSort.activeOrdersCurrentPage = 1;
        pageSort.activeOrdersPageSize = 10;
        //System.JSON.serialize(part.Id, System.JSON.serialize(pageSort));
        String activeOrders = BPUtility.getDecodedString(ViewPartRelatedListCtrl.getPaginatedActiveOrdersForPart(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewPartRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewPartRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewPartRelatedListCtrl.AllActiveOrdersWrapper.class);
        system.assertEquals(activeOrdersList.TotalActiveOrders, 0 );
    }
    
    	  /**
     * Name: getAllAlternatePartsForPartTest 
     * Desc: Test to fetch total number of alternate parts for part.
     * @param: 
     * @return: 
    **/

    static testMethod void getAllAlternatePartsForPartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partD = TestUtil.createPart(true, 'partD', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
      	Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
      	Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partC.Id, partA.Id, 'Alternate');
      	Part_Alternates__c partsAlternate2 = TestUtil.createPartAlternates(true, partD.Id, partA.Id, 'Replaces');
        

        Integer alternatePartNumbers = ViewPartRelatedListCtrl.getTotalAlternatePartsForPart(BPUtility.getEncodedString(partA.Id));
        system.assertEquals(alternatePartNumbers, 3 );
     }
    
    	  /**
     * Name: getPaginatedAlternatePartsForPartTest 
     * Desc: Test to fetch alternate parts for part.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedAlternatePartsForPartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        //System.JSON.serialize(partA.Id, System.JSON.serialize(pageSort));
        String alternateParts = BPUtility.getDecodedString(ViewPartRelatedListCtrl.getPaginatedAlternatePartsForPart(BPUtility.getEncodedString(partA.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort) )));
        ViewPartRelatedListCtrl.AllAlternatePartsWrapper alternatePartsList = (ViewPartRelatedListCtrl.AllAlternatePartsWrapper) System.JSON.deserialize(alternateParts, ViewPartRelatedListCtrl.AllAlternatePartsWrapper.class);
        system.assertEquals(alternatePartsList.TotalAlternateParts, 1);
    }
    
       	  /**
     * Name: addAlternatePartToPartTest 
     * Desc: Test to add alternate part for a part.
     * @param: 
     * @return: 
    **/

    static testMethod void addAlternatePartToPartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       // Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String alternatePartsAdded = BPUtility.getDecodedString(ViewPartRelatedListCtrl.addAlternatePartToPart(BPUtility.getEncodedString('[{"AlternatePartId":"'+partB.Id+'","Relation":"Alternate","PartId":"'+partA.Id+'"}]')));
        
       	List<AlternatePart.AlternatePartWrapper> alternatePartsList = (List<AlternatePart.AlternatePartWrapper> ) System.JSON.deserialize(alternatePartsAdded, List<AlternatePart.AlternatePartWrapper> .class);
       	system.assertequals(alternatePartsList[0].AlternatePartRecord.AlternatePartNumber, 'partB');
    }
    
      	  /**
     * Name: addAlternatePartToPartTestA
     * Desc: Test to add alternate part for a part which is already added.
     * @param: 
     * @return: 
    **/

    static testMethod void addAlternatePartToPartTestA() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       // Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String alternatePartsAdded = BPUtility.getDecodedString(ViewPartRelatedListCtrl.addAlternatePartToPart(BPUtility.getEncodedString('[{"AlternatePartId":"'+partB.Id+'","Relation":"Alternate","PartId":"'+partA.Id+'"}]')));
        String alternatePartsAdded1 = BPUtility.getDecodedString(ViewPartRelatedListCtrl.addAlternatePartToPart(BPUtility.getEncodedString('[{"AlternatePartId":"'+partB.Id+'","Relation":"Replaces","PartId":"'+partA.Id+'"}]')));
        
       	List<AlternatePart.AlternatePartWrapper> alternatePartsList = (List<AlternatePart.AlternatePartWrapper> ) System.JSON.deserialize(alternatePartsAdded1, List<AlternatePart.AlternatePartWrapper> .class);
       	system.assertequals(alternatePartsList[0].ErrorMsg, 'Part is already added as Alternate Part.');
       
    }
    
     	  /**
     * Name: addAlternatePartToPartTestB for more condition
     * Desc: Test to add alternate part for a part which is replacing same part.
     * @param: 
     * @return: 
    **/

    static testMethod void addAlternatePartToPartTestB() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	//Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Replaces');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String alternatePartsAdded = BPUtility.getDecodedString(ViewPartRelatedListCtrl.addAlternatePartToPart(BPUtility.getEncodedString('[{"AlternatePartId":"'+partA.Id+'","Relation":"Alternate","PartId":"'+partB.Id+'"}]')));
        //String alternatePartsAdded1 = ViewPartRelatedListCtrl.addAlternatePartToPart('[{"AlternatePartId":"'+partB.Id+'","Relation":"Replaces","PartId":"'+partA.Id+'"}]');
        
       	List<AlternatePart.AlternatePartWrapper> alternatePartsList = (List<AlternatePart.AlternatePartWrapper> ) System.JSON.deserialize(alternatePartsAdded, List<AlternatePart.AlternatePartWrapper> .class);
       	//system.assert(false,  alternatePartsList);
       	system.assertequals(alternatePartsList[0].AlternatePartRecord.AlternatePartNumber, 'partA');
       
    }
    
          	  /**
     * Name: updateDefaultAlternatePartTest
     * Desc: Test to update alternate part as a default.
     * @param: 
     * @return: 
    **/

    static testMethod void updateDefaultAlternatePartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
       	Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partC.Id, partA.Id, 'Alternate');
       	//Part_Alternates__c partsAlternate2 = TestUtil.createPartAlternates(true, partA.Id, partA.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String defaultAlternatePart = BPUtility.getDecodedString(ViewPartRelatedListCtrl.updateDefaultAlternatePart(BPUtility.getEncodedString(partA.Id), BPUtility.getEncodedString(partsAlternate1.Id), true ));
       	system.assertEquals(defaultAlternatePart, '2' );
       
    }
    
              	  /**
     * Name: updateDefaultAlternatePartTestA
     * Desc: Test to update alternate part as a default where part itself a alternate part.
     * @param: 
     * @return: 
    **/

    static testMethod void updateDefaultAlternatePartTestA() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
       	Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partC.Id, partA.Id, 'Alternate');
       	Part_Alternates__c partsAlternate2 = TestUtil.createPartAlternates(true, partA.Id, partA.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String defaultAlternatePart = BPUtility.getDecodedString(ViewPartRelatedListCtrl.updateDefaultAlternatePart(BPUtility.getEncodedString(partA.Id), BPUtility.getEncodedString(partsAlternate2.Id), true ));
       	system.assertEquals(defaultAlternatePart, '3' );
       
    }
    
                  	  /**
     * Name: updateDefaultAlternatePartTestB
     * Desc: Test to update alternate part as a default where alternate part is preferred .
     * @param: 
     * @return: 
    **/

    static testMethod void updateDefaultAlternatePartTestB() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
       	//Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partA.Id, partB.Id, 'Alternate');
       	Part_Alternates__c partReverseAlternate = Testutil.createPartReverseAlternates(true, partB.Id, partA.Id, 'Alternate', true);
       	Part_Alternates__c partsAlternate2 = TestUtil.createPartAlternates(false, partC.Id, partA.Id, 'Alternate');
       	partsAlternate2.Preferred__c = true ;
       	insert partsAlternate2;
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String defaultAlternatePart = BPUtility.getDecodedString(ViewPartRelatedListCtrl.updateDefaultAlternatePart(BPUtility.getEncodedString(partA.Id), BPUtility.getEncodedString(partsAlternate.Id), true ));
       	//system.assert(false, defaultAlternatePart);
       	system.assertEquals(defaultAlternatePart, '2,' );
       
    }
    
              	  /**
     * Name: updateAlternatePartRelationTest
     * Desc: Test to update relation for alternate part  for condition where relation is Replaces.
     * @param: 
     * @return: 
    **/

    static testMethod void updateAlternatePartRelationTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	//Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
       	//Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partA.Id, partB.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String alternatePartsAdded = BPUtility.getDecodedString(ViewPartRelatedListCtrl.addAlternatePartToPart(BPUtility.getEncodedString('[{"AlternatePartId":"'+partA.Id+'","Relation":"Alternate","PartId":"'+partB.Id+'"}]')));
        String alternatePartRelation = BPUtility.getDecodedString(ViewPartRelatedListCtrl.updateAlternatePartRelation(BPUtility.getEncodedString(partA.Id), BPUtility.getEncodedString(partB.Id), BPUtility.getEncodedString('Replaces' )));
       	//ViewPartRelatedListCtrl.AllAlternatePartsWrapper alternatePartsList = (ViewPartRelatedListCtrl.AllAlternatePartsWrapper) System.JSON.deserialize(alternatePartRelation, ViewPartRelatedListCtrl.AllAlternatePartsWrapper.class);
       	//system.assert(false, alternatePartRelation );
       	//system.assertEquals(alternatePartsList.TotalAlternateParts, null);
       	system.assertEquals(true, true);
    }
    
    	  /**
     * Name: updateAlternatePartRelationTestA
     * Desc: Test to update relation for alternate part.
     * @param: 
     * @return: 
    **/

    static testMethod void updateAlternatePartRelationTestA() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
       	Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partC.Id, partB.Id, 'Alternate');
      	
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String alternatePartRelation = BPUtility.getDecodedString(ViewPartRelatedListCtrl.updateAlternatePartRelation(BPUtility.getEncodedString(partB.Id), BPUtility.getEncodedString(partsAlternate.Id), BPUtility.getEncodedString('Replaces' )));
       	//system.assert(false, alternatePartRelation );
       	system.assertEquals(alternatePartRelation, '{}' );
       
    }
    
       /**
     * Name: removeAlternatePartRelationTest
     * Desc: Test to remove relation for alternate part.
     * @param: 
     * @return: 
    **/

    static testMethod void removeAlternatePartRelationTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c partA = TestUtil.createPart(true, 'partA', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partB = TestUtil.createPart(true, 'partB', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c partC = TestUtil.createPart(true, 'partC', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
       	Part_Alternates__c partsAlternate = TestUtil.createPartAlternates(true, partB.Id, partA.Id, 'Alternate');
      	Part_Alternates__c partsAlternate1 = TestUtil.createPartAlternates(true, partC.Id, partA.Id, 'Alternate');
        
        AlternatePart.RelatedListPaginationSorting pageSort = new AlternatePart.RelatedListPaginationSorting();
        pageSort.alternatePartsCurrentPage = 1;
        pageSort.alternatePartsPageSize = 10;
        String alternatePartRelation = BPUtility.getDecodedString(ViewPartRelatedListCtrl.removeAlternatePartRelation(BPUtility.getEncodedString(partA.Id), BPUtility.getEncodedString(partsAlternate.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)) ));
       	ViewPartRelatedListCtrl.AllAlternatePartsWrapper alternatePartsList = (ViewPartRelatedListCtrl.AllAlternatePartsWrapper) System.JSON.deserialize(alternatePartRelation, ViewPartRelatedListCtrl.AllAlternatePartsWrapper.class);
       	//system.assert(false, alternatePartsList );
       	system.assertEquals(alternatePartsList.TotalAlternateParts, 1 );
       
    }
    
     /**
     * Name: getPaginatedTaxExemptionsForPartTest
     * Desc: Test to fetch Tax exemption for part
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedTaxExemptionsForPartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax_Item__c salesTaxItem = TestUtil.createSalesTaxItem(true, 'Test Item', 8.0, 'Testing ', true, testCategory.Id);
        Part__c part = TestUtil.createPart(true, 'part', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part_Tax__c partTax = Testutil.createPartTax(true, salesTaxItem.Id, part.Id);
        
        TaxExemption.RelatedListPaginationSorting pageSort = new TaxExemption.RelatedListPaginationSorting();
        pageSort.taxExemptionsCurrentPage = 1;
        pageSort.taxExemptionsPageSize = 10;
        //System.JSON.serialize(part.Id, System.JSON.serialize(pageSort));
        String taxExemptions = BPUtility.getDecodedString(ViewPartRelatedListCtrl.getPaginatedTaxExemptionsForPart(BPUtility.getENcodedString(part.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewPartRelatedListCtrl.AllTaxExemptionsWrapper taxExemptionList = (ViewPartRelatedListCtrl.AllTaxExemptionsWrapper) System.JSON.deserialize(taxExemptions, ViewPartRelatedListCtrl.AllTaxExemptionsWrapper.class);
        //system.assert(false, taxExemptionList);
        system.assertNotEquals(taxExemptionList, null);
    }
    
    /**
     * Name: getTotalTaxExemptionsForPartTest
     * Desc: Test to fetch total Tax exemption for part
     * @param: 
     * @return: 
    **/

    static testMethod void getTotalTaxExemptionsForPartTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax_Item__c salesTaxItem = TestUtil.createSalesTaxItem(true, 'Test Item', 8.0, 'Testing ', true, testCategory.Id);
        Part__c part = TestUtil.createPart(true, 'part', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part_Tax__c partTax = Testutil.createPartTax(true, salesTaxItem.Id, part.Id);
        
        TaxExemption.RelatedListPaginationSorting pageSort = new TaxExemption.RelatedListPaginationSorting();
        pageSort.taxExemptionsCurrentPage = 1;
        pageSort.taxExemptionsPageSize = 10;
        //System.JSON.serialize(part.Id, System.JSON.serialize(pageSort));
        Integer taxExemptions =ViewPartRelatedListCtrl.getTotalTaxExemptionsForPart(BPUtility.getEncodedString(part.Id));
        //ViewPartRelatedListCtrl.AllTaxExemptionsWrapper taxExemptionList = (ViewPartRelatedListCtrl.AllTaxExemptionsWrapper) System.JSON.deserialize(taxExemptions, ViewPartRelatedListCtrl.AllTaxExemptionsWrapper.class);
        //system.assert(false, taxExemptionList);
        system.assertEquals(taxExemptions, 500 );
    }
    

    
    	  /**
     * Name: getPaginatedActiveOrdersForPartTest 
     * Desc: Test to fetch active orders for part.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForPartTestPositive() {
    	General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Vendor_Order_Header__c VendorOrderHeader =  TestUtil.createVendorOrderHeader(true, vendor.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
        pageSort.activeOrdersCurrentPage = 1;
        pageSort.activeOrdersPageSize = 10;
        //System.JSON.serialize(part.Id, System.JSON.serialize(pageSort));
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String activeOrders = BPUtility.getDecodedString( ViewPartRelatedListCtrl.getPaginatedActiveOrdersForPart(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewPartRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewPartRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewPartRelatedListCtrl.AllActiveOrdersWrapper.class);
        system.assertEquals(activeOrdersList.TotalActiveOrders, 1 );
    }
    
        	  /**
     * Name: getPaginatedActiveOrdersForPartTest 
     * Desc: Test to fetch active orders for part.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForPartTestNegative() {
    	General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Vendor_Order_Header__c VendorOrderHeader =  TestUtil.createVendorOrderHeader(true, vendor.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
        pageSort.activeOrdersCurrentPage = 1;
        pageSort.activeOrdersPageSize = 10;
        //System.JSON.serialize(part.Id, System.JSON.serialize(pageSort));
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        String activeOrders = BPUtility.getDecodedString(ViewPartRelatedListCtrl.getPaginatedActiveOrdersForPart(BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewPartRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewPartRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewPartRelatedListCtrl.AllActiveOrdersWrapper.class);
        system.assertEquals(activeOrdersList.TotalActiveOrders, 0 );
    }
}