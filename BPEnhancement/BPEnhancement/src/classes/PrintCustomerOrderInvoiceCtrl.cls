/**
 * Name: PrintCustomerOrderInvoiceCtrl
 * Description: 
 * 
**/
global with sharing class PrintCustomerOrderInvoiceCtrl {
    public static Map<String, String> merchandiseNameToType = new Map<String, String>{'Part'    => 'Part',
                                                                                      'Fee'     => 'Fee',
                                                                                      'Labour'  => 'Labour',
                                                                                      'Sublet'  => 'Sublet'};
    
    /**
     * Name: getCOInvoiceDetails
     * Desc: 
     * @param:  (1) coInvoiceIdStr
     * @return: String - JSON String
    **/
    @RemoteAction
    global static String getCOInvoiceDetails(String coInvoiceIdStr) {
        String coInvoiceDetails;
        coInvoiceIdStr = BPUtility.getDecodedString(coInvoiceIdStr);
    	try{
            Id coInvoiceId = coInvoiceIdStr;
            List<CO_Invoice_Header__c> coInvoices = getCustomerOrderInvoiceHeaders(new List<Id>{coInvoiceId});
            if(coInvoices.size() > 0) {
                List<Id> coliIds = new List<Id>();
                List<Id> sohIds = new List<Id>();
                if(coInvoices[0].CO_Invoice_Items__r != null) {
                    for(CO_Invoice_Item__c coInvoiceItem : coInvoices[0].CO_Invoice_Items__r) {
                        if(coInvoiceItem.CO_Line_Item__c != null) {
                            coliIds.add(coInvoiceItem.CO_Line_Item__c);
                        }
                        if(coInvoiceItem.Service_Order_Header__c != null) {
                            sohIds.add(coInvoiceItem.Service_Order_Header__c);
                        }
                    }
                }
                
                Id coId = coInvoices[0].CO_Header__c;
                List<CO_Header__c> coHeadersList = getCustomerOrderHeaders(new List<Id>{coId}, coliIds);
                List<Service_Order_Header__c> soHeadersList = getServiceOrderHeaders(new List<Id>{coId}, sohIds);
                
                coInvoiceDetails = System.JSON.serialize(new CustomerOrderInvoiceDetail(coInvoices[0], coHeadersList, soHeadersList));
            }
        } catch(Exception e) {
            coInvoiceDetails = '{}';
        }
        
        return BPUtility.getEncodedString(coInvoiceDetails);
    }
    
    
    
    /**
     * Name: getCOInvoiceDetails
     * Desc: 
     * @param:  (1) coInvoiceIdStr
     * @return: String - JSON String
    **/
    @RemoteAction
    global static String getMerchandiseDetails(String coHeaderId, Boolean isAustralianMarket) {
        coHeaderId = BPUtility.getDecodedString(coHeaderId);
    	List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeaderId);
        List<CO_Kit_Header__c> coKitHeaders = SOQLUtil.getCOKHByCOHeaderId(coHeaderId);
        List<CO_Header__c> coHeadersList = getCustomerOrderDetails(coHeaderId);
        List<COHeaderWrapper.COKitHeader> COKHList = COHeaderWrapper.getCOLineItemsList(coLineItems, coKitHeaders);
        if(coLineItems == null) {
            coLineItems = new List<CO_Line_Item__c>();
        }
        
        Decimal subtotal = 0;
        Decimal salesTax = 0;
        Decimal priceOverrides = 0;
        
        Decimal total_Part = 0;
        Decimal total_Laobur = 0;
        Decimal total_Sublet = 0;
        Decimal total_Fee = 0;
        Map<String, Decimal> salesTaxNameToTaxValue = new Map<String, Decimal>();            
            //Decimal australianMarketTaxRate = (Australian_Market__c.getInstance().get(Constants.NAMESPACE + 'Sales_Tax_Rate__c') != null) ? 
                                                //Decimal.valueOf(String.valueOf(Australian_Market__c.getInstance().get(Constants.NAMESPACE + 'Sales_Tax_Rate__c'))) : 0;
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        for(CO_Line_Item__c coLineItemRec : coLineItems) {
            coLineItemRec.Qty__c = (coLineItemRec.Qty__c == null) ? 0 : coLineItemRec.Qty__c;
            coLineItemRec.Price__c = (coLineItemRec.Price__c == null) ? 0 : coLineItemRec.Price__c;
            coLineItemRec.Retail__c = (coLineItemRec.Retail__c == null) ? 0 : coLineItemRec.Retail__c;
            coLineItemRec.Tax__c = (coLineItemRec.Tax__c == null) ? 0 : coLineItemRec.Tax__c;
            
            for(Individual_Tax__c individualTaxRec : coLineItemRec.Individual_Taxes__r) {
            	Decimal taxValue;
            	if(salesTaxNameToTaxValue.containsKey(individualTaxRec.Sales_Tax_Item_Name__c)) {
            		taxValue = salesTaxNameToTaxValue.get(individualTaxRec.Sales_Tax_Item_Name__c);
            	} else {
            		taxValue = 0;
            	}
            	taxValue += (individualTaxRec.Tax_Rate__c * coLineItemRec.Qty__c * coLineItemRec.Price__c) / 100;
            	salesTaxNameToTaxValue.put(individualTaxRec.Sales_Tax_Item_Name__c, taxValue);
            }
            
            if(coLineItemRec.Kit_Price_With_Price_Level__c == null  ){
                coLineItemRec.Kit_Price_With_Price_Level__c = coLineItemRec.Price__c;
            }
            if(coLineItemRec.CO_Kit_Header__c != null ){
                priceOverrides += coLineItemRec.Qty__c * (coLineItemRec.Price__c - coLineItemRec.Kit_Price_With_Price_Level__c);
            }else If(coLineItemRec.CO_Kit_Header__c == null ){
                priceOverrides += coLineItemRec.Qty__c * (coLineItemRec.Price__c - coLineItemRec.Actual_Kit_Price__c);
            }
            
            if(!isTaxIncludingPricing) {
                if(coLineItemRec.Part__c != null) {
                    total_Part += coLineItemRec.Qty__c * coLineItemRec.Price__c;
                }
                if(coLineItemRec.Fee__c != null) {
                    total_Fee += coLineItemRec.Qty__c * coLineItemRec.Price__c;
                }
                subtotal += coLineItemRec.Qty__c * coLineItemRec.Price__c;
                salesTax += (coLineItemRec.Qty__c * coLineItemRec.Price__c * coLineItemRec.Tax__c) / 100;
            } else {
            	if(coLineItemRec.Price__c == null) {
            		coLineItemRec.Price__c = 0;
            	}
            	if(coLineItemRec.Tax__c == null) {
            		coLineItemRec.Tax__c = 0;
            	}
            	if(coLineItemRec.Part__c != null) {
                    total_Part += (coLineItemRec.Qty__c * coLineItemRec.Price__c) + 
                    			((coLineItemRec.Qty__c * coLineItemRec.Price__c * coLineItemRec.Tax__c) / 100);
                }
                if(coLineItemRec.Fee__c != null) {
                    total_Fee += (coLineItemRec.Qty__c * coLineItemRec.Price__c) + 
                    			((coLineItemRec.Qty__c * coLineItemRec.Price__c * coLineItemRec.Tax__c) / 100);
                }
                subtotal += coLineItemRec.Sub_Total_With_Tax__c;
            }
        }
        List<CustomerMerchandies> cusRec =  new  List<CustomerMerchandies>();
        for(CO_Header__c coHeaderRec : coHeadersList ){
        	cusRec.add(new CustomerMerchandies(coHeaderRec) );
        }
        
        COMerchandiseDetail COMerchandiseDetailObj;
        if(coLineItems.size() > 0) {
            COMerchandiseDetailObj = new COMerchandiseDetail(COKHList, subtotal, salesTax, priceOverrides, total_Part, total_Laobur, total_Sublet, total_Fee, salesTaxNameToTaxValue, cusRec);
        }
        System.debug(COMerchandiseDetailObj);
        return BPUtility.getEncodedString(System.JSON.serialize(COMerchandiseDetailObj));
    }
    
    /**
     * Name: CustomerOrderInvoice
     * Description: Wrapper class
     * 
    **/
    public class CustomerOrderInvoiceDetail {
        public COInvoiceDetail COInvoice;
        public List<TransactionDetail> Transactions;
        public List<MerchandiseDetail> Merchandises;
        public List<ServiceDetail> Services;
        public Boolean IsTaxIncludingPricing;
        
        public CustomerOrderInvoiceDetail(CO_Invoice_Header__c coInvoiceHeader,
                                    List<CO_Header__c> coHeadersList, 
                                    List<Service_Order_Header__c> soHeadersList
                                ) {
            this.COInvoice = new COInvoiceDetail(coInvoiceHeader);
            this.IsTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            this.Transactions = new List<TransactionDetail>();
            if(coHeadersList != null) {
                for(CO_Header__c coHeader : coHeadersList) {
                    if(coHeader.CO_Deposits__r != null && coHeader.CO_Deposits__r.size() > 0) {
                        this.Transactions.add(new TransactionDetail(coHeader.CO_Deposits__r));
                    }
                }
            }
            if(coInvoiceHeader.CO_Deposits__r != null && coInvoiceHeader.CO_Deposits__r.size() > 0) {
                this.Transactions.add(new TransactionDetail(coInvoiceHeader.CO_Deposits__r));
            }
            if(coInvoiceHeader.CO_Invoice_Payments__r != null && coInvoiceHeader.CO_Invoice_Payments__r.size() > 0) {
                this.Transactions.add(new TransactionDetail(coInvoiceHeader.CO_Invoice_Payments__r));
            }
            
            this.Merchandises = new List<MerchandiseDetail>();
            if(coHeadersList != null) {
                for(CO_Header__c coHeader : coHeadersList) {
                    if(coHeader.CO_Line_Items__r.size() > 0) {
                    	for(CO_Line_Item__c coliRec : coHeader.CO_Line_Items__r) {
                    		this.Merchandises.add(new MerchandiseDetail(COInvoice, coliRec));
                    	}
                    }
                }
            }
            
            this.Services = new List<ServiceDetail>();
            if(coHeadersList != null) {
                for(Service_Order_Header__c soHeader : soHeadersList) {
                    this.Services.add(new ServiceDetail(COInvoice, soHeader));
                }
            }
            
            coInvoice.Total = coInvoice.SubTotal + coInvoice.SalesTax;
        }
    }
    
    /**
     * Name: COInvoiceDetail
     * Description: Wrapper class
     * 
    **/
    public class COInvoiceDetail {
        public String StoreCityProv;
        public String StorePostal;
        public String StoreBusinessNumber;
        public String StoreWebsite;
        
        public String CustomerName;
        public String CustomerAddress;
        public String CustomerAddress2;
        public String CustomerCityProv;
        public String CustomerPostal;
        
        public String InvoiceId;
        public String InvoiceNumber;
        public String InvoiceDate;
        public String Status;
        public String SoldBy;
        
        public Decimal TotalParts;
        public Decimal TotalLabour;
        public Decimal TotalSublet;
        public Decimal TotalFees;
        public Decimal SubTotal;
        public Decimal SalesTax;
        public Decimal Total;
        public Decimal MerchandiseTotal;
        
        public COInvoiceDetail(CO_Invoice_Header__c coInvoiceHeader) {
            TotalParts  = 0;
            TotalLabour = 0;
            TotalSublet = 0;
            TotalFees   = 0;
            SubTotal    = 0;
            SalesTax    = 0;
            Total       = 0;
            MerchandiseTotal = 0;
            
            if(coInvoiceHeader != null) {
                CustomerName        = coInvoiceHeader.CO_Header__r.Customer__r.Name;
                CustomerAddress     = coInvoiceHeader.CO_Header__r.Customer__r.BillingStreet;
                CustomerAddress2    = coInvoiceHeader.CO_Header__r.Customer__r.BillingCountry;
                CustomerCityProv    = coInvoiceHeader.CO_Header__r.Customer__r.BillingCity;
                CustomerCityProv    = (CustomerCityProv != null && CustomerCityProv != '') ? (CustomerCityProv + '/' + coInvoiceHeader.CO_Header__r.Customer__r.BillingState) : coInvoiceHeader.CO_Header__r.Customer__r.BillingState;
                CustomerPostal      = coInvoiceHeader.CO_Header__r.Customer__r.BillingPostalCode;
                
                InvoiceId       = coInvoiceHeader.Id;
                InvoiceNumber   = coInvoiceHeader.Name;
                InvoiceDate     = coInvoiceHeader.CreatedDate.format('MM/dd/yyyy');
                Status          = coInvoiceHeader.Status__c;
                SoldBy          = coInvoiceHeader.CreatedBy.Name;
            }
        }
    }
    
    /**
     * Name: TransactionDetail
     * Description: Wrapper class
     * 
    **/
    public class TransactionDetail {
        public boolean IsDeposit;
        public boolean IsPayment;
        public String Method;
        public String TransactionDate;
        public decimal Amount;
        
        public TransactionDetail(List<CO_Deposit__c> coDeposits) {
            if(coDeposits != null) {
                for(CO_Deposit__c deposit : coDeposits) {
                    IsDeposit   = true;
                    IsPayment   = false;
                    Method      = deposit.Payment_Method__c;
                    Amount      = deposit.Amount__c;
                    TransactionDate = deposit.LastModifiedDate.format('MM/dd/yyyy');
                }
            }
        }
        
        public TransactionDetail(List<CO_Invoice_Payment__c> coPayments) {
            if(coPayments != null) {
                for(CO_Invoice_Payment__c payment : coPayments) {
                    IsPayment   = true;
                    IsDeposit   = false;
                    Method      = payment.Payment_Method__c;
                    Amount      = payment.Amount__c;
                    TransactionDate = payment.LastModifiedDate.format('MM/dd/yyyy');
                }
            }
        }
    }
    
     public static List<CO_Header__c> getCustomerOrderDetails(Id CoheaderId) {
     	 List<CO_Header__c> coHeaderRec = [SELECT Id, 
                                                        Name,
                                                        Status__c,
                                                        CreatedDate,
                                                        CreatedBy.Name,
                                                       	Customer__c,
                                                        Customer__r.Name,
                                                       	Customer__r.BillingStreet,
                                                        Customer__r.BillingCity,
                                                        Customer__r.BillingState,
                                                        Customer__r.BillingPostalCode,
                                                        Customer__r.BillingCountry
                                                        from CO_Header__c WHERE Id =: CoheaderId
                                       ];
     	return coHeaderRec;
     }
    
    /**
     * Name: MerchandiseDetail
     * Description: Wrapper class
     * 
    **/
    public class MerchandiseDetail {
        public String Type;
        public String ItemDesc;
        public decimal Qty;
        public decimal Price;
        public decimal Total;
        
        public MerchandiseDetail(COInvoiceDetail coInvoice, CO_Line_Item__c coli) {
        	ItemDesc    = coli.Item_ID__c;
            Qty         = coli.Qty__c;
            Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            if(coli.Tax__c == null) {
        		coli.Tax__c = 0;
        	}
        	if(coli.Price__c == null) {
        		coli.Price__c = 0;
        	}
            	
            if(coli.Fee__c != null) {
                // Fee
                Type    = PrintCustomerOrderInvoiceCtrl.merchandiseNameToType.get('Fee');
                if(!isTaxIncludingPricing) {
                	coInvoice.TotalFees += coli.Sub_Total_Without_Tax__c;
                } else {
                	Decimal taxAmount = (coli.Price__c * coli.Tax__c / 100);
            		coInvoice.TotalFees += (coli.Price__c + taxAmount).setScale(2);
                }
            } else if(coli.Part__c != null) {
                // Part
                Type    = PrintCustomerOrderInvoiceCtrl.merchandiseNameToType.get('Part');
                if(!isTaxIncludingPricing) {
                	coInvoice.TotalParts += coli.Sub_Total_Without_Tax__c;
                } else {
                	Decimal taxAmount = (coli.Price__c * coli.Tax__c / 100);
            		coInvoice.TotalParts += (coli.Price__c + taxAmount).setScale(2);
                }
            } else {
                // Labour
                Type    = PrintCustomerOrderInvoiceCtrl.merchandiseNameToType.get('Labour');
                if(!isTaxIncludingPricing) {
                	coInvoice.TotalLabour += coli.Sub_Total_Without_Tax__c;
                } else {
                	Decimal taxAmount = (coli.Price__c * coli.Tax__c / 100);
            		coInvoice.TotalLabour += (coli.Price__c + taxAmount).setScale(2);
                }
            }
            
            if(isTaxIncludingPricing) {
            	Decimal taxAmount = (coli.Price__c * coli.Tax__c / 100);
            	Price = (coli.Price__c + taxAmount).setScale(2);
            	Total = Price * Qty;
            } else {
            	Price = coli.Price__c;
            	Total = coli.Sub_Total_Without_Tax__c;
            }
            
            
            // Calculations for Invoice
            coInvoice.SalesTax += coli.Tax_Amount__c;
            coInvoice.SubTotal += this.Total;
            coInvoice.MerchandiseTotal += this.Total;
        }
    }
    
    /**
     * Name: ServiceDetail
     * Description: Wrapper class
     * 
    **/
    public class ServiceDetail {
        public String Name;
        public decimal Total;
        public String Correction;
        public String Cause;
        public String Concern;
        public decimal MileageIn;
        public decimal MileageOut;
        public String Unit;
        
        public List<ServiceItemsDetail> ServiceItems;
        
        public ServiceDetail(COInvoiceDetail coInvoice, Service_Order_Header__c soHeader) {
            // Service details
            Name    = soHeader.Name__c;
            Total   = 0;
            Correction  = soHeader.Correction__c;
            Cause   = soHeader.Cause__c;
            Concern = soHeader.Concern__c;
            if(soHeader.Customer_Owned_Unit__c != null) {
                MileageIn   = soHeader.Odometer_on_Arrival__c;
                MileageOut  = soHeader.Odometer_on_Departure__c;
                Unit        = soHeader.Customer_Owned_Unit__r.VIN__c 
                              + ' ' + soHeader.Customer_Owned_Unit__r.Year__c
                              + ' ' + soHeader.Customer_Owned_Unit__r.Unit_Make__r.Name
                              + ' ' + soHeader.Customer_Owned_Unit__r.Unit_Model__r.Name__c;
            }
            Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            // Service Line Items
            ServiceItems = new List<ServiceItemsDetail>();
            if(soHeader != null && soHeader.Service_Order_Line_Items__r != null) {
                for(Service_Order_Line_Item__c soli : soHeader.Service_Order_Line_Items__r) {
                    ServiceItems.add(new ServiceItemsDetail(coInvoice, soli));
                    if(isTaxIncludingPricing) {
		            	Decimal taxAmount = (soli.Kit_Price__c * soli.Tax_Percent__c / 100);
		            	decimal Price = (soli.Kit_Price__c + taxAmount).setScale(2);
		            	this.Total += Price * soli.Qty_Needed__c;
		            } else {
		            	this.Total += soli.Kit_Price__c * soli.Qty_Needed__c;
		            }
                }
            }
        }
    }
    
    /**
     * Name: ServiceItemsDetail
     * Description: Wrapper class
     * 
    **/
    public class ServiceItemsDetail {
        public String Type;
        public String ItemDesc;
        public decimal Qty;
        public decimal Price;
        public decimal Total;
        
        public ServiceItemsDetail(COInvoiceDetail coInvoice, Service_Order_Line_Item__c soli) {
        	Qty         = soli.Qty_Needed__c;
        	Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        	if(soli.Tax_Percent__c == null) {
        		soli.Tax_Percent__c = 0;
        	}
            if(soli.Fee__c != null) {
                // Fee
                Type    = PrintCustomerOrderInvoiceCtrl.merchandiseNameToType.get('Fee');
                if(!isTaxIncludingPricing) {
                	coInvoice.TotalFees += soli.Kit_Price__c;
                } else {
                	Decimal taxAmount = (soli.Kit_Price__c * soli.Tax_Percent__c / 100);
            		coInvoice.TotalFees += (soli.Kit_Price__c + taxAmount).setScale(2);
                }
            } else if(soli.Part__c != null) {
                // Part
                Type    = PrintCustomerOrderInvoiceCtrl.merchandiseNameToType.get('Part');
            	if(!isTaxIncludingPricing) {
                	coInvoice.TotalParts += soli.Kit_Price__c;
                } else {
                	Decimal taxAmount = (soli.Kit_Price__c * soli.Tax_Percent__c / 100);
            		coInvoice.TotalParts += (soli.Kit_Price__c + taxAmount).setScale(2);
                }
            } else {
                // Labour
                Type    = PrintCustomerOrderInvoiceCtrl.merchandiseNameToType.get('Labour');
                if(!isTaxIncludingPricing) {
                	coInvoice.TotalLabour += soli.Kit_Price__c;
                } else {
                	Decimal taxAmount = (soli.Kit_Price__c * soli.Tax_Percent__c / 100);
            		coInvoice.TotalLabour += (soli.Kit_Price__c + taxAmount).setScale(2);
                }
            }
            
            ItemDesc    = soli.Item_Desc__c;
            if(isTaxIncludingPricing) {
            	Decimal taxAmount = (soli.Kit_Price__c * soli.Tax_Percent__c / 100);
            	Price = (soli.Kit_Price__c + taxAmount).setScale(2);
            	Total = Price * Qty;
            } else {
            	Price = soli.Kit_Price__c;
            	Total = soli.Kit_Price__c * Qty;
            }
            
            // Calculations for Invoice
            coInvoice.SalesTax += (soli.Kit_Price__c * soli.Tax_Percent__c / 100);
            coInvoice.SubTotal += this.Total;
        }
    }
    
    private static List<CO_Invoice_Header__c> getCustomerOrderInvoiceHeaders(List<Id> coInvoiceIdsList) {
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Deposit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<CO_Invoice_Header__c> coInvoices = [SELECT Id, 
                                                        Name,
                                                        Status__c,
                                                        CreatedDate,
                                                        CreatedBy.Name,
                                                        CO_Header__c,
                                                        CO_Header__r.Customer__c,
                                                        CO_Header__r.Customer__r.Name,
                                                        CO_Header__r.Customer__r.BillingStreet,
                                                        CO_Header__r.Customer__r.BillingCity,
                                                        CO_Header__r.Customer__r.BillingState,
                                                        CO_Header__r.Customer__r.BillingPostalCode,
                                                        CO_Header__r.Customer__r.BillingCountry,
                                                        (SELECT CO_Line_Item__c, Service_Order_Header__c FROM CO_Invoice_Items__r),
                                                        (SELECT Name, 
                                                                LastModifiedDate, 
                                                                Payment_Method__c, 
                                                                Amount__c 
                                                                FROM CO_Invoice_Payments__r
                                                                WHERE Amount__c != 0
                                                        ),
                                                        (SELECT Name, 
                                                                LastModifiedDate, 
                                                                Payment_Method__c, 
                                                                Amount__c 
                                                                FROM CO_Deposits__r
                                                                WHERE Amount__c != 0
                                                        )
                                                        FROM CO_Invoice_Header__c 
                                                        WHERE Id IN: coInvoiceIdsList
                                                ];
        return coInvoices;
    }
    
    private static List<CO_Header__c> getCustomerOrderHeaders(List<Id> coIdsList, List<Id> coliIds) {
        List<CO_Header__c> coHeadersList;
        if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
       
        if(coIdsList != null && coIdsList.size() > 0) {
            coHeadersList = [SELECT Id, 
                                    Name,
                                    Total_COLI__c,
                                    Total_SO__c,
                                    Total_Deposit__c,
                                    Total_Payment__c,
                                    Total_Order_Value__c,
                                    (SELECT Item_ID__c, 
                                            Part__c, Fee__c, 
                                            Qty__c, Price__c, 
                                            Sub_Total_Without_Tax__c, 
                                            Tax__c,
                                            Tax_Amount__c 
                                            FROM CO_Line_Items__r 
                                            WHERE Price__c != 0 
                                            AND Is_In_Service_Order__c = false
                                            AND Id IN: coliIds
                                    )
                                    FROM CO_Header__c 
                                    WHERE Id IN: coIdsList
                            ];
        }
        
        return coHeadersList;
    }
    
    private static List<Service_Order_Header__c> getServiceOrderHeaders(List<Id> coIdsList, List<Id> sohIds) {
        List<Service_Order_Header__c> soHeadersList;
         if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Customer_Owned_Unit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(coIdsList != null && coIdsList.size() > 0) {
            soHeadersList = [SELECT Id, 
                                    Name__c,
                                    Total__c,
                                    Correction__c, 
                                    Cause__c,
                                    Concern__c, 
                                    Customer_Owned_Unit__c,
                                    Customer_Owned_Unit__r.VIN__c,
                                    Customer_Owned_Unit__r.Unit_Make__r.Name,
                                    Customer_Owned_Unit__r.Unit_Model__r.Name__c,
                                    Customer_Owned_Unit__r.Year__c,
                                    Odometer_on_Arrival__c,
                                    Odometer_on_Departure__c,
                                    (SELECT Id, 
                                            Item_Desc__c, 
                                            Kit_Price__c, 
                                            Labour_Code__c, 
                                            Part__c, 
                                            Qty_Needed__c, 
                                            Total__c, 
                                            Fee__c, 
                                            Tax_Percent__c,
                                            Tax_Amount__c 
                                            FROM Service_Order_Line_Items__r
                                    )
                                    FROM Service_Order_Header__c
                                    WHERE Id IN: sohIds
                            ];
        }
        
        return soHeadersList;
    }
    
    
    /**
     * Name: COInvoiceDetail
     * Description: Wrapper class
     * 
    **/
    public class COMerchandiseDetail {
        // List of CO Line Items
        public List<COHeaderWrapper.COKitHeader> COKHList{get; set;}
        
        public GridTotal gridTotal {get; set;}
        
        public List<CustomerMerchandies> custmerMercRec = new  List<CustomerMerchandies>();
        
        public COMerchandiseDetail(List<COHeaderWrapper.COKitHeader> COKHList, Decimal subtotal, Decimal salesTax, Decimal priceOverrides, 
                                            Decimal total_Part, Decimal total_Laobur, Decimal total_Sublet, Decimal total_Fee,
                                            Map<String, Decimal> salesTaxNameToTaxValue, List<CustomerMerchandies> custmerMercRec){
            this.COKHList = COKHList;
            this.gridTotal = new GridTotal(subtotal, salesTax, priceOverrides, total_Part, total_Laobur, total_Sublet, total_Fee, salesTaxNameToTaxValue);
            this.custmerMercRec =  custmerMercRec; 
        }
    }
    
    public class CustomerMerchandies {
        public String StoreCityProv;
        public String StorePostal;
        public String StoreBusinessNumber;
        public String StoreWebsite;
        
        public String CustomerName;
        public String CustomerAddress;
        public String CustomerAddress2;
        public String CustomerCityProv;
        public String CustomerPostal;
        
       	public CustomerMerchandies(CO_Header__c coHeaderRec) {
         	if(coHeaderRec != null) {
                CustomerName        = coHeaderRec.Customer__r.Name;
                CustomerAddress     = coHeaderRec.Customer__r.BillingStreet;
                CustomerAddress2    = coHeaderRec.Customer__r.BillingCountry;
                CustomerCityProv    = coHeaderRec.Customer__r.BillingCity;
                CustomerCityProv    = (CustomerCityProv != null && CustomerCityProv != '') ? (CustomerCityProv + '/' + coHeaderRec.Customer__r.BillingState) : coHeaderRec.Customer__r.BillingState;
                CustomerPostal      = coHeaderRec.Customer__r.BillingPostalCode;
                
            }
        }
        
    }
    public class GridTotal {
        public Decimal SubTotal;
        public Decimal SalesTax;
        public Decimal PriceOverrides;
        
        public Decimal Total_Part;
        public Decimal Total_Laobur;
        public Decimal Total_Sublet;
        public Decimal Total_Fee;
        public List<IndividualTax> SalesTaxList;
        
        public GridTotal(Decimal subtotal, Decimal salesTax, Decimal priceOverride, 
                          Decimal total_Part, Decimal total_Laobur, Decimal total_Sublet, Decimal total_Other,Map<String, Decimal> salesTaxNameToTaxValue){
            this.SubTotal = Subtotal.setScale(2);		                           
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
}