/**
 * Author: Tarun Khandelwal
 * Since: May 16, 2016
 * Name: ClaimWizard
 * Description: Apex class to handle JSON related oprations of Claim Wizard Screen.
**/
public with sharing class ClaimWizard {
    
    public String ClaimId;
    public String ClaimNumber;
    public String ResponseDate;
    public String Notes;
    public String ClaimDisposition;
    public String SOHeaderId;
    public Decimal Total;
    public String ProviderClaimNumber;
    public Decimal DeductibleAmount;
    public List<ClaimLineItem> VarianceLineItemList;
    public List<ClaimLineItem> NonVarianceLineItemList;
    public List<CategoryItem>  InternalCategoryList; 
    
    public ClaimWizard(Claim__c claimRec, List<SO_Payment_Role__c> deductibelRecordList, List<Category__c> InternalCategoryList) {
        this.ClaimId = claimRec.Id;
        this.ClaimNumber = (claimRec.Claim_Number__c != null) ? claimRec.Claim_Number__c : claimRec.Name;
        this.ResponseDate = (claimRec.Response_Date__c != null) ? 
                                datetime.newInstance(claimRec.Response_Date__c.year(), claimRec.Response_Date__c.month(),claimRec.Response_Date__c.day()).format('MM/dd/yyyy') 
                                : system.now().format('MM/dd/yyyy');
                                
        this.Notes = claimRec.Notes__c;
        this.ClaimDisposition = claimRec.Claim_Disposition__c;
        this.SOHeaderId = claimRec.Service_Order_Header__c; 
        
        this.VarianceLineItemList = new List<ClaimLineItem>();
        this.NonVarianceLineItemList = new List<ClaimLineItem>();
        this.ProviderClaimNumber = claimRec.Provider_Claim_Number__c;
        for(Claim_Line_Item__c claimLineItemRec : claimRec.Claim_Line_Items__r) {
            if(claimLineItemRec.Is_Variance__c) {
                this.VarianceLineItemList.add(new ClaimLineItem(claimLineItemRec));
            } else {
                this.NonVarianceLineItemList.add(new ClaimLineItem(claimLineItemRec));
            }
        }   
        
        this.InternalCategoryList = new List<CategoryItem>();
        for(Category__c categoryItem  :  InternalCategoryList){
        	this.InternalCategoryList.add(new CategoryItem(categoryItem) );
        
        }
        
        this.DeductibleAmount = 0;
        for(SO_Payment_Role__c deductibleRec : deductibelRecordList) {
            this.DeductibleAmount += deductibleRec.Total_Amount__c;
        }
    }
    
    public class CategoryItem{
    	public String Id;
    	public String CategoryName; 
    	public CategoryItem(Category__c Internalcategory){
    		this.Id = Internalcategory.Id;
    		this.CategoryName = Internalcategory.Name;
    	
    	}
    }
    
    public class ClaimLineItem {
        
        public String Id;
        public Decimal ApprovedPrice;
        public Decimal ApprovedQty;
        public Decimal ApprovedSubTotal;
        public Decimal ClaimedPrice;
        public Decimal ClaimedQty;
        public Decimal ClaimedSubtotal;
        public String  ServiceOrderLineItem ;
        public String  SOPaymentRole;
        public String  BillTo;
        public Decimal DeductibleAmount;  
        public Decimal Tax;  
        public Decimal TaxAmount;
        public Decimal Variance;    
        public String Itemdesc; 
        public String Total;
        public String Claim;
        public Decimal VarianceQuantity;
        public Decimal VarianceAmount;
        public Boolean IsVariance;
        public String PaymentStatus;
        public Decimal TotalVariance;
        public String Category;
        
        public ClaimLineItem(Claim_Line_Item__c claimLineItemRec){
            this.Id = claimLineItemRec.Id;
            this.ApprovedPrice = claimLineItemRec.Approved_Price__c !=null ? claimLineItemRec.Approved_Price__c : 0 ;
            this.ApprovedQty =  claimLineItemRec.Approved_Qty__c !=null ? claimLineItemRec.Approved_Qty__c : 0 ;
            this.ApprovedSubTotal =  claimLineItemRec.Approved_Subtotal__c ;
            this.ClaimedPrice = claimLineItemRec.Claimed_Price__c !=null ? claimLineItemRec.Claimed_Price__c : 0 ;
            this.ClaimedQty = claimLineItemRec.Claimed_Qty__c !=null ? claimLineItemRec.Claimed_Qty__c : 0 ;
            this.ClaimedSubtotal = claimLineItemRec.Claimed_Subtotal__c;
            this.Itemdesc = claimLineItemRec.Item_Desc__c;//need to update from Parent Soli parts records
            this.ServiceOrderLineItem  = claimLineItemRec.Service_Order_Line_Item__c !=null ? claimLineItemRec.Service_Order_Line_Item__c : null ;
            this.SOPaymentRole  = claimLineItemRec.SO_Payment_Role__c;
            this.Tax = claimLineItemRec.Tax__c;
            this.TaxAmount = claimLineItemRec.Tax_Amount__c;
            this.Variance = claimLineItemRec.Variance__c;
            this.Claim = claimLineItemRec.Claim__c;
            this.DeductibleAmount = (claimLineItemRec.SO_Payment_Role__c != null ? claimLineItemRec.SO_Payment_Role__r.Total_Amount__c : null) ;
            this.VarianceQuantity = claimLineItemRec.Variance_Qty__c;
            this.VarianceAmount = claimLineItemRec.Variance_Amount__c;
            this.IsVariance = claimLineItemRec.Is_Variance__c; 
            this.BillTo = (claimLineItemRec.SO_Payment_Role__c !=null )? claimLineItemRec.SO_Payment_Role__r.RecordType.DeveloperName : ((claimLineItemRec.Variance_Qty__c == 0 ) ? Constants.Internal : null);
            this.PaymentStatus =( claimLineItemRec.SO_Payment_Role__c !=null ) ? claimLineItemRec.SO_Payment_Role__r.Status__c : null;
            this.TotalVariance = claimLineItemRec.Total_Variance_Amount__c;
            this.Category =  claimLineItemRec.Category__c;
            
        }
    }
    
    public static List<String> getClaimFieldsList(){
        List<String> claimsFields = new List<String>{ 'Id',
                                                    'Name',
                                                    'Claim_Number__c',
                                                    'Notes__c',
                                                    'Claim_Disposition__c',
                                                    'Response_Date__c',
                                                    'Service_Order_Header__c',
                                                    'Provider_Claim_Number__c'
                                                };  
        return claimsFields;
    }
    
    
    public static List<String> getClaimLineItemFieldsList(){
        List<String> claimLineItemFieldList = new List<String>{ 'Id',
                                                            'Approved_Price__c',
                                                            'Approved_Qty__c',
                                                            'Approved_Subtotal__c',
                                                            'Claimed_Price__c',
                                                            'Claimed_Qty__c',
                                                            'Claimed_Subtotal__c',
                                                            'Item_Desc__c',
                                                            'Service_Order_Line_Item__c',
                                                            'SO_Payment_Role__c',
                                                            'Tax__c ',
                                                            'Tax_Amount__c',
                                                            'Variance__c ',
                                                            'Claim__c ',
                                                            'SO_Payment_Role__r.Total_Amount__c',
                                                            'Variance_Qty__c',
                                                            'Variance_Amount__c',
                                                            'Is_Variance__c',
                                                            'SO_Payment_Role__r.RecordType.DeveloperName',
                                                            'SO_Payment_Role__r.Status__c',
                                                            'Total_Variance_Amount__c',
                                                            'Category__c'
                                                };  
        return claimLineItemFieldList;
    }
}