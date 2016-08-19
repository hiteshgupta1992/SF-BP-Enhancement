/**
 * Author: Anurag Anand
 * Since: April. 26, 2016
 * Name: DeleteScheduler
 * Description: Apex class which calls methods to delete Active Blank Records.
**/
global class DeleteScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      //DeleteEmptyRecordsSchedulerCtrl deleteEmptyObj  = new DeleteEmptyRecordsSchedulerCtrl(); 
      DeleteEmptyRecordsSchedulerCtrl.deleteVendorInvoicing();
      DeleteEmptyRecordsSchedulerCtrl.deleteVendorRecieving();
      DeleteEmptyRecordsSchedulerCtrl.deleteVendorOrder();
      DeleteEmptyRecordsSchedulerCtrl.deleteCustomerOrder();
      
   }
   	/**
     * Name: executeDataScheduler
     * Desc: Method which delete the VendorInvoice which are blank
     * @param: 1.Integer second : Sec at which Scheduler to run
     		   2.Integer minute : minute at which Scheduler to run
     		   3.Integer hour : hour at which Scheduler to run
     		   4.Integer day : day at which Scheduler to run
     		   5.Integer month : month at which Scheduler to run
     * @return: 
    **/
   global static void executeDataScheduler(Integer second, Integer minute, Integer hour, Integer day, Integer month, Integer year){
   		DeleteScheduler delScheduler = new DeleteScheduler();
       	String sch = String.valueOf(second)+' '+String.valueOf(minute)+' '+ String.valueOf(hour)+' '+ String.valueOf(day)+' '+ String.valueOf(month)+' '+ String.valueOf(year);
       	system.schedule('Blank Record Deletion', sch, delScheduler); 
   }
   
   
   
   
}