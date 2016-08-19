public with sharing class SOPaymentWrapper {

    public String Id;
    public Decimal DeductibleAmount;
    public String ServiceOrderHeader;
    public String  DeductibleStatus;
    public Decimal TaxAmount;
    public Decimal Variance;
    public String RecordTypeId;
    public Decimal Quantity;
    
    
    public SOPaymentWrapper(SO_Payment_Role__c soPaymentRoleRec){
        this.Id = soPaymentRoleRec.Id;
        this.DeductibleAmount = soPaymentRoleRec.Total_Amount__c;
        this.ServiceOrderHeader = soPaymentRoleRec.Service_Order_Header__c;
        this.DeductibleStatus = soPaymentRoleRec.Deductible_Status__c;
        this.TaxAmount = soPaymentRoleRec.Tax_Amount__c;
        this.Variance = soPaymentRoleRec.Variance__c;
        this.RecordTypeId = soPaymentRoleRec.RecordTypeId;
        this.Quantity = soPaymentRoleRec.Qty__c;
        
    }
    
    public static List<String> getSOPaymentRoleFieldsList(){
        List<String> soPaymentRoleFields = new List<String>{ 'Id',
                                                        'Total_Amount__c',
                                                        'Service_Order_Header__c',
                                                        'Deductible_Status__c',
                                                        'Tax_Amount__c',
                                                        'Variance__c',
                                                        'RecordTypeId',
                                                        'RecordType.DeveloperName',
                                                        'Qty__c'
                                                };  
        return soPaymentRoleFields;
    }
    
}