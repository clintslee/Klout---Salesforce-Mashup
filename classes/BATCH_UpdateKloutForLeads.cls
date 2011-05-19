/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This method will loop through all the leads and send them to the Klout API to retrieve
* the Klout User data.  Since batch apex only supports one callout per execute method,
* the batch size must be set to 1 when using this class.
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

global class BATCH_UpdateKloutForLeads implements Database.Batchable<sObject>, Database.AllowsCallouts {
       
        public String query;                       // 'select id, twitter_username__c from Contact where twitter_username__c != null';
        public Boolean isTest = false;             // used for testing b/c of the HTTP callouts.
        public Boolean sendEmail = false;          // used to toggle on/off email notification of completed batches
        
        // @params:  Database.BatchableContext
        // @returns: Database.QueryLocator
        // @summary: Runs a SOQL query using the query variable that is set by the client.
        global database.Querylocator start(Database.BatchableContext BC) {
        	   return Database.getQueryLocator(query);
        }
        
        // @params:  Database.BatchableContext, A list of Leads
        // @returns: Void
        // @summary: This is the execute method required by the Batchable interface. Takes all leads that
        //           are passed in through the scope variable, sends them to Klout, and assigns the responses
        //           to the correct field on the Lead object.
        global void execute(Database.BatchableContext BC, List<Lead> scope) {
        	   Set<Id> ids = Klout_LeadManager.makeIdSet(scope);
        	   Map<String,Lead> usernameToLeadMap = new Map<String,Lead>();
			   List<String> usernames = new List<String>();
			   List<Lead> leadsToUpdate = new List<Lead>();
			   List<KloutResponse> userResponseList = new List<KloutResponse>();
			    
			   // query and loop through all leads passed in from the trigger.  if there is a twitter username
			   // add the username to the list, then add the <username, lead> pair to the map.
			   for(Integer i = 0; i < scope.size(); i++) {        //[select id, klout_score__c, twitter_username__c from lead where id IN :ids]) 
			    	System.debug(scope[i].twitter_username__c);
			    	if(scope[i].twitter_username__c != null) {
			    		usernames.add(scope[i].twitter_username__c);
			    		usernameToLeadMap.put(scope[i].twitter_username__c, scope[i]);
			        }
			   }
			        System.debug('USERNAME SIZE' + usernames.size());
			    
			    // ensure that there was at least one lead with a twitter username before proceeding.
			    if(usernames.size() > 0) {
			       try { // handles sending the usernames to klout and putting the responses in a list.
			           Klout klout = new Klout();
			           klout.isTestOne = isTest;
			    	   userResponseList = klout.getKlout(usernames, 'show');
			       } catch(KloutResponse.KloutException e) {
			    	   System.debug(e);
			       }
			       
			       // loop through all the responses 
			       for(KloutResponse user : userResponseList) {
			       	   if(usernameToLeadMap.get(user.getUsername()) != null) {      // to prevent a null error, ensure the username exists as a key in the map.
			       	      Lead l = usernameToLeadMap.get(user.getUsername());       // use the map to get the lead from the username, then assign it to a new lead. 
			       	      l.klout_score__c = user.getKscore();                      // assign the klout score (from the response) to the corresponding lead field.
			       	      l.Klout_Amplification_Score__c = user.getAmpScore();
			       	      l.Klout_Class__c = user.getKClass();
			       	      l.Klout_Class_Description__c = user.getKClassDesc();
			       	      l.Klout_Delta_1_Day__c = user.getDelta_1day();
			       	      l.Klout_Delta_5_Day__c = user.getDelta_5day();
			       	      l.Klout_Network_Score__c = user.getNetworkScore();
			       	      l.Klout_Score_Description__c = user.getKScoreDesc();
			       	      l.Klout_Slope__c = user.getSlope();
			       	      l.Klout_True_Reach__c = user.getTrueReach();
			       	      l.Klout_Twitter_Id__c = user.getTwitterId();
			       	      l.Klout_Most_Discussed_Topics__c = user.getTopics();
			       	      l.Klout_Influenced_By__c = user.getInfluencers();
			       	      l.Klout_Influencer_Of__c = user.getInfluencees();
			       	      leadsToUpdate.add(l);
			       	      usernameToLeadMap.remove(user.getUsername());                                    // add the lead to the list for updating.
			       	   }
			       }        	   
                }
                update leadsToUpdate;
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