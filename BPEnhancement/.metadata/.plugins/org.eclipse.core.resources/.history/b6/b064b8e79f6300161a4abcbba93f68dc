/**
 * Author: Ashish Garg
 * Since: Dec. 18, 2015
 * Name: GLAccountsSetupCtrl
 * Description: Service class used to export salesforce data 
**/
public with sharing class GLAccountsSetupCtrl {
	// GL Account reference
	public GL_Account__c glAcc {get; set;}
	
	// Selcted GL Account Id
	public id glAccountId {private get; set;}
	
	/**
     * Name: GLAccountsSetupCtrl
     * Desc: Constructor to setup the selcted gl account data
     * @param: 
    **/
	public GLAccountsSetupCtrl(){
		if(AccessControl.ifObjectFieldIsAccessible('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		Id glAccountId;
		
		try{
			glAccountId = ApexPages.CurrentPage().getParameters().get('id');
			glAccountId = String.escapeSingleQuotes(glAccountId);
		} catch(Exception e){
			glAccountId = null;
		}
		
		if(glAccountId == null){
			glAcc = new GL_Account__c();
		} else {
			try{
				glAccountId = BPUtility.escapeSingleQuotes(glAccountId);
				glAcc = [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c where Id =: glAccountId];
			} catch(QueryException e) {
				glAcc = new GL_Account__c();
			}
		}
	}
	
	/**
     * Name: save
     * Desc: Method to save the current changes to GL Account record
     * @param: 
     * @return:
    **/
	public void save() {
		if(AccessControl.ifObjectFieldIsCreateable('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		upsert glAcc;
		glAcc = new GL_Account__c();
	}
	
	/**
     * Name: getAllGLAccounts
     * Desc: Method to get all gl accounts recorded in database
     * @param: 
     * @return:
    **/
	public List<GL_Account__c> getAllGLAccounts() {
		if(AccessControl.ifObjectFieldIsAccessible('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		return [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c Limit 25];
	}
	
	/**
     * Name: editSelectedGLAccount
     * Desc: Method to initiate edit of selected gl account
     * @param: Id glAccountId
     * @return:
    **/
	public void editSelectedGLAccount() {
		if(AccessControl.ifObjectFieldIsAccessible('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		glAccountId = BPUtility.escapeSingleQuotes(glAccountId);
		glAcc = [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c where Id =: glAccountId];
	}
	
	/**
     * Name: deleteSelectedGLAccount
     * Desc: Method to process deletion of selected gl account
     * @param: Id glAccountId
     * @return:
    **/
	public void deleteSelectedGLAccount() {
		if(AccessControl.ifObjectIsDeletable('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		glAcc = new GL_Account__c(Id = glAccountId);
		delete glAcc;
		
		glAcc = new GL_Account__c();
	}
}