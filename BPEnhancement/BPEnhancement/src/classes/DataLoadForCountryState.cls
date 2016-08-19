public with sharing class DataLoadForCountryState {
	
	public DataLoadForCountryState() {
		if(AccessControl.ifObjectFieldIsCreateable('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		List<Country__c> countryList = new List<Country__c>();
		countryList.add(new Country__c(Name__c = 'Australia'));
		countryList.add(new Country__c(Name__c = 'Canada', Default__c = true));
		countryList.add(new Country__c(Name__c = 'New Zealand'));
		countryList.add(new Country__c(Name__c = 'USA'));
		countryList.add(new Country__c(Name__c = 'Costa Rica'));
		countryList.add(new Country__c(Name__c = 'Guinea'));
		countryList.add(new Country__c(Name__c = 'Israel'));
		countryList.add(new Country__c(Name__c = 'Luxembourg'));
		countryList.add(new Country__c(Name__c = 'Maldives'));
		countryList.add(new Country__c(Name__c = 'Malaysia'));
		countryList.add(new Country__c(Name__c = 'Mali'));
		countryList.add(new Country__c(Name__c = 'Mauritius'));
		
		
		insert countryList;
		
		Map<String, Id> countryNameToCountryIdMap = new Map<String, Id>();
		countryNameToCountryIdMap.put(countryList[0].Name__c, countryList[0].Id);
		countryNameToCountryIdMap.put(countryList[1].Name__c, countryList[1].Id);
		countryNameToCountryIdMap.put(countryList[2].Name__c, countryList[2].Id);
		countryNameToCountryIdMap.put(countryList[3].Name__c, countryList[3].Id);
		countryNameToCountryIdMap.put(countryList[4].Name__c, countryList[4].Id);
		countryNameToCountryIdMap.put(countryList[5].Name__c, countryList[5].Id);
		countryNameToCountryIdMap.put(countryList[6].Name__c, countryList[6].Id);
		countryNameToCountryIdMap.put(countryList[7].Name__c, countryList[7].Id);
		countryNameToCountryIdMap.put(countryList[8].Name__c, countryList[8].Id);
		countryNameToCountryIdMap.put(countryList[9].Name__c, countryList[9].Id);
		countryNameToCountryIdMap.put(countryList[10].Name__c, countryList[10].Id);
		countryNameToCountryIdMap.put(countryList[11].Name__c, countryList[11].Id);
		
		
		
		Map<String, List<String>> countryNameToStatesNameMap = new Map<String, List<String>>();
		List<String> statesList = new List<String>();
		
		// For Australia Country
		statesList.add('Australian Capital Territory');
		statesList.add('New South Wales');
		statesList.add('Northern Territory');
		statesList.add('Queensland');
		statesList.add('South Australia');
		statesList.add('Tasmania');
		statesList.add('Victoria');
		statesList.add('Western Australia');
		
		countryNameToStatesNameMap.put(countryList[0].Name__c, statesList);
		
		
		// For Canada Country
		statesList = new List<String>();
		
		statesList.add('Alberta');
		statesList.add('British Columbia');
		statesList.add('Manitoba');
		statesList.add('New Brunswick');
		statesList.add('Newfoundland and Labrador');
		statesList.add('Nova Scotia');
		statesList.add('Northwest Territories');
		statesList.add('Nunavut');
		statesList.add('Ontario');
		statesList.add('Prince Edward Island');
		statesList.add('Quebec');
		statesList.add('Saskatchewan');
		statesList.add('Yukon Territory');
		
		countryNameToStatesNameMap.put(countryList[1].Name__c, statesList);
		
		
		// For New Zealand Country
		statesList = new List<String>();
		
		statesList.add('Auckland');
		statesList.add('Bay of Plenty');
		statesList.add('Canterbury');
		statesList.add('Chatham Islands Territory');
		statesList.add('Gisborne District');
		statesList.add('Hawkes\'s Bay');
		statesList.add('Marlborough District');
		statesList.add('Manawatu-Wanganui');
		statesList.add('Nelson City');
		statesList.add('Northland');
		statesList.add('Otago');
		statesList.add('Southland');
		statesList.add('Tasman District');
		statesList.add('Taranaki');
		statesList.add('Wellington');
		statesList.add('Waikato');
		statesList.add('West Coast');
		
		countryNameToStatesNameMap.put(countryList[2].Name__c, statesList);
		
		
		// For USA Country
		statesList = new List<String>();
		
		statesList.add('Alaska');
		statesList.add('Alabama');
		statesList.add('Arkansas');
		statesList.add('American Samoa');
		statesList.add('Arizona');
		statesList.add('California');
		statesList.add('Colorado');
		statesList.add('Connecticut');
		statesList.add('District of Columbia');
		statesList.add('Delaware');
		statesList.add('Florida');
		statesList.add('Georgia');
		statesList.add('Guam');
		statesList.add('Hawaii');
		statesList.add('Iowa');
		statesList.add('Idaho');
		statesList.add('Illinois');
		statesList.add('Indiana');
		statesList.add('Kansas');
		statesList.add('Kentucky');
		statesList.add('Louisiana');
		statesList.add('Massachusetts');
		statesList.add('Maryland');
		statesList.add('Maine');
		statesList.add('Michigan');
		statesList.add('Minnesota');
		statesList.add('Missouri');
		statesList.add('Northern Mariana Islands');
		statesList.add('Mississippi');
		statesList.add('Montana');
		statesList.add('North Carolina');
		statesList.add('North Dakota');
		statesList.add('Nebraska');
		statesList.add('New Hampshire');
		statesList.add('New Jersey');
		statesList.add('New Mexico');
		statesList.add('Nevada');
		statesList.add('New York');
		statesList.add('Ohio');
		statesList.add('Oklahoma');
		statesList.add('Oregon');
		statesList.add('Pennsylvania');
		statesList.add('Puerto Rico');
		statesList.add('Rhode Island');
		statesList.add('South Carolina');
		statesList.add('South Dakota');
		statesList.add('Tennessee');
		statesList.add('Texas');
		statesList.add('U.S. Minor Outlying Islands');
		statesList.add('Utah');
		statesList.add('Virginia');
		statesList.add('Virgin Islands of the U.S.');
		statesList.add('Vermont');
		statesList.add('Washington');
		statesList.add('Wisconsin');
		statesList.add('West Virginia');
		statesList.add('Wyoming');
		
		countryNameToStatesNameMap.put(countryList[3].Name__c, statesList);
		
		
	/*	// For Brazil Country
		statesList = new List<String>();
		
		statesList.add('Acre');
		statesList.add('Alagoas');
		statesList.add('Arkansas');
		statesList.add('Amazonas');
		statesList.add('Bahia');
		statesList.add('Ceara');
		statesList.add('Espirito Santo');
		statesList.add('Goias');
		statesList.add('Maranhao');
		statesList.add('Bahia');
		statesList.add('Mato Grosso');
		statesList.add('Mato Grosso do Sul');
		statesList.add('Minas Gerais');
		statesList.add('Para');
		statesList.add('Paraiba');
		statesList.add('Parana');
		statesList.add('Pernambuco');
		statesList.add('Piaui');
		statesList.add('Rio de Janeiro');
		statesList.add('Rio Grande do Norte');
		statesList.add('Rondonia');
		statesList.add('Roraima');
		statesList.add('Santa Catarina');
		statesList.add('Sao Paulo');
		statesList.add('Sergipe');
		statesList.add('Tocantins');
		
		countryNameToStatesNameMap.put(countryList[4].Name__c, statesList);
		*/
		
		// For Costa Rica Country
		statesList = new List<String>();
		
		statesList.add('Alajuela');
		statesList.add('Cartago');
		statesList.add('Guanacaste');
		statesList.add('Heredia');
		statesList.add('Limon');
		statesList.add('Puntarenas');
		statesList.add('San Jose');
		
		
		countryNameToStatesNameMap.put(countryList[4].Name__c, statesList);
		
		
		// For Guinea Country
		statesList = new List<String>();
		
		
		statesList.add('Boke');
		statesList.add('Faranah');
		statesList.add('Kankan');
		statesList.add('Kindia');
		statesList.add('Labe');
		statesList.add('Mamou');
		statesList.add('N\'Zerekore');
		
		countryNameToStatesNameMap.put(countryList[5].Name__c, statesList);
		
		
		
		// For Israel Country
		statesList = new List<String>();
		
		statesList.add('Central');
		statesList.add('Haifa');
		statesList.add('Jerusalem');
		statesList.add('Northern');
		statesList.add('Southern');
		statesList.add('Tel Aviv');
		
		countryNameToStatesNameMap.put(countryList[6].Name__c, statesList);
		
		
		// For Luxembourg Country
		statesList = new List<String>();
		
		statesList.add('Diekirch');
		statesList.add('Grevenmacher');
		statesList.add('Luxembourg');
		
		countryNameToStatesNameMap.put(countryList[7].Name__c, statesList);
		
		
		// For Luxembourg Country
		statesList = new List<String>();
		
		statesList.add('Dhekunu');
		statesList.add('Mathi Dhekunu');
		statesList.add('Mathi Uthuru');
		statesList.add('Medhu');
		statesList.add('Medhu Dhekunu');
		statesList.add('Medhu Uthuru');
		statesList.add('Uthuru');
		
		countryNameToStatesNameMap.put(countryList[8].Name__c, statesList);
		
		
		
		// For Malaysia Country
		statesList = new List<String>();
		
		statesList.add('Johor');
		statesList.add('Kedah');
		statesList.add('Kelantan');
		statesList.add('Melaka');
		statesList.add('Negeri Sembilan');
		statesList.add('Pahang');
		statesList.add('Perak');
		statesList.add('Perlis');
		statesList.add('Pulau Pinang');
		statesList.add('Sabah');
		statesList.add('Sarawak');
		statesList.add('Selangor');
		statesList.add('Terengganu');
		
		countryNameToStatesNameMap.put(countryList[9].Name__c, statesList);
		
		
		
		// For Mali Country
		statesList = new List<String>();
		
		
		statesList.add('Gao');
		statesList.add('Kayes');
		statesList.add('Kidal');
		statesList.add('Koulikoro');
		statesList.add('Mopti');
		statesList.add('Segou');
		statesList.add('Sikasso');
		statesList.add('Tombouctou');
		
		countryNameToStatesNameMap.put(countryList[10].Name__c, statesList);
		
		
		
		// For Mauritius Country
		statesList = new List<String>();
		
		statesList.add('Black River');
		statesList.add('Flacq');
		statesList.add('Grand Port');
		statesList.add('Moka');
		statesList.add('Pamplemousses');
		statesList.add('Plaines Wilhems');
		statesList.add('Port Louis');
		statesList.add('Riviere du Rempart');
		statesList.add('Savanne');
		
		countryNameToStatesNameMap.put(countryList[11].Name__c, statesList);
		
		
		List<State__c> stateListToBeInsert = new List<State__c>();
		Integer Counter = 0;
		for(String countryName : countryNameToStatesNameMap.keyset() ) {
			for(String stateName : countryNameToStatesNameMap.get(countryName)) {
				stateListToBeInsert.add(new State__c(Name__c = stateName, Country__c = countryNameToCountryIdMap.get(countryName)));
				Counter++;
				system.debug('      ' + stateName + '  ' +Counter);
			}
		}
		if(AccessControl.ifObjectFieldIsCreateable('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		insert stateListToBeInsert;
		
	}
}