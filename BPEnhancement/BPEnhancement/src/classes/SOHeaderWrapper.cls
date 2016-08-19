/**
* Author: Tarun Khandelwal
* Since: Dec 15, 2015
* Name: SOHeaderWrapper
* Description: Apex class which contains all JSON related oprations of Service Order
**/
public with sharing class SOHeaderWrapper {

	public List<SOWrapper> SOList;
	public List<String> PinnedItemList;
	public SO_KLI_Recalculation.Errorhandler error;
	
    // List of CO Invoice Items
    public List<COInvoiceItem> coInvoiceItemRecs; 
    
    // List of CO Line Items
    public List<SpecialOrder> specialOrderList;
    
    // CO Invoice Header Record.
    public COInvoiceHeader coInvoiceHeaderRec;
    
	/**
     * Name: SOHeaderWrapper
     * Desc: Constructor
     * @param:  (1) soHeaderRecList - List<Service_Order_Header__c> - List of service order header
     			(2)pinItems - List<String> - list of pin items
     			(3)soHeaderIdToSOKIListMap -  Map<Id, List<Service_Order_Kit_Header__c>> - map of service order kit with id
     			(4)coInvoiceHeader - List<CO_Invoice_Header__c> - List of  coinvoice header
     			(5)coInvoiceItems - List<CO_Invoice_Item__c> - List of coinvoice item  
     			(6)specialOrderList -List<CO_Line_Item__c> - List of coLine items
     * @return: 
    **/
	public SOHeaderWrapper(List<Service_Order_Header__c> soHeaderRecList, List<String> pinItems, Map<Id, List<Service_Order_Kit_Header__c>> soHeaderIdToSOKIListMap,
								List<CO_Invoice_Header__c> coInvoiceHeader, List<CO_Invoice_Item__c> coInvoiceItems, List<Vendor_Order_Line_Item__c> specialOrderList) {
		this.PinnedItemList = new List<String>();
		this.coInvoiceItemRecs = new List<COInvoiceItem>();
		this.specialOrderList = new List<SpecialOrder>(); 
		if(pinItems.size() > 0) {
			this.PinnedItemList.addAll(pinItems);
		}
		this.SOList = new List<SOWrapper>();
		//system.assert(false, soHeaderRecList);
		for(Service_Order_Header__c soHeaderRec : soHeaderRecList) {
			if(soHeaderIdToSOKIListMap.containsKey(soHeaderRec.Id)) {
				this.SOList.add(new SOWrapper(soHeaderRec, soHeaderIdToSOKIListMap.get(soHeaderRec.Id)));
			} else {
				this.SOList.add(new SOWrapper(soHeaderRec, new List<Service_Order_Kit_Header__c>()));
			}
        }
        
        Decimal deductibleTotal = 0;
        for(CO_Invoice_Item__c coInvoiceItemRecord : coInvoiceItems) {
        	if(coInvoiceItemRecord.CO_Line_Item__c != null && coInvoiceItemRecord.CO_Line_Item__r.Qty__c <= 0) {
        		//continue;
        	}
        	if(coInvoiceItemRecord.SO_Payment_Role__c != null && coInvoiceItemRecord.SO_Payment_Role__r.RecordType.DeveloperName == 'Deductible') {
        		deductibleTotal += coInvoiceItemRecord.SO_Payment_Role__r.Total_Amount__c;
        	}
        	this.coInvoiceItemRecs.add(new COInvoiceItem(coInvoiceItemRecord));
        }
        
        for(COInvoiceItem coInvoiceItemObj : coInvoiceItemRecs) {
        	if(coInvoiceItemObj.CheckoutType == Constants.CHECKOUT_TYPE_THIRD_PARTY) {
        		coInvoiceItemObj.Total = coInvoiceItemObj.Total - deductibleTotal;
        	}
        }
        
        for(CO_Invoice_Header__c coInvoiceHeaderRecord : coInvoiceHeader) {
        	this.coInvoiceHeaderRec = new COInvoiceHeader(coInvoiceHeaderRecord);
        }
        for(Vendor_Order_Line_Item__c specialOrderObj : specialOrderList) {
            this.specialOrderList.add(new SpecialOrder(specialOrderObj));
        }
        this.error = (CustomerOrderCtrl.error != null) ? CustomerOrderCtrl.error : new SO_KLI_Recalculation.Errorhandler('200', 'Success');
	}
	
	/**
     * Name: getDateTimeFromString
     * Desc: Get Date Time From String 
     * @param:  (1) dtStr - String - string contain date and time
     * @return: DateTime - date time Object 
    **/
	public static DateTime getDateTimeFromString(String dtStr) {
		List<String> dateTimeList = dtStr.split(' ');
		Integer day = Integer.valueOf(dateTimeList[0].split('/')[1]);
		Integer month = Integer.valueOf(dateTimeList[0].split('/')[0]);
		Integer year = Integer.valueOf(dateTimeList[0].split('/')[2]);
		Integer hour = Integer.valueOf(dateTimeList[1].split(':')[0]);
		Integer min = Integer.valueOf(dateTimeList[1].split(':')[1]);
		if(hour == 12) {
			hour -= 12;
		}
		if(dateTimeList[2] == 'PM') {
			hour += 12;
		}
		return datetime.newInstance(year, month, day, hour, min, 0);
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
                                                        'Provider__c',
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
    
    /**
     * Name: getSOKitHeaderFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getSOKitHeaderFieldsList(){
        List<String> soKitHeaderFields = new List<String>{ 	'Id',
	                                                        'Kit_Header__c',
	                                                        'Is_Fixed_Kit_Header_SO__c',
	                                                        'Kit_Header__r.Cause__c',
	                                                        'Kit_Header__r.Concern__c',
	                                                        'Kit_Header__r.Correction__c',
	                                                        'Can_Split__c',
	                                                        'Code__c',
	                                                        'Service_Kit__c',
	                                                        'Description__c',
	                                                        'Fixed_Price__c',
	                                                        'Fixed_Price_Flag__c',
	                                                        'Kit_Unique_Name__c',
	                                                        'Service_Order_Header__c',
	                                                        'CreatedDate',
	                                                        'Actual_Kit_Price__c',
	                                                        'Tax_amount__c'
                                                };
        return soKitHeaderFields;
    }
    
    /**
     * Name: getSOLineItemFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getSOLineItemFieldsList(){
        List<String> soLineItemFields = new List<String>{ 	'Id',
	                                                        'Fixed_Price__c',
	                                                        'Is_Fixed_Kit_LineItem_SO__c',
	                                                        'CO_Line_Item__c',
	                                                        'Item_Desc__c',
	                                                        'Kit_Price__c',
	                                                        'Labour_Code__c',
	                                                        'Part__c',
	                                                        'Part__r.AvailableParts__c',
	                                                        'Qty_Needed__c',
	                                                        'Qty_Committed__c',
	                                                        'Retail_Price__c',
	                                                        'Service_Order_Header__c',
	                                                        'Service_Order_Kit_Header__c',
	                                                        'Total__c',
	                                                        'CreatedDate',
	                                                        'CO_Line_Item__r.Special_Order__c',
	                                                        'CO_Line_Item__r.Closed_CO_Invoice_link__c',
	                                                        'Part__r.Vendor__c',
	                                                        'Fee__c',
	                                                        'Qty_To_Order__c',
	                                                        'Actual_Kit_Price__c',
	                                                        'Tax__c',
	                                                        'Tax_Percent__c',
	                                                        'Labour_Tax_Amount__c',
	                                                        'Kit_Price_With_Price_Level__c'
                                                };
        return soLineItemFields;
    }
    
    /**
     * Name: getProviderFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getProviderFieldsList(){
        List<String> providerFields = new List<String>{ 'Id',
                                                        'Name__c',
                                                        'Phone__c',
                                                        'Email__c',
                                                        'Transaction_Type__c'
                                                };
        return providerFields;
    }
    
    
    /**
     * Name: getHoursLoggedFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getHoursLoggedFieldsList(){
        List<String> hoursLoggedFields = new List<String>{ 'Id',
                                                        'Employee__c',
                                                        'Employee__r.Name',
                                                        'Notes__c',
                                                        'Original_Estimate__c',
                                                        'Previously_Logged__c',
                                                        'Remaining_Estimate__c',
                                                        'Remaining_Estimate_d__c',
                                                        'Remaining_Estimate_h__c',
                                                        'Remaining_Estimate_m__c',
                                                        'Service_Order_Header__c',
                                                        'Time_Spent__c',
                                                        'Time_Spent_d__c',
                                                        'Time_Spent_h__c',
                                                        'Time_Spent_m__c',
                                                        'CreatedDate',
                                                        'Work_Performed_Date__c',
                                                        'Service_Order_Header__r.Status__c',
                                                        'Name',
                                                        'Notes_Required__c'
                                                };
        return hoursLoggedFields;
    }
    
    /**
     * Name: getHoursLoggedFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
 	 public static List<String> getCustomerApprovalList(){
        List<String> customerApprovalFields = new List<String>{ 'Id',
                                                        'Name',
                                                        'Notes__c',
                                                        'Section_key__c',
                                                        'Section_Name__c',
                                                        'Service_Order_Header__c',
                                                        'Status__c',
                                                        'ApprovalType__c',
                                                        'ApprovalDetailJson__c',
                                                        'LastModifiedDate',
                                                        'Approval_Count__c'
                                                };
        return customerApprovalFields;
    }
    
    
    /**
     * Name: getAttachmentList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
 	 public static List<String> getAttachmentList(){
        List<String> attachmentFields = new List<String>{ 'Id',
                                                        'Name',
                                                        'Description',
                                                        'CreatedDate'
                                                };
        return attachmentFields;
    }
    
    /**
     * Name: getCOInvoiceItemList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
 	 public static List<String> getCOInvoiceItemList(){
        List<String> coInvoiceItemList = new List<String>{ 'Id',
                                                        'Invoice_Header_Status__c'
                                                };
        return coInvoiceItemList;
    }
    
    /**
     * Name: getTTFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getTTFieldsList(){
        List<String> ttFields = new List<String>{ 	'Id',
                                                	'Type__c'
                                                };
        return ttFields;
    }


	public static List<String> getSOPaymentRoleFieldsList(){
		List<String> soPaymentRoleFields = new List<String>{ 'Id',
														'Total_Amount__c',
		                                                'Service_Order_Header__c',
		                                                'Status__c',
		                                                'Deductible_Status__c',
		                                                'Tax_Amount__c',
		                                                'Variance__c',
		                                                'RecordTypeId ',
		                                                'RecordType.DeveloperName',
		                                                'Service_Order_Header__r.CO_Header__c'
		                                        };  
		return soPaymentRoleFields;
	}
	/**

	* Name: SOWrapper
	* Description: Apex class which contains all JSON related oprations of Service Order
	**/
	public class SOWrapper {
		public SOHeader SOHeaderInfo;
		public SOSignIn SOSignInRec;
		public SOReview SOReviewRec;
		public List<SOGrid> SOGridItems;
		public List<HoursLogged> HoursLoggedList;
		public List<CustomerApproval> CustomerApprovalList;
		public List<Attachments> AttachmentList;
		public Deductible DeductibleItem;
		
		/**
     	* Name: SOWrapper
     	* Desc: Constructor
    	* @param:	(1)soRec -  Service_Order_Header__c - Service order header Record
					(2)soKitHeaderList -List<Service_Order_Kit_Header__c> - List of Service Order kit 	    			
    	* @return: 
   		**/
		public SOWrapper(Service_Order_Header__c soRec, List<Service_Order_Kit_Header__c> soKitHeaderList) {
			this.SOHeaderInfo = new SOHeader(soRec);
			this.SOSignInRec = new SOSignIn(soRec);
			this.SOReviewRec = new SOReview(soRec);
			this.SOGridItems = new List<SOGrid>();
			this.HoursLoggedList = new List<HoursLogged>();
			this.CustomerApprovalList = new List<CustomerApproval>();
			this.AttachmentList = new List<Attachments>();
			this.DeductibleItem = new Deductible(soRec);
			if(soKitHeaderList == null) {
				soKitHeaderList = new List<Service_Order_Kit_Header__c>();
			}
			List<DateTime> sortedDateTimeList = new List<dateTime>();
			Set<Id> soliIdSet = new Set<Id>();
			for(Service_Order_Kit_Header__c soKHRec : soKitHeaderList) {
				sortedDateTimeList.add( soKHRec.CreatedDate );
				
				this.SOGridItems.add(new SOGrid(soKHRec, soKHRec.Service_Order_Line_Items__r, true));
            	for(Service_Order_Line_Item__c soliRec : sokhRec.Service_Order_Line_Items__r) {
            		soliIdSet.add(soliRec.Id);
            	} 
			}
			Integer lastIndexValue = 0;
			system.debug('Sorting Started OF SOLIs -->>');
			system.debug(sortedDateTimeList);
			for(Service_Order_Line_Item__c soliRec : soRec.Service_Order_Line_Items__r) {
        		if(!soliIdSet.contains(soliRec.Id)) {
        			for(Integer i = lastIndexValue; i < sortedDateTimeList.size(); i++){
        				system.debug(i);
        				if(sortedDateTimeList[i] < soliRec.CreatedDate){
        					lastIndexValue ++;
        				} else {
        					break;
        				}
        			}
        			if(this.SOGridItems.size() > lastIndexValue){
        				this.SOGridItems.add(lastIndexValue, new SOGrid(new Service_Order_Kit_Header__c(), new List<Service_Order_Line_Item__c>{soliRec}, false));
        				
        				if(sortedDateTimeList.size() > lastIndexValue){
        					sortedDateTimeList.add(lastIndexValue, soliRec.CreatedDate);
        				} else {
        					sortedDateTimeList.add(soliRec.CreatedDate);
        				}
        				
        				lastIndexValue++;
        			} else {
        				this.SOGridItems.add(new SOGrid(new Service_Order_Kit_Header__c(), new List<Service_Order_Line_Item__c>{soliRec}, false));
        				lastIndexValue++;
        			}
        		}
        	}
        	
        	
        	for(Hours_Logged__c hoursLogged : soRec.Hours_Logged__r) {
        		this.HoursLoggedList.add(new HoursLogged(hoursLogged));
			}
			for(CustomerApproval__c approvalRec : soRec.CustomerApprovals__r) {
				if(approvalRec.ApprovalType__c != 'Submit_Claim') {
					this.CustomerApprovalList.add(new CustomerApproval(approvalRec));
				}
			}
			for(Attachment attchmentRec : soRec.Attachments) {
				this.AttachmentList.add(new Attachments(attchmentRec));
			}
		}
	}
	
	/**

	* Name: SOHeader
	* Description: Apex class which contains all JSON related oprations of Service Order
	**/
	public class SOHeader {
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
		
		public String WorkStatus;
		public List<AvailableStatus> AvailableWorkStatusList;
		public String ClaimStatus;
		public List<AvailableStatus> AvailableClaimStatusList;
		public String InvoiceStatus;
		
		/**
     	* Name: SOHeader
     	* Desc: Constructor
    	* @param:	(1)soHeaderRec -  Service_Order_Header__c - Service order header Record
    	* @return: 
   		**/		
		public SOHeader(Service_Order_Header__c soHeaderRec) {
			this.Id = soHeaderRec.Id;
			this.Name = soHeaderRec.Name__c;
			this.Total = 0;
			this.ManualConcern = (soHeaderRec.Concern__c != null) ? soHeaderRec.Concern__c.split('\n') : new List<String>();
			this.ManualCorrection = (soHeaderRec.Correction__c != null) ? soHeaderRec.Correction__c.split('\n') : new List<String>();
			this.ManualCause = (soHeaderRec.Cause__c != null) ? soHeaderRec.Cause__c.split('\n') : new List<String>();
			if(soHeaderRec.Customer_Owned_Unit__c != null) {
				this.COUId = soHeaderRec.Customer_Owned_Unit__c;
			}
			this.ProviderId = soHeaderRec.Provider__c;
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
			for (Service_Order_Line_Item__c soli : soHeaderRec.Service_Order_Line_Items__r) {
				if (soli.Total__c != null) {
					if (soli.Tax_Percent__c == null) {
						soli.Tax_Percent__c = 0;
					}
					this.Total += (soli.Total__c != null) ? soli.Total__c : 0;
					this.Total += ((soli.Total__c * soli.Tax_Percent__c) / 100);
					this.Total = this.Total.setScale(2);
				}
				if(soli.Qty_To_Order__c > 0) {
					this.IsCompletedLinkShown = false;
				}
			}
			
			this.WorkStatus = soHeaderRec.Work_Status__c;
			if(this.WorkStatus != null && Constants.workStatusToAvailableStatusMap.containsKey(this.WorkStatus)) {
				this.AvailableWorkStatusList = new List<AvailableStatus>();
				for(String status : Constants.workStatusToAvailableStatusMap.get(this.WorkStatus)) {
            		this.AvailableWorkStatusList.add(new AvailableStatus(status));
            	}
			} else {
				this.AvailableWorkStatusList = new List<AvailableStatus>();
			}
			
			this.ClaimStatus = soHeaderRec.Claim_Status__c;
			if(this.ClaimStatus != null && Constants.claimStatusToAvailableStatusMap.containsKey(this.ClaimStatus)) {
				this.AvailableClaimStatusList = new List<AvailableStatus>();
	            for(String status : Constants.claimStatusToAvailableStatusMap.get(this.ClaimStatus)) {
	            	this.AvailableClaimStatusList.add(new AvailableStatus(status));
	            }
			} else {
				this.AvailableClaimStatusList = new List<AvailableStatus>();
			}
			
			// Invoice Status based on CO Invoice Item of SOHeader
			if(soHeaderRec.CO_Invoice_Items__r.size() > 0) {
				this.InvoiceStatus = soHeaderRec.CO_Invoice_Items__r[0].Invoice_Header_Status__c;
			}
		}
	}
	
	public class AvailableStatus {
    	public String AvailableStatus;
    	public String StatusUniqueKey; 
    	
    	public AvailableStatus(String status) {
    		this.AvailableStatus = status;
    		this.StatusUniqueKey = (status != null) ? status.replaceAll(' ', '_') : null;
    	}
    }

	/**
	* Name: SOSignIn
	* Description: Apex class service order sign in 
	**/
	public class SOSignIn {
		public String Id;
		public Decimal Odometer;
		
		/**
     	* Desc: Constructor
   		**/	
		public SOSignIn(Service_Order_Header__c soHeaderRec) {
			this.Id = soHeaderRec.Id;
			this.Odometer = (soHeaderRec.Odometer_on_Arrival__c == null) ? 0 : soHeaderRec.Odometer_on_Arrival__c;
		}	
	}
	
	/**
	* Name: SOReview
	* Description: Apex class service order review
	**/
	public class SOReview {
		
		public Decimal OdometerOnDeparture;
		public String Id;
		public List<String> KitHeaderNotes;
		public List<String> ManualNotes;
		
		/**
     	* Name: SOReview
     	* Desc: Constructor
    	* @param:	(1)soHeaderRec -  Service_Order_Header__c - Service order header Record
    	* @return: 
   		**/	
		public SOReview(Service_Order_Header__c soHeaderRec) {
			this.KitHeaderNotes = new List<String>();
			this.ManualNotes = new List<String>();
			this.Id = soHeaderRec.Id;
			this.OdometerOnDeparture = (soHeaderRec.Odometer_on_Departure__c == null) ? 0 : soHeaderRec.Odometer_on_Departure__c;
			
			if(soHeaderRec.Service_Order_Kit_Headers__r.size() > 0) {
				for(Service_Order_Kit_Header__c soKitHeaderRec : soHeaderRec.Service_Order_Kit_Headers__r) {
					if(soKitHeaderRec.Kit_Header__c != null) {
						this.KitHeaderNotes = (soKitHeaderRec.Kit_Header__r.Correction__c != null) ? soKitHeaderRec.Kit_Header__r.Correction__c.split('\n') : new List<String>();
					}
				}
			}
			this.ManualNotes = (soHeaderRec.Notes_For_Customer__c != null) ? soHeaderRec.Notes_For_Customer__c.split('\n') : new List<String>();
		}
	}
	
	/**
	* Name: SOGrid
	* Description: Apex class Service Order Grid
	**/
	public class SOGrid {
		
		public SOKitHeader SOKH;
		
		/**
     	* Name: SOGrid
     	* Desc: Constructor
    	* @param:	(1)soKitHeaderRec -  Service_Order_Kit_Header__c - Service order Kit Header Record
					(2)soliList -List<Service_Order_Kit_Header__c> - List of Service Order Kit Header
					(3)hasChildren - Boolean  - has Children or not    			
    	* @return: 
   		**/
		public SOGrid(Service_Order_Kit_Header__c soKitHeaderRec, List<Service_Order_Line_Item__c> soliList, Boolean hasChildren) {
			this.SOKH = new SOKitHeader(soKitHeaderRec, soliList, hasChildren);
		}
	}
	
	/**
	* Name: SOKitHeader
	* Description: Apex class Service Order Kit Header
	**/
	public class SOKitHeader {
		
		public List<SOLineItem> SOLIList;
		public String ItemDescription;
		public Boolean CanItSplit;
		public String Code;
		public Boolean IsServiceKit;
		public String Id;
		public Decimal FixedPrice;
		public Decimal RetailPrice;
		public Boolean IsFixedPrice; 
		public Boolean hasChildren;
		public Boolean isFixedKitHeaderSO;
		public Decimal taxAmount;
		/**
     	* Name: SOKitHeader
     	* Desc: Constructor
    	* @param:	(1)soKitHeaderRec -  Service_Order_Kit_Header__c - Service order Kit Header Record
					(2)soliList -List<Service_Order_Line_Item__c>- List of Service Order Line Items
					(3)hasChildren - Boolean  - has Children or not    			
    	* @return: 
   		**/
		public SOKitHeader(Service_Order_Kit_Header__c soKitHeaderRec, List<Service_Order_Line_Item__c> soliList, Boolean hasChildren) {
			Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
			this.SOLIList = new List<SOLineItem>();
			this.taxAmount = soKitHeaderRec.Tax_Amount__c;
			this.ItemDescription = soKitHeaderRec.Kit_Unique_Name__c;
			this.CanItSplit = soKitHeaderRec.Can_Split__c;
			this.IsServiceKit = soKitHeaderRec.Service_Kit__c;
			this.Code = soKitHeaderRec.Code__c;
			this.Id = soKitHeaderRec.Id;
			if (!isTaxIncludingPricing) {
				this.FixedPrice = (soKitHeaderRec.Fixed_Price__c != null) ? soKitHeaderRec.Fixed_Price__c.SetScale(2) : soKitHeaderRec.Fixed_Price__c;
			} else {
				if (soKitHeaderRec.Fixed_Price__c == null) {
					soKitHeaderRec.Fixed_Price__c = 0;
				}
				if (soKitHeaderRec.Tax_Amount__c == null) {
					soKitHeaderRec.Tax_Amount__c = 0;
				}
				//system.assert(false,soKitHeaderRec);
				this.FixedPrice = (soKitHeaderRec.Fixed_Price__c + soKitHeaderRec.Tax_Amount__c).setscale(2);
			}
			//this.isFixedKitHeaderSO = soKitHeaderRec.Is_Fixed_Kit_Header_SO__c;
			
			this.IsFixedPrice = soKitHeaderRec.Fixed_Price_Flag__c;
			for(Service_Order_Line_Item__c soliRec : soliList) {
				this.SOLIList.add(new SOLineItem(soliRec));
			}
			this.hasChildren = hasChildren;
		}
	}
	
	/**
	* Name: SOLineItem
	* Description: Apex class Service Order Line Item
	**/
	public class SOLineItem {
		
		public String ItemDesc;
		public String Status;
		public Decimal QtyNeeded;
		public Decimal StockCommited;
		public Decimal QtyOrder;
		public Decimal ReatilPrice;
		public Decimal SubTotal;
		public Boolean IsFixedPrice;
		public Decimal AvailablePart;
		public String PartId;
		public Boolean IsPart;
		public Boolean IsLabour;
		public Boolean IsFee;
		public String Id;
		public String SOKitHeaderId;
		public Decimal KitPrice;
		public String VendorId;
		public String CoLineItem;
		public Boolean isFixedKitHeaderLineItemSO;
		public Decimal Tax;
		/**
     	* Name: SOLineItem
     	* Desc: Constructor
    	* @param:	(1)soLineItemRec - Service_Order_Line_Item__c - Service Order Line Item Record
    	* @return: 
   		**/
		public SOLineItem(Service_Order_Line_Item__c soLineItemRec) {
			this.Id = soLineItemRec.Id; 
			this.VendorId=soLineItemRec.Part__r.Vendor__c;
			this.ItemDesc = soLineItemRec.Item_Desc__c;
			this.isFixedKitHeaderLineItemSO = soLineItemRec.Is_Fixed_Kit_LineItem_SO__c;
			this.QtyNeeded = (soLineItemRec.Qty_Needed__c != null ) ? soLineItemRec.Qty_Needed__c : 0;
			this.StockCommited = (soLineItemRec.Qty_Committed__c != null) ? soLineItemRec.Qty_Committed__c : 0;
			this.IsPart = (soLineItemRec.Part__c != null) ? true : false;
			this.IsLabour = (soLineItemRec.Labour_Code__c != null) ? true : false;
			this.IsFee = (soLineItemRec.Fee__c != null) ? true : false;

			if (this.IsLabour || this.IsFee) {
				this.StockCommited = this.QtyNeeded;
			}
			if(soLineItemRec.CO_Line_Item__r.Closed_CO_Invoice_link__c != null) {
				this.Status = 'Invoiced'; 
			} else {
				if(this.QtyNeeded == this.StockCommited) {
					this.Status = 'In Stock';
				} else if(this.QtyNeeded > this.StockCommited) {
					if(soLineItemRec.CO_Line_Item__c != null && !soLineItemRec.CO_Line_Item__r.Special_Order__c) {
						this.Status = 'Required';
					} else {
						this.Status = 'Ordered';
					}
				} else if(soLineItemRec.Qty_Needed__c < 0) {
		        	this.Status = 'RETURN';
		        }
			}
			
			this.QtyOrder = (this.StockCommited != null && this.QtyNeeded != null) ? (this.QtyNeeded - this.StockCommited) : 0;
			
			if(soLineItemRec.Qty_Needed__c < 0) {
				this.QtyOrder = null;
				this.StockCommited = null;
			}
			this.Tax = soLineItemRec.Tax_Percent__c;
            
            Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            
            if(isTaxIncludingPricing) {
                if(this.Tax == null) {
                    this.Tax = 0;
                }
                if(soLineItemRec.Kit_Price__c == null) {
                    soLineItemRec.Kit_Price__c = 0;
                }
                this.KitPrice = (soLineItemRec.Kit_Price__c * (1 + (this.Tax / 100))).setScale(2);
            } else {
                this.KitPrice = (soLineItemRec.Kit_Price__c != null) ? soLineItemRec.Kit_Price__c.SetScale(2) : soLineItemRec.Kit_Price__c;
            }
            this.ReatilPrice = (soLineItemRec.Retail_Price__c != null) ? soLineItemRec.Retail_Price__c.SetScale(2) : soLineItemRec.Retail_Price__c;
			this.IsFixedPrice = soLineItemRec.Fixed_Price__c;
			this.PartId = soLineItemRec.Part__c;
			this.AvailablePart = (soLineItemRec.Part__c != null) ? (soLineItemRec.Part__r.AvailableParts__c) : null;
			this.IsPart = (soLineItemRec.Part__c != null) ? true : false;
			this.IsLabour = (soLineItemRec.Labour_Code__c != null) ? true : false;
			this.IsFee = (soLineItemRec.Fee__c != null) ? true : false;
			this.SOKitHeaderId = soLineItemRec.Service_Order_Kit_Header__c;
			this.CoLineItem = (soLineItemRec.CO_Line_Item__c !=null) ? (soLineItemRec.CO_Line_Item__c ) : null;
		}
	}
	
	/**
	* Name: HoursLogged
	* Description: Apex class Hours Logged
	**/
	public class HoursLogged {
		
		public String EmployeeId;
		public String EmployeeName;
		public String Notes;
		public String OriginalEstimate;
		public String PreviouslyLogged;
		public Decimal RemainingEstimate_D;
		public Decimal RemainingEstimate_H;
		public Decimal RemainingEstimate_M;
		public String SOHeaderId;
		public String TimeSpent;
		public Decimal TimeSpent_D;
		public Decimal TimeSpent_H;
		public Decimal TimeSpent_M;
		public String WorkPerformedDate;
		public String CreatedDate;
		public String Id;
		public String Log; 
		public String SOHeaderStatus;
		public Boolean NotesRequired;
		
		/**
     	* Name: HoursLogged
     	* Desc: Constructor
    	* @param:	(1)hoursLoggedRec - Hours_Logged__c - hours logged Record
    	* @return: 
   		**/
		public HoursLogged(Hours_Logged__c hoursLoggedRec) {
			this.Id = hoursLoggedRec.Id;
			if(hoursLoggedRec.Employee__c == null) {
				this.EmployeeName = UserInfo.getFirstName() +' '+ UserInfo.getLastName();
				this.EmployeeId = UserInfo.getUserId();
			} else {
				this.EmployeeName = hoursLoggedRec.Employee__r.Name;
				this.EmployeeId = hoursLoggedRec.Employee__c;
			}
			this.Notes= hoursLoggedRec.Notes__c;
			this.OriginalEstimate = hoursLoggedRec.Original_Estimate__c;
			this.PreviouslyLogged = hoursLoggedRec.Previously_Logged__c;
			this.RemainingEstimate_D = hoursLoggedRec.Remaining_Estimate_d__c;
			this.RemainingEstimate_H = hoursLoggedRec.Remaining_Estimate_h__c;
			this.RemainingEstimate_M = hoursLoggedRec.Remaining_Estimate_m__c;
			this.SOHeaderId = hoursLoggedRec.Service_Order_Header__c;
			this.TimeSpent = hoursLoggedRec.Time_Spent__c;
			this.TimeSpent_D = hoursLoggedRec.Time_Spent_d__c;
			this.TimeSpent_H = hoursLoggedRec.Time_Spent_h__c;   
			this.TimeSpent_M = hoursLoggedRec.Time_Spent_m__c;
			if(hoursLoggedRec.Work_Performed_Date__c != null) {
				this.WorkPerformedDate = (DateTime.newInstance(hoursLoggedRec.Work_Performed_Date__c.Year(), hoursLoggedRec.Work_Performed_Date__c.Month(), hoursLoggedRec.Work_Performed_Date__c.Day())).format('MM/dd/yyyy');
			}
			this.CreatedDate = hoursLoggedRec.CreatedDate.format('MMM dd, yyyy');
			this.Log = hoursLoggedRec.Name;
			this.SOHeaderStatus = hoursLoggedRec.Service_Order_Header__r.Status__c;
			this.NotesRequired = hoursLoggedRec.Notes_Required__c ;
		}
	}
	
	
	public class Attachments {
		public String UploadedDate;
		public String AttachmentName;
		public String AttachmentId;
		public String Source;
		
		public Attachments(Attachment attachmentRec) {
			this.UploadedDate = attachmentRec.CreatedDate.format('MM/dd/YYYY');
			this.AttachmentName = attachmentRec.Name;
			this.AttachmentId = attachmentRec.Id;
			this.Source = attachmentRec.Description;
		}
	}
	
	/**
	* Name: SOMasterData
	* Description: Apex class Service Order Master Data
	**/
	public class SOMasterData {
		public List<SOHeaderWrapper.TTType> TTList;
		public List<CustomerOwnedUnit> COUList;
		public List<SOHeaderWrapper.VendorAsProvider> ProviderList;
		public String DefaultInternalCategoryName;
		public String DefaultInternalCategoryId;
			
		/**
     	* Name: SOMasterData
     	* Desc: Constructor
    	* @param:	(1)ttRecList - List<Transaction_Type__c> - Transaction Type List
    	*			(2)couList - List<Customer_Owned_Unit__c> - Customer Owned Unit Record
    	* @return: 	
   		**/
		public SOMasterData(List<Transaction_Type__c> ttRecList, List<Customer_Owned_Unit__c> couList, List<Account> providerList, List<Category__c> internalDefaultCategoryList) {
			this.TTList = new List<SOHeaderWrapper.TTType>();
			this.COUList = new List<CustomerOwnedUnit>();
			this.ProviderList = new List<SOHeaderWrapper.VendorAsProvider>();
			for(Transaction_Type__c ttRec : ttRecList) {
				this.ttList.add(new SOHeaderWrapper.TTType(ttRec));
			}
			for(Customer_Owned_Unit__c couRec : couList) { 
	        	this.COUList.add(new CustomerOwnedUnit(couRec));
	        }
	        for(Account providerRec : providerList) {
	        	this.ProviderList.add(new SOHeaderWrapper.VendorAsProvider(providerRec));
	        }
	        if(internalDefaultCategoryList.size() > 0) {
	        	DefaultInternalCategoryName = internalDefaultCategoryList[0].Name;
	        	DefaultInternalCategoryId = internalDefaultCategoryList[0].Id;
	        }
		}	
	}
	
	/**
	* Name: TTType
	* Description: Apex class Transation Type
	**/
	public class TTType {
		public String Type;
		public String Id;
		public List<SOHeaderWrapper.Provider> ProviderList;
		
		/**
     	* Name: TTType
     	* Desc: Constructor
    	* @param:	(1)ttRec - Transaction_Type__c - Transaction Type Record
    	* @return: 	
   		**/
		public TTType(Transaction_Type__c ttRec) {
			this.Id = ttRec.Id;
			this.Type = ttRec.Type__c;
			this.ProviderList = new List<SOHeaderWrapper.Provider>();
			for(Provider__c providerRec : ttRec.Providers__r) {
				this.ProviderList.add(new SOHeaderWrapper.Provider(providerRec));
			}
		}	
	}
	
	/**
	* Name: TTType
	* Description: Apex class Transation Type
	**/
	public class VendorAsProvider {
		public String Id;
		public String Name;
		public String Email;
		public String Phone;
		
		/**
     	* Name: TTType
     	* Desc: Constructor
    	* @param:	(1)ttRec - Transaction_Type__c - Transaction Type Record
    	* @return: 	
   		**/
		public VendorAsProvider(Account vendorRec) {
			this.Id = vendorRec.Id;
			this.Name = vendorRec.Name;
			this.Email = (vendorRec.Preferred_Email__c != null) ? vendorRec.Preferred_Email__c : vendorRec.Work_Email__c;
			this.Phone = (vendorRec.Preferred_Phone__c != null) ? vendorRec.Preferred_Phone__c : vendorRec.Work_Number__c;
		}	
	}
	
	/**
	* Name: Provider
	* Description: Apex class about Provider
	**/
	public class Provider {
		public String ProviderName;
		public String ProviderEmail;
		public String Id;
		public String ProviderPhone;
		
		/**
     	* Name: Provider
     	* Desc: Constructor
    	* @param:	(1)providerRec - Provider__c - Provider Record 
    	* @return: 	
   		**/
		public Provider(Provider__c providerRec) {
			this.ProviderName = providerRec.Name__c;
			this.ProviderEmail = providerRec.Email__c;
			this.ProviderPhone = providerRec.Phone__c;
			this.Id = providerRec.Id;
		}
	}
	
	public class SpecialOrder {
		public String Id;
		public String PartId;
		public String COLineItemId;
	    public String Item;
	    public Decimal QtyNeeded;
	    public String Status;
	    public String PONumber;
	    public String POStatus;
	    public String ExpectedDelivery;
	    public String ETA;
	    public String VendorId;

    	
    	public SpecialOrder(Vendor_Order_Line_Item__c VendorOrderLineItemRec) {
    		this.Id = VendorOrderLineItemRec.Id;
    		this.PartId = VendorOrderLineItemRec.Part__c;
    		this.COLineItemId = VendorOrderLineItemRec.CO_Line_Item__c;
    		this.Item = VendorOrderLineItemRec.Part__r.Part_Number__c + ' - ' + VendorOrderLineItemRec.Part__r.Description__c;
    		this.QtyNeeded = VendorOrderLineItemRec.Qty_Needed__c;
    		if(VendorOrderLineItemRec.Status__c == null){
    			this.Status = 'Required';	
    		}else{
    			this.Status = VendorOrderLineItemRec.Status__c;	
    		}
    		this.PONumber = VendorOrderLineItemRec.Vendor_Order_Header__r.Name;
    		this.POStatus = VendorOrderLineItemRec.Vendor_Order_Header__r.Status__c;
    		this.ExpectedDelivery = (VendorOrderLineItemRec.CO_Line_Item__r.Expected_Delivery_Date__c != null) ? 
    										DateTime.newInstance(VendorOrderLineItemRec.CO_Line_Item__r.Expected_Delivery_Date__c.year(), VendorOrderLineItemRec.CO_Line_Item__r.Expected_Delivery_Date__c.month(), VendorOrderLineItemRec.CO_Line_Item__r.Expected_Delivery_Date__c.day()).format('MM/dd/yyyy') 
    										: null;
    		this.ETA = null;
    		this.VendorId = (VendorOrderLineItemRec.Part__c != null) ? VendorOrderLineItemRec.Part__r.Vendor__c : null;
    	}
    }
    
    public class Deductible{
    	public Decimal DeductibleAmount;
    	public String DeductibleStatus;
    	public String DeductibleId;
    	public String SoHeaderId;
    	public String CoHeaderId;

    	public Deductible(Service_Order_Header__c soHeaderRec ){
    	 	this.DeductibleAmount = 0;
    	 	for(SO_Payment_Role__c soPaymentRoleObj : soHeaderRec.SO_Payment_Roles__r ){
    	 		if(soPaymentRoleObj.RecordType.DeveloperName == 'Deductible'){
		    	 	this.DeductibleAmount = soPaymentRoleObj.Total_Amount__c != null ? soPaymentRoleObj.Total_Amount__c : 0;
		    	 	this.DeductibleStatus = soPaymentRoleObj.Deductible_Status__c;
		    	 	this.DeductibleId = soPaymentRoleObj.Id;
		    	 	this.SoHeaderId = soPaymentRoleObj.Service_Order_Header__c;
		    	 	this.CoHeaderId = soPaymentRoleObj.Service_Order_Header__r.CO_Header__c;
    	 		}
    	 	}
    	 }
    }
}