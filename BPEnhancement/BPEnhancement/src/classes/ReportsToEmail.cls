public with sharing class ReportsToEmail {
    public static Map<String, String> whereClause = new Map<String, String>{  '7' => 'LAST_N_DAYS:7',
                                                                '15' => 'LAST_N_DAYS:15',
                                                                '30' => 'LAST_N_DAYS:30',
                                                                '1' => 'LAST_N_DAYS:1'};
                                                                
    public static Map<String, String> displayObjectNameToObjectAPINameMap = new Map<String, String>{    'Customer' => 'Customer' ,
                                                                                                        'Vendor' => 'Vendor' ,
                                                                                                        'CO_Header__c' => 'Customer Orders',
                                                                                                        'Part__c' => 'Parts',
                                                                                                        'Vendor_Order_Header__c' => 'Vendor Order'
                                                                                                };
    public static Map<String, String> ObjectNameToOwnerAPINameMap   =  new Map<String, String>{ 'Part__c' => 'Vendor__r.Owner.Name' 
                                                                                                
                                                                                                };    
   	                                                                                             
    public static String orgInfo(){
        if(AccessControl.ifObjectFieldIsAccessible('Organization') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
   	 	List<Organization> orgDetails = [Select  Name  From Organization LIMIT 1];  
        return orgDetails[0].Name;
    }                                                                                                         

    @readonly
    @remoteAction
    public static void getOrgReports(){
        if(getIsReporting()){
            List<String> ObjectNameList =  getObjectNames().split(';');
            List<String> RecipientEmailList = getRecipientEmail().split(';');
            Map<String, Map<String , Decimal>> ObjectToNoOfRecordsMap = noOfRecordsCreated(ObjectNameList);
            Map<String, String> userNameToLastLogin = getLogindetails();
            Map<String , Integer> getTotalRecordsCount = getTotalRecords(ObjectNameList);
            //system.assert(false,getTotalRecordsCount);
            String subject = 'Daily Activity Report for '+ orgInfo() +' Org '+  DateTime.now();
           	String body = emailBody( ObjectToNoOfRecordsMap, userNameToLastLogin, getTotalRecordsCount );
            sendEmailReport(RecipientEmailList, body, subject);
            //System.assert(false,body);
        }
        
    }
    
    @readonly
    @remoteAction
    public static  Map<String , Integer> getTotalRecords(List<String> objectName){
     Map<String , Integer> objectToRecordsMap = new Map<String , Integer>();
    	for(String selectedObjName : objectName) {
            if(selectedObjName == 'Customer' || selectedObjName == 'Vendor' ){
            	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            }else{
            	if(AccessControl.ifObjectFieldIsAccessible(selectedObjName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            }
            String objQuery = createSOQLForTotalObjectRecord(selectedObjName);
        	Integer intCount = 0;
            for(AggregateResult result :  Database.query(objQuery))
            {
                intCount+=(Integer)result.get('totalRec');
            }
            //system.assert(false, '\n\n\n\n' + intCount);
           	objectToRecordsMap.put(selectedObjName,intCount);
             
        }
        //system.assert(false,objectToRecordsMap);
        return objectToRecordsMap;
    }
    
    
    private static Map<String, String> getLogindetails(){
        if(AccessControl.ifObjectFieldIsAccessible('LoginHistory') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<LoginHistory> loginrec = [Select UserId, Status, LoginTime From LoginHistory   where LoginTime > = LAST_N_DAYS: 1 Order By LoginTime];
        Set<String> UserIdSet = new Set<String>();
        for(LoginHistory logRec : loginrec ){
            if(logRec.status == 'Success'){
                UserIdSet.add(logRec.UserId);
            }
        }
        if(AccessControl.ifObjectFieldIsAccessible('user') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        Map<ID, User> userIdToName = new Map<ID, User>([SELECT Id, Name FROM user where Id In: UserIdSet]);
        
        Map<String, String> userNameToLastLogin = new Map<String, String>();
        for(LoginHistory logRec : loginrec ){
            String userID = logRec.UserId;
            if(UserIdSet.contains(userID)){
                if(!userNameToLastLogin.containsKey(logRec.UserId)){
                    userNameToLastLogin.put(userIdToName.get(logRec.UserId).Name,string.valueOf(logRec.LoginTime));
                }
            }
        }
        return userNameToLastLogin;
    }
     
    public static Map<String, Map<String , Decimal>> noOfRecordsCreated(List<String> objectName){
        Map<String, Map<String , Decimal>> resultRecordsMap = new Map<String, Map<String , Decimal>>();
        Map<String , Decimal> UserToRecordsMap ;
        
        for(String selectedObjName : objectName) {
            UserToRecordsMap = new Map<String , Decimal>();
            if(selectedObjName == 'Customer' || selectedObjName == 'Vendor' ){
            	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            }else{
            	if(AccessControl.ifObjectFieldIsAccessible(selectedObjName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            }
            
            String objQuery = createSOQLForObject(selectedObjName);
            //system.assert(false,objQuery);
            List<AggregateResult> resultRecords = Database.query(objQuery);
            //system.assert(false, objQuery + '\n\n\n\n' + resultRecords);
            for(AggregateResult ownerRec: resultRecords){
                UserToRecordsMap.put((String)ownerRec.get('ownName'),(Decimal)ownerRec.get('total'));
            }
            resultRecordsMap.put(selectedObjName,UserToRecordsMap );   
        }
        //System.assert(false,resultRecordsMap);
        return resultRecordsMap;
        
    }
    
    private static String createSOQLForObject(String objName) {
        String objToQuery  = '';
        if(objName.equalsIgnoreCase('CUSTOMER')){
            objToQuery =  'Account WHERE Is_Customer__c = True  AND';
        }else if( objName.equalsIgnoreCase('VENDOR')){
            objToQuery =  'Account WHERE Is_Vendor__c = True AND';
        }
        else{
            objToQuery = objName + ' WHERE';
        }
        String query = 'SELECT COUNT(Id) total,';
        String ownerField = '';
        if(ObjectNameToOwnerAPINameMap.containsKey(objName)){
            ownerField = 'Vendor__r.Owner.Name ';
        } else{
            ownerField = 'Owner.Name ';
        }
        query += ownerField;
        query += 'ownName FROM ' + objToQuery;
        query += ' CreatedDate = ' + whereClause.get('1');
        query += ' GROUP BY '+ ownerField;
        
        return query;
    }
    
    
    private static String createSOQLForTotalObjectRecord(String objName) {
        String objToQuery  = '';
        if(objName.equalsIgnoreCase('CUSTOMER')){
            objToQuery =  'Account WHERE Is_Customer__c = True ';
        }else if( objName.equalsIgnoreCase('VENDOR')){
            objToQuery =  'Account WHERE Is_Vendor__c = True ';
        }
        else{
            objToQuery = objName + ' WHERE Id != null';
        }
        String query = 'SELECT COUNT(Id)  totalRec';
        query += ' FROM ' + objToQuery;
        
        return query;
    }
    
    
    public static Boolean getIsReporting() {
        return Reporting__c.getOrgDefaults().Is_Reporting__c;
    }
    
    public static String getObjectNames()    {
        return Reporting__c.getOrgDefaults().Reporting_Objects__c  ;
    }
    
    public static String getRecipientEmail()    {
        return Reporting__c.getOrgDefaults().Receipient_Email__c  ;
    }
    
    
    private static void sendEmailReport(List<String> emailStrList, String htmlBody, String subject){
        if(emailStrList.size() == 0) {
            return;
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String sentFromEmailString = Configurations__c.getInstance().Sent_From_Email_Id__c;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = emailStrList;
        mail.setToAddresses(sendTo);
        mail.setReplyTo(sentFromEmailString);
        mail.setSenderDisplayName('BlackPurl Team');
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
    
    private static String emailBody(Map<String, Map<String , Decimal>> ObjectToNoOfRecordsMap, Map<String, String> userNameToLastLoginDetails, Map<String , Integer> getTotalRecordsCount  ){
        String htmlBodyString = null ;
        htmlBodyString = '<p>******DO NOT REPLY******</p>';
        htmlBodyString += '<br/>This is an autogenerated report of activities on ';
        htmlBodyString += orgInfo() + ' Org for the last 24 hours.';
        htmlBodyString += '<h2>Detailed Report - </h2>';
        
        htmlBodyString += '<table border= \'1px solid black;\' style=\' border-collapse: collapse;\' >';
        htmlBodyString += '<tr> <th> S.No. </th> <th> Entity </th> <th> User </th><th> Created In last 24 Hours </th><th> Total Records </th>  </tr>';
        Decimal total = 0;
        Integer counter = 1;
        Decimal grandTotal = 0;
        boolean isFirstRow;
        Integer totalRecords = 0;
        for(String str : ObjectToNoOfRecordsMap.keySet()){
            total = 0;
            htmlBodyString += '<tr> ';
            htmlBodyString += '<td style =\' text-align: center;\'>' + counter + '</td>';
            htmlBodyString += '<td>' + displayObjectNameToObjectAPINameMap.get(str) + '</td>';
            isFirstRow = true;
            if(ObjectToNoOfRecordsMap.get(str).keySet().size() == 0){
                htmlBodyString += '<td style =\' text-align: center;\'> - </td> <td style =\' text-align: center;\'> 0 </td><td></td> </tr>';
                
            }
            for(String str1 : ObjectToNoOfRecordsMap.get(str).keySet()){
                if(!isFirstRow){
                    htmlBodyString += '<tr> ';
                    htmlBodyString += '<td> </td> <td> </td>';
                    
                }
                htmlBodyString += '<td style =\' text-align: center;\'>' + str1 + '</td>';
                htmlBodyString += '<td style =\' text-align: center;\'>' + ObjectToNoOfRecordsMap.get(str).get(str1) + '</td>';
                htmlBodyString += '<td> </td>';
                htmlBodyString += '</tr>';
                Decimal x = ObjectToNoOfRecordsMap.get(str).get(str1);
                total += x;
                grandTotal += x;
                isFirstRow = false;
            }
            if(ObjectToNoOfRecordsMap.get(str).keySet().size() != 0){
                htmlBodyString += '<td colspan="2">  </td> </tr>';
                htmlBodyString += '<td style = \'font-weight: bold; text-align: right;\' > TOTAL </td>';
                htmlBodyString += '<td style = \'font-weight: bold; text-align: center;\'>' + total + '</td>';
                htmlBodyString += '<td style = \'font-weight: bold; text-align: center;\'>' + getTotalRecordsCount.get(str) + '</td>';
                totalRecords += getTotalRecordsCount.get(str);
                 
            }
            if(ObjectToNoOfRecordsMap.get(str).keySet().size() == 0){
                htmlBodyString += '<td  colspan="2">  </td> </tr>';
                htmlBodyString += '<td style = \'font-weight: bold; text-align: right; \'> TOTAL </td>';
                htmlBodyString += '<td style = \'font-weight: bold; text-align: center;\'> 0 </td>';
                htmlBodyString += '<td style = \'font-weight: bold; text-align: center;\'>' + getTotalRecordsCount.get(str) + '</td>';
                totalRecords += getTotalRecordsCount.get(str);
            }
            counter++;
        }
        htmlBodyString += '<tr>';
     	htmlBodyString += '<td colspan="2">  </td>';
        htmlBodyString += '<td style = \'font-weight: bold; text-align: right; \'>  GRAND TOTAL </td>';
        htmlBodyString += '<td style = \'font-weight: bold; text-align: center;\'>' + grandTotal + '</td>';
        htmlBodyString += '<td style = \'font-weight: bold; text-align: center;\'>' + totalRecords + '</td>';
        htmlBodyString += '</tr>';
        
        htmlBodyString += '</table>';
        htmlBodyString += '<br/><br/>';
        
        htmlBodyString += '<table border= \'1px solid black;\' style=\' border-collapse: collapse;\' >';
        htmlBodyString += '<tr> <th> S.No. </th><th> User Name </th><th> Last Logged In At </th>  </tr>';
        Integer counterVar = 1;
        for(String userRec : userNameToLastLoginDetails.keySet()){
            htmlBodyString += '<tr> ';
            htmlBodyString += '<td style =\' text-align: center;\'>' + counterVar + '</td>';
            htmlBodyString += '<td>' + userRec + '</td>';
            htmlBodyString += '<td>' + userNameToLastLoginDetails.get(userRec) + '</td>';
            htmlBodyString += '</tr> ';
            counterVar++;
        }
        htmlBodyString += '</table>';
        
        htmlBodyString += '<br/>Team Blackpurl';
        
        return htmlBodyString;
        
        
    }
}