@isTest
private class MasterDataUploadCtrlTest {

    @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }
    
    static testMethod void testGetTemplateUrl(){
        
        String templateJSON = BPUtility.getDecodedString(MasterDataUploadCtrl.getTemplateUrl());
        System.assertEquals(true, templateJSON.contains('[]') && templateJSON.length()==2);
    }
    
    static testMethod void testInsertCategoryData(){
        
        List<MasterDataUploadCtrl.Category> categoryList = new List<MasterDataUploadCtrl.Category>();
        MasterDataUploadCtrl.Category categoryObj =  new MasterDataUploadCtrl.Category();
        categoryObj.Name = 'Test Category';
        categoryObj.Type= 'Test';
        categoryObj.Description = 'Test Description ';
        categoryObj.Active= 'True';
        categoryList.add(categoryObj);
        
        String templateJSON = JSON.serialize(categoryList);
        
        MasterDataUploadCtrl.insertCSVRecord(BPUtility.getEncodedString(templateJSON),BPUtility.getEncodedString('Category Template'));
        List<Category__c> insertedCategoryList = [select id from Category__c];
        System.assertEquals(insertedCategoryList.size(), 1);
    }
    
    static testMethod void testInsertPriceLevelData(){
        
        List<MasterDataUploadCtrl.PriceLevel> priceLevelList = new List<MasterDataUploadCtrl.PriceLevel>();
        MasterDataUploadCtrl.PriceLevel priceLevelObj =  new MasterDataUploadCtrl.PriceLevel();
        priceLevelObj.Name = 'Test PriceLevel';
        priceLevelObj.Description = 'Test Description ';
        priceLevelObj.Active = 'True';
        priceLevelObj.DefaultValue = 'True';
        priceLevelList.add(priceLevelObj);
        
        String templateJSON = JSON.serialize(priceLevelList);
        
        MasterDataUploadCtrl.insertCSVRecord(BPUtility.getEncodedString(templateJSON),BPUtility.getEncodedString('Price Level Template'));
        List<Price_Level__c> insertedPriceLevelList = [select id from Price_Level__c];
        System.assertEquals(insertedPriceLevelList.size(), 1);
    }
    
    static testMethod void testInsertUnitModelData(){
        
        List<MasterDataUploadCtrl.MakeModel> unitMakeList = new List<MasterDataUploadCtrl.MakeModel>();
        MasterDataUploadCtrl.MakeModel unitMakeObj =  new MasterDataUploadCtrl.MakeModel();
        unitMakeObj.Name = 'Test MakeModel';
        unitMakeObj.Model = 'Test Model';
        unitMakeObj.ModelDescription = 'Test Description ';
        unitMakeObj.Active = 'True';
        unitMakeObj.ModelActive = 'True';
        unitMakeObj.MakeVIN = '123';
        unitMakeList.add(unitMakeObj);
        
        String templateJSON = JSON.serialize(unitMakeList);
        
        MasterDataUploadCtrl.insertCSVRecord(BPUtility.getEncodedString(templateJSON),BPUtility.getEncodedString('Make Model Template'));
        List<Unit_Make__c> insertedUnitMakeList = [select id from Unit_Make__c];
        System.assertEquals(insertedUnitMakeList.size(), 1);
    }
    
    static testMethod void testInsertSalesTaxData(){
        
        List<MasterDataUploadCtrl.SalesTax> salesTaxList = new List<MasterDataUploadCtrl.SalesTax>();
        MasterDataUploadCtrl.SalesTax salesTaxObj =  new MasterDataUploadCtrl.SalesTax();
        salesTaxObj.Name = 'Test PriceLevel';
        salesTaxObj.DefaultValue = 'True';
        salesTaxObj.Active= 'True';
        salesTaxObj.FormsListTaxes = 'True';
        salesTaxList.add(salesTaxObj);
        
        String templateJSON = JSON.serialize(salesTaxList);
        
        MasterDataUploadCtrl.insertCSVRecord(BPUtility.getEncodedString(templateJSON),BPUtility.getEncodedString('Sales Tax Template'));
        List<Sales_Tax__c> insertedsalesTaxList = [select id from Sales_Tax__c];
        System.assertEquals(insertedsalesTaxList.size(), 1);
    }
    
    static testMethod void testInsertSalesTaxItemData(){
        
        List<MasterDataUploadCtrl.SalesTaxItem> salesTaxItemList = new List<MasterDataUploadCtrl.SalesTaxItem>();
        MasterDataUploadCtrl.SalesTaxItem salesTaxItemObj =  new MasterDataUploadCtrl.SalesTaxItem();
        salesTaxItemObj.TaxName = 'Test SalesTaxItem';
        salesTaxItemObj.Rate = 20;
        salesTaxItemObj.Active = 'True';
        salesTaxItemObj.TaxParts = 'True';
        salesTaxItemObj.TaxMisc = 'True'; 
        salesTaxItemObj.TaxLabour = 'True';
        salesTaxItemObj.TaxUnits = 'True';
        salesTaxItemObj.FormsLabel = 'Test Label';
        salesTaxItemList.add(salesTaxItemObj);
        
        String templateJSON = JSON.serialize(salesTaxItemList);
        
        MasterDataUploadCtrl.insertCSVRecord(BPUtility.getEncodedString(templateJSON),BPUtility.getEncodedString('Sales Tax Item Template'));
        List<Sales_Tax_Item__c> insertedSalesTaxItemList = [select id from Sales_Tax_Item__c];
        System.assertEquals(insertedSalesTaxItemList.size(), 1);
    }
    
    static testMethod void testInsertStateData(){
        
        List<MasterDataUploadCtrl.CountryState> countryList = new List<MasterDataUploadCtrl.CountryState>();
        MasterDataUploadCtrl.CountryState countryObj =  new MasterDataUploadCtrl.CountryState();
        countryObj.CountryName = 'Test Country';
        countryObj.Visible = 'True';
        countryObj.StateDefaultValue= 'True';
        countryObj.CountryDefaultValue = 'True';
        countryObj.StateName = 'Test State';
        countryList.add(countryObj);
        
        String templateJSON = JSON.serialize(countryList);
        
        MasterDataUploadCtrl.insertCSVRecord(BPUtility.getEncodedString(templateJSON),BPUtility.getEncodedString('Country State Template'));
        List<Country__c> insertedCountryList = [select id from Country__c];
        System.assertEquals(insertedCountryList.size(), 1);
    }
}