/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

public class Klout_LeadManager {
       
       public static boolean isTest = false;
	
	    /*******************************************************************************************
	    * Trigger Context methods called by lead triggers.
	    *******************************************************************************************/
		// @params:  List of Leads - presumably from Trigger.New
		// @returns: Void
		// @summary: Takes a list of new leads from the trigger, gets their ids, and passes the ids
		//           into the futureKloutCall() method.  This allows the callout to be made from a 
		//           trigger.
		public static void handleNewLeadsAfterInsert(List<Lead> newList)
		{
			Set<Id> idSet = makeIdSet(newList);
			futureKloutCall(idSet);
		}
		
		/********************************************************************************************
		* Static Methods
		********************************************************************************************/
		@future (callout=true)
		public static void futureKloutCall(Set<Id> ids) {
			    kloutCall(ids);
		}
		// @params:  A set of lead ids from the trigger.
		// @returns: Void
		// @summary: Sends twitter usernames to the Klout API, parses the XML response, adds the corresponding Klout score
		//           to each lead, and then updates the leads.
		public static void kloutCall(Set<Id> ids) {
			    Map<String,Lead> usernameToLeadMap = new Map<String,Lead>();
			    List<String> usernames = new List<String>();
			    List<Lead> leadsToUpdate = new List<Lead>();
			    List<KloutResponse> userResponseList = new List<KloutResponse>();
			    List<KloutResponse> topicResponseList = new List<KloutResponse>();
			    List<KloutResponse> influencerResponseList = new List<KloutResponse>();
			    List<KloutResponse> influenceeResponseList = new List<KloutResponse>();
			    
			    
			    // query and loop through all leads passed in from the trigger.  if there is a twitter username
			    // add the username to the list, then add the <username, lead> pair to the map.
			    for(Lead l : [select id, klout_score__c, twitter_username__c from lead where id IN :ids]) {
			    	if(l.twitter_username__c != null) 
			    		usernames.add(l.twitter_username__c);
			    		usernameToLeadMap.put(l.twitter_username__c, l);
			    }
			    
			    // ensure that there was at least one lead with a twitter username before proceeding.
			    if(usernames.size() > 0) {
			       try { // handles sending the usernames to klout and putting the responses in a list.
			           Klout klout = new Klout();
			           if(isTest)
			              klout.isTestOne = isTest;
			    	   userResponseList = klout.getKlout(usernames, 'show');
			    	   topicResponseList = klout.getKlout(usernames, 'topics');
			    	   influencerResponseList = klout.getKlout(usernames, 'influenced_by');
			    	   influenceeResponseList = klout.getKlout(usernames, 'influencer_of');
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
			       	      leadsToUpdate.add(l);                                     // add the lead to the list for updating.
			       	   }
			       }
			       update leadsToUpdate;
			       leadsToUpdate.clear();
			       
			       for(KloutResponse topic : topicResponseList) {
			       	    if(usernameToLeadMap.get(topic.getUsername()) != null) {
			       	    	Lead l = usernameToLeadMap.get(topic.getUsername());
			       	    	l.Klout_Most_Discussed_Topics__c = topic.getTopics();
			       	    	leadsToUpdate.add(l);
			       	    }
			       }
			       update leadsToUpdate;
			       leadsToUpdate.clear();
			       
			       for(KloutResponse influencers : influencerResponseList) {
			       	    if(usernameToLeadMap.get(influencers.getUsername()) != null) {
			       	    	Lead l = usernameToLeadMap.get(influencers.getUsername());
			       	    	l.Klout_Influenced_By__c = influencers.getInfluencers();
			       	    	leadsToUpdate.add(l);
			       	    }
			       }
			       update leadsToUpdate;
			       leadsToUpdate.clear();
			       
			       for(KloutResponse influencees : influenceeResponseList) {
			       	    if(usernameToLeadMap.get(influencees.getUsername()) != null) {
			       	    	Lead l = usernameToLeadMap.get(influencees.getUsername());
			       	    	l.Klout_Influencer_Of__c = influencees.getInfluencees();
			       	    	leadsToUpdate.add(l);
			       	    }
			       }
			       update leadsToUpdate;
			   }
		}
		
		// @params:  A list of Leads.
		// @returns: A Set of Ids.
		// @summary: Loops through the list of leads and adds each one's id to the set if and 
		//           only if the lead has a twitter username.
		public static Set<Id> makeIdSet(List<Lead> leadList) {
			    Set <Id> leadIdSet = new Set <Id>();
			    for(Lead lead : leadList) {
				    if(lead.twitter_username__c != null) 
					   leadIdSet.add(lead.Id);
			    }
			    return leadIdSet;
		}
		
		public static void setIsTest(Boolean test) {
			   isTest = test;
		}
}