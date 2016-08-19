/**
 * Author: Tarun Khandelwal
 * Since: July 09, 2016
 * Name: BPUtility
 * Description: Utility class which is used for generic methods used in application
**/
public with sharing class BPUtility {
    
    public static String getDecodedString(String str) {
    	if(String.isBlank(str)) {
			return str;
		}
    	return (EncodingUtil.base64Decode(str) != null) ? EncodingUtil.base64Decode(str).toString() : null;
    }
	
	public static String getEncodedString(String str) {
		if(String.isBlank(str)) {
			return str;
		}
    	return getEncodedStr(Blob.valueOf(str));
    }
	    
    public static String getEncodedStr(Blob blobStr) {
    	return EncodingUtil.base64Encode(blobStr);
    }
    
    public static String escapeSingleQuotes(String inputStr) {
    	if(String.isNotBlank(inputStr)) {
    		inputStr = String.escapeSingleQuotes(inputStr);
    	}
    	return inputStr;
    }
}