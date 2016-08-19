@isTest
public with sharing class GlAccountSetupCtrlTest {
	
    @isTest
    private static void saveTest(){
        
    	GL_Account__c  gla  = new GL_Account__c(MYOB_Account_Name__c =  'A/P Accrual - Inventory', MYOB_Account_Number__c = '2-1530',  Type__c = 'Received Inventory Accrual');
        insert gla; 
        
		Test.setCurrentPageReference(new PageReference('Page.GLAccountsSetup')); 
		System.currentPageReference().getParameters().put('id', gla.Id);		
		Test.startTest();
		GLAccountsSetupCtrl glaCntrl = new GLAccountsSetupCtrl();
		glaCntrl.save();  
		Test.stopTest();
		List<GL_Account__c> glAccountList =  [select Id From GL_Account__c Limit 25 ];
		System.assertEquals(1,glAccountList.size());
    }  
    
    @isTest 
    private static void getAllGLAccountsTest(){
        
        List<GL_Account__c> GLAccountList =  new List<GL_Account__c>();
		
		GL_Account__c  gla  = new GL_Account__c(MYOB_Account_Name__c =  'A/P Accrual - Inventory', MYOB_Account_Number__c = '2-1530',  Type__c = 'Received Inventory Accrual');
		GLAccountList.add(gla);
		
		GL_Account__c  gla1  = new GL_Account__c(MYOB_Account_Name__c =  'BP Customer Deposits', MYOB_Account_Number__c = '1-1250',  Type__c = 'Deposit Allocation Account');
		GLAccountList.add(gla1);
		GL_Account__c  gla2  = new GL_Account__c(MYOB_Account_Name__c =  'Other Income', MYOB_Account_Number__c = '4-4200',  Type__c = '	Sales Invoice Account');
		GLAccountList.add(gla2);
		GL_Account__c  gla3 = new GL_Account__c(MYOB_Account_Name__c =  'Undeposited Funds Account', MYOB_Account_Number__c = '1-1210',  Type__c = 'Deposit Account');
		GLAccountList.add(gla3);
		  
		if(GLAccountList.size() > 0){
			insert GLAccountList;  
		}
		
		Test.startTest();
		GLAccountsSetupCtrl glaCntrl = new GLAccountsSetupCtrl();
		glaCntrl.getAllGLAccounts();
		Test.stopTest();
		List<GL_Account__c> glAccountRecList =  [select Id From GL_Account__c Limit 25 ];
		System.assertEquals(4,glAccountRecList.size());
    }  
    @isTest
    private static void editSelectedGLAccountTest(){
        
        GL_Account__c  gla  = new GL_Account__c(MYOB_Account_Name__c =  'A/P Accrual - Inventory', MYOB_Account_Number__c = '2-1530',  Type__c = 'Received Inventory Accrual');
        insert gla; 
        
		Test.setCurrentPageReference(new PageReference('Page.GLAccountsSetup')); 
		System.currentPageReference().getParameters().put('id', gla.Id);
		
		Test.startTest();
		GLAccountsSetupCtrl glaCntrl = new GLAccountsSetupCtrl(); 
		glaCntrl.glAccountId = gla.Id; 
		glaCntrl.editSelectedGLAccount();
		Test.stopTest();
		
		List<GL_Account__c> glAccountList =  [select Id From GL_Account__c Limit 25 ];
		System.assertEquals(1,glAccountList.size());
    }
    
    @isTest
    private static void deleteSelectedGLAccountTest(){
        
        GL_Account__c  gla  = new GL_Account__c(MYOB_Account_Name__c =  'A/P Accrual - Inventory', MYOB_Account_Number__c = '2-1530',  Type__c = 'Received Inventory Accrual');
        insert gla; 
        
		Test.setCurrentPageReference(new PageReference('Page.GLAccountsSetup')); 
		System.currentPageReference().getParameters().put('id', gla.Id);
		
		Test.startTest();
		GLAccountsSetupCtrl glaCntrl = new GLAccountsSetupCtrl();
		glaCntrl.glAccountId = gla.Id;
		glaCntrl.deleteSelectedGLAccount();
		Test.stopTest();
		List<GL_Account__c> glAccountList =  [select Id From GL_Account__c Limit 25 ];
		System.assertEquals(0, glAccountList.size());
    }

}