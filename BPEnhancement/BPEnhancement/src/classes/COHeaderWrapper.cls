/**
 * Author: Tarun Khandelwal
 * Since: April 10, 2015
 * Name: COHeaderWrapper
 * Description: Apex class to handle JSON related oprations of all object used in customer order page.
**/
public with sharing class COHeaderWrapper { 
    
    // CO header Record
    public COHeader coHeaderRec{get; set;}
    
    // User locale to decide if user is australian or else
    public String CurrentUserLocale {get; set;}
    
    // List of CO Line Items
    public List<COLineItem> coLineItemRecs {get; set;}
    
    
    public List<COKitHeader> COKHList;
    
    // List of CO Line Items
    public List<COLineItem> allCOLineItemRecs {get; set;}
    
    // List of CO Deposits record
    public List<CODeposit> coDeposits {get; set;}
    
    // CO Invoice Header Record.
    public COInvoiceHeader coInvoiceHeaderRec {get; set; } 
    
    // List of Co invoice Payments
    public List<COInvoicePayment> coInvoicePaymentRecs {get; set;}
    
    // List of CO Invoice Items
    public List<COInvoiceItem> coInvoiceItemRecs {get; set;}
    
    // List of CO Invoice History Record
    public List<InvoiceHistory> COInvoiceHistoryRecs {get; set;}
    
    // List of COUs Records
    public List<CustomerOwnedUnit> COUList;
    
    // List of CO Line Items
    public List<SpecialOrder> specialOrderList;
    
    // Total Records Count for grids
    public Integer TotalMerchandiseItems;
    public Integer TotalSpecialOrders;
    public Integer TotalDeposits;
    public Integer TotalCheckoutItems;
    public Integer TotalCheckoutPayments;
    public Integer TotalInvoiceHistories;
    
    public Decimal MerchandiseTotal;
    public Boolean IsTaxIncludingPricing;
    
    public SO_KLI_Recalculation.Errorhandler error;
    
    // Constructor
    public COHeaderWrapper(CO_Header__c coHeaderObj, List<CO_Line_Item__c> coLineItemListObj, List<CO_Line_Item__c> allCOLineItemListObj, String currentUserLocale, List<CO_Deposit__c> coDepositsList, 
    							List<CO_Invoice_Header__c> coInvoiceHeader, List<CO_Invoice_Payment__c> coInvoicePayments, 
    							List<CO_Invoice_Item__c> coInvoiceItems, List<CO_Invoice_Header__c> coInvoiceHistoryList,
    							Map<Id, List<Vendor_Order_Header__c>> vendorIdToVOHeadesListMap, List<Customer_Owned_Unit__c> couList) {
    	// Intialize all list and objects	
    	if(coHeaderObj != null) {						
        	this.coHeaderRec = new COHeader(coHeaderObj);
    	}
        this.coLineItemRecs = new List<COLineItem>();
        this.allCOLineItemRecs = new List<COLineItem>();
        this.coDeposits = new List<CODeposit>();
        this.coInvoicePaymentRecs = new List<COInvoicePayment>();
        this.coInvoiceItemRecs = new List<COInvoiceItem>();
        this.COInvoiceHistoryRecs = new List<InvoiceHistory>();
        this.CurrentUserLocale = currentUserLocale;
        this.COUList = new List<CustomerOwnedUnit>();
        
        for(CO_Line_Item__c coLineItemObj : allCOLineItemListObj) {
        	COLineItem coliObj = new COLineItem(coLineItemObj);
        	
        	String vendorId;
        	if(coLineItemObj.Part__c != null && coLineItemObj.Part__r.Vendor__c != null) {
        		vendorId = coLineItemObj.Part__r.Vendor__c;
        	}
        	if(vendorId != null) {
        		if(vendorIdToVOHeadesListMap.containsKey(vendorId)) {
        			List<COLineItem.VOHeader> voHeaderObjList = new List<COLineItem.VOHeader>();
        			for(Vendor_Order_Header__c voHeaderRec : vendorIdToVOHeadesListMap.get(vendorId)) {
        				voHeaderObjList.add(new COLineItem.VOHeader(voHeaderRec));
        			}
        			coliObj.VOHeaderList.addAll(voHeaderObjList);
        		}
        	}
            this.allCOLineItemRecs.add(coliObj);
        }
        
        for(CO_Line_Item__c coLineItemObj : coLineItemListObj) {
        	COLineItem coliObj = new COLineItem(coLineItemObj);
            this.coLineItemRecs.add(coliObj);
        }
        
        for(CO_Deposit__c coDeposit  : coDepositsList) {
            this.coDeposits.add(new CODeposit(coDeposit));
        }
        for(CO_Invoice_Header__c coInvoiceHeaderRecord : coInvoiceHeader) {
        	this.coInvoiceHeaderRec = new COInvoiceHeader(coInvoiceHeaderRecord);
        }
        for(CO_Invoice_Payment__c coInvoicePaymentRecord : coInvoicePayments) {
        	this.coInvoicePaymentRecs.add(new COInvoicePayment(coInvoicePaymentRecord));
        }
        
    	Decimal deductiblePartyTotal = 0;
        for(CO_Invoice_Item__c coInvoiceItemRecord : coInvoiceItems) {
        	if(coInvoiceItemRecord.CO_Line_Item__c != null && coInvoiceItemRecord.CO_Line_Item__r.Qty__c == 0) {
        		continue;
        	}
        	if(coInvoiceItemRecord.SO_Payment_Role__c != null && coInvoiceItemRecord.SO_Payment_Role__r.RecordType.DeveloperName == 'Deductible') {
        		deductiblePartyTotal += coInvoiceItemRecord.SO_Payment_Role__r.Total_Amount__c;
        	}
        	this.coInvoiceItemRecs.add(new COInvoiceItem(coInvoiceItemRecord));
        }
        
        for(COInvoiceItem coInvoiceItemObj : coInvoiceItemRecs) {
        	if(coInvoiceItemObj.CheckoutType == Constants.CHECKOUT_TYPE_THIRD_PARTY) {
        		coInvoiceItemObj.Total = coInvoiceItemObj.Total - deductiblePartyTotal;
        	}
        }
        
        for(CO_Invoice_Header__c closedCOInvoiceHeaderRec : coInvoiceHistoryList) {
        	this.COInvoiceHistoryRecs.add(new InvoiceHistory(closedCOInvoiceHeaderRec));
        }
        for(Customer_Owned_Unit__c couRec : couList) {
        	this.COUList.add(new CustomerOwnedUnit(couRec));
        }
        this.IsTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
    }
    
    // Constructor
    public COHeaderWrapper(CO_Header__c coHeaderObj, List<CO_Line_Item__c> coLineItemListObj, List<CO_Kit_Header__c> coKitHeaders, String currentUserLocale, List<CO_Deposit__c> coDepositsList, 
    							List<CO_Invoice_Header__c> coInvoiceHeader, List<CO_Invoice_Payment__c> coInvoicePayments, 
    							List<CO_Invoice_Item__c> coInvoiceItems, List<CO_Invoice_Header__c> coInvoiceHistoryList,
    							Map<Id, List<Vendor_Order_Header__c>> vendorIdToVOHeadesListMap, List<Customer_Owned_Unit__c> couList,
    							List<Vendor_Order_Line_Item__c> specialOrderList) {    
    	// Intialize all list and objects
    	if(coHeaderObj != null) {							
        	this.coHeaderRec = new COHeader(coHeaderObj);
    	}  
        this.coLineItemRecs = new List<COLineItem>();
        this.allCOLineItemRecs = new List<COLineItem>();
        this.coDeposits = new List<CODeposit>();
        this.coInvoicePaymentRecs = new List<COInvoicePayment>();
        this.coInvoiceItemRecs = new List<COInvoiceItem>();
        this.COInvoiceHistoryRecs = new List<InvoiceHistory>();
        this.CurrentUserLocale = currentUserLocale;
        this.COUList = new List<CustomerOwnedUnit>();
        this.specialOrderList = new List<SpecialOrder>();
        this.COKHList = new List<COKitHeader>();
        
        for(CO_Line_Item__c coLineItemObj : coLineItemListObj) {
        	COLineItem coliObj = new COLineItem(coLineItemObj);
        	
        	String vendorId;
        	if(coLineItemObj.Part__c != null && coLineItemObj.Part__r.Vendor__c != null) {
        		vendorId = coLineItemObj.Part__r.Vendor__c;
        	}
        	if(vendorId != null) {
        		if(vendorIdToVOHeadesListMap.containsKey(vendorId)) {
        			List<COLineItem.VOHeader> voHeaderObjList = new List<COLineItem.VOHeader>();
        			for(Vendor_Order_Header__c voHeaderRec : vendorIdToVOHeadesListMap.get(vendorId)) {
        				voHeaderObjList.add(new COLineItem.VOHeader(voHeaderRec));
        			}
        			coliObj.VOHeaderList.addAll(voHeaderObjList);
        		}
        	}
            this.allCOLineItemRecs.add(coliObj);
        }
        this.MerchandiseTotal = 0;
        for(CO_Line_Item__c coLineItemObj : coLineItemListObj) {
        	COLineItem coliObj = new COLineItem(coLineItemObj);
        	String vendorId;
        	if(coLineItemObj.Part__c != null && coLineItemObj.Part__r.Vendor__c != null) {
        		vendorId = coLineItemObj.Part__r.Vendor__c;
        	}
        	if(vendorId != null) {
        		if(vendorIdToVOHeadesListMap.containsKey(vendorId)) {
        			List<COLineItem.VOHeader> voHeaderObjList = new List<COLineItem.VOHeader>();
        			for(Vendor_Order_Header__c voHeaderRec : vendorIdToVOHeadesListMap.get(vendorId)) {
        				voHeaderObjList.add(new COLineItem.VOHeader(voHeaderRec));
        			}
        			coliObj.VOHeaderList.addAll(voHeaderObjList);
        		}
        	}
        	coLineItemObj.Qty__c = (coLineItemObj.Qty__c == null) ? 0 : coLineItemObj.Qty__c;
    		coLineItemObj.Price__c = (coLineItemObj.Price__c == null) ? 0 : coLineItemObj.Price__c;
    		
    		Decimal TaxAmount = (coLineItemObj.Tax__c == null) ? 0 : (coLineItemObj.Qty__c * coLineItemObj.Price__c * coLineItemObj.Tax__c / 100);
    		merchandiseTotal += (coLineItemObj.Qty__c * coLineItemObj.Price__c) + TaxAmount;
    		merchandiseTotal = merchandiseTotal.setScale(2);
            //this.coLineItemRecs.add(coliObj);
        }
        
        this.COKHList = getCOLineItemsList(coLineItemListObj, coKitHeaders);
        
        for(CO_Deposit__c coDeposit  : coDepositsList) {
            this.coDeposits.add(new CODeposit(coDeposit));
        }
        for(CO_Invoice_Header__c coInvoiceHeaderRecord : coInvoiceHeader) {
        	this.coInvoiceHeaderRec = new COInvoiceHeader(coInvoiceHeaderRecord);
        }
        for(CO_Invoice_Payment__c coInvoicePaymentRecord : coInvoicePayments) {
        	this.coInvoicePaymentRecs.add(new COInvoicePayment(coInvoicePaymentRecord));
        }
        
        Decimal deductibleTotal = 0;
        for(CO_Invoice_Item__c coInvoiceItemRecord : coInvoiceItems) {
        	if(coInvoiceItemRecord.CO_Line_Item__c != null && coInvoiceItemRecord.CO_Line_Item__r.Qty__c == 0) {
        		continue;
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
        
        for(CO_Invoice_Header__c closedCOInvoiceHeaderRec : coInvoiceHistoryList) {
        	this.COInvoiceHistoryRecs.add(new InvoiceHistory(closedCOInvoiceHeaderRec));
        }
        for(Customer_Owned_Unit__c couRec : couList) {
        	this.COUList.add(new CustomerOwnedUnit(couRec));
        }
        for(Vendor_Order_Line_Item__c specialOrderObj : specialOrderList) {
            this.specialOrderList.add(new SpecialOrder(specialOrderObj));
        }
        
        this.error = (CustomerOrderCtrl.error != null) ? CustomerOrderCtrl.error : new SO_KLI_Recalculation.Errorhandler('200', 'Success');
        this.IsTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COHeaderWrapper - Class Object
    **/
    public static COHeaderWrapper parse(String json) {
        return (COHeaderWrapper) System.JSON.deserialize(json, COHeaderWrapper.class);   
    }
    
    
    /**
     * Name: getCOKHFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getCOKHFieldsList(){
        List<String> cokhFields = new List<String>{ 'Id',
                                                    'CO_Header__c',
                                                    'Kit_Header__c',
                                                    'Price__c',
                                                    'CreatedDate',
                                                    'Kit_Header__r.Kit_Unique_Name__c',
													'Can_Split__c',
													'Service_Kit__c',
													'Fixed_Price_Flag__c',
													'Actual_Kit_Price__c',
													'CO_Fixed_KitHeader__c',
													'Tax_Amount__c'
                                                };
        return cokhFields;
    }
    
    public static List<COKitHeader> getCOLineItemsList(List<CO_Line_Item__c> coLineItemListObj, List<CO_Kit_Header__c> coKitHeaders ) {
    	
    	List<COKitHeader> coKHObjList = new List<COKitHeader>();
    	List<DateTime> sortedDateTimeList = new List<dateTime>();
    	Set<Id> coliIdSet = new Set<Id>();
    	for(CO_Kit_Header__c cokh : coKitHeaders) {
    		sortedDateTimeList.add(cokh.CreatedDate);
    		
    		coKHObjList.add(new COKitHeader(cokh, cokh.CO_Line_Items__r, true));
        	for(CO_Line_Item__c coliRec : cokh.CO_Line_Items__r) {
        		coliIdSet.add(coliRec.Id);
        	} 
    	}
    	
    	Integer lastIndexValue = 0;
		system.debug('Sorting Started OF COLIs -->>');
		system.debug(sortedDateTimeList);
		for(CO_Line_Item__c coliRec : coLineItemListObj) {
    		if(!coliIdSet.contains(coliRec.Id)) {
    			for(Integer i = lastIndexValue; i < sortedDateTimeList.size(); i++){
    				system.debug(i);
    				if(sortedDateTimeList[i] < coliRec.CreatedDate){
    					lastIndexValue ++;
    				} else {
    					break;
    				}
    			}
    			system.debug('lastIndexValue  ' + lastIndexValue);
    			
    			if(coKHObjList.size() > lastIndexValue){
    				coKHObjList.add(lastIndexValue, new COKitHeader(new CO_Kit_Header__c(), new List<CO_Line_Item__c>{coliRec}, false));
    				
    				if(sortedDateTimeList.size() > lastIndexValue){
    					sortedDateTimeList.add(lastIndexValue, coliRec.CreatedDate);
    				} else {
    					sortedDateTimeList.add(coliRec.CreatedDate);
    				}
    				
    				lastIndexValue++;
    			} else {
    				coKHObjList.add(new COKitHeader(new CO_Kit_Header__c(), new List<CO_Line_Item__c>{coliRec}, false));
    				lastIndexValue++;
    			}
    			system.debug('lastIndexValue : ' +lastIndexValue + '\n\n\nSOGridItems : ' + coKHObjList);
    			system.debug('sortedDateTimeList : ' + sortedDateTimeList);
    		}
    	}
    	return coKHObjList;
    }
    
    
    public class COKitHeader {
    	
    	public List<COLineItem> COLIList;
    	public Decimal Price;
    	public String ItemDescription;
		public Boolean CanItSplit;
		public String Code;
		public Boolean IsServiceKit;
		public String Id;
		public Decimal FixedPrice;
		public Decimal RetailPrice;
		public Boolean IsFixedPrice; 
		public Boolean hasChildren;
		public Decimal ActualKitPrice;
		public Boolean IsFixedKitHeaderCO;
		public Decimal TaxAmount;
    	
    	public COKitHeader(CO_Kit_Header__c coKitHeaderRec, List<CO_Line_Item__c> coliList, Boolean hasChild) {
    		this.hasChildren = hasChild;
    		this.TaxAmount = coKitHeaderRec.Tax_Amount__c;
    		Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
    		if(!isTaxIncludingPricing) {
    			this.Price = coKitHeaderRec.Price__c;
    		} else {
    			if(coKitHeaderRec.Tax_Amount__c == null) {
    				coKitHeaderRec.Tax_Amount__c = 0;
    			}
    			if(coKitHeaderRec.Price__c == null) {
    				coKitHeaderRec.Price__c = 0;
    			}
    			this.Price = coKitHeaderRec.Price__c + coKitHeaderRec.Tax_Amount__c;
    			this.Price = this.Price.setScale(2);
    		}
    		this.ItemDescription = coKitHeaderRec.Kit_Header__r.Kit_Unique_Name__c;
			this.Id = coKitHeaderRec.Id;
			this.IsServiceKit = (coKitHeaderRec.Service_Kit__c == null) ? false : coKitHeaderRec.Service_Kit__c;
			this.IsFixedPrice = (coKitHeaderRec.Fixed_Price_Flag__c == null) ? false : coKitHeaderRec.Fixed_Price_Flag__c;
			this.CanItSplit = (coKitHeaderRec.Can_Split__c == null) ? false : coKitHeaderRec.Can_Split__c;
			this.ActualKitPrice = (coKitHeaderRec.Actual_Kit_Price__c != null) ? coKitHeaderRec.Actual_Kit_Price__c.setScale(2) : 0.00;
    		
    		this.COLIList = new List<COLineItem>();
    		
    		for(CO_Line_Item__c coliRec : coliList) {
    			this.COLIList.add(new COLineItem(coliRec));
    		}
    		this.IsFixedKitHeaderCO = coKitHeaderRec.CO_Fixed_KitHeader__c;
    	}
    }
    
    
    public class GridTotal {
    	public Decimal Total;
    	public Decimal SalesTax;
    	public Decimal PriceOverrides;
    	
    	public Decimal Total_Part;
		public Decimal Total_Laobur;
		public Decimal Total_Sublet;
		public Decimal Total_Fee;
    	public List<IndividualTax> SalesTaxList;
    	
    	public GridTotal(Decimal total, Decimal salesTax, Decimal priceOverride, 
    					  Decimal total_Part, Decimal total_Laobur, Decimal total_Sublet, Decimal total_Other,
    					  Map<String, Decimal> salesTaxNameToTaxValue) {
    		this.Total = total.setScale(2);
    		this.SalesTax = salesTax.setScale(2);
    		this.PriceOverrides = priceOverride.setScale(2);
    		
    		this.Total_Part = total_Part.setScale(2);
    		this.Total_Laobur = total_Laobur.setScale(2);
    		this.Total_Sublet = total_Sublet.setScale(2);
    		this.Total_Fee = total_Other.setScale(2);
    		
    		this.SalesTaxList = new List<IndividualTax>();
    		for(String taxName : salesTaxNameToTaxValue.keySet()) {
    			this.SalesTaxList.add(new IndividualTax(taxName, salesTaxNameToTaxValue.get(taxName)));	
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
    		if(VendorOrderLineItemRec.Status__c == null) {
    			this.Status = VendorOrderLineItemRec.CO_Line_Item__r.Status__c == 'Ordered' ? 'Ordered':'Required' ;	
    		}
    		else{
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
    
}