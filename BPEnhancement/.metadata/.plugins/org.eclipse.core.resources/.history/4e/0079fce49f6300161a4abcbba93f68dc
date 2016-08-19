public with sharing class CustomerApproval {
	
 	public String ApprovalId;
	public String SectionName;
	public String SectionKey;
	public String ServiceOrderHeader;
	public String ApprovalType ;
	public String ApprovalDetailJson ;
	public String Notes ;
	public string Status;
	public String ApprovalDate;
	public String Id;
	public Boolean IsApprovalObtained;
	public Decimal ApprovalCount;
	
	public CustomerApproval(CustomerApproval__c customerApproval){
	 	this.Id =customerApproval.Id;
		this.ApprovalId	=	customerApproval.Name;
		this.ApprovalType = customerApproval.ApprovalType__c;
		this.ApprovalDetailJson =customerApproval.ApprovalDetailJson__c;
		this.SectionName = customerApproval.Section_Name__c;
		this.SectionKey = customerApproval.Section_key__c;
		this.ServiceOrderHeader =  (customerApproval.Service_Order_Header__c !=null) ? customerApproval.Service_Order_Header__c:null;
		this.Status = customerApproval.Status__c;
		this.Notes = customerApproval.Notes__c;
		this.ApprovalDate=customerApproval.LastModifiedDate.format('MMM dd, yyyy');
		
		if(customerApproval.Status__c != null && customerApproval.Status__c == 'Approved') {
			this.IsApprovalObtained = true;
		} else {
			this.IsApprovalObtained = false;
		}
		this.ApprovalCount = customerApproval.Approval_Count__c;
	}
}