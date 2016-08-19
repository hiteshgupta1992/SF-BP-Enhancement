/**
 * Author: Tarun Khandelwal
 * Since: Oct 14, 2014
 * Name: TestUtil
 * Description: Static util class to create test data used in test classes
**/
public with sharing class TestUtil {
    
    // A static constant integer to hold uniqueness among current context vendor codes
    private static Integer uniqueNumber = 1;
    
    /**
     * Name: createPriceLevel
     * Desc: Method to insert price level record
     * @param:  boolean isInsert - if record is inserted
     *          String priceLevelName - Name of price level record
     * @return: inserted price level record
    **/
    public static Price_Level__c createPriceLevel(boolean isInsert, String priceLevelName){
        return createPriceLevel(isInsert, priceLevelName, null, null, null);
    }
    
    /**
     * Name: createPriceLevel
     * Desc: Method to insert price level record
     * @param:  boolean isInsert - if record is inserted
     *          String priceLevelName - Name of price level record
     *          String partPriceBaseValue - Part price Base Value of price level record
     * @return: inserted price level record
    **/
    public static Price_Level__c createPriceLevel(boolean isInsert, String priceLevelName, String partPriceBaseValue){
        return createPriceLevel(isInsert, priceLevelName, partPriceBaseValue, null, null);
    }
    
    /**
     * Name: createPriceLevel
     * Desc: Method to insert price level record
     * @param:  boolean isInsert - if record is inserted
     *          String priceLevelName - Name of price level record
     *          String partPriceBaseValue - Part price Base Value of price level record
     *          boolean isDefault - Default field value
     *          boolean isActive  - Active field value
     * @return: inserted price level record
    **/
    public static Price_Level__c createPriceLevel(boolean isInsert, String priceLevelName, String partPriceBaseValue, boolean isDefault, boolean isActive){
        return createPriceLevel(isInsert, priceLevelName, partPriceBaseValue, 0 ,isDefault, isActive);
    }
    
    /**
     * Name: createPriceLevel
     * Desc: Method to insert price level record
     * @param:  boolean isInsert - if record is inserted
     *          String priceLevelName - Name of price level record
     *          String partPriceBaseValue - Part price Base Value of price level record
     *          boolean isDefault - Default field value
     *          boolean isActive  - Active field value
     * @return: inserted price level record
    **/
    public static Price_Level__c createPriceLevel(boolean isInsert, String priceLevelName, String partPriceBaseValue, Decimal discount, boolean isDefault, boolean isActive){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Price_Level__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Price_Level__c priceLevel = new Price_Level__c();
        priceLevel.Name__c = (priceLevelName != null) ?  priceLevelName : 'Test Price Level' + uniqueNumber;
        priceLevel.Part_Price_Base__c = (partPriceBaseValue == null) ? 'Cost' : partPriceBaseValue;
        priceLevel.Default__c = (isDefault == null) ? false : isDefault;
        priceLevel.Active__c = (isActive == null) ? true : isActive; 
        priceLevel.Discount_Markup__c = (discount == null) ? 0 : discount;
        
        if(isInsert){
            insert priceLevel;
        }
        return priceLevel;
    }
    
    /**
     * Name: createSalesTax
     * Desc: Method to insert Sales Tax record
     * @param:  boolean isInsert - if record is inserted
     *          String salesTaxName - Name of Sales Tax record
     * @return: inserted Sales Tax record
    **/
    public static Sales_Tax__c createSalesTax(boolean isInsert, String salesTaxName){
        return createSalesTax(isInsert, salesTaxName, null, null, null);
    }
    
    /**
     * Name: createSalesTax
     * Desc: Method to insert Sales Tax record
     * @param:  boolean isInsert - if record is inserted
     *          String salesTaxName - Name of Sales Tax record
     *          Boolean isFormListTax - Is Form List Tax field value of Sales Tax Record
     *          boolean isDefault - default field value of sales tax record
     *          boolean isActive - active field value of sales tax record
     * @return: inserted Sales Tax record
    **/
    public static Sales_Tax__c createSalesTax(boolean isInsert, String salesTaxName, Boolean isFormListTax, boolean isDefault, boolean isActive){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Sales_Tax__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Sales_Tax__c salesTax = new Sales_Tax__c();
        
        salesTax.Name__c = (salesTaxName != null) ?  salesTaxName : 'Test Sales Tax' + uniqueNumber;
        salesTax.Forms_List_Taxes__c = (isFormListTax == null) ? true : isFormListTax;
        salesTax.Default__c = (isDefault == null) ? false : isDefault;
        salesTax.Active__c = (isActive == null) ? true : isActive; 
        
        if(isInsert){
            insert salesTax;
        }
        return salesTax;
    }
    
    /**
     * Name: createSalesTaxItem
     * Desc: Method to insert Sales Tax Item record
     * @param:  boolean isInsert - if record is inserted
     *          String salesTaxItemName - Name of Sales Tax Item record
     * @return: inserted Sales Tax Item record
    **/
    public static Sales_Tax_Item__c createSalesTaxItem(boolean isInsert, String salesTaxItemName){
        return createSalesTaxItem(isInsert, salesTaxItemName, 0, null, null, null);
    }
     
    /**
     * Name: createSalesTaxItem
     * Desc: Method to insert Sales Tax Item record
     * @param:  boolean isInsert - if record is inserted
     *          String salesTaxName - Name of Sales Tax Item record
     *          Decimal rate - Rate field value of record
     *          String formsLabel - form label value of record
     *          boolean isActive - active field value of sales tax record
     *          String categoryId - category Id value as String
     * @return: inserted Sales Tax Item record
    **/
    public static Sales_Tax_Item__c createSalesTaxItem(boolean isInsert, String salesTaxItemName, Decimal rate, String formsLabel, boolean isActive, String categoryId){
        return createSalesTaxItem(isInsert, salesTaxItemName, rate, formsLabel, isActive, categoryId, true);
    }
    
    /**
     * Name: createSalesTaxItem
     * Desc: Method to insert Sales Tax Item record
     * @param:  boolean isInsert - if record is inserted
     *          String salesTaxName - Name of Sales Tax Item record
     *          Decimal rate - Rate field value of record
     *          String formsLabel - form label value of record
     *          boolean isActive - active field value of sales tax record
     *          String categoryId - category Id value as String
     * @return: inserted Sales Tax Item record
    **/
    public static Sales_Tax_Item__c createSalesTaxItem(boolean isInsert, String salesTaxItemName, Decimal rate, String formsLabel, boolean isActive, String categoryId, Boolean isTaxPart){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Sales_Tax_Item__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Sales_Tax_Item__c salesTaxItem = new Sales_Tax_Item__c();
        
        salesTaxItem.Name__c = (salesTaxItemName != null) ?  salesTaxItemName : 'Test Sales Tax Item' + uniqueNumber;
        salesTaxItem.Rate__c = (rate == 0) ? uniqueNumber : rate;
        salesTaxItem.Forms_Label__c = (formsLabel == null) ? 'Test Form Label' + uniqueNumber : formsLabel;
        salesTaxItem.Active__c = (isActive == null) ? true : isActive; 
        salesTaxItem.Category__c = categoryId;
        salesTaxItem.Tax_Parts__c = isTaxPart;
        
        if(isInsert){
            insert salesTaxItem;
        }
        return salesTaxItem;
    }
    
    /**
     * Name: createApplicableTax
     * Desc: Method to insert Applicable Tax record
     * @param:  boolean isInsert - if record is inserted
     *          String salesTaxId - Sales Tax record Id
     *          String salesTaxItemId - Sales Tax Item record Id
     * @return: inserted Applicable Tax record
    **/
    public static Applicable_Taxes__c createApplicableTax(boolean isInsert, String salesTaxId, String salesTaxItemId){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Applicable_Taxes__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Applicable_Taxes__c applicableTax = new Applicable_Taxes__c();
        
        applicableTax.Sales_Tax__c = (salesTaxId != null) ?  salesTaxId : createSalesTax(true, 'Test Sales Tax' + uniqueNumber).Id;
        applicableTax.Sales_Tax_Item__c = (salesTaxItemId != null) ?  salesTaxItemId : createSalesTaxItem(true, 'Test Sales Tax Item' + uniqueNumber).Id;
        
        if(isInsert){
            insert applicableTax;
        }
        return applicableTax;
    }
    
    /**
     * Name: createCategory
     * Desc: Method to insert Category record
     * @param:  boolean isInsert - if record is inserted
     *          String categoryName - Name of category Record
     * @return: inserted Category record
    **/
    public static Category__c createCategory(boolean isInsert, String categoryName){
        return createCategory(isInsert, categoryName, 'Labour', 'Testing Category', true, true);
    }
    
    /**
     * Name: createCategory
     * Desc: Method to insert Category record
     * @param:  boolean isInsert - if record is inserted
     *          String categoryName - Name of category Record
     * @return: inserted Category record
    **/
    public static Category__c createCategory(boolean isInsert, String categoryName, String categoryType, String categoryDescription, Boolean isDefault, Boolean isActive){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Category__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Category__c categoryObj = new Category__c();
        categoryObj.Name = (categoryName == null) ? 'Test Ctaegory' + uniqueNumber : categoryName;
        categoryObj.Type__c = (categoryType == null) ? 'Test Labour ' : categoryType;
        categoryObj.Description__c = (categoryDescription == null) ? 'Test Description ' + uniqueNumber : categoryDescription; 
        categoryObj.Default__c = (isDefault == null) ? false : isDefault;
        categoryObj.Active__c = (isActive == null) ? true : isActive;
        categoryObj.OwnerId = UserInfo.getUserId();
        if(isInsert){
            insert categoryObj;
        }
        return categoryObj;
    }
    
    
    
    /**
     * Name: createCountry
     * Desc: Method to insert Country record
     * @param:  boolean isInsert - if record is inserted
     *          String countryName - Name of Country record
     *          Boolean isVisible - Visible field value of Country Record
     *          boolean isDefault - Default field value of Country record
     * @return: inserted Country record
    **/
    public static Country__c createCountry(boolean isInsert, String countryName, Boolean isVisible, Boolean isDefault){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Country__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Country__c countryObj = new Country__c();
        countryObj.Name__c = (countryName == null) ? 'India' + uniqueNumber : countryName;
        countryObj.Visible__c = (isVisible == null) ? true : isVisible ; 
        countryObj.Default__c = (isDefault == null) ? false : isDefault;
        
        if(isInsert){
            insert countryObj;
        }
        return countryObj;
    }
    
    /**
     * Name: createState
     * Desc: Method to insert State record
     * @param:  boolean isInsert - if record is inserted
     *          String stateName - Name of State record
     *          boolean isDefault - Default field value of state record
     * @return: inserted State record
    **/
    public static State__c createState(boolean isInsert, String stateName, String countryId, Boolean isDefault){
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('State__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        State__c stateObj = new State__c();
        stateObj.Name__c = (stateName == null) ? 'Maharastra' + uniqueNumber : stateName;
        stateObj.Country__c = countryId ; 
        stateObj.Default__c = (isDefault == null) ? false : isDefault;
        
        if(isInsert){
            insert stateObj;
        }
        return stateObj;
    }
    
    /**
     * Name: createCustomer
     * Desc: Method to insert Customer record
     * @param:  boolean isInsert - if record is inserted
     *          String customerName - Name of Customer record
     *          String email - Email of Customer record
     *          String billingCity - Billing City of Customer record
     *          String phoneNumber - phone Number of Customer record
     * @return: inserted Customer record
    **/
    public static Account createCustomer(boolean isInsert, String customerName, String email, String billingCity, String phoneNumber) {
        return createCustomer(isInsert, customerName, email, billingCity, phoneNumber, null, null);
    }
    
    /**
     * Name: createCustomer
     * Desc: Method to insert Customer record
     * @param:  boolean isInsert - if record is inserted
     *          String customerName - Name of Customer record
     *          String email - Email of Customer record
     *          String billingCity - Billing City of Customer record
     *          String phoneNumber - phone Number of Customer record
     * @return: inserted Customer record
    **/
    public static Account createCustomer(boolean isInsert, String customerName, String email, String billingCity, String phoneNumber, String priceLevel, String salesTax) {
        return createCustomer(isInsert, customerName, email, billingCity, phoneNumber, priceLevel, salesTax, false, false, null);
    }
    
    /**
     * Name: createCustomer
     * Desc: Method to insert Customer record
     * @param:  boolean isInsert - if record is inserted
     *          String customerName - Name of Customer record
     *          String email - Email of Customer record
     *          String billingCity - Billing City of Customer record
     *          String phoneNumber - phone Number of Customer record
     * @return: inserted Customer record
    **/
    public static Account createCustomer(boolean isInsert, String customerName, String email, String billingCity, String phoneNumber, String priceLevel, String salesTax, Boolean isVendor, Boolean isCustomer, String customertype) {
        return createCustomer(isInsert, customerName, email, billingCity, phoneNumber, priceLevel, salesTax, isVendor, isCustomer, customertype, null, null, null, null);
    }
    /**
     * Name: createCustomer
     * Desc: Method to insert Customer record
     * @param:  boolean isInsert - if record is inserted
     *          String customerName - Name of Customer record
     *          String email - Email of Customer record
     *          String billingCity - Billing City of Customer record
     *          String phoneNumber - phone Number of Customer record
     *          Boolean isCustomer
     * @return: inserted Customer record
    **/
    
     public static Account createCustomer(boolean isInsert, String customerName, String email, String billingCity, String phoneNumber, String priceLevel, String salesTax, Boolean isVendor, Boolean isCustomer, String customertype, String firstName, String lastName, String Mobile, String BillingStreet ) {
        return createCustomer(isInsert, customerName, email, billingCity, phoneNumber, priceLevel, salesTax, isVendor, isCustomer, customertype, firstName, lastName, Mobile, BillingStreet, null, null, null, null, null, null);
    }
    /**
     * Name: createCustomer
     * Desc: Method to insert Customer record
     * @param:  boolean isInsert - if record is inserted
     *          String customerName - Name of Customer record
     *          String email - Email of Customer record
     *          String billingCity - Billing City of Customer record
     *          String phoneNumber - phone Number of Customer record
     *          Boolean isCustomer
     *          Boolean isCustomer 
     *          String customertype 
     *          String firstName 
     *          String lastName 
     *          String Mobile 
     *          String BillingStreet 
     *          String workEmail 
     *          String otherEmail 
     *          String workPhone 
     *          String facebookUrl 
     *          String twitterUrl 
     *          String linkedInUrl
     * @return: inserted Customer record
    **/
    
     public static Account createCustomer(boolean isInsert, String customerName, String email, String billingCity, String phoneNumber, String priceLevel, String salesTax, Boolean isVendor, Boolean isCustomer, String customertype, String firstName, String lastName, String Mobile, String BillingStreet, String workEmail, String otherEmail, String workPhone, String facebookUrl, String twitterUrl, String linkedInUrl    ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Account') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Account customer = new Account();
        customer.Name = (customerName == null) ? 'Test Customer' + uniqueNumber : customerName ;
        customer.Email__c = (email == null) ? 'Test' + uniqueNumber + '@gmail.com' : email;
        customer.Phone = (phoneNumber == null) ? '123456' + uniqueNumber : phoneNumber;
        customer.BillingCity = (billingCity == null) ? 'Test Billing City' + uniqueNumber : billingCity;
        customer.Price_Level__c = priceLevel;
        customer.Sales_Tax__c = salesTax;
        customer.Is_Vendor__c = isVendor;
        customer.Is_Customer__c = isCustomer;
        customer.Type__c = customertype;
        customer.FirstName__c = firstName;
        customer.LastName__c = lastName;
        customer.Mobile__c = Mobile;
        customer.BillingStreet = BillingStreet ;
        customer.Work_Email__c = workEmail ;
        customer.Other_Email__c = otherEmail ;
        customer.Work_Number__c = workPhone ;
        customer.Facebook__c = facebookUrl ;
        customer.Twitter__c = twitterUrl ;
        customer.LinkedIn__c = linkedInUrl ;
        
        
        if(isInsert) {
            insert customer;
        }
        return customer;
    }
    
    
    
    /**
     * Name: createCustomer
     * Desc: Method to insert Part record
     * @param:  boolean isInsert - if record is inserted
     *          String partNumber - Part Number Of part
     *          String vendorId - Vendor Id of Part
     *          String description - Short Description of part
     *          String categoryId - Category Id of Part
     * @return: inserted Part record
    **/
    public static Part__c createPart(boolean isInsert, String partNumber, String vendorId, String description, String categoryId) {
        return createPart(isInsert, partNumber, vendorId, description, categoryId, 10, 20, 30, 40, 100);
    }
    
       
    
    /**
     * Name: createCustomer
     * Desc: Method to insert Part record
     * @param:  boolean isInsert - if record is inserted
     *          String partNumber - Part Number Of part
     *          String vendorId - Vendor Id of Part
     *          String description - Short Description of part
     *          String categoryId - Category Id of Part
     * @return: inserted Part record
    **/
    public static Part__c createPart(boolean isInsert, String partNumber, String vendorId, String description, String categoryId, Integer averageCost, 
                                        Integer LastCost, Integer MSRP, Integer retailPrice, Integer qtyInStock) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Part__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Part__c part = new Part__c();
        part.Part_Number__c = (partNumber == null) ? 'Test Part 123' + uniqueNumber : partNumber ;
        part.Description__c = (description == null) ? 'This is test ' + uniqueNumber + ' Part': description;
        part.Category__c = (categoryId == null) ?  createCategory(true, 'Testing Category' + uniqueNumber).Id : categoryId;
        part.Vendor__c = vendorId;
        part.Order_Lots__c = 1;
        part.Average_Cost__c = averageCost;
        part.Last_Cost__c = LastCost;
        part.MSRP__c = MSRP;
        part.Retail_Price__c = retailPrice;
        part.Qty_In_Stock__c = qtyInStock;
        
        if(isInsert) {
            insert part;
        }
        return part;
    }
     /**
     * Name: createCOInvoiceheader
     * Desc: Method to COInvoiceheader
     * @param:  boolean isInsert - if record is inserted
     * String coHeaderId - coHeaderId
     * String description - Short Description of part
     * @return: inserted coInvoiceHeader record
    **/
    public static CO_Invoice_Header__c createCOInvoiceHeader(boolean isInsert, String coHeaderId, String status) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        CO_Invoice_Header__c coInvoiceHeaderRec = new CO_Invoice_Header__c();
        coInvoiceHeaderRec.CO_Header__c = coHeaderId;
        coInvoiceHeaderRec.Invoice_Status__c = status;
        if(isInsert) {
            insert coInvoiceHeaderRec ;
        }
        return coInvoiceHeaderRec;
        }
    
    /**
     * Name: createCOInvoicePayment
     * Desc: Method to COInvoicePayment
     * @param:  boolean isInsert - if record is inserted
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * @return: inserted coInvoicepayment record
    **/
    public static CO_Invoice_Payment__c createCOInvoicePayment(boolean isInsert, String coInvoiceHeaderId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Payment__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        CO_Invoice_Payment__c coInvoicepaymentRec = new CO_Invoice_Payment__c();
        coInvoicepaymentRec.CO_Invoice_Header__c = coInvoiceHeaderId;
        if(isInsert) {
            insert coInvoicepaymentRec ;
        }
        return coInvoicepaymentRec;
	}
        
	/**
     * Name: createCOInvoiceitems
     * Desc: Method to COInvoiceitems
     * @param:  boolean isInsert - if record is inserted
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * @return: inserted coInvoicepayment record
    **/
	public static CO_Invoice_Item__c createCOInvoiceItem(boolean isInsert, String categoryId, String coInvoiceHeaderId, String coLineItemId) {
        return createCOInvoiceItem(isInsert, categoryId, coInvoiceHeaderId, coLineItemId, true);
	}
        
          /**
     * Name: createCOInvoiceitems
     * Desc: Method to COInvoiceitems
     * @param:  boolean isInsert - if record is inserted
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * String coInvoiceHeaderId - coInvoiceHeaderId
     * Boolean isActive  - if record is active/selected
     * @return: inserted coInvoicepayment record
    **/
	public static CO_Invoice_Item__c createCOInvoiceItem(boolean isInsert, String categoryId, String coInvoiceHeaderId, String coLineItemId, Boolean isActive) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        CO_Invoice_Item__c coInvoiceItemRec = new CO_Invoice_Item__c();
        coInvoiceItemRec.Category__c = categoryId;
        coInvoiceItemRec.CO_Invoice_Header__c = coInvoiceHeaderId;
        coInvoiceItemRec.CO_Line_Item__c = coLineItemId;
        coInvoiceItemRec.isActive__c = isActive;
        if(isInsert) {
            insert coInvoiceItemRec ;
        }
        return coInvoiceItemRec;    
        }
    /**
     * Name: createVendor
     * Desc: Method to insert Vendor record
     * @param:  boolean isInsert - if record is inserted
     *          String vendorName - Part Number Of part
     * @return: inserted Vendor record
    **/
    public static Account createVendor(boolean isInsert, String vendorName) {
        return createVendor(isInsert, vendorName,'test.vendor@gmail.com', 'Jaipur', '123456789');
    }
    
    /**
     * Name: createVendor
     * Desc: Method to insert Vendor record
     * @param:  boolean isInsert - if record is inserted
     *          String vendorName - Name of Vendor record
     *          String email - Email of Vendor record
     *          String billingCity - Billing City of Vendor record
     *          String phoneNumber - phone Number of Vendor record
     * @return: inserted Vendor record
    **/
    public static Account createVendor(boolean isInsert, String vendorName, String email, String billingCity, String phoneNumber) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Account') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Account vendor = new Account();
        vendor.Name = (vendorName == null) ? 'Test Venodr' + uniqueNumber : vendorName ;
        vendor.Email__c = (email == null) ? 'Test' + uniqueNumber + '@gmail.com' : email;
        vendor.Phone = (phoneNumber == null) ? '123456' + uniqueNumber : phoneNumber;
        vendor.BillingCity = (billingCity == null) ? 'Test Billing City' + uniqueNumber : billingCity;
        vendor.Is_Vendor__c = true;
        
        if(isInsert) {
            insert vendor;
        }
        return vendor;
    }
    
    /**
     * Name: createIndividaulCustomer
     * Desc: Method to insert Vendor record
     * @param:  boolean isInsert - if record is inserted
     *          String customerName - Customer Name
     * @return: inserted Individual customer record
    **/
    public static Contact createIndividaulCustomer(boolean isInsert, String customerName) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Contact') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Contact indiCustomer = new Contact();
        indiCustomer.LastName = (customerName == null) ? 'Test Customer ' + uniqueNumber : customerName ;
        if(isInsert) {
            insert indiCustomer;
        }
        return indiCustomer;
    }
    
    /**
     * Name: createUnitMake
     * Desc: Method to insert Unit Make record
     * @param:  boolean isInsert - if record is inserted
     *          String unitMakeName - Name of Unit Make record
     *          String VINCode - VIN code of Unit Make record
     *          Boolean isActive - Active field of Unit Make Record
     * @return: inserted Unit Make record
    **/
    public static Unit_Make__c createUnitMake(boolean isInsert, String unitMakeName, String VINCode, boolean isActive) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Unit_Make__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Unit_Make__c unitMake = new Unit_Make__c();
        unitMake.Name = (unitMakeName == null) ? 'Test Unit Make ' : unitMakeName;
        unitMake.VIN_Code__c = (VINCode == null) ? 'TES' : VINCode;
        unitMake.Active__c = (isActive == null) ? true : isActive;
        
        if(isInsert) {
            insert unitMake;
        }
        return unitMake;
    }
    
    /**
     * Name: createUnitModel
     * Desc: Method to insert Unit Make record
     * @param:  boolean isInsert - if record is inserted
     *          String unitMakeName - Name of Unit Make record
     *          String VINCode - VIN code of Unit Make record
     *          Boolean isActive - Active field of Unit Make Record
     * @return: inserted Unit Make record
    **/
    public static Unit_Model__c createUnitModel(boolean isInsert, String unitModelName, String VINCode, boolean isActive, String unitMakeId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Unit_Model__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Unit_Model__c unitModel = new Unit_Model__c();
        unitModel.Name__c = (unitModelName == null) ? 'Test Unit Model ' : unitModelName;
        unitModel.VIN_Code__c = (VINCode == null) ? 'TES' : VINCode;
        unitModel.Active__c = (isActive == null) ? true : isActive;
        unitModel.Unit_Make__c = (unitMakeId == null) ? '' : unitMakeId;
        
        if(isInsert) {
            insert unitModel;
        }
        return unitModel;
    }
    
    /**
     * Name: create Customer Owned Unit
     * Desc: Method to insert Customer Owned Unit
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     *          String parentCOHeader - Parent CO Header
     * @return: inserted CO Header record
    **/
    public static Customer_Owned_Unit__c createCustomerOwnedUnit(boolean isInsert, String accountId, String UnitMakeId, String UnitModelId, String subModelId) {
        return createCustomerOwnedUnit(isInsert, accountId, UnitMakeId, UnitModelId, subModelId, null);
    }
    
    /**
     * Name: create Customer Owned Unit
     * Desc: Method to insert Customer Owned Unit
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     *          String parentCOHeader - Parent CO Header
     *          String VIN 
     * @return: inserted CO Header record
    **/
    public static Customer_Owned_Unit__c createCustomerOwnedUnit(boolean isInsert, String accountId, String UnitMakeId, String UnitModelId, String subModelId, String VIN) {
        
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Customer_Owned_Unit__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Customer_Owned_Unit__c CustomerOwnedUnits = new Customer_Owned_Unit__c();
        CustomerOwnedUnits.Account__c = accountId ;
        CustomerOwnedUnits.Unit_Make__c = UnitMakeId ;
        CustomerOwnedUnits.Unit_Model__c = UnitModelId;
        CustomerOwnedUnits.Submodel__c = subModelId;
        CustomerOwnedUnits.VIN__c = VIN ;
       
         
        if(isInsert) {
            insert CustomerOwnedUnits;
        }
        return CustomerOwnedUnits;
    }
    /**
     * Name: createCOHeader
     * Desc: Method to insert CO Header record
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     * @return: inserted CO Header record
    **/
    public static CO_Header__c createCOHeader(boolean isInsert, String customer) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CO_Header__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        CO_Header__c coHeader = new CO_Header__c();
        coHeader.Customer__c = customer;
        coHeader.Owner__c = UserInfo.getUserId();
        
        if(isInsert) {
            insert coHeader;
        }
        return coHeader;
    }
    
    /**
     * Name: createCOLineitem
     * Desc: Method to insert COLineitem record
     * @param:  boolean isInsert - if record is inserted
     *          String COHeader - COHeaderId
     *          String part - PartId
     *          Decimal qty - qty
     * @return: inserted CO LineItem record
    **/
    public static CO_Line_Item__c createCOLineItem(boolean isInsert, String COHeader, String part, Decimal qty) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        CO_Line_Item__c coLineItem = new CO_Line_Item__c();
        coLineItem.CO_Header__c = (COHeader == null) ? '' : COHeader;
        coLineItem.Part__c = (part == null) ? '' : part;
        coLineItem.Qty__c = (qty == null) ? 0 : qty;
        if(isInsert) {
            insert coLineItem;
        }
        return coLineItem;
    }
    
    /**
     * Name: createPartTax
     * Desc: Method to insert CO Header record
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     *          String parentCOHeader - Parent CO Header
     * @return: inserted CO Header record
    **/
    public static Part_Tax__c createPartTax(boolean isInsert, String salesTaxItem, String partId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Part_Tax__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Part_Tax__c partTax = new Part_Tax__c();
        partTax.Sales_Tax_Item__c = salesTaxItem;
        partTax.Part_ID__c = partId;
         
        if(isInsert) {
            insert partTax;
        }
        return partTax;
    }
    
    /**
     * Name: createPartTax
     * Desc: Method to insert CO Header record
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     *          String parentCOHeader - Parent CO Header
     * @return: inserted CO Header record
    **/
    public static CO_Deposit__c createCODeposit(boolean isInsert, String coHeaderId, String paymentMethod, Decimal amount) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CO_Deposit__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        CO_Deposit__c coDepositRec = new CO_Deposit__c();
        coDepositRec.CO_Header__c = coHeaderId;
        coDepositRec.Amount__c = amount;
        coDepositRec.Payment_Method__c = paymentMethod;
         
        if(isInsert) {
            insert coDepositRec;
        }
        return coDepositRec;
    }
    
    /**
     * Name: createUser
     * Desc: Method to insert User record
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     *          String parentCOHeader - Parent CO Header
     * @return: inserted CO Header record
    **/
    public static User createUser(boolean isInsert, String email, String lastName, String localeSidKey, String userName, String alias) {
        return createUser(isInsert, email, lastName, localeSidKey, userName, alias, 'America/Los_Angeles');
    }
    
    /**
     * Name: createUser
     * Desc: Method to insert User record
     * @param:  boolean isInsert - if record is inserted
     *          String customer - Name of customer
     *          String parentCOHeader - Parent CO Header
     * @return: inserted CO Header record
    **/
    public static User createUser(boolean isInsert, String email, String lastName, String localeSidKey, String userName, String alias, String timeZoneSidKey) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('User') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        User testUser = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        testUser.Email = email;
        testUser.LastName = lastName;
        testUser.LocaleSidKey = localeSidKey;
        testUser.Username = userName;
        testUser.Alias = alias;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.ProfileId = p.Id;
        testUser.TimeZoneSidKey = timeZoneSidKey;
        testUser.EmailEncodingKey = 'UTF-8';
         
        if(isInsert) {
            insert testUser;
        }
        return testUser;
    }
    
    /**
     * Name: createGeneralConfig
     * Desc: Method to insert GeneralConfig
     * @param:  boolean isInsert - if record is inserted
     *          Integer page size
     * @return: 
    **/
    
    public static General_Configurations__c createGeneralConfig(Integer pageSize, Boolean isInsert) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('General_Configurations__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        General_Configurations__c genConfig = new General_Configurations__c(Related_List_Page_Size__c = pageSize);
        
        if(isInsert) {
            insert genConfig;
        }
        return genConfig;
    }
    
    /**
     * Name: createSearchConfig
     * Desc: Method to insert Search configurations
     * @param:  boolean isInsert - if record is inserted
     * @return: 
    **/
    
    public static List<SearchConfigurations__c> createSearchConfig(Boolean isInsert, Set<String> objectNames) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('SearchConfigurations__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        List<SearchConfigurations__c> searchConfigSettings = new List<SearchConfigurations__c>();
        
        if(objectNames.contains('Customer') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Name', 
                                                                 Object_Name__c = 'Customer',
                                                                 Order__c = 1, 
                                                                 Searchable_Field__c = 'Name',
                                                                 Name = 'Customer'
                                                                ));
        }
        
        if(objectNames.contains('User') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Name', 
                                                                 Object_Name__c = 'User',
                                                                 Order__c = 2, 
                                                                 Searchable_Field__c = 'Name',
                                                                 Name = 'User'
                                                                ));
        }
        
        if(objectNames.contains('Sales_Tax_Item__c') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Name__c', 
                                                                 Object_Name__c = 'Sales_Tax_Item__c',
                                                                 Order__c = 3, 
                                                                 Searchable_Field__c = 'Name__c',
                                                                 Name = 'Sales_Tax_Item__c'
                                                                ));
        }
        
        if(objectNames.contains('Part__c') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Part_Id__c', 
                                                                 Display_Info__c = '{Description__c}', 
                                                                 Object_Name__c = 'Part__c',
                                                                 Order__c = 3, 
                                                                 Searchable_Field__c = 'Part_Number__c,Description__c,Part_Id__c, Qty_In_Stock__c, Qty_Committed__c, Retail_Price__c, Name, Vendor__c',
                                                                 Name = 'Part__c'
                                                                ));
        }
        
        if(objectNames.contains('Vendor') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Name', 
                                                                 Object_Name__c = 'Vendor',
                                                                 Order__c = 3, 
                                                                 Searchable_Field__c = 'Name',
                                                                 Name = 'Vendor'
                                                                ));
        }
        
        if(objectNames.contains('Category__c') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Name', 
                                                                 Object_Name__c = 'Category__c',
                                                                 Order__c = 3, 
                                                                 Searchable_Field__c = 'Name',
                                                                 Name = 'Category__c'
                                                                ));
        }
        
        if(objectNames.contains('Fee__c') || objectNames == null){
            searchConfigSettings.add(new SearchConfigurations__c(Display_Field__c = 'Name', 
                                                                 Object_Name__c = 'Fee__c',
                                                                 Order__c = 3, 
                                                                 Searchable_Field__c = 'Name',
                                                                 Name = 'Fee__c'
                                                                ));
        }
        if(isInsert && searchConfigSettings.size() > 0) {
            insert searchConfigSettings;
        }
        return searchConfigSettings;
    }
    
     /**
     * Name: createPeople
     * Desc: Method to insert relationship
     * @param:  boolean isInsert - if record is inserted
     *          String  - customerId
     *          String - another CustomerId
     *          String - relationship name
     * @return: 
    **/
    public static People__c createPeople(Boolean isInsert, String customer1Id, String customer2Id, String relationship) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('People__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        People__c People = new People__c();
        people.Parent_Customer1__c = customer1Id;
        people.Parent_Customer2__c = customer2Id;
        people.Relationship__c = relationship;
        
        if(isInsert) {
            insert People;
        }
        return People;
    }
    
      /**
     * Name: contact
     * Desc: Method to insert contact
     * @param:  boolean isInsert - if record is inserted
     *          String  - customerId
     *          String - firstName
     *          String - lastname
     *          String - accountId
     * @return: 
    **/
    public static Contact createContact(Boolean isInsert, String firstName, String lastName, String accountId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Contact') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Contact contact = new Contact();
        
        contact.FirstName = firstName;
        contact.LastName = lastName ;
        contact.AccountId = accountId;
        
        if(isInsert) {
            insert contact;
        }
        return contact;
    }
    
          /**
     * Name: AlternatePart
     * Desc: Method to insert AlternatePart
     * @param:  boolean isInsert - if record is inserted
     *          String  - alternatePartId
     *          String - partId
     *          String - relation
     * @return: 
    **/
    public static Part_Alternates__c createPartAlternates(Boolean isInsert, String alternatePartId, String partId, String relation) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Part_Alternates__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Part_Alternates__c PartAlternates = new Part_Alternates__c();
        
       PartAlternates.Alternate_Part_ID__c = alternatePartId;
       PartAlternates.Part_ID__c = partId;
       PartAlternates.Relation__c = relation;
        
        if(isInsert) {
            insert PartAlternates;
        }
        return PartAlternates;
    }
    
            /**
     * Name: AlternatePart
     * Desc: Method to insert AlternatePart
     * @param:  boolean isInsert - if record is inserted
     *          String  - alternatePartId
     *          String - partId
     *          String - relation
     * @return: 
    **/
    public static Part_Alternates__c createPartReverseAlternates(Boolean isInsert, String alternatePartId, String partId, String relation, boolean IsPreferred) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Part_Alternates__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Part_Alternates__c PartAlternates = new Part_Alternates__c();
        
       PartAlternates.Alternate_Part_ID__c = PartId;
       PartAlternates.Part_ID__c = alternatePartId;
       PartAlternates.Relation__c = relation;
       PartAlternates.Alternate_Preferred__c = IsPreferred;
        
        if(isInsert) {
            insert PartAlternates;
        }
        return PartAlternates;
    }
    
        /**
     * Name: VendorOrderHeader
     * Desc: Method to insert VendorOrderHeader
     * @param:  boolean isInsert - if record is inserted
     *          String  - vendorId
     *          String - ownerId
     * @return: 
    **/
    
        public static Vendor_Order_Header__c createVendorOrderHeader(Boolean isInsert, String vendorId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Header__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Vendor_Order_Header__c VendorOrderHeader = new Vendor_Order_Header__c();
        
        VendorOrderHeader.Vendor__c = vendorId;
        VendorOrderHeader.Owner__c = UserInfo.getUserId();
        
        if(isInsert) {
            insert VendorOrderHeader;
        }
        return VendorOrderHeader;
    }
    
        /**
     * Name: VendorOrderLineitem
     * Desc: Method to insert VendorOrderLineitem
     * @param:  boolean isInsert - if record is inserted
     *          String  - partId
     *          String - 
     * @return: 
    **/
    
        public static Vendor_Order_Line_Item__c createVendorOrderLineItem(Boolean isInsert, String vendorOrderHeaderId, String partId, Double qtyOrdered) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Vendor_Order_Line_Item__c VendorOrderLineItem = new Vendor_Order_Line_Item__c();
        
        VendorOrderLineItem.Vendor_Order_Header__c = vendorOrderHeaderId;
        VendorOrderLineItem.Part__c = partId;
        VendorOrderLineItem.Qty_Ordered__c = qtyOrdered ;
       
        if(isInsert) {
            insert VendorOrderLineItem;
        }
        return VendorOrderLineItem;
    }
    
       /**
     * Name: product_c
     * Desc: Method to insert product
     * @param:  boolean isInsert - if record is inserted
     *          String  - categoryId
     *          String - productCode
     *          String - vendorId
     * @return: 
    **/
    
        public static Product__c createProduct(Boolean isInsert, String categoryId, String productCode, String vendorId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Product__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Product__c product = new Product__c();
        
        product.Category__c = categoryId;
        product.Code__c = productCode;
        product.Vendor__c = vendorId ;
       
        if(isInsert) {
            insert product;
        }
        return product;
    }
    
       /**
     * Name: PO_Type__c
     * Desc: Method to insert purchase Order
     * @param:  boolean isInsert - if record is inserted
     *          String  - purchaseOrderCode
     *          String - vendorId
     *          boolean - IsDefault
     *          double - leadTime
     * @return: 
    **/
    
        public static PO_Type__c createPurchaseOrder(Boolean isInsert, String purchaseOrderCode, String vendorId, boolean IsDefault, Double leadTime) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('PO_Type__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        PO_Type__c purchaseOrder = new PO_Type__c();
        
        purchaseOrder.Code__c = purchaseOrderCode;
        purchaseOrder.Vendor__c = vendorId;
        purchaseorder.IsDefault__c = IsDefault;
        purchaseOrder.Lead_Time__c = leadTime;
        
       
        if(isInsert) {
            insert purchaseOrder;
        }
        return purchaseOrder;
    }
    
       /**
     * Name: VendorOrderLineItemGroup
     * Desc: Method to insert VendorOrderLineitem
     * @param:  boolean isInsert - if record is inserted
     *          String  - vendorOrderheaderId
     *          String - partId
     * @return: 
    **/
    
        public static Vendor_Order_Line_Item_Group__c createVendorOrderLineItemGroup(Boolean isInsert, String vendorOrderHeaderId, String partId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item_Group__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Vendor_Order_Line_Item_Group__c VendorOrderLineItemGroup = new Vendor_Order_Line_Item_Group__c();
        
        VendorOrderLineItemGroup.Vendor_Order_Header__c = vendorOrderHeaderId;
        VendorOrderLineItemGroup.Part__c = partId;
        VendorOrderLineItemGroup.Need__c = 0;
       
        if(isInsert) {
            insert VendorOrderLineItemGroup;
        }
        return VendorOrderLineItemGroup;
    }
    
           /**
     * Name: VendorOrderReceiveHeader
     * Desc: Method to insert VendorOrderReceiveHeader
     * @param:  boolean isInsert - if record is inserted
     *          String  - vendorId
     *          String - Status
     * @return: 
    **/
    
        public static Vendor_Receiving_Header__c createVendorOrderReceiveHeader(Boolean isInsert, String vendorId, String Status) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Vendor_Receiving_Header__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Vendor_Receiving_Header__c VendorOrderReceiveHeader = new Vendor_Receiving_Header__c();
        
        VendorOrderReceiveHeader.Vendor__c = vendorId;
        VendorOrderReceiveHeader.Status__c = Status;
       
        if(isInsert) {
            insert VendorOrderReceiveHeader;
        }
        return VendorOrderReceiveHeader;
    }
    
    
    
               /**
     * Name: VendorInvoiceHeader
     * Desc: Method to insert VendorInvoiceHeader
     * @param:  boolean isInsert - if record is inserted
     *          String  - vendorId
     *          String - Status
     * @return: 
    **/
    
        public static Vendor_Invoicing_Header__c createVendorInvoiceHeader(Boolean isInsert, String vendorId, String Status) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Vendor_Invoicing_Header__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Vendor_Invoicing_Header__c VendorInvoiceHeader = new Vendor_Invoicing_Header__c();
        
        VendorInvoiceHeader.Vendor__c = vendorId;
        VendorInvoiceHeader.Status__c = Status;
       	VendorInvoiceHeader.Owner__c = UserInfo.getUserId();
        if(isInsert) {
            insert VendorInvoiceHeader;
        }
        return VendorInvoiceHeader;
    }
    
                   /**
     * Name: Kit Header
     * Desc: Method to insert Kit Header
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Kit_Header__c createKitHeader(Boolean isInsert, Boolean Active, Boolean CanSplit, String Cause, String Code, String Concern, String Correction, String Description, Decimal FixedPrice, Boolean  IsFixedPriceFlag, Boolean IsServiceKit, String UnitMake, String UnitModel  ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Kit_Header__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Kit_Header__c KitHeader = new Kit_Header__c();
        
        KitHeader.Active__c = Active;
        KitHeader.Can_Split__c = CanSplit;
        KitHeader.Cause__c = Cause;
        KitHeader.Code__c = Code;
        KitHeader.Concern__c = Concern;
        KitHeader.Correction__c = Correction;
        KitHeader.Description__c = Description;
        KitHeader.Fixed_Price__c = FixedPrice;
        KitHeader.Fixed_Price_Flag__c = IsFixedPriceFlag;
        KitHeader.Service_Kit__c = IsServiceKit;
        KitHeader.Make__c = UnitMake;
        KitHeader.Model__c = UnitModel;

       
        if(isInsert) {
            insert KitHeader;
        }
        return KitHeader;
    }
    
                       /**
     * Name: Kit Transaction type Junction
     * Desc: Method to insert Kit Transaction Type Junction
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Kit_Transaction_Type_Junction__c createKitTransactionTypeJunction(Boolean isInsert, String KitHeaderId, String TransactionType ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Kit_Transaction_Type_Junction__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Kit_Transaction_Type_Junction__c KitTransactionTypeJunction = new Kit_Transaction_Type_Junction__c();
        
        KitTransactionTypeJunction.Kit_Header__c = KitHeaderId;
        KitTransactionTypeJunction.Transaction_Type__c = TransactionType;


       
        if(isInsert) {
            insert KitTransactionTypeJunction;
        }
        return KitTransactionTypeJunction;
    }
    
                           /**
     * Name: Labour Code
     * Desc: Method to insert Labour Code
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Labour_Code__c createLabourCode(Boolean isInsert, Boolean IsActive, String Category, String Code, String CoHeaderId, String Description, Boolean IsFixedRate, Decimal Hours, String LabourCodeName, Decimal Rate, Boolean IsTaxable ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Labour_Code__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Labour_Code__c LabourCode = new Labour_Code__c();
        
        LabourCode.Active__c = IsActive;
        LabourCode.Category__c = Category;
        LabourCode.Code__c = Code;
        LabourCode.CO_Header__c = CoHeaderId;
        LabourCode.Description__c = Description;
        LabourCode.Fixed_Rate__c = IsFixedRate;
        LabourCode.Hours__c = Hours;
        LabourCode.Name__c = LabourCodeName;
        LabourCode.Rate__c = Rate;
        LabourCode.Taxable__c = IsTaxable;


       
        if(isInsert) {
            insert LabourCode;
        }
        return LabourCode;
    }
    
                               /**
     * Name: Labour Code
     * Desc: Method to insert Labour Code
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Kit_Header_Line_Item__c createKitHeaderLineItem(Boolean isInsert, Boolean IsFixedPrice, Boolean IsFixedPriceFlag, String KitHeaderId, Decimal KitPrice, String LabourCodeId, String PartId, Decimal QtyNeeded, Decimal TotalPrice ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Kit_Header_Line_Item__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Kit_Header_Line_Item__c KitHeaderLineItem = new Kit_Header_Line_Item__c();
        
        KitHeaderLineItem.Fixed_Price__c = IsFixedPriceFlag;
        KitHeaderLineItem.Kit_Header__c = KitHeaderId;
        KitHeaderLineItem.Kit_Price__c = KitPrice;
        KitHeaderLineItem.Labour_Code__c = LabourCodeId;
        KitHeaderLineItem.Part__c = PartId;
        KitHeaderLineItem.Qty_Needed__c = QtyNeeded;
       
        if(isInsert) {
            insert KitHeaderLineItem;
        }
        return KitHeaderLineItem;
    }
    
                                   /**
     * Name: Transaction_Type__c
     * Desc: Method to insert Transaction_Type
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Transaction_Type__c createTransactionType(Boolean isInsert, String Code, String Type) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Transaction_Type__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        
        Transaction_Type__c TransactionType = new Transaction_Type__c();
        
        TransactionType.Code__c = Code;
        TransactionType.Type__c = Type;
        

       
        if(isInsert) {
            insert TransactionType;
        }
        return TransactionType;
    }
    
                                   /**
     * Name: Fee
     * Desc: Method to insert fee
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Fee__c createFee(Boolean isInsert, Boolean IsActive, String CategoryId, String Code, String CoHeaderId, String Description, Decimal Price, Boolean IsTaxable ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Fee__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Fee__c Fee = new Fee__c();
        
        Fee.Active__c = IsActive;
        Fee.Category__c= CategoryId;
        Fee.Code__c = Code;
        Fee.CO_Header__c = CoHeaderId;
        Fee.Description__c = Description;
        Fee.Price__c = Price;
        Fee.Taxable__c= IsTaxable;

       
        if(isInsert) {
            insert Fee;
        }
        return Fee;
    }
    
                                      /**
     * Name: Fee
     * Desc: Method to insert sublet
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    
        public static Product__c createSublet(Boolean isInsert, String CategoryId, String Code, Decimal Cost, String Description, Decimal Mileage, Decimal Price, String Status,  String vendorId ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Product__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Product__c sublet = new Product__c();
        
        sublet.Category__c = CategoryId;
        sublet.Code__c= Code;
        sublet.Cost__c = Cost;
        sublet.Description__c = Description;
        sublet.Mileage__c = Mileage;
        sublet.Price__c = Price;
        sublet.Status__c= Status;
        sublet.Vendor__c= vendorid;
       
        if(isInsert) {
            insert sublet;
        }
        return sublet;
    }
    
    
    /**
     * Name: CustomerApproval__c
     * Desc: Method to insert Transaction_Type
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
   	public static CustomerApproval__c createCustomerApproval(Boolean isInsert, String status, String notes) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('CustomerApproval__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        CustomerApproval__c customerApproval = new CustomerApproval__c();
        customerApproval.Status__c = status;
        customerApproval.Notes__c = notes;
        if(isInsert) {
            insert customerApproval;
        }
        return customerApproval;
    }
    
        /**
     * Name: Widget__c
     * Desc: Method to insert Transaction_Type
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
   	public static Widget__c createWidget(Boolean isInsert, String widgetName ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Widget__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Widget__c widget = new Widget__c();
        widget.Widget_Name__c = widgetName;
        if(isInsert) {
            insert widget;
        }
        return widget;
    }
    
            /**
     * Name: Widget__c
     * Desc: Method to insert Transaction_Type
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
   	public static Widget_User_Junction__c createWidgetJunction(Boolean isInsert, String widgetId, Double widgetNumber, boolean IsVisible, String userId ) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Widget_User_Junction__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Widget_User_Junction__c widgetJunction = new Widget_User_Junction__c();
        widgetJunction.Widget__c = widgetId;
        widgetJunction.WidgetOrder__c = widgetNumber;
        widgetJunction.Is_Visible__c = IsVisible;
        widgetJunction.User__c = userId;
        if(isInsert) {
            insert widgetJunction;
        }
        return widgetJunction;
    }
    
    public static List<Account> createCustomerAccount(boolean isToInsert,
													  Integer numberOfRecords
													) {
		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Account') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
		// Customer List
		List<Account> customerList = new List<Account>();
		
		// To create number Of records as per value Passed as argument
		for(Integer indexValue = 1; indexValue <= numberOfRecords; indexValue++) {
			// Customer record whose type is Individual
			Account individualCustomer = new Account(Name = 'Customer Name ' + indexValue,
				    								 FirstName__c = 'Customer FirstName '+ indexValue,
				    								 LastName__c = 'Customer LastName '+ indexValue,
				    								 Email__c='xyz@gmail.com',
				    								 Other_Email__c='xyz@gmail.com',
				    								 Type__c = 'Individual',
				    								 Is_Customer__c = true,
				    								 Home_Number__c= '9785587257',
				    								 Mobile__c='1234567890',
				    								 BillingStreet='200-164 Venables St',
				    								 BillingCity='Vancouver',
				    								 BillingCountry='Canada',
				    								 BillingState='British Columbia',
				    								 BillingPostalCode='V5L 2H1',
				    								 ShippingStreet='200-164 Venables St',
				    								 ShippingCity='Vancouver',
				    								 ShippingCountry='Canada',
				    								 ShippingState='British Columbia',
				    								 ShippingPostalCode='V5L 2H1'
				    							  );
    									
    			// Customer record whose type is not individual
    	 	Account otherCustomer = new Account(Name = 'Customer Name ' + indexValue,
    											FirstName__c = 'Customer FirstName '+ indexValue,
    											LastName__c = 'Customer LastName '+ indexValue,
			    								Email__c='xyz@gmail.com',
			    								Other_Email__c='xyz@gmail.com',
			    								Type__c = 'other',
			    								Is_Customer__c = true,
			    								Home_Number__c= '9785587257',
			    								Mobile__c='1234567890',
			    								BillingStreet='200-164 Venables St',
			    								BillingCity='Vancouver',
			    								BillingCountry='Canada',
			    								BillingState='British Columbia',
			    								BillingPostalCode='V5L 2H1',
			    								ShippingStreet='200-164 Venables St',
			    								ShippingCity='Vancouver',
			    								ShippingCountry='Canada',
			    								ShippingState='British Columbia',
			    								ShippingPostalCode='V5L 2H1'
    									
											    );
    		customerList.add(individualCustomer);
    		customerList.add(otherCustomer);
    	}
    	if(isToInsert && customerList.size() > 0) {
    		insert customerList;
    	}
    	return customerList;
	}
    
    public static List<Account> createVendorAccount(boolean isToInsert,
													  Integer numberOfRecords
													) {
		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Account') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
		// Vendor List
		List<Account> vendorList = new List<Account>();
		
		// To create number Of records as per value Passed as argument
		for(Integer indexValue = 1; indexValue <= numberOfRecords; indexValue++) {
			
			// Vendor record 
    		Account vendorAccount = new Account( Name = 'Vendor Name ' + indexValue,
			    								 FirstName__c = 'Vendor FirstName '+ indexValue,
			    								 LastName__c = 'Vendor LastName '+ indexValue,
			    								 Email__c='xyz@gmail.com',
			    								 Other_Email__c='xyz@gmail.com',
			    								 Is_Vendor__c = true,
			    								 Home_Number__c= '9785587257',
			    								 Mobile__c='1234567890',
			    								 BillingStreet='200-164 Venables St',
			    								 BillingCity='Vancouver',
			    								 BillingCountry='Canada',
			    								 BillingState='British Columbia',
			    								 BillingPostalCode='V5L 2H1',
			    								 ShippingStreet='200-164 Venables St',
			    								 ShippingCity='Vancouver',
			    								 ShippingCountry='Canada',
			    								 ShippingState='British Columbia',
			    								 ShippingPostalCode='V5L 2H1'
    										);
    		vendorList.add(vendorAccount);
    	}
    	
    	if(isToInsert && vendorList.size() > 0) {
    		insert vendorList;
    	}
    	return vendorList;
	}
    
    
    
    
    public static List<Accounting_Data_Migration__c> createAccountMigration( boolean isToInsert, Integer numberOfRecords, String objectName, String MYObObjectName) {
		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
		// Account data Migration List
		List<Accounting_Data_Migration__c> accountDataMigrationList = new List<Accounting_Data_Migration__c>();
		
		// To create number Of records as per value Passed as argument
		for(Integer indexValue = 1; indexValue <= numberOfRecords; indexValue++) {
			
			
			// Creating account Migrate Data
    		Accounting_Data_Migration__c accuntMigrateData = new Accounting_Data_Migration__c( Last_Synched_Date__c =  DateTime.newInstance(2016,06,13) ,
    																						   Object_Name__c = objectName,
    																						   MYOB_Object_Name__c = MYObObjectName
 																							);
    		accountDataMigrationList.add(accuntMigrateData);
    	}
    	
    	if(isToInsert && accountDataMigrationList.size() > 0) { 
    		insert accountDataMigrationList;
    	}
    	return accountDataMigrationList;
	}
	
	/**
     * Name: createFilter
     * Desc: Method to insert Filter Record
     * @param:  boolean isInsert - if record is inserted
     *          String  - 
     *          String - 
     * @return: 
    **/
    public static Filter__c createFilter(Boolean isInsert, String filterLabel, String commonFilterCategory, Boolean isCommon, Boolean isCustom, Boolean isFavorite) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Filter__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Filter__c filterRec = new Filter__c();
        filterRec.Filter_Label__c = filterLabel;
        filterRec.Common__c = isCommon;
        filterRec.CommonFilterCategory__c = commonFilterCategory;
        filterRec.Custom__c = isCustom;
        filterRec.Favorite__c = isFavorite;
        
        if(isInsert) {
            insert filterRec;
        }
        return filterRec;
    }
    
    /**
     * Name: getNamespace
     * Desc: Method to get Namespace
     * @return: 
    **/
   	public static String getNamespace(String className) {
   		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsAccessible('apexclass') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
       ApexClass testClass  = [Select Id, NamespacePrefix from apexclass where name = :className];
        if(testClass.NamespacePrefix == null){
            return '';
        }
       return testClass.NamespacePrefix+'__';
    }
    
    /**
     * Name: createNameSpaceInGeneralConfig
     * Desc: Method to get Namespace
     * @return: 
    **/
   	public static void createNameSpaceInGeneralConfig() {
   		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('General_Configurations__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
   		General_Configurations__c genConfig = General_Configurations__c.getInstance();
   		genConfig.Namespace__c = getNamespace('TestUtil');
   		insert genConfig;
    }
      
       /**
     * Name: createtaxsettingInGeneralConfig
     * Desc: Method to set tax setting
     * @return: 
    **/
   	public static void createtaxsettingInGeneralConfig() {
   		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Configurations__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
   		Configurations__c taxSetting = Configurations__c.getOrgDefaults();
   		taxSetting.Tax_Included_Pricing__c = true;
   		insert taxSetting;
    }
    
           /**
     * Name: createtaxsettingInGeneralConfigA
     * Desc: Method to set tax setting
     * @return: 
    **/
   	public static void createtaxsettingInGeneralConfigA() {
   		if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Configurations__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
   		Configurations__c taxSetting = Configurations__c.getOrgDefaults();
   		taxSetting.Tax_Included_Pricing__c = false;
   		insert taxSetting;
    }
    
    /**
     * Name: createTaxExemption
     * Desc: Method to taxexemption
     * @param:  boolean isInsert - if record is inserted
     *          String customer - customer ID
     *          String salesTaxItem - salestaxItemId
     * @return: inserted CO Header record
    **/
    public static Tax_Exemption__c createTaxExemption(boolean isInsert, String custId, String salestaxItemId) {
        if(!Test.isRunningTest() && AccessControl.ifObjectFieldIsCreateable('Tax_Exemption__c') == false) {throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        Tax_Exemption__c TaxExemption = new Tax_Exemption__c();
        TaxExemption.Customer__c = custId;
        TaxExemption.Sales_Tax_Item__c = salestaxItemId;
         
        if(isInsert) {
            insert TaxExemption;
        }
        return TaxExemption;
    }
}