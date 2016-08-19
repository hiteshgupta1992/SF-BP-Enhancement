/**
 * Author: Ashish Garg
 * Since: Sept. 24, 2014
 * Name: BlackPurlHomeCtrl
 * Description: Conroller class for BlackPurlHome page (Used In Kendo)
**/
public with sharing class BlackPurlHomeCtrl {
	
	// Boolean variables to decide pages to render
	public boolean renderSettings {get; private set;}
	public boolean renderCustomerMgmt {get; private set;}
	public boolean renderPartsMgmt {get; private set;}
	public boolean renderCategoryMgmt {get; private set;}
	public boolean renderVendorMgmt {get; private set;}
	public boolean renderMakeMgmt {get; private set;}
	public boolean renderErrorPage {get; private set;}
	
	/**
     * Name: BlackPurlHomeCtrl
     * Desc: Constructor
    **/
	public BlackPurlHomeCtrl(){
		renderErrorPage = decideRenderErrorPage();
		if( !renderErrorPage ){
			renderSettings = decideRenderPage(Constants.settingsPageParameterName);
			if( !renderSettings ){
				renderCustomerMgmt = decideRenderPage(Constants.customerMgmtPageParameterName);
				if( !renderCustomerMgmt ){
					renderPartsMgmt = decideRenderPage(Constants.partsMgmtPageParameterName);
					if(!renderPartsMgmt) {
						renderCategoryMgmt = decideRenderPage(Constants.categoryMgmtPageParameterName);
						if(!renderCategoryMgmt) {
							renderVendorMgmt = decideRenderPage(Constants.vendorMgmtPageParameterName);
							if(!renderVendorMgmt) {
								renderMakeMgmt = decideRenderPage(Constants.makeMgmtPageParameterName);
							} else {
								renderMakeMgmt = false;
							}
						} else {
							renderVendorMgmt = false;
						}
					} else {
						renderCategoryMgmt = false;
					}
				}else{
					renderPartsMgmt = false;
				}
			}else{
				renderCustomerMgmt = false;
			}
		}
	}
	
	/**
     * Name: decideRenderErrorPage
     * Desc: getter method which decides if to display Error page
     * @ret: boolean, true then render settings page
     * @param: 
    **/
	public boolean decideRenderErrorPage(){
		Map<String, String> pageParametersMap = ApexPages.currentPage().getParameters();
		for(String pageParamKey : pageParametersMap.keySet()){
			pageParamKey = String.escapeSingleQuotes(pageParamKey);
			if( !Constants.ALLOWED_PAGE_PARAMS.contains(pageParamKey.toLowerCase()) ){
				return true;
			}
		}
		return false;
	}
	
	/**
     * Name: decideRenderPage
     * Desc: getter method which decides if to display settings page
     * @ret: boolean, true then render settings page
     * @param: renderPageParameterName - Page parameter
    **/
	public boolean decideRenderPage(String renderPageParameterName){
		String pageNameParam = ApexPages.currentPage().getParameters().get(Constants.pageParameterName);
		if(pageNameParam != null) {
			pageNameParam = String.escapeSingleQuotes(pageNameParam);
		}
		if(pageNameParam == null || pageNameParam.trim().length() == 0 || pageNameParam.equalsIgnoreCase(renderPageParameterName)){
			return true;
		}
		return false;
	}
	
}