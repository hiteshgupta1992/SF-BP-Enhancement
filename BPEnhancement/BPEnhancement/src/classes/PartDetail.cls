/**
 * Author: Tarun Khandelwal
 * Since: June 15, 2015
 * Name: PartDetail
 * Description: Apex class to handle JSON related oprations of Part entity.
**/
public with sharing class PartDetail {
    
    // Id
    public String Id;
    
    // Name
    public String Name;
    
    // Part Number
    public String PartNumber;
    
    // Decsription
    public String Description;
    
    // Vendor Id
    public String VendorId;
    
    // Vendor Name
    public String VendorName;
    
    // Vendor Name
    public String VendorCode;
    
    // Vendor Name
    public String PartId;
    
    // Category Id
    public String CategoryId;
    
    // Category Name
    public String CategoryName;
    
    // Price Method
    public String PriceMethod;
    
    // ReplacedBy Id
    public String ReplacedById;
    
    // ReplacedBy Name
    public String ReplacedByName;
    
    // Packaged Part
    public Boolean IsPackagedPart;
    
    // Packaged Qty
    public Decimal PackagedQty;
    
    // Packaged Unit
    public String PackagedUnit;
    
    // Is Taxable
    public Boolean IsTaxable;
    
    // In Stock Qty
    public Decimal InStockQty;
    
    // Location
    public String Location;
    
    // Cost
    public Decimal Cost; 
    
    // Packaged Cost
    public Decimal PackagedCost;
    
    // MSRP
    public Decimal MSRP;
    
    // Retail
    public Decimal Retail;
    
    // EnviroFee 
    public Decimal EnviroFee;
    
    // AutoReorder At
    public Decimal AutoReorderAt;
    
    // AutoReorder To
    public Decimal AutoReorderTo;
    
    // Order Lots
    public Decimal OrderLots; 
    
    // Active
    public Boolean Active;
    
    // Status of Part 
    public String Status;
    
    // Qty Commited 
    public Decimal QtyCommited;
    
    // Qty Commited 
    public Decimal QtyAvailable;
    
    // Qty Commited 
    public Decimal QtyOnOrder;
    
    // Revenue Lifetime
    public Decimal RevenueLifetime;
    
    //Special Order
    public Decimal SpecialOrder;
    
    // IsOrderLot
	public Boolean IsOrderLot;
	
    // Last Sold
    public String LastSold;
    
    // Last Ordered
    public String LastOrdered;
    
    // ApplicableTaxId
    public String ApplicableTaxId;
    
    // ApplicableTaxName
	public String ApplicableTaxName;
    
    // Constructor
    public PartDetail(Part__c partRec){
        this.Id = partRec.Id;
        this.Name = partRec.Name;
        this.PartNumber = partRec.Part_Number__c;
        this.Description = partRec.Description__c;
        this.VendorId = partRec.Vendor__c;
        this.VendorName = partRec.Vendor__r.Name;
        this.partId = partRec.Part_ID__c;
        this.VendorCode = partRec.Vendor_Code__c;
        this.CategoryId = partRec.Category__c;
        this.CategoryName = partRec.Category__r.Name;
        this.PriceMethod = '';
        this.ReplacedById = partRec.Superseded_By__c;
        this.ReplacedByName = partRec.Superseded_By__r.Part_ID__c;
        this.IsPackagedPart = partRec.Packaged_Part__c;
        this.PackagedQty = partRec.Package_Qty__c;
        this.PackagedUnit = partRec.Package_Unit__c;
        this.IsTaxable = partRec.Taxable__c;
        this.InStockQty = partRec.Qty_In_Stock__c;
        this.Location = partRec.Location__c;
        this.Cost = (partRec.Last_Cost__c != null) ? partRec.Last_Cost__c.setScale(2) : 0.00;
        this.PackagedCost = (partRec.Package_Cost__c != null) ? partRec.Package_Cost__c.setScale(2) : 0.00;
        this.MSRP = (partRec.MSRP__c != null) ? partRec.MSRP__c.setScale(2) : 0.00;
        this.Retail = (partRec.Retail_Price__c != null) ? partRec.Retail_Price__c.setScale(2) : 0.00;
        this.EnviroFee = (partRec.Enviro_Fee__c != null) ? partRec.Enviro_Fee__c.setScale(2) : 0.00;
        this.AutoReorderAt = partRec.Auto_reorder_Min__c;
        this.AutoReorderTo = partRec.Auto_reorder_Max__c;
        this.OrderLots = partRec.Order_Lots__c;
        this.Active = partRec.Active__c;
        this.QtyCommited = partRec.Qty_Committed__c;
        this.RevenueLifetime = partRec.Qty_Committed__c * partRec.Retail_Price__c;
        this.QtyCommited = partRec.Qty_Committed__c;
        this.QtyAvailable = partRec.AvailableParts__c;
        this.QtyOnOrder = partRec.Qty_On_Order__c ;
        
        // Set Status Logic. Refer US - PA 004 - View Part - Left Sidebar
        if(partRec.Qty_In_Stock__c > 0 && partRec.Qty_In_Stock__c > partRec.Auto_reorder_Min__c && partRec.Qty_On_Order__c == 0) {
            this.Status = 'In Stock';
        } else if(partRec.Qty_In_Stock__c < partRec.Auto_reorder_Min__c || (partRec.Qty_In_Stock__c == partRec.Auto_reorder_Min__c 
                    && partRec.Auto_reorder_Min__c != partRec.Auto_reorder_Max__c) && partRec.Qty_On_Order__c == 0) {
            this.Status = 'Required';
        } else if(partRec.Qty_In_Stock__c == 0 && partRec.Qty_On_Order__c == 0) {
            this.Status = 'Out of Stock';
        } else if(partRec.Qty_On_Order__c == 0 && partRec.AvailableParts__c == 0 && partRec.Qty_In_Stock__c > 0) {
            this.Status = 'Committed';
        } else if(partRec.Qty_On_Order__c > 0 ) {
            this.Status = 'On Order';
        } 
        this.IsOrderLot = partRec.Is_OrderLot__c;
        this.ApplicableTaxId = partRec.Applicable_Tax__c;
        this.ApplicableTaxName = (partRec.Applicable_Tax__c != null) ? partRec.Applicable_Tax__r.Name__c : null;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: PartDetail - Class Object
    **/
    public static List<PartDetail> parse(String JSONString) {
        return (List<PartDetail>) System.JSON.deserialize(JSONString, List<PartDetail>.class);
    }
    
    // A method to define the list of part fields to be used in queries
    public static List<String> fieldsList(){
        List<String> partFields = new List<String>{ 'Id',
                                                    'Name',
                                                    'Part_Number__c',
                                                    'Description__c',
                                                    'Vendor__c',
                                                    'Vendor__r.Name',
                                                    'Part_Id__c',
                                                    'Category__c',
                                                    'Category__r.Name',
                                                    'Superseded_By__c',
                                                    'Superseded_By__r.Part_ID__c',
                                                    'Packaged_Part__c',
                                                    'Package_Qty__c',
                                                    'Package_Unit__c',
                                                    'Taxable__c',
                                                    'Qty_In_Stock__c', 
                                                    'Vendor_Code__c',
                                                    'Location__c',
                                                    'Last_Cost__c',
                                                    'Package_Cost__c',
                                                    'MSRP__c',
                                                    'Retail_Price__c',
                                                    'Enviro_Fee__c',
                                                    'Auto_reorder_Min__c',
                                                    'Auto_reorder_Max__c',
                                                    'Order_Lots__c',
                                                    'Active__c',
                                                    'Qty_On_Order__c',
                                                    'Qty_Committed__c',
                                                    'AvailableParts__c',
                                                    'Applicable_Tax__c',
                                                    'Applicable_Tax__r.Name__c',
													'Is_OrderLot__c'
                                                };
        return partFields;
    }
}