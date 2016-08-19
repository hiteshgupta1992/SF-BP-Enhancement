/**
 * Author: 
 * Since: 
 * Name: HomeSearchFilterInterface
 * Description: Home Search Filter Apex Class
**/
public with sharing class HomeSearchFilterInterface {
	private static String objectName;
	
	 /**
     * Name: getFilterList
     * Desc: Getting Filter List
     * @param:  (1) homeSerachFilterObj - HomeSearchFilterWrapper - Home Search Filter Wrapper Record
     * @return: Map<String, List<FieldFilter>>
    **/
	public static Map<String, List<FieldFilter>> getFilterList(HomeSearchFilterWrapper homeSerachFilterObj) {
		Map<String, List<FieldFilter>> objectFilterJSON = new Map<String, List<FieldFilter>>();
		
		System.debug('@#@#@#@homeSerachFilterObj.Type.Objects BEOFER:  ' + homeSerachFilterObj.Type.Objects);
		// If nothing selected in object, then add 'Any' generic search
		if(homeSerachFilterObj.Type.Objects == null || homeSerachFilterObj.Type.Objects.size() == 0) {
			homeSerachFilterObj.Type.Objects = new Set<String>{Label.Generic_Object_Label};
		}
		
		System.debug('@#@#@#@homeSerachFilterObj.Type.Objects MID:  ' + homeSerachFilterObj.Type.Objects);
		// If Customer and Vendor both are added in list, then combine them to 'People'
		// method Should be generari using looping
		boolean isAddedPeople = false;
		if(homeSerachFilterObj.Type.Objects.contains('Customers') && homeSerachFilterObj.Type.Objects.contains('Vendors')) {
			isAddedPeople = true;
			homeSerachFilterObj.Type.Objects.remove('Customers');  
			homeSerachFilterObj.Type.Objects.remove('Vendors');
		}
		if(isAddedPeople) {
			Set<String> objectsSet = new Set<String>(homeSerachFilterObj.Type.Objects);
			objectsSet.add('People');
			homeSerachFilterObj.Type.Objects = new Set<String>(objectsSet);
		}
		System.debug('@#@#@#@homeSerachFilterObj.Type.Objects AFTER:  ' + homeSerachFilterObj.Type.Objects);
		
		Set<String> objectSet = new Set<String>();
		if(homeSerachFilterObj.Type.Objects.size() == 0 || (homeSerachFilterObj.Type.Objects.size() == 1 && homeSerachFilterObj.Type.Objects.contains(Label.Generic_Object_Label))) {
			objectSet = HomeSearchUtil.displayObjectNameToTypeNumber.keySet();
		} else {
			objectSet = homeSerachFilterObj.Type.Objects;
		}
		
		/*if(homeSerachFilterObj.Type.Objects.contains('Customer Orders')  && homeSerachFilterObj.Customer_Order_Payments  !=null  &&  homeSerachFilterObj.Customer_Order_Payments){
				set<CO_Invoice_Header__c> myset = new set<CO_Invoice_Header__c>([select CO_Invoice_Header__c.CO_Header__r.Id from CO_Invoice_Header__c WHERE  Id IN
									(select  CO_Invoice_Header__c FROM CO_Invoice_Payment__c WHERE Amount__c >= 200)]);
				//filterJSON.add(new FieldFilter('', '', ));	
				
				system.assert(false,'Id In('+myset+' )');
		}*/
		for(String objName : objectSet) {
			List<FieldFilter> filterJSON = new List<FieldFilter>();
			
			//For People Vendor and Cutomers
			if(objName == 'People' || objName == 'Customers'  || objName == 'Vendors'){
				if(objName == 'Customers') {
					filterJSON.add(new FieldFilter('Is_Customer__c', '=', 'true'));
				} else if(objName == 'Vendors') {
					filterJSON.add(new FieldFilter('Is_Vendor__c', '=', 'true'));
				} else if(objName == 'People') {
					filterJSON.add(new FieldFilter('', '=', '(Is_Customer__c = true OR Is_Vendor__c = true)'));
				}
				
				if(!String.isBlank(homeSerachFilterObj.People_BillingAddress)) {
					filterJSON.add(new FieldFilter('BillingStreet', 'Like','\'%' + homeSerachFilterObj.People_BillingAddress + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.People_BillingCity)){
					filterJSON.add(new FieldFilter('BillingCity', 'Like','\'%' + homeSerachFilterObj.People_BillingCity + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.People_Country)){
					filterJSON.add(new FieldFilter('BillingCountry', 'Like','\'%' + homeSerachFilterObj.People_Country + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.People_StateProv)){
					filterJSON.add(new FieldFilter('BillingState', 'Like','\'%' + homeSerachFilterObj.People_StateProv + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.People_Email)){
					filterJSON.add(new FieldFilter('',	'', (' (Preferred_Email__c Like \'%' + homeSerachFilterObj.People_Email + '%\''
														+ ' OR Email__c Like \'%' + homeSerachFilterObj.People_Email + '%\''
														+ ' OR Other_Email__c Like \'%' + homeSerachFilterObj.People_Email + '%\''
														+ ' OR Work_Email__c Like \'%' + homeSerachFilterObj.People_Email + '%\')') ));
				}
				if(!String.isBlank(homeSerachFilterObj.People_Id)) {
					filterJSON.add(new FieldFilter('', '=', '(Vendor_Code__c LIKE \'%' + homeSerachFilterObj.People_Id + '%\' OR Customer_Number__c LIKE \'%' + homeSerachFilterObj.People_Id + '%\')'));
				}
				if(!String.isBlank(homeSerachFilterObj.People_Name)){
					filterJSON.add(new FieldFilter('Name', 'Like','\'%' + homeSerachFilterObj.People_Name + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.People_Phone)){
					filterJSON.add(new FieldFilter('',	'', (' (Preferred_Phone__c Like \'%' + homeSerachFilterObj.People_Phone + '%\''
														+ ' OR Phone Like \'%' + homeSerachFilterObj.People_Phone + '%\''
														+ ' OR Home_Number__c Like \'%' + homeSerachFilterObj.People_Phone + '%\''
														+ ' OR Preferred_SMS__c Like \'%' + homeSerachFilterObj.People_Phone + '%\''
														+ ' OR Work_Number__c Like \'%' + homeSerachFilterObj.People_Phone + '%\''
														+ ' OR Mobile__c Like \'%' + homeSerachFilterObj.People_Phone + '%\')') ));
				}
				if(!String.isBlank(homeSerachFilterObj.People_PriceLevel) && homeSerachFilterObj.People_PriceLevel != '0'){
					filterJSON.add(new FieldFilter('Price_Level__c', '=', '\'' + homeSerachFilterObj.People_PriceLevel + '\''));
				}
				if(!String.isBlank(homeSerachFilterObj.People_SalesTax) && homeSerachFilterObj.People_SalesTax != '0'){
					filterJSON.add(new FieldFilter('Sales_Tax__c', '=', '\'' + homeSerachFilterObj.People_SalesTax +'\''));
				}
				//Purhcase tax
				if(objName == 'Vendors' && !String.isBlank(homeSerachFilterObj.Vendor_PurchaseSalesTax) && homeSerachFilterObj.Vendor_PurchaseSalesTax != '0'){
					filterJSON.add(new FieldFilter('Purchase_Tax__c', '=', '\'' + homeSerachFilterObj.Vendor_PurchaseSalesTax + '\''));
				}
			}
					
			//For User
			if(objName == 'User') {
				filterJSON.add(new FieldFilter('IsActive', '=', 'true'));
			}
			
			// Parts
			if(objName == 'Parts') {
				if(!String.isBlank(homeSerachFilterObj.Product_Item)) {
					filterJSON.add(new FieldFilter('Part_Number__c', 'Like', '\'%' + homeSerachFilterObj.Product_Item + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Description)){
					filterJSON.add(new FieldFilter('Description__c', 'Like', '\'%' + homeSerachFilterObj.Product_Description + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Category) && homeSerachFilterObj.Product_Category != '0') {
					filterJSON.add(new FieldFilter('Category__c', '=', '\'' + homeSerachFilterObj.Product_Category + '\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_Price.SelectedOption) && homeSerachFilterObj.Product_Price.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Product_Price, 'Retail_Price__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_QtyAvailable.SelectedOption) && homeSerachFilterObj.Product_QtyAvailable.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Product_QtyAvailable, 'AvailableParts__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_Location)) {
					filterJSON.add(new FieldFilter('Location__c', 'Like', '\'%' + homeSerachFilterObj.Part_Location + '%\''));
				}
				
				
				if(!String.isBlank(homeSerachFilterObj.Part_Cost.SelectedOption) && homeSerachFilterObj.Part_Cost.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_Cost, 'Last_Cost__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_AverageCost.SelectedOption) && homeSerachFilterObj.Part_AverageCost.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_AverageCost, 'Average_Cost__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				
				if(!String.isBlank(homeSerachFilterObj.Part_InStock.SelectedOption) && homeSerachFilterObj.Part_InStock.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_InStock, 'Qty_In_Stock__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_Committed.SelectedOption) && homeSerachFilterObj.Part_Committed.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_Committed, 'Qty_Committed__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_OnOrder.SelectedOption) && homeSerachFilterObj.Part_OnOrder.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_OnOrder, 'Qty_On_Order__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_PackagedPart) && homeSerachFilterObj.Part_PackagedPart != '0') {
					if(homeSerachFilterObj.Part_PackagedPart == '1') {
						filterJSON.add(new FieldFilter('Packaged_Part__c', '=', true));
					} else if(homeSerachFilterObj.Part_PackagedPart == '2') {
						filterJSON.add(new FieldFilter('Packaged_Part__c', '=', false));
					} 
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_LastCounted.SelectedOption) && homeSerachFilterObj.Part_LastCounted.SelectedOption != '0') {
					List<FieldFilter> lastCountedFilterJSON = getDateFilter(homeSerachFilterObj.Part_LastCounted, 'Last_Counted__c');
					if(lastCountedFilterJSON.size() > 0) {
						filterJSON.addAll(lastCountedFilterJSON);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_LastSold.SelectedOption) && homeSerachFilterObj.Part_LastSold.SelectedOption != '0') {
					List<FieldFilter> lastSoldFilterJSON = getDateFilter(homeSerachFilterObj.Part_LastSold, 'Last_Sold__c');
					if(lastSoldFilterJSON.size() > 0) {  
						filterJSON.addAll(lastSoldFilterJSON);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_LastStocked.SelectedOption) && homeSerachFilterObj.Part_LastStocked.SelectedOption != '0') {
					List<FieldFilter> lastStockFilterJSON = getDateFilter(homeSerachFilterObj.Part_LastStocked, 'Last_Stocked__c');
					if(lastStockFilterJSON.size() > 0) {
						filterJSON.addAll(lastStockFilterJSON);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_ReorderAt.SelectedOption) && homeSerachFilterObj.Part_ReorderAt.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_ReorderAt, 'Auto_reorder_Min__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_ReorderTo.SelectedOption) && homeSerachFilterObj.Part_ReorderTo.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Part_ReorderTo, 'Auto_reorder_Max__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_Vendor)) {
					filterJSON.add(new FieldFilter('Vendor__r.Name', 'LIKE', '\'' + homeSerachFilterObj.Part_Vendor + '%\''));
				}
			}
			
			// Kits
			if(objName == 'Kits'){
				if(!String.isBlank(homeSerachFilterObj.Product_Item)) {
					filterJSON.add(new FieldFilter('Code__c', 'Like', '\'%' + homeSerachFilterObj.Product_Item + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Description)){
					filterJSON.add(new FieldFilter('Description__c', 'Like', '\'%' + homeSerachFilterObj.Product_Description + '%\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_Price.SelectedOption) && homeSerachFilterObj.Product_Price.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Product_Price, 'Fixed_Price__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Kit_KitPrice.SelectedOption) && homeSerachFilterObj.Kit_KitPrice.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Kit_KitPrice, 'Fixed_Price__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Kit_FixedPrice) && homeSerachFilterObj.Kit_FixedPrice != '0') {
					if(homeSerachFilterObj.Kit_FixedPrice == '1') {
						filterJSON.add(new FieldFilter('Fixed_Price_Flag__c', '=', true));
					} else if(homeSerachFilterObj.Kit_FixedPrice == '2') {
						filterJSON.add(new FieldFilter('Fixed_Price_Flag__c', '=', false));
					} 
				}
				
				if(!String.isBlank(homeSerachFilterObj.Kit_ServiceKit) && homeSerachFilterObj.Kit_ServiceKit != '0') {
					if(homeSerachFilterObj.Kit_ServiceKit == '1') {
						filterJSON.add(new FieldFilter('Service_Kit__c', '=', true));
					} else if(homeSerachFilterObj.Kit_ServiceKit == '2') {
						filterJSON.add(new FieldFilter('Service_Kit__c', '=', false));
					} 
				}
			}
			
			// Fees
			if(objName == 'Fees'){
				if(!String.isBlank(homeSerachFilterObj.Product_Item)) {
					filterJSON.add(new FieldFilter('Code__c', 'Like', '\'%' + homeSerachFilterObj.Product_Item + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Description)){
					filterJSON.add(new FieldFilter('Description__c', 'Like', '\'%' + homeSerachFilterObj.Product_Description + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Category) && homeSerachFilterObj.Product_Category != '0') {
					filterJSON.add(new FieldFilter('Category__c', '=', '\'' + homeSerachFilterObj.Product_Category + '\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_Price.SelectedOption) && homeSerachFilterObj.Product_Price.SelectedOption != '0' && !String.isBlank(homeSerachFilterObj.Product_Price.Value1)) {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Product_Price, 'Price__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
			}
			
			// Labour Codes
			if(objName == 'Labor Codes'){
				if(!String.isBlank(homeSerachFilterObj.Product_Item)) {
					filterJSON.add(new FieldFilter('Code__c', 'Like', '\'%' + homeSerachFilterObj.Product_Item + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Description)){
					filterJSON.add(new FieldFilter('Description__c', 'Like', '\'%' + homeSerachFilterObj.Product_Description + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Category) && homeSerachFilterObj.Product_Category != '0') {
					filterJSON.add(new FieldFilter('Category__c', '=', '\'' + homeSerachFilterObj.Product_Category + '\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_Price.SelectedOption) && homeSerachFilterObj.Product_Price.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Product_Price, 'Rate__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
			}
			
			if(objName == 'Customer Orders') {
				if(homeSerachFilterObj.Customer_Sales_Id != null && homeSerachFilterObj.Customer_Sales_Id != ''){
					filterJSON.add(new FieldFilter('Invoice_Number__c', 'Like', '\'%' + homeSerachFilterObj.Customer_Sales_Id + '%\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Total.SelectedOption) && homeSerachFilterObj.Customer_Sales_Total.SelectedOption != '0'){
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Customer_Sales_Total, 'Total_Order_Value__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption) && homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption != '0'){
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Customer_Sales_Balance_Due, 'Total_Balance_Due__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Order_Payments.SelectedOption) && homeSerachFilterObj.Customer_Order_Payments.SelectedOption != '0'){
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Customer_Order_Payments, 'Total_Payment__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Order_Deposits.SelectedOption) && homeSerachFilterObj.Customer_Order_Deposits.SelectedOption != '0') {
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Customer_Order_Deposits, 'Total_Deposit__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Customer)) {
					filterJSON.add(new FieldFilter('Customer__r.Name', 'Like', '\'%' +homeSerachFilterObj.Customer_Sales_Customer + '%\''));
				}
			}
			
			if(objName == 'Customer Invoices') {
				if(homeSerachFilterObj.Customer_Sales_Id != null && homeSerachFilterObj.Customer_Sales_Id != ''){
					filterJSON.add(new FieldFilter('Invoice_Number__c', 'Like', '\'%' + homeSerachFilterObj.Customer_Sales_Id + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Customer)) {
					filterJSON.add(new FieldFilter('CO_Header__r.Customer__r.Name', 'Like', '\'%' + homeSerachFilterObj.Customer_Sales_Customer + '%\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Total.SelectedOption) && homeSerachFilterObj.Customer_Sales_Total.SelectedOption != '0'){
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Customer_Sales_Total, 'Total_Payment__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}

				if(!String.isBlank(homeSerachFilterObj.CO_Invoice_Header_Customer_Order)) {
					filterJSON.add(new FieldFilter('CO_Header__r.Name', 'Like', '\'%' + homeSerachFilterObj.CO_Invoice_Header_Customer_Order + '%\''));
				}
				 
				filterJSON.add(new FieldFilter('Status__c', '=', '\'Closed\''));
			}
			
			if(objName == 'Customer Payments') {
				if(homeSerachFilterObj.Customer_Sales_Id != null && homeSerachFilterObj.Customer_Sales_Id != ''){
					filterJSON.add(new FieldFilter('Invoice_Number__c', 'Like', '\'%' + homeSerachFilterObj.Customer_Sales_Id + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Customer)) {
					filterJSON.add(new FieldFilter('CO_Invoice_Header__r.CO_Header__r.Customer__r.Name', 'Like', '\'%' + homeSerachFilterObj.Customer_Sales_Customer + '%\''));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Total.SelectedOption) && homeSerachFilterObj.Customer_Sales_Total.SelectedOption != '0'){
					List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Customer_Sales_Total, 'Amount__c');
					if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
					}
				}
				if(!String.isBlank(homeSerachFilterObj.CO_Payment_Customer_Order)) {
					filterJSON.add(new FieldFilter('CO_Invoice_Header__r.CO_Header__r.Name', 'Like', '\'%' + homeSerachFilterObj.CO_Payment_Customer_Order + '%\''));
				}
				if(!String.isBlank(homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption) && homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption != '0') {
					filterJSON.add(new FieldFilter('Payment_Method__c', '=', '\'' + optionValueToPaymentMethodMap.get(homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption) + '\''));
				}
				
			}		
			
			if(objName == 'Vendor Ordering' || objName == 'Vendor Orders'|| objName == 'Vendor Receivings'|| objName == 'Vendor Invoices'){
				if(!String.isBlank(homeSerachFilterObj.Vendor_Invoicing_Header_Status) && homeSerachFilterObj.Vendor_Invoicing_Header_Status !=null ){
					//filterJSON.add(new FieldFilter('Name', '=', '\''+homeSerachFilterObj.Customer_Sales_Id));
				}
				if(!String.isBlank(homeSerachFilterObj.Vendor_Order_Purchase_Order) && homeSerachFilterObj.Vendor_Order_Purchase_Order !='0' ){
					filterJSON.add(new FieldFilter('Purchase_Order_Type__c', '=', '\''+homeSerachFilterObj.Vendor_Order_Purchase_Order + '\''));
				}
				/*if( homeSerachFilterObj.Vendor_Order_Total_Recieved != null ){
						//Need To add
				}*/
				if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Id)){	
					filterJSON.add(new FieldFilter('Name', 'LIKE', '\'' + homeSerachFilterObj.Vendor_Ordering_Id + '%\''));
				}
				/*if(homeSerachFilterObj.Vendor_Ordering_Total !=null ){
						//Need To add 
				}*/
				if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Vendor)){
					filterJSON.add(new FieldFilter('Vendor__r.Name', 'Like', '\'%'+ homeSerachFilterObj.Vendor_Ordering_Vendor + '%\''));
				}
				if(objName == 'Vendor Invoices'){
					if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption) && homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption != '0'){
						List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Vendor_Ordering_Total, 'Total__c');
						if(numericFilterList.size() > 0) {
							filterJSON.addAll(numericFilterList);
						}
					}
				}
				if(objName == 'Vendor Orders'){
					if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption) && homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption != '0'){
						List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Vendor_Ordering_Total, 'Total__c');
						if(numericFilterList.size() > 0) {
						filterJSON.addAll(numericFilterList);
						}
					}
					if(!String.isBlank(homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption) && homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption != '0'){
						List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Vendor_Order_Total_Recieved, 'Total_Recieved__c');
						if(numericFilterList.size() > 0) {
							filterJSON.addAll(numericFilterList);
						}
					}
				}
				if(objName == 'Vendor Receivings'){
					if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption) && homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption != '0'){
						List<FieldFilter> numericFilterList = getNumericFilter(homeSerachFilterObj.Vendor_Ordering_Total, 'Receiving_Total__c');
						if(numericFilterList.size() > 0) {
							filterJSON.addAll(numericFilterList);
						}
					}
				}
			}
					
			//For All Standards Objects
			if(homeSerachFilterObj.Owner.SelectedOption != null && homeSerachFilterObj.Owner.SelectedOption != '0') {
				FieldFilter ff = getOwnerFilter(homeSerachFilterObj.Owner, objName);
				if(ff != null) {
					filterJSON.add(ff);
				}
			}
			
			if(homeSerachFilterObj.ModifiedDate != null && homeSerachFilterObj.ModifiedDate.SelectedOption != '0') {
				List<FieldFilter> modifiedFilterJSON = getDateFilter(homeSerachFilterObj.ModifiedDate, 'LastModifiedDate');
				if(modifiedFilterJSON.size() > 0) {
					filterJSON.addAll(modifiedFilterJSON);
				}
			}
			
			if(homeSerachFilterObj.CreatedDate != null && homeSerachFilterObj.CreatedDate.SelectedOption != '0') {
				List<FieldFilter> createdFilterJSON = getDateFilter(homeSerachFilterObj.CreatedDate, 'CreatedDate');
				if(createdFilterJSON.size() > 0) {
					filterJSON.addAll(createdFilterJSON); 
				}
			}
			
			if(homeSerachFilterObj.Status != null && (!String.isBlank(homeSerachFilterObj.Status) && homeSerachFilterObj.Status !='0') ) {
				if(objName == 'Customer Payments') {
					filterJSON.add(new FieldFilter('CO_Invoice_Header__r.Status__c', '=', '\'' + homeSerachFilterObj.Status + '\''));
				} else {
					filterJSON.add(new FieldFilter('Status__c', '=', '\'' + homeSerachFilterObj.Status + '\''));
				}
			}
			objectFilterJSON.put(objName, filterJSON);
		}
		system.debug('********************'+objectFilterJSON);
		return objectFilterJSON;
	}
	
	/**
     * Name: getNumericFilter
     * Desc: Getting List of Field Filter according to parameter
     * @param:  (1) numericJSON - HomeSearchFilterWrapper.BetweenFilter - Between Filter Record
     *			(2) fieldName - String - Name of Field
     * @return: List<FieldFilter> - List of Field Filter Record
     **/
	private static List<FieldFilter> getNumericFilter(HomeSearchFilterWrapper.BetweenFilter numericJSON, String fieldName) {
		List<FieldFilter> numericFilterList = new List<FieldFilter>();
		
		if(numericJSON.SelectedOption == '0' || String.isBlank(numericJSON.Value1)) {
			return numericFilterList;
		} else if(numericJSON.SelectedOption == '1') {
			numericFilterList.add(new FieldFilter(fieldName, '=', Decimal.ValueOf(numericJSON.Value1)));
		} else if(numericJSON.SelectedOption == '2') {
			numericFilterList.add(new FieldFilter(fieldName, '!=', Decimal.ValueOf(numericJSON.Value1)));
		} else if(numericJSON.SelectedOption == '3') {
			numericFilterList.add(new FieldFilter(fieldName, '>', Decimal.ValueOf(numericJSON.Value1)));
		} else if(numericJSON.SelectedOption == '4') {
			numericFilterList.add(new FieldFilter(fieldName, '<', Decimal.ValueOf(numericJSON.Value1)));
		} else if(numericJSON.SelectedOption == '5' && !String.isBlank(numericJSON.Value2)) {
			numericFilterList.add(new FieldFilter(fieldName, '>=',  Decimal.ValueOf(numericJSON.Value1)));
			numericFilterList.add(new FieldFilter(fieldName, '<=',  Decimal.ValueOf(numericJSON.Value2)));
		}
		return numericFilterList;
	}
		
	/**
     * Name: getOwnerFilter
     * Desc: Getting FieldFilter according to parameter
     * @param:  (1) ownerJSON - HomeSearchFilterWrapper.OwnerFilter - Owner Filter JSON String 
     *			(2) objName - String - Object Name 
     * @return: FieldFilter - Field Filter Record
    **/	
	private static FieldFilter getOwnerFilter(HomeSearchFilterWrapper.OwnerFilter ownerJSON, String objName) {
		FieldFilter ownerFilter;
		
		String ownerFieldName = 'OwnerId';
		if(HomeSearchUtil.objectToOwnerObjectFieldName.containsKey(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName))) {
			String ownerFieldNameFromMap = HomeSearchUtil.objectToOwnerObjectFieldName.get(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName));
			ownerFieldName = (ownerFieldNameFromMap.endsWith('__c')) ? ownerFieldNameFromMap : (ownerFieldNameFromMap + '.' + ownerFieldName);
			ownerFieldName = ownerFieldName;
		}
		if(objName == 'Users') {
			ownerFieldName = 'CreatedById';
		}
		
		if(ownerJSON.SelectedOption == '1') {
			ownerFilter = new FieldFilter(ownerFieldName, '=', '\'' + UserInfo.getUserId() + '\'');
		} else if(ownerJSON.SelectedOption == '2'){
			ownerFilter = new FieldFilter(ownerFieldName, '!=', '\'' + UserInfo.getUserId() + '\'');
		} else if(ownerJSON.SelectedOption == '3'){
			if(ownerJSON.OwnerId != null) {
				ownerFilter = new FieldFilter(ownerFieldName, '=', '\'' + ownerJSON.OwnerId + '\'');
			}
		}
		return ownerFilter;
	}
	
	/**
     * Name: getStatusFilter
     * Desc: Getting Status of Filter  according to parameter
     * @param:  (1) statusStr - String - Status String 
     *			(2) objName - String - Object Name 
     * @return: FieldFilter - Field Filter Record
    **/	
	private static FieldFilter getStatusFilter(String statusStr, String objName) {
		FieldFilter filter;
		
		if(objName == 'Customers' || objName == 'Vendors' || objName == 'People') {
			statusStr = (statusStr == '1') ? 'true' : ((statusStr == '2') ? 'false' : 'ANY');
			if(statusStr != 'ANY') {
				filter = new FieldFilter('Active__c', '=', statusStr);
			}
		} else if(objName == 'Parts') {
			statusStr = (statusStr == '1') ? '> 0' : ((statusStr == '2') ? '< 0' : 'ANY');
			if(statusStr != 'ANY') {
				filter = new FieldFilter('AvailableParts__c', '', statusStr);
			}
		}
		
		return filter;
	}	
	
	/**
     * Name: getDateFilter
     * Desc: Getting Date Filter
     * @param:  (1) dateJSON - HomeSearchFilterWrapper.BetweenFilter - Between Filter Record
     *			(2) fieldName - String - Field Name 
     * @return: List<FieldFilter> - List Of Field Filter Record
    **/	
	private static List<FieldFilter> getDateFilter(HomeSearchFilterWrapper.BetweenFilter dateJSON, String fieldName) {
		List<FieldFilter> dateFilterList = new List<FieldFilter>();
		
		if(dateJSON.SelectedOption == '1') {
			dateFilterList.add(new FieldFilter(fieldName, '=', 'TODAY'));
		} else if(dateJSON.SelectedOption == '2') {
			dateFilterList.add(new FieldFilter(fieldName, '=', 'YESTERDAY'));
		} else if(dateJSON.SelectedOption == '3') {
			dateFilterList.add(new FieldFilter(fieldName, '=', 'LAST_N_DAYS:7'));
		} else if(dateJSON.SelectedOption == '4') {
			dateFilterList.add(new FieldFilter(fieldName, '=', 'LAST_N_DAYS:30'));
		} else if(dateJSON.SelectedOption == '5' && (dateJSON.Value1 != null && dateJSON.Value1.trim().length() != 0) && (dateJSON.Value2 != null && dateJSON.Value2.trim().length() != 0)) {
			system.debug('dateJSON.Value1   ' + dateJSON.Value1 +'\n\n' + getDateFromString(dateJSON.Value1));
			DateTime dtValue = getDateFromString(dateJSON.Value1);
			dateFilterList.add(new FieldFilter(fieldName, '>=', dtValue.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')));
			
			dtValue = getDateFromString(dateJSON.Value2);
			dtValue = dtValue.addDays(1);
			dateFilterList.add(new FieldFilter(fieldName, '<=', dtValue.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')));
		}
		return dateFilterList;
	}	

	
	 /**
     * Name: getDateFromString
     * Desc: Getting Date From Given String 
     * @param:  (1) dtStr - String  - Date String
     * @return: DateTime- DateTime Object
     **/	
	private static DateTime getDateFromString(String dtStr) {
		Integer day = Integer.valueOf(dtStr.split('/')[1]);
		Integer month = Integer.valueOf(dtStr.split('/')[0]);
		Integer year = Integer.valueOf(dtStr.split('/')[2]);
		
		return datetime.newInstance(year, month, day, 0, 0 , 0);
	}
	
	
	/**
     * Name: getFilterLabelList
     * Desc: Getting List Filter Label
     * @param:  (1) homeSerachFilterObj - HomeSearchFilterWrapper  -Home Search Filter Wrapper Record
     * @return: List<FilterLabel> - List Of Filter Label Record
     **/	
	public static List<FilterLabel> getFilterLabelList(HomeSearchFilterWrapper homeSerachFilterObj) {
		List<FilterLabel> filterLables = new List<FilterLabel>();
		if(homeSerachFilterObj.Type.Objects != null && homeSerachFilterObj.Type.Objects.size() > 0) {
			List<String> objectList = new List<String>();
			for(String objName : homeSerachFilterObj.Type.Objects) {
				if(objName != 'Any') {
					objectList.add(objName);
				}
			}
			if(objectList.size() == 1) {
				filterLables.add(new FilterLabel('Type', 'Type', objectList[0]));
			} else if(objectList.size() > 1) {
				String types = '';
				for(String typeStr : objectList) {
					types += typeStr + ', ';
				}
				types = types.subString(0, types.length() - 2);
				filterLables.add(new FilterLabel('Type', 'Type', types));
			}
		}
		
		if(!String.isBlank(homeSerachFilterObj.SearchText)) {
			filterLables.add(new FilterLabel('SearchText', 'Contains', homeSerachFilterObj.SearchText));
		}
		
		if(!String.isBlank(homeSerachFilterObj.Owner.SelectedOption) && homeSerachFilterObj.Owner.SelectedOption != '0') {
			String ownerLabelName = optionValueToOwnerKeyMap.containsKey(homeSerachFilterObj.Owner.SelectedOption) ? optionValueToOwnerKeyMap.get(homeSerachFilterObj.Owner.SelectedOption) : homeSerachFilterObj.Owner.SelectedOption;
			if(ownerLabelName == '3') {
				filterLables.add(new FilterLabel('Owner', 'Owner', homeSerachFilterObj.Owner.OwnerName));
			} else {
				filterLables.add(new FilterLabel('Owner', 'Owner', ownerLabelName));
			}
			
		}
		
		if(!String.isBlank(homeSerachFilterObj.Status) && homeSerachFilterObj.Status != '0') {
			String statusName = optionValueToStatusKeyMap.containsKey(homeSerachFilterObj.Status) ? optionValueToStatusKeyMap.get(homeSerachFilterObj.Status) : homeSerachFilterObj.Status;
			filterLables.add(new FilterLabel('Status', 'Status', statusName));
		}
		
		if(!String.isBlank(homeSerachFilterObj.ModifiedDate.SelectedOption) && homeSerachFilterObj.ModifiedDate.SelectedOption != '0') {
			String modifiedLabelName = optionValueToModifiedKeyMap.containsKey(homeSerachFilterObj.ModifiedDate.SelectedOption) ? optionValueToModifiedKeyMap.get(homeSerachFilterObj.ModifiedDate.SelectedOption) : homeSerachFilterObj.ModifiedDate.SelectedOption;
			if( modifiedLabelName == '5'  && !String.isBlank(HomeSerachFilterObj.ModifiedDate.Value1) && !String.isBlank(homeSerachFilterObj.ModifiedDate.Value2)) {
				filterLables.add(new FilterLabel('ModifiedDate', 'Modified', homeSerachFilterObj.ModifiedDate.Value1 + ' To ' + homeSerachFilterObj.ModifiedDate.Value2));
			} else {
				filterLables.add(new FilterLabel('ModifiedDate', 'Modified', modifiedLabelName));
			}
		}
		
		if(!String.isBlank(homeSerachFilterObj.CreatedDate.SelectedOption) && homeSerachFilterObj.CreatedDate.SelectedOption != '0') {
			String modifiedLabelName = optionValueToModifiedKeyMap.containsKey(homeSerachFilterObj.CreatedDate.SelectedOption) ? optionValueToModifiedKeyMap.get(homeSerachFilterObj.CreatedDate.SelectedOption) : homeSerachFilterObj.CreatedDate.SelectedOption;
			if(modifiedLabelName == '5') {
				filterLables.add(new FilterLabel('CreatedDate', 'Created', homeSerachFilterObj.CreatedDate.Value1 + ' To ' + homeSerachFilterObj.CreatedDate.Value2));
			} else {
				filterLables.add(new FilterLabel('CreatedDate', 'Created', modifiedLabelName));
			}
		}
		
		// Customers AND Vendors
		if(homeSerachFilterObj.Type.Objects.contains('People') ||homeSerachFilterObj.Type.Objects.contains('Customers')  || homeSerachFilterObj.Type.Objects.contains('Vendors') ){
			if(!String.isBlank(homeSerachFilterObj.People_BillingAddress)) {
				filterLables.add(new FilterLabel('People_BillingAddress', 'Billing Address', homeSerachFilterObj.People_BillingAddress));
			}
			if(!String.isBlank(homeSerachFilterObj.People_BillingCity)){
				filterLables.add(new FilterLabel('People_BillingCity', 'Billing City', homeSerachFilterObj.People_BillingCity));
			}
			if(!String.isBlank(homeSerachFilterObj.People_Country)){
				filterLables.add(new FilterLabel('People_Country', 'Billing Country', homeSerachFilterObj.People_Country));
			}
			if(!String.isBlank(homeSerachFilterObj.People_StateProv)){
				filterLables.add(new FilterLabel('People_StateProv', 'Billing State', homeSerachFilterObj.People_StateProv));
			}
			if(!String.isBlank(homeSerachFilterObj.People_Email)){
				filterLables.add(new FilterLabel('People_Email', 'Email', homeSerachFilterObj.People_Email));
			}
			if(!String.isBlank(homeSerachFilterObj.People_Id)) {
				filterLables.add(new FilterLabel('People_Id', 'Id', homeSerachFilterObj.People_Id));
			}
			if(!String.isBlank(homeSerachFilterObj.People_Name)){
				filterLables.add(new FilterLabel('People_Name', 'Name', homeSerachFilterObj.People_Name));
			}
			if(!String.isBlank(homeSerachFilterObj.People_Phone)){
				filterLables.add(new FilterLabel('People_Phone', 'Phone', homeSerachFilterObj.People_Phone));
			}
			if(!String.isBlank(homeSerachFilterObj.People_PriceLevel)  && homeSerachFilterObj.People_PriceLevel != '0'){
				if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
				List<Price_Level__c> pricelist= [select Name__c from Price_Level__c where Id =: homeSerachFilterObj.People_PriceLevel];
				filterLables.add(new FilterLabel('People_PriceLevel', 'Price level', pricelist[0].Name__c));
			}
			if(!String.isBlank(homeSerachFilterObj.People_SalesTax) && homeSerachFilterObj.People_SalesTax != '0'){
				if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
				List<Sales_Tax__c> saleslist= [select Name__c from Sales_Tax__c where Id =: homeSerachFilterObj.People_SalesTax];
				filterLables.add(new FilterLabel('People_SalesTax', 'Sales Tax', saleslist[0].Name__c));
			}
		}
			
			
		if(homeSerachFilterObj.Type.Objects.contains('Customer Orders') || homeSerachFilterObj.Type.Objects.contains('Customer Invoices') || homeSerachFilterObj.Type.Objects.contains('Customer Payments')){				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Customer)){
					filterLables.add(new FilterLabel('Customer_Sales_Customer', 'Customer', homeSerachFilterObj.Customer_Sales_Customer));
				}
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Id)){
					filterLables.add(new FilterLabel('Customer_Sales_Id', 'Id', homeSerachFilterObj.Customer_Sales_Id));
				}
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption) && homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption != '0' ){
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption) : homeSerachFilterObj.Customer_Sales_Balance_Due.SelectedOption;
					if(modifiedLabelName == '5') {
						filterLables.add(new FilterLabel('Customer_Sales_Balance_Due', 'Balance Due', homeSerachFilterObj.Customer_Sales_Balance_Due.Value1 + ' To ' + homeSerachFilterObj.Customer_Sales_Balance_Due.Value2));
					} else {
						filterLables.add(new FilterLabel('Customer_Sales_Balance_Due', 'Balance Due', modifiedLabelName + ' ' + homeSerachFilterObj.Customer_Sales_Balance_Due.Value1));
					}
				}
				if(!String.isBlank(homeSerachFilterObj.Customer_Order_Payments.SelectedOption) && homeSerachFilterObj.Customer_Order_Payments.SelectedOption != '0' ){
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Customer_Order_Payments.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Customer_Order_Payments.SelectedOption) : homeSerachFilterObj.Customer_Order_Payments.SelectedOption;
					if(modifiedLabelName == '5') {
						filterLables.add(new FilterLabel('Customer_Order_Payments', 'Payment', homeSerachFilterObj.Customer_Order_Payments.Value1 + ' To ' + homeSerachFilterObj.Customer_Order_Payments.Value2));
					} else {
						filterLables.add(new FilterLabel('Customer_Order_Payments', 'Payment', modifiedLabelName + ' ' + homeSerachFilterObj.Customer_Order_Payments.Value1));
					}
				}
				if(!String.isBlank(homeSerachFilterObj.Customer_Order_Deposits.SelectedOption) && homeSerachFilterObj.Customer_Order_Deposits.SelectedOption != '0' ){
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Customer_Order_Deposits.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Customer_Order_Deposits.SelectedOption) : homeSerachFilterObj.Customer_Order_Deposits.SelectedOption;
					if(modifiedLabelName == '5') {
						filterLables.add(new FilterLabel('Customer_Order_Deposits', 'Deposit', homeSerachFilterObj.Customer_Order_Deposits.Value1 + ' To ' + homeSerachFilterObj.Customer_Order_Deposits.Value2));
					} else {
						filterLables.add(new FilterLabel('Customer_Order_Deposits', 'Deposit', modifiedLabelName + ' ' + homeSerachFilterObj.Customer_Order_Deposits.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Customer_Sales_Total.SelectedOption) && homeSerachFilterObj.Customer_Sales_Total.SelectedOption != '0' ){
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Customer_Sales_Total.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Customer_Sales_Total.SelectedOption) : homeSerachFilterObj.Customer_Sales_Total.SelectedOption;
					if(modifiedLabelName == '5') {
						filterLables.add(new FilterLabel('Customer_Sales_Total', 'Total', homeSerachFilterObj.Customer_Sales_Total.Value1 + ' To ' + homeSerachFilterObj.Customer_Sales_Total.Value2));
					} else {
						filterLables.add(new FilterLabel('Customer_Sales_Total', 'Total', modifiedLabelName + ' ' + homeSerachFilterObj.Customer_Sales_Total.Value1));
					}
				}
				if(!String.isBlank( homeSerachFilterObj.CO_Invoice_Header_Customer_Order)){
						filterLables.add(new FilterLabel('CO_Invoice_Header_Customer_Order', 'Customer Order', homeSerachFilterObj.CO_Invoice_Header_Customer_Order));
				}
				
				if(!String.isBlank( homeSerachFilterObj.CO_Payment_Customer_Order)){
					filterLables.add(new FilterLabel('CO_Payment_Customer_Order', 'Customer Order', homeSerachFilterObj.CO_Payment_Customer_Order));
			}
		
				if(!String.isBlank(homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption) && homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption != '0' ){
					String paymentLabelName = optionValueToPaymentMethodMap.containsKey(homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption) ? optionValueToPaymentMethodMap.get(homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption) : homeSerachFilterObj.CO_Payment_Payment_Method.SelectedOption;
					filterLables.add(new FilterLabel('CO_Payment_Payment_Method', 'Payment Method', paymentLabelName));
				}
			}
		
			
			if(homeSerachFilterObj.Type.Objects.contains('Vendor Orders') || homeSerachFilterObj.Type.Objects.contains('Vendor Receivings')  || homeSerachFilterObj.Type.Objects.contains('Vendor Invoices') ){
					
				if(!String.isBlank(homeSerachFilterObj.Vendor_Invoicing_Header_Status)){
					filterLables.add(new FilterLabel('Vendor_Invoicing_Header_Status', 'Status', homeSerachFilterObj.Vendor_Invoicing_Header_Status));
				}
				if(!String.isBlank(homeSerachFilterObj.Vendor_Order_Purchase_Order) && homeSerachFilterObj.Vendor_Order_Purchase_Order != '0'){
					//filterJSON.add(new FieldFilter('Purchase_Order_Type__c', '=', homeSerachFilterObj.Vendor_Order_Purchase_Order));
					if(AccessControl.ifObjectFieldIsAccessible('PO_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
					List<PO_Type__c> PuchaseOrderList = [select Code__c from PO_Type__c where Id =: homeSerachFilterObj.Vendor_Order_Purchase_Order];
					if(PuchaseOrderList.size() > 0) {
						filterLables.add(new FilterLabel('Vendor_Order_Purchase_Order', 'Purchase Order', PuchaseOrderList[0].Code__c));
					} else {
						filterLables.add(new FilterLabel('Vendor_Order_Purchase_Order', 'Purchase Order', ''));
					}
				}
				if(!String.isBlank(homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption) && homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption != '0' ){
					
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption) : homeSerachFilterObj.Vendor_Order_Total_Recieved.SelectedOption;
					if(modifiedLabelName == '5') {
						filterLables.add(new FilterLabel('Vendor_Order_Total_Recieved', ' Receving Total', homeSerachFilterObj.Vendor_Order_Total_Recieved.Value1 + ' To ' + homeSerachFilterObj.Vendor_Order_Total_Recieved.Value2));
					} else {
						filterLables.add(new FilterLabel('Vendor_Order_Total_Recieved', ' Receving Total', modifiedLabelName + ' ' + homeSerachFilterObj.Vendor_Order_Total_Recieved.Value1));
					}
				}
				if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Id)){	
					filterLables.add(new FilterLabel('Vendor_Ordering_Id', 'ID', homeSerachFilterObj.Vendor_Ordering_Id));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption) && homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption != '0'){
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption) : homeSerachFilterObj.Vendor_Ordering_Total.SelectedOption;
					if(modifiedLabelName == '5') {
						filterLables.add(new FilterLabel('Vendor_Ordering_Total', 'Total', homeSerachFilterObj.Vendor_Ordering_Total.Value1 + ' To ' + homeSerachFilterObj.Vendor_Ordering_Total.Value2));
					} else {
						filterLables.add(new FilterLabel('Vendor_Ordering_Total', 'Total', modifiedLabelName + ' ' + homeSerachFilterObj.Vendor_Ordering_Total.Value1));
					}
					//system.Assert(false,filterLables);
				}
				
				if(!String.isBlank(homeSerachFilterObj.Vendor_Ordering_Vendor)){
					filterLables.add(new FilterLabel('Vendor_Ordering_Vendor', 'Vendor', homeSerachFilterObj.Vendor_Ordering_Vendor));
				}
			}
			
			if(homeSerachFilterObj.Type.Objects.contains('Parts') || homeSerachFilterObj.Type.Objects.contains('Kits') || homeSerachFilterObj.Type.Objects.contains('Labour Codes') || homeSerachFilterObj.Type.Objects.contains('Fees')){
				if(!String.isBlank(homeSerachFilterObj.Product_Item)) {
					filterLables.add(new FilterLabel('Product_Item', 'Item', homeSerachFilterObj.Product_Item));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Description)){
					filterLables.add(new FilterLabel('Product_Description', 'Description', homeSerachFilterObj.Product_Description));
				}
				if(!String.isBlank(homeSerachFilterObj.Product_Category) && homeSerachFilterObj.Product_Category != '0'){
					if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
					List<Category__c> categoryList = [select Name from Category__c where Id =: homeSerachFilterObj.Product_Category];
					filterLables.add(new FilterLabel('Product_Category', 'Category', categoryList[0].Name));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_Price.SelectedOption)&& homeSerachFilterObj.Product_Price.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Product_Price.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Product_Price.SelectedOption) : homeSerachFilterObj.Product_Price.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Product_Price.Value1) && !String.isBlank(homeSerachFilterObj.Product_Price.Value2)) {
						filterLables.add(new FilterLabel('Product_Price', 'Price', homeSerachFilterObj.Product_Price.Value1 + ' To ' + homeSerachFilterObj.Product_Price.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Product_Price.Value1)){
						filterLables.add(new FilterLabel('Product_Price', 'Price', modifiedLabelName + ' ' + homeSerachFilterObj.Product_Price.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Product_QtyAvailable.SelectedOption) && homeSerachFilterObj.Product_QtyAvailable.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Product_QtyAvailable.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Product_QtyAvailable.SelectedOption) : homeSerachFilterObj.Product_QtyAvailable.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Product_QtyAvailable.Value1) && !String.isBlank(homeSerachFilterObj.Product_QtyAvailable.Value2)) {
						filterLables.add(new FilterLabel('Product_QtyAvailable', 'Qty Available', homeSerachFilterObj.Product_QtyAvailable.Value1 + ' To ' + homeSerachFilterObj.Product_QtyAvailable.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Product_QtyAvailable.Value1)){
						filterLables.add(new FilterLabel('Product_QtyAvailable', 'Qty Available', modifiedLabelName + ' ' + homeSerachFilterObj.Product_QtyAvailable.Value1));
					}
				}
			}
			
			
			if(homeSerachFilterObj.Type.Objects.contains('Parts')) {
				if(!String.isBlank(homeSerachFilterObj.Part_Location)) {
					filterLables.add(new FilterLabel('Part_Location', 'Location', homeSerachFilterObj.Part_Location));
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_Cost.SelectedOption) && homeSerachFilterObj.Part_Cost.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_Cost.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_Cost.SelectedOption) : homeSerachFilterObj.Part_Cost.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_Cost.Value1) && !String.isBlank(homeSerachFilterObj.Part_Cost.Value2)) {
						filterLables.add(new FilterLabel('Part_Cost', 'Cost', homeSerachFilterObj.Part_Cost.Value1 + ' To ' + homeSerachFilterObj.Part_Cost.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Part_Cost.Value1)){
						filterLables.add(new FilterLabel('Part_Cost', 'Cost', modifiedLabelName + ' ' + homeSerachFilterObj.Part_Cost.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_AverageCost.SelectedOption) && homeSerachFilterObj.Part_AverageCost.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_AverageCost.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_AverageCost.SelectedOption) : homeSerachFilterObj.Part_AverageCost.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_AverageCost.Value1) && !String.isBlank(homeSerachFilterObj.Part_AverageCost.Value2)) {
						filterLables.add(new FilterLabel('Part_AverageCost', 'Average Cost', homeSerachFilterObj.Part_AverageCost.Value1 + ' To ' + homeSerachFilterObj.Part_AverageCost.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Part_AverageCost.Value1)){
						filterLables.add(new FilterLabel('Part_AverageCost', 'Average Cost', modifiedLabelName + ' ' + homeSerachFilterObj.Part_AverageCost.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_InStock.SelectedOption)&& homeSerachFilterObj.Part_InStock.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_InStock.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_InStock.SelectedOption) : homeSerachFilterObj.Part_InStock.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_InStock.Value1) && !String.isBlank(homeSerachFilterObj.Part_InStock.Value2)) {
						filterLables.add(new FilterLabel('Part_InStock', 'In Stock', homeSerachFilterObj.Part_InStock.Value1 + ' To ' + homeSerachFilterObj.Part_InStock.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Part_InStock.Value1)){
						filterLables.add(new FilterLabel('Part_InStock', 'In Stock', modifiedLabelName + ' ' + homeSerachFilterObj.Part_InStock.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_Committed.SelectedOption) && homeSerachFilterObj.Part_Committed.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_Committed.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_Committed.SelectedOption) : homeSerachFilterObj.Part_Committed.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_Committed.Value1) && !String.isBlank(homeSerachFilterObj.Part_Committed.Value2)) {
						filterLables.add(new FilterLabel('Part_Committed', 'Commited Qty', homeSerachFilterObj.Part_Committed.Value1 + ' To ' + homeSerachFilterObj.Part_Committed.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Part_Committed.Value1)){
						filterLables.add(new FilterLabel('Part_Committed', 'Commited Qty', modifiedLabelName + ' ' + homeSerachFilterObj.Part_Committed.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_OnOrder.SelectedOption) && homeSerachFilterObj.Part_OnOrder.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_OnOrder.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_OnOrder.SelectedOption) : homeSerachFilterObj.Part_OnOrder.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_Cost.Value1) && !String.isBlank(homeSerachFilterObj.Part_Cost.Value2)) {
						filterLables.add(new FilterLabel('Part_OnOrder', 'On Order', homeSerachFilterObj.Part_OnOrder.Value1 + ' To ' + homeSerachFilterObj.Part_OnOrder.Value2));
					} else if(!String.isBlank(homeSerachFilterObj.Part_OnOrder.Value1)){
						filterLables.add(new FilterLabel('Part_OnOrder', 'On Order', modifiedLabelName + ' ' + homeSerachFilterObj.Part_OnOrder.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_LastCounted.SelectedOption) && homeSerachFilterObj.Part_LastCounted.SelectedOption != '0') {
					String modifiedLabelName = optionValueToModifiedKeyMap.containsKey(homeSerachFilterObj.Part_LastCounted.SelectedOption) ? optionValueToModifiedKeyMap.get(homeSerachFilterObj.Part_LastCounted.SelectedOption) : homeSerachFilterObj.Part_LastCounted.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_LastCounted.Value1) && !String.isBlank(homeSerachFilterObj.Part_LastCounted.Value2)) {
						filterLables.add(new FilterLabel('Part_LastCounted', 'Last Count', homeSerachFilterObj.Part_LastCounted.Value1 + ' To ' + homeSerachFilterObj.Part_LastCounted.Value2));
					} else {
						filterLables.add(new FilterLabel('Part_LastCounted', 'Last Count', modifiedLabelName));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_LastSold.SelectedOption) && homeSerachFilterObj.Part_LastSold.SelectedOption != '0') {
					String modifiedLabelName = optionValueToModifiedKeyMap.containsKey(homeSerachFilterObj.Part_LastSold.SelectedOption) ? optionValueToModifiedKeyMap.get(homeSerachFilterObj.Part_LastSold.SelectedOption) : homeSerachFilterObj.Part_LastSold.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_LastSold.Value1) && !String.isBlank(homeSerachFilterObj.Part_LastSold.Value2)) {
						filterLables.add(new FilterLabel('Part_LastSold', 'Last Sold', homeSerachFilterObj.Part_LastSold.Value1 + ' To ' + homeSerachFilterObj.Part_LastSold.Value2));
					} else {
						filterLables.add(new FilterLabel('Part_LastSold', 'Last Sold', modifiedLabelName));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_LastStocked.SelectedOption) && homeSerachFilterObj.Part_LastStocked.SelectedOption != '0') {
					String modifiedLabelName = optionValueToModifiedKeyMap.containsKey(homeSerachFilterObj.Part_LastStocked.SelectedOption) ? optionValueToModifiedKeyMap.get(homeSerachFilterObj.Part_LastStocked.SelectedOption) : homeSerachFilterObj.Part_LastStocked.SelectedOption;
					system.debug('$$$$$$$$$$$$$'+ modifiedLabelName);
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_LastStocked.Value1) && !String.isBlank(homeSerachFilterObj.Part_LastStocked.Value2)) {
						filterLables.add(new FilterLabel('Part_LastStocked', 'Last Stock', homeSerachFilterObj.Part_LastStocked.Value1 + ' To ' + homeSerachFilterObj.Part_LastStocked.Value2));
					} else{
						filterLables.add(new FilterLabel('Part_LastStocked', 'Last Stock', modifiedLabelName));
					}
					  
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_ReorderAt.SelectedOption) && homeSerachFilterObj.Part_ReorderAt.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_ReorderAt.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_ReorderAt.SelectedOption) : homeSerachFilterObj.Part_ReorderAt.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_ReorderAt.Value1) && !String.isBlank(homeSerachFilterObj.Part_ReorderAt.Value2)) {
						filterLables.add(new FilterLabel('Part_ReorderAt', 'Reorder At', homeSerachFilterObj.Part_ReorderAt.Value1 + ' To ' + homeSerachFilterObj.Part_ReorderAt.Value2));
					} else {
						filterLables.add(new FilterLabel('Part_ReorderAt', 'Reorder At', modifiedLabelName + ' ' + homeSerachFilterObj.Part_ReorderAt.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_ReorderTo.SelectedOption) && homeSerachFilterObj.Part_ReorderTo.SelectedOption != '0') {
					String modifiedLabelName = optionValueToNumberValueLabelMap.containsKey(homeSerachFilterObj.Part_ReorderTo.SelectedOption) ? optionValueToNumberValueLabelMap.get(homeSerachFilterObj.Part_ReorderTo.SelectedOption) : homeSerachFilterObj.Part_ReorderTo.SelectedOption;
					if(modifiedLabelName == '5' && !String.isBlank(homeSerachFilterObj.Part_ReorderTo.Value1) && !String.isBlank(homeSerachFilterObj.Part_ReorderTo.Value2)) {
						filterLables.add(new FilterLabel('Part_ReorderTo', 'Reorder To', homeSerachFilterObj.Part_ReorderTo.Value1 + ' To ' + homeSerachFilterObj.Part_ReorderTo.Value2));
					} else{
						filterLables.add(new FilterLabel('Part_ReorderTo', 'Reorder To', modifiedLabelName + ' ' + homeSerachFilterObj.Part_ReorderTo.Value1));
					}
				}
				
				if(!String.isBlank(homeSerachFilterObj.Part_Vendor)) {
					filterLables.add(new FilterLabel('Part_Vendor', 'Vendor', homeSerachFilterObj.Part_Vendor));
				}   
				
				if(!String.isBlank(homeSerachFilterObj.Part_PackagedPart) && homeSerachFilterObj.Part_PackagedPart != '0') {
					if(homeSerachFilterObj.Part_PackagedPart == '1') {
						filterLables.add(new FilterLabel('Part_PackagedPart', 'Packaged Part', 'Yes'));
					} else if(homeSerachFilterObj.Part_PackagedPart == '2'){
						filterLables.add(new FilterLabel('Part_PackagedPart', 'Packaged Part', 'No'));
					}
				}
			}
			
			if(homeSerachFilterObj.Type.Objects.contains('Kits')) {
				if(homeSerachFilterObj.Kit_FixedPrice == '1') {
					filterLables.add(new FilterLabel('Kit_FixedPrice', 'Fixed Price', 'Yes'));
				} else if(homeSerachFilterObj.Kit_FixedPrice == '2'){
					filterLables.add(new FilterLabel('Kit_FixedPrice', 'Fixed Price', 'No'));
				}
				
				if(homeSerachFilterObj.Kit_ServiceKit == '1') {
					filterLables.add(new FilterLabel('Kit_ServiceKit', 'Service Part', 'Yes'));
				} else if(homeSerachFilterObj.Kit_ServiceKit == '2'){
					filterLables.add(new FilterLabel('Kit_ServiceKit', 'Service Part', 'No'));
				}
			}
			
		return filterLables;
	}
	
	
	public static Map<String, String> optionValueToStatusKeyMap = new Map<String, String>{ 	'0' => 'Any',
																							'1'	=> 'Active',
																							'2' => 'Inactive'
																						};
	
	public static Map<String, String> optionValueToOwnerKeyMap = new Map<String, String>{ 	'0' => 'Any',
																							'1'	=> 'Owned by me',
																							'2' => 'Not owned by me'
																						};
	
	public static Map<String, String> optionValueToModifiedKeyMap = new Map<String, String>{ 	'0' => 'Anytime',
																								'1'	=> 'Today',
																								'2' => 'Yesterday',
																								'3' => 'Last 7 days',
																								'4' => 'Last 30 days'
																						};
																						
	public static Map<String, String> optionValueToNumberValueLabelMap = new Map<String, String>{ 	'0' => 'Any',
																									'1'	=> 'Equal To',
																									'2' => 'Not Equal To',
																									'3' => 'Greater Than',
																									'4' => 'Less Than'
																								};																					
	
	public static Map<String, String> optionValueToPaymentMethodMap = new Map<String, String>{ 	'0' => 'Any',
																								'1' => 'Cash',
																								'2'	=> 'Debit',
																								'3' => 'Cheque',
																								'4' => 'Visa',
																								'5'	=> 'Mastercard',
																								'6' => 'Amex',
																								'7' => 'Gift Card',
																								'8'	=> 'Charge Account',
																								'9' => 'Use Deposit'																							};
	
	 /**
	 * Name: FieldFilter
	 * Description: Field Filter Wrapper Class
	 **/
	public class FieldFilter {
		
		public String FieldName;
		public String Operator;
		public Object FieldValue;
		
		 /**
	     * Name: FieldFilter
	     * Desc: Constructor
	     * @param:  (1) fieldName - String  - Field Name
	     *			(2) operator - String  - Operator String
	     *			(3) value - Object - Value Object
	     * @return:
	     **/
		public FieldFilter(String fieldName, String operator, Object value){
		 	this.FieldName = fieldName;
		 	this.Operator = operator;
		 	this.FieldValue = value;
		 }
	}
	
	
	 /**
	 * Name: FieldLabel
	 * Description: Field Label Wrapper Class
	 **/
	public class FilterLabel {
		
		public String Key;
		public String Label;
		public String Value;
		
		/**
	     * Name: FilterLabel
	     * Desc: Constructor
	     * @param:  (1) key - String  - Key String
	     *			(2) label - String  - Operator String
	     *			(3) value - String - Value String
	     * @return:
	     **/
		public FilterLabel(String key, String label, String value) {
			this.Key = key;
			this.Label = label;
			this.Value = value;
		}
	}
}