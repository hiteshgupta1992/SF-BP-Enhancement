/**
 * Author: Durga Singh
 * Since: July 29, 2015
 * Name: ViewVendorRelatedListCtrlTest
 * Description: test Class for complete vendor functionality and other related PO, Contacts, products.
**/
@isTest
private class ViewVendorRelatedListCtrlTest {

 /**
     * Name: getVendorContactByIdTest 
     * Desc: Test to fetch vendor's contact.
     * @param: 
     * @return: 
    **/
    static testMethod void getVendorContactByIdTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        Contact contact = TestUtil.createContact(true, 'firstName', 'lastName', vendor.Id);
        
        String contactInformation = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getVendorContactById(BPUtility.getEncodedString(contact.Id)));
        
        List<VendorContact> contactInformationList = (List<VendorContact>) System.JSON.deserialize(contactInformation, List<VendorContact>.class);  
        system.assertEquals(contactInformationList[0].Firstname, 'firstName');
    }
      
     /**
     * Name: updateContactRelationTest 
     * Desc: Test to update realtionship for vendor's contact.
     * @param: 
     * @return: 
    **/
    
     static testMethod void updateContactRelationTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        Contact contact = TestUtil.createContact(false, 'firstName', 'lastName', vendor.Id);
        contact.Relationship__c = 'Friend';
        insert contact ;
        
        String contactRelationship = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.updateContactRelation(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(contact.Id), BPUtility.getEncodedString('Family')));
        //system.assert(false, contactRelationship);
        system.assertEquals(contactRelationship, '1');
    }
    
     /**
     * Name: removeContactTest 
     * Desc: Test to remove contact from vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removeContactTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        Contact contact = TestUtil.createContact(true, 'firstName', 'lastName', vendor.Id);
        
        VendorContact.RelatedListPaginationSorting pageSort = new VendorContact.RelatedListPaginationSorting();
        pageSort.contactsCurrentPage = 1;
        pageSort.contactsPageSize = 10;
        
        String contactRelationship = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.removeContact(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(contact.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllContactsWrapper contactInformationList = (ViewVendorRelatedListCtrl.AllContactsWrapper) System.JSON.deserialize(contactRelationship, ViewVendorRelatedListCtrl.AllContactsWrapper.class);
        //system.assert(false, contactInformationList);
        system.assertEquals(contactInformationList.TotalContacts, 0);
    }
    
    /**
     * Name: getPaginatedContactsForVendorTest 
     * Desc: Test to getPaginatedContactsForVendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getPaginatedContactsForVendorTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        
        
        for(Integer i=0;i<23;i++) {
         Contact contact = TestUtil.createContact(true, 'firstName '+i, 'lastName'+i, vendor.Id);
        }
        
        VendorContact.RelatedListPaginationSorting pageSort = new VendorContact.RelatedListPaginationSorting();
        pageSort.contactsCurrentPage = 1;
        pageSort.contactsPageSize = 10;
        
        String contacts = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedContactsForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllContactsWrapper contactsList = (ViewVendorRelatedListCtrl.AllContactsWrapper) System.JSON.deserialize(contacts, ViewVendorRelatedListCtrl.AllContactsWrapper.class);
        system.assertEquals(contactsList.TotalContacts, 23);
        system.assertEquals(contactsList.Contacts.size(), 10);
    }
    
     /**
     * Name: saveVendorContactTest 
     * Desc: Test to save vendor contact.
     * @param: 
     * @return: 
    **/
    
     static testMethod void saveVendorContactTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	
        
        String contacts = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.saveVendorContact(BPUtility.getEncodedString('[{"PreferredEmail":false,"PreferredPhone":false,"PreferredSMS":false,"IsSMS":false,"ParentVendor":"'+vendor.Id+'","FirstName":"firstcontact","LastName":"lastcontact","Relation":"Friend"}]')));
        List<VendorContact.VendorContactWrapper> contactsList = (List<VendorContact.VendorContactWrapper>) System.JSON.deserialize(contacts, List<VendorContact.VendorContactWrapper>.class);
        //system.assert(false, contactsList);
        system.assertEquals(contactsList[0].ContactRecord.Firstname, 'firstcontact');
        String contacts1 = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.saveVendorContact(BPUtility.getEncodedString('[{"PreferredEmail":false,"PreferredPhone":false,"PreferredSMS":false,"IsSMS":false,"ParentVendor":"'+vendor.Id+'","FirstName":"firstcontact","LastName":"lastcontact","Relation":"Friend", "Id":"'+contactsList[0].ContactRecord.Id+'"}]')));
        
    }
    
     /**
     * Name: getPaginatedActiveOrdersForVendorTest
     * Desc: Test to fetch active orders for vendor.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForVendorTest() {
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
        String activeOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedActiveOrdersForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewVendorRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewVendorRelatedListCtrl.AllActiveOrdersWrapper.class);
        
        
        system.assertEquals(activeOrdersList.TotalActiveOrders, 1 );
    }
    
    /**
     * Name: getProductInfoByIdTest 
     * Desc: Test to fetch product information.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getProductInfoByIdTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
       	Product__c product = TestUtil.createproduct(true, testCategory.Id, 'product', vendor.Id );
        
        String vendorProducts = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getProductInfoById(BPUtility.getEncodedString(product.Id)));
        List<VendorProduct> productList = (List<VendorProduct>) System.JSON.deserialize(vendorProducts, List<VendorProduct>.class);
        //system.assert(false, productList);
       	system.assertEquals(productList[0].Code, 'product');
        
    }
    
    /**
     * Name: getPaginatedProductsForVendorTest
     * Desc: Test to fetch product for a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getPaginatedProductsForVendorTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
       	Product__c product = TestUtil.createproduct(true, testCategory.Id, 'product', vendor.Id );
       	
       	Vendorproduct.RelatedListPaginationSorting pageSort = new Vendorproduct.RelatedListPaginationSorting();
        pageSort.productsCurrentPage = 1;
        pageSort.productsPageSize = 10;
        
        String vendorProducts = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedProductsForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllProductsWrapper productList = (ViewVendorRelatedListCtrl.AllProductsWrapper) System.JSON.deserialize(vendorProducts, ViewVendorRelatedListCtrl.AllProductsWrapper.class);
        //system.assert(false, productList);
       	system.assertEquals(productList.TotalProducts, 1);
       	system.assertEquals(productList.Products.size(), 1);
        
     }   

  /**
     * Name: removeProductTest
     * Desc: Test to remove product from a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removeProductTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
       	Product__c product = TestUtil.createproduct(true, testCategory.Id, 'product', vendor.Id );
       	
       	Vendorproduct.RelatedListPaginationSorting pageSort = new Vendorproduct.RelatedListPaginationSorting();
        pageSort.productsCurrentPage = 1;
        pageSort.productsPageSize = 10;
        
        String vendorProducts = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.removeProduct(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(product.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllProductsWrapper productList = (ViewVendorRelatedListCtrl.AllProductsWrapper) System.JSON.deserialize(vendorProducts, ViewVendorRelatedListCtrl.AllProductsWrapper.class);
        //system.assert(false, productList);
       	system.assertEquals(productList.TotalProducts, 0);
       	system.assertEquals(productList.Products.size(), 0);
        
     }  
     
      /**
     * Name: getSystemDefaultCategoryTest
     * Desc: Test to fetch default category for a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getSystemDefaultCategoryTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
       	Product__c product = TestUtil.createproduct(true, testCategory.Id, 'product', vendor.Id );

        
        String defaultCategory = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getSystemDefaultCategory(BPUtility.getEncodedString(vendor.Id)));
       	//system.assertEquals(defaultCategory.contains('Test Category'), true);
        system.assertEquals(defaultCategory.contains('Test Category'), false);
        
     } 
     
      /**
     * Name: addUpdateProductToVendorTest
     * Desc: Test to add and update product for a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void addUpdateProductToVendorTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        
        String vendorProducts = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.addUpdateProductToVendor(BPUtility.getEncodedString('[{"vendorId":"'+vendor.Id+'","CategoryId":"'+testCategory.Id+'","CategoryName":"Part_B1_Category","Type":"Sublet","Code":"testcode","Cost":"10.000","Price":"100.000"}]')));
       	List<VendorProduct.ProductWrapper> productList = (List<VendorProduct.ProductWrapper>) System.JSON.deserialize(vendorProducts, List<VendorProduct.ProductWrapper>.class);
       	//system.assert(false, productList);
       	system.assertEquals(productList[0].ProductRecord.Code, 'testcode');
       	String vendorProducts1 = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.addUpdateProductToVendor(BPUtility.getEncodedString('[{"vendorId":"'+vendor.Id+'","CategoryId":"'+testCategory.Id+'","CategoryName":"Part_B1_Category","Type":"Sublet","Code":"testcode","Cost":"10.000","Price":"100.000", "Id":"'+productList[0].ProductRecord.Id+'"}]')));
        } 
        
        /**
     * Name: getPOTypeInfoByIdTest 
     * Desc: Test to fetch purchase order info for a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getPOTypeInfoByIdTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	PO_Type__c purchaseOrder = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        
        String purchaseOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPOTypeInfoById(BPUtility.getEncodedString(purchaseOrder.Id)));
        List<POType> purchaseOrderList = (List<POType>) System.JSON.deserialize(purchaseOrders, List<POType>.class);
        //system.assert(false, productList);
       	system.assertEquals(purchaseOrderList[0].Code, 'purchaseOrderCode');
        
    }
    
            /**
     * Name: getPaginatedPOTypesForVendorTest 
     * Desc: Test to fetch purchase order info for a vendor on page.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getPaginatedPOTypesForVendorTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	for(Integer i=0;i<23;i++) {
       	PO_Type__c purchaseOrder = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode'+i, vendor.Id, true, 2);
       	}
       	
       	POType.RelatedListPaginationSorting pageSort = new POType.RelatedListPaginationSorting();
        pageSort.poTypesCurrentPage = 1;
        pageSort.poTypesPageSize = 10;
        String purchaseOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedPOTypesForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort) )));
        ViewVendorRelatedListCtrl.AllPOTypesWrapper purchaseOrderList = (ViewVendorRelatedListCtrl.AllPOTypesWrapper) System.JSON.deserialize(purchaseOrders, ViewVendorRelatedListCtrl.AllPOTypesWrapper.class);
        //system.assert(false, productList);
       	system.assertEquals(purchaseOrderList.TotalPOTypes, 24);
        system.assertEquals(purchaseOrderList.POTypes.size(), 10);
        
    }
    
                /**
     * Name: removePOTypeTest 
     * Desc: Test to remove purchase order from vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removePOTypeTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
       	
       	PO_Type__c purchaseOrder = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
       	PO_Type__c purchaseOrder1 = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode1', vendor.Id, true, 2);
       	
       	
       	POType.RelatedListPaginationSorting pageSort = new POType.RelatedListPaginationSorting();
        pageSort.poTypesCurrentPage = 1;
        pageSort.poTypesPageSize = 10;
        String purchaseOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.removePOType(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(purchaseOrder.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))) );
        ViewVendorRelatedListCtrl.AllPOTypesWrapper purchaseOrderList = (ViewVendorRelatedListCtrl.AllPOTypesWrapper) System.JSON.deserialize(purchaseOrders, ViewVendorRelatedListCtrl.AllPOTypesWrapper.class);
        //system.assert(false, productList);
       	system.assertEquals(purchaseOrderList.TotalPOTypes, 2);
        system.assertEquals(purchaseOrderList.POTypes.size(), 2);
        
    }
    
                    /**
     * Name: addUpdatePOTypeToVendorTest
     * Desc: Test to add/update purchase order for a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void addUpdatePOTypeToVendorTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');

        String purchaseOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.addUpdatePOTypeToVendor(BPUtility.getEncodedString('[{"vendorId":"'+vendor.Id+'","Code":"poCode","LeadTime":"2","Discount":"15","LandedCostAdjustment":"12","Usage":"brakes"}]')));
        List<POType.POTypeWrapper> purchaseOrderList = (List<POType.POTypeWrapper>) System.JSON.deserialize(purchaseOrders, List<POType.POTypeWrapper>.class);
        //system.assert(false, productList);
       	system.assertEquals(purchaseOrderList[0].POTypeRecord.code, 'poCode');
       	String purchaseOrders1 = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.addUpdatePOTypeToVendor(BPUtility.getEncodedString('[{"vendorId":"'+vendor.Id+'","Code":"poCode","LeadTime":"2","Discount":"15","LandedCostAdjustment":"12","Usage":"brakes","Id":"'+purchaseOrderList[0].POTypeRecord.Id+'"}]')));
        
    }
    
      /**
     * Name: updateDefaultPOTypeTest
     * Desc: Test to change default purchase order for a vendor.
     * @param: 
     * @return: 
    **/
    
     static testMethod void updateDefaultPOTypeTest() {
        Account vendor = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, true, false,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        
        PO_Type__c purchaseOrder = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
       	PO_Type__c purchaseOrder1 = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode1', vendor.Id, false, 2);

        String purchaseOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.updateDefaultPOType(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(purchaseOrder1.Id), true ));
       	system.assertEquals(purchaseOrders, '3,');
        
    }
    
         /**
     * Name: getPaginatedActiveOrdersForVendorTestA
     * Desc: Test to fetch active orders for vendor.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForVendorTestPositive() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Vendor_Order_Header__c VendorOrderHeader =  TestUtil.createVendorOrderHeader(true, vendor.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        
        ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
        pageSort.activeOrdersCurrentPage = 1;
        pageSort.activeOrdersPageSize = 10;
        String activeOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedActiveOrdersForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewVendorRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewVendorRelatedListCtrl.AllActiveOrdersWrapper.class);

        
        system.assertEquals(activeOrdersList.TotalActiveOrders, 1 );
    }
    
             /**
     * Name: getPaginatedActiveOrdersForVendorTestA
     * Desc: Test to fetch active orders for vendor.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForVendorTestNegative() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Vendor_Order_Header__c VendorOrderHeader =  TestUtil.createVendorOrderHeader(true, null);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        
        ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
        pageSort.activeOrdersCurrentPage = 1;
        pageSort.activeOrdersPageSize = 10;
        String activeOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedActiveOrdersForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewVendorRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewVendorRelatedListCtrl.AllActiveOrdersWrapper.class);

        
        system.assertEquals(activeOrdersList.TotalActiveOrders, 0 );
    }
    
            	  /**
     * Name: getPaginatedActiveOrdersForPartTest 
     * Desc: Test to fetch active orders for part.
     * @param: 
     * @return: 
    **/

    static testMethod void getPaginatedActiveOrdersForVendorTestPositiveMultpleOrders() {
    	General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Vendor_Order_Header__c VendorOrderHeader =  TestUtil.createVendorOrderHeader(true, vendor.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, '321', vendor.Id, 'Test Part1', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
        pageSort.activeOrdersCurrentPage = 1;
        pageSort.activeOrdersPageSize = 10;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part1.Id, 200);
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(voHeader.Id), true, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String activeOrders = BPUtility.getDecodedString(ViewVendorRelatedListCtrl.getPaginatedActiveOrdersForVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        ViewVendorRelatedListCtrl.AllActiveOrdersWrapper activeOrdersList = (ViewVendorRelatedListCtrl.AllActiveOrdersWrapper) System.JSON.deserialize(activeOrders, ViewVendorRelatedListCtrl.AllActiveOrdersWrapper.class);
        system.assertEquals(activeOrdersList.TotalActiveOrders, 2 );
    }
    
}