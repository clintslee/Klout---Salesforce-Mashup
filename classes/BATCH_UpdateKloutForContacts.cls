/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

global class BATCH_UpdateKloutForContacts implements Database.Batchable<sObject>, Database.AllowsCallouts {
       
        public String query;                 // 'select id, twitter_username__c from Contact where twitter_username__c != null';
        public Boolean isTest = false;       // used for testing b/c of the HTTP callouts.
        public Boolean sendEmail = false;    // used to toggle on/off email notification of completed batches
        
        global database.Querylocator start(Database.BatchableContext BC) {
        	   return Database.getQueryLocator(query);
        }
        
        global void execute(Database.BatchableContext BC, List<Contact> scope) {
        	   Set<Id> ids = Klout_ContactManager.makeIdSet(scope);
        	   Map<String,Contact> usernameToContactMap = new Map<String,Contact>();
			   List<String> usernames = new List<String>();
			   List<Contact> contactsToUpdate = new List<Contact>();
			   List<KloutResponse> userResponseList = new List<KloutResponse>();
			    
			    
			   // query and loop through all contacts passed in from the trigger.  if there is a twitter username
			   // add the username to the list, then add the <username, contact> pair to the map.
			   for(Integer i = 0; i < scope.size(); i++) {
			        if(scope[i].twitter_username__c != null) {
			    		usernames.add(scope[i].twitter_username__c);
			    		usernameToContactMap.put(scope[i].twitter_username__c, scope[i]);
			        }
			   }
			    
			    // ensure that there was at least one contact with a twitter username before proceeding.
			    if(usernames.size() > 0) {
			       try {  // handles sending the usernames to klout and putting the responses in a list.
			           Klout klout = new Klout();
			           klout.isTestOne = isTest;
			    	   userResponseList = klout.getKlout(usernames, 'show');
			       } catch(KloutResponse.KloutException e) {
			    	   System.debug(e);
			       }
			       
			       // loop through all the responses 
			       for(KloutResponse user : userResponseList) {
			       	   if(usernameToContactMap.get(user.getUsername()) != null) {      // to prevent a null error, ensure the username exists as a key in the map.
			       	      Contact c = usernameToContactMap.get(user.getUsername());    // use the map to get the lead from the username, then assign it to a new contact. 
			       	      c.klout_score__c = user.getKscore();                         // assign the klout score (from the response) to the corresponding contact field.
			       	      c.Klout_Amplification_Score__c = user.getAmpScore();
			       	      c.Klout_Class__c = user.getKClass();
			       	      c.Klout_Class_Description__c = user.getKClassDesc();
			       	      c.Klout_Delta_1_Day__c = user.getDelta_1day();
			       	      c.Klout_Delta_5_Day__c = user.getDelta_5day();
			       	      c.Klout_Network_Score__c = user.getNetworkScore();
			       	      c.Klout_Score_Description__c = user.getKScoreDesc();
			       	      c.Klout_Slope__c = user.getSlope();
			       	      c.Klout_True_Reach__c = user.getTrueReach();
			       	      c.Klout_Twitter_Id__c = user.getTwitterId();
			       	      c.Klout_Most_Discussed_Topics__c = user.getTopics();
			       	      c.Klout_Influenced_By__c = user.getInfluencers();
			       	      c.Klout_Influencer_Of__c = user.getInfluencees();
			       	      contactsToUpdate.add(c);                                     // add the contact to the list for updating.
			       	      usernameToContactMap.remove(user.getUsername());             // remove this twitter username from the map to prevent duplication errors.                   
			       	   }
			       }        	   
                }
                update contactsToUpdate;
        }
        
        global void finish(Database.BatchableContext BC) {
        	   // query info about the completed job.
              AsyncApexJob a = 
                             [select id
                                    ,Status
                                    ,NumberOfErrors
                                    ,JobItemsProcessed
                                    ,TotalJobItems
                                    ,CreatedBy.Email
                                from AsyncApexJob 
                               where Id = :BC.getJobId()];
        
              if(sendEmail) {
                 // Create and send an email with the results of the batch.  Set email address info below.
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

       		     mail.setToAddresses(new String[] {a.CreatedBy.Email});
        	 	 mail.setReplyTo('clint@theflywheelgroup.com');
        	 	 mail.setSenderDisplayName('Klout Batch');
        	 	 mail.setSubject('Update Status: ' + a.Status);
        	 	 mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems + 
       	     	 ' batches with ' + a.NumberofErrors + ' failures.');

       		  	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              }
        }
}