public with sharing class SOInfoPrintPreviewPDFCtrl {
	
	
	public SOInfoPrintPreviewPDFCtrl(){
			String soHeaderId = ApexPages.currentPage().getParameters().get('id');
			soHeaderId = String.escapeSingleQuotes(soHeaderId);
			 
			List<CO_Header__c> coHeaderRecs = new List<CO_Header__c>();
			List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
			List<Account> customerList = new List<Account>();
			List<Service_Order_Kit_Header__c> soKitHeaderList = new List<Service_Order_Kit_Header__c>();
			List<Service_Order_Header__c> soHeaderRecList = SOQLUtil.getSODetailsByFieldName(new Map<String, String>{'Id' => string.escapesinglequotes(soHeaderId)});
			
			if(AccessControl.ifObjectFieldIsAccessible('Individual_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			List<Individual_Tax__c> individualTaxList = [select Sales_Tax_Item_Name__c, Tax_Rate__c, Service_Order_Line_Item__c, 		
    														Service_Order_Line_Item__r.Total__c, Service_Order_Line_Item__r.Tax_Percent__c	 		
    														from Individual_Tax__c		
    														where Service_Order_Line_Item__r.Service_Order_Header__c =: soHeaderId];
			
			if(soHeaderRecList.size() != 0) {
				soKitHeaderList = SOQLUtil.getSOKitHeaderByFieldName(new Map<String, String>{'Service_Order_Header__c' => string.escapesinglequotes(soHeaderId)});
				Service_Order_Header__c soHeaderRec = soHeaderRecList[0];
				coHeaderRecs = SOQLUtil.getCOHeaderDetails(soHeaderRec.CO_Header__c);
				if(coHeaderRecs.size() > 0 && coHeaderRecs[0].Customer__c != null) {
	    			couRecords = (soHeaderRec.Customer_Owned_Unit__c != null) ? SOQLUtil.getCOUListByFieldName('Id', soHeaderRec.Customer_Owned_Unit__c) : new List<Customer_Owned_Unit__c>();
	   				customerList = SOQLUtil.getCustomer(coHeaderRecs[0].Customer__c, null);
				}
	        	printingInfoObj = new PrintingInfo(customerList, couRecords, coHeaderRecs, soHeaderRec, soKitHeaderList, individualTaxList);
			}
	}
	
	public PrintingInfo printingInfoObj{set;get;}
		public class PrintingInfo {
		
		public Customer CustomerInfo{Set;get;}
		public CustomerOwnedUnit COUInfo{Set;get;}
		public COHeader COHeaderInfo{Set;get;}
		public SOHeader SOHeaderInfo{Set;get;}
		public SOReview SOReviewInfo{Set;get;}
		public List<SOGrid> SOGridItems{Set;get;}
		public Decimal Total_Part{Set;get;}
		public Decimal Total_Laobur{Set;get;}
		public Decimal Total_Sublet{Set;get;}
		public Decimal Total_Other{Set;get;}
		public Decimal Total{Set;get;}
		public Decimal SalesTax{set;get;}
		public List<IndividualTax> SalesTaxList{set;get;}
		public Boolean IsTaxIncludingPricing{set;get;}
			
		 /**
		 * Name: PrintingInfo
		 * Description: Constructor
		 * @Param:	(1) customerList - List<Account> - List Of Customer
		 *			(2) couList - List<Customer_Owned_Unit__c> - List of Customer Owned Unit Record
		 *			(3) coHeaderList - List<CO_Header__c> - List of Co  Header
		 *			(4) soHeaderRec -  Service_Order_Header__c - List of Service Order Header
		 *			(5) soKitHeaderList - List<Service_Order_Kit_Header__c> - List of Service Order Kit Header Record
		 * @Return:	
		 **/
		public PrintingInfo(List<Account> customerList, List<Customer_Owned_Unit__c> couList, List<CO_Header__c> coHeaderList, Service_Order_Header__c soHeaderRec, 
								List<Service_Order_Kit_Header__c> soKitHeaderList, List<Individual_Tax__c> individualTaxList) {
			this.SOGridItems = new List<SOGrid>();
			
			this.CustomerInfo = (customerList.size() > 0) ? new Customer(customerList[0]) : new Customer(new Account());
			this.COUInfo = (couList.size() > 0) ? new CustomerOwnedUnit(couList[0]) : new CustomerOwnedUnit(new Customer_Owned_Unit__c());
			this.COHeaderInfo = (coHeaderList.size() > 0) ? new COHeader(coHeaderList[0]) : new COHeader(new CO_Header__c());
			this.SOHeaderInfo = new SOHeader(soHeaderRec);
			this.SOReviewInfo = new SOReview(soHeaderRec);
			
			this.Total_Part = 0;
			this.Total_Laobur = 0;
			this.Total_Sublet = 0;
			this.Total_Other = 0;
			this.Total = 0;
			this.SalesTax = 0;
			this.SalesTaxList = new List<IndividualTax>();		
			this.IsTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
			
			Set<Id> soliIdSet = new Set<Id>();
			for(Service_Order_Kit_Header__c soKHRec : soKitHeaderList) {
				this.SOGridItems.add(new SOGrid(soKHRec, soKHRec.Service_Order_Line_Items__r, true));
            	for(Service_Order_Line_Item__c soliRec : sokhRec.Service_Order_Line_Items__r) {
            		if(soliRec.Tax_Percent__c == null) {
            			soliRec.Tax_Percent__c = 0;
            		}
            		soliIdSet.add(soliRec.Id);
            		if(soliRec.Labour_Code__c != null && soliRec.Part__c == null) {
            			this.Total_Laobur += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
                        	this.Total_Laobur += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                        } else {
                        	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                        }
            		} else if(soliRec.Labour_Code__c == null && soliRec.Part__c != null) {
            			this.Total_Part += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
	                    	this.Total_Part += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
	                    } else {
	                    	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
	                    }
            		} else if(soliRec.Fee__c != null) {
            			this.Total_Other += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
                        	this.Total_Other += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                        } else {
                        	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                        }
            		}
            	} 
			}
			
			for(Service_Order_Line_Item__c soliRec : soHeaderRec.Service_Order_Line_Items__r) {
				if(soliRec.Tax_Percent__c == null) {
        			soliRec.Tax_Percent__c = 0;
        		}
        		if(!soliIdSet.contains(soliRec.Id)) {
    				this.SOGridItems.add(new SOGrid(new Service_Order_Kit_Header__c(), new List<Service_Order_Line_Item__c>{soliRec}, false));
    				if(soliRec.Labour_Code__c != null && soliRec.Part__c == null) {
            			this.Total_Laobur += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
                        	this.Total_Laobur += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                        } else {
                        	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                        }
            		} else if(soliRec.Labour_Code__c == null && soliRec.Part__c != null) {
            			this.Total_Part += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
	                    	this.Total_Part += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
	                    } else {
	                    	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
	                    }
            		} else if(soliRec.Fee__c != null) {
            			this.Total_Other += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
                        	this.Total_Other += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                        } else {
                        	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                        }
            		}
        		}
        	}
        	this.Total = this.Total_Part + this.Total_Laobur + this.Total_Sublet + this.Total_Other;
        	Map<String, Decimal> salesTaxItemNameToTaxValueMap = new Map<String, Decimal>();
        	for(Individual_Tax__c individualTaxRec : individualTaxList) {
        		if(!salesTaxItemNameToTaxValueMap.containsKey(individualTaxRec.Sales_Tax_Item_Name__c)) {
        			salesTaxItemNameToTaxValueMap.put(individualTaxRec.Sales_Tax_Item_Name__c, 0);
        		}
        		if(individualTaxRec.Service_Order_Line_Item__r.Total__c != null) {
        			if(individualTaxRec.Tax_Rate__c == null) {
        				individualTaxRec.Tax_Rate__c = 0;
        			}
        			Decimal oldTaxValue = salesTaxItemNameToTaxValueMap.get(individualTaxRec.Sales_Tax_Item_Name__c) + 
        						((individualTaxRec.Tax_Rate__c * individualTaxRec.Service_Order_Line_Item__r.Total__c) / 100);
        			salesTaxItemNameToTaxValueMap.put(individualTaxRec.Sales_Tax_Item_Name__c, oldTaxValue);
        		}
        	}
        	for(String salesTaxName : salesTaxItemNameToTaxValueMap.keySet()) {
        		this.SalesTaxList.add(new IndividualTax(salesTaxName, salesTaxItemNameToTaxValueMap.get(salesTaxName)));
        	}
        	//system.assert(false, SalesTaxList);
		}	
	}
	
	public class IndividualTax {		
    	public String TaxName{set;get;}		
    	public Decimal TaxValue{set;get;}		
    			
    	public IndividualTax(String taxName, Decimal taxValue) {		
    		this.TaxName = taxName;		
    		this.TaxValue = (taxValue != null) ? taxValue.setScale(2) : 0;		
    	}		
    }		
	
	/**
	* Name: Customer
	* Description: Customer Wrapper Class
	**/
	public class Customer {
		
		public String FirstName{set;get;}
		public String LastName{set;get;}
		public String BusinessName{set;get;}
		public String NickName{set;get;}
		public String Type{set;get;}
		public Boolean Active{set;get;}
	    public String FacebookLink{set;get;}
	    public String TwitterLink{set;get;}
	    public String LinkedInLink{set;get;}
		
		 /**
		 * Name: Customer
		 * Description: Constructor
		 * @Param:	(1) customerRec - Account - Account Record
		 * @Return:	
		 **/
		public Customer(Account customerRec) {
			this.BusinessName = customerRec.Name;
			this.FirstName = customerRec.FirstName__c;
    		this.LastName = customerRec.LastName__c;
    		this.Nickname = (customerRec.Nickname__c == null) ? '' : customerRec.Nickname__c;
    		this.Type = customerRec.Type__c;
    		this.Active = customerRec.Active__c;
    		this.FacebookLink = (customerRec.Facebook__c == null) ? '' : customerRec.Facebook__c;
	    	this.TwitterLink = (customerRec.Twitter__c == null) ? '' : customerRec.Twitter__c;
	    	this.LinkedInLink = (customerRec.LinkedIn__c == null) ? '' : customerRec.LinkedIn__c;
		}
	}
	
	/**
	* Name: COHeader
	* Description: COHeader Wrapper Class
	**/
	public class COHeader {
		public String COHeaderName{Set;get;}
		
		/**
		 * Name: COHeader
		 * Description: Constructor
		 * @Param:	(1) coHeaderRec - CO_Header__c - CO Header Record
		 * @Return:	
		 **/
		public COHeader(CO_Header__c coHeaderRec) {
			this.COHeaderName = coHeaderRec.Name;
		}
	}
	public with sharing class CustomerOwnedUnit {
	
	// VIN Number
    public String VIN{set;get;}
    
    // Year
    public Decimal Year{set;get;}
    
    // Make
    public String Make{set;get;}
    
    // Make
    public String MakeName{set;get;}
    
    // Model
    public String ModelName{set;get;}
    
    // Model
    public String Model{set;get;}
    
    // Sub-Model
    public String SubModel{set;get;}
    
    // Sub-Model Name
    public String SubModelName{set;get;}
    
    // Parent model make name
    public String ModelMakeName{set;get;}
    
    // License Plate
    public String Plate{set;get;}
    
    // Mileage
    public Decimal Mileage{set;get;}
    
    // Color
    public String Color{set;get;}
    
    // Id
    public String Id{set;get;}
    
    public String Name{set;get;}
    
    // Constructor
    public CustomerOwnedUnit(Customer_Owned_Unit__c coUnitRec) {
    	this.VIN = coUnitRec.VIN__c;
    	this.Year = coUnitRec.Year__c;
    	this.Make = coUnitRec.Unit_Make__c;
    	this.MakeName = coUnitRec.Unit_Make__r.Name;
    	this.Name = coUnitRec.Name;
    	
    	if(coUnitRec.Unit_Model__c != null) {
    		this.Model = coUnitRec.Unit_Model__c;
    		this.ModelName = coUnitRec.Unit_Model__r.Name__c;
    		this.SubModel = coUnitRec.Unit_Model__c;
    		this.SubModelName = coUnitRec.Unit_Model__r.Sub_Model__c;
    		this.ModelMakeName = coUnitRec.Unit_Model__r.Unit_Make__r.Name;
    	} else {
    		this.Model = '';
    		this.ModelName = '';
    		this.SubModel = '';
    	}
    	this.Plate = coUnitRec.Plate__c;
    	this.Mileage = coUnitRec.Mileage__c;
    	this.Color = coUnitRec.Colour__c;
    	this.Id = coUnitRec.Id;
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
	* Name: SOHeader
	* Description: Apex class which contains all JSON related oprations of Service Order
	**/
	public class SOHeader {
		public String Id;
		public String Name;
		public Decimal Total;
		public List<String> ManualConcern{set;get;}
		public List<String> ManualCorrection{set;get;} 
		public List<String> ManualCause{set;get;}
		
		public List<String> KitHeaderCause;
		public List<String> KitHeaderConcern{set;get;}
		public List<String> KitHeaderCorrection{Set;get;}
		
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
		public String Status{Set;get;}
		public Boolean IsCompletedLinkShown;
		
		public String WorkStatus;
		public List<AvailableStatus> AvailableWorkStatusList;
		public String ClaimStatus;
		public List<AvailableStatus> AvailableClaimStatusList;
		
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
			
		}
	}
	/**
	* Name: SOKitHeader
	* Description: Apex class Service Order Kit Header
	**/
	public class SOKitHeader {
		
		public List<SOLineItem> SOLIList{Set;get;}
		
		public String ItemDescription{set;get;}
		public Boolean CanItSplit;
		public String Code;
		public Boolean IsServiceKit;
		public String Id{Set;get;}
		public Decimal FixedPrice{set;get;}
		public Decimal RetailPrice;
		public Boolean IsFixedPrice; 
		public Boolean hasChildren{Set;get;}
		public Boolean isFixedKitHeaderSO;
		
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
			this.ItemDescription = soKitHeaderRec.Kit_Unique_Name__c;
			this.CanItSplit = soKitHeaderRec.Can_Split__c;
			this.IsServiceKit = soKitHeaderRec.Service_Kit__c;
			this.Code = soKitHeaderRec.Code__c;
			this.Id = soKitHeaderRec.Id;
			this.isFixedKitHeaderSO = soKitHeaderRec.Is_Fixed_Kit_Header_SO__c;
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
		
		public String ItemDesc{Set;get;}
		public String Status{Set;get;}
		public Decimal QtyNeeded{Set;get;}
		public Decimal StockCommited{Set;get;}
		public Decimal QtyOrder{Set;get;}
		public Decimal ReatilPrice;
		public Decimal SubTotal{Set;get;}
		public Boolean IsFixedPrice;
		public Decimal AvailablePart;
		public String PartId;
		
		public Boolean IsPart {set;get;}
		public Boolean IsLabour{set;get;}
		public Boolean IsFee{set;get;}
		public String Id;
		public String SOKitHeaderId;
		public Decimal KitPrice{Set;get;}
		public Decimal Tax{get; set;
		}
		public String VendorId;
		public String CoLineItem;
		public Boolean isFixedKitHeaderLineItemSO;
		
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
			
			Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            this.Tax = soLineItemRec.Tax_Percent__c;
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
			
			this.ReatilPrice = (soLineItemRec.Retail_Price__c != null) ? soLineItemRec.Retail_Price__c.SetScale(3) : soLineItemRec.Retail_Price__c;
			this.IsFixedPrice = soLineItemRec.Fixed_Price__c;
			this.PartId = soLineItemRec.Part__c;
			this.AvailablePart = (soLineItemRec.Part__c != null) ? (soLineItemRec.Part__r.AvailableParts__c) : null;
			this.IsPart = (soLineItemRec.Part__c != null) ? true : false;
			this.IsLabour = (soLineItemRec.Labour_Code__c != null) ? true : false;
			this.IsFee = (soLineItemRec.Fee__c != null) ? true : false;
			this.SOKitHeaderId = soLineItemRec.Service_Order_Kit_Header__c;
			this.CoLineItem = (soLineItemRec.CO_Line_Item__c !=null) ? (soLineItemRec.CO_Line_Item__c ) : null;
			
			if(this.IsLabour) {
				//this.KitPrice = this.KitPrice + soLineItemRec.Labour_Tax_Amount__c;
			}
		}
	}
	
	/**
	* Name: SOGrid
	* Description: Apex class Service Order Grid
	**/
	public class SOGrid {
		
		public SOKitHeader SOKH{Set;get;}
		
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
	* Name: SOReview
	* Description: Apex class service order review
	**/
	public class SOReview {
		
		public Decimal OdometerOnDeparture;
		public String Id;
		public List<String> KitHeaderNotes{Set;get;}
		public List<String> ManualNotes{Set;get;}
		
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
	
}