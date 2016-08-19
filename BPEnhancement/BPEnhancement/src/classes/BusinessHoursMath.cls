public with sharing class BusinessHoursMath {
	public BusinessHours businessHours;
	public List<Holiday> holidays;
	public List<Day> businessDays;
 
	public BusinessHoursMath() {
		//by default, get default
		if(AccessControl.ifObjectFieldIsAccessible('BusinessHours') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Holiday') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
		businessHours = [SELECT Id, MondayEndTime, MondayStartTime, TuesdayEndTime, TuesdayStartTime, WednesdayEndTime, WednesdayStartTime, ThursdayEndTime, ThursdayStartTime, FridayEndTime, FridayStartTime, SaturdayEndTime, SaturdayStartTime, SundayEndTime, SundayStartTime FROM BusinessHours WHERE IsDefault=true];
		holidays = [SELECT Id, ActivityDate, RecurrenceType, RecurrenceDayOfMonth, RecurrenceMonthOfYear from Holiday LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
		configureBusinessWeek();
	}

	public BusinessHoursMath configureBusinessWeek() {
		businessDays = new Day[7];
		businessDays[0] = new Day(
			(businessHours.SundayStartTime != null),
			businessHours.SundayStartTime ,
			businessHours.SundayEndTime
		);
		businessDays[1] = new Day(
			(businessHours.MondayStartTime != null),
			businessHours.MondayStartTime ,
			businessHours.MondayEndTime
		);
		businessDays[2] = new Day(
			(businessHours.TuesdayStartTime != null),
			businessHours.TuesdayStartTime ,
			businessHours.TuesdayEndTime
		);
		businessDays[3] = new Day(
			(businessHours.WednesdayStartTime != null),
			businessHours.WednesdayStartTime ,
			businessHours.WednesdayEndTime
		);
		businessDays[4] = new Day(
			(businessHours.ThursdayStartTime != null),
			businessHours.ThursdayStartTime ,
			businessHours.ThursdayEndTime
		);
		businessDays[5] = new Day(
			(businessHours.FridayStartTime != null),
			businessHours.FridayStartTime ,
			businessHours.FridayEndTime
		);
		businessDays[6] = new Day(
			(businessHours.SaturdayStartTime != null),
			businessHours.SaturdayStartTime ,
			businessHours.SaturdayEndTime
		);
		return this;//chainable
	}

	public BusinessHoursMath setBusinessHours(BusinessHours businessHoursIn) {
		businessHours = businessHoursIn;
		return configureBusinessWeek();//chainable
	}

	public BusinessHoursMath setHolidays(List<Holiday> holidaysIn) {
		holidays = holidaysIn;
		return this;//chain
	}

	public Boolean isBusinessDay(DateTime datetimeToCheck){
		Date dateToCheck = datetimeToCheck.date();
		for(Holiday holiday : this.holidays) {
			if(holiday.RecurrenceType == null) {//no recurence
				if(holiday.ActivityDate == dateToCheck) {
					system.debug('***Match: ' + holiday.ActivityDate + ' - ' + dateToCheck);
					return false;
				}
			} else if(holiday.RecurrenceType == 'RecursYearly') {
				Integer dayOfMonth = dateToCheck.day();
				Integer monthOfYear = dateToCheck.month();
				system.debug('monthOfYear: '+ monthOfYear);
				Integer holidayDayOfMonth = holiday.RecurrenceDayOfMonth;
				Integer holidayMonthOfYear;

				//big if statement to translate month to day
				if(holiday.RecurrenceMonthOfYear == 'January') {
					holidayMonthOfYear = 1;
				} else if(holiday.RecurrenceMonthOfYear == 'February') {
					holidayMonthOfYear = 2;
				} else if(holiday.RecurrenceMonthOfYear == 'March') {
					holidayMonthOfYear = 3;
				} else if(holiday.RecurrenceMonthOfYear == 'April') {
					holidayMonthOfYear = 4;
				} else if(holiday.RecurrenceMonthOfYear == 'May') {
					holidayMonthOfYear = 5;
				} else if(holiday.RecurrenceMonthOfYear == 'June') {
					holidayMonthOfYear = 6;
				} else if(holiday.RecurrenceMonthOfYear == 'July') {
					holidayMonthOfYear = 7;
				} else if(holiday.RecurrenceMonthOfYear == 'August') {
					holidayMonthOfYear = 8;
				} else if(holiday.RecurrenceMonthOfYear == 'September') {
					holidayMonthOfYear = 9;
				} else if(holiday.RecurrenceMonthOfYear == 'October') {
					holidayMonthOfYear = 10;
				} else if(holiday.RecurrenceMonthOfYear == 'November') {
					holidayMonthOfYear = 11;
				} else if(holiday.RecurrenceMonthOfYear == 'December') {
					holidayMonthOfYear = 12;
				}
				if((dayOfMonth == holidayDayOfMonth) && (monthOfYear == holidayMonthOfYear))
					return false;
			}
		}
		//passed the holiday check, now lets check the business day. 
		//Integer 
		//if()
		Date tmpDate = dateToCheck.toStartofWeek();
		Integer dayOfWeek = tmpDate.daysBetween(dateToCheck);
		return businessDays[dayOfWeek].isBusinessDay;//return the business day status
	}

	public Boolean isBusinessDay(Date dateToCheck) {
		return isBusinessDay(DateTime.newInstance(dateToCheck, DateTime.now().time()));
	}

	public Date getEndOfBusinessDayFromDate(DateTime dateStarted, Integer numberOfBusinessDays) {
		Integer businessDayCounter = 0;//count of business days actually hit.
		Integer dayCounter = 0;//loops through the days one at a time, starts with 1 
		DateTime endOfDayDateTime;
		while(businessDayCounter < numberOfBusinessDays) {
			if(isBusinessDay(dateStarted.addDays(dayCounter + 1))) {//check tomorrow in the loop
				businessDayCounter++;
				system.debug(dateStarted.addDays(dayCounter + 1) + ' - is businessDay');
			} else {
				system.debug(dateStarted.addDays(dayCounter + 1) + ' - is NOT a businessDay');
			}
			dayCounter++;
		}
		endOfDayDateTime = dateStarted.addDays(dayCounter);
		return getEndOfBusinessDay(endOfDayDateTime);
	}

	public Date getEndOfBusinessDayFromDate(Date dateStarted, Integer numberOfBusinessDays) {
		return getEndOfBusinessDayFromDate(DateTime.newInstance(dateStarted, DateTime.now().time()), numberOfBusinessDays);
	}

	public Date getEndOfBusinessDay(DateTime dateToCast) {
		//will return null if its not a business day, you should probably route this 
		//through another function anyways, ya know, like the one above ;)
		Date businessDayDate = dateToCast.date();
		return businessDayDate;
		/*Date tmpDate = businessDayDate.toStartofWeek();
		Integer dayOfWeek = tmpDate.daysBetween(businessDayDate);
		Time businessDayEndTime = this.businessDays[dayOfWeek].endTime;
		return DateTime.newInstance(businessDayDate, businessDayEndTime);*/

	}

	public class Day {
		public Boolean isBusinessDay;
		public Time startTime;
		public Time endTime;

		public Day(Boolean isBusinessDayIn, Time startTimeIn, Time endTimeIn) {
			this.isBusinessDay = isBusinessDayIn;
			this.startTime = startTimeIn;
			this.endTime = endTimeIn;
		}
	}
}