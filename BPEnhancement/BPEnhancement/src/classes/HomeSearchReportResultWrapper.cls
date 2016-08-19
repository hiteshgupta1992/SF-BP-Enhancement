/**
 * Author: Tarun Khandelwal
 * Since: April 15, 2016
 * Name: HomeSearchReportResultWrapper
 * Description: Apex class to handle all operations related to JSON Forming Operation of Home Search Reporting Data
**/
public with sharing class HomeSearchReportResultWrapper {
	
	public String RecordKey;
	public String Label;
	public Decimal TotalValue;
	public Boolean IsDisplayed;
	public String Type;
	
	public HomeSearchReportResultWrapper(Decimal value, String fieldLabel, String fieldType) {
		this.RecordKey = (fieldLabel != null) ? fieldLabel.replaceAll(' ', '_') : fieldLabel;
		this.Label = (fieldLabel == HomeSearchReportUtil.COUNT_RECORD_ALIASE) ? HomeSearchReportUtil.COUNT_RECORD_LABEL : 
							(fieldLabel.contains('_') ? fieldLabel.replaceAll('_', ' ') : fieldLabel);
		this.TotalValue = value;
		this.IsDisplayed = false;
		this.Type = (fieldLabel == HomeSearchReportUtil.COUNT_RECORD_ALIASE) ?  HomeSearchReportUtil.NUMERIC_TYPE_1 : fieldType;
	}
	
}