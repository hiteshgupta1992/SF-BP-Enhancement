/**
 * Author: 
 * Since: 
 * Name: CustomMetadataTypeUtil
 * Description: Apex Class Custom Metadata Type Util
**/
public with sharing class CustomMetadataTypeUtil {
	/**
	 * Name: getFilterObjectTypes
	 * Description: Method to get the object labels which can be filtered on home search screen filter diaplog box
	 * @Param:	
	 * @Return:	List<String> - Object labels string name list
	**/
	public static List<String> getFilterObjectTypes() {
		List<String> objectLabels = new List<String>();
		List<HomeSearch_Setting__mdt> hsSettingRecords = getGridCustomMetadataTypeSettings(null);
		for(HomeSearch_Setting__mdt hsSetting : hsSettingRecords) {
			if(!hsSetting.Is_Group__c) {
				objectLabels.add(hsSetting.Label);
			}
		}
		return objectLabels;
	}
	
    /**
	 * Name: getGridFilterConfigurations
	 * Description: Method to get the home search grid filter settings based on Obejct name
	 * @Param:	1) Set<String> objectNames - Obejct name selected in home search filter panel
	 * @Return:	String - Serialized string for grid filter settings respective to object name
	**/
	public static String getGridFilterConfigurations(Set<String> objectNames) {
		String objectName = HomeSearchUtil.getGenericObjectNameBySelectedObject(objectNames);
		
		List<HomeSearch_Setting__mdt> hsSettings = getGridCustomMetadataTypeSettings(objectName);
		HomeSearch_Setting__mdt hsSetting = (hsSettings.size() > 0) ? hsSettings[0] : null;
		return System.JSON.serialize(new GridFilterConfigurations(hsSetting, objectName));
	}
	
	/**
	 * Name: getGridColumnsConfiguration
	 * Description: Method to get the home search grid columns configurations based on object name seldcted from UI
	 * @Param:	1) Set<String> objectNames - Obejct name selected in home search filter panel
	 * @Return:	String - Serialized string for grid columns configurations respective to object name
	**/
	public static String getGridColumnsConfiguration(Set<String> objectNames, String filterJSON) {
		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String objectName = HomeSearchUtil.getGenericObjectNameBySelectedObject(objectNames);

		List<HomeSearch_Grid_Column__mdt> hsColumnsSetting = getGridColumnsMetadataTypeSettings(objectName);
		
		Filter__c filterRec = new Filter__c();
		if(!String.isBlank(filterJSON)) {
			Decimal filterHashCode = filterJSON.hashCode();
			List<Filter__c> filterList = [select Name, 
												 favorite__c, 
												 Common__c, 
												 Filter_Label__c, 
												 Custom__c,
												 Display_Hidden_Column__c,
												 Summary_Field_Json__c,
												 Export_Field_Json__c 
												 from Filter__c 
												 where Field_Filter_JSON_Hash_Code__c =: filterHashCode 
												 AND Filter_User__c =: UserInfo.getUserId()
										];
			if(filterList.size() > 0) {
				filterRec = filterList[0];
			}
		}
		
		return System.JSON.serialize(new GridColumnsConfigurations(hsColumnsSetting, filterRec));
	}
	
	/**
	 * Name: getGridCustomMetadataTypeSettings
	 * Description: Method to get the grid custom metadata type setting based on object name
	 * @Param:	1) String objectName - Obejct name selected in home search filter panel
	 * @Return:	List<HomeSearch_Setting__mdt> - Custom Metadata type records
	**/
	private static List<HomeSearch_Setting__mdt> getGridCustomMetadataTypeSettings(String objectName) {
		if(AccessControl.ifObjectFieldIsAccessible('HomeSearch_Setting__mdt') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<String> fieldsList = new List<String>{	'Label', 
													'Status__c', 
													'DeveloperName', 
													'Additional_Fields_1__c',
													'Additional_Fields_2__c',
													'Additional_Fields_3__c',
													'Additional_Fields_4__c',
													'Is_Group__c'
												};
		String query = 'SELECT Id';
		for(String fieldName : fieldsList) {
			query += ', ' + fieldName;
		}
		objectName = BPUtility.escapeSingleQuotes(objectName);
		query += ' FROM HomeSearch_Setting__mdt';
		if(objectName != null) {
			objectName = BPUtility.escapeSingleQuotes(objectName);
			query += ' WHERE Label =: objectName';
		}
		query += ' LIMIT ' + SOQLUtil.getAvailableQueryRowsLimit();
		
		HomeSearch_Setting__mdt hsSetting;
		return Database.query(query);
	}
	
	/**
	 * Name: getGridColumnsMetadataTypeSettings
	 * Description: Method to get the grid custom metadata type column setting reocrds based on object name
	 * @Param:	1) String objectName - Obejct name selected in home search filter panel
	 * @Return:	List<HomeSearch_Grid_Column__mdt> - Custom Metadata type records
	**/
	public static List<HomeSearch_Grid_Column__mdt> getGridColumnsMetadataTypeSettings(String objectName) {
		if(AccessControl.ifObjectFieldIsAccessible('HomeSearch_Grid_Column__mdt') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<HomeSearch_Grid_Column__mdt> hsColumnsSetting = new List<HomeSearch_Grid_Column__mdt>();
		objectName = BPUtility.escapeSingleQuotes(objectName);
		if(objectName != null) {
			hsColumnsSetting = [SELECT	Id,
										Label,
										Type__c, 
										Is_Display__c,
										Order_Number__c,
										Field_API_Name__c,
										Display_Object_Name__c
										FROM HomeSearch_Grid_Column__mdt
										WHERE Display_Object_Name__c =: objectName
										ORDER BY Order_Number__c ASC
								];
		}
		return hsColumnsSetting;
	}
	
    /**
	 * Name: GridFilterConfigurations
	 * Description: Class holds home search grid settings based on Obejct Name selected to look on for records
	**/
	public class GridFilterConfigurations {
		// List of additional fields which are hidden from search dialog box but can be filtered after selction in dialog
		public List<Field> AdditionalFields {get; private set;}
		
		// Status picklist values can be selected on filter dialog box based on object name
		public List<String> StatusValues {get; private set;}
		
		public List<PickListValue> SalesTaxList {get; private set;}
		public List<PickListValue> PriceLevelList {get; private set;}
		public List<PickListValue> PurchaseTaxList {get; private set;}
		public List<PickListValue> POTypeList {get; private set;}
		public List<PickListValue> CategoryList {get; private set;}
		
		/**
		 * Name: GridFilterConfigurations
		 * Description: Constructor used to initialize class variables based on parameter values
		 * @Param:	(1) HomeSearch_Setting__mdt hsSetting - Custom Metadata Type: Home Search Setting value
		 *			(2) String objectName - Obejct name selected in home search filter panel
		 * @Return:
		**/
		public GridFilterConfigurations(HomeSearch_Setting__mdt hsSetting, String objName) {
			// Set additional field values
			setAdditionalFields(hsSetting);
			
			// Set status values
			setStatusValues(hsSetting);
			
			if(objName == 'People' || objName == 'Customers' || objName == 'Vendors') {
				setSalesTaxList();
				setPriceLevelList();
			}
			if(objName == 'Vendors') {
				PurchaseTaxList = SalesTaxList;
			}
			if(objName == 'Vendor Orders') {
				setPOTypeList();
			}
			if(objName == 'Parts' || objName == 'Kits' || objName == 'Fees' || objName == 'Labor Codes' || objName == 'Products') {
				setCategoryList();
			}
		}
		
		/**
		 * Name: setAdditionalFields
		 * Description: Method to set additional fields available for object
		 * @Param:	1) HomeSearch_Setting__mdt hsSetting - Custom Metadata Type: Home Search Setting value
		 * @Return:
		**/
		private void setAdditionalFields(HomeSearch_Setting__mdt hsSetting) {
			AdditionalFields = new List<Field>();
			if(hsSetting.Additional_Fields_1__c != null && hsSetting.Additional_Fields_1__c.trim().length() > 0) {
				for(String addField : hsSetting.Additional_Fields_1__c.split(',')) {
					AdditionalFields.add(new Field(addField, hsSetting.DeveloperName));
					system.debug('%%%%%%%%%%%%'+addField);
				}
			}
			if(hsSetting.Additional_Fields_2__c != null && hsSetting.Additional_Fields_2__c.trim().length() > 0) {
				for(String addField : hsSetting.Additional_Fields_2__c.split(',')) {
					AdditionalFields.add(new Field(addField, hsSetting.DeveloperName));
				}
			}
			if(hsSetting.Additional_Fields_3__c != null && hsSetting.Additional_Fields_3__c.trim().length() > 0) {
				for(String addField : hsSetting.Additional_Fields_3__c.split(',')) {
					AdditionalFields.add(new Field(addField, hsSetting.DeveloperName));
				}
			}
			if(hsSetting.Additional_Fields_4__c != null && hsSetting.Additional_Fields_4__c.trim().length() > 0) {
				for(String addField : hsSetting.Additional_Fields_4__c.split(',')) {
					AdditionalFields.add(new Field(addField, hsSetting.DeveloperName));
				}
			}
		}
		
		/**
		 * Name: setStatusValues
		 * Description: Method to set staus field values available for object
		 * @Param:	1) HomeSearch_Setting__mdt hsSetting - Custom Metadata Type: Home Search Setting value
		 * @Return:
		**/
		private void setStatusValues(HomeSearch_Setting__mdt hsSetting) {
			StatusValues = new List<String>();
			if(hsSetting.Status__c != null && hsSetting.Status__c.trim().length() > 0) {
				StatusValues = hsSetting.Status__c.split(',');
			}
		}
		
		/**
		 * Name: setSalesTaxList
		 * Description: Method to set the sales Tax piclist
		 * @Param:	
		 * @Return:
		**/
		private void setSalesTaxList() {
			if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			List<Sales_Tax__c> salesTaxs = [select Id, Name__c from Sales_Tax__c limit: SOQLUtil.getAvailableQueryRowsLimit()];
			SalesTaxList = new List<PickListValue>();
			for(Sales_Tax__c salesTaxRec : salesTaxs) {
				SalesTaxList.add(new PickListValue(salesTaxRec.Id, salesTaxRec.Name__c));
			}
		}
		
		/**
		 * Name: setPriceLevelList
		 * Description: Method to set the Price Level List
		 * @Param:	
		 * @Return:
		**/
		private void setPriceLevelList() {
			if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			List<Price_Level__c> priceLevels = [select Id, Name__c from Price_Level__c limit: SOQLUtil.getAvailableQueryRowsLimit()];
			PriceLevelList = new List<PickListValue>();
			for(Price_Level__c pl : priceLevels) {
				PriceLevelList.add(new PickListValue(pl.Id, pl.Name__c));
			}
		}
		
		/**
		 * Name: setPOTypeList
		 * Description: Method to set PO Types List
		 * @Param:	
		 * @Return:
		**/
		private void setPOTypeList() {
			if(AccessControl.ifObjectFieldIsAccessible('PO_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			List<PO_Type__c> poTypes = [select Id, Name, Code__c from PO_Type__c limit: SOQLUtil.getAvailableQueryRowsLimit()];
			POTypeList = new List<PickListValue>();
			for(PO_Type__c pl : poTypes) {
				POTypeList.add(new PickListValue(pl.Id, pl.Code__c));
			}
		}
		
		/**
		 * Name: setCategoryList
		 * Description: Method to set PO Types List
		 * @Param:	
		 * @Return:
		**/
		private void setCategoryList() {
			if(AccessControl.ifObjectFieldIsAccessible('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			List<Category__c> categories = [select Id, Name from Category__c limit: SOQLUtil.getAvailableQueryRowsLimit()];
			CategoryList = new List<PickListValue>();
			for(Category__c catRec : categories) {
				CategoryList.add(new PickListValue(catRec.Id, catRec.Name));
			}
		}
	}
	
	/**
	 * Name: GridColumnsConfigurations
	 * Description: Class holds home search grid display and hiddden columns
	**/
	public class GridColumnsConfigurations {
		// List of display grid columns to be added in grid
		public List<Column> DisplayedColumns {get; private set;}
		
		// List of hidden grid columns to be added in grid
		public List<Column> HiddenColumns {get; private set;}
		
		public HomeSearchCtrl.FilterItem MatchFilter {get; private set;}
		
		/**
		 * Name: GridColumnsConfigurations
		 * Description: Constructor used to initialize class variables based on parameter values
		 * @Param:	1) List<HomeSearch_Grid_Column__mdt> gridColumnsList
		 * @Return:
		**/
		public GridColumnsConfigurations(List<HomeSearch_Grid_Column__mdt> gridColumnsList, Filter__c filterRec) {
			// Set display coulumns in grid
			setDisplayedColumns(gridColumnsList);
			
			// Set hidden coulumns in grid
			setHiddenColumns(gridColumnsList);
			
			if(filterRec.Name != null) {
				this.MatchFilter = new HomeSearchCtrl.FilterItem(filterRec);
			}
		}
		
		/**
		 * Name: setDisplayedColumns
		 * Description: Method to set the display columns in grid for object
		 * @Param:	1) List<HomeSearch_Grid_Column__mdt> gridColumnsList
		 * @Return:
		**/
		private void setDisplayedColumns(List<HomeSearch_Grid_Column__mdt> gridColumnsList) {
			DisplayedColumns = new List<Column>();
			if(gridColumnsList != null) {
				for(HomeSearch_Grid_Column__mdt gridCol : gridColumnsList) {
					if(gridCol.Is_Display__c && gridCol.Label != 'Id') {
						DisplayedColumns.add(new Column(gridCol));
					}
				}
			}
		}
		
		/**
		 * Name: setHiddenColumns
		 * Description: Method to set the display columns in grid for object
		 * @Param:	1) List<HomeSearch_Grid_Column__mdt> gridColumnsList
		 * @Return:
		 * 
		**/
		private void setHiddenColumns(List<HomeSearch_Grid_Column__mdt> gridColumnsList) {
			HiddenColumns = new List<Column>();
			if(gridColumnsList != null) {
				for(HomeSearch_Grid_Column__mdt gridCol : gridColumnsList) {
					if(!gridCol.Is_Display__c && gridCol.Label != 'Id') {
						HiddenColumns.add(new Column(gridCol));
					}
				}
			}
		}
	}
	
	/**
	 * Name: Column
	 * Description: Wrapper Class to hold properties of a column in grid
	**/
	public class Column {
		// Column header label
		public String Label {get; private set;}
		
		// Column data type
		public String Type {get; private set;}
		
		// Boolean if true, the column will be displayed in grid
		public Boolean IsDisplayed {get; private set;}
		
		// Boolean if true, the column will be hidden in grid
		public Boolean IsHidden {get; private set;}
		
		// Key field name by which search result record field value need to be identified
		public String RecordKey {get; private set;}
		
		// Field API name for the grid column of object
		public String FieldAPIName {get; private set;}
		
		/**
		 * Name: Column
		 * Description: Cosntructor which is used to set class variables based on custom metadata type
		 * @Param:	1) HomeSearch_Grid_Column__mdt - gridColumn - Custom Metadata Type column value
		 * @Return:
		**/
		public Column(HomeSearch_Grid_Column__mdt gridColumn) {
			this.Label = gridColumn.Label;
			this.Type = gridColumn.Type__c;
			this.IsDisplayed = gridColumn.Is_Display__c;
			this.FieldAPIName = gridColumn.Field_API_Name__c;
			this.IsHidden = !this.IsDisplayed;
			this.RecordKey = this.Label.replace(' ', '_');
		}
	}
	
	/**
	 * Name: Field
	 * Description: Wrapper Class to hold field configurations for object type (Additional fields)
	**/
	public class Field {
		// Field Label
		public String Label {get; private set;}
		
		// Boolean if true, the field will be displayed in filter panel
		public Boolean IsDisplayed {get; private set;}
		
		// UI Key for JSON
		public String UIFieldKey {get; private set;}
		
		/**
		 * Name: Field
		 * Description: Cosntructor which is used to set class variables based on custom metadata type
		 * @Param:	(1) String - fieldLabel - 
		 *			(2) String -  objectDeveloperName - 
		 * @Return:
		**/
		public Field(String fieldLabel, String objectDeveloperName) {
			this.Label = fieldLabel;
			this.IsDisplayed = false;
			system.debug('%%%%%%%%%%%%%'+objectDeveloperName);
			if(HomeSearchUtil.objectNameToLabelToJSONKeyMap.containsKey(objectDeveloperName)) {
				if(HomeSearchUtil.objectNameToLabelToJSONKeyMap.get(objectDeveloperName).containsKey(fieldLabel)) {
					this.UIFieldKey = HomeSearchUtil.objectNameToLabelToJSONKeyMap.get(objectDeveloperName).get(fieldLabel);
				}
			} else {
				this.UIFieldKey = null;				
			}
		}
	}
	
	
	/**
	 * Name: PickListValue
	 * Description: Wrapper Class to hold field configurations for object type (Additional fields)
	**/
	public class PickListValue {
		
		public String Id {get; private set;}
		public String Value {get; private set;}
		
		/**
		 * Name: PickListValue
		 * Description: Cosntructor which is used to set class variables based on custom metadata type
		 * @Param:	(1) String - id -  Id 
		 *			(2) String -  value - Value
		 * @Return:
		**/
		public PickListValue(String id, String value) {
			this.Id = id;
			this.Value = value;
		}
	}
}