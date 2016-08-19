@isTest
private class SalesTaxTest {

	static testMethod void testCreateSalesTax() {
		
		String taxName = 'Testing Sales Tax 1';
		Sales_Tax__c salesTaxRec = TestUtil.createSalesTax(true, taxName, true, true, true);
		
		SalesTax salesTax = new SalesTax(salesTaxRec);
		
		System.assertEquals(taxName, salesTax.SalesTaxName);
		System.assertEquals(true, salesTax.IsDefault);
	}
	
	static testMethod void testFieldsList() {
		
		List<String> fieldsList = SalesTax.fieldsList();
		
		System.assertNotEquals(null, fieldsList);
		System.assertEquals(4, fieldsList.size());
	}
}