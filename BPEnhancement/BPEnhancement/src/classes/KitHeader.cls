/**
 * Author: Tarun Khandelwal
 * Since: Nov 19, 2015
 * Name: KitHeader
 * Description: Apex class to handle JSON related oprations of Kit Header Object
**/
public with sharing class KitHeader {
	
	public String Description;
	public Boolean CanItSplit;
	public String Code;
	public Boolean IsServiceKit;
	public List<String> Concern;
	public List<String> Correction;
	public List<String> Cause;
	public String MakeName;
	public String MakeId;
	public String ModelName;
	public String ModelId;
	public String SubModelName;
	public String SubModelId;
	public List<TransactionType> TransactionTypeList;
	public Boolean IsActive;
	public String Id;
	public Decimal FixedPrice;
	public Decimal RetailPrice;
	public Boolean IsFixedPrice; 
	public Decimal NumberOfLabours;
	
	public 	KitHeader(Kit_Header__c kitHeaderRec) {
		
		this.Description = kitHeaderRec.Description__c;
		this.CanItSplit = kitHeaderRec.Can_Split__c;
		this.IsServiceKit = kitHeaderRec.Service_Kit__c;
		this.Code = kitHeaderRec.Code__c;
		this.MakeId = kitHeaderRec.Make__c;
		this.MakeName = (kitHeaderRec.Make__c == null) ? '' : kitHeaderRec.Make__r.Name;
		this.ModelId = kitHeaderRec.Model__c;
		this.ModelName = (kitHeaderRec.Model__c == null) ? '' : kitHeaderRec.Model__r.Name__c;
		this.SubModelId = kitHeaderRec.SubModel__c;
		this.SubModelName = (kitHeaderRec.SubModel__c == null) ? '' : kitHeaderRec.SubModel__r.Sub_Model__c;
		this.IsActive = kitHeaderRec.Active__c;
		this.Id = kitHeaderRec.Id;
		
		this.Concern = new List<String>();
		this.Correction = new List<String>();
		this.Cause = new List<String>();
		system.debug(kitHeaderRec.Concern__c);
		this.Concern = (kitHeaderRec.Concern__c != null) ? kitHeaderRec.Concern__c.split('\n') : new List<String>();
		this.Correction = (kitHeaderRec.Correction__c != null) ? kitHeaderRec.Correction__c.split('\n') : new List<String>();
		this.Cause = (kitHeaderRec.Cause__c != null) ? kitHeaderRec.Cause__c.split('\n') : new List<String>();
		this.FixedPrice = kitHeaderRec.Fixed_Price__c;
		this.IsFixedPrice = kitHeaderRec.Fixed_Price_Flag__c ;
		this.NumberOfLabours = (kitHeaderRec.Number_of_Labours__c == null) ? 0 : kitHeaderRec.Number_of_Labours__c;
		
		this.TransactionTypeList = new List<TransactionType>();
		
		for(Kit_Transaction_Type_Junction__c kitToTTJunRec : kitHeaderRec.Kit_Transaction_Type_Junctions__r) {
			this.TransactionTypeList.add(new TransactionType(kitToTTJunRec.Transaction_Type__c, kitToTTJunRec.Transaction_Type__r.Code__c));
		}
		
		this.RetailPrice = 0;
		if(kitHeaderRec.Kit_Header_Line_Items__r != null){
			for(Kit_Header_Line_Item__c khli : kitHeaderRec.Kit_Header_Line_Items__r){
				this.RetailPrice += khli.Qty_Needed__c * khli.Retail_Price__c;
			}
		}
	}
	
	public static List<String> getKitHeaderFields() {
		List<String> kitFields = new List<String>{	'Can_Split__c',
													'Cause__c',
													'Code__c',
													'Concern__c',
													'Correction__c',
													'Description__c',
													'Fixed_Price__c',
													'Fixed_Price_Flag__c',
													'Number_of_Labours__c',
													'Make__c',
													'Make__r.Name',
													'Model__c',
													'Model__r.Name__c',
													'Service_Kit__c',
													'SubModel__c',
													'SubModel__r.Sub_Model__c',
													'Active__c',
													'(Select Id, Qty_Needed__c, Retail_Price__c, Fixed_Price__c, Kit_Price__c, Total__c from Kit_Header_Line_Items__r)'
											};
		return kitFields;
	}
	
	public static List<String> getKitTransactionTypeJunctionFields() {
		List<String> kitFields = new List<String>{	'Kit_Header__c',
													'Transaction_Type__c',
													'Transaction_Type__r.Code__c'
											};
		return kitFields;
	}
	
	/**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: KitHeader - Class Object
    **/
    public static KitHeader parse(String json) {
        return (KitHeader) System.JSON.deserialize(json, KitHeader.class);
    }
    
    
    public class TransactionType {
    	
    	public String Id;
    	public String TTName;
    	
    	public TransactionType(Transaction_Type__c ttRec) {
    		this.Id = ttRec.Id;
    		this.TTName = ttRec.Code__c;
    	}
    	
    	public TransactionType(String ttId, String ttCode) {
    		this.Id = ttId;
    		this.TTName = ttCode;
    	}
	}
}