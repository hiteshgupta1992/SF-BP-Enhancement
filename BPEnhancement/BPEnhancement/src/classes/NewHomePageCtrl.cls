/**
 * Author: Hitesh Gupta
 * Since: Jul 25, 2016
 * Name: NewHomePageCtrl
 * Description: Apex class to handle JSON related oprations of NewHomePage
 **/
 global with sharing class NewHomePageCtrl {
 	
 	public Boolean IsTrialOrg { get{return GeneralConfiguration.isTrialOrg();} private set;}
 	
 	public String communityURL { get{return GeneralConfiguration.communityLink();} private set;}
 	
 	public Boolean IsSystemSettingVisited{get{return GeneralConfiguration.isSystemSettingVisited();} private set;}
 	
 	public Boolean IsSampleDataAvailable { get{
 												if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
 												List<Category__c> categoryList = [select id from Category__c limit : Limits.getLimitDMLRows()];
 												if(categoryList.size() == 0){
 													return false;
 												}else{
 													return true;
 												}
 											} 
 											
 											private set;
 										}
        
}