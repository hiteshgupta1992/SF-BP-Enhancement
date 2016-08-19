/**
 * Author: Tarun Khandelwal
 * Since: March 10, 2016
 * Name: HomeSearchResultWrapper
 * Description: Apex class which gives JSON format for searched result
**/
public with sharing class HomeSearchResultWrapper {
	public static ResultWrapper result;
	
	/**
	 * Name: getJSONForSObjectRecords 
	 * Description: Method used to get search records JSON String
	 * @param: 1. List<sObject> records : Searched Sobject record 
	 * 		   2. String objName : Searched Object Name
	 *         3. Integer totalRecordsFound : Count of searched Records
	 *         4. List<HomeSearchFilterInterface.FilterLabel> filterLabelList - List of filter labels applied on UI.
	 * @return: String
	 */
	public static String getJSONForSObjectRecords(List<sObject> records, String objName, Integer totalRecordsFound, List<HomeSearchFilterInterface.FilterLabel> filterLabelList) {
		return getJSONForSObjectRecords(records, objName, totalRecordsFound, filterLabelList, true);
	}
	
	/**
	 * Name: getJSONForSObjectRecords 
	 * Description: Method used to get search records JSON String
	 * @param: 1. List<sObject> records : Searched Sobject record 
	 * 		   2. String objName : Searched Object Name
	 *         3. Integer totalRecordsFound : Count of searched Records
	 *         4. List<HomeSearchFilterInterface.FilterLabel> filterLabelList - List of filter labels applied on UI.
	 * @return: String
	 */
	public static String getJSONForSObjectRecords(	List<sObject> records, 
													String objName, 
													Integer totalRecordsFound, 
													List<HomeSearchFilterInterface.FilterLabel> filterLabelList,
													boolean ifToSerialzeResult
												) {
		//system.assert(false, totalRecordsFound);
		if(objName == 'Customers') {
			List<Customer> customerRecords = new List<Customer>();
			for(Account acc : (List<Account>)records) {
				customerRecords.add(new Customer(acc));
			}
			result = new ResultWrapper(totalRecordsFound, 'CustomerRecords');
			result.CustomerRecords = customerRecords;
			
		} else if(objName == 'Vendors') {
			List<Vendor> vendorRecords = new List<Vendor>();
			for(Account acc : (List<Account>)records){
				vendorRecords.add(new Vendor(acc));
			}
			result = new ResultWrapper(totalRecordsFound, 'VendorRecords');
			result.VendorRecords = vendorRecords;
		
		} else if(objName == 'People') {
			List<People> peopleRecords = new List<People>();
			for(Account acc : (List<Account>)records){
				peopleRecords.add(new People(acc));
			}
			result = new ResultWrapper(totalRecordsFound, 'PeopleRecords');
			result.PeopleRecords = peopleRecords;
			
		} else if(objName == 'Parts') {
			List<Part> partRecords = new List<Part>();
			for(Part__c partRec : (List<Part__c>)records) {
				partRecords.add(new Part(partRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'PartRecords');
			result.PartRecords = partRecords;
			
		} else if(objName == 'Kits') {
			List<KitHeader> kitRecords = new List<KitHeader>();
			for(Kit_Header__c kitHeaderRec : (List<Kit_Header__c>)records) {
				kitRecords.add(new KitHeader(kitHeaderRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'KitRecords');
			result.KitRecords = kitRecords;
			
		} else if(objName == 'Fees') {
			List<Fee> feeRecords = new List<Fee>();
			for(Fee__c feeRec : (List<Fee__c>)records) {
				feeRecords.add(new Fee(feeRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'FeeRecords');
			result.FeeRecords = feeRecords;
			
		} else if(objName == 'Labor Codes') {
			List<LabourCode> labourRecords = new List<LabourCode>();
			for(Labour_Code__c labourRec : (List<Labour_Code__c>)records) {
				labourRecords.add(new LabourCode(labourRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'LabourRecords');
			result.LabourRecords = labourRecords;
		
		} else if(objName == 'Sublets') {
			List<VendorProduct> vendorProductRecords = new List<VendorProduct>();
			for(Product__c subletRec : (List<Product__c>)records) {
				vendorProductRecords.add(new VendorProduct(subletRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'SubletRecords');
			result.SubletRecords = vendorProductRecords;
			
		} else if(objName == 'Products') {
			List<Product> productRecords = new List<Product>();
			for(Sobject sobjRec : records) {
				productRecords.add(new Product(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'ProductRecords');
			result.ProductRecords = productRecords;
			
		} else if(objName == 'Customer Orders') {
			List<CustomerOrders> customerOrdersRecords = new List<CustomerOrders>();
			for(CO_Header__c coHeaderRec : (List<CO_Header__c>)records) {
				customerOrdersRecords.add(new CustomerOrders(coHeaderRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'CustomerOrderRecords');
			result.CustomerOrderRecords = customerOrdersRecords;
			
		} else if(objName == 'Customer Invoices') {
			List<CustomerInvoice> customerInvoiceRecords = new List<CustomerInvoice>();
			for(CO_Invoice_Header__c coInvoiceHeaderRec : (List<CO_Invoice_Header__c>)records) {
				customerInvoiceRecords.add(new CustomerInvoice(coInvoiceHeaderRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'CustomerInvoiceRecords');
			result.CustomerInvoiceRecords = customerInvoiceRecords;
			
		} else if(objName == 'Customer Payments') {
			List<CustomerPayment> customerPaymentRecords = new List<CustomerPayment>();
			for(CO_Invoice_Payment__c coPaymentRec : (List<CO_Invoice_Payment__c>)records) {
				customerPaymentRecords.add(new CustomerPayment(coPaymentRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'CustomerPaymentRecords');
			result.CustomerPaymentRecords = customerPaymentRecords;
			
		} else if(objName == 'Customer Sales') {
			List<CustomerSales> customerSalesRecords = new List<CustomerSales>();
			for(Sobject sobjRec : records) {
				customerSalesRecords.add(new CustomerSales(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'CustomerSalesRecords');
			result.CustomerSalesRecords = customerSalesRecords;
			
        } else if(objName == 'Vendor Orders') {
			List<VendorOrder> vendorOrderRecords = new List<VendorOrder>();
			for(Vendor_Order_Header__c vendorOrderRec : (List<Vendor_Order_Header__c>)records) {
				vendorOrderRecords.add(new VendorOrder(vendorOrderRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'VendorOrderRecords');
			result.VendorOrderRecords = vendorOrderRecords;
			
		} else if(objName == 'Vendor Invoices') {
			List<VendorInvoice> vendorInvoiceRecords = new List<VendorInvoice>();
			for(Vendor_Invoicing_Header__c vendorInvoiceRec : (List<Vendor_Invoicing_Header__c>)records) {
				vendorInvoiceRecords.add(new VendorInvoice(vendorInvoiceRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'VendorInvoiceRecords');
			result.VendorInvoiceRecords = vendorInvoiceRecords;
			
		} else if(objName == 'Vendor Receivings') {
			List<VendorRecieving> vendorRecievingRecords = new List<VendorRecieving>();
			for(Vendor_Receiving_Header__c vendorRecievingRec : (List<Vendor_Receiving_Header__c>)records) {
				vendorRecievingRecords.add(new VendorRecieving(vendorRecievingRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'VendorRecievingRecords');
			result.VendorRecievingRecords = vendorRecievingRecords;
			
		} else if(objName == 'Vendor Ordering') {
			List<VendorOrdering> vendorOrderingRecords = new List<VendorOrdering>();
			for(Sobject sobjRec : records) {
				vendorOrderingRecords.add(new VendorOrdering(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'VendorOrderingRecords');
			result.VendorOrderingRecords = vendorOrderingRecords;

		} else if(objName == 'Item Categories') {
			List<Category> CategoryRecords = new List<Category>();
			for(Category__c sobjRec : (List<Category__c>)records) {
				CategoryRecords.add(new Category(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'CategoryRecords');
			result.CategoryRecords = CategoryRecords;

		} else if(objName == 'Price Levels') {
			List<PriceLevel> PriceLevelRecords = new List<PriceLevel>();
			for(Price_Level__c sobjRec : (List<Price_Level__c>)records) {
				PriceLevelRecords.add(new PriceLevel(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'PriceLevelRecords');
			result.PriceLevelRecords = PriceLevelRecords;

		} else if(objName == 'Sales Taxes') {
			List<SalesTax> SalesTaxRecords = new List<SalesTax>();
			for(Sales_Tax__c sobjRec : (List<Sales_Tax__c>)records) {
				SalesTaxRecords.add(new SalesTax(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'SalesTaxRecords');
			result.SalesTaxRecords = SalesTaxRecords;

		} else if(objName == 'Setting') {
			List<Setting> SettingRecords = new List<Setting>();
			for(Sobject sobjRec : records) {
				SettingRecords.add(new Setting(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'SettingRecords');
			result.SettingRecords = SettingRecords;

		} else if(objName == 'Users') {
			List<UserRec> UserRecords = new List<UserRec>();
			for(User userRecord : (List<User>)records) {
				UserRecords.add(new UserRec(userRecord));
			}
			result = new ResultWrapper(totalRecordsFound, 'UserRecords');
			result.UserRecords = UserRecords;

		} else if(objName == Label.Generic_Object_Label) {
			List<AnyObject> anyObjectRecords = new List<AnyObject>();
			for(Sobject sobjRec : records) {
				anyObjectRecords.add(new AnyObject(sobjRec));
			}
			result = new ResultWrapper(totalRecordsFound, 'AnyObjectRecords');
			result.AnyObjectRecords = anyObjectRecords;
		} else {
			result = new ResultWrapper(0, 'NoMatchedRecords');
		}
		
		
		result.FilterLabelList = filterLabelList;
		
		if(ifToSerialzeResult) {
			return System.Json.serialize(result);
		}
		return '';
	}
	
	/**
     * Name: ResultWrapper
     * Desc: RESULT records wrapper class used to get records in json format
    **/
    public class ResultWrapper {
    	
    	
    	public Integer Total_Records {get; private set;}
    	public String RecordsVariableName {get; private set;}
    	public List<HomeSearchFilterInterface.FilterLabel> FilterLabelList {get; set;}
    	
    	// People
    	public List<Customer> CustomerRecords {get; set;}
    	public List<Vendor> VendorRecords {get; set;}
    	public List<People> PeopleRecords {get; set;}
    	
    	// Products
    	public List<Part> PartRecords {get; set;}
    	public List<LabourCode> LabourRecords {get; set;}
    	public List<Fee> FeeRecords {get; set;}
    	public List<KitHeader> KitRecords {get; set;}
    	public List<Product> ProductRecords {get; set;}
    	public List<VendorProduct> SubletRecords {get; set;}
    	
    	// Customer Sales
        public List<CustomerSales> CustomerSalesRecords {get; set;}
    	public List<CustomerOrders> CustomerOrderRecords {get; set;}
    	public List<CustomerInvoice> CustomerInvoiceRecords {get; set;}
    	public List<CustomerPayment> CustomerPaymentRecords {get; set;}
    	
    	// Vendor Orders
    	public List<VendorOrder> VendorOrderRecords {get; set;}
    	public List<VendorInvoice> VendorInvoiceRecords {get; set;}
    	public List<VendorRecieving> VendorRecievingRecords {get; set;}
        public List<VendorOrdering> VendorOrderingRecords {get; set;}
        
        // Setting
        public List<Category> CategoryRecords {get; set;}
    	public List<PriceLevel> PriceLevelRecords {get; set;}
    	public List<salesTax> SalesTaxRecords {get; set;}
        public List<Setting> SettingRecords {get; set;}
        
        // User
        public List<UserRec> UserRecords {get; set;}
    	
        // Any Object(Generic Type)
    	public List<AnyObject> AnyObjectRecords {get; set;}
    	
    	public ResultWrapper(Integer Total_Records, String RecordsVariableName){
    		this.Total_Records = Total_Records;
    		this.RecordsVariableName = RecordsVariableName;
    	}
    }
	
    /**
	 * Name: Customer
	 * Description: Sets the value of customer 
	 * 
	**/
	public class Customer {
		public Integer Type {get; private set;}
		public String Customer_Number {get; private set;}
		public String Customer_Name {get; private set;}
		public String Phone_Number {get; private set;}
		public String Email {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Status {get; private set;}
		public String Id {get; private set;}
		
		public String First_Name {get; private set;}
		public String Last_Name {get; private set;}
		public String Nickname {get; private set;}
		public String Birth_Date {get; private set;}
		public String VIP_Number {get; private set;} 
		public String Job_Title {get; private set;}
		
		public String Billing_Address {get; private set;}
		public String Billing_City {get; private set;}
		public String Billing_State {get; private set;}
		public String Shipping_Address {get; private set;}
		public String Shipping_City {get; private set;}
		public String Shipping_State {get; private set;}
		
		public String Home_Number {get; private set;}
		public String Mobile_Number {get; private set;}
		public String Other_Email {get; private set;}
		public String Work_Email {get; private set;}
		public String Work_Number {get; private set;}
		
		public String Facebook {get; private set;}
		public String LinkedIn {get; private set;}
		public String Twitter {get; private set;}
		public String Website {get; private set;}
		public String Sales_Tax {get; private set;}
		public String Price_Level {get; private set;}
		
		public Decimal Open_Orders {get; private set;}
		public Decimal Orders_Lifetime {get; private set;} 
		public Decimal Average_Spend_per_Order {get; private set;}
		public String Created {get; private set;}
		public String Parent_Account {get; private set;}
		
		public Customer(Account acc) {
			this.Id = acc.Id;
			this.Customer_Number = acc.Customer_Number__c;
			this.Customer_Name = acc.Name;
			this.Phone_Number = acc.Preferred_Phone__c;
			this.Email = acc.Email__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customers');
			this.Modified = (acc.LastModifiedDate != null) ? acc.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Owner = (acc.Owner.Name != null) ? acc.Owner.Name : null;
			this.Status = acc.Status__c;
			
			
			this.First_Name = acc.FirstName__c;
			this.Last_Name =  acc.LastName__c;
			this.Nickname = acc.Nickname__c;
			
			
			
			this.Birth_Date = (acc.Birth_Date__c != null) ? (datetime.newInstance(acc.Birth_Date__c.year(), acc.Birth_Date__c.month(), acc.Birth_Date__c.day())).format('MM/dd/yyyy') : null;
			this.VIP_Number = acc.VIP__c;
			this.Job_Title = acc.Job_Title__c;
			
			this.Billing_Address = acc.BillingStreet;
			this.Billing_City = acc.BillingCity;
			this.Billing_State = acc.BillingState;
			this.Shipping_Address = acc.ShippingStreet;
			this.Shipping_City = acc.ShippingCity;
			this.Shipping_State = acc.ShippingState;
			
			this.Home_Number = acc.Home_Number__c;
			this.Mobile_Number = acc.Mobile__c;
			this.Other_Email = acc.Other_Email__c;
			this.Work_Email = acc.Work_Email__c;
			this.Work_Number = acc.Work_Number__c;
			
			this.Facebook = acc.Facebook__c;
			this.LinkedIn = acc.LinkedIn__c;
			this.Twitter = acc.Twitter__c;
			this.Website = acc.Website;
			this.Sales_Tax = (acc.Sales_Tax__c != null) ? acc.Sales_Tax__r.Name__c : null;
			this.Price_Level = (acc.Price_Level__c != null) ? acc.Price_Level__r.Name__c : null;
			
			this.Open_Orders = acc.Open_Orders__c;
			this.Orders_Lifetime = acc.Orders_Lifetime__c;
			this.Average_Spend_per_Order = acc.Average_Spend_per_Order__c;
			this.Created = (acc.CreatedDate != null) ? acc.CreatedDate.format('MM/dd/yyyy') : null;
			this.Parent_Account = '';  //
		}
	}
	
	/**
	 * Name: Vendor
	 * Description: Sets the value of vendor
	**/
	
	public class Vendor {
		public Integer Type {get; private set;}
		public String Vendor_Code {get; private set;}
		public String Vendor_Name {get; private set;}
		public String Phone_Number {get; private set;}
		public String Email {get; private set;}
		public String Modified {get; private set;}
		public String Owner {get; private set;}
		public String Status {get; private set;}
		public String Id {get; private set;}
		
		public String Billing_Address {get; private set;}
		public String Billing_City {get; private set;}
		public String Billing_State {get; private set;}
		public String Shipping_Address {get; private set;}
		public String Shipping_City {get; private set;}
		public String Shipping_State {get; private set;}
		
		
		public String Mobile_Number {get; private set;}
		public String Other_Email {get; private set;}
		public String Work_Email {get; private set;}
		public String Work_Number {get; private set;}
		
		public String Facebook {get; private set;}
		public String LinkedIn {get; private set;}
		public String Twitter {get; private set;}
		public String Website {get; private set;}
		public String Sales_Tax {get; private set;}
		public String Price_Level {get; private set;}
		
		public Decimal Open_Orders {get; private set;}
		public Decimal Orders_Lifetime {get; private set;} 
		public Decimal Average_Spend_per_Order {get; private set;}
		public String Created {get; private set;}
		public String Parent_Account {get; private set;}
		
		
		public String Last_Order {get; private set;}
		public String Purchase_Tax {get; private set;}
		public String Vendor_Account_Number {get; private set;}
		public String Part_Category_Default {get; private set;}
		public String Unit_Category_Default {get; private set;}
		public Boolean Claims_for_Service_Work {get; private set;}
		public Boolean Flooring_Company  {get; private set;}
		public Boolean Part_Purchases {get; private set;}
		public Boolean Sublet_Purchases {get; private set;}
		public Boolean Unit_Purchases {get; private set;}
		public Boolean Warranty_Plan_Sales_on_Unit_Deals {get; private set;}
		
	
		
		public Vendor(Account acc) {
			this.Id = acc.Id;
			this.Vendor_Code = acc.Vendor_Code__c;
			this.Vendor_Name = acc.Name;
			this.Phone_Number = acc.Preferred_Phone__c;
			this.Email = acc.Email__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendors');
			this.Modified = (acc.LastModifiedDate != null) ? acc.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Owner = (acc.Owner.Name != null) ? acc.Owner.Name : null;
			this.Status = acc.Status__c;
			
			this.Billing_Address = acc.BillingStreet;
			this.Billing_City = acc.BillingCity;
			this.Billing_State = acc.BillingState;
			this.Shipping_Address = acc.ShippingStreet;
			this.Shipping_City = acc.ShippingCity;
			this.Shipping_State = acc.ShippingState;
			
			this.Mobile_Number = acc.Mobile__c;
			this.Other_Email = acc.Other_Email__c;
			this.Work_Email = acc.Work_Email__c;
			this.Work_Number = acc.Work_Number__c;
			
			this.Facebook = acc.Facebook__c;
			this.LinkedIn = acc.LinkedIn__c;
			this.Twitter = acc.Twitter__c;
			this.Website = acc.Website;
			this.Sales_Tax = (acc.Sales_Tax__c != null) ? acc.Sales_Tax__r.Name__c : null;
			this.Price_Level = (acc.Price_Level__c != null) ? acc.Price_Level__r.Name__c : null;
			
			this.Open_Orders = acc.Open_Orders__c;
			this.Orders_Lifetime = acc.Orders_Lifetime__c;
			this.Average_Spend_per_Order = acc.Average_Spend_per_Order__c;
			this.Created = (acc.CreatedDate != null) ? acc.CreatedDate.format('MM/dd/yyyy') : null;
			this.Parent_Account = '';  //
			
			this.Last_Order = acc.Last_Visit_Order__c;
			this.Purchase_Tax = (acc.Purchase_Tax__c != null) ? acc.Purchase_Tax__r.Name__c : null;
			//this.Vendor_Account_Number = 
			this.Part_Category_Default = (acc.Part_Category_Default__c != null) ? acc.Part_Category_Default__r.Name : null;
			this.Unit_Category_Default = (acc.Unit_Category_Default__c != null) ? acc.Unit_Category_Default__r.Name : null;
			this.Claims_for_Service_Work = acc.Claims_for_Service_Work__c;
			this.Flooring_Company = acc.Flooring_Company__c;
			this.Part_Purchases = acc.Part_Purchases__c;
			this.Sublet_Purchases = acc.Sublet_Purchases__c;
			this.Unit_Purchases = acc.Unit_Purchases__c;
			this.Warranty_Plan_Sales_on_Unit_Deals = acc.Warranty_Plan_Sales_on_Unit_Deals__c;
		}
	}
	
	/**
	 * Name: People
	 * Description: Sets the value of the People 
	**/
	public class People {
		public Integer Type {get; private set;}
		public String Id_Number {get; private set;}
		public String Name {get; private set;}
		public String Phone_Number {get; private set;}
		public String Email {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Status {get; private set;}
		
		public String Billing_Address {get; private set;}
		public String Billing_City {get; private set;}
		public String Billing_State {get; private set;}
		public String Shipping_Address {get; private set;}
		public String Shipping_City {get; private set;}
		public String Shipping_State {get; private set;}
		
		public String Mobile_Number {get; private set;}
		public String Other_Email {get; private set;}
		public String Work_Email {get; private set;}
		public String Work_Number {get; private set;}
		
		public String Facebook {get; private set;}
		public String LinkedIn {get; private set;}
		public String Twitter {get; private set;}
		public String Website {get; private set;}
		public String Sales_Tax {get; private set;}
		public String Price_Level {get; private set;}
		
		public Decimal Open_Orders {get; private set;}
		public String Created {get; private set;}
		public String Parent_Account {get; private set;}
		public String Id {get; private set;}
		
		public People(Account acc) {
			this.Id = acc.Id;
			this.Name = acc.Name;
			this.Phone_Number = acc.Preferred_Phone__c;
			this.Email = acc.Email__c;
			this.Billing_Address = acc.BillingStreet;
			this.Billing_City = acc.BillingCity;
			this.Billing_State = acc.BillingState;
			
			if(acc.Is_Customer__c) {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customers');
				this.Id_Number = acc.Customer_Number__c;
			} else {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendors');
				this.Id_Number = acc.Vendor_Code__c;
			}
			this.Modified = (acc.LastModifiedDate != null) ? acc.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Owner = (acc.Owner.Name != null) ? acc.Owner.Name : null;
			this.Status = acc.Status__c;
			
			this.Shipping_Address = acc.ShippingStreet;
			this.Shipping_City = acc.ShippingCity;
			this.Shipping_State = acc.ShippingState;
			
			this.Mobile_Number = acc.Mobile__c;
			this.Other_Email = acc.Other_Email__c;
			this.Work_Email = acc.Work_Email__c;
			this.Work_Number = acc.Work_Number__c;
			
			this.Facebook = acc.Facebook__c;
			this.LinkedIn = acc.LinkedIn__c;
			this.Twitter = acc.Twitter__c;
			this.Website = acc.Website;
			this.Sales_Tax = (acc.Sales_Tax__c != null) ? acc.Sales_Tax__r.Name__c : null;
			this.Price_Level = (acc.Price_Level__c != null) ? acc.Price_Level__r.Name__c : null;
			
			this.Open_Orders = acc.Open_Orders__c;
			this.Created = (acc.CreatedDate != null) ? acc.CreatedDate.format('MM/dd/yyyy') : null;
			this.Parent_Account = '';  // 
		}
	}
	
	/**
	 * Name: Part
	 * Description: Sets the value of the Parts
	**/
	public class Part {
		public Integer Type {get; private set;}
		public String Part_Number {get; private set;}
		public String Description {get; private set;}
		public String Category {get; private set;}
		public Decimal Retail {get; private set;}
		public Decimal Qty_Available {get; private set;}
		public String Modified {get; private set;}
		public String Status {get; private set;}
		public String Vendor {get; private set;}
		public Decimal Cost {get; private set;}
		public String Location {get; private set;}
		public String Id {get; private set;}
		
		public Decimal Qty_In_Stock {get; private set;}
		public Decimal Qty_Committed {get; private set;} 
		public Decimal Qty_On_Order {get; private set;}
		public Decimal MSRP {get; private set;}
		public Decimal Enviro_Fee {get; private set;}
		public Decimal Average_Cost {get; private set;}
		public Decimal Package_Cost {get; private set;}
		public Decimal Package_Qty {get; private set;}
		public String Package_Unit {get; private set;}
		public String Last_Counted {get; private set;}
		public String Last_Sold {get; private set;}
		public String Last_Stocked {get; private set;}
		public Decimal Reorder_At {get; private set;}
		public Decimal Reorder_To {get; private set;}
		public Decimal Order_Lots {get; private set;}
		public String Replaced_By {get; private set;}
		
		public Part(Part__c partRec) {
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Parts');
			this.Part_Number = partRec.Part_Number__c;
			this.Description = partRec.Description__c;
			this.Qty_Available = partRec.AvailableParts__c;
			this.Retail = partRec.Retail_Price__c;
			this.Location = partRec.Location__c;
			this.Category = partRec.Category__r.Name;
			this.Status = partRec.Status__c;
			this.Modified = (partRec.LastModifiedDate != null) ? partRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Vendor = (partRec.Vendor__c != null) ? partRec.Vendor__r.Vendor_Code__c : null;
			this.Cost = (partRec.Last_Cost__c != null) ? partRec.Last_Cost__c : null;
			this.Status = partRec.Status__c;
			this.Id = partRec.Id;
			
			this.Qty_In_Stock = partRec.Qty_In_Stock__c;
			this.Qty_Committed = partRec.Qty_Committed__c;
			this.Qty_On_Order = partRec.Qty_On_Order__c;
			this.MSRP = partRec.MSRP__c;
			this.Enviro_Fee = partRec.Enviro_Fee__c;
			this.Average_Cost = partRec.Average_Cost__c;
			this.Package_Cost =  partRec.Package_Cost__c;
			this.Package_Qty = partRec.Package_Qty__c;
			this.Package_Unit = partRec.Package_Unit__c;
			this.Last_Counted = (partRec.Last_Counted__c != null) ? partRec.Last_Counted__c.format('MM/dd/yyyy') : null;
			this.Last_Sold = (partRec.Last_Sold__c != null) ? partRec.Last_Sold__c.format('MM/dd/yyyy') : null;
			this.Last_Stocked = (partRec.Last_Stocked__c != null) ? partRec.Last_Stocked__c.format('MM/dd/yyyy') : null;
			this.Reorder_At = partRec.Auto_reorder_Min__c;
			this.ReOrder_To = partRec.Auto_reorder_Max__c;
			this.Order_Lots =  partRec.Order_Lots__c;
			this.Replaced_By = (partRec.Superseded_By__c != null) ? partRec.Superseded_By__r.Part_Number__c : null;
		}
	}
	
	/**
	 * Name: KitHeader
	 * Description:  Sets the value of the Kit
	**/
	public class KitHeader {
		public String Id {get; private set;}
		public String Code {get; private set;}
		public Integer Type {get; private set;}
		public String Description {get; private set;}
		public Decimal Qty_Available {get; private set;}
		public Decimal Price {get; private set;}
		public String Status {get; private set;}
		public String Modified {get; private set;}
		
		public KitHeader(Kit_Header__c kitHeaderRec) {
			this.Id = kitHeaderRec.Id;
			this.Code = kitHeaderRec.Code__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Kits');
			this.Description = kitHeaderRec.Kit_Unique_Name__c;
			this.Price = kitHeaderRec.Fixed_Price__c;
			this.Qty_Available = 1;
			this.Modified = (kitHeaderRec.LastModifiedDate != null) ? kitHeaderRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Status = kitHeaderRec.Status__c;
		}
	}
	
	
	/**
	 * Name: Fee
	 * Description: Sets the value of the Kit
	**/
	public class Fee {
		public String Id {get; private set;}
		public String Code {get; private set;}
		public Integer Type {get; private set;}
		public String Description {get; private set;}
		public String Category {get; private set;}
		public Decimal Price {get; private set;}
		public String Status {get; private set;}
		public String Modified {get; private set;}
		
		public Fee(Fee__c feeRec) {
			this.Id = feeRec.Id;
			this.Code = feeRec.Code__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Fees');
			this.Description = feeRec.Fee_Unique_Name__c;
			this.Category = (feeRec.Category__c != null && feeRec.Category__r.Name != null) ? feeRec.Category__r.Name : null;
			this.Price = feeRec.Price__c;
			this.Status = feeRec.Status__c;
			this.Modified = (feeRec.LastModifiedDate != null) ? feeRec.LastModifiedDate.format('MM/dd/yyyy') : null;
		}
	}
	
	/**
	 * Name: LabourCode
	 * Description: Sets the value of LabourCode 
	**/
	public class LabourCode {
		
		public String Id {get; private set;}
		public String Code {get; private set;}
		public Integer Type {get; private set;}
		public String Description {get; private set;}
		public String Category {get; private set;}
		public Decimal Price {get; private set;}
		public String Status {get; private set;}
		public String Modified {get; private set;}
		
		public LabourCode(Labour_Code__c labourRec) {
			this.Id = labourRec.Id;
			this.Code = labourRec.Code__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Labor Codes');
			this.Description = labourRec.Description__c;
			this.Category = (labourRec.Category__c != null && labourRec.Category__r.Name != null) ? labourRec.Category__r.Name : null;
			this.Price = labourRec.Rate__c;
			this.Status = labourRec.Status__c;
			this.Modified = (labourRec.LastModifiedDate != null) ? labourRec.LastModifiedDate.format('MM/dd/yyyy') : null;
		}
	}
	
	
	public class VendorProduct {
		public String Id {get; private set;}
		public String Code {get; private set;}
		public Integer Type {get; private set;}
		public String Category {get; private set;}
		public Decimal Price {get; private set;}
		public String Description {get; private set;}
		public String Status {get; private set;}
		public String Modified {get; private set;}
		public String Vendor {get; private set;}
		public Decimal Cost {get; private set;}
		
		public VendorProduct(Product__c productRec) {
			this.Id = productRec.Id;
			this.Code = productRec.Code__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Sublets');
			this.Description = productRec.Description__c;
			this.Price = productRec.Price__c;
			this.Modified = (productRec.LastModifiedDate != null) ? productRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Category = (productRec.Category__c != null && productRec.Category__r.Name != null) ? productRec.Category__r.Name : null;
			this.Vendor = (productRec.Vendor__c != null) ? productRec.Vendor__r.Vendor_Code__c : null;
			this.Cost = (productRec.Cost__c != null) ? productRec.Cost__c : null;
			//this.Status = productRec.Status__c;
		}
	}
	
	/**
	 * Name: Product
	 * Description: Sets the value of Product by filtering out the fields of the entity
	**/
	public class Product {
		public Integer Type {get; private set;}
		public String Code {get; private set;}
		public String Description {get; private set;}
		public String Category {get; private set;}
		public Decimal Price {get; private set;}
		public Decimal Available {get; private set;}
		public String Modified {get; private set;}
		public String Status {get; private set;}
		public String Vendor {get; private set;}
		public Decimal Cost {get; private set;}
		public String Location {get; private set;}
		public String Id {get; private set;}
		
		public Product(Sobject sobjRec) {
			this.Id = String.valueOf(sobjRec.get('Id'));
			String objectName = ((Id)sobjRec.get('Id')).getSObjectType().getDescribe().getName();
			// If the entity is of part type or kit or labourcode or fee then it will be assigned from here accordingly
			if(objectName == Constants.NAMESPACE + 'Part__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Parts');
				this.Description = (sobjRec.get(Constants.NAMESPACE +'Part_Number__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Part_Number__c')) : null;
				this.Price = (sobjRec.get(Constants.NAMESPACE +'Retail_Price__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Retail_Price__c'))) : null;
				this.Code = (sobjRec.get(Constants.NAMESPACE +'Part_Number__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Part_Number__c')) : null;
				this.Available = (sobjRec.get(Constants.NAMESPACE +'AvailableParts__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'AvailableParts__c'))) : null;
				this.Category = (sobjRec.getSobject(Constants.NAMESPACE + 'Category__r') != null && sobjRec.getSobject(Constants.NAMESPACE + 'Category__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name')) : null;
				this.Location = (sobjRec.get(Constants.NAMESPACE + 'Location__c') != null) ? String.valueOf(sobjRec.get('Location__c')) : null;
				this.Vendor = (sobjRec.get(Constants.NAMESPACE +'Vendor__c') != null && String.valueOf(sobjRec.getSobject(Constants.NAMESPACE + 'Vendor__r').get(Constants.NAMESPACE +'Vendor_Code__c')) != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Vendor__r').get(Constants.NAMESPACE +'Vendor_Code__c')) : null;
				this.Cost = (sobjRec.get(Constants.NAMESPACE +'Last_Cost__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE + 'Last_Cost__c'))) : null;
				
			} else if(objectName == Constants.NAMESPACE +'Kit_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Kits');
				this.Description = (sobjRec.get(Constants.NAMESPACE +'Kit_Unique_Name__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Kit_Unique_Name__c')) : null;
				this.Price = (sobjRec.get(Constants.NAMESPACE +'Fixed_Price__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Fixed_Price__c'))) : null;
				this.Available = 1;
				this.Code = (sobjRec.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Code__c')) : null;
			
			} else if(objectName == Constants.NAMESPACE +'Labour_Code__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Labor Codes');
				this.Description = (sobjRec.get('Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				this.Category = (sobjRec.getSobject(Constants.NAMESPACE +'Category__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name')) : null;
				this.Price = (sobjRec.get(Constants.NAMESPACE +'Rate__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Rate__c'))) : null;
				this.Code = (sobjRec.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Code__c')) : null;
			
			} else if(objectName == Constants.NAMESPACE +'Fee__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Fees');
				this.Description = (sobjRec.get(Constants.NAMESPACE +'Fee_Unique_Name__c') != null) ? String.valueOf(sobjRec.get('Fee_Unique_Name__c')) : null;
				this.Category = (sobjRec.getSobject(Constants.NAMESPACE +'Category__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name')) : null;
				this.Price = (sobjRec.get(Constants.NAMESPACE +'Price__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Price__c'))) : null;
				this.Code = (sobjRec.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Code__c')) : null;
			
			} else if(objectName == Constants.NAMESPACE +'Product__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Sublets');
				this.Description = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				this.Category = (sobjRec.getSobject(Constants.NAMESPACE +'Category__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Category__r').get('Name')) : null;
				this.Price = (sobjRec.get(Constants.NAMESPACE +'Price__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Price__c'))) : null;
				this.Code = (sobjRec.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Code__c')) : null;
				this.Vendor = (sobjRec.get(Constants.NAMESPACE +'Vendor__c') != null && String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Vendor__r').get(Constants.NAMESPACE +'Vendor_Code__c')) != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Vendor__r').get(Constants.NAMESPACE +'Vendor_Code__c')) : null;
				this.Cost = (sobjRec.get(Constants.NAMESPACE +'Cost__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Cost__c'))) : null;
			}
			
			this.Status = String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c'));
			this.Modified = (DateTime.valueOf(String.valueOf(sobjRec.get('LastModifiedDate')))).format('MM/dd/yyyy');
		}
	}
	
	/**
	 * Name: CustomerOrders
	 * Description:  Sets the value of the customerOrder
	**/
	public class CustomerOrders {
		public Integer Type {get; private set;}
		public String Order_Number {get; private set;}
		public String Customer_Name {get; private set;}
		public String Status {get; private set;}
		public Decimal Total {get; private set;}
		public Decimal Balance_Due {get; private set;}
		public String Owner {get; private set;}
		public String Created {get; private set;}
		public String Modified {get; private set;}
		
		public Decimal Deposits {get; private set;}
		public Decimal Payments {get; private set;}
		public String Id {get; private set;}
		
		public CustomerOrders(CO_Header__c coHeaderRec) {
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Orders');
			this.Order_Number =  coHeaderRec.Name;
			this.Customer_Name =  coHeaderRec.Customer__r.Name;
			this.Status = coHeaderRec.Status__c;
			this.Total = coHeaderRec.Total_Order_Value__c;
			this.Balance_Due = coHeaderRec.Total_Balance_Due__c;
			this.Owner = coHeaderRec.Owner__r.Name;
			this.Created = (coHeaderRec.CreatedDate != null) ? coHeaderRec.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (coHeaderRec.LastModifiedDate != null) ? coHeaderRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			
			this.Id = coHeaderRec.Id;
			this.Deposits = coHeaderRec.Total_Deposit__c;
			this.Payments = coHeaderRec.Total_Payment__c;
			//this.Balance_Due = coHeaderRec.Total_Balance_Due__c;
		}
	}
	
	/**
	 * Name: CustomerInvoice
	 * Description: Sets the Value of the Customer Invoice
	**/	
	
	public class CustomerInvoice {
		public Integer Type {get; private set;}
		public String Invoice_Number {get; private set;}
		public String Customer_Name {get; private set;}
		public String Status {get; private set;}
		public Decimal Total {get; private set;}
		public String Order_Number {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Id {get; private set;}
		
		public CustomerInvoice(CO_Invoice_Header__c coInvoiceHeader) {
			this.Id = coInvoiceHeader.CO_Header__c;
			this.Invoice_Number = coInvoiceHeader.Invoice_Number__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Invoices');
			this.Customer_Name =  coInvoiceHeader.CO_Header__r.Customer__r.Name;
			this.Total = coInvoiceHeader.Total_Payment__c;
			this.Status = coInvoiceHeader.Status__c;
			this.Order_Number = coInvoiceHeader.CO_Header__r.Name;
			this.Owner = coInvoiceHeader.CO_Header__r.Owner__r.Name;
			this.Created = (coInvoiceHeader.CreatedDate != null) ? coInvoiceHeader.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (coInvoiceHeader.LastModifiedDate != null) ? coInvoiceHeader.LastModifiedDate.format('MM/dd/yyyy') : null;
			//this.Balance_Due = coInvoiceHeader.CO_Header__r.Total_Balance_Due__c;
		}
	}
	
	/**
	 * Name: CustomerPayment
	 * Description: Sets the Value of the Customer Invoice
	**/	
	
	public class CustomerPayment {
		public Integer Type {get; private set;}
		public String Payment_Number {get; private set;}
		public String Customer_Name {get; private set;}
		public Decimal Total {get; private set;}
		public String Status {get; private set;}
		public String Order_Number {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Payment_Method {get; private set;}
		public String Reverse_Payment_Id {get; private set;}
		public String Id {get; private set;}
		
		public CustomerPayment(CO_Invoice_Payment__c coPaymentRec) {
			this.Id = (coPaymentRec.CO_Invoice_Header__c != null) ? coPaymentRec.CO_Invoice_Header__r.CO_Header__c : null;
			this.Payment_Number = coPaymentRec.Name;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Payments');
			this.Customer_Name = (coPaymentRec.CO_Invoice_Header__c != null) ? coPaymentRec.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name : null;
			this.Total = coPaymentRec.Amount__c;
			this.Status = (coPaymentRec.CO_Invoice_Header__c != null) ? coPaymentRec.CO_Invoice_Header__r.Status__c : null;
			this.Order_Number = (coPaymentRec.CO_Invoice_Header__c != null) ? coPaymentRec.CO_Invoice_Header__r.CO_Header__r.Name : null;
			this.Owner = (coPaymentRec.CO_Invoice_Header__c != null && coPaymentRec.CO_Invoice_Header__r.CO_Header__r.Owner__c != null) ? coPaymentRec.CO_Invoice_Header__r.CO_Header__r.Owner__r.Name : null;
			this.Created = coPaymentRec.CreatedDate.format('MM/dd/yyyy');
			this.Modified = coPaymentRec.LastModifiedDate.format('MM/dd/yyyy');
			this.Payment_Method = coPaymentRec.Payment_Method__c;
			this.Reverse_Payment_Id = (coPaymentRec.Reverse_Payment_From__c != null) ? coPaymentRec.Reverse_Payment_From__r.Name : null;
		}
	}
	
	
	/**
	 * Name: CustomerSales
	 * Description: Sets the value of Customer Sales
	**/	
	public class CustomerSales {
		
		public Integer Type {get; private set;}
		public String Id_Number {get; private set;}
		public String Name {get; private set;}
		public String Status {get; private set;}
		public Decimal Total {get; private set;}
		public Decimal Balance_Due {get; private set;}
		public String Order_Number {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Deposits {get; private set;}
		public String Payments {get; private set;}
		
		public String Id {get; private set;}
		  
		public CustomerSales(Sobject sobjRec) {
			this.Id = String.valueOf(sobjRec.get('Id'));
			String objectName = ((Id)sobjRec.get('Id')).getSObjectType().getDescribe().getName();
			this.Id_Number = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
			
			// Matches for the Object of the CustomerSales group and then assigns to it
			if(objectName == Constants.NAMESPACE +'CO_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Orders');
				this.Name =  (sobjRec.getSobject(Constants.NAMESPACE +'Customer__r') != null &&  sobjRec.getSobject(Constants.NAMESPACE +'Customer__r').get('Name') != null ) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Customer__r').get('Name')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				this.Total =  (sobjRec.get(Constants.NAMESPACE +'Total_Order_Value__c') != null) ?  Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Total_Order_Value__c'))) : null; 
				this.Owner = (sobjRec.getSobject(Constants.NAMESPACE +'Owner__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'Owner__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Owner__r').get('Name')) : null;
				this.Balance_Due = (sobjRec.get(Constants.NAMESPACE +'Total_Balance_Due__c') != null) ?  Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Total_Balance_Due__c'))) : null;
				//(sobjRec.getSobject('CO_Header__r') != null && sobjRec.getSobject('CO_Header__r').get('Total_Order_Value__c') != null)
				//this.Balance_Due = (sobjRec.get('Total_Balance_Due__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get('CO_Header__r').get('Total_Balance_Due__c'))) : null;  
			  
			} else if(objectName == Constants.NAMESPACE +'CO_Invoice_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Invoices');
				this.Name = (sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r') != null && 
                		     sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Customer__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Customer__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Customer__r').get('Name')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				
				//this.Total =  (sobjRec.getSobject('CO_Header__r') != null &&  sobjRec.getSobject('CO_Header__r').get('Total_Order_Value__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.getSobject('CO_Header__r').get('Total_Order_Value__c'))) : null;
				
				this.Order_Number = (sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r') != null &&
				 						sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').get('Name') != null ) ? 
				 						String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').get('Name')) : null;
				this.Owner = (sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r') != null &&  sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').get(Constants.NAMESPACE +'Owner__c') != null &&  sobjRec.getSobject('CO_Header__r').getSobject(Constants.NAMESPACE +'Owner__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Owner__r').get('Name')) : null;
				this.Total = (sobjRec.get(Constants.NAMESPACE +'Total_Payment__c') != null) ?  Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Total_Payment__c'))) : null;
				this.Balance_Due = (sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').get(Constants.NAMESPACE +'Total_Balance_Due__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Header__r').get(Constants.NAMESPACE +'Total_Balance_Due__c'))) : null;
			
            } else if(objectName == Constants.NAMESPACE +'CO_Invoice_Payment__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Payments');
				this.Name = (sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r') != null && 
							sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Customer__r') != null && 
							sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Customer__r').get('Name') != null) ? 
									String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Customer__r').get('Name')) : 
									null;
				this.Total = (sobjRec.get(Constants.NAMESPACE +'Amount__c') != null) ? Decimal.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Amount__c'))) : null;
				
				this.Order_Number = ( (sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r') != null) &&  
									  (sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').get('Name')) != null) ? 
									String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').get('Name')) : null;
				this.Owner = (sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r') != null &&  sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').get(Constants.NAMESPACE +'Owner__c') != null &&
                			sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Owner__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSobject(Constants.NAMESPACE +'CO_Header__r').getSobject(Constants.NAMESPACE +'Owner__r').get('Name')) : null;
			}
			
			this.Created = (DateTime.valueOf(String.valueOf(sobjRec.get('CreatedDate')))).format('MM/dd/yyyy');
			this.Modified = (DateTime.valueOf(String.valueOf(sobjRec.get('LastModifiedDate')))).format('MM/dd/yyyy');
		}
	}	
	
	
	/**
	 * Name: Category
	 * Description: Sets the value of the Category
	**/	
	
	public class Category{
		public String Id {get; private set;}
		public Integer Type {get; private set;}
		public String Code {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String OwnerId {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Description {get; private set;}
		
		public Category(Category__c categoryRecord) {
			this.Id = categoryRecord.Id;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Item Categories');
			this.Code = categoryRecord.Unique_Category__c;
			this.Status = categoryRecord.Status__c;
			this.Owner = categoryRecord.Owner.Name;
			this.Created = (categoryRecord.CreatedDate != null) ? categoryRecord.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (categoryRecord.LastModifiedDate != null) ? categoryRecord.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Description = categoryRecord.Description__c;
		}
	}
	
	/**
	 * Name: PriceLevel
	 * Description: Sets the value of the PriceLevel
	**/	
	
	public class PriceLevel{
		public String Id {get; private set;}
		public String Code {get; private set;}
		public Integer Type {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String OwnerId {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Description {get; private set;}
		
		public PriceLevel(Price_Level__c priceLevel) {
			this.Id = priceLevel.Id;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Price Levels');
			this.Code = priceLevel.Name__c;
			this.Status = priceLevel.Status__c;
			this.Owner = priceLevel.Owner.Name;
			this.Created = (priceLevel.CreatedDate != null) ? priceLevel.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (priceLevel.LastModifiedDate != null) ? priceLevel.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Description = priceLevel.Description__c;
		}
	}
	
	/**
	 * Name: SalesTax
	 * Description: Sets the value of the SalesTax
	**/	
	
	public class SalesTax{
		public String Id {get; private set;}
		public String Code {get; private set;}
		public Integer Type {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Description {get; private set;}
		
		public SalesTax(Sales_Tax__c salesTax) {
			this.Id = salesTax.Id;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Sales Taxes');
			this.Code = salesTax.Name__c;
			this.Status = salesTax.Status__c;
			this.Owner = salesTax.Owner.Name;
			this.Created = (salesTax.CreatedDate != null) ? salesTax.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (salesTax.LastModifiedDate != null) ? salesTax.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Description = salesTax.Forms_Label__c;
		}
	}
	
	/**
	 * Name: Setting
	 * Description: Sets the value of the Setting according to its entity type
	**/	
	
	public class Setting{
		public String Id {get; private set;}
		public Integer Type {get; private set;}
		public String Code {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String OwnerId {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Description {get; private set;}
		
		public Setting(sObject setting) {
			this.Id = String.valueOf(setting.get('Id'));
			this.Status = String.valueOf(setting.get(Constants.NAMESPACE +'Status__c'));
			this.Owner = (setting.getSObject('Owner') != null) ? String.valueOf(setting.getSObject('Owner').get('Name')) : null;
			this.OwnerId =  (setting.getSObject('Owner') != null) ? String.valueOf(setting.getSObject('Owner').get('Id')) : null;
			this.Created = (DateTime.valueOf(String.valueOf(setting.get('CreatedDate')))).format('MM/dd/yyyy');
			this.Modified = (DateTime.valueOf(String.valueOf(setting.get('LastModifiedDate')))).format('MM/dd/yyyy');
			
			// Checks for the Object and assigns value accordingly
			String objectName = ((Id)setting.get('Id')).getSObjectType().getDescribe().getName();
			if(objectName == Constants.NAMESPACE + 'Category__c') {
				this.Code = String.valueOf(setting.get(Constants.NAMESPACE +'Unique_Category__c'));
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Item Categories');
				this.Description = String.valueOf(setting.get(Constants.NAMESPACE +'Description__c'));
			} else if(objectName == Constants.NAMESPACE +'Price_Level__c') {
				this.Code = String.valueOf(setting.get(Constants.NAMESPACE +'Name__c'));
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Price Levels');
				this.Description = String.valueOf(setting.get(Constants.NAMESPACE +'Description__c'));
			} else if(objectName == Constants.NAMESPACE +'Sales_Tax__c') {
				this.Code = String.valueOf(setting.get(Constants.NAMESPACE +'Name__c'));
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Sales Taxes');
				this.Description = String.valueOf(setting.get(Constants.NAMESPACE +'Forms_Label__c'));
			}
		}
	}
	
	/**
	 * Name: VendorOrder
	 * Description: Sets the value of the VendorOrder
	**/	
	public class VendorOrder {
		
		public Integer Type {get; private set;}
		public String Order_Number {get; private set;}
		public String Vendor {get; private set;}
		public String Status {get; private set;}
		public Decimal Total {get; private set;}
		public String Owner {get; private set;}
		public String Created {get; private set;}
		public String Modified {get; private set;}
		public String Order_Type {get; private set;}
		public Decimal Received {get; private set;}
		
		public String Id {get; private set;}
		
		public VendorOrder(Vendor_Order_Header__c voHeaderRec) {
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Orders');
			this.Order_Number = voHeaderRec.Name;
			this.Vendor =  voHeaderRec.Vendor__r.Name;
			this.Status = voHeaderRec.Status__c;
			this.Total = voHeaderRec.Total__c; 
			this.Received = voHeaderRec.Total_Recieved__c; 
			this.Owner = voHeaderRec.Owner__r.Name;
			this.Created = (voHeaderRec.CreatedDate != null) ? voHeaderRec.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (voHeaderRec.LastModifiedDate != null) ? voHeaderRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Order_Type = (voHeaderRec.Purchase_Order_Type__c != null) ? voHeaderRec.Purchase_Order_Type__r.Code__c : null;
			this.Id = voHeaderRec.Id;
		}
	}	
	
	/**
	 * Name: VendorInvoice
	 * Description: Sets the value of the VendorInvoice
	**/	
	public class VendorInvoice {
		
		public Integer Type {get; private set;}
		public String Invoice_Number {get; private set;}
		public String Vendor {get; private set;}
        public string VendorId {get; private set;}
		public Decimal Total {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String OwnerId {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Id {get; private set;}
		
		public VendorInvoice(Vendor_Invoicing_Header__c voInvoiceRec) {
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Invoices');
			this.Invoice_Number = voInvoiceRec.Invoice_Number__c;
			this.Vendor =  voInvoiceRec.Vendor__r.Name;
			this.Status = voInvoiceRec.Status__c;
			this.Owner = voInvoiceRec.Owner__r.Name;
			this.Created = (voInvoiceRec.CreatedDate != null) ? voInvoiceRec.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (voInvoiceRec.LastModifiedDate != null) ? voInvoiceRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			
			this.Total = voInvoiceRec.Total__c;
			this.Id = voInvoiceRec.Id;
		}
	}
	
	/**
	 * Name: User
	 * Description: Sets the value of the VendorInvoice
	**/	
	public class UserRec {
		
		public Integer Type {get; private set;}
		public String Name {get; private set;}
		public String Email {get; private set;}
        public string Status {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		public String Id {get; private set;}
		
		public UserRec(User userRec) {
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Users');
			this.Name = userRec.Name;
			this.Email =  userRec.Email;
			this.Status = userRec.IsActive ? 'Active' : 'Inactive';
			this.Created = (userRec.CreatedDate != null) ? userRec.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (userRec.LastModifiedDate != null) ? userRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			this.Id = userRec.Id;
		}
	}
	
	/**
	 * Name: VendorRecieving
	 * Description: Sets the value of the VendorRecieving
	**/
	public class VendorRecieving { 
		
		public Integer Type {get; private set;}
		public String Reciept_Number {get; private set;}
		public String Vendor {get; private set;}
		public Decimal Total {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		
		public String Id {get; private set;}
		
		public VendorRecieving(Vendor_Receiving_Header__c vrHeaderRec) {
			this.Id = vrHeaderRec.Id;
			this.Reciept_Number = vrHeaderRec.Packing_Slip_Number__c;
			this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Receivings');
			this.Vendor =  vrHeaderRec.Vendor__r.Name;
			this.Status = vrHeaderRec.Status__c;
			this.Owner = vrHeaderRec.Owner__r.Name;
			this.Created = (vrHeaderRec.CreatedDate != null) ? vrHeaderRec.CreatedDate.format('MM/dd/yyyy') : null;
			this.Modified = (vrHeaderRec.LastModifiedDate != null) ? vrHeaderRec.LastModifiedDate.format('MM/dd/yyyy') : null;
			
			this.Total = vrHeaderRec.Receiving_Total__c;
		}
		
	}
	/**
	 * Name: VendorOrdering
	 * Description: Sets the value of the VendorOrdering
	**/
	public class VendorOrdering {
		
		public String Id {get; private set;}
		public String Id_Number {get; private set;}
		public Integer Type {get; private set;}
		public String Vendor {get; private set;}
        public string VendorId {get; private set;}
		public Decimal Total {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String OwnerId {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		
		public VendorOrdering(Sobject sobjRec) {
			this.Id = String.valueOf(sobjRec.get('Id'));
			String objectName = ((Id)sobjRec.get('Id')).getSObjectType().getDescribe().getName();
			
			// Checks for the  Object and assigns the value accordingly for object type
			this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
			this.Owner = (sobjRec.getSobject(Constants.NAMESPACE +'Owner__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'Owner__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Owner__r').get('Name')) : null;
			this.Vendor = (sobjRec.getSobject(Constants.NAMESPACE +'Vendor__r') != null && sobjRec.getSobject(Constants.NAMESPACE +'Vendor__r').get('Name') != null) ? String.valueOf(sobjRec.getSobject(Constants.NAMESPACE +'Vendor__r').get('Name')) : null;
			this.Total = 0;
			
			if(objectName == Constants.NAMESPACE +'Vendor_Order_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Orders');
				this.Id_Number = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
			} else if(objectName == Constants.NAMESPACE +'Vendor_Receiving_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Receivings');
				this.Id_Number = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Packing_Slip_Number__c')) : null;
			} else if(objectName == Constants.NAMESPACE +'Vendor_Invoicing_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Invoices');
				this.Id_Number = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Invoice_Number__c')) : null;
			} 
			 
			this.Created = (DateTime.valueOf(String.valueOf(sobjRec.get('CreatedDate')))).format('MM/dd/yyyy');
			this.Modified = (DateTime.valueOf(String.valueOf(sobjRec.get('LastModifiedDate')))).format('MM/dd/yyyy');
		}
     
    }
	/**
	 * Name: AnyObject
	 * Description: Sets the Value of Generic type
	**/
	public class AnyObject {
		
		public String Id {get; private set;}
		public Integer Type {get; private set;}
		public String Key {get; private set;}
		public String Summary {get; private set;}
		public String Status {get; private set;}
		public String Owner {get; private set;}
		public String OwnerId {get; private set;}
		public String Modified {get; private set;}
		public String Created {get; private set;}
		
		public AnyObject(Sobject sobjRec) {
			this.Id = String.valueOf(sobjRec.get('Id'));
			String objectName = ((Id)sobjRec.get('Id')).getSObjectType().getDescribe().getName();
			
			// Checks for the Object and assigns the value accordingly for that object
			if(objectName == 'Account') {
				if(Boolean.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Is_Customer__c')))) {
					this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customers');
					
				} else if(Boolean.valueOf(String.valueOf(sobjRec.get(Constants.NAMESPACE +'Is_Vendor__c')))) {
					this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendors');
				}
				
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c'));
				
			} else if(objectName == Constants.NAMESPACE + 'Part__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Parts');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Part_Number__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Part_Number__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Product__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Sublets');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Code__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Labour_Code__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Labor Codes');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
			
			} else if(objectName == Constants.NAMESPACE + 'Kit_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Kits');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Code__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
			
			} else if(objectName == Constants.NAMESPACE + 'Fee__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Fees');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Fee_Unique_Name__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Fee_Unique_Name__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				
			} else if(objectName == 'User') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Users');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = (sobjRec.get('IsActive') != null) ? String.valueOf(sobjRec.get('IsActive')) : null;
				this.Status = (this.Status.toLowerCase() == 'true') ? 'Active' : 'Inactive';
				this.Summary = (sobjRec.get('Email') != null) ? String.valueOf(sobjRec.get('Email')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'CO_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Orders');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'CO_Invoice_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Invoices');
				this.Key = (sobjRec.get('Invoice_Number__c') != null) ? String.valueOf(sobjRec.get('Invoice_Number__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
			
            } else if(objectName == Constants.NAMESPACE + 'CO_Invoice_Payment__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Customer Payments');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = 'Active';
                
			} else if(objectName == Constants.NAMESPACE + 'Vendor_Order_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Orders');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Vendor_Receiving_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Receivings');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Vendor_Invoicing_Header__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Vendor Invoices');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get('Name')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null ) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Category__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Item Categories');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Unique_Category__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Unique_Category__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Price_Level__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Price Levels');
				this.Key = (sobjRec.get(Constants.NAMESPACE +'Name__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Name__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Description__c')) : null;
				
			} else if(objectName == Constants.NAMESPACE + 'Sales_Tax__c') {
				this.Type = HomeSearchUtil.displayObjectNameToTypeNumber.get('Sales Taxes');
				this.Key = (sobjRec.get('Name') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Name__c')) : null;
				this.Status = (sobjRec.get(Constants.NAMESPACE +'Status__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Status__c')) : null;
				this.Summary = (sobjRec.get(Constants.NAMESPACE +'Forms_Label__c') != null) ? String.valueOf(sobjRec.get(Constants.NAMESPACE +'Forms_Label__c')) : null;
			}
			
			String ownerFieldNameValue;
			String ownerFieldIdValue;
            //system.assert(false, objectName + '  ' + HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName);
            
			String ownerFieldName = HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objectName).get('Owner');
			List<String> ownerFieldsMap = ownerFieldName.split('\\.');
			
			if( ownerFieldName.contains('CreatedBy') ){
				if(ownerFieldsMap.size() == 1) {
					ownerFieldNameValue = (String) sobjRec.get(ownerFieldsMap[0]);
					ownerFieldIdValue = (String) sobjRec.get(ownerFieldsMap[0]);
				} else if(ownerFieldsMap.size() == 2 && sobjRec.getSObject(ownerFieldsMap[0]) != null) {
					ownerFieldNameValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).get(ownerFieldsMap[1]);
					ownerFieldIdValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).get('Id');
				}
			} else if( ownerFieldName.contains('Owner') == false ){
				ownerFieldNameValue = String.valueOf(sobjRec.get(ownerFieldName));
				ownerFieldIdValue = String.valueOf(sobjRec.get(ownerFieldName));
			} else if(ownerFieldsMap.size() == 1) {
				ownerFieldNameValue = (String) sobjRec.get(ownerFieldsMap[0]);
				ownerFieldIdValue = (String) sobjRec.get(ownerFieldsMap[0]);
			} else if(ownerFieldsMap.size() == 2) {
				if(sobjRec.getSObject(ownerFieldsMap[0]) != null) {
					ownerFieldNameValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).get(ownerFieldsMap[1]);
					ownerFieldIdValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).get('Id');
				}
			} else if(ownerFieldsMap.size() == 3){
				if(sobjRec.getSObject(ownerFieldsMap[0]) != null && sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]) != null) {
					ownerFieldNameValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]).get(ownerFieldsMap[2]);
					ownerFieldIdValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]).get('Id');
				}
			} else if(ownerFieldsMap.size() == 4){
				if(sobjRec.getSObject(ownerFieldsMap[0]) != null && sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]) != null && sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]).getSObject(ownerFieldsMap[2]) != null) {
					ownerFieldNameValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]).getSObject(ownerFieldsMap[2]).get(ownerFieldsMap[3]);
					ownerFieldIdValue = (String) sobjRec.getSObject(ownerFieldsMap[0]).getSObject(ownerFieldsMap[1]).getSObject(ownerFieldsMap[2]).get('Id');
				}
			}
			this.Owner = ownerFieldNameValue;
			this.OwnerId = ownerFieldIdValue;
			/*
			if(HomeSearchUtil.objectToOwnerObjectFieldName.containsKey(objectName) && HomeSearchUtil.objectToOwnerObjectFieldName.get(objectName).contains('__c')) {
				String parentObjectFieldName = HomeSearchUtil.objectToOwnerObjectFieldName.get(objectName).split('\\.')[0];
				this.Owner = String.valueOf(sobjRec.getSobject(parentObjectFieldName).getSobject('Owner__r').get('Name'));
				this.OwnerId = String.valueOf(sobjRec.getSobject(parentObjectFieldName).getSobject('Owner__r').get('Id'));
			} else if(HomeSearchUtil.objectToOwnerObjectFieldName.containsKey(objectName)) {
				String parentObjectFieldName = HomeSearchUtil.objectToOwnerObjectFieldName.get(objectName);
				this.Owner = String.valueOf(sobjRec.getSobject(parentObjectFieldName).getSobject('Owner').get('Name'));
				this.OwnerId = String.valueOf(sobjRec.getSobject(parentObjectFieldName).getSobject('Owner').get('Id'));
			} else if(HomeSearchUtil.searchableObjectToFieldsMap.get(objectName).contains('Owner.Name')) {
				this.Owner = (sobjRec.getSobject('Owner') != null && sobjRec.getSobject('Owner').get('Name') != null) ? String.valueOf(sobjRec.getSobject('Owner').get('Name')) : null;
				this.OwnerId = (sobjRec.getSobject('Owner') != null) ? String.valueOf(sobjRec.getSobject('Owner').get('Id')) : null;
			}
			*/
			
			this.Modified = (DateTime.valueOf(String.valueOf(sobjRec.get('LastModifiedDate')))).format('MM/dd/yyyy');
			this.Created = (DateTime.valueOf(String.valueOf(sobjRec.get('CreatedDate')))).format('MM/dd/yyyy');
		}
	}
}