/**
 * Author: Ashish Garg
 * Since: Sept. 11, 2014
 * Name: Constants
 * Description: utility class which holds constant values thoroughout the system
**/
public with sharing class Constants {
    
    // SFDC tab name parameter name:
    private static final String SFDC_TAB_NAME = 'sfdc.tabName';
    
    // Variables related to page parameters:
    public static String pageParameterName = 'pageName';
    public static String settingsPageParameterName = 'SystemSettings';
    public static String customerMgmtPageParameterName = 'CustomerMgmt';
    public static String partsMgmtPageParameterName = 'PartsMgmt';
    public static String categoryMgmtPageParameterName = 'CategoryMgmt';
    public static String vendorMgmtPageParameterName = 'VendorMgmt';
    public static String makeMgmtPageParameterName = 'MakeMgmt';
    public static Integer searchPageGridSize = 50;
    public static String Internal ='Internal';
    
    public static final String CHECKOUT_TYPE_CUSTOMER = 'Customer';
    public static final String CHECKOUT_TYPE_INTERNAL = 'Internal';
    public static final String CHECKOUT_TYPE_THIRD_PARTY = 'Third-Party';
    
    public static final String WORK_SERVICE_ORDER_INVOICE_ITEM_TYPE = 'Work';
    public static final String CLAIM_SERVICE_ORDER_INVOICE_ITEM_TYPE = 'Claim';
    public static final String KIT_INVOICE_ITEM_TYPE = 'Kit';
    public static final String PART_INVOICE_ITEM_TYPE = 'Part';
    public static final String FEE_INVOICE_ITEM_TYPE = 'Fee';
    
    public static final String OBJIECT_NOT_ACCESSIBLE = 'Object is not accessible for user.';
    public static final String OBJIECT_NOT_CREATEABLE = 'Object is not createable for user.';
    public static final String OBJIECT_NOT_UPDATEABLE = 'Object is not updateable for user.';
    public static final String OBJIECT_NOT_DELETABLE = 'Object is not deletable for user.';
    public static final String EMAIL_SEND_NOT_PERMIT = 'Sending email is not permitted for user.';
    
    // Object translations as defined in cutom labels
    public static String customerObjectLabel = Label.Customer_Object_Display_Label;
    public static String vendorObjectLabel = Label.Vendor_Object_Display_Label;
    
    public static boolean IS_RECENT_VENDOR_TO_BE_CREATED = false;
    public static boolean IS_RECENT_CUSTOMER_TO_BE_CREATED = false;

    // Set of all allowed page parameters
    public static final Set<String> ALLOWED_PAGE_PARAMS = new Set<String>{  SFDC_TAB_NAME.toLowerCase(),
                                                                            pageParameterName.toLowerCase()
                                                                        };
    
    
    public static String NAMESPACE = (GeneralConfiguration.getNamespace() == null) ? '' : GeneralConfiguration.getNamespace();
    
    /****************************************************/
    /*                  Sales Tax Item                  */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String SALES_TAX_ITEM_NAME_PREFIX = 'STI_';
    
    
    // Map of Sales Tax field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> SALES_TAX_ITEM_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => SALES_TAX_ITEM_NAME_PREFIX + 'Id',
                                                                                                      'Name__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Name',
                                                                                                      'Active__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Active',
                                                                                                      'Rate__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Rate',
                                                                                                      'Forms_Label__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Forms_Label',
                                                                                                      'Tax_Parts__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Parts',
                                                                                                      'Tax_Labour__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Labour',
                                                                                                      'Tax_Units__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Units',
                                                                                                      'Tax_Misc__c' => SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Misc',
                                                                                                      'Category__r.Name' => SALES_TAX_ITEM_NAME_PREFIX + 'Category',
                                                                                                      'Category__c' => SALES_TAX_ITEM_NAME_PREFIX + 'CategoryId'
                                                                                                      };
    
    // Map of Sales Tax JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> SALES_TAX_ITEM_JSON_TO_FIELDS_MAPPING = new Map<String, String>{SALES_TAX_ITEM_NAME_PREFIX + 'Id' => 'Id',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Name' => 'Name__c' ,
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Rate' => 'Rate__c',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Forms_Label' => 'Forms_Label__c',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Parts' => 'Tax_Parts__c',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Labour' => 'Tax_Labour__c' ,
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Units' => 'Tax_Units__c',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Tax_Misc' => 'Tax_Misc__c',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'Category' => 'Category__r.Name',
                                                                                                      SALES_TAX_ITEM_NAME_PREFIX + 'CategoryId' => 'Category__c'
                                                                                                      };
                                                            
    
    // Map of Sales Tax Item field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> SALES_TAX_ITEM_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                           'Name__c' => 'String' ,
                                                                                                           'Active__c' => 'Boolean',
                                                                                                           'Rate__c' => 'Number',
                                                                                                           'Forms_Label__c' => 'String',
                                                                                                           'Tax_Parts__c' => 'Boolean' ,
                                                                                                           'Tax_Labour__c' => 'Boolean',
                                                                                                           'Tax_Units__c' => 'Boolean',
                                                                                                           'Tax_Misc__c' => 'Boolean',
                                                                                                           'Category__r.Name' => 'Reference',
                                                                                                           'Category__c' => 'String'
                                                                                                           };
                                                            
                                                                                                                    
                                                                                          
    /****************************************************/
    /*                  Sales Tax                       */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String SALES_TAX_NAME_PREFIX = 'ST_';
    
    
    // Map of Sales Tax field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> SALES_TAX_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => SALES_TAX_NAME_PREFIX + 'Id',
                                                                                                'Name__c' => SALES_TAX_NAME_PREFIX + 'Name',
                                                                                                'Active__c' => SALES_TAX_NAME_PREFIX + 'Active',
                                                                                                'Rate__c' => SALES_TAX_NAME_PREFIX + 'Rate',
                                                                                                'Default__c' => SALES_TAX_NAME_PREFIX + 'Default',
                                                                                                'Forms_List_Taxes__c' => SALES_TAX_NAME_PREFIX + 'Forms_List_Taxes',
                                                                                                'Forms_Label__c' => SALES_TAX_NAME_PREFIX + 'Forms_Label'};
    
    // Map of Sales Tax JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> SALES_TAX_JSON_TO_FIELDS_MAPPING = new Map<String, String>{SALES_TAX_NAME_PREFIX + 'Id' => 'Id',
                                                                                                 SALES_TAX_NAME_PREFIX + 'Name' => 'Name__c' ,
                                                                                                 SALES_TAX_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                 SALES_TAX_NAME_PREFIX + 'Rate' => 'Rate__c',
                                                                                                 SALES_TAX_NAME_PREFIX + 'Default' => 'Default__c',
                                                                                                 SALES_TAX_NAME_PREFIX + 'Forms_List_Taxes' => 'Forms_List_Taxes__c',
                                                                                                 SALES_TAX_NAME_PREFIX + 'Forms_Label' => 'Forms_Label__c'};
                                                                                                 
                                                                                                 
    // Map of Sales Tax field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> SALES_TAX_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                      'Name__c' => 'String' ,
                                                                                                      'Active__c' => 'Boolean',
                                                                                                      'Rate__c' => 'Number',
                                                                                                      'Default__c' => 'Boolean',
                                                                                                      'Forms_List_Taxes__c' => 'Boolean',
                                                                                                      'Forms_Label__c' => 'String'};
                                                                                                      
    /****************************************************/
    /*              Recently Viewes Item                */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String RECENT_ITEM_NAME_PREFIX = 'RI_';
    
    
    // Map of Sales Tax field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> RECENT_ITEM_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => RECENT_ITEM_NAME_PREFIX + 'Id',
                                                                                                 'Name' => RECENT_ITEM_NAME_PREFIX + 'Name'};
                                                                                                 
                                                                                                 
    // Map of Sales Tax JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> RECENT_ITEM_JSON_TO_FIELDS_MAPPING = new Map<String, String>{RECENT_ITEM_NAME_PREFIX + 'Id' => 'Id',
                                                                                                 RECENT_ITEM_NAME_PREFIX + 'Name' => 'Name' };
                                                                                                 
                                                                                                 
    // Map of Sales Tax field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> RECENT_ITEM_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                      'Name' => 'String' };

    /****************************************************/
    /*                  Price Level                     */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String PRICE_LEVEL_NAME_PREFIX = 'PL_';
    
    
    // Map of Price Level field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> PRICE_LEVEL_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => PRICE_LEVEL_NAME_PREFIX + 'Id',
                                                                                                'Name__c' => PRICE_LEVEL_NAME_PREFIX + 'Name',
                                                                                                'Description__c' => PRICE_LEVEL_NAME_PREFIX + 'Description',
                                                                                                'Part_Price_Base__c' => PRICE_LEVEL_NAME_PREFIX + 'Part_Price_Base',
                                                                                                'Discount_Markup__c' => PRICE_LEVEL_NAME_PREFIX + 'Discount_Markup',
                                                                                                'Labour_Rate__c' => PRICE_LEVEL_NAME_PREFIX + 'Labour_Rate',
                                                                                                'Active__c' => PRICE_LEVEL_NAME_PREFIX + 'Active',
                                                                                                'Default__c' => PRICE_LEVEL_NAME_PREFIX + 'Default' };
    
    // Map of Price Level JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> PRICE_LEVEL_JSON_TO_FIELDS_MAPPING = new Map<String, String>{PRICE_LEVEL_NAME_PREFIX + 'Id' => 'Id',
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Name' => 'Name__c' ,
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Description' => 'Description__c',
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Part_Price_Base' => 'Part_Price_Base__c',
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Discount_Markup' => 'Discount_Markup__c',
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Labour_Rate' => 'Labour_Rate__c',
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                 PRICE_LEVEL_NAME_PREFIX + 'Default' => 'Default__c'  };
                                                                                                 
                                                                                                 
    // Map of Price Level field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> PRICE_LEVEL_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                      'Name__c' => 'String' ,
                                                                                                      'Description__c' => 'String',
                                                                                                      'Part_Price_Base__c' => 'String',
                                                                                                      'Discount_Markup__c' => 'Number',
                                                                                                      'Labour_Rate__c' => 'Number',
                                                                                                      'Active__c' => 'Boolean',
                                                                                                      'Default__c' => 'Boolean'  };
                                                                                                      
    
    /****************************************************/
    /*                  Country                         */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String COUNTRY_NAME_PREFIX = 'C_';
    

    // Map of Country field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> COUNTRY_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => COUNTRY_NAME_PREFIX + 'Id',
                                                                                              'Name__c' => COUNTRY_NAME_PREFIX + 'Name',
                                                                                              'Visible__c' => COUNTRY_NAME_PREFIX + 'Visible',
                                                                                              'Default__c' => COUNTRY_NAME_PREFIX + 'Default' };
    
    // Map of Country JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> COUNTRY_JSON_TO_FIELDS_MAPPING = new Map<String, String>{COUNTRY_NAME_PREFIX + 'Id' => 'Id',
                                                                                               COUNTRY_NAME_PREFIX + 'Name' => 'Name__c' ,
                                                                                               COUNTRY_NAME_PREFIX + 'Visible' => 'Visible__c',
                                                                                               COUNTRY_NAME_PREFIX + 'Default' => 'Default__c' };
                                                                                                 
                                                                                                 
    // Map of Country field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> COUNTRY_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Name__c' => 'String' ,
                                                                                                    'Visible__c' => 'Boolean',
                                                                                                    'Default__c' => 'Boolean'  };       



    /****************************************************/
    /*                  State                           */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String STATE_NAME_PREFIX = 'S_';
    
    
    // Map of Country field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> STATE_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => STATE_NAME_PREFIX + 'Id',
                                                                                              'Name__c' => STATE_NAME_PREFIX + 'Name',
                                                                                              'Country__c' => STATE_NAME_PREFIX + 'Country',
                                                                                              'Default__c' => STATE_NAME_PREFIX + 'Default' };
    
    // Map of Country JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> STATE_JSON_TO_FIELDS_MAPPING = new Map<String, String>{STATE_NAME_PREFIX + 'Id' => 'Id',
                                                                                               STATE_NAME_PREFIX + 'Name' => 'Name__c' ,
                                                                                               STATE_NAME_PREFIX + 'Country' => 'Country__c',
                                                                                               STATE_NAME_PREFIX + 'Default' => 'Default__c' };
                                                                                                 
                                                                                                 
    // Map of Country field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> STATE_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Name__c' => 'String' ,
                                                                                                    'Country__c' => 'String',
                                                                                                    'Default__c' => 'Boolean'  };       
                                                                                                    
                                            
                                            
                                                                                                    
    /****************************************************/
    /*                  Account                         */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String CUSTOMER_NAME_PREFIX = 'Cust_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> CUSTOMER_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => CUSTOMER_NAME_PREFIX + 'Id',
                                                                                                  'Name' => CUSTOMER_NAME_PREFIX + 'Name',
                                                                                                  'BillingStreet' => CUSTOMER_NAME_PREFIX + 'BillingStreet',
                                                                                                  'BillingCity' => CUSTOMER_NAME_PREFIX + 'BillingCity',
                                                                                                  'BillingState' => CUSTOMER_NAME_PREFIX + 'BillingState',
                                                                                                  'BillingCountry' => CUSTOMER_NAME_PREFIX + 'BillingCountry',
                                                                                                  'BillingPostalCode' => CUSTOMER_NAME_PREFIX + 'BillingPostalCode',
                                                                                                  'Home_Number__c' => CUSTOMER_NAME_PREFIX + 'HomeNumber',
                                                                                                  'Work_Number__c' => CUSTOMER_NAME_PREFIX + 'WorkNumber',
                                                                                                  'Email__c' => CUSTOMER_NAME_PREFIX + 'HomeEmail',
                                                                                                  'Work_Email__c' => CUSTOMER_NAME_PREFIX + 'WorkEmail',
                                                                                                  'Other_Email__c' => CUSTOMER_NAME_PREFIX + 'OtherEmail',
                                                                                                  'Preferred_Email__c' => CUSTOMER_NAME_PREFIX + 'PreferredEmail',
                                                                                                  'Mobile__c' => CUSTOMER_NAME_PREFIX + 'Mobile',
                                                                                                  'Mobile__c' => CUSTOMER_NAME_PREFIX + 'OtherNumber',
                                                                                                  'Preferred_Phone__c' => CUSTOMER_NAME_PREFIX + 'PreferredPhone',
                                                                                                  'Facebook__c' => CUSTOMER_NAME_PREFIX + 'Facebook',
                                                                                                  'Twitter__c' => CUSTOMER_NAME_PREFIX + 'Twitter',
                                                                                                  'LinkedIn__c' => CUSTOMER_NAME_PREFIX + 'LinkedIn',
                                                                                                  'Active__c' => CUSTOMER_NAME_PREFIX + 'Active',
                                                                                                  'Type__c' => CUSTOMER_NAME_PREFIX + 'Type',
                                                                                                  'FirstName__c' => CUSTOMER_NAME_PREFIX + 'FirstName',
                                                                                                  'LastName__c' => CUSTOMER_NAME_PREFIX + 'LastName',
                                                                                                  'Nickname__c' => CUSTOMER_NAME_PREFIX + 'NickName' 
                                                                                                };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> CUSTOMER_JSON_TO_FIELDS_MAPPING = new Map<String, String>{CUSTOMER_NAME_PREFIX + 'Id' => 'Id',
                                                                                                   CUSTOMER_NAME_PREFIX + 'Name' => 'Name' ,
                                                                                                   CUSTOMER_NAME_PREFIX + 'BillingStreet' => 'BillingStreet',
                                                                                                   CUSTOMER_NAME_PREFIX + 'BillingCity' => 'BillingCity',
                                                                                                   CUSTOMER_NAME_PREFIX + 'BillingState' => 'BillingState',
                                                                                                   CUSTOMER_NAME_PREFIX + 'BillingCountry' => 'BillingCountry',
                                                                                                   CUSTOMER_NAME_PREFIX + 'BillingPostalCode' => 'BillingPostalCode',
                                                                                                   CUSTOMER_NAME_PREFIX + 'HomeNumber' => 'Home_Number__c' ,
                                                                                                   CUSTOMER_NAME_PREFIX + 'HomeEmail' => 'Email__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'WorkNumber' => 'Work_Number__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'WorkEmail' => 'Work_Email__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'OtherEmail' => 'Other_Email__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'Mobile' => 'Mobile__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'OtherNumber' => 'Mobile__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'PreferredEmail' => 'Preferred_Email__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'PreferredPhone' => 'Preferred_Phone__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'Facebook' => 'Facebook__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'Twitter' => 'Twitter__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'LinkedIn' => 'LinkedIn__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'Type' => 'Type__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'FirstName' => 'FirstName__c',
                                                                                                   CUSTOMER_NAME_PREFIX + 'LastName' => 'LastName__c'
                                                                                                 };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Name' => 'String' ,
                                                                                                    'BillingStreet' => 'String',
                                                                                                    'BillingCity' => 'String',
                                                                                                    'BillingState' => 'String',
                                                                                                    'BillingCountry' => 'String',
                                                                                                    'BillingPostalCode' => 'String',
                                                                                                    'Home_Number__c' => 'String',
                                                                                                    'Work_Number__c' => 'String',
                                                                                                    'Email__c' => 'String',
                                                                                                    'Work_Email__c' => 'String',
                                                                                                    'Other_Email__c' => 'String',
                                                                                                    'Mobile__c' => 'String',
                                                                                                    'Preferred_Email__c' => 'String',
                                                                                                    'Preferred_Phone__c' => 'String',
                                                                                                    'Facebook__c' => 'String',
                                                                                                    'Twitter__c' => 'String',
                                                                                                    'LinkedIn__c' => 'String',
                                                                                                    'Active__c' => 'Boolean',
                                                                                                    'Type__c' => 'String',
                                                                                                    'FirstName__c' => 'String',
                                                                                                    'LastName__c' => 'String',
                                                                                                    'Nickname__c' => 'String'
                                                                                                  };                                                                                                                                                                                                                                                                                                 
    
    /****************************************************/
    /*                  Contact                         */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String INDIVIDUAL_CUSTOMER_NAME_PREFIX = 'Indi_Cust_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> INDIVIDUAL_CUSTOMER_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Id',
                                                                                                          'FirstName' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'FirstName',
                                                                                                          'LastName' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'LastName',
                                                                                                          'MailingStreet' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingStreet',
                                                                                                          'MailingCity' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingCity',
                                                                                                          'MailingState' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingState',
                                                                                                          'MailingCountry' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingCountry',
                                                                                                          'MailingPostalCode' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingPostalCode',
                                                                                                          
                                                                                                          'OtherStreet' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherStreet',
                                                                                                          'OtherCity' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherCity',
                                                                                                          'OtherState' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherState',
                                                                                                          'OtherCountry' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherCountry',
                                                                                                          'OtherPostalCode' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherPostalCode',
                                                                                                          'SA_same_as_BA__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'SASameAsBA',
                                                                                                          'Phone' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Phone',
                                                                                                          'MobilePhone' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MobilePhone',
                                                                                                          'Fax' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Fax',
                                                                                                          'Email' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Email',
                                                                                                          'Preferred_Contact__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Preferred_Contact',
                                                                                                          'VIP__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'VIP',
                                                                                                          'Price_Level__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Price_Level_Id',
                                                                                                          'Price_Level__r.Name' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Price_Level',
                                                                                                          'Sales_Tax__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Sales_Tax_Id',
                                                                                                          'Sales_Tax__r.Name' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Sales_Tax',
                                                                                                          'Active__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Active',
                                                                                                          'Is_Vendor__c' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'IsVendor',
                                                                                                          'LastModifiedDate' => INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'LastActive' };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> INDIVIDUAL_CUSTOMER_JSON_TO_FIELDS_MAPPING = new Map<String, String>{INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Id' => 'Id',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'FirstName' => 'FirstName' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'LastName' => 'LastName',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingStreet' => 'MailingStreet',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingCity' => 'MailingCity' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingState' => 'MailingState',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingCountry' => 'MailingCountry',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MailingPostalCode' => 'MailingPostalCode' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherStreet' => 'OtherStreet',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherCity' => 'OtherCity',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherState' => 'OtherState' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherCountry' => 'OtherCountry',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'OtherPostalCode' => 'OtherPostalCode',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'SASameAsBA' => 'SA_same_as_BA__c',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Phone' => 'Phone' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'MobilePhone' => 'MobilePhone' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Fax' => 'Fax',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Email' => 'Email',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Preferred_Contact' => 'Preferred_Contact__c',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'VIP' => 'VIP__c',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Price_Level_Id' => 'Price_Level__c' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Price_Level' => 'Price_Level__r.Name' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Sales_Tax_Id' => 'Sales_Tax__c' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Sales_Tax' => 'Sales_Tax__r.Name' ,
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                           INDIVIDUAL_CUSTOMER_NAME_PREFIX + 'IsVendor' => 'Is_Vendor__c'  };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> INDIVIDUAL_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'FirstName' => 'String' ,
                                                                                                    'LastName' => 'String',
                                                                                                    'MailingStreet' => 'String',
                                                                                                    'MailingCity' => 'String',
                                                                                                    'MailingState' => 'String',
                                                                                                    'MailingCountry' => 'String',
                                                                                                    'MailingPostalCode' => 'String' ,
                                                                                                    'OtherStreet' => 'String',
                                                                                                    'OtherCity' => 'String',
                                                                                                    'OtherState' => 'String',
                                                                                                    'OtherCountry' => 'String',
                                                                                                    'OtherPostalCode' => 'String',
                                                                                                    'Phone' => 'String' ,
                                                                                                    'MobilePhone' => 'String' ,
                                                                                                    'Fax' => 'String',
                                                                                                    'Email' => 'String',
                                                                                                    'Preferred_Contact__c' => 'String',
                                                                                                    'VIP__c' => 'String',
                                                                                                    'Price_Level__c' => 'String',
                                                                                                    'Price_Level__r.Name' => 'Reference',
                                                                                                    'Sales_Tax__c' => 'String' ,
                                                                                                    'Sales_Tax__r.Name' => 'Reference' ,
                                                                                                    'Active__c' => 'Boolean',
                                                                                                    'Is_Vendor__c' => 'Boolean',
                                                                                                    'SA_same_as_BA__c' => 'Boolean' };                                                                                                                                                                                                                                                                                                
    
    /****************************************************/
    /*                  Comapny Customer                */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String COMAPANY_CUSTOMER_NAME_PREFIX = 'Comp_Cust_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> COMAPANY_CUSTOMER_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Id',
                                                                                                          'Name' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Name',
                                                                                                          'BillingStreet' => COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingStreet',
                                                                                                          'BillingCity' => COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingCity',
                                                                                                          'BillingState' => COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingState',
                                                                                                          'BillingCountry' => COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingCountry',
                                                                                                          'BillingPostalCode' => COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingPostalCode',
                                                                                                          
                                                                                                          'ShippingStreet' => COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingStreet',
                                                                                                          'ShippingCity' => COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingCity',
                                                                                                          'ShippingState' => COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingState',
                                                                                                          'ShippingCountry' => COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingCountry',
                                                                                                          'ShippingPostalCode' => COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingPostalCode',
                                                                                                          'SA_same_as_BA__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'SASameAsBA',
                                                                                                          'Phone' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Phone',
                                                                                                          'Mobile__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Mobile',
                                                                                                          'Fax' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Fax',
                                                                                                          'Email__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Email',
                                                                                                          'Preferred_Contact__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Preferred_Contact',
                                                                                                          'VIP__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'VIP',
                                                                                                          'Price_Level__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Price_Level_Id',
                                                                                                          'Price_Level__r.Name' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Price_Level',
                                                                                                          'Sales_Tax__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Sales_Tax_Id',
                                                                                                          'Sales_Tax__r.Name' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Sales_Tax',
                                                                                                          'Active__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'Active',
                                                                                                          'Is_Vendor__c' => COMAPANY_CUSTOMER_NAME_PREFIX + 'IsVendor',
                                                                                                          'LastModifiedDate' => COMAPANY_CUSTOMER_NAME_PREFIX + 'LastActive' };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> COMAPANY_CUSTOMER_JSON_TO_FIELDS_MAPPING = new Map<String, String>{COMAPANY_CUSTOMER_NAME_PREFIX + 'Id' => 'Id',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Name' => 'Name',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingStreet' => 'BillingStreet',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingCity' => 'BillingCity' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingState' => 'BillingState',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingCountry' => 'BillingCountry',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'BillingPostalCode' => 'BillingPostalCode' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingStreet' => 'ShippingStreet',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingCity' => 'ShippingCity',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingState' => 'ShippingState' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingCountry' => 'ShippingCountry',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'ShippingPostalCode' => 'ShippingPostalCode',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'SASameAsBA' => 'SA_same_as_BA__c',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Phone' => 'Phone' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Mobile' => 'Mobile__c' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Fax' => 'Fax',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Email' => 'Email__c',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Preferred_Contact' => 'Preferred_Contact__c',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'VIP' => 'VIP__c',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Price_Level_Id' => 'Price_Level__c' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Price_Level' => 'Price_Level__r.Name' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Sales_Tax_Id' => 'Sales_Tax__c' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Sales_Tax' => 'Sales_Tax__r.Name' ,
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'IsVendor' => 'Is_Vendor__c',
                                                                                                           COMAPANY_CUSTOMER_NAME_PREFIX + 'LastActive' => 'LastModifiedDate'   };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> COMAPANY_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Name' => 'String' ,
                                                                                                    'BillingStreet' => 'String',
                                                                                                    'BillingCity' => 'String',
                                                                                                    'BillingState' => 'String',
                                                                                                    'BillingCountry' => 'String',
                                                                                                    'BillingPostalCode' => 'String' ,
                                                                                                    'ShippingStreet' => 'String',
                                                                                                    'ShippingCity' => 'String',
                                                                                                    'ShippingState' => 'String',
                                                                                                    'ShippingCountry' => 'String',
                                                                                                    'ShippingPostalCode' => 'String',
                                                                                                    'Phone' => 'String' ,
                                                                                                    'Mobile__c' => 'String' ,
                                                                                                    'Fax' => 'String',
                                                                                                    'Email__c' => 'String',
                                                                                                    'Preferred_Contact__c' => 'String',
                                                                                                    'VIP__c' => 'String',
                                                                                                    'Price_Level__c' => 'String',
                                                                                                    'Price_Level__r.Name' => 'Reference',
                                                                                                    'Sales_Tax__c' => 'String' ,
                                                                                                    'Sales_Tax__r.Name' => 'Reference' ,
                                                                                                    'Active__c' => 'Boolean',
                                                                                                    'SA_same_as_BA__c' => 'Boolean',
                                                                                                    'Is_Vendor__c' => 'Boolean' };                                                                                                                                                                                                                                                                                                 
    
    /****************************************************/
    /*                  Part                            */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String PART_NAME_PREFIX = 'Part_';
    
    
    // Map of Part field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> PART_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => PART_NAME_PREFIX + 'Id',
                                                                                            'Part_ID__c' => PART_NAME_PREFIX + 'Part_ID',
                                                                                            'Description__c' => PART_NAME_PREFIX + 'Description',
                                                                                            'Active__c' => PART_NAME_PREFIX + 'Active',
                                                                                            'Qty_On_Order__c' => PART_NAME_PREFIX + 'Qty_On_Order',
                                                                                            'Retail_Price__c' => PART_NAME_PREFIX + 'Retail_Price',
                                                                                            'Location__c' => PART_NAME_PREFIX + 'Location',
                                                                                            'Category__c' => PART_NAME_PREFIX + 'CategoryId',
                                                                                            'Category__r.Name' => PART_NAME_PREFIX + 'Category',
                                                                                            'Qty_In_Stock__c' => PART_NAME_PREFIX + 'Qty_In_Stock',
                                                                                            'Qty_Committed__c' => PART_NAME_PREFIX + 'Qty_Committed',
                                                                                            'AvailableParts__c' => PART_NAME_PREFIX + 'AvailableParts' };
    
    // Map of Part JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> PART_JSON_TO_FIELDS_MAPPING = new Map<String, String>{PART_NAME_PREFIX + 'Id' => 'Id',
                                                                                            PART_NAME_PREFIX + 'Part_ID' => 'Part_ID__c' ,
                                                                                            PART_NAME_PREFIX + 'Description' => 'Description__c',
                                                                                            PART_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                            PART_NAME_PREFIX + 'Qty_On_Order' => 'Qty_On_Order__c' ,
                                                                                            PART_NAME_PREFIX + 'Retail_Price' => 'Retail_Price__c',
                                                                                            PART_NAME_PREFIX + 'Location' => 'Location__c',
                                                                                            PART_NAME_PREFIX + 'Category' => 'Category__r.Name',
                                                                                            PART_NAME_PREFIX + 'CategoryId' => 'Category__c',
                                                                                            PART_NAME_PREFIX + 'Qty_In_Stock' => 'Qty_In_Stock__c',
                                                                                            PART_NAME_PREFIX + 'Qty_Committed' => 'Qty_Committed__c',
                                                                                            PART_NAME_PREFIX + 'AvailableParts' => 'AvailableParts__c'  };

                                                                                                 
                                                                                                 
    // Map of Part field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> PART_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                'Part_ID__c' => 'String' ,
                                                                                                'Description__c' => 'String',
                                                                                                'Active__c' => 'Boolean',
                                                                                                'Qty_On_Order__c' => 'Number',
                                                                                                'Retail_Price__c' => 'Number',
                                                                                                'Location__c' => 'String',
                                                                                                'Category__c' => 'String',
                                                                                                'Category__r.Name' => 'Reference',
                                                                                                'Qty_In_Stock__c' => 'Number',
                                                                                                'Qty_Committed__c' => 'Number',
                                                                                                'AvailableParts__c' => 'Number' };                                                                                                                                                                                                                                                                                                
    
    
    
    // Map of Part All field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> PART_ALL_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => PART_NAME_PREFIX + 'Id',
                                                                                                'Part_ID__c' => PART_NAME_PREFIX + 'Part_ID',
                                                                                                'Description__c' => PART_NAME_PREFIX + 'Description',
                                                                                                'Active__c' => PART_NAME_PREFIX + 'Active',
                                                                                                'Qty_On_Order__c' => PART_NAME_PREFIX + 'Qty_On_Order',
                                                                                                'Retail_Price__c' => PART_NAME_PREFIX + 'Retail_Price',
                                                                                                'Location__c' => PART_NAME_PREFIX + 'Location',
                                                                                                'Category__c' => PART_NAME_PREFIX + 'CategoryId',
                                                                                                'Category__r.Name' => PART_NAME_PREFIX + 'Category',
                                                                                                
                                                                                                'Auto_reorder_Max__c' => PART_NAME_PREFIX + 'Auto_reorder_Max',
                                                                                                'Auto_reorder_Min__c' => PART_NAME_PREFIX + 'Auto_reorder_Min',
                                                                                                'Average_Cost__c' => PART_NAME_PREFIX + 'Average_Cost',
                                                                                                'Enviro_Fee__c' => PART_NAME_PREFIX + 'Enviro_Fee',
                                                                                                'Last_Cost__c' => PART_NAME_PREFIX + 'Last_Cost',
                                                                                                'Last_Counted__c' => PART_NAME_PREFIX + 'Last_Counted',
                                                                                                'Last_Sold__c' => PART_NAME_PREFIX + 'Last_Sold',
                                                                                                'Last_Stocked__c' => PART_NAME_PREFIX + 'Last_Stocked',
                                                                                                
                                                                                                'MSRP__c' => PART_NAME_PREFIX + 'MSRP',
                                                                                                'Notes__c' => PART_NAME_PREFIX + 'Notes',
                                                                                                'Order_Lots__c' => PART_NAME_PREFIX + 'Order_Lots',
                                                                                                'Packaged_Part__c' => PART_NAME_PREFIX + 'Packaged_Part',
                                                                                                'Package_Qty__c' => PART_NAME_PREFIX + 'Package_Qty',
                                                                                                'Part_Number__c' => PART_NAME_PREFIX + 'Part_Number',
                                                                                                'Qty_Committed__c' => PART_NAME_PREFIX + 'Qty_Committed',
                                                                                                
                                                                                                'Qty_In_Stock__c' => PART_NAME_PREFIX + 'Qty_In_Stock',
                                                                                                'Superseded_By__c' => PART_NAME_PREFIX + 'Superseded_By_Id',
                                                                                                'Superseded_By__r.Part_ID__c' => PART_NAME_PREFIX + 'Superseded_By',
                                                                                                'Taxable__c' => PART_NAME_PREFIX + 'Taxable',
                                                                                                'Vendor__c' => PART_NAME_PREFIX + 'Vendor',
                                                                                                'Vendor_Code__c' => PART_NAME_PREFIX + 'Vendor_Code',
                                                                                                'Vendor_Name_And_Code__c' => PART_NAME_PREFIX + 'Vendor_Name_And_Code'    };
    
    // Map of Part JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> PART_ALL_JSON_TO_FIELDS_MAPPING = new Map<String, String>{PART_NAME_PREFIX + 'Id' => 'Id',
                                                                                                PART_NAME_PREFIX + 'Part_ID' => 'Part_ID__c' ,
                                                                                                PART_NAME_PREFIX + 'Description' => 'Description__c',
                                                                                                PART_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                PART_NAME_PREFIX + 'Qty_On_Order' => 'Qty_On_Order__c' ,
                                                                                                PART_NAME_PREFIX + 'Retail_Price' => 'Retail_Price__c',
                                                                                                PART_NAME_PREFIX + 'Location' => 'Location__c',
                                                                                                PART_NAME_PREFIX + 'Category' => 'Category__r.Name',
                                                                                                PART_NAME_PREFIX + 'CategoryId' => 'Category__c',
                                                                                                PART_NAME_PREFIX + 'Auto_reorder_Max' => 'Auto_reorder_Max__c',
                                                                                                PART_NAME_PREFIX + 'Auto_reorder_Min' => 'Auto_reorder_Min__c' ,
                                                                                                PART_NAME_PREFIX + 'Average_Cost' => 'Average_Cost__c',
                                                                                                PART_NAME_PREFIX + 'Enviro_Fee' => 'Enviro_Fee__c',
                                                                                                PART_NAME_PREFIX + 'Last_Cost' => 'Last_Cost__c' ,
                                                                                                PART_NAME_PREFIX + 'Last_Counted' => 'Last_Counted__c',
                                                                                                PART_NAME_PREFIX + 'Last_Sold' => 'Last_Sold__c',
                                                                                                PART_NAME_PREFIX + 'Last_Stocked' => 'Last_Stocked__c',
                                                                                                PART_NAME_PREFIX + 'MSRP' => 'MSRP__c',
                                                                                                
                                                                                                
                                                                                                PART_NAME_PREFIX + 'Notes' => 'Notes__c',
                                                                                                PART_NAME_PREFIX + 'Order_Lots' => 'Order_Lots__c' ,
                                                                                                PART_NAME_PREFIX + 'Packaged_Part' => 'Packaged_Part__c',
                                                                                                PART_NAME_PREFIX + 'Package_Qty' => 'Package_Qty__c',
                                                                                                PART_NAME_PREFIX + 'Qty_Committed' => 'Qty_Committed__c' ,
                                                                                                PART_NAME_PREFIX + 'Part_Number' => 'Part_Number__c',
                                                                                                PART_NAME_PREFIX + 'Qty_In_Stock' => 'Qty_In_Stock__c',
                                                                                                PART_NAME_PREFIX + 'Superseded_By_Id' => 'Superseded_By__c',
                                                                                                PART_NAME_PREFIX + 'Superseded_By' => 'Superseded_By__r.Part_ID__c',

                                                                                                PART_NAME_PREFIX + 'Taxable' => 'Taxable__c',
                                                                                                PART_NAME_PREFIX + 'Vendor' => 'Vendor__c',
                                                                                                PART_NAME_PREFIX + 'Vendor_Code' => 'Vendor_Code__c',
                                                                                                PART_NAME_PREFIX + 'Vendor_Name_And_Code' => 'Vendor_Name_And_Code__c'   };
                                                                                                 
                                                                                                 
    // Map of Part field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> PART_ALL_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Part_ID__c' => 'Formula' ,
                                                                                                    'Description__c' => 'String',
                                                                                                    'Active__c' => 'Boolean',
                                                                                                    'Qty_On_Order__c' => 'Number',
                                                                                                    'Retail_Price__c' => 'Number',
                                                                                                    'Location__c' => 'String',
                                                                                                    'Category__c' => 'String',
                                                                                                    'Category__r.Name' => 'Reference',
                                                                                                    'Auto_reorder_Max__c' => 'Number',
                                                                                                    'Auto_reorder_Min__c' => 'Number' ,
                                                                                                    'Average_Cost__c' => 'Number',
                                                                                                    'Enviro_Fee__c' => 'Number',
                                                                                                    'Last_Cost__c' => 'Number',
                                                                                                    'Last_Counted__c' => 'Date',
                                                                                                    'Last_Sold__c' => 'Date',
                                                                                                    'Last_Stocked__c' => 'Date',
                                                                                                    'MSRP__c' => 'Number',
                                                                                                    'Notes__c' => 'String',
                                                                                                    'Order_Lots__c' => 'Number' ,
                                                                                                    'Packaged_Part__c' => 'Boolean',
                                                                                                    'Package_Qty__c' => 'Number',
                                                                                                    'Part_Number__c' => 'String',
                                                                                                    'Qty_Committed__c' => 'Number',
                                                                                                    'Qty_In_Stock__c' => 'Number',
                                                                                                    'Superseded_By__c' => 'String',
                                                                                                    'Superseded_By__r.Part_ID__c' => 'Reference',
                                                                                                    'Taxable__c' => 'Boolean',
                                                                                                    'Vendor__c' => 'String',
                                                                                                    'Vendor_Code__c' => 'Formula',
                                                                                                    'Vendor_Name_And_Code__c' => 'Formula'
                                                                                                    };  
                                                                                                    
    // Map of Part field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, Decimal> PART_FIELDS_TO_DEFAULT_VALUE_MAPPING = new Map<String, Decimal>{'Retail_Price__c' => 0.00,
                                                                                                        'Auto_reorder_Max__c' => 0,
                                                                                                        'Auto_reorder_Min__c' => 0 ,
                                                                                                        'Enviro_Fee__c' => 0.00,
                                                                                                        'Last_Cost__c' => 0.000,
                                                                                                        'MSRP__c' => 0.000,
                                                                                                        'Order_Lots__c' => 1,
                                                                                                        'Package_Qty__c' => 0,
                                                                                                        'Qty_In_Stock__c' => 0.00    };                                                                                                 
    
    /****************************************************/
    /*                  Auto Complete: Vendor           */
    /****************************************************/

    // Prefix name for object fields used in JSON
    private static String VENDOR_NAME_PREFIX = 'Vendor_';
    
    // boolean variable: If true then display only Active vendor records, if false then display all vendor records
    private static boolean displayOnlyActive = true;
    




    // Where condition need to be included in SOQL statement
    public static String VENDOR_SOQL_FILTER = (displayOnlyActive) ? ('Is_Vendor__c = true AND ' + 'Active__c = ' + displayOnlyActive) : 'Is_Vendor__c = true';
    

    // Order By fields:
    public static String VENDOR_SOQL_ORDER_BY = 'Name ASC';
    
    // Map of Vendor field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> VENDOR_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => 'Value',
                                                                                              'Name' => 'Name',
                                                                                              NAMESPACE + 'Vendor_Code__c' => VENDOR_NAME_PREFIX + 'Code' };
    
    // Map of Vendor field API name to JSON data mapping
    // Key: Field API Name
    // Value: Representative field data used in JSON and webservices
    public static Map<String, String> VENDOR_FIELDS_TO_JSON_DATA_MAPPING = new Map<String, String>{'Id' => NAMESPACE + 'Id',
                                                                                                   'Name' => NAMESPACE + 'Name' + ' (' + NAMESPACE + 'Vendor_Code__c)'
                                                                                                  };
                                                                                                  




    /****************************************************/
    /*                  Auto Complete: Category         */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String CATEGORY_NAME_PREFIX = 'Cat_';
    
    // Where condition need to be included in SOQL statement
    public static String CATEGORY_SOQL_FILTER = null;
    
    // Order By fields:
    public static String CATEGORY_SOQL_ORDER_BY = 'Name ASC';
    
    // Map of CATEGORY field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> CATEGORY_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => 'Value',
                                                                                                'Name' => 'Name'
                                                                                              };
    
    // Map of CATEGORY field API name to JSON data mapping
    // Key: Field API Name
    // Value: Representative field data used in JSON and webservices
    public static Map<String, String> CATEGORY_FIELDS_TO_JSON_DATA_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Name' => 'Name'
                                                                                                  };
                                                                                                  

    /****************************************************/
    /*                  Auto Complete: Part         */
    /****************************************************/
    // Where condition need to be included in SOQL statement
    public static String PART_SOQL_FILTER = null;
    
    // Order By fields:
    public static String PART_SOQL_ORDER_BY = 'Part_Number__c ASC';
    
    // Map of PART field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> PART_FIELDS_TO_AUTOCOMPLETE_JSON_MAPPING = new Map<String, String>{'Id' => 'Value',
                                                                                                'Part_ID__c' => 'Name'
                                                                                              };
    
    // Map of PART field API name to JSON data mapping
    // Key: Field API Name
    // Value: Representative field data used in JSON and webservices
    public static Map<String, String> PART_FIELDS_TO_AUTOCOMPLETE_JSON_DATA_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    NAMESPACE + 'Part_ID__c' => NAMESPACE + 'Part_ID__c'
                                                                                                  };
                                                                                                  



    /********************************************************************************************************************************************************
     *  Maps which is used to decide which map to use while query or JSON processings
     *  Key: Object API name / Object type name in case object has additional types (Like Account: Customer, Vendor, Company)
     *  Value: Instance of related map which should be used for logic operations
     *
     ********************************************************************************************************************************************************/






    // Map which is used to get object API name
    // Mostly used in case to get object API for realted type (Like Vendor => Account)
    public static Map<String, String> OBJ_TYPE_NAME_TO_OBJ_API_NAME_MAP = new Map<String, String>{  'Vendor'    =>  'Account',
                                                                                                    'Category__c'   =>  'Category__c',
                                                                                                    'Part__c'   =>  'Part__c',
                                                                                                    'Price_Level__c'    =>  'Price_Level__c',
                                                                                                    'Sales_Tax__c'  =>  'Sales_Tax__c'
                                                                                                };
    
    // Map to be used to get related object API names and JSON fields mapping map
    public static Map<String, Map<String,String>> OBJ_TO_JSON_FIELDS_MAP = new Map<String, Map<String,String>>{ 'Vendor'    =>  VENDOR_FIELDS_TO_JSON_MAPPING,
                                                                                                                'Category__c'   =>  CATEGORY_FIELDS_TO_JSON_MAPPING,
                                                                                                                'Part__c'   =>  PART_FIELDS_TO_AUTOCOMPLETE_JSON_MAPPING
                                                                                                            };
    
    // Map to be used to get related object JSON Fields to dsiplay data mapping map
    public static Map<String, Map<String,String>> OBJ_TO_JSON_DATA_MAP = new Map<String, Map<String,String>>{   'Vendor'    =>  VENDOR_FIELDS_TO_JSON_DATA_MAPPING,
                                                                                                                'Category__c'   =>  CATEGORY_FIELDS_TO_JSON_DATA_MAPPING,
                                                                                                                'Part__c'   =>  PART_FIELDS_TO_AUTOCOMPLETE_JSON_DATA_MAPPING
                                                                                                            };
    
    // Map to be used to get where condition for object types query
    public static Map<String, String> OBJ_TO_FILTER_CONDITION_MAP = new Map<String, String>{    'Vendor'    =>  VENDOR_SOQL_FILTER,
                                                                                                'Category__c'   =>  CATEGORY_SOQL_FILTER,
                                                                                                'Part__c'   =>  PART_SOQL_FILTER
                                                                                            };
    
    // Map to be used to get ORDER BY condition for object types query
    public static Map<String, String> OBJ_TO_ORDERBY_CLAUSE_MAP = new Map<String, String>{  'Vendor'    =>  VENDOR_SOQL_ORDER_BY,
                                                                                            'Category__c'   =>  CATEGORY_SOQL_ORDER_BY,
                                                                                            'Part__c'   =>  PART_SOQL_ORDER_BY
                                                                                        };





    
    /****************************************************/
    /*                  Category List                   */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String CATEGORY_LIST_NAME_PREFIX = 'Cat_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> CATEGORY_LIST_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => CATEGORY_LIST_NAME_PREFIX + 'Id',
                                                                                                      'Name' => CATEGORY_LIST_NAME_PREFIX + 'Name',
                                                                                                      'Active__c' => CATEGORY_LIST_NAME_PREFIX + 'Active',
                                                                                                      'COGS_GL__c' => CATEGORY_LIST_NAME_PREFIX + 'COGS_GL',
                                                                                                      'Default__c' => CATEGORY_LIST_NAME_PREFIX + 'Default',
                                                                                                      'Description__c' => CATEGORY_LIST_NAME_PREFIX + 'Description',
                                                                                                      'Income_GL__c' => CATEGORY_LIST_NAME_PREFIX + 'Income_GL',
                                                                                                      'Inventory_GL__c' => CATEGORY_LIST_NAME_PREFIX + 'Inventory_GL',
                                                                                                      'Type__c' => CATEGORY_LIST_NAME_PREFIX + 'Type' };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> CATEGORY_LIST_JSON_TO_FIELDS_MAPPING = new Map<String, String>{CATEGORY_LIST_NAME_PREFIX + 'Id' => 'Id',
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Name' => 'Name' ,
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'COGS_GL' => 'COGS_GL__c',
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Default' => 'Default__c' ,
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Description' => 'Description__c',
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Income_GL' => 'Income_GL__c',
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Inventory_GL' => 'Inventory_GL__c',
                                                                                                       CATEGORY_LIST_NAME_PREFIX + 'Type' => 'Type__c'  };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> CATEGORY_LIST_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                        'Name' => 'String' ,
                                                                                                        'Active__c' => 'Boolean',
                                                                                                        'COGS_GL__c' => 'String',
                                                                                                        'Default__c' => 'Boolean',
                                                                                                        'Description__c' => 'String',
                                                                                                        'Income_GL__c' => 'String',
                                                                                                        'Inventory_GL__c' => 'String',
                                                                                                        'Type__c' => 'String'};     
                                                                                                        
                                                                                                        
    /****************************************************/
    /*                  Vendor                          */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String VENDOR_LIST_NAME_PREFIX = 'Vendor_';
    
    
    // Map of Vendor field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> VENDOR_LIST_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => VENDOR_LIST_NAME_PREFIX + 'Id',
                                                                                                  'Name' => VENDOR_LIST_NAME_PREFIX + 'Name',
                                                                                                  'BillingStreet' => VENDOR_LIST_NAME_PREFIX + 'BillingStreet',
                                                                                                  'BillingCity' => VENDOR_LIST_NAME_PREFIX + 'BillingCity',
                                                                                                  'BillingState' => VENDOR_LIST_NAME_PREFIX + 'BillingState',
                                                                                                  'BillingCountry' => VENDOR_LIST_NAME_PREFIX + 'BillingCountry',
                                                                                                  'BillingPostalCode' => VENDOR_LIST_NAME_PREFIX + 'BillingPostalCode',
                                                                                                  'ShippingStreet' => VENDOR_LIST_NAME_PREFIX + 'ShippingStreet',
                                                                                                  'ShippingCity' => VENDOR_LIST_NAME_PREFIX + 'ShippingCity',
                                                                                                  'ShippingState' => VENDOR_LIST_NAME_PREFIX + 'ShippingState',
                                                                                                  'ShippingCountry' => VENDOR_LIST_NAME_PREFIX + 'ShippingCountry',
                                                                                                  'ShippingPostalCode' => VENDOR_LIST_NAME_PREFIX + 'ShippingPostalCode',
                                                                                                  'SA_same_as_BA__c' => VENDOR_LIST_NAME_PREFIX + 'SASameAsBA',
                                                                                                  'Phone' => VENDOR_LIST_NAME_PREFIX + 'Phone',
                                                                                                  'Mobile__c' => VENDOR_LIST_NAME_PREFIX + 'Mobile',
                                                                                                  'Fax' => VENDOR_LIST_NAME_PREFIX + 'Fax',
                                                                                                  'Email__c' => VENDOR_LIST_NAME_PREFIX + 'Email',
                                                                                                  'Preferred_Contact__c' => VENDOR_LIST_NAME_PREFIX + 'Preferred_Contact',
                                                                                                  'VIP__c' => VENDOR_LIST_NAME_PREFIX + 'VIP',
                                                                                                  'Price_Level__c' => VENDOR_LIST_NAME_PREFIX + 'Price_Level_Id',
                                                                                                  'Price_Level__r.Name' => VENDOR_LIST_NAME_PREFIX + 'Price_Level',
                                                                                                  'Sales_Tax__c' => VENDOR_LIST_NAME_PREFIX + 'Sales_Tax_Id',
                                                                                                  'Sales_Tax__r.Name' => VENDOR_LIST_NAME_PREFIX + 'Sales_Tax',
                                                                                                  'Active__c' => VENDOR_LIST_NAME_PREFIX + 'Active',
                                                                                                  'Is_Vendor__c' => VENDOR_LIST_NAME_PREFIX + 'IsVendor',
                                                                                                  'Is_Customer__c' => VENDOR_LIST_NAME_PREFIX + 'IsCustomer',
                                                                                                  'LastModifiedDate' => VENDOR_LIST_NAME_PREFIX + 'LastActive',
                                                                                                  'Vendor_Code__c' => VENDOR_LIST_NAME_PREFIX + 'Vendor_Code',
                                                                                                  'Website' => VENDOR_LIST_NAME_PREFIX + 'Website',
                                                                                                  'Purchase_Tax__c' => VENDOR_LIST_NAME_PREFIX + 'Purchase_Tax' };
    
    // Map of Vendor JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> VENDOR_LIST_JSON_TO_FIELDS_MAPPING = new Map<String, String>{VENDOR_LIST_NAME_PREFIX + 'Id' => 'Id',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Name' => 'Name',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'BillingStreet' => 'BillingStreet',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'BillingCity' => 'BillingCity' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'BillingState' => 'BillingState',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'BillingCountry' => 'BillingCountry',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'BillingPostalCode' => 'BillingPostalCode' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'ShippingStreet' => 'ShippingStreet',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'ShippingCity' => 'ShippingCity',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'ShippingState' => 'ShippingState' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'ShippingCountry' => 'ShippingCountry',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'ShippingPostalCode' => 'ShippingPostalCode',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'SASameAsBA' => 'SA_same_as_BA__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Phone' => 'Phone' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Mobile' => 'Mobile__c' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Fax' => 'Fax',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Email' => 'Email__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Preferred_Contact' => 'Preferred_Contact__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'VIP' => 'VIP__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Price_Level_Id' => 'Price_Level__c' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Price_Level' => 'Price_Level__r.Name' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Sales_Tax_Id' => 'Sales_Tax__c' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Sales_Tax' => 'Sales_Tax__r.Name' ,
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'IsVendor' => 'Is_Vendor__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'IsCustomer' => 'Is_Customer__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'LastActive' => 'LastModifiedDate',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Vendor_Code' => 'Vendor_Code__c',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Website' => 'Website',
                                                                                                   VENDOR_LIST_NAME_PREFIX + 'Purchase_Tax' => 'Purchase_Tax__c'  };
                                                                                             
                                                                                                 
    // Map of Vendor field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> VENDOR_LIST_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                        'Name' => 'String' ,
                                                                                                        'BillingStreet' => 'String',
                                                                                                        'BillingCity' => 'String',
                                                                                                        'BillingState' => 'String',
                                                                                                        'BillingCountry' => 'String',
                                                                                                        'BillingPostalCode' => 'String' ,
                                                                                                        'ShippingStreet' => 'String',
                                                                                                        'ShippingCity' => 'String',
                                                                                                        'ShippingState' => 'String',
                                                                                                        'ShippingCountry' => 'String',
                                                                                                        'ShippingPostalCode' => 'String',
                                                                                                        'Phone' => 'String' ,
                                                                                                        'Mobile__c' => 'String' ,
                                                                                                        'Fax' => 'String',
                                                                                                        'Email__c' => 'String',
                                                                                                        'Preferred_Contact__c' => 'String',
                                                                                                        'VIP__c' => 'String',
                                                                                                        'Price_Level__c' => 'String',
                                                                                                        'Price_Level__r.Name' => 'Reference',
                                                                                                        'Sales_Tax__c' => 'String' ,
                                                                                                        'Sales_Tax__r.Name' => 'Reference' ,
                                                                                                        'Purchase_Tax__c' => 'String',
                                                                                                        'Active__c' => 'Boolean',
                                                                                                        'SA_same_as_BA__c' => 'Boolean',
                                                                                                        'Is_Vendor__c' => 'Boolean',
                                                                                                        'LastModifiedDate' => 'String',
                                                                                                        'Vendor_Code__c' => 'Formula',
                                                                                                        'Website' => 'String',
                                                                                                        'Is_Customer__c' => 'Boolean' };                                                                                                                                                                                                                                                                                                      
    
                                                                                                                                                                                                                                                                                                                                                                                                  
    /****************************************************/
    /*                  Unit Make List                  */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String UNIT_MAKE_LIST_NAME_PREFIX = 'Unit_Make_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> UNIT_MAKE_LIST_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => UNIT_MAKE_LIST_NAME_PREFIX + 'Id',
                                                                                                      'Name' => UNIT_MAKE_LIST_NAME_PREFIX + 'Name',
                                                                                                      'Active__c' => UNIT_MAKE_LIST_NAME_PREFIX + 'Active',
                                                                                                      'VIN_Code__c' => UNIT_MAKE_LIST_NAME_PREFIX + 'VIN_Code' };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> UNIT_MAKE_LIST_JSON_TO_FIELDS_MAPPING = new Map<String, String>{UNIT_MAKE_LIST_NAME_PREFIX + 'Id' => 'Id',
                                                                                                       UNIT_MAKE_LIST_NAME_PREFIX + 'Name' => 'Name' ,
                                                                                                       UNIT_MAKE_LIST_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                       UNIT_MAKE_LIST_NAME_PREFIX + 'VIN_Code' => 'VIN_Code__c'  };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> UNIT_MAKE_LIST_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                            'Name' => 'String' ,
                                                                                                            'Active__c' => 'Boolean',
                                                                                                            'VIN_Code__c' => 'String' };        
                                                                                                        
    
    
    /****************************************************/
    /*                  Unit Model List                 */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String UNIT_MODEL_LIST_NAME_PREFIX = 'Unit_Model_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> UNIT_MODEL_LIST_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => UNIT_MODEL_LIST_NAME_PREFIX + 'Id',
                                                                                                      'Name__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'Name',
                                                                                                      'Active__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'Active',
                                                                                                      'VIN_Code__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'VIN_Code',
                                                                                                      'Category__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'Category_Id',
                                                                                                      'Category__r.Name' => UNIT_MODEL_LIST_NAME_PREFIX + 'Category',
                                                                                                      'Model_Description__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'Model_Description',
                                                                                                      'Sub_Model__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'Sub_Model',
                                                                                                      'Unit_Make__c' => UNIT_MODEL_LIST_NAME_PREFIX + 'Unit_Make_Id',
                                                                                                      'Unit_Make__r.Name' => UNIT_MODEL_LIST_NAME_PREFIX + 'Unit_Make'  };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING = new Map<String, String>{UNIT_MODEL_LIST_NAME_PREFIX + 'Id' => 'Id',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Name' => 'Name__c' ,
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Active' => 'Active__c',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'VIN_Code' => 'VIN_Code__c',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Category_Id' => 'Category__c',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Category' => 'Category__r.Name' ,
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Model_Description' => 'Model_Description__c',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Sub_Model' => 'Sub_Model__c',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Unit_Make_Id' => 'Unit_Make__c',
                                                                                                       UNIT_MODEL_LIST_NAME_PREFIX + 'Unit_Make' => 'Unit_Make__r.Name'  };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> UNIT_MODEL_LIST_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                            'Name__c' => 'String' ,
                                                                                                            'Active__c' => 'Boolean',
                                                                                                            'VIN_Code__c' => 'String',
                                                                                                            'Category__c' => 'String',
                                                                                                            'Category__r.Name' => 'Reference' ,
                                                                                                            'Model_Description__c' => 'String',
                                                                                                            'Sub_Model__c' => 'String',
                                                                                                            'Unit_Make__c' => 'String',
                                                                                                            'Unit_Make__r.Name' => 'Reference' };
                                                                                                            
    /****************************************************/
    /*                  User Object                   */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String USER_NAME_PREFIX = 'User_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> USER_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Email' => USER_NAME_PREFIX + 'Email',
                                                                                              'Phone' => USER_NAME_PREFIX + 'Phone',    
                                                                                              'Name' => USER_NAME_PREFIX + 'Name' };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> USER_JSON_TO_FIELDS_MAPPING = new Map<String, String>{USER_NAME_PREFIX + 'Email' => 'Email',
                                                                                               USER_NAME_PREFIX + 'Phone' => 'Phone' ,  
                                                                                               USER_NAME_PREFIX + 'Name' => 'Name'  };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> USER_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Email' => 'String',
                                                                                                    'Phone' => 'String',    
                                                                                                    'Name' => 'String'  };
                                                                                                    
                                                                                                    
                                                                                                                                                                                                            
    
    /****************************************************/
    /*                  Filter Object                   */
    /****************************************************/
    // Prefix name for object fields used in JSON
    private static String FILTER_NAME_PREFIX = 'Filter_';
    
    
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> FILTER_FIELDS_TO_JSON_MAPPING = new Map<String, String>{'Id' => FILTER_NAME_PREFIX + 'Id',
                                                                                              'Custom__c' => FILTER_NAME_PREFIX + 'Custom',
                                                                                              'Filter_JSON__c' => FILTER_NAME_PREFIX + 'Filter_JSON',
                                                                                              'Filter_Label__c' => FILTER_NAME_PREFIX + 'Filter_Label'  };
    
    // Map of Customer JSON representative field name to related field API name
    // Key: JSON representative Field API Name
    // Value: Related field API name
    public static Map<String, String> FILTER_JSON_TO_FIELDS_MAPPING = new Map<String, String>{FILTER_NAME_PREFIX + 'Id' => 'Id',
                                                                                               FILTER_NAME_PREFIX + 'Custom' => 'Custom__c' ,
                                                                                               FILTER_NAME_PREFIX + 'Filter_JSON' => 'Filter_JSON__c',
                                                                                               FILTER_NAME_PREFIX + 'Filter_Label' => 'Filter_Label__c'  };
                                                                                                 
                                                                                                 
    // Map of Customer field API name to their Data types
    // Key: Field API Name
    // Value: Data type of field 
    public static Map<String, String> FILTER_FIELDS_TO_DATA_TYPE_MAPPING = new Map<String, String>{'Id' => 'Id',
                                                                                                    'Custom__c' => 'Boolean' ,
                                                                                                    'Filter_JSON__c' => 'String',
                                                                                                    'Filter_Label__c' => 'String' };
                                                                                                    
                                                                                                    
    
    /****************************************************/
    /*                  Parse JSON Map                  */
    /****************************************************/
    // Map of Customer field API name to related webservice field name
    // Key: Field API Name
    // Value: Representative field name used in JSON and webservices
    public static Map<String, String> FILTER_FIELD_TO_FIELD_API_NAME_MAPPING = new Map<String, String>{'Part' => 'Part__c',
                                                                                                        'Category' => 'Category__c',
                                                                                                        'Status' => 'Active__c',
                                                                                                        'Assignee' => 'OwnerId',
                                                                                                        'Date' => 'LastModifiedDate',
                                                                                                        'Summary' => 'Description__c',
                                                                                                        'Last Week' => 'LAST_WEEK',
                                                                                                        'This Week' => 'THIS_WEEK',
                                                                                                        'This Month' => 'THIS_MONTH',
                                                                                                        'Account' => 'Account',
                                                                                                        'Vendor' => 'Account',
                                                                                                        'Customer' => 'Account',
                                                                                                        'Labour' => 'Labour_Code__c',
                                                                                                        'Kit' => 'Kit_Header__c',
                                                                                                        'Fee' => 'Fee__c'
                                                                                                        };
    
    /****************************************************/
    /*                  Seachable Object Map            */
    /****************************************************/
    // Ordered list for objects to display
    public static List<String> homeSearchObjectsOrderedList = new List<String>{'Customer', 'Vendor', 'Part__c', 'Category__c', 'Labour_Code__c', 'Kit_Header__c', 'Fee__c'};
    public static List<String> objectsOrderedList;
    public static map<String, List<String>> objectToSearchableFieldsMap;
    public static map<String, String> objectToDisplayFieldsMap;
    public static map<String, String> objectToAdditionalInfoDisplayMap;
    public static set<String> autoCompleteSearchableFields;
    static {
        objectToSearchableFieldsMap = new map<String, List<String>>{'Account' => new List<String>{'Name'}};
        objectToDisplayFieldsMap = new map<String, String>{'Account' => 'Name'};
        objectToAdditionalInfoDisplayMap = new map<String, String>();
        autoCompleteSearchableFields = new set<String>();
        objectsOrderedList = new List<String>();
        map<Integer, Set<String>> orderToObjectName = new map<Integer, Set<String>>{1 => new Set<String>{'Account'}};
        
        for(SearchConfigurations__c searchConfig : SearchConfigurations__c.getAll().values()){
            List<String> searchableFields = (objectToSearchableFieldsMap.containsKey(searchConfig.Object_Name__c)) 
                                            ? objectToSearchableFieldsMap.get(searchConfig.Object_Name__c)
                                            : new List<String>();
            
            if( !searchConfig.Searchable_Field__c.contains(',') ){
                searchableFields.add(searchConfig.Searchable_Field__c.trim());
                if( !autoCompleteSearchableFields.contains(searchConfig.Searchable_Field__c.trim()) ){
                    autoCompleteSearchableFields.add(searchConfig.Searchable_Field__c.trim());
                }
            } else {
                for(String searchField : searchConfig.Searchable_Field__c.trim().split(',')){
                    if(searchField != null && searchField.trim().length() != 0){
                        searchableFields.add(searchField);
                        
                        if( !autoCompleteSearchableFields.contains(searchField) ){
                            autoCompleteSearchableFields.add(searchField);
                        }
                    }
                }
            }
            objectToSearchableFieldsMap.put(searchConfig.Object_Name__c, searchableFields);
            objectToDisplayFieldsMap.put(searchConfig.Object_Name__c, searchConfig.Display_Field__c);
            objectToAdditionalInfoDisplayMap.put(searchConfig.Object_Name__c, searchConfig.Display_Info__c);
            
            Integer configOrder = Integer.valueOf(searchConfig.Order__c);
            Set<String> currentOrderObjects = (orderToObjectName.containsKey(configOrder)) ? orderToObjectName.get(configOrder) : new Set<String>();
            currentOrderObjects.add(searchConfig.Object_Name__c);
            orderToObjectName.put(configOrder, currentOrderObjects);
        }
        
        List<Integer> orderList = new List<Integer>(orderToObjectName.keySet());
        orderList.sort();
        for(Integer orderNum : orderList){
            List<String> currentOrderObjects = new List<String>(orderToObjectName.get(orderNum));
            currentOrderObjects.sort();
            objectsOrderedList.addAll(currentOrderObjects);
        }
    }
    
    // Map to hold object API name to object label to display on UI (Custom lables value)
    public static map<String, String> objectNameToObjectDisplayLabel = new map<String, String>{
                                                                            'Contact' => Label.Contact_Object_Display_Label,
                                                                            'Customer' => Label.Customer_Object_Display_Label,
                                                                            'Vendor' => Label.Vendor_Object_Display_Label,
                                                                            NAMESPACE + 'Part__c' => Label.Part_Object_Display_Label,
                                                                            NAMESPACE + 'Category__c' => Label.Category_Object_Display_Label,
                                                                            NAMESPACE + 'Unit_Make__c' => Label.Unit_Make_Object_Display_Label,
                                                                            'User' => Label.User_Object_Display_Label,
                                                                            NAMESPACE + 'Sales_Tax_Item__c' => Label.Sales_Tax_Item_Object_Display_Label,
                                                                            NAMESPACE + 'Labour_Code__c' => Label.Labour_Object_Display_Label,
                                                                            NAMESPACE + 'Kit_Header__c' => Label.Kit_Object_Display_Label,
                                                                            NAMESPACE + 'Fee__c' => Label.Fee_Object_Display_Label
                                                                        };
                                                                        
    // Map to hold object display label (Custom lables value) to object API name
    public static map<String, String> objectDisplayLabelToObjectName = new map<String, String>{
                                                                            Label.Contact_Object_Display_Label => 'Contact',
                                                                            Label.Customer_Object_Display_Label => 'Customer',
                                                                            Label.Vendor_Object_Display_Label => 'Vendor',
                                                                            Label.Part_Object_Display_Label => NAMESPACE + 'Part__c',
                                                                            Label.Category_Object_Display_Label => NAMESPACE + 'Category__c',
                                                                            Label.Unit_Make_Object_Display_Label => NAMESPACE + 'Unit_Make__c',
                                                                            Label.User_Object_Display_Label => 'User',
                                                                            Label.Sales_Tax_Item_Object_Display_Label => NAMESPACE + 'Sales_Tax_Item__c',
                                                                            Label.Labour_Object_Display_Label => NAMESPACE + 'Labour_Code__c',
                                                                            Label.Kit_Object_Display_Label => NAMESPACE + 'Kit_Header__c',
                                                                            Label.Fee_Object_Display_Label => NAMESPACE + 'Fee__c'
                                                                        };
    
    // A Map of Objects to associated fields on which search to be performed
    public static Map<String, Set<String>> searchableObjectToFieldsMap = new Map<String, Set<String>>{
                                                                            'Contact' => new Set<String>{'Id', 'Active__c', 'Name', 'Description', 'Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Customer' => new Set<String>{'Id', 'Is_Customer__c', 'Is_Vendor__c', 'Active__c', 'Name', 'Description', 'Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Account' => new Set<String>{'Id', 'Is_Customer__c', 'Is_Vendor__c', 'Active__c', 'Name', 'Description', 'Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Vendor' => new Set<String>{'Id', 'Is_Customer__c', 'Is_Vendor__c', 'Active__c', 'Name', 'Description', 'Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Part__c' => new Set<String>{'Id', CONSTANTS.NAMESPACE+'Part_ID__c', CONSTANTS.NAMESPACE+'Active__c', CONSTANTS.NAMESPACE+'Description__c', CONSTANTS.NAMESPACE+'Vendor__r.Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'User' => new Set<String>{'Id', 'UserName', 'Name', 'IsActive', 'Title', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Category__c' => new Set<String>{'Id', 'Name', 'Active__c', 'Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Labour_Code__c' => new Set<String>{'Id', 'Name', 'Active__c', 'Name__c', 'Description__c', 'Code__c', 'Owner.Name', 'LastModifiedDate', 'CreatedDate'},
                                                                            'Kit_Header__c' => new Set<String>{'Id', 'Name', 'Active__c', 'Description__c', 'Code__c', 'Owner.Name', 'LastModifiedDate', 'CreatedDate', 'Kit_Unique_Name__c'},
                                                                            'Fee__c' => new Set<String>{'Id', 'Name', 'Active__c', 'Description__c', 'Code__c', 'Owner.Name', 'LastModifiedDate', 'CreatedDate', 'Fee_Unique_Name__c'} };
                                                                            
    public static Map<String, String> objectToMasterOwnerField = new Map<String, String>{
                                                                            'Part__c' => 'Vendor__r.OwnerId'};
                                                                            
                                                                            
     
    // Related To Customer suggestion used in Create Customer Page                                                                        
    public static Map<String, String> customerFieldToFieldAPINameMap = new Map<String, String>{ 'Id' => 'Id',
                                                                                                'Name' => 'Name',
                                                                                                'FirstName' => 'FirstName__c',
                                                                                                'LastName' => 'LastName__c', 
                                                                                                'HomeEmail' => 'Email__c',
                                                                                                'WorkEmail' => 'Work_Email__c',
                                                                                                'OtherEmail' => 'Other_Email__c',
                                                                                                'HomeNumber' => 'Home_Number__c',
                                                                                                'MobileNumber' => 'Mobile__c',
                                                                                                'WorkNumber' => 'Work_Number__c',
                                                                                                'LinkedIn' => 'LinkedIn__c',
                                                                                                'Facebook' => 'Facebook__c',
                                                                                                'Twitter' => 'Twitter__c',
                                                                                                'BillingStreet' => 'BillingStreet',
                                                                                                'IsCustomer' => 'Is_Customer__c',
                                                                                                'IsVendor' => 'Is_Vendor__c'
                                                                                            };
                                                                                        
    
    // Related To Vendor suggestion used in Create Vendor Page                                                                        
    public static Map<String, String> vendorFieldToFieldAPINameMap = new Map<String, String>{  'Id' => 'Id',
                                                                                                'Name' => 'Name',
                                                                                                'WorkEmail' => 'Work_Email__c',
                                                                                                'OtherEmail' => 'Other_Email__c',
                                                                                                'MobileNumber' => 'Mobile__c',
                                                                                                'WorkNumber' => 'Work_Number__c',
                                                                                                'LinkedIn' => 'LinkedIn__c',
                                                                                                'Facebook' => 'Facebook__c',
                                                                                                'Twitter' => 'Twitter__c',
                                                                                                'BillingStreet' => 'BillingStreet',
                                                                                                'IsCustomer' => 'Is_Customer__c',
                                                                                                'IsVendor' => 'Is_Vendor__c'
                                                                                            };
     public static Map<String, Integer> SOStatusToPriorityMap = new Map<String, Integer> {'New' => 1,
                                                                                         'Ready' => 2,
                                                                                         'In Progress' => 3,
                                                                                         'Complete' => 4,
                                                                                         'Reviewed' => 5};
                                                                                         
                                                                                         
     public static Map<String, List<String>> workStatusToAvailableStatusMap = 
                                new Map<String , List<String>> {'New'           =>  new List<String>{'Sign In', 'Force To Ready', 'Force To Checkout'},
                                                                'Ready'         =>  new List<String>{'Start Progress', 'Get Customer Approval', 'Put On Hold'},
                                                                'In Progress'   =>  new List<String>{'Log Service Work', 'Set As Complete', 'Get Customer Approval', 'Put On Hold'},
                                                                'On Hold'       =>  new List<String>{'Start Progress', 'Get Customer Approval', 'Log Service Work'},
                                                                'Complete'      =>  new List<String>{'Review Service', 'Re-Open For Work', 'Force To Reviewed'},
                                                                'Reviewed'      =>  new List<String>{'Service Sign Out', 'Re-Open For Work', 'Force To Sign Out'},
                                                                'Signed Out'    =>  new List<String>{'Go To CheckOut'},
                                                                'Invoiced'      =>  new List<String>{}
                                                            };
     // ClaimStatus Map To Available Status                                                         
    public static Map<String, List<String>> claimStatusToAvailableStatusMap = 
                                new Map<String , List<String>> {'Unsubmitted'       =>  new List<String>{'Force Claim Submission'},
                                                                'Ready to Submit'   =>  new List<String>{'Claim Submission'},
                                                                'Submitted'         =>  new List<String>{'View Submitted Claim', 'Claim Response'},
                                                                'Approved'          =>  new List<String>{'View Claim Response'}
                                                               };
}