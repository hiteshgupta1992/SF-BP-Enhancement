/**
 * Name: AccessControl
 * Description: Class is used to control/view/edit/CRUD permissions and sharing for objects and fields
 *
**/
public with sharing class AccessControl {
   /*****************************************************START: OBJECTS************************************************************************/
   public static boolean ifObjectIsAccessible(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectIsAccessible(new List<String>{objName});
    }
    public static boolean ifObjectIsAccessible(String objName){
        return ifObjectIsAccessible(new List<String>{objName});
    }
    public static boolean ifObjectIsAccessible(List<string> objNamesList){
        return ifObjectFieldIsAccessible(objNamesList);
    }
    
    public static boolean ifObjectIsCreateable(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectIsCreateable(new List<String>{objName});
    }
    public static boolean ifObjectIsCreateable(String objName) {
        return ifObjectIsCreateable(new List<String>{objName});
    }
    public static boolean ifObjectIsCreateable(List<string> objNamesList) {
        return ifObjectFieldIsCreateable(objNamesList);
    }
    
    public static boolean ifObjectIsUpdateable(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectIsUpdateable(new List<String>{objName});
    }
    public static boolean ifObjectIsUpdateable(String objName) {
        return ifObjectIsUpdateable(new List<String>{objName});
    }
    public static boolean ifObjectIsUpdateable(List<string> objNamesList) {
        return ifObjectFieldIsUpdateable(objNamesList);
    }
    
    public static boolean ifObjectIsDeletable(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectIsDeletable(new List<String>{objName});
    }
    public static boolean ifObjectIsDeletable(String objName) {
        return ifObjectIsDeletable(new List<String>{objName});
    }
    public static boolean ifObjectIsDeletable(List<string> objNamesList) {
        objNamesList = implementNameSpace(objNamesList);
        boolean IsDeletable = true;
        Schema.DescribeSobjectResult[] objDescribeResult  = Schema.describeSObjects(objNamesList);
        for(Schema.DescribeSobjectResult objDesResult  : objDescribeResult){
            if( !objDesResult.IsDeletable() ) { IsDeletable = false;break; }
        }
        
        return IsDeletable;
    }
    /*****************************************************END: OBJECTS************************************************************************/
    
    /*****************************************************START: FIELDS************************************************************************/
    public static boolean ifObjectFieldIsAccessible(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectFieldIsAccessible(objName);
    }
    public static boolean ifObjectFieldIsAccessible(String objName){
        return ifObjectFieldIsAccessible(new Map<String, List<String>>{ objName.toLowerCase() => new List<String>() });
    }
    public static boolean ifObjectFieldIsAccessible(List<String> objNamesList){
    	Map<String, List<String>> objNameFieldsMap = new Map<String, List<String>>();
    	for(String objName : objNamesList) {
    		objNameFieldsMap.put(objName.toLowerCase(), new List<String>());
    	}
        return ifObjectFieldIsAccessible(objNameFieldsMap);
    }
    public static boolean ifObjectFieldIsAccessible(String objName, String fieldName){
        return ifObjectFieldIsAccessible(new Map<String, List<String>>{ objName.toLowerCase() => new List<String>{fieldName.toLowerCase()} });
    }
    public static boolean ifObjectFieldIsAccessible(Map<String, List<String>> objFieldsMap){
        objFieldsMap = implementNameSpace(objFieldsMap);
        boolean IsAccessible = true;
        Schema.DescribeSobjectResult[] objDescribeResult  = Schema.describeSObjects(new List<String>(objFieldsMap.keySet()));
        for(Schema.DescribeSobjectResult objDesResult  : objDescribeResult){
            if(objFieldsMap.containsKey(objDesResult.getLocalName().toLowerCase()) || objFieldsMap.containsKey(objDesResult.getName().toLowerCase())) {
            	
            	// Check for object accessibility first, and if false, then break the method.
                if( !objDesResult.isAccessible() ) { IsAccessible = false; break; }
                
                // Create fields set need to be checked for accessibility permission
                String objName = (objFieldsMap.containsKey(objDesResult.getLocalName().toLowerCase())) ? objDesResult.getLocalName().toLowerCase() : objDesResult.getName().toLowerCase();
                Set<String> fieldsSet = new Set<String>();
                if(objFieldsMap.get(objName) != null) {
	                for(String fieldName : objFieldsMap.get(objName)) {
	                    fieldsSet.add(fieldName.toLowerCase());
	                }
                }
                
                // Check for all fields accessibility, and if false anywhere, then break the method
                for(Schema.SobjectField objField : objDesResult.fields.getMap().values()){
                    Schema.DescribeFieldResult fieldDescRes = objField.getDescribe();
                    String fieldName = (fieldsSet.contains(fieldDescRes.getLocalName().toLowerCase())) ? fieldDescRes.getLocalName().toLowerCase() : fieldDescRes.getName().toLowerCase();
                    if(fieldsSet.contains(fieldName) || fieldsSet.size() == 0) {
                        if( !fieldDescRes.isAccessible() && fieldDescRes.isPermissionable()) { IsAccessible = false; break; }
                    }
                }
            }
        }
        return IsAccessible;
    }
    
    public static boolean ifObjectFieldIsCreateable(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectFieldIsCreateable(objName);
    }
    public static boolean ifObjectFieldIsCreateable(String objName){
        return ifObjectFieldIsCreateable(new Map<String, List<String>>{ objName.toLowerCase() => new List<String>() });
    }
    public static boolean ifObjectFieldIsCreateable(List<String> objNamesList){
    	Map<String, List<String>> objNameFieldsMap = new Map<String, List<String>>();
    	for(String objName : objNamesList) {
    		objNameFieldsMap.put(objName.toLowerCase(), new List<String>());
    	}
        return ifObjectFieldIsCreateable(objNameFieldsMap);
    }
    public static boolean ifObjectFieldIsCreateable(String objName, String fieldName){
        return ifObjectFieldIsCreateable(new Map<String, List<String>>{ objName.toLowerCase() => new List<String>{fieldName.toLowerCase()} });
    }
    public static boolean ifObjectFieldIsCreateable(Map<String, List<String>> objFieldsMap){
        objFieldsMap = implementNameSpace(objFieldsMap);
        boolean IsCreateable = true;
        Schema.DescribeSobjectResult[] objDescribeResult  = Schema.describeSObjects(new List<String>(objFieldsMap.keySet()));
        for(Schema.DescribeSobjectResult objDesResult  : objDescribeResult){
            if(objFieldsMap.containsKey(objDesResult.getLocalName().toLowerCase()) || objFieldsMap.containsKey(objDesResult.getName().toLowerCase())) {
            	// Check for object createable first, and if false, then break the method.
                if( !objDesResult.IsCreateable() ) { IsCreateable = false;break; }
                
                // Create fields set need to be checked for createable permission
                String objName = (objFieldsMap.containsKey(objDesResult.getLocalName().toLowerCase())) ? objDesResult.getLocalName().toLowerCase() : objDesResult.getName().toLowerCase();
                Set<String> fieldsSet = new Set<String>();
                if(objFieldsMap.get(objName) != null) {
	                for(String fieldName : objFieldsMap.get(objName)) {
	                    fieldsSet.add(fieldName.toLowerCase());
	                }
                }
                
                // Check for all fields createablity, and if false anywhere, then break the method
                for(Schema.SobjectField objField : objDesResult.fields.getMap().values()){
                    Schema.DescribeFieldResult fieldDescRes = objField.getDescribe();
                    String fieldName = (fieldsSet.contains(fieldDescRes.getLocalName().toLowerCase())) ? fieldDescRes.getLocalName().toLowerCase() : fieldDescRes.getName().toLowerCase();
                    if(fieldsSet.contains(fieldName) || fieldsSet.size() == 0) {
                        if( !isFieldCreateable(fieldDescRes)) { IsCreateable = false;break; }
                    }
                }
            }
        }
        
        return IsCreateable;
    }
    
    public static boolean ifObjectFieldIsUpdateable(sObject sObj){
        String objName = sObj.getSobjectType().getDescribe().getName();
        return ifObjectFieldIsUpdateable(objName);
    }
    public static boolean ifObjectFieldIsUpdateable(String objName){
        return ifObjectFieldIsUpdateable(new Map<String, List<String>>{ objName.toLowerCase() => new List<String>() });
    }
    public static boolean ifObjectFieldIsUpdateable(List<String> objNamesList){
    	Map<String, List<String>> objNameFieldsMap = new Map<String, List<String>>();
    	for(String objName : objNamesList) {
    		objNameFieldsMap.put(objName.toLowerCase(), new List<String>());
    	}
        return ifObjectFieldIsUpdateable(objNameFieldsMap);
    }
    public static boolean ifObjectFieldIsUpdateable(String objName, String fieldName){
        return ifObjectFieldIsUpdateable(new Map<String, List<String>>{ objName.toLowerCase() => new List<String>{fieldName.toLowerCase()} });
    }
    public static boolean ifObjectFieldIsUpdateable(Map<String, List<String>> objFieldsMap){
        objFieldsMap = implementNameSpace(objFieldsMap);
        boolean IsUpdateable = true;
        Schema.DescribeSobjectResult[] objDescribeResult  = Schema.describeSObjects(new List<String>(objFieldsMap.keySet()));
        for(Schema.DescribeSobjectResult objDesResult  : objDescribeResult){
            if(objFieldsMap.containsKey(objDesResult.getLocalName().toLowerCase()) || objFieldsMap.containsKey(objDesResult.getName().toLowerCase())) {
                // Check for object Updateable first, and if false, then break the method.
                if( !objDesResult.IsUpdateable() ) { IsUpdateable = false;break; }
                
                // Create fields set need to be checked for Updateable permission
                String objName = (objFieldsMap.containsKey(objDesResult.getLocalName().toLowerCase())) ? objDesResult.getLocalName().toLowerCase() : objDesResult.getName().toLowerCase();
                Set<String> fieldsSet = new Set<String>();
                if(objFieldsMap.get(objName) != null) {
	                for(String fieldName : objFieldsMap.get(objName)) {
	                    fieldsSet.add(fieldName.toLowerCase());
	                }
                }
                
                // Check for all fields Updateable permission, and if false anywhere, then break the method
                Integer counter = 1;
                for(Schema.SobjectField objField : objDesResult.fields.getMap().values()){
                    Schema.DescribeFieldResult fieldDescRes = objField.getDescribe();
                    String fieldName = (fieldsSet.contains(fieldDescRes.getLocalName().toLowerCase())) ? fieldDescRes.getLocalName().toLowerCase() : fieldDescRes.getName().toLowerCase();
                    if(fieldsSet.contains(fieldName) || fieldsSet.size() == 0) {
                        if( !isFieldUpdateable(fieldDescRes)) { IsUpdateable = false;break; }
                    }
                    counter++;
                }
            }
        }
        
        return IsUpdateable;
    }
    /*****************************************************END: FIELDS************************************************************************/
    
    /*****************************************************START: EMAIL************************************************************************/
    public static boolean ifSingleEmailSendAllowed() {
    	return ifSingleEmailSendAllowed(1);
    }
    	
    public static boolean ifSingleEmailSendAllowed(Integer amountReserved) {
    	try { Messaging.reserveSingleEmailCapacity(amountReserved); } catch(Exception exc) { return false; }
    	return true;
    }
    /*****************************************************END: EMAIL************************************************************************/
    
    private static List<String> implementNameSpace(List<String> objNames){
        List<String> objNamesWithNameSpace = new List<String>();
        for(String objN : objNames) {
            if(objN.indexOf(Constants.NAMESPACE) == -1 && objN.indexOf('__c') != -1) {
                objN = Constants.NAMESPACE + objN;
            }
            objNamesWithNameSpace.add(objN);
        }
        return objNamesWithNameSpace;
    }
    
    private static Map<String, List<String>> implementNameSpace(Map<String, List<String>> objFieldsMap){
        Map<String, List<String>> objFieldsMapWithNameSpace = new Map<String, List<String>>();
        Constants.NAMESPACE = (Constants.NAMESPACE == null) ? '' : Constants.NAMESPACE;
        for(String objN : objFieldsMap.keySet()) {
            List<String> fieldsList = objFieldsMap.get(objN);
            
            if(objN.indexOf((Constants.NAMESPACE).toLowerCase()) == -1 && objN.indexOf('__c') != -1) {
                objN = Constants.NAMESPACE + objN;
            }
            objFieldsMapWithNameSpace.put(objN, fieldsList);
        }
        return objFieldsMapWithNameSpace;
    }
    
    private static Set<String> compoundFieldsDataTypeSet = new Set<String>{'ADDRESS', 'LOCATION'};
    
    /*
    	Check fields permission, except for following:
    	1. Field which are permissible in schema are only checked for Updateable condition, like LastModifedDate, CreatedDate are excluded in check
		2. Calculated (Formula) fields
		3. Autonumber fields
		4. Compound fields: Address, Location
    */
    private static Boolean isFieldUpdateable(Schema.DescribeFieldResult fieldDescRes) {
        Boolean isUpdateable = false;
        if(	fieldDescRes.isCalculated() || 
        	!fieldDescRes.isPermissionable() || 
        	fieldDescRes.isAutoNumber() || 
        	compoundFieldsDataTypeSet.contains(String.valueOf(fieldDescRes.getType()))
        ) {
            isUpdateable = true;
        } else if(fieldDescRes.IsUpdateable() && fieldDescRes.isPermissionable()) {
            isUpdateable = true;
        }
        return isUpdateable;
    }
    
    /*
    	Check fields permission, except for following:
    	1. Field which are permissible in schema are only checked for createable condition, like LastModifedDate, CreatedDate are excluded in check
		2. Calculated (Formula) fields
		3. Autonumber fields
		4. Compound fields: Address, Location
    */
    private static Boolean isFieldCreateable(Schema.DescribeFieldResult fieldDescRes) {
        Boolean isCreateable = false;
        if(	fieldDescRes.isCalculated() || 
        	!fieldDescRes.isPermissionable() || 
        	fieldDescRes.isAutoNumber() || 
        	compoundFieldsDataTypeSet.contains(String.valueOf(fieldDescRes.getType()))
        ) {
            isCreateable = true;
        } else if(fieldDescRes.isCreateable() && fieldDescRes.isPermissionable()) {
            isCreateable = true;
        }
        return isCreateable;
    }
}