public with sharing class SOWizard {
    
    public SOSignInWizard Sign_In;
    public SOSignInWizard Ready_to_Submit;
    
    public SOWizard(Service_Order_Header__c soHeaderRec, String wizardName) {
        if(wizardName == 'Sign_In') {
            this.Sign_In = new SOSignInWizard(soHeaderRec);
        } else if(wizardName == 'Service_Sign_Out') {
            this.Sign_In = new SOSignInWizard(soHeaderRec.CustomerApprovals__r);
        } else if(wizardName == 'Claim_Submission') {
            this.Ready_to_Submit = new SOSignInWizard(soHeaderRec.CustomerApprovals__r);
        }
        
    }
    
    
    public class SOSignInWizard {
        
        public SOInfo Service_Information;
        public SOSignIn Sign_In_Unit;
        public List<CustomerApproval> Approval_Method;
        
        /*public SOApproval Approval_Method;
        public SODSApproval Digital_Signature_Approval;
        public SOPrintApproval Print_Approval;
        public SORemoteApproval Remotely_Approval;*/
        
        public SOSignInWizard(Service_Order_Header__c soHeaderRec) {
            Service_Information = new SOInfo(soHeaderRec);
            Sign_In_Unit = new SOSignIn(soHeaderRec);
            
            this.Approval_Method = new List<CustomerApproval>();
            for(CustomerApproval__c custApprovalRec : soHeaderRec.CustomerApprovals__r ){
                this.Approval_Method.add(new CustomerApproval(custApprovalRec) );
            }
        }
        
        
        public SOSignInWizard(List<CustomerApproval__c> custApprovalRecList) {
            this.Approval_Method = new List<CustomerApproval>();
            for(CustomerApproval__c custApprovalRec : custApprovalRecList){
                this.Approval_Method.add(new CustomerApproval(custApprovalRec) );
            }
        }
    }
    
    public class SOInfo {
        
        public String Id;
        public String Name;
        public Decimal Total;
        public List<String> ManualConcern;
        public List<String> ManualCorrection; 
        public List<String> ManualCause;
        
        public List<String> KitHeaderCause;
        public List<String> KitHeaderConcern;
        public List<String> KitHeaderCorrection;
        
        public String PromisedBy;
        public String IsPromisedByAmPm;
        public Decimal EstimatedHours;
        public String TransactionTypeId;
        public String TransactionType;
        public String COUId;
        public String ProviderId;
        public String CategoryId;
        public String CategoryName;
        public String Stock;
        public String Status;
        public Boolean IsCompletedLinkShown;
        
        public SOInfo(Service_Order_Header__c soHeaderRec) {
            this.Id = soHeaderRec.Id;
            this.Name = soHeaderRec.Name__c;
            this.Total = 0;
            this.ManualConcern = (soHeaderRec.Concern__c != null) ? soHeaderRec.Concern__c.split('\n') : new List<String>();
            this.ManualCorrection = (soHeaderRec.Correction__c != null) ? soHeaderRec.Correction__c.split('\n') : new List<String>();
            this.ManualCause = (soHeaderRec.Cause__c != null) ? soHeaderRec.Cause__c.split('\n') : new List<String>();
            if(soHeaderRec.Customer_Owned_Unit__c != null) {
                this.COUId = soHeaderRec.Customer_Owned_Unit__c;
            }
            
            //this.ProviderId = soHeaderRec.Provider__c;
            if(soHeaderRec.Category__c != null) {
                this.CategoryName = soHeaderRec.Category__r.Name;
                this.CategoryId = soHeaderRec.Category__c;
            } 
            this.KitHeaderCause = new List<String>();
            this.KitHeaderConcern = new List<String>();
            this.KitHeaderCorrection = new List<String>();
            
            if(soHeaderRec.Service_Order_Kit_Headers__r.size() > 0) {
                for(Service_Order_Kit_Header__c soKitHeaderRec : soHeaderRec.Service_Order_Kit_Headers__r) {
                    if(soKitHeaderRec.Kit_Header__c != null) {
                        this.KitHeaderCause = (soKitHeaderRec.Kit_Header__r.Cause__c != null) ? soKitHeaderRec.Kit_Header__r.Cause__c.split('\n') : new List<String>();
                    }
                    if(soKitHeaderRec.Kit_Header__c != null) {
                        this.KitHeaderConcern = (soKitHeaderRec.Kit_Header__r.Concern__c != null) ? soKitHeaderRec.Kit_Header__r.Concern__c.split('\n') : new List<String>();
                    }
                    if(soKitHeaderRec.Kit_Header__c != null) {
                        this.KitHeaderCorrection = (soKitHeaderRec.Kit_Header__r.Correction__c != null) ? soKitHeaderRec.Kit_Header__r.Correction__c.split('\n') : new List<String>();
                    }
                }
            }
            this.EstimatedHours = ((soHeaderRec.Estimated_Hours__c == null) ? 0 : soHeaderRec.Estimated_Hours__c).setScale(1);
            this.Stock = 'No outstanding items';
            this.TransactionType = soHeaderRec.Transaction_Type__r.Type__c;
            this.TransactionTypeId = soHeaderRec.Transaction_Type__c;
            this.PromisedBy = (soHeaderRec.Promised_By__c != null) ? soHeaderRec.Promised_By__c.format('MM/dd/yyyy hh:mm a') : null; 
            this.IsPromisedByAmPm = soHeaderRec.IsPromisedBy_AmPm__c;
            this.Status = soHeaderRec.Status__c;
            this.IsCompletedLinkShown = true;
            
            for(Service_Order_Line_Item__c soli : soHeaderRec.Service_Order_Line_Items__r) {
                if(soli.Total__c != null) {
                    this.Total += soli.Total__c;
                    if(soli.Labour_Code__c != null) {
                        Decimal tax = soli.Labour_Tax_Amount__c;
                        this.Total += tax; 
                    } else if(soli.Tax__c != null) {
                        Decimal tax = soli.Total__c * soli.Tax__c / 100;
                        this.Total += tax;
                    }
                }
                if(soli.Qty_To_Order__c > 0) {
                    this.IsCompletedLinkShown = false;
                }
            }
        }
    }
    
    
    public class SOSignIn {
        
        public String Id;
        public Decimal Odometer;
        
        public SOSignIn(Service_Order_Header__c soHeaderRec) {
            this.Id = soHeaderRec.Id;
            this.Odometer = (soHeaderRec.Odometer_on_Arrival__c == null) ? 0 : soHeaderRec.Odometer_on_Arrival__c;
        }   
    }
    
    
    /*public class CustomerApproval{
        public String ApprovalId;
        public String Sign_InSectionName;
        public String Sign_InSectionKey;
        public String SOHeaderId ;
        public String ApprovalType  ;
        public String ApprovalDetailJson ;
        public String Notes ;
        public string Status;
        public String ApprovalDate;
        
        
        public CustomerApproval(CustomerApproval__c custApprovalRec){
            this.ApprovalId = custApprovalRec.Id;
            this.Sign_InSectionName =  custApprovalRec.Name;
            this.Sign_InSectionKey = custApprovalRec.Section_key__c;
            this.SOHeaderId = custApprovalRec.Service_Order_Header__c;
            this.ApprovalDetailJson = custApprovalRec.ApprovalDetailJson__c;
            this.Notes = custApprovalRec.Notes__c;
            this.Status = custApprovalRec.Status__c;
            this.ApprovalDate =custApprovalRec.LastModifiedDate.format('MM/dd/YYYY');
            this.ApprovalType = custApprovalRec.ApprovalType__c;
        }
    }*/
    
    
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be queried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> appLogFieldsList(){
        List<String> appLogFieldList = new List<String>{    'Id', 
                                                            'Field__c',
                                                            'Old_Value__c',
                                                            'New_Value__c',
                                                            'Notes__c',
                                                            'Service_Order_Header__c',
                                                            'Service_Order_Header__r.Name'
                                                };
        return appLogFieldList;
    }
    
    /**
     * Name: getSOHeaderFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getSOHeaderFieldsList(){
        List<String> soHeaderFields = new List<String>{ 'Id',
                                                        'Name__c',
                                                        'Cause__c',
                                                        'Concern__c',
                                                        'Correction__c',
                                                        'Promised_By__c',
                                                        'Total__c',
                                                        'Stock__c',
                                                        'Estimated_Hours__c',
                                                        'Customer_Owned_Unit__c',
                                                        'Customer_Owned_Unit__r.VIN__c',
                                                        'CO_Header__c',
                                                        'Category__c',
                                                        'Category__r.Name',
                                                        'Odometer_on_Arrival__c',
                                                        'Odometer_on_Departure__c',
                                                        'Transaction_Type__c',
                                                        'Notes_For_Customer__c',
                                                        'Transaction_Type__r.Type__c',
                                                        'IsPromisedBy_AmPm__c',
                                                        'Status__c',
                                                        'Notes__c',
                                                        'Work_Status__c',
                                                        'Claim_Status__c'
                                                };
        return soHeaderFields;
    }
    
    
    public static Map<String, String> overridenStatusToNextStatusMap = 
                                new Map<String , String> {  'New'           =>  'Ready',
                                                            'Ready'         => 'In Progress',
                                                            'In Progress'   => 'On Hold',
                                                            'On Hold'       => 'Complete',
                                                            'Complete'      => 'Reviewed',
                                                            'Reviewed'      => 'Signed Out',
                                                            'Signed Out'    => 'Invoiced',
                                                            'Invoiced'      => 'Invoiced' 
                                                            };                                              
    
    /**
     * Name: SOInfoWrapper
     * Desc : Wrapper Class For SO Wizard
    **/
    public class SOInfoWrapper{
        public String WorkStatus;
        public String ClaimStatus;
        public List<AvailableStatus> AvailableWorkStatusList;
        public List<AvailableStatus> AvailableClaimStatusList;
        
        public SOInfoWrapper(String WorkStatus, String ClaimStatus, List<String> availableWorkStatusList, List<String> availableClaimStatusList ){
            this.WorkStatus = WorkStatus;
            this.ClaimStatus = ClaimStatus;
            this.AvailableWorkStatusList = new List<AvailableStatus>();
            for(String status : availableWorkStatusList) {
                this.AvailableWorkStatusList.add(new AvailableStatus(status));
            }
            
            this.AvailableClaimStatusList = new List<AvailableStatus>();
            for(String status : availableClaimStatusList) {
                this.AvailableClaimStatusList.add(new AvailableStatus(status));
            }
        }
    }
    
    public class AvailableStatus {
        public String AvailableStatus;
        public String StatusUniqueKey;
        
        public AvailableStatus(String availableStatus) {
            this.AvailableStatus = availableStatus;
            this.StatusUniqueKey = (availableStatus != null) ? availableStatus.replaceAll(' ', '_') : null;
        }
    }
    
    
    public class AppLog{
        public String Field;
        public String OldStatus;
        public String NewStatus;
        public String Notes;
        public String SOHeaderId;
        public String SOHeaderName;
        
        public AppLog(App_Log__c appLogRec){
            this.Field = appLogRec.Field__c;
            this.OldStatus = appLogRec.Old_Value__c;
            this.NewStatus = appLogRec.New_Value__c;
            this.Notes = appLogRec.Notes__c;
            this.SOHeaderId = appLogRec.Service_Order_Header__c;
            this.SOHeaderName = (appLogRec.Service_Order_Header__c != null) ? appLogRec.Service_Order_Header__r.Name : null;
        }
    }
    
    
    public class CustInfo {
        public String Label;
        public String Value;
        public String Type;
        public Boolean IsSelected;
        
        
        public CustInfo() {
            
        }
    }
}