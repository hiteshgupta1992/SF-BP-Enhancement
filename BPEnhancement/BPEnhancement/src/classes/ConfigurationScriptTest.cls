@isTest
private class ConfigurationScriptTest {
    
    static testMethod void testRunAll(){
        
        ConfigurationScript.runAll();
        
        List<SearchConfigurations__c> searchConfigurations = [Select id From SearchConfigurations__c];
        System.assertEquals(9, searchConfigurations.size());
        
        List<General_Configurations__c> generalConfigurations = [Select id, Related_List_Page_Size__c From General_Configurations__c];
        System.assertEquals(25, generalConfigurations[0].Related_List_Page_Size__c);
        
        List<Widget__c> widgets = [Select id From Widget__c];
        System.assertEquals(8, widgets .size());
        
        List<Transaction_Type__c> transactionTypes = [Select id From Transaction_Type__c];
        System.assertEquals(3, transactionTypes.size());
        
        List<GL_Account__c> GL_Accounts = [Select id From GL_Account__c];
        System.assertEquals(4, GL_Accounts.size());
        
        List<Accounting_Data_Migration__c> accountingDataMigrationList = [Select id From Accounting_Data_Migration__c];
        System.assertEquals(7, accountingDataMigrationList.size());
    }
}