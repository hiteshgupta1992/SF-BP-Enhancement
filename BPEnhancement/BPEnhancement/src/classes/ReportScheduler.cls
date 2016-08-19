global class ReportScheduler implements Schedulable{
   global void execute(SchedulableContext SC) {
      ReportsToEmail.getOrgReports();
   }
}