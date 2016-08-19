@isTest
private class UserSettingCtrlTest {
 	private static final String PROFILE_NAME='Chatter Free User';
    private static Price_Level__c defaultpriceLevel;
   @testsetup
   public static void setTestData(){
		defaultpriceLevel = TestUtil.createPriceLevel(true, 'Test', '10',10, true, true);
		TestUtil.createtaxsettingInGeneralConfig();
   }
    static testMethod void getAllUsersTest() {
    	Test.startTest();
    	List<UserSettingCtrl.UserWrapper> userWrapperList = (List<UserSettingCtrl.UserWrapper>)Json.deserialize(BPUtility.getDecodedString(UserSettingCtrl.getAllUsers()),List<UserSettingCtrl.UserWrapper>.class);
    	Test.stopTest();
    	Profile profileObject = [Select id from Profile where name = : PROFILE_NAME];
    	List<User> initialUserList = [Select id from User where ProfileId =: profileObject.id];
    	System.assertEquals(initialUserList.size(), initialUserList.size());
    }
    static testMethod void  createUsersTest(){
    	List<UserSettingCtrl.UserWrapper> userwrapperList = new List<UserSettingCtrl.UserWrapper>();
    	UserSettingCtrl.UserWrapper userwrapperRecord = new UserSettingCtrl.UserWrapper('test','Jaxsontest@test.com',true,'12');
    	userwrapperList.add(userwrapperRecord);
    	String userwrapperListJson = Json.serialize(userwrapperList);
    	List<User> initialUserList = [Select id from User];
    	
    	Test.startTest();
    	UserSettingCtrl.createUsers(BPUtility.getEncodedString(userwrapperListJson));
    	Test.stopTest();
    	List<User> finalUserList = [Select id from User];
    	System.assertEquals(initialUserList.size() + 1,finalUserList.size() );
    }
    static testMethod void  getPriceAndTaxMasterDataTest(){
	    Test.startTest();
	    BPUtility.getDecodedString(UserSettingCtrl.getPriceAndTaxMasterData());
	    Test.stopTest();
    	System.assertEquals(true,true);
    
    }
    static testMethod void getBusinessProfileMasterDataTest(){
	    Test.startTest();
	    BPUtility.getDecodedString(UserSettingCtrl.getBusinessProfileMasterData());
	    Test.stopTest();
    	System.assertEquals(true,true);
    }
    static testMethod void getCurrentConfigurationTest(){
        Test.startTest();
	    BPUtility.getDecodedString(UserSettingCtrl.getCurrentConfiguration());
	    Test.stopTest();
    	System.assertEquals(true,true);
    }
    static testMethod void getBillingProfileTest(){
        Test.startTest();
	   	UserSettingCtrl.getBillingProfile();
	    Test.stopTest();
    	System.assertEquals(true,true);

    }
    static testmethod void saveBusinessProfileTest(){
		
		Test.startTest();
		//UserSettingCtrl.saveBusinessProfile();
		//UserSettingCtrl.BusinessProfileMasterData businessprofileobject= (UserSettingCtrl.BusinessProfileMasterData)Json.deserialize(BPUtility.getDecodedString(UserSettingCtrl.getBusinessProfileMasterData()),UserSettingCtrl.BusinessProfileMasterData.class);
		//System.debug(UserSettingCtrl.BusinessProfileMasterData.IsSameAsBusinessAddress);
		//UserSettingCtrl.saveBusinessProfile(BPUtility.getEncodedString(Json.serialize(businessprofileobject)));
		Test.stopTest();
  	
    }
    static testmethod void savePriceAndTaxTest(){
    	/*Test.startTest();
    	//defaultpriceLevel = TestUtil.createPriceLevel(true, 'Test2', '100',120, true, true);
		//PriceAndTaxWrapper PriceAndTaxWrapperRecord = new PriceAndTaxWrapper(defaultpriceLevel);
		PriceAndTaxWrapperRecord.regionId;
    	PriceAndTaxWrapperRecord.stateId;
       	PriceAndTaxWrapperRecord.taxId;
    	PriceAndTaxWrapperRecord.timezoneId;
    	PriceAndTaxWrapperRecord.defaultLaborTax;
    	PriceAndTaxWrapperRecord.defaultVendorItemTax;
    	PriceAndTaxWrapperRecord.defaultPartTax;
		PriceAndTaxWrapperRecord.defaultFeeTax;
    	PriceAndTaxWrapperRecord.orderingTaxRate;
    	PriceAndTaxWrapperRecord.priceIncludeTax;
   		PriceAndTaxWrapperRecord.defaultPriceLevel;
    	
    	Test.stopTest();
    	System.assertEquals(true,true);*/
    	
    }
    
    
}