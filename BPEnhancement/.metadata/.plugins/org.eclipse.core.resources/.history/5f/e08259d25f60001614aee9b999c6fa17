public with sharing class SearchSuggestionJSON {
    
    // Method to parse the search query JSON
    public static QueryJSON parseQuery(String json) {
        return (QueryJSON) System.JSON.deserialize(json, QueryJSON.class);
    }
    
    /**
     * Name: QueryJSON
     * Description: Class to represent search query JSON
    **/
    public class QueryJSON {
        // Object label selected by user to search in
        public String ObjectLabel {get; set;}
        
        // Search text
        public String SearchText {get; set;}
        
        // Preferred object to look into or add
        public String PreferredObject {get; set;}
        
        // Preferred objects into which to look
        public String SearchableObjects {get; set;}
        
        // List of filters need to be applied on records
        public List<FilterJSON> FilterValues {get; set;}
    }
    
    /**
     * Name: FilterJSON
     * Description: Class to hold filter field and filter value for object
    **/
    public class FilterJSON {
    	// Object field API name on which filter needs to be applied
    	public String Field {get; set;}
    	
    	// Field value by which records need to be filtered
    	public String Value {get; set;}
    	// field Value for Object To filter
    	public String FilterObject{get;set;}
    }
    
    /**
     * Name: ResultJSON
     * Description: Class to represent search reault reocrds JSON
    **/
    public class ResultJSON {
        // Record display text
        public String Name {get; set;}
        
        // Record background value (generally Id value)
        public String Value {get; set;}
        
        // Additional info for the record
        public String Description {get; set;}
        
        // Record specification
        public String Info {get; set;}
        
        //Record Additional Info
        public AdditionalDetails AdditionalDetailsForPart;  
        
         
        // Constructor
        public ResultJSON(sObject record, String name, String value, String Description, String info, String qty, String qtyCommitted, String price){
            this.Name = name;
            
            this.Value = value;
            
            // Set additional information for record as specified in custom settings
            setAdditionalInfo(record, Description);
            //system.assert(false, info);
            // set record specifications
            setInfoForObject(info);
              
            if(info == Constants.NAMESPACE + 'Part__c') {
                this.additionalDetailsForPart = new AdditionalDetails(String.valueOf(record.get(Constants.NAMESPACE + 'Part_Number__c')) + ' - ' + String.valueOf(record.get(Constants.NAMESPACE + 'Description__c')), qty, qtyCommitted, price, String.valueOf(record.get('Id')), String.valueOf(record.get(Constants.NAMESPACE + 'Vendor__c')));
            }
            else if (info == Constants.NAMESPACE + 'Kit_Header__c'){
                this.additionalDetailsForPart = new AdditionalDetails(Boolean.valueOf(record.get(Constants.NAMESPACE + 'Service_Kit__c')));
            }
        }
        
        
        
        // Method to set the info description for object record
        // Purpose of the method is to set object lable as defined in custom labels
        private void setInfoForObject(String info){
            if( Constants.objectNameToObjectDisplayLabel.containsKey(info) ){
                
                this.info = Constants.objectNameToObjectDisplayLabel.get(info);
            } else {
                this.info = info;
            }
        }
        
        // Method to set the Additional info description for object record
        private void setAdditionalInfo(sObject record, String Description){
            if(record != null && Description != null && Description.length() != 0){
                String compliedDesc = '';
                Integer indexVal = 0;
                
                // Case if there is/are only '{' in description tag and no other character, 
                // so the split method does not recognise empty string and won't process in for loop
                if(Description.split('\\{').size() == 0){
                    compliedDesc = Description;
                }
                
                for(String breakWord : Description.split('\\{')){
                    if(breakWord.indexOf('}') != -1){
                        // This is the bind operator for object field value to insert here
                        String objField = breakWord.subString(0, breakWord.indexOf('}'));
                        
                        // Try getting field value from object and if the "objField" is not object field api name then
                        // Catch the SObjectException and put the value as is
                        try{
                            compliedDesc += ' ' + String.valueOf(record.get(objField)) + breakWord.subString(breakWord.indexOf('}') + 1);
                        } catch (SObjectException sObjException){
                            // indexVal != 0 check is for the case if description is '}'
                            // If only the break word has '{' in start and not an object field, then add the '{' as it should not be complied
                            compliedDesc += (((indexVal != 0) && (Description.substring(indexVal-1, indexVal)) == '{') ? '{' : '' ) + objField + '}';
                        }
                    } else if(breakWord != ''){
                        // This is the case is description starts with '{' and there is no closing brace for the one
                        // So add a opening brace
                        compliedDesc += '{' + breakWord;
                    }
                    indexVal += breakWord.length() + 1;
                }
                compliedDesc = compliedDesc.trim();
                
                this.Description = compliedDesc;
            }
        }
    }
    
    public class AdditionalDetails {
        
        public String Item {get; set;}
        
        public Decimal Qty {get; set;}
        
        public Decimal QtyCommitted {get; set;}
        
        public String Status {get; set;}
        
        public Decimal Price {get; set;}
        
        public Decimal SubTotal {get; set;}
        
        public String Invoice {get; set;}
        
        public String FulfillDate {get; set;}
        
        public String PartId {get; set;}
        
        public String VendorId {get; set;}
        
        public boolean IsServiceKit{get;set;}
        
        public AdditionalDetails(String item, String qty, String qtyCommitted, String price, String partId, String vendorId) {
            this.Item = item;
            this.Qty = 1;
            this.QtyCommitted = 0;
            if(String.isBlank(qty)) {
            	qty = '0';
            }
            if(String.isBlank(qtyCommitted)) {
            	qtyCommitted = '0';
            }
            
            if(Decimal.valueOf(qty) - Decimal.valueOf(qtyCommitted) > 0) {
                this.Status = 'In Stock';   
            } else {
                this.Status = 'Out of Stock';
            }
            if(String.isBlank(price)) {
                this.Price = 0;
            } else {
                this.Price = Decimal.valueOf(price);
            }
            this.SubTotal = this.Qty * this.price;
            this.Invoice = '';
            this.FulfillDate = String.valueOf(system.today());
            this.PartId = partId;
            this.VendorId = vendorId;
        }
        public AdditionalDetails(boolean IsServiceKit){
        	
        	//system.assert()
        	this.IsServiceKit = IsServiceKit;
        }
    }
}