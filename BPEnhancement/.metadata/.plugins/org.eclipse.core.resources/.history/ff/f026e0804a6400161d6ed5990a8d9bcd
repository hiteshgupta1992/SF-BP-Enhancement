/**
 * Author: Tarun Khandelwal
 * Since: Feb 15, 2016
 * Name: HomeSearchUtil
 * Description: Class used to hold utility methods, variables and mapping used in Home Search screen
 * 
**/
public with sharing class HomeSearchUtil {
	public static List<PaginationSorting.SortAttrs> sortMapping;
	
	/**
	 * Name: getGenericObjectNameBySelectedObject 
	 * Description: To get Generic object name by Selected object set
	 * @param: 1. Set<String> objectNamesSet - selected object set
	 * @return: String
	 */
	public static String getGenericObjectNameBySelectedObject(Set<String> objectNamesSet) {
		List<String> objectNames = new List<String>(objectNamesSet);
		if(objectNamesSet.size() == 0) {
			return Label.Generic_Object_Label;
		}
		
		if(objectNames.size() == 1) {
			return objectNames[0];
		}
		
		for(String groupName : groupNameToGroupObjectsMap.keySet()) {
			Set<String> mapObjects = new Set<String>(groupNameToGroupObjectsMap.get(groupName));
			
			boolean isAGroup = true;
			for(String objNameSelected : objectNamesSet) {
				if( mapObjects.contains(objNameSelected) == false ) {
					isAGroup = false;
					break;
				}
			}
			if(isAGroup){
				return groupName;
			}
		}
		
		return Label.Generic_Object_Label;
	}
	
	/**
	 * Name: getPickValues 
	 * Description: To get picklist values by describe call
	 * @param: 	1. String objectName - object name
	 *			2. String fieldName - Picklist field API Name
	 * @return: List<String> - Picklist options
	 */
	public static List<String> getPickValues(String objectName, String fieldName) {
		List<String> lstPickvals = new List<String>();
		
		if(Schema.getGlobalDescribe().containsKey(objectName)) {
			Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
			Sobject Object_name = targetType.newSObject();
			Schema.sObjectType sobject_type = Object_name.getSObjectType();
			
			Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
			Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
			if(field_map.containsKey(fieldName)) {
				List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
				
				for (Schema.PicklistEntry a : pick_list_values) {
					lstPickvals.add(a.getValue());
				}
			}
		}
		return lstPickvals;
	}
	
	// Map of object name to owner field API Name
	public static Map<String, String> objectToOwnerObjectFieldName = new Map<String,String>{'Part__c'	=>	'Vendor__r',
																							'CO_Invoice_Header__c'	=>	'CO_Header__r.Owner__c',
                                                                                            'CO_Invoice_Payment__c' =>  'CO_Invoice_Header__r.CO_Header__r.Owner__c',
																							'Product__c'	=>	'Vendor__r'
																						};
    
    // Map of object name to related grid columns name and field API name(Used in sorting attributes for records)
    public static Map<String, Map<String, String>> obejctNameToMapOfSortLabelToAPIName = new Map<String, Map<String, String>>{
																							'Account' => new Map<String, String>{'Id'		=>	'Id',
																																 'Key'		=>	'Name',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																															},
    																						CONSTANTS.NAMESPACE+'Part__c' => new Map<String, String>{'Id'		=>	'Id',
																																 'Key'		=>	'Part_Number__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Vendor__r.Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
    																						CONSTANTS.NAMESPACE+'Labour_Code__c' => new Map<String, String>{'Id'=>	'Id',
																																 'Key'		=>	'Code__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
    																						CONSTANTS.NAMESPACE+'CO_Header__c' => new Map<String, String>{'Id'=>	'Id',
																																 'Key'		=>	'Name',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner__r.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
    																						'User' => new Map<String, String>{	 'Id'		=>	'Id',
																																 'Key'		=>	'UserName',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'CreatedBy.Name',
																																 'Name'		=>	'Title',
																																 'Status' => 'IsActive'
																																},
    																						CONSTANTS.NAMESPACE+'Kit_Header__c' => new Map<String, String>{'Id'	=>	'Id',
																																 'Key'		=>	'Code__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
    																						CONSTANTS.NAMESPACE+'Fee__c' => new Map<String, String>{ 'Id'		=>	'Id',
																																 'Key'		=>	'Code__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
    																						
    																						CONSTANTS.NAMESPACE+'CO_Invoice_Header__c' => new Map<String, String>{ 'Id'	=>	'Id',
																																 'Key'		=>	'Invoice_Number__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'CO_Header__r.Owner__r.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Invoice_Number__c'
																																},
                                                                                                                                
                                                                                            CONSTANTS.NAMESPACE+'CO_Invoice_Payment__c' => new Map<String, String>{ 'Id'    =>  'Id',
                                                                                                                                 'Key'      =>  'Name',
                                                                                                                                 'LastModifiedDate' =>  'LastModifiedDate',
                                                                                                                                 'Created'  =>  'CreatedDate',
                                                                                                                                 'Owner'    =>  'CO_Invoice_Header__r.CO_Header__r.Owner__r.Name',
                                                                                                                                 'Name'     =>  'Name'
                                                                                                                                },
                                                                                                                                                                    
                                                                                            CONSTANTS.NAMESPACE+'Vendor_Order_Header__c' => new Map<String, String>{ 'Id'   =>  'Id',
																																 'Key'		=>	'Name',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner__r.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
    																						CONSTANTS.NAMESPACE+'Vendor_Receiving_Header__c' => new Map<String, String>{ 'Id'	=>	'Id',
																																 'Key'		=>	'Name',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner__r.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
																							CONSTANTS.NAMESPACE+'Vendor_Invoicing_Header__c' => new Map<String, String>{ 'Id'	=>	'Id',
																																 'Key'		=>	'Name',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner__r.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
																							CONSTANTS.NAMESPACE+'Category__c' => new Map<String, String>{ 'Id'	=>	'Id',
																																 'Key'		=>	'Unique_Category__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
																							CONSTANTS.NAMESPACE+'Price_Level__c' => new Map<String, String>{'Id'=>	'Id',
																																 'Key'		=>	'Name__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
																							CONSTANTS.NAMESPACE+'Sales_Tax__c' => new Map<String, String>{'Id'=>	'Id',
																																 'Key'		=>	'Name__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																},
																																
																							CONSTANTS.NAMESPACE+'Product__c' => new Map<String, String>{'Id'=>	'Id',
																																 'Key'		=>	'Code__c',
																																 'LastModifiedDate'	=>	'LastModifiedDate',
																																 'Created'	=>	'CreatedDate',
																																 'Owner'	=>	'Vendor__r.Owner.Name',
																																 'Status'	=>	'Status__c',
																																 'Name'		=>	'Name'
																																}
																																
																					};
    
    public static Map<String, String> searchableObjectToUniqueValueFieldMap = new Map<String, String>{
    	'Account'					=> 'Name',
    	'Part__c'					=> 'Name',
		'Labour_Code__c'			=> 'Name',
		'Kit_Header__c'				=> 'Name',
		'Fee__c'					=> 'Name',
		'CO_Header__c'				=> 'Name',
		'CO_Invoice_Header__c'		=> 'Invoice_Number__c',
        'CO_Invoice_Payment__c'     => 'Name', 
		'Vendor_Order_Header__c'	=> 'Name',
		'Vendor_Receiving_Header__c'=> 'Name',
		'Vendor_Invoicing_Header__c'=> 'Name',
		'Category__c'				=> 'Unique_Category__c',
		'Price_Level__c'			=> 'Name',
		'Sales_Tax__c'				=> 'Name',
		'Product__c'				=> 'Name',
		'User'						=> 'UserName'
    };
    
    // A Map of Objects to associated fields on which search to be performed -> Used to make JSON + Result Wrapper
    public static Map<String, Set<String>> searchableObjectToFieldsMap = new Map<String, Set<String>>{
            'Account'		=> new Set<String>{	'Id', 
            									'Is_Customer__c', 
            									'Is_Vendor__c', 
            									'Customer_Number__c',
            									'Active__c', 
            									'Name', 
            									'Description', 
            									'Phone', 
            									'Email__c', 
            									'BillingStreet', 
            									'BillingCity', 
            									'BillingState', 
            									'BillingCountry', 
            									'Sales_Tax__r.Name__c', 
            									'Price_Level__r.Name__c', 
            									'Preferred_Email__c',
            									'Preferred_Phone__c',
            									'Vendor_Code__c',
            									'Owner.Name', 
            									'OwnerId',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Status__c',
            									'FirstName__c',
            									'LastName__c',
												'Nickname__c',
												'Birth_Date__c',
												'VIP__c',
												'Job_Title__c',
												'ShippingStreet',
												'ShippingCity',
												'ShippingState',
												'Mobile__c',
												'Other_Email__c',
												'Home_Number__c',
												'Work_Email__c',
												'Work_Number__c',
												'Facebook__c',
												'LinkedIn__c',
												'Twitter__c',
												'Website',
												'Sales_Tax__c',
												'Sales_Tax__r.Name__c',
												'Price_Level__c',
												'Price_Level__r.Name__c',
												'Open_Orders__c',
												'Orders_Lifetime__c',
												'Average_Spend_per_Order__c',
												'CreatedDate',
												'Last_Visit_Order__c',
												'Purchase_Tax__c',
												'Purchase_Tax__r.Name__c',
												'Part_Category_Default__c',
												'Part_Category_Default__r.Name',
												'Unit_Category_Default__c',
												'Unit_Category_Default__r.Name',
												'Claims_for_Service_Work__c',
												'Flooring_Company__c',
												'Unit_Purchases__c',
												'Part_Purchases__c',
												'Sublet_Purchases__c',
												'Warranty_Plan_Sales_on_Unit_Deals__c'
																								
            								},
            								
            'Part__c'		=> new Set<String>{	'Id', 
            									'Part_Number__c', 
            									'Active__c', 
            									'Description__c', 
            									'AvailableParts__c', 
            									'Vendor__c',
            									'Vendor__r.Vendor_Code__c',
            									'Qty_In_Stock__c',
												'Qty_Committed__c',
												'Qty_On_Order__c',
												'Retail_Price__c',
												'Location__c',
												'Category__r.Name',
												'Category__c',
												'Status__c',
												'Name',
												'Last_Cost__c',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Vendor__r.OwnerId',
            									'Vendor__r.Name',
            									'Vendor__r.Owner.Name',
            									'Status__c',
            									'Status__c',
            									'MSRP__c',
            									'Enviro_Fee__c',
            									'Average_Cost__c',
            									'Package_Cost__c',
            									'Package_Qty__c',
            									'Package_Unit__c',
            									'Last_Counted__c',
            									'Last_Sold__c',
            									'Last_Stocked__c',
            									'Auto_reorder_Min__c',
            									'Auto_reorder_Max__c',
            									'Order_Lots__c',
            									'Superseded_By__c',
            									'Superseded_By__r.Part_Number__c'
            									
            								},
            								
            'Labour_Code__c'=> new Set<String>{	'Id', 
            									'Name', 
            									'Active__c', 
            									'Description__c', 
            									'Code__c', 
            									'Category__r.Name',
												'Category__c',
												'Rate__c',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Owner.Name',
            									'OwnerId',
            									'Status__c',
            									'Code__c',
            									'Hours__c'
            								},
            
            'Kit_Header__c'	=> new Set<String>{	'Id', 
            									'Name', 
            									'Active__c', 
            									'Description__c', 
            									'Code__c', 
            									'Fixed_Price__c',
            									'OwnerId',
            									'Owner.Name', 
            									'LastModifiedDate', 
            									'CreatedDate', 
            									'Code__c',
            									'Kit_Unique_Name__c',
            									'Status__c',
            									'Service_Kit__c'
            								},
            								
            'Fee__c'		=> new Set<String>{	'Id', 
            									'Name', 
            									'Active__c', 
            									'Description__c', 
            									'Code__c', 
            									'Category__c',
            									'Category__r.Name',
            									'Price__c',
            									'Owner.Name', 
            									'OwnerId',
            									'LastModifiedDate', 
            									'CreatedDate', 
            									'Fee_Unique_Name__c',
            									'Status__c',
            									'Code__c'
            								},
            
            'CO_Header__c'=> new Set<String>{	'Id', 
            									'Name', 
            									'Customer__c',
            									'Customer__r.Name',
            									'Order_status__c', 
            									'Total_Order_Value__c', 
            									'Owner__r.Name', 
            									'Owner__c',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Total_Balance_Due__c',
            									'Status__c',
            									'Total_Payment__c',
            									'Total_Deposit__c'
            								},
           
	        'CO_Invoice_Header__c'=> new Set<String>{'Id', 
	            									'Name', 
                                                    'Invoice_Number__c',   
	            									'CO_Header__r.Customer__c',
	            									'CO_Header__r.Customer__r.Name',
	            									'Invoice_Status__c', 
	            									'Total_Payment__c',
	            									'CO_Header__r.Owner__r.Name',
	            									'CO_Header__r.Owner__c',
	            									'LastModifiedDate', 
	            									'CreatedDate',
	            									'CO_Header__c',
	            									'CO_Header__r.Name',
	            									'CO_Header__r.Owner__c',
	            									'CO_Header__r.Owner__r.Name',
	            									'CO_Header__r.Total_Balance_Due__c',
	            									'Status__c'
		            									
            								},
            
            'CO_Invoice_Payment__c'=> new Set<String>{'Id', 
                                                    'Name', 
                                                    'CO_Invoice_Header__r.CO_Header__c',
                                                    'CO_Invoice_Header__r.CO_Header__r.Name',
                                                    'CO_Invoice_Header__r.CO_Header__r.Customer__c',
                                                    'CO_Invoice_Header__r.CO_Header__r.Customer__r.Name',
                                                    'Amount__c',
                                                    'CO_Invoice_Header__r.CO_Header__r.Owner__r.Name',
                                                    'CO_Invoice_Header__r.CO_Header__r.Owner__c',
                                                    'CO_Invoice_Header__r.Status__c',
                                                    'LastModifiedDate', 
                                                    'CreatedDate',
                                                    'Payment_Method__c',
                                                    'Reverse_Payment_From__c',
                                                    'Reverse_Payment_From__r.Name'
                                            },                              
            
            'Vendor_Order_Header__c'=> new Set<String>{	'Id', 
		            									'Name', 
		            									'Vendor__c',
		            									'Vendor__r.Name',
		            									'Status__c',
		            									'Owner__r.Name', 
		            									'Owner__c',
		            									'LastModifiedDate', 
		            									'CreatedDate',
		            									'Total__c',
		            									'Total_Recieved__c',
		            									'Status__c',
		            									'Purchase_Order_Type__c',
		            									'Purchase_Order_Type__r.Code__c'		            									
            								},	
            								
            'Vendor_Receiving_Header__c'=> new Set<String>{	'Id', 
			            									'Name', 
			            									'Vendor__c',
			            									'Vendor__r.Name',
			            									'Status__c', 
			            									'Owner__r.Name', 
			            									'Owner__c',
			            									'Packing_Slip_Number__c',
			            									'LastModifiedDate', 
			            									'CreatedDate',
			            									'Status__c',
			            									'Receiving_Total__c'
            								},
            								
            'Vendor_Invoicing_Header__c'=> new Set<String>{	'Id', 
			            									'Name', 
			            									'Vendor__c',
			            									'Vendor__r.Name',
			            									'Status__c', 
			            									'Owner__r.Name', 
			            									'Owner__c',
			            									'Invoice_Number__c',
			            									'LastModifiedDate', 
			            									'CreatedDate',
			            									'Status__c',
			            									'Total__c'
            								},
			'Category__c'=> new Set<String>{	'Id', 
            									'Name', 
            									'Description__c',
            									'Status__c', 
            									'Owner.Name', 
            									'OwnerId',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Unique_Category__c',
            									'Type__c'
								},
			'Price_Level__c'=> new Set<String>{	'Id', 
            									'Name__c', 
            									'Description__c',
            									'Status__c', 
            									'Owner.Name', 
            									'OwnerId',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Name',
            									'Discount_Markup__c'
								},
			'Sales_Tax__c'=> new Set<String>{	'Id', 
            									'Name__c', 
            									'Forms_Label__c',
            									'Status__c', 
            									'Owner.Name', 
            									'OwnerId',
            									'LastModifiedDate', 
            									'CreatedDate',
            									'Name',
            									'Rate__c'
								},
								
			'Product__c' => new Set<String>{	'Id',
												'Description__c',
												'Category__r.Name',
												'Name',
												'Price__c',
												'Status__c', 
												'LastModifiedDate',
												'Vendor__r.Vendor_Code__c',
												'Cost__c',
												'Code__c',
												'Vendor__r.Owner.Name',
												'Vendor__r.Name',
												'CreatedDate'
								},
								
			'User' 		=> new Set<String>	{	'Id',
												'Name',
												'UserName',
												'Email',
												'LastModifiedDate',
												'CreatedDate',
												'CreatedBy.Name',
												'IsActive',
												'Phone'
								}
            								 
          };
	
	// A map to define group with object names
	public static Map<String, List<String>> groupNameToGroupObjectsMap = new Map<String, List<String>>{	'People' 			=> new List<String>{'Customers', 'Vendors'},
																										'Products' 			=> new List<String>{'Parts', 'Kits', 'Fees', 'Labor Codes', 'Sublets'},
																										'Customer Sales'	=> new List<String>{'Customer Orders', 'Customer Invoices', 'Customer Payments'},
																										'Vendor Ordering' 	=> new List<String>{'Vendor Orders', 'Vendor Receivings', 'Vendor Invoices'},
																										'Setting' 			=> new List<String>{'Item Categories', 'Sales Taxes', 'Price Levels'}
																									};
	
	// A map to define group/display object name to object API name
	public static Map<String, String> displayObjectNameToObjectAPINameMap = new Map<String, String>{'People'			=> 'Account',
																									'Customers'			=> 'Account',
																									'Vendors'			=> 'Account',
																									'Parts'				=> 'Part__c',
																									'Kits'				=> 'Kit_Header__c',
																									'Fees'				=> 'Fee__c',
																									'Labor Codes'		=> 'Labour_Code__c',
																									'Sublets' 			=> 'Product__c',
																									'Users'				=> 'User',
																									'Customer Orders'	=> 'CO_Header__c',
																									'Customer Invoices'	=> 'CO_Invoice_Header__c',
                                                                                                    'Customer Payments' => 'CO_Invoice_Payment__c',
																									'Vendor Orders'		=> 'Vendor_Order_Header__c',
																									'Vendor Receivings'	=> 'Vendor_Receiving_Header__c',
																									'Vendor Invoices' 	=> 'Vendor_Invoicing_Header__c',
																									'Item Categories'	=> 'Category__c',
																									'Price Levels'		=> 'Price_Level__c',
																									'Sales Taxes'		=> 'Sales_Tax__c'
																								};
																								
	// A map to define group/display object name to object API name
	public static Map<String, Integer> displayObjectNameToTypeNumber = new Map<String, Integer>{'Customers'		 	=> 1,
																								'Vendors'		 	=> 2,
																								'Parts'				=> 3,
																								'Kits'				=> 4,
																								'Fees'				=> 5,
																								'Labor Codes'		=> 6,
																								'Users'				=> 7,
																								'Customer Orders'	=> 8,
																								'Customer Invoices'	=> 9,
																								'Vendor Orders'		=> 10,
																								'Vendor Receivings'	=> 11,
																								'Vendor Invoices' 	=> 12,
																								'Item Categories'	=> 13,
																								'Price Levels'		=> 14,
																								'Sales Taxes'		=> 15,
																								'Sublets' 			=> 16,
                                                                                                'Customer Payments' => 17
																							};
                                                                                            
	public static Map<String, Integer> filterGroupToOrderMap = new Map<String, Integer>{'Customer Sales'	=> 1,
																						'Vendor Orders'		=> 2,
																						'Product'			=> 3,
																						'People'			=> 4,
																						'Setting'			=> 5,
																						'Settings'			=> 5,
																						'My Customer Orders'		=> 5,
																						'All Customer Orders'		=> 6,
																						'Recent Customer Invoices'	=> 7,
																						'My Vendor Orders'			=> 8,
																						'All Vendor Orders'			=> 9,
																						'Active Receivings'			=> 10,
																						'Recent Vendor Invoices'	=> 11,
																						'Recent Parts'				=> 12,
																						'Kits'						=> 13,
																						'Sublets'					=> 14,
																						'Labor'						=> 15,
																						'Labour'					=> 15,
																						'Fees'						=> 16,
																						'Customers'					=> 17,
																						'Customer'					=> 17,
																						'Vendors'					=> 18,
																						'Vendor'					=> 18,
																						'Category'					=> 19,
																						'Price Level'				=> 20,
																						'Sales Tax'					=> 21
																					};
	
	// Map to define label to UI map Key
	public static Map<String, Map<String, String>> objectNameToLabelToJSONKeyMap = new Map<String, Map<String, String>> {
			'Customers' => new Map<String, String>{	'Id' => 'People_Id',
												 	'Name' => 'People_Name',
													'Phone' => 'People_Phone',
													'Email' => 'People_Email',
												 	'Address' => 'People_BillingAddress',
												 	'City' => 'People_BillingCity',
												 	'State' => 'People_StateProv',
												 	'Country' => 'People_Country',
												 	'Sales Tax' => 'People_SalesTax',
												 	'Price Level' => 'People_PriceLevel'
							
							},
			'Vendors' =>  new Map<String, String> {	'Id' => 'People_Id',
												 	'Name' => 'People_Name',
												 	'Phone' => 'People_Phone',
												 	'Email' => 'People_Email',
												 	'Address' => 'People_BillingAddress',
												 	'City' => 'People_BillingCity',
												  	'State' => 'People_StateProv',
												 	'Country' => 'People_Country',
													'Sales Tax' => 'People_SalesTax',
												 	'Price Level' => 'People_PriceLevel',
												 	'Purchase Sales Tax' => 'Vendor_PurchaseSalesTax'
							
							},	
			'People' => new Map<String, String> {	'Id' => 'People_Id',
													'Name' => 'People_Name',
													'Phone' => 'People_Phone',
													'Email' => 'People_Email',
													'Address' => 'People_BillingAddress',
													'City' => 'People_BillingCity',
													'State' => 'People_StateProv',
													'Country' => 'People_Country',
													'Sales Tax' => 'People_SalesTax',
													'Price Level' => 'People_PriceLevel'
								
								},
											
			'Products' => new Map<String, String> {	'Item' 				=> 'Product_Item',
													'Description' 		=> 'Product_Description',
													'Category' 			=> 'Product_Category' ,
													'Price' 			=> 'Product_Price',
													'Qty Available' 	=> 'Product_QtyAvailable'
												},		
																		
			'Kits' => new Map<String, String> {		'Item' 				=> 'Product_Item',
													'Description' 		=> 'Product_Description',
													'Category' 			=> 'Product_Category',
													'Price' 			=> 'Product_Price',
													'Qty Available' 	=> 'Product_QtyAvailable',
													'Kit Price' 		=> 'Kit_KitPrice',
													'Fixed Price' 		=> 'Kit_FixedPrice' ,
													'Service Kit' 		=>'Kit_ServiceKit' 
												},	
												
			'Fees' => new Map<String, String> {		'Item' 				=> 'Product_Item',
													'Description' 		=> 'Product_Description',
													'Category' 			=> 'Product_Category' ,
													'Price' 			=> 'Product_Price',
													'Qty Available' 	=> 'Product_QtyAvailable',
													'Fee Type' 			=> 'Fee_FeeType'
												},	
												
			'Labor_Codes' => new Map<String, String> {	'Item' 			=> 'Product_Item',
														'Description' 	=> 'Product_Description',
														'Category' 		=> 'Product_Category' ,
														'Price' 		=> 'Product_Price',
														'Qty Available' => 'Product_QtyAvailable'
												},
			'Product__c' => new Map<String, String> {	'Category'	=>	'Category__r.Name',
 														'Code'		=> 'Code__c',
	 													'Cost'		=> 'Cost__c',
	 													'Description'=> 'Description__c',
	 													'Modified'	=>	'LastModifiedDate',
 														'Price'		=>	'Price__c',
 														'Status'	=>	'Status__c',
	 													'Vendor Code'=>	'Vendor_Code__c'
												},								
												
			'Parts' => new Map<String, String> {		'Item' 			=> 'Product_Item',
														'Description'	=> 'Product_Description',
														'Category' 		=> 'Product_Category' ,
														'Price' 		=> 'Product_Price',
														'Qty Available' => 'Product_QtyAvailable',
														'Vendor' 		=> 'Part_Vendor',
														'Cost' 			=> 'Part_Cost',
														'Avg Cost' 		=> 'Part_AverageCost',
														'Location' 		=> 'Part_Location', 
														'In Stock' 		=> 'Part_InStock',
														'Committed' 	=> 'Part_Committed',
														'On Order' 		=> 'Part_OnOrder',
														'Packaged Part'	=> 'Part_PackagedPart',
														'LastCounted' 	=> 'Part_LastCounted',
														'Last Sold' 	=> 'Part_LastSold',
														'Last Stocked' 	=> 'Part_LastStocked',
														'Reorder At' 	=> 'Part_ReorderAt', 
														'Reorder To' 	=> 'Part_ReorderTo',
														'Status'		=>  'Part_Status'
			                               },
			                               
			                               
			'Customer_Sales' => new Map<String, String> {	'Id' 			=> 'Customer_Sales_Id',
															'Customer' 		=> 'Customer_Sales_Customer',
															'Total' 		=> 'Customer_Sales_Total',
															'Balance Due' 	=> 'Customer_Sales_Balance_Due'
											},
											
			'Customer_Orders' => new Map<String, String> {	'Id' 			=> 'Customer_Sales_Id',
															'Customer' 		=> 'Customer_Sales_Customer',
															'Total' 		=> 'Customer_Sales_Total',
															'Balance Due' 	=> 'Customer_Sales_Balance_Due',
															'Deposits' 		=> 'Customer_Order_Deposits',
															'Payments'		=> 'Customer_Order_Payments',
															'Status' 		=> 'Customer_Order_Status'
												},
												
			'Customer_Invoices' => new Map<String, String> {'Id' 			=> 'Customer_Sales_Id',
															'Customer' 		=> 'Customer_Sales_Customer',
															'Total' 		=> 'Customer_Sales_Total',
															'Balance Due' 	=> 'Customer_Sales_Balance_Due',
															'Deposits' 		=> 'Customer_Order_Deposits',
															'Payments' 		=> 'Customer_Order_Payments',
															'Customer Order'=> 'CO_Invoice_Header_Customer_Order',
															'Status' 		=> 'CO_Invoice_Header_Status'
													},
													
            'Customer_Payments' => new Map<String, String> {'Id'            => 'Customer_Sales_Id',
                                                            'Customer'      => 'Customer_Sales_Customer',
                                                            'Total'         => 'Customer_Sales_Total',
                                                            'Customer Order'=> 'CO_Payment_Customer_Order',
                                                            'Payment Method'=> 'CO_Payment_Payment_Method'
                                                    },
            
                                                    
			'Vendor_Ordering' => new Map<String, String>{	'Id' 			=> 'Vendor_Ordering_Id',
															'Vendor' 		=> 'Vendor_Ordering_Vendor',
															'Total' 		=> 'Vendor_Ordering_Total'
													},
													
			'Vendor_Orders' => new Map<String, String>{		'Id' 			=> 'Vendor_Ordering_Id',
															'Vendor' 		=> 'Vendor_Ordering_Vendor',
															'Total' 		=> 'Vendor_Ordering_Total',
															'Purchase Order'=> 'Vendor_Order_Purchase_Order',
															'Total Recieved'=> 'Vendor_Order_Total_Recieved' ,
															'Status' 		=> 'Vendor_Order_Status'
													},
													
			'Vendor_Receivings' => new Map<String, String>{	'Id' 			=> 'Vendor_Ordering_Id',
															'Vendor' 		=> 'Vendor_Ordering_Vendor',
															'Total' 		=> 'Vendor_Ordering_Total',
															'Status' 		=> 'Vendor_Invoicing_Header_Status'
													},
													
			'Vendor_Invoices' => new Map<String, String>{	'Id' 			=> 'Vendor_Ordering_Id',
														  	'Vendor' 		=> 'Vendor_Ordering_Vendor',
														  	'Total' 		=> 'Vendor_Ordering_Total',
													 	    'Status' 		=> 'Vendor_Invoicing_Header_Status'
													},						
			
			'Category__c' => new Map<String, String>{		'Id' 			=> 'Category_Id',
													 	    'Status' 		=> 'Category_Status'
													},
													
			'Price_Level__c' => new Map<String, String>{		'Id' 		=> 'Price_Level_Id',
													 	    'Status' 		=> 'Price_Level_Status'
													},
													
			'Sales_Tax__c' => new Map<String, String>{		'Id' 			=> 'Sales_Tax_Id',
													 	    'Status' 		=> 'Sales_Tax_Status'
													}
	};
	
	
	// Map of object name to owner field API Name
	public static Map<String, List<String>> objectToCommonNumericFieldAPIName = 
						new Map<String, List<String>>{'Parts'				=>	new List<String>{'Retail_Price__c', 'Last_Cost__c'},
														'Kits'				=>	new List<String>{'Fixed_Price__c'},
														'Labor Codes'		=>	new List<String>{'Rate__c'},
														'Fees'				=>	new List<String>{'Price__c'},
														'Sublets'			=> 	new List<String>{'Price__c'},
														'Sales Taxes' 		=>  new List<String>(),
														'Price Levels'		=>  new List<String>(),
														'Item Categories'	=>	new List<String>(),
														'Customers'			=> 	new List<String>(),
														'Vendors'			=> 	new List<String>(),
														'Customer Orders'	=> 	new List<String>{'Total_Order_Value__c', 'Total_Balance_Due__c', 'Total_Payment__c', 'Total_Deposit__c'},
														'Customer Invoices'	=> 	new List<String>{'Total_Payment__c', 'CO_Header__r.Total_Balance_Due__c'},
                                                        'Customer Payments' =>  new List<String>(),
														'Vendor Orders'		=> 	new List<String>{'Total__c'},
														'Vendor Receivings'	=> 	new List<String>{'Receiving_Total__c'},
														'Vendor Invoices' 	=> 	new List<String>(),
														'People'			=> 	new List<String>()
													};
    
    // Map of object name to owner field API Name
	public static Map<String, List<String>> objectToCommonNumericFieldLabelName = 
						new Map<String, List<String>>{'Parts'				=>	new List<String>{'Price', 'Cost'},
														'Kits'				=>	new List<String>{'Price'},
														'Labor Codes'		=>	new List<String>{'Price'},
														'Fees'				=>	new List<String>{'Price'},
														'Sublets'			=>	new List<String>{'Price'},
														'Sales Taxes' 		=>  new List<String>(),
														'Price Levels'		=>  new List<String>(),
														'Item Categories'	=> 	new List<String>(),
														'Customers'			=> 	new List<String>(),
														'Vendors'			=> 	new List<String>(),
														'Customer Orders'	=> 	new List<String>{'Total', 'Balance_Due', 'Payments', 'Deposit'},
														'Customer Invoices'	=> 	new List<String>{'Total', 'Balance_Due'},
                                                        'Customer Payments' =>  new List<String>(),
														'Vendor Orders'		=> 	new List<String>{'Total'},
														'Vendor Receivings'	=> 	new List<String>{'Total'},
														'Vendor Invoices' 	=> 	new List<String>(),
														'People'			=> 	new List<String>()
													};
													
	// Map of object name to owner field API Name
	public static Map<String, List<String>> objectToCommonNumericFieldTypeMap = 
						new Map<String, List<String>>{	'Parts'				=>	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2, HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Kits'				=>	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Labor Codes'		=>	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Fees'				=>	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Sublets'			=>	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Sales Taxes' 		=>  new List<String>(),
														'Price Levels'		=>  new List<String>(),
														'Item Categories'	=> 	new List<String>(),
														'Customers'			=> 	new List<String>(),
														'Vendors'			=> 	new List<String>(),
														'Customer Orders'	=> 	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2, HomeSearchReportUtil.NUMERIC_TYPE_2, HomeSearchReportUtil.NUMERIC_TYPE_2, HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Customer Invoices'	=> 	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2, HomeSearchReportUtil.NUMERIC_TYPE_2},
                                                        'Customer Payments' =>  new List<String>(),
														'Vendor Orders'		=> 	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Vendor Receivings'	=> 	new List<String>{HomeSearchReportUtil.NUMERIC_TYPE_2},
														'Vendor Invoices' 	=> 	new List<String>()
													};												
}