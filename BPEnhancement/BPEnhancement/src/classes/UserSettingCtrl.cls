/**
* Author: Ankit Jain
* Since: June 30, 2016
* Name: UserSettingCtrl
* Description: Apex class which contains all remoted methods related to UserSetting Page.
**/
 
global with sharing class UserSettingCtrl {
    
    public Boolean IsTrialOrg { get{return GeneralConfiguration.isTrialOrg();} private set;}
    public String communityURL { get{return GeneralConfiguration.communityLink();} private set;}
    public String communityquestionURL { get{return GeneralConfiguration.communityLink();} private set;}
    public String communitycaseURL { get{return GeneralConfiguration.communityLink();} private set;}
    private static final String PROFILE_NAME = 'System Administrator';
    private static final Integer MAX_TRAIL_USERS = 5;
    
    
    /**
     * Name: getAllUsers
     * Desc: Method which gives  List of Users which have ChatterFree profile in the org
       @param:    
     * @return: String - JSON String of list of Users which have ChatterFree profile in the org
    **/
    @RemoteAction
    global static String getAllUsers(){
        if(AccessControl.ifObjectFieldIsAccessible('Profile') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Profile> ProfilesList = [Select Id from Profile where Name =: PROFILE_NAME];
        List<User> userList = [Select Name, Email from User where isActive = true and ProfileId = :ProfilesList[0].Id Limit : MAX_TRAIL_USERS];
        List<UserWrapper> userWrapperList = new List<UserWrapper>();
        for(User userRecord : userList){
            UserWrapper userWrapperRecord = new UserWrapper(userRecord.Name,userRecord.Email,false,userRecord.Id);
            userWrapperList.add(userWrapperRecord);
        }
        return BPUtility.getEncodedString(System.JSON.serialize(userWrapperList));
    }
    /**
     * Name: createUsers
     * Desc: Method which gives  creates new users of the Org
     * @param:  (1) JSONString - String - JSON String of UserWrapperList
     * @return: None
    **/

    @RemoteAction
    global static String createUsers(String userWrapperStringList){
        userWrapperStringList = BPUtility.getDecodedString(userWrapperStringList);
        List<UserWrapper> userWrapperList = new List<UserWrapper>();
        userWrapperList = (List<UserWrapper>)System.JSON.deserialize(userWrapperStringList,List<UserWrapper>.class);
        List<User> userList = new List<User>();
        if(AccessControl.ifObjectFieldIsAccessible('Profile') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Profile> ProfilesList = [Select id from Profile where name =: PROFILE_NAME];
        for(UserWrapper userWrapperRecord :userWrapperList){
            if(!String.isBlank(userWrapperRecord.name) &&  !String.isBlank(userWrapperRecord.email)){
                User newUserRecord = new User();
                Integer positionOfSpace  = userWrapperRecord.name.indexof(' ');
                if(positionOfSpace == -1){
                    newUserRecord.LastName = userWrapperRecord.name;
                }
                else {
                    newUserRecord.FirstName = userWrapperRecord.name.substring(0,positionOfSpace);
                    newUserRecord.LastName = userWrapperRecord.name.substring(positionOfSpace);
                }
                newUserRecord.Email = userWrapperRecord.email;
                if(userWrapperRecord.name.length() > 6){
                    newUserRecord.Alias = userWrapperRecord.name.substring(0,6);
                }
                else{
                    newUserRecord.Alias = userWrapperRecord.name;
                }
                newUserRecord.Username = userWrapperRecord.email;
                newUserRecord.CommunityNickname = (userWrapperRecord.name.substring(0,3) + Math.random()).substring(0,8);
                newUserRecord.LocaleSidKey = 'en_US';
                newUserRecord.TimeZoneSidKey = 'GMT';
                newUserRecord.ProfileID = ProfilesList.get(0).id;
                newUserRecord.LanguageLocaleKey = 'en_US';
                newUserRecord.EmailEncodingKey = 'UTF-8';
                userList.add(newUserRecord);
            }
        }
        try{
            if(AccessControl.ifObjectFieldIsCreateable('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            insert userList;
        }
        catch(Exception e){
            if(e.getMessage().contains('DUPLICATE_USERNAME')){
                throw new BlackPurlException('Username already registered.');
            }else{
                throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
            }
        }
        return getAllUsers();
    }
    
    /**
     * Name: getPriceAndTaxMasterData
     * Desc: Method that provides List of all sales tax and price levels
       @param:  
     * @return: String - JSON String of lists of both sales tax and price levels
    **/
    @RemoteAction
    global static String getPriceAndTaxMasterData() {
        List<Sales_Tax__c> salesTaxList = SOQLUtil.getSalesTax(new List<Id>());
        List<Price_Level__c> priceLevelList = SOQLUtil.getPriceLevel(new List<Id>());
        List<Country__c> countryList = SOQLUtil.getAllCountry();
        List<Country__c> countryWrapperList = SOQLUtil.getAllCountryWrapper();
        PriceAndTaxMasterData priceAndTaxMasterDataObj = new PriceAndTaxMasterData(salesTaxList, priceLevelList,countryList,countryWrapperList);
        
        return BPUtility.getEncodedString(System.Json.serialize(priceAndTaxMasterDataObj));
    }
    
    /**
     * Name: getCurrentConfiguration
     * Desc: Method that provides current configuration data to show on user setting - price and tax section
       @param:  
     * @return: String - JSON String of current configuration data
    **/
    @RemoteAction
    global static String getCurrentConfiguration() {
        List<Price_Level__c> priceLevelList = [Select Id, Name__c from Price_Level__c where Default__c = true];
        Price_Level__c defaultPriceLevelRec;
        if(priceLevelList.size() > 0) {
            defaultPriceLevelRec = priceLevelList[0];
        } else {
            defaultPriceLevelRec = new Price_Level__c();
        }
        PriceAndTaxWrapper priceAndTaxWrapperObj = new PriceAndTaxWrapper(defaultPriceLevelRec);
        //System.assert(false, priceAndTaxWrapperObj);
        return BPUtility.getEncodedString(System.JSON.serialize(priceAndTaxWrapperObj));
    }
    
    /**
     * Name: savePriceAndTax
     * Desc: Method to save new configuration for sales tax and price level
       @param:  
    **/
    @RemoteAction
    global static string savePriceAndTax(String priceAndTaxJsonData){
        if(AccessControl.ifObjectFieldIsUpdateable('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        
        priceAndTaxJsonData = BPUtility.getDecodedString(priceAndTaxJsonData);
        PriceAndTaxWrapper priceAndTaxWrapperObj = (PriceAndTaxWrapper) System.JSON.deserialize(priceAndTaxJsonData, PriceAndTaxWrapper.class);
        update new Price_Level__c(Id = priceAndTaxWrapperObj.defaultPriceLevel, Default__c = true);
        List<Sobject> sobjList = new List<Sobject>();
        
        Configurations__c configurationSettingObj = Configurations__c.getOrgDefaults();
        configurationSettingObj.Default_Tax_on_Labor__c = priceAndTaxWrapperObj.defaultLaborTax;
        configurationSettingObj.Default_Tax_on_Vendor_Product__c = priceAndTaxWrapperObj.defaultVendorItemTax;
        configurationSettingObj.Default_Tax_on_Part__c = priceAndTaxWrapperObj.defaultPartTax;
        configurationSettingObj.Default_Tax_on_Fee__c = priceAndTaxWrapperObj.defaultFeeTax;
        configurationSettingObj.Default_Tax_on_Unit__c = priceAndTaxWrapperObj.orderingTaxRate;
        configurationSettingObj.Tax_Included_Pricing__c = priceAndTaxWrapperObj.priceIncludeTax;
        configurationSettingObj.Country_Id__c = priceAndTaxWrapperObj.regionId;
        configurationSettingObj.State_Id__c = priceAndTaxWrapperObj.stateId;
        configurationSettingObj.Time_Zone__c = priceAndTaxWrapperObj.timezoneId;
        configurationSettingObj.Tax_Id__c = priceAndTaxWrapperObj.taxId;
        
        sobjList.add(configurationSettingObj);
        upsert configurationSettingObj;
        
        return getCurrentConfiguration();
    }
    
    /**
     * Name: getBusinessProfileMasterData
     * Desc: Method that provides master data for business profile section
       @param:  
     * @return: String - JSON String of lists of countries and states along with business profile warpper object
    **/
    @RemoteAction
    global static String getBusinessProfileMasterData(){
        List<Country__c> countryWrapperList = SOQLUtil.getAllCountryWrapper();
        List<Business_Profile__c> businessProfiles = SOQLUtil.getBusinessProfileData(new List<id>());
        BusinessProfileMasterData businessProfileMasterDataObj = new BusinessProfileMasterData(countryWrapperList, businessProfiles);
        
        return BPUtility.getEncodedString(System.JSON.serialize(businessProfileMasterDataObj));
    }
    
     /**
     * Name: getBillingProfile
     * Desc: Method that provides master data for business profile section
       @param:  
     * @return: String - JSON String of lists of countries and states along with business profile warpper object
    **/
     @RemoteAction 
     global static Integer getBillingProfile(){
        if(AccessControl.ifObjectFieldIsAccessible('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<User> userList = [Select id, createddate from user ORDER BY createddate ASC];
        Date startDate = Date.valueOf(userList[0].createdDate);  
        Integer noOfDays = (30 - startDate.daysBetween(Date.today()));
        return noOfDays;
    }
    
    
    /**
     * Name: saveBusinessProfile
     * Desc: Method to save new configuration for business profile
       @param:  
    **/
    @RemoteAction
    global static string saveBusinessProfile(String BusinessProfileJsonData){
        BusinessProfileJsonData = BPUtility.getDecodedString(BusinessProfileJsonData);
        
        BusinessProfileWrapper businessProfileObj = (BusinessProfileWrapper) System.JSON.deserialize(BusinessProfileJsonData, BusinessProfileWrapper.class);
        
        Business_Profile__c businessProfile = new Business_Profile__c();
        
        if(businessProfileObj.Id == null){
            if(AccessControl.ifObjectIsCreateable('Business_Profile__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        }else{
            if(AccessControl.ifObjectIsUpdateable('Business_Profile__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
            businessProfile.Id = businessProfileObj.Id;
        }
        
        businessProfile.Business_Name__c = businessProfileObj.BusinessName;
        businessProfile.Business_Phone__c = businessProfileObj.BusinessPhone;
        businessProfile.Business_Email__c = businessProfileObj.BusinessEmail;
        businessProfile.Business_Street_Address1__c = businessProfileObj.BusinessStreetAddress1;
        businessProfile.Business_Street_Address2__c = businessProfileObj.BusinessStreetAddress2;
        businessProfile.Business_City__c = businessProfileObj.BusinessCity;
        businessProfile.Business_Postal_Code__c = businessProfileObj.BusinessZipCode;
        businessProfile.Business_Country__c = businessProfileObj.BusinessCountryId;
        businessProfile.Business_State__c = businessProfileObj.BusinessStateId;
        
        businessProfile.Same_As_Business_Address__c = businessProfileObj.IsSameAsBusinessAddress;
        
        if(businessProfileObj.isSameAsBusinessAddress == true){
            businessProfile.Shipping_Street_Address1__c = businessProfileObj.BusinessStreetAddress1;
            businessProfile.Shipping_Street_Address2__c = businessProfileObj.BusinessStreetAddress2;
            businessProfile.Shipping_City__c = businessProfileObj.BusinessCity;
            businessProfile.Shipping_Postal_Code__c = businessProfileObj.BusinessZipCode;
            businessProfile.Shipping_Country__c = businessProfileObj.BusinessCountryId;
            businessProfile.Shipping_State__c = businessProfileObj.BusinessStateId;
        }else{
            businessProfile.Company_Name_Optional__c = businessProfileObj.ShippingCompanyName;
            businessProfile.Shipping_Street_Address1__c = businessProfileObj.ShippingStreetAddress1;
            businessProfile.Shipping_Street_Address2__c = businessProfileObj.ShippingStreetAddress2;
            businessProfile.Shipping_City__c = businessProfileObj.ShippingCity;
            businessProfile.Shipping_Postal_Code__c = businessProfileObj.ShippingZipCode;
            businessProfile.Shipping_Country__c = businessProfileObj.ShippingCountryId;
            businessProfile.Shipping_State__c = businessProfileObj.ShippingStateId;
        }
       
        upsert businessProfile;
        
        return getBusinessProfileMasterData();
    }
    
    
    
    /**
     * Name: sendEmail
     * Desc: Method to send Email for support and contact
       @param:  
    **/
    @RemoteAction
    global static String sendEmail(String subjectKey){
        subjectKey = BPUtility.getDecodedString(subjectKey);
        
        List<Business_Profile__c> businessProfiles = SOQLUtil.getBusinessProfileData(new List<id>());
        Business_Profile__c businessProfileObj = businessProfiles.size() > 0 ? businessProfiles[0] : null;
        String companyName = businessProfileObj != null ? businessProfileObj.Business_Name__c : '';
        String subject = getMailSubject(subjectKey, companyName);
        String htmlBody = getEmailTemplateBody(subjectKey, businessProfileObj);
        
        String defaultEmail = GeneralConfiguration.getSupportEmail();
        List<String> emailStrList = new List<String>{defaultEmail};
        try{
            SendEmail.sendSupportMail(emailStrList, subject, htmlBody); 
        }catch(Exception e){
            throw new BlackPurlException('Some error occurend in sending mail.');
        }
        
        return BPUtility.getEncodedString('An email has been sent to our support team. You will be contacted shortly.');
    }
    
    
 	/* deprecated */
    global static string sendEmail(String subject, String htmlBody){
        /*subject = BPUtility.getDecodedString(subject);
        htmlBody = BPUtility.getDecodedString(htmlBody);
        String defaultEmail = 'hitesh.gupta@metacube.com';
        List<String> emailStrList = new List<String>{defaultEmail};
        try{
            SendEmail.sendSupportMail(emailStrList, subject, htmlBody); 
        }catch(Exception e){
            throw new BlackPurlException('Some error occurend in sending mail.');
        }
        */
        return BPUtility.getEncodedString('');
    }
    
    public static String getMailSubject(String subjectKey, String companyName) {
        if(subjectKey == 'Add Licences'){
             return '[License Request] : Add user license request for '+ companyName;
        }
        else if(subjectKey == 'Buy More Licences'){
             return '[License Request] : Add user license request for '+ companyName;
        }
        else if(subjectKey == 'Upgrade Your Account'){
             return ' [Account Upgrade Request] : Upgrade Account status for '+companyName;
        }
        else if(subjectKey == 'Cancel Your Licences'){
             return '[License Cancel Request] : Cancel user license request for '+companyName;
        }else{
            return '';          
        }
    }
    
    public static String getEmailTemplateBody(String subjectKey, Business_Profile__c businessProfileObj) {
        String htmlBody = '';
        Boolean IsTrialOrg = GeneralConfiguration.isTrialOrg();
        Boolean IsSystemSettingVisited = GeneralConfiguration.isSystemSettingVisited();
        String LicenseStatus = IsTrialOrg ? (IsSystemSettingVisited ? 'Trial with own data' : 'Trial with Demo data') : 'Licensed';
        if(businessProfileObj == null){
            htmlBody = 'No information provided';
        }else{
            if(subjectKey == 'Add Licences'){
                htmlBody += '<p>A request has been sent to add more users licences by </p>';
                htmlBody += '<p>Company Name :-   '+ BusinessProfileObj.Business_Name__c +'</p>';
                htmlBody += '<p>Org ID :-         '+ UserInfo.getOrganizationId() +'</p>';
                htmlBody += '<p>License Status :- '+ LicenseStatus +'</p>';
                htmlBody += '<p>Contact Number :- '+ BusinessProfileObj.Business_Phone__c +'</p>';
                htmlBody += '<p>Email :-          '+ BusinessProfileObj.Business_Email__c +'</p>';
            }
            else if(subjectKey == 'Buy More Licences'){
                htmlBody += '<p>A request has been sent to add more users licences by </p>';
                htmlBody += '<p>Company Name :-   '+ BusinessProfileObj.Business_Name__c +'</p>';
                htmlBody += '<p>Org ID :-         '+ UserInfo.getOrganizationId() +'</p>';
                htmlBody += '<p>License Status :- '+ LicenseStatus +'</p>';
                htmlBody += '<p>Contact Number :- '+ BusinessProfileObj.Business_Phone__c +'</p>';
                htmlBody += '<p>Email :-          '+ BusinessProfileObj.Business_Email__c +'</p>';
            }
            else if(subjectKey == 'Upgrade Your Account'){
                htmlBody += '<p>A request has been sent to upgrade account status by </p>';
                htmlBody += '<p>Company Name :-   '+ BusinessProfileObj.Business_Name__c +'</p>';
                htmlBody += '<p>Org ID :-         '+ UserInfo.getOrganizationId() +'</p>';
                htmlBody += '<p>License Status :- '+ LicenseStatus +'</p>';
                htmlBody += '<p>Contact Number :- '+ BusinessProfileObj.Business_Phone__c +'</p>';
                htmlBody += '<p>Email :-          '+ BusinessProfileObj.Business_Email__c +'</p>';
            }
            else if(subjectKey == 'Cancel Your Licences'){
                htmlBody += '<p>A request has been sent to cancel/reduce user licences status by </p>';
                htmlBody += '<p>Company Name :-   '+ BusinessProfileObj.Business_Name__c +'</p>';
                htmlBody += '<p>Org ID :-         '+ UserInfo.getOrganizationId() +'</p>';
                htmlBody += '<p>License Status :- '+ LicenseStatus +'</p>';
                htmlBody += '<p>Contact Number :- '+ BusinessProfileObj.Business_Phone__c +'</p>';
                htmlBody += '<p>Email :-          '+ BusinessProfileObj.Business_Email__c +'</p>';
            }
        }
        return htmlBody;
    }
    
    
    /**
     * Name: upgradeAccount
     * Desc: Method to send Email for upgrade Account
       @param:  
    **/
    @RemoteAction
    global static string upgradeAccount(String billingInfo){
        billingInfo = BPUtility.getDecodedString(billingInfo);
        
        BillingWrapper billingInfoObj = (BillingWrapper)System.JSON.deserialize(billingInfo, BillingWrapper.class);
        String UpgradeDate = '';
        if(billingInfoObj.UpgradeDate != null){
            Date d = Date.valueOf(billingInfoObj.UpgradeDate);
            DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day());
            UpgradeDate = dt.format('dd-MMM-YYYY');
        }
        Boolean IsTrialOrg = GeneralConfiguration.isTrialOrg();
        Boolean IsSystemSettingVisited = GeneralConfiguration.isSystemSettingVisited();
        String LicenseStatus = IsTrialOrg ? (IsSystemSettingVisited ? 'Trial with own data' : 'Trial with Demo data') : 'Licensed';
        List<Business_Profile__c> businessProfiles = SOQLUtil.getBusinessProfileData(new List<id>());
        Business_Profile__c businessProfileObj = businessProfiles.size() > 0 ? businessProfiles[0] : null;
        String companyName = businessProfileObj != null ? businessProfileObj.Business_Name__c : '';
        String subject = '[Upgrade Account Request] : Upgrade Account request for '+companyName;
        String htmlBody = '';
        
        if(businessProfileObj == null){
            htmlBody = 'No information provided';
        }else{
            htmlBody += '<p>A request has been sent to upgrade Account by </p>';
            htmlBody += '<p>Phone No:-    '+ billingInfoObj.IDDCode+'-'+billingInfoObj.Phone+'</p>';
            htmlBody += '<p>Date :-   '+ UpgradeDate +'</p>';
            htmlBody += '<p>Time :-   '+ billingInfoObj.UpgradeTime +'</p>';
            htmlBody += '<p style="font-weight: bold;">Business Information :-</p>';
            htmlBody += '<p>Company Name :-   '+ BusinessProfileObj.Business_Name__c +'</p>';
            htmlBody += '<p>Org ID :-         '+ UserInfo.getOrganizationId() +'</p>';
            htmlBody += '<p>License Status :- '+ LicenseStatus +'</p>';
            htmlBody += '<p>Contact Number :- '+ BusinessProfileObj.Business_Phone__c +'</p>';
            htmlBody += '<p>Email :-          '+ BusinessProfileObj.Business_Email__c +'</p>';
        }
        
        String defaultEmail = GeneralConfiguration.getSupportEmail();
        List<String> emailStrList = new List<String>{defaultEmail};
        try{
            SendEmail.sendSupportMail(emailStrList, subject, htmlBody); 
        }catch(Exception e){
            throw new BlackPurlException('Some error occurend in sending mail.');
        }
        
        return BPUtility.getEncodedString('An email has been sent to our support team. You will be contacted shortly.');
    }
    
    
    /**
     * Name: setSystemSettingVisited
     * Desc: Method to set system setting visited flag to true
       @param:  
    **/
    @RemoteAction
    global static void setSystemSettingVisited(){
        Boolean IsSystemSettingVisited = GeneralConfiguration.isSystemSettingVisited();
        if(!IsSystemSettingVisited){
            General_Configurations__c GCObj = General_Configurations__c.getOrgDefaults();
            GCObj.Is_System_Setting_Visited__c = true;
            upsert GCObj;
        }
    }
    
    /**
     * Name: getExportFiles
     * Desc: Method to send Email for support and contact
       @param:  
    **/
    @RemoteAction
    global static string getExportFiles(){
        if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<ExportedData> exportedFiles = new List<ExportedData>();
        
        // get all accounting data records with Attachments as inner list
        for(Accounting_Data_Migration__c adm : [Select Id, Object_Name__c, Last_Synched__c, (Select Id, Name, CreatedDate, CreatedBy.Name, LastModifiedDate From Attachments) from Accounting_Data_Migration__c LIMIT : Limits.getLimitQueryRows() - Limits.getQueryRows()]){
            exportedFiles.add( new ExportedData(adm) );
        }
        
        /*
        DataExportService DES = new DataExportService();
        List<DataExportService.ExportedData> exportDataList = DES.getExportedDataList();*/
        return BPUtility.getEncodedString(System.JSON.serialize(exportedFiles));
        //return System.JSON.serialize(exportedFiles);
    }
    
    
    /**
     * Name: exportData
     * Desc: Method to send Email for support and contact
       @param:  
    **/
    @RemoteAction
    global static string exportData(){
        DataExportService DES = new DataExportService();
        DES.objectName = '';
        DES.exportAccountingData();
        return BPUtility.getEncodedString('Export Data scheduled successfully');
        //return System.JSON.serialize(exportedFiles);
    }
    
    
    public class UserWrapper{
        private String name;
        private String email;
        private Boolean isNew;
        private String id;
        public UserWrapper(String name,String email,Boolean isNew,String id){
            this.name = name;
            this.email = email;
            this.isNew = isNew;
            this.id = id;
        }
    }
    
    public class PriceAndTaxMasterData{
        public List<RecordItem> salesTaxList;
        public List<RecordItem> priceLevelList;
        public List<Country> countryList;
        public List<CountryWrapper> stateList;
        public List<String> timezoneList;
        
        public PriceAndTaxMasterData(List<Sales_Tax__c> salesTaxList, List<Price_Level__c> priceLevelList, List<Country__c> countryList, List<Country__c> countryWrapperList){  
            this.countryList = new List<Country>();
            this.salesTaxList = new List<RecordItem>();
            this.stateList = new List<CountryWrapper>();
            for(Sales_Tax__c salesTaxObj : salesTaxList){
                this.salesTaxList.add(new RecordItem(salesTaxObj.Name__c, salesTaxObj.Id));
            }
            this.priceLevelList = new List<RecordItem>();
            for(Price_Level__c priceLevelObj : priceLevelList){
                this.priceLevelList.add(new RecordItem(priceLevelObj.Name__c, priceLevelObj.Id));
            }
            
             for(Country__c countryObj : countryWrapperList){
                this.countryList.add(new Country(countryObj));
            }  
        }
    }
    
    public class BusinessProfileMasterData{
        public List<Country> CountryList;
        public BusinessProfileWrapper BusinessProfileObj;
        
        public BusinessProfileMasterData(List<Country__c> countryWrapperList, List<Business_Profile__c> businessProfiles){  
            
            if(businessProfiles.size() > 0){
                BusinessProfileObj = new BusinessProfileWrapper(businessProfiles[0]);
            }else{
                BusinessProfileObj = new BusinessProfileWrapper(new Business_Profile__c());
            }
            
            this.countryList = new List<Country>();
            for(Country__c countryObj : countryWrapperList){
                this.countryList.add(new Country(countryObj));
            }
        }
    }
    
    
    public class BillingWrapper{
        private String IDDCode;
        private String UpgradeTime;
        private String Phone;
        private String UpgradeDate;
        public BillingWrapper(){
            
        }
    }
    
    
    public class ExportedData {
        // Object name
        public String objectName {get; private set;}
        
        // List of attachments
        public List<AttachmentWrapper> exportedFiles {get; private set;}
        
        /**
         * Name: ExportedData
         * Desc: Constructor which takes a Accounting Data Export record and populate values
        **/
        public ExportedData(Accounting_Data_Migration__c adm){
            objectName      = adm.Object_Name__c;
            exportedFiles   = new List<AttachmentWrapper>();
            
            for(Attachment att : adm.Attachments){
                if(att.CreatedDate >= adm.Last_Synched__c){
                    exportedFiles.add(new AttachmentWrapper(att));
                }
            }
        }
    }
    
    public class AttachmentWrapper{
        public String Id;
        public String Name;
        public String LastModifiedDate;
        public String CreatedBy;
        
        public AttachmentWrapper(Attachment attachObj){
            this.Id = attachObj.Id;
            this.Name = attachObj.Name;
            this.LastModifiedDate = attachObj.LastModifiedDate.format('dd/MM/yyyy');
            this.CreatedBy = attachObj.CreatedBy.Name;
        }
    }
    
    public Static Map<String, List<String>> BUSINESS_PROFILE_FIELDS_TO_JSON_MAPPING = 
                                                                    new Map<String, List<String>>{'Business_Profile__c' => new List<String>{'id',
                                                                                                                                            'Business_Name__c',
                                                                                                                                            'Business_Phone__c',
                                                                                                                                            'Business_Email__c','Business_Street_Address1__c',
                                                                                                                                            'Business_Street_Address2__c','Business_City__c',
                                                                                                                                            'Business_Postal_Code__c',
                                                                                                                                            'Business_Country__c',
                                                                                                                                            'Business_Country__r.Name__c',
                                                                                                                                            'Business_State__c',
                                                                                                                                            'Business_State__r.Name__c',
                                                                                                                                            'Same_As_Business_Address__c',
                                                                                                                                            'Company_Name_Optional__c',
                                                                                                                                            'Shipping_Street_Address1__c',
                                                                                                                                            'Shipping_Street_Address2__c',
                                                                                                                                            'Shipping_City__c',
                                                                                                                                            'Shipping_Postal_Code__c'
                                                                                                                                            ,'Shipping_Country__c',
                                                                                                                                            'Shipping_State__c'}};
    
    public class RecordItem{  
        private String id;
        private String name;
        public RecordItem(String name, String id){
            this.name = name;
            this.id = id.substring(0, 15);
        }
    }
}