/**
 * Author: 
 * Since: March 31, 2016
 * Name: MasterDataUploadCtrl
 * Description: Used to  serialize and deserialize JSON operations of different category for uploading of csv.
**/
global with sharing class MasterDataUploadCtrl {
    
    public static final String MAKE_TEMPLATE = 'Make_Model_Template';
    public static final String CATEGORY_TEMPLATE = 'Category_Template';
    public static final String SALES_TAX_TEMPLATE = 'Sales_Tax_Template';
    public static final String SALES_TAX_ITEM_TEMPLATE = 'Sales_Tax_Item_Template';
    public static final String COUNTRY_TEMPLATE = 'Country_State_Template';
    public static final String PRICE_LEVEL_TEMPLATE = 'Price_Level_Template';
    
    /**
     * Name: getTemplateUrl
     * Desc: Method which provides json of different template on load of the page
     * @param:  
     * @return: String - JSON String of  Documents
    **/
    @RemoteAction
    global static String getTemplateUrl() {
        List<String> TemplateDeveleoperName = new List<String>{ MAKE_TEMPLATE,CATEGORY_TEMPLATE,SALES_TAX_TEMPLATE,SALES_TAX_ITEM_TEMPLATE,COUNTRY_TEMPLATE,PRICE_LEVEL_TEMPLATE};
        if(AccessControl.ifObjectFieldIsAccessible('Document') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Document> docTemplateRecList = [Select Url, Id, DeveloperName From Document Where DeveloperName IN :TemplateDeveleoperName];
        
        List<TemplateLinkJSON> templateLinkJSONList = new List<TemplateLinkJSON>();
        for(Document docTemplateRec : docTemplateRecList){
            templateLinkJSONList.add(new TemplateLinkJSON(docTemplateRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(templateLinkJSONList));
    }
        
    /**
     * Name: insertCSVRecord
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     *         (2)String csvType  - Type of the CSV (For identification of the Object)
     * @return: 
    **/
    @RemoteAction
    global static String insertCSVRecord(String strList , String csvType ) {
        Savepoint sp = Database.setSavepoint();
        strList = BPUtility.getDecodedString(strList);
    	csvType = BPUtility.getDecodedString(csvType);
    	try{
        	if(AccessControl.ifObjectFieldIsCreateable('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Unit_Model__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('Sales_Tax_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	
            if(csvType.equals('Category Template')){
               List<Category__c> categoryListToInsert =  insertCategoryData(strList);
               insert categoryListToInsert ;
                
            } else if (csvType.equals('Price Level Template')){
                List<Price_Level__c> priceLevelListToInsert = insertPriceLevelData(strList);
                insert priceLevelListToInsert;
                     
            } else if(csvType.equals('Make Model Template')) {
                 string makeListToInsert =  insertMakeData(strList );
                 //insert makeListToInsert ;
            }else if(csvType.equals('Sales Tax Template')){
                List<Sales_Tax__c> salesTaxListToInsert = insertSalesTaxData(strList );
                insert salesTaxListToInsert;
            }else if(csvType.equals('Sales Tax Item Template')){
                List<Sales_Tax_Item__c> salesTaxListItemToInsert = insertSalesTaxItemData(strList );
                insert salesTaxListItemToInsert;
            }else if(csvType.equals('Country State Template')){
                String countryListToInsert = insertCountryData(strList );
                //insert countryListToInsert;
            }
        } catch(Exception e) {  
            Database.rollback(sp);
            if(e.getMessage().contains('DUPLICATE_VALUE')){
                throw new BlackPurlException(BlackPurlException.getUniqueKeyErrorForCSV(e.getMessage()));
            }else{
                throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
            }
        }
        return BPUtility.getEncodedString('Success');  
    }
     /**
     * Name: insertCategoryData
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     * @return: Error Message
    **/
    public static List<Category__c> insertCategoryData(String strList ){
        List<Category__c> categoryListToInsert = new List<Category__c>();
        List<Category> categorycsv = (List<Category>)System.JSON.deserialize(strList, List<Category>.class);
        for(Category categoryRec : categorycsv) {
            Category__c categoryObj = new Category__c();
            categoryObj.Name = categoryRec.Name;
            categoryObj.Type__c = categoryRec.Type;
            categoryObj.Description__c = categoryRec.Description; 
            categoryObj.COGS_GL__c = categoryRec.COGSGL;
            categoryObj.Income_GL__c = categoryRec.IncomeGL; 
            categoryObj.Inventory_GL__c = categoryRec.InventoryGL;
            categoryObj.Active__c = ((categoryRec.Active != null) && (categoryRec.Active.equalsIgnoreCase('true') || categoryRec.Active.equalsIgnoreCase('Yes'))) ? true : false;
            categoryObj.Default__c = ((categoryRec.DefaultValue != null) && (categoryRec.DefaultValue.equalsIgnoreCase('TRUE') || categoryRec.DefaultValue.equalsIgnoreCase('Yes'))) ? true : false;
            
            categoryListToInsert.add(categoryObj);
        }
        return categoryListToInsert;
    }
    /**
     * Name: insertPriceLevelData
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     * @return: Error Message
    **/   
     public static List<Price_Level__c> insertPriceLevelData(String strList ){
        List<Price_Level__c> priceLevelListToInsert = new List<Price_Level__c>();
        
        List<PriceLevel> priceLevelcsvList = (List<PriceLevel>)System.JSON.deserialize(strList, List<PriceLevel>.class);
        for(PriceLevel priceLevelRec : priceLevelcsvList){
            Price_Level__c priceLevelObj = new Price_Level__c(  Name__c = priceLevelRec.Name, 
                                                                Description__c = priceLevelRec.Description, 
                                                                Labour_Rate__c = priceLevelRec.LabourRate,
                                                                Part_Price_Base__c = priceLevelRec.PartPriceBase,
                                                                Discount_Markup__c = priceLevelRec.RateApplied
                                                         );
            priceLevelObj.Active__c = (priceLevelRec.Active.equalsIgnoreCase('TRUE') || priceLevelRec.Active.equalsIgnoreCase('Yes'))? true : false;
            priceLevelObj.Default__c = (priceLevelRec.DefaultValue.equalsIgnoreCase('TRUE') || priceLevelRec.DefaultValue.equalsIgnoreCase('Yes'))? true : false;
            
            priceLevelListToInsert.add(priceLevelObj);
        }
        return priceLevelListToInsert;
        
     }
     /**
     * Name: insertMakeData
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     * @return: Error Message
    **/    
    
    public static String insertMakeData(String strList ){
        List<Unit_Make__c> makeListToInsert = new List<Unit_Make__c>();
        List<Unit_Model__c> modelListToInsert = new List<Unit_Model__c>();
        
        Map<String, Id> MakeNameToIdMap = new Map<String, Id>();
        List<Unit_Make__c> makeList = [select Name from Unit_Make__c LIMIT: SOQLUtil.getAvailableQueryRowsLimit()];
        for(Unit_Make__c makeObj : makeList){
            MakeNameToIdMap.put(makeObj.Name , makeObj.Id);
         }
        Set<String> MakeNameSet  = new Set<String>();
        
        for( String str :  MakeNameToIdMap.keySet()){
            MakeNameSet.add(str);
        }
        List<MakeModel> makecsvList = (List<MakeModel>)System.JSON.deserialize(strList, List<MakeModel>.class);
        for(MakeModel makemodelRec : makecsvList){
            
            if(!MakeNameSet.contains(makemodelRec.Name)){
                Unit_Make__c makeObj = new Unit_Make__c(    Name = makemodelRec.Name, 
                                                            VIN_Code__c = makemodelRec.MakeVIN
                                                       );
                                                       
                makeObj.Active__c= (makemodelRec.Active.equalsIgnoreCase('TRUE') || makemodelRec.Active.equalsIgnoreCase('Yes'))? true : false; 
                makeListToInsert.add(makeObj);
                MakeNameSet.add(makemodelRec.Name);
            }
        }
        insert makeListToInsert;
        
        for(Unit_Make__c makeObj : makeListToInsert){
            MakeNameToIdMap.put(makeObj.Name , makeObj.Id);
         }
         for(MakeModel makemodelRec : makecsvList){
            if(!(String.isBlank(makemodelRec.Model))){
                Unit_Model__c modelObj = new Unit_Model__c( Name__c =  makemodelRec.Model,
                                                            Sub_Model__c = makemodelRec.SubModel,
                                                            VIN_Code__c = makemodelRec.ModelVIN,
                                                            Model_Description__c = makemodelRec.ModelDescription
                                                    );
                modelObj.Active__c= (makemodelRec.ModelActive.equalsIgnoreCase('TRUE') || makemodelRec.ModelActive.equalsIgnoreCase('Yes'))? true : false;                                              
                if(MakeNameToIdMap.containsKey(makemodelRec.Name)){
                    //system.Assert(false, modelObj );
                     modelObj.Unit_Make__c = MakeNameToIdMap.get(makemodelRec.Name);    
                } 
                modelListToInsert.add(modelObj);
             }
            
         }
         if(modelListToInsert.size()>0){
             insert modelListToInsert;
         }
        return '';
     }
    /**
     * Name: insertCountryData
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     * @return: Error Message
    **/    
      public static String insertCountryData(String strList ){
        
        Map<String, Id> countryNameToIdMap = new Map<String, Id>();
        if(AccessControl.ifObjectFieldIsAccessible('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Country__c> countryList = [select Name__c from Country__c LIMIT :SOQLUtil.getAvailableQueryRowsLimit()];
        if(AccessControl.ifObjectFieldIsCreateable('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        for(Country__c cObj : countryList){
            countryNameToIdMap.put(cObj.Name__c , cObj.Id);
        }
        
      
        List<State__c> stateListToInsert = new List<State__c>();
        List<Country__c> countryListToInsert = new List<Country__c>();
        Set<String> countryNameSet = new Set<String>();
        
        for( String str :  countryNameToIdMap.keySet()){
            countryNameSet.add(str);
        }
        
        
        
        List<CountryState> countrycsvList = (List<CountryState>)System.JSON.deserialize(strList, List<CountryState>.class);
        for(CountryState countryStateRec : countrycsvList){
            if(!countryNameSet.contains(countryStateRec.CountryName)){
                Country__c countryObj = new Country__c( Name__c = countryStateRec.CountryName 
                                                    );
                countryObj.Default__c= (countryStateRec.CountryDefaultValue.equalsIgnoreCase('TRUE') || countryStateRec.CountryDefaultValue.equalsIgnoreCase('Yes')) ? true : false;       
                countryObj.Visible__c= (countryStateRec.Visible.equalsIgnoreCase('TRUE') || countryStateRec.Visible.equalsIgnoreCase('Yes')) ? true : false;                                          
               
                countryListToInsert.add(countryObj);
                countryNameSet.add(countryStateRec.CountryName);
            }
        }
         insert countryListToInsert;
         
         for(Country__c cObj : countryListToInsert){
            countryNameToIdMap.put(cObj.Name__c , cObj.Id);
         }
        
         for(CountryState countryStateRec : countrycsvList){
               if(!(String.isBlank(countryStateRec.StateName))){
                    State__c stateObj = new State__c(Name__c =  countryStateRec.StateName);
                    if(countryNameToIdMap.containsKey(countryStateRec.CountryName)){
                        stateObj.Country__c = countryNameToIdMap.get(countryStateRec.CountryName);  
                    }
                    stateObj.Default__c= (countryStateRec.StateDefaultValue.equalsIgnoreCase('TRUE') || countryStateRec.StateDefaultValue.equalsIgnoreCase('Yes')) ? true : false; 
                    
                    stateListToInsert.add(stateObj);
               }
         }
            
        if(stateListToInsert.size()>0){
             insert stateListToInsert;
         }
        return '';
      }
    /**
     * Name: insertSalesTaxData
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     * @return: Error Message
    **/   
     public static List<Sales_Tax__c> insertSalesTaxData(String strList ){
        List<Sales_Tax__c> salesTaxListToInsert = new List<Sales_Tax__c>();
        List<SalesTax> salesTaxcsvList = (List<SalesTax>)System.JSON.deserialize(strList, List<SalesTax>.class);
        for(SalesTax salesTaxRec : salesTaxcsvList){
            Sales_Tax__c salesTaxObj = new Sales_Tax__c(    Name__c = salesTaxRec.Name, 
                                                            Rate__c = salesTaxRec.Rate,
                                                            Forms_Label__c = salesTaxRec.FormsLabel
                                                         );
            salesTaxObj.Active__c = (salesTaxRec.Active.equalsIgnoreCase('TRUE') || salesTaxRec.Active.equalsIgnoreCase('Yes')) ? true : false;
            salesTaxObj.Default__c = (salesTaxRec.DefaultValue.equalsIgnoreCase('TRUE') || salesTaxRec.DefaultValue.equalsIgnoreCase('Yes')) ? true : false;
            salesTaxObj.Forms_List_Taxes__c = (salesTaxRec.FormsListTaxes.equalsIgnoreCase('TRUE') || salesTaxRec.FormsListTaxes.equalsIgnoreCase('Yes')) ? true : false;
            
            salesTaxListToInsert.add(salesTaxObj);
        }
        return salesTaxListToInsert;
     }
    /**
     * Name: insertSalesTaxItemData
     * Desc: Method which insert the CSV record according to the CSV type
     * @param: (1)String strList - JSON of the CSV Uploaded
     * @return: Error Message
    **/ 
      public static List<Sales_Tax_Item__c> insertSalesTaxItemData(String strList ){
        List<Sales_Tax_Item__c> salesTaxListItemToInsert = new List<Sales_Tax_Item__c>();
        List<SalesTaxItem> salesTaxItemcsvList = (List<SalesTaxItem>)System.JSON.deserialize(strList, List<SalesTaxItem>.class);
        for(SalesTaxItem salesTaxItemRec : salesTaxItemcsvList){
            Sales_Tax_Item__c salesTaxItemObj = new Sales_Tax_Item__c(  Name__c = salesTaxItemRec.TaxName, 
                                                                        Rate__c = salesTaxItemRec.Rate,
                                                                        Forms_Label__c = salesTaxItemRec.FormsLabel
                                                            );
            salesTaxItemObj.Tax_Parts__c = (salesTaxItemRec.TaxParts.equalsIgnoreCase('TRUE') || salesTaxItemRec.TaxParts.equalsIgnoreCase('Yes')) ? true : false;
            salesTaxItemObj.Tax_Misc__c = (salesTaxItemRec.TaxMisc.equalsIgnoreCase('TRUE') || salesTaxItemRec.TaxMisc.equalsIgnoreCase('Yes')) ? true : false;
            salesTaxItemObj.Tax_Labour__c = (salesTaxItemRec.TaxLabour.equalsIgnoreCase('TRUE') || salesTaxItemRec.TaxLabour.equalsIgnoreCase('Yes')) ? true : false;
            salesTaxItemObj.Tax_Units__c = (salesTaxItemRec.TaxUnits.equalsIgnoreCase('TRUE') || salesTaxItemRec.TaxUnits.equalsIgnoreCase('Yes')) ? true : false;
            salesTaxItemObj.Active__c = (salesTaxItemRec.Active.equalsIgnoreCase('TRUE') || salesTaxItemRec.Active.equalsIgnoreCase('Yes')) ? true : false;
            
            salesTaxListItemToInsert.add(salesTaxItemObj);
        }
        return salesTaxListItemToInsert;
      }
    /**
     * Name: TemplateLinkJSON
     * Description: Sets the value of the TemplateLinkJSON
    **/
    public class TemplateLinkJSON{
        public String Id;
        public String Url;
        public String DocumentUniqueName;
        
        public TemplateLinkJSON(Document doc) {
            this.Id = doc.Id;
            this.Url = '/servlet/servlet.FileDownload?file='+ doc.Id;
            this.DocumentUniqueName = doc.DeveloperName;
        }
        
    }
    
    /**
     * Name: Category
     * Description: Sets the value of the Category
    **/
    public class Category{
        public String Name;
        public String Type;
        public String Description;
        public String IncomeGL;
        public String COGSGL;
        public String InventoryGL;
        public String DefaultValue;
        public String Active;
        
        public Category(){
            
        }
    }
    
    /**
     * Name: MakeModel
     * Description: Sets the value of the MakeModel
    **/
    public class MakeModel{
        public String Name;
        public String MakeVIN;
        public String Active;
        public String Model;
        public String SubModel;
        public String ModelVIN;
        public String ModelDescription;
        public String ModelActive;
        
        public MakeModel(){
            
        }
    }
    /**
     * Name: PriceLevel
     * Description: Sets the value of the PriceLevel
    **/
    public class PriceLevel{
        public String Name;
        public String Description;
        public String PartPriceBase;
        public Decimal LabourRate;
        public String DefaultValue;
        public String Active;
        public Decimal RateApplied;
        
        
        public PriceLevel(){
            
        }
    }
    /**
     * Name: SalesTax
     * Description: Sets the value of the SalesTax
    **/
    public class SalesTax{
        public String Name;
        public String FormsLabel;
        public String FormsListTaxes;
        public Decimal Rate;
        public String DefaultValue;
        public String Active;
        
        
        public SalesTax(){
            
        }
    }
    /**
     * Name: SalesTaxItem
     * Description: Sets the value of the SalesTaxItem
    **/
     
    public class SalesTaxItem{
        public String TaxName;
        public Decimal Rate;
        public String TaxParts;
        public String TaxMisc; 
        public String TaxLabour;
        public String TaxUnits;
        public String FormsLabel;
        public String Active;
        
        public SalesTaxItem(){
            
        }
    }
     /**
     * Name: Country
     * Description: Sets the value of the Country
    **/
     
    public class CountryState{
        public String CountryName;
        public String CountryDefaultValue;
        public String Visible;
        public String StateName;
        public String StateDefaultValue;
        
        public CountryState(){
            
        }
    }
  
  
    

}