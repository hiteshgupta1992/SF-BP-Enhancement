/**
 * Author: Ashish Garg
 * Since: Dec. 12, 2014
 * Name: CustomAutoCompleteCtrl
 * Description: Conroller class for CustomAutoComplete Component
**/
global with sharing class CustomAutoCompleteCtrl {
	/**
     * Name: getAutoCompleteJSONForObj
     * Desc: Method used to get a JSON string with Name-Value pair for object records and display values in Autocomplete component on page
     * @param:	sObjName - Object API name for which to get records JSON string
     *			filterKey - Search string
     * @return: String - SObject records JSON String (Name-Value format)
    **/
    @RemoteAction
    global static String getAutoCompleteJSONForObj(String sObjName, String filterKey) {
    	sObjName = BPUtility.getDecodedString(sObjName);
    	filterKey = BPUtility.getDecodedString(filterKey);
    	return BPUtility.getEncodedString(SystemSettingsService.getAutoCompleteJSONForObj(sObjName, filterKey));
    }
}