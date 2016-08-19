/**
 * Author: Tarun Khandelwal
 * Since: March 13, 2015
 * Name: CustomerOrderCtrl
 * Description: Apex class which contains all remoted methods related to Customer Order Page.
**/
public with sharing class Part {
	// record Id
	public Id PartId;
	
	// Part description
	public String Description;
	
	// Quantity available
	public Double Qty_Available;
	
	// Quantity committed
	public Double Qty_Committed;
	
	// Part unit price
	public double Unit_Price;
	
	// Constructor
	public Part(Part__c obj){
		PartId = obj.Id;
		Description = obj.Part_Id__c;
		Qty_Available = obj.Qty_In_Stock__c;
		Qty_Committed = obj.Qty_Committed__c;
		Unit_Price = obj.Retail_Price__c;
	}
	
	// A method to define the list of part fields to be used in queries
	public static List<String> fieldsList(){
		List<String> partFields = new List<String>{	'Id', 
													'Part_Id__c', 
													'Qty_In_Stock__c', 
													'Qty_Committed__c', 
													'Retail_Price__c'
												};
		return partFields;
	}
}