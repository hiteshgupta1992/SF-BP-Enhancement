/**
 * Author: Tarun Khandelwal
 * Since: Oct. 24, 2014
 * Name: BlackPurlException
 * Description: Apex Class for handling all exceptions and gives meaningful messgaes
**/
public with sharing class BlackPurlException extends Exception{
    
    //============================================================================
    //Method: getErrorMessage
    //Desc: Method to return meaningful error messages
    //Args : String - error - error message produced by salesforce
    //       String stackTrace - Stack trace message of generated error
    //Return: String  - Error Message
    //============================================================================
    public static String getErrorMessage(String error, String stackTrace) {
        String errorString = ' ';
        /*if(error.contains('Trigger.')) {
            errorString = getTriggerError(error);
        }else */if(error.contains('DUPLICATE_VALUE')) {
            errorString = getUniqueKeyError(error);
        }else if(error.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
            errorString = getValidationError(error);
        } else if(error.contains('de-reference')) {
            errorString = getNullError(stackTrace);
        } else if(error.contains('DELETE_FAILED')) {
            errorString = getDeleteFailedError(error);
        } else {
            errorString = error ;
        }
        return errorString;
    }   
    
    //============================================================================
    //Method: getTriggerError
    //Desc: Method to return meaningful error messages generated due to trigger 
    //Args : String - error - error message produced by salesforce
    //Return: String - Meaningful custom Error Message
    //============================================================================
    public static String getTriggerError(String error) {
        Integer index = error.lastIndexOf('Trigger.');
        String errorMsg = error.substring(index);
        String subErrorString = errorMsg.replace('Trigger.',':');
        String triggerName =  subErrorString.split(':')[1];
        return 'Trigger error :' +triggerName;
    }
    
    //============================================================================
    //Method: getUniqueKeyError
    //Desc: Method to return meaningful error messages generated due to Unique key field 
    //Args : String - error - error message produced by salesforce
    //Return: String - Meaningful custom Error Message
    //============================================================================
    public static String getUniqueKeyError( String error) {
        Integer lastIndex = error.lastIndexOf(':');
        String subErrorString = error.substring(0, lastIndex);
        
        Integer secondIndex = subErrorString.lastIndexOf(':');
        String errorRecordId = subErrorString.substring(secondIndex+2, subErrorString.length());
        String remainingString = subErrorString.substring(0, secondIndex);
        
        String sObjName = Id.valueOf(errorRecordId).getSObjectType().getDescribe().getName();
        if(AccessControl.ifObjectFieldIsAccessible(sObjName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        String query = 'Select Name from ' + sObjName + ' Where Id = :errorRecordId';
        
        List<Sobject> sObjects = Database.query(query);     
        String errorRecordName = '';
        if(sObjects.size() != 0) {
            errorRecordName = String.valueOf(sObjects[0].get('Name'));
        }else{
            errorRecordName = errorRecordId;
        }
        
        lastIndex = remainingString.lastIndexOf(':');
        String fieldNameString = remainingString.substring(lastIndex+1, remainingString.length());
        
        String fieldName = fieldNameString.substring(0,fieldNameString.indexOf('__c')+3);
        
        String errorMsg = 'Duplicate record found. Another record ';
        
        errorMsg += (errorRecordName != errorRecordId) ? ('<a href="/'+errorRecordId+'">' + errorRecordName + '</a>') : errorRecordName;
        
        errorMsg += ' already exists with same Name';
        
        return errorMsg;
    }
    
    //============================================================================
    //Method: getValidationError
    //Desc: Method to return meaningful error messages generated due to validation rule
    //Args : String - error - error message produced by validation rule
    //Return: String - Meaningful custom Error Message
    //============================================================================
    public static String getValidationError(String error) {
        String errorMsg = '';
        
        Integer index = error.lastIndexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION');
        String errorString = error.substring(index);
        
        String subErrorString = errorString.replace('FIELD_CUSTOM_VALIDATION_EXCEPTION',':');
        String validationErrorMsg =  subErrorString.split(':')[1];
        
        validationErrorMsg = validationErrorMsg.subString(2);
        errorMsg += 'Validation Error : ' + validationErrorMsg;
        
        return errorMsg;
    }
    
    //============================================================================
    //Method: getNullError
    //Desc: Method to return meaningful error messages generated due to dereference of null object
    //Args : String - error - error message produced by dereference of null object
    //Return: String - Meaningful custom Error Message
    //============================================================================
    public static String getNullError( String stackTrace) {
        String errorMsg = '';
        
        List<String> subString = stackTrace.split(':');
        subString[0] = subString[0].replace('.',':');
        List<String> classNameList = subString[0].split(':');
        String className = classNameList[1];
        String methodName = classNameList[2];
        String lineNumber = subString[1];
        
        errorMsg += 'Attempt to de-reference a null object. <br/>';
        errorMsg += 'Error in - ' + methodName + '()' + ' method of ' + className + ' Class';
        errorMsg += ' at '+ lineNumber;
        
        return errorMsg;
    }
    
    //============================================================================
    //Method: getDeleteFailedError
    //Desc: Method to return meaningful error messages generated due to failing the deleting operation
    //Args : String - error - error message produced by failing the deleting operation
    //Return: String - Meaningful custom Error Message
    //============================================================================
    public static String getDeleteFailedError( String error) {
        String errorMsg = '';
        errorMsg += 'Delete Failed. <br/>'; 
        Integer index = error.lastIndexOf('DELETE_FAILED');
        String errorString = error.substring(index+15, error.length()-4);
        errorMsg += errorString;
        return errorMsg;
    }
    
    //============================================================================
    //Method: getUniqueKeyErrorForCSV
    //Desc: Method to return meaningful error messages generated due to Unique key field 
    //Args : String - error - error message produced by salesforce
    //Return: String - Meaningful custom Error Message
    //============================================================================  
    
    public static String getUniqueKeyErrorForCSV( String error) {
        Integer lastIndex = error.lastIndexOf(':');
        String subErrorString = error.substring(0, lastIndex);
        
        Integer secondIndex = subErrorString.lastIndexOf(':');
        String errorRecordId = subErrorString.substring(secondIndex+2, subErrorString.length());
        String remainingString = subErrorString.substring(0, secondIndex);
        
        String sObjName = Id.valueOf(errorRecordId).getSObjectType().getDescribe().getLabel();
        
        String errorMsg = 'Duplicate record found. A  ';
        
        errorMsg +=  sObjName ;
        
        errorMsg += ' records already exists with same name';
        
        return errorMsg;
    }
}