/**
 * Author: Subhrant Singh
 * Since: 19 Feb 2016
 * Name: HomeSearchAllFilter
 * Description: Apex class class for json parsing filter 
**/
public with sharing class  HomeSearchAllFilter{
	
	public map<String,List<GroupFilterWrapper>> FilterType =new  map<String,List<GroupFilterWrapper>>();
	
	/**
	 * Name: HomeSearchAllFilter
	 * Description: Constructor
	 * @Param:	(1)filterList - List<Filter__c> - List Of Filter__C Object Record
	 * @Return:	
	**/
	public HomeSearchAllFilter(List<Filter__c> fiterList){
		//System.assert(false, fiterList);
		map<String,List<Filter__c>> FilterMap = new map<String,List<Filter__c>>(); 
		set<String> CheckFilterString = new set<String>();
	 
	 	for(Filter__c filterRec : fiterList){
	 			if(filterRec.Favorite__c){
					if(!FilterType.keySet().contains('Favorite')){
							FilterType.put('Favorite',new List<GroupFilterWrapper>());
					}  
					GroupFilterWrapper obj =new GroupFilterWrapper(filterRec);
					FilterType.get('Favorite').add(obj);
				}else if(filterRec.Common__c){
					if(!FilterType.keySet().contains('Common')){
							FilterType.put('Common',new List<GroupFilterWrapper>());
					}
					if(!CheckFilterString.contains(filterRec.CommonFilterCategory__c)){
						List<Filter__c> ListToSubCategory = new List<Filter__c>();
						CheckFilterString.add(filterRec.CommonFilterCategory__c);
						for(Filter__c filterRecToSubRec : fiterList){
							if( !filterRecToSubRec.Custom__c && filterRecToSubRec.Common__c  && filterRecToSubRec.CommonFilterCategory__c == filterRec.CommonFilterCategory__c){
								ListToSubCategory.add(filterRecToSubRec);
							}
						}
						GroupFilterWrapper obj =new GroupFilterWrapper(ListToSubCategory,filterRec.CommonFilterCategory__c);
						FilterType.get('Common').add(obj);
					}
				}else if(filterRec.Custom__c){
					if(!FilterType.keySet().contains('Custom')){
							FilterType.put('Custom',new List<GroupFilterWrapper>());
					}
					GroupFilterWrapper obj =new GroupFilterWrapper(filterRec);
					FilterType.get('Custom').add(obj);
				}
				
	 		}  
	 		//system.assert(false,FilterType);
		}
		
		

	/**
	* Name: GroupFilterWrapper
	* Description: Group Filter Wrapper Class
	**/
	public class GroupFilterWrapper{
		public String Id;
		public String FilterLabel;
		public Boolean IsCommon;
		public Integer Order;
		
		//public String Category;
		public List<SubGroupFilterWrapper> subgroupList =new List<SubGroupFilterWrapper>();
		
		/**
		* Name: GroupFilterWrapper
	 	* Description: Constructor
	 	* @Param:	(1)filterRec - Filter__c - Filter__C Object Record
	 	* @Return:	
		**/
		public GroupFilterWrapper ( Filter__c filterRec){
							this.Id= filterRec.Id;
							if( filterRec.Filter_Label__c == null){
								this.FilterLabel = '';
							}
							else{
								this.FilterLabel = filterRec.Filter_Label__c;
							}
							this.IsCommon = filterRec.Common__c;
							//this.Category = filterRec.CommonFilterCategory__c;
							this.Order = (HomeSearchUtil.filterGroupToOrderMap.containsKey(filterRec.CommonFilterCategory__c)) ? HomeSearchUtil.filterGroupToOrderMap.get(filterRec.CommonFilterCategory__c) : 100;
		}
		
		/**
		* Name: GroupFilterWrapper
	 	* Description: Constructor
	 	* @Param:	(1)FilterList - List<Filter__c> - List of Filter__C Object Record
	 	*			(2)FilterLabel - String - Filter Label String
	 	* @Return:	
		**/
		public GroupFilterWrapper ( List<Filter__c> FilterList ,String FilterLabel ){	
			this.FilterLabel = FilterLabel;
			this.Order = (HomeSearchUtil.filterGroupToOrderMap.containsKey(this.FilterLabel)) ? HomeSearchUtil.filterGroupToOrderMap.get(this.FilterLabel) : 100;
			for( Filter__c filterRec : FilterList){
							FilterLabel = filterRec.CommonFilterCategory__c;
							SubGroupFilterWrapper obj=new SubGroupFilterWrapper(filterRec);
							subgroupList.add(obj);
							
			}
		}
	}
	
	/**
	* Name: SubGroupFilterWrapper
	* Description: Sub Group Filter Wrapper Class
	**/
	public class SubGroupFilterWrapper{
		public String Id;
		public String FilterLabel;
		public String Category;
		public Boolean IsCommon;
		public Integer Order;
		
		/**
		* Name: SubGroupFilterWrapper
	 	* Description: Constructor
	 	* @Param:	(1)filterRec - Filter__c - Filter__C Object Record
	 	* @Return:	
		**/
		public SubGroupFilterWrapper (Filter__c filterRec){
			
						this.Id= filterRec.Id;
						if( filterRec.Filter_Label__c == null){
							this.FilterLabel = '';
						}
						else{
							this.FilterLabel = filterRec.Filter_Label__c;
						}
						this.Category = filterRec.CommonFilterCategory__c;
						this.IsCommon = filterRec.Common__c;
						this.Order = (HomeSearchUtil.filterGroupToOrderMap.containsKey(this.FilterLabel)) ? HomeSearchUtil.filterGroupToOrderMap.get(this.FilterLabel) : 100;
		}
	}
}