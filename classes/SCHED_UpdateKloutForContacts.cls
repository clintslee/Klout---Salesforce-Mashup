/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

global class SCHED_UpdateKloutForContacts implements Schedulable {
	   public static String CRON_EXP = '0 0 5 * * ?';
	   
	   
	   // @params:  SchedulableContext  
	   // @returns: Void
	   // @summary:  Creates a new 
	   global void execute(SchedulableContext SC) {
              BATCH_UpdateKloutForContacts batch = new BATCH_UpdateKloutForContacts();
              batch.query =  'select id, twitter_username__c from Contact where twitter_username__c != null';
              database.executebatch(batch, 5);
       } 
       
       /*********************************************************************************************
       * Test Methods
       *********************************************************************************************/
       
       static testMethod void scheduledTest() {
    	
    	   Test.startTest();
    	
    	   String jobId = System.schedule('testSCHED_UpdateKloutForContacts'
    	                                  ,SCHED_UpdateKloutForLeads.CRON_EXP
    	                                  ,new SCHED_UpdateKloutForContacts());
   		   
   		   // Get the information from the CronTrigger API object  
           CronTrigger ct = [SELECT id
                                   ,CronExpression
                                   ,TimesTriggered
                                   ,NextFireTime
                               FROM CronTrigger 
                              WHERE id = :jobId];

           // Verify the expressions are the same  
           System.assertEquals(SCHED_UpdateKloutForContacts.CRON_EXP, ct.CronExpression);

           // Verify the job has not run  
           System.assertEquals(0, ct.TimesTriggered);

           Test.stopTest();     
    }

}