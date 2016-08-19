/**
* Author: Tarun Khandelwal
* Since: Jan 13, 2016
* Name: SOHeaderPrintPreviewCtrl
* Description: Apex class which gives SO Header Info used in Print Preview Page
**/
global with sharing class SOHeaderPrintPreviewCtrl {
	
	/**
    * Name: getPrinitngInfo
    * Desc: Method to get json string related to Prinitng Info of Service Header Order
    * @param:  (1) soHeaderId - String - Id of SO Header Record
    * @return: String - JSON String of SO Header Detail Record
    **/
    @RemoteAction 
    global static String getPrinitngInfo(String soHeaderId){
    	soHeaderId = BPUtility.getDecodedString(soHeaderId);
    	List<CO_Header__c> coHeaderRecs = new List<CO_Header__c>();
    	List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
    	List<Account> customerList = new List<Account>();
    	List<Service_Order_Kit_Header__c> soKitHeaderList = new List<Service_Order_Kit_Header__c>();
    	
    	if(AccessControl.ifObjectFieldIsAccessible('Individual_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Individual_Tax__c> individualTaxList = [select Sales_Tax_Item_Name__c, Tax_Rate__c, Service_Order_Line_Item__c, 		
    														Service_Order_Line_Item__r.Total__c, Service_Order_Line_Item__r.Tax_Percent__c	 		
    														from Individual_Tax__c		
    														where Service_Order_Line_Item__r.Service_Order_Header__c =: soHeaderId];
    	List<Service_Order_Header__c> soHeaderRecList = SOQLUtil.getSODetailsByFieldName(new Map<String, String>{'Id' => soHeaderId});
    	if(soHeaderRecList.size() == 0) {
    		return BPUtility.getEncodedString('{}');
    	}
    	
    	soKitHeaderList = SOQLUtil.getSOKitHeaderByFieldName(new Map<String, String>{'Service_Order_Header__c' => soHeaderId});
    	Service_Order_Header__c soHeaderRec = soHeaderRecList[0];
    	coHeaderRecs = SOQLUtil.getCOHeaderDetails(soHeaderRec.CO_Header__c);
    	
    	
    	if(coHeaderRecs.size() > 0 && coHeaderRecs[0].Customer__c != null) {
            couRecords = (soHeaderRec.Customer_Owned_Unit__c != null) ? SOQLUtil.getCOUListByFieldName('Id', soHeaderRec.Customer_Owned_Unit__c) : new List<Customer_Owned_Unit__c>();
            customerList = SOQLUtil.getCustomer(coHeaderRecs[0].Customer__c, null);
        }
        PrintingInfo printingInfoObj = new PrintingInfo(customerList, couRecords, coHeaderRecs, soHeaderRec, soKitHeaderList, individualTaxList);
        
        return BPUtility.getEncodedString(System.JSON.serialize(printingInfoObj));  
    }
	
	
	public class PrintingInfo {
		
		public Customer CustomerInfo;
		public CustomerOwnedUnit COUInfo;
		public COHeader COHeaderInfo;
		public SOHeaderWrapper.SOHeader SOHeaderInfo;
		public SOHeaderWrapper.SOReview SOReviewInfo;
		public List<SOHeaderWrapper.SOGrid> SOGridItems;
		public Decimal Total_Part;
		public Decimal Total_Laobur;
		public Decimal Total_Sublet;
		public Decimal Total_Other;
		public Decimal Total;
		public Decimal SalesTax;		
		public List<IndividualTax> SalesTaxList;
		public Boolean IsTaxIncludingPricing;
		
		public PrintingInfo(List<Account> customerList, List<Customer_Owned_Unit__c> couList, List<CO_Header__c> coHeaderList, Service_Order_Header__c soHeaderRec, 
								List<Service_Order_Kit_Header__c> soKitHeaderList, List<Individual_Tax__c> individualTaxList) {
			this.SOGridItems = new List<SOHeaderWrapper.SOGrid>();
			
			this.CustomerInfo = (customerList.size() > 0) ? new Customer(customerList[0]) : new Customer(new Account());
			this.COUInfo = (couList.size() > 0) ? new CustomerOwnedUnit(couList[0]) : new CustomerOwnedUnit(new Customer_Owned_Unit__c());
			this.COHeaderInfo = (coHeaderList.size() > 0) ? new COHeader(coHeaderList[0]) : new COHeader(new CO_Header__c());
			this.SOHeaderInfo = new SOHeaderWrapper.SOHeader(soHeaderRec);
			this.SOReviewInfo = new SOHeaderWrapper.SOReview(soHeaderRec);
			
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
				this.SOGridItems.add(new SOHeaderWrapper.SOGrid(soKHRec, soKHRec.Service_Order_Line_Items__r, true));
            	for(Service_Order_Line_Item__c soliRec : sokhRec.Service_Order_Line_Items__r) {
            		soliIdSet.add(soliRec.Id);
            		if(soliRec.Tax_Percent__c == null) {
            			soliRec.Tax_Percent__c = 0;
            		}
            		if(soliRec.Labour_Code__c != null) {
            			this.Total_Laobur += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
                        if(isTaxIncludingPricing) {
                        	this.Total_Laobur += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                        } else {
                        	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                        }
            		} else if(soliRec.Part__c != null) {
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
        		if(!soliIdSet.contains(soliRec.Id)) {
    				this.SOGridItems.add(new SOHeaderWrapper.SOGrid(new Service_Order_Kit_Header__c(), new List<Service_Order_Line_Item__c>{soliRec}, false));
    				if(soliRec.Labour_Code__c != null) {
            			this.Total_Laobur += (soliRec.Total__c != null) ? soliRec.Total__c : 0;
            			if(isTaxIncludingPricing) {
                        	this.Total_Laobur += ((soliRec.Total__c * soliRec.Tax_Percent__c) / 100).setScale(2);
                        } else {
                        	this.SalesTax += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
                        }
            		} else if(soliRec.Part__c != null) {
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
		}	
			
	}
							
	public class IndividualTax {		
    	public String TaxName;		
    	public Decimal TaxValue;		
    			
    	public IndividualTax(String taxName, Decimal taxValue) {		
    		this.TaxName = taxName;		
    		this.TaxValue = (taxValue != null) ? taxValue.setScale(2) : 0;		
    	}		
    }
	public class Customer {
		
		public String FirstName;
		public String LastName;
		public String BusinessName;
		public String NickName;
		public String Type;
		public Boolean Active;
	    public String FacebookLink;
	    public String TwitterLink;
	    public String LinkedInLink;
		
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
	
	public class COHeader {
		public String COHeaderName;
		
		public COHeader(CO_Header__c coHeaderRec) {
			this.COHeaderName = coHeaderRec.Name;
		}
	}
}