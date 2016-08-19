/**
 * Author: Tarun Khandelwal
 * Since: March 10, 2016
 * Name: HomeSearchFilterWrapper
 * Description: Class is used for the Creation of the Json For Filters
**/
public with sharing class HomeSearchFilterWrapper {

	public TypeFilter Type;	
	public OwnerFilter Owner;
	public String SearchText;
	public String Status;
	public BetweenFilter ModifiedDate;
	public BetweenFilter CreatedDate;
	
	// Customer
	public String People_Id;
	public String People_Name;
	public String People_Email;
	public String People_Phone;
	public String People_BillingAddress;
	public String People_BillingCity;
	public String People_StateProv;
	public String People_Country;
	public String People_SalesTax;
	public String People_PriceLevel;
	
	// Vendor
	public String Vendor_PurchaseSalesTax; 
	
	
	// Product
	public String Product_Item;
	public String Product_Description;
	public String Product_Category;
	public BetweenFilter Product_Price;
	public BetweenFilter Product_QtyAvailable;
	
	// Part
	public String Part_Location;
	public BetweenFilter Part_Cost;
	public BetweenFilter Part_AverageCost;
	public BetweenFilter Part_InStock;
	public BetweenFilter Part_Committed;
	public BetweenFilter Part_OnOrder;
	public String Part_PackagedPart;
	public BetweenFilter Part_LastCounted;
	public BetweenFilter Part_LastSold;
	public BetweenFilter Part_LastStocked;
	public BetweenFilter Part_ReorderAt;
	public BetweenFilter Part_ReorderTo;
	public String Part_Status;
	public String Part_Vendor;
	
	// Kits
	public BetweenFilter Kit_KitPrice;
	public String Kit_FixedPrice;
	public String Kit_ServiceKit;
	
	//Fees
	public String Fee_FeeType;
	
	
	// Customer Sales
	public String Customer_Sales_Id;
	public String Customer_Sales_Customer;
	public BetweenFilter Customer_Sales_Total;
	public BetweenFilter Customer_Sales_Balance_Due;
	
	// Customer Orders
	public BetweenFilter Customer_Order_Deposits;
	public BetweenFilter Customer_Order_Payments;
	public String Customer_Order_Status;
	
	
	// Customer Invoices
	public String CO_Invoice_Header_Customer_Order;
	public String CO_Invoice_Header_Status;
	
	// Customer Payments
	public String CO_Payment_Customer_Order;
	public BetweenFilter CO_Payment_Payment_Method;
	
	
	//Vendor Ordering - Group
	public String Vendor_Ordering_Id;
	public String Vendor_Ordering_Vendor;
	public BetweenFilter Vendor_Ordering_Total;
	
	//Vendor Order
	public String Vendor_Order_Purchase_Order;
	public BetweenFilter Vendor_Order_Total_Recieved;
	public String Vendor_Order_Status;
	
	//Vendor Recievings
	public String Vendor_Receiving_Header_Status;
	
	//Vendor Invoices
	public String Vendor_Invoicing_Header_Status;
	
	
	// Settings
	public String Settings_Name;
	
	/*
	 * Name:HomeSearchFilterWrapper
	 * Description: Constructor
	**/
	public HomeSearchFilterWrapper() {
		this.Type = new TypeFilter(new List<String>());
		this.Owner = new OwnerFilter();
		this.SearchText = '';
		this.Status = '0';
		this.ModifiedDate = new BetweenFilter();
		this.CreatedDate = new BetweenFilter();
		
		
		this.People_Id = '';
		this.People_Name = '';
		this.People_Email = '';
		this.People_Phone = '';
		this.People_BillingAddress = '';
		this.People_BillingCity = '';
		this.People_StateProv = '';
		this.People_Country = '';
		
		
		this.People_SalesTax = '0';
		this.People_PriceLevel = '0';
		this.Vendor_PurchaseSalesTax = '0';
		
		this.Product_Item = '';
		this.Product_Description = '';
		this.Product_Category = '0';
		this.Product_Price = new BetweenFilter();
		this.Product_QtyAvailable = new BetweenFilter();
		
		this.Part_Location = '';
		this.Part_Cost = new BetweenFilter();
		this.Part_AverageCost = new BetweenFilter();
		this.Part_InStock = new BetweenFilter();
		this.Part_Committed = new BetweenFilter();
		this.Part_OnOrder = new BetweenFilter();
		this.Part_LastCounted = new BetweenFilter();
		this.Part_LastSold = new BetweenFilter();
		this.Part_LastStocked = new BetweenFilter();
		this.Part_PackagedPart = '0';
		this.Part_ReorderAt = new BetweenFilter();
		this.Part_ReorderTo = new BetweenFilter();
		this.Part_Status = '';
		this.Part_Vendor ='';
		
		this.Kit_KitPrice = new BetweenFilter();
		this.Kit_FixedPrice = '0';
		this.Kit_ServiceKit = '0';
		this.Fee_FeeType = '0';
		
		this.Customer_Sales_Id = '';
		this.Customer_Sales_Customer = '';
		this.Customer_Sales_Total = new BetweenFilter();
		this.Customer_Sales_Balance_Due = new BetweenFilter();
		
		this.CO_Invoice_Header_Customer_Order = '';
		this.CO_Invoice_Header_Status = '';
		
		this.CO_Payment_Customer_Order = '';
		this.CO_Payment_Payment_Method = new BetweenFilter();
		
		this.Customer_Order_Deposits = new BetweenFilter();
		this.Customer_Order_Payments = new BetweenFilter();
		
		this.Vendor_Ordering_Id = '';
		this.Vendor_Ordering_Vendor = '';
		this.Vendor_Ordering_Total = new BetweenFilter();
		
		this.Vendor_Order_Purchase_Order = '0';
		this.Vendor_Order_Total_Recieved = new BetweenFilter();
		this.Vendor_Order_Status = '' ;
		this.Vendor_Receiving_Header_Status = '';
		this.Vendor_Invoicing_Header_Status = '';
		this.Settings_Name = '';
		
	} 
	
	/**
	 * Name: TypeFilter
	 * Description: Class Is used for wrapping up the Type of the Object 
	**/
	public class TypeFilter { 
		public Set<String> Objects;
		
		/**
		 * Name: TypeFilter
		 * Description: Constructor
		 */
		public TypeFilter(List<String> selectedObjectList){
			Objects = new Set<String>();
			if(selectedObjectList != null){
				this.Objects.addAll(selectedObjectList);
			}
		}
	}
	/**
	 * Name: OwnerFilter
	 * Description: Class is used to create the Json according to the Owner Field
	**/
	public class OwnerFilter {
		
		public String SelectedOption;
		public String OwnerId;
		public String OwnerName;	
		
		/**
		 * Name: OwnerFilter
		 * Description: Constructor
		 */
		public OwnerFilter(){
			this.SelectedOption = '0';
			this.OwnerId = '';
			this.OwnerName = '';
		}
		
		public OwnerFilter(String selectedOptionStr, String ownerId, String ownerName){
			this.SelectedOption = selectedOptionStr;
			this.OwnerId = ownerId;
			this.OwnerName = ownerName;
		}
	}
	
	/**
	 * Name: BetweenFilter
	 * Description: Class is used to create the json for the Between option
	**/
	public class BetweenFilter {
		
		public String SelectedOption;
		public String Value1;
		public String Value2;  
		
		/**
		 * Name: BetweenFilter
		 * Description: Constructor
		**/
		public BetweenFilter(String selectedOptionStr, String value1Str, String value2Str){
			this.SelectedOption = selectedOptionStr;
			this.Value1 = value1Str;
			this.Value2 = value2Str;
		}
		public BetweenFilter(){
			this.SelectedOption = '0';
			this.Value1 = '';
			this.Value2 = '';
		}
	
	}
	
}