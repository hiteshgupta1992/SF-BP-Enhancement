@isTest
private class PriceLevelTest {
	
	static testMethod void testPriceLevel() {
		
		String priceLevelName = 'Default Price Level';
		TestUtil.createPriceLevel(true, priceLevelName, 'MSRP', 10 , true, true);
		
		Price_Level__c defaultPriceLevel = [Select id, name__c, Default__c from Price_Level__c Where name__c=:priceLevelName Limit 1];
		PriceLevel priceLevelObj = new PriceLevel(defaultPriceLevel);
		
		System.assertEquals(priceLevelName, defaultPriceLevel.name__c);
		System.assertEquals(true, defaultPriceLevel.Default__c);
	}
	
	static testMethod void testFieldsList() {
		
		List<String> fieldsList = PriceLevel.fieldsList();
		
		System.assertNotEquals(null, fieldsList);
		System.assertEquals(4, fieldsList.size());
	}
}