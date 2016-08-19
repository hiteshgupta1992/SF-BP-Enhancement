/**
 * Author: Ashish Garg
 * Since: Sept 1, 2015
 * Name: UsersUtility
 * Description: Utility class to perform specific actions on users
**/ 
public with sharing class UsersUtility {
	/**
     * Name: getUserImageURL
     * Desc: Method used to get user image url for a user
     * @param:  Id: user Id
     * @return: String - string url for user image
    **/
    public static String getUserImageURL(Id userId){
    	if(AccessControl.ifObjectFieldIsAccessible('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        List<User> usersList = [Select Id, SmallPhotoUrl from User where Id =: userId];
        String photoURL = '';
        
        if(usersList.size() > 0){
        	User currentUser = usersList[0];
			String[] urlParts = currentUser.SmallPhotoUrl.split('/');
			Boolean isUploadedPhoto = urlParts[urlParts.size() - 2].length() == 15;
        	
        	if(isUploadedPhoto){
        		photoURL = currentUser.SmallPhotoUrl;
        	} else {
        		photoURL = GetResourceURL('Images') + '/StandardUserImage.png'; 
        	}
        }
        
        return photoURL;
    }
    
    /**
     * Name: GetResourceURL
     * Desc: Method used to geturl for static resource name
     * @param:  String static resource name
     * @return: String - string url forresource
    **/
	public static String GetResourceURL(String resourceName) {
		if(AccessControl.ifObjectFieldIsAccessible('StaticResource') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		//Fetching the resource
		resourceName = BPUtility.escapeSingleQuotes(resourceName);
		List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name =: resourceName];
	
		//Checking if the result is returned or not
		if(resourceList.size() == 1) {
			String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
			String namespace = resourceList[0].NamespacePrefix;
			return baseUrl + '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
		} else {
			return '';
		}
	}
}