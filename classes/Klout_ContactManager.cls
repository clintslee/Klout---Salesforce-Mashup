/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

public class Klout_ContactManager {
	    public static Boolean isTest = false;
	
	    /********************************************************************************************
	    * Trigger Context methods called by Contact triggers.  
	    ********************************************************************************************/
		
		// @params:  List of Contacts - presumably from Trigger.New
		// @returns: Void
		// @summary: Makes a set of Contact ids from the incoming list and passes them to the 
		//           futureKloutCall() method which handles getting the data from Klout.  
		public static void handleNewContactsAfterInsert(List<Contact> newList) {
			Set<Id> idSet = makeIdSet(newList);
			futureKloutCall(idSet);
		}
		
		// Other methods to be implemented:
		//  * public static void handleNewContactsBeforeInsert() { }
		//  * public static void handleNewContactsBeforeUpdate() { }
		//  * public static void handleNewContactsAfterUpdate() { }
		//  * public static void handleNewContactsBeforeDelete() { }
		
		/********************************************************************************************
		* Methods called directly by the trigger context methods above.
		********************************************************************************************/
		
		// @params:  Set of Ids
		// @returns: Void
		// @summary: Basically just the kloutCall() method wrapped in an @future method.  This allows 
		//           the callouts to be made from a trigger.
		@future (callout=true)
		public static void futureKloutCall(Set<Id> ids) {
			    kloutCall(ids);
		}
				
		/********************************************************************************************
		 * Static Methods.
		 *******************************************************************************************/
		
		// @params:  A set of contact ids from the trigger.
		// @returns: Void
		// @summary: Sends twitter usernames to the Klout API, parses the XML response, adds the corresponding Klout score
		//           to each contact, and then updates the contacts.
		public static void kloutCall(Set<Id> ids) {
			    Map<String,Contact> usernameToContactMap = new Map<String,Contact>();
			    List<String> usernames = new List<String>();
			    List<Contact> contactsToUpdate = new List<Contact>();
			    List<KloutResponse> userResponseList = new List<KloutResponse>();
			    List<KloutResponse> topicResponseList = new List<KloutResponse>();
			    List<KloutResponse> influencerResponseList = new List<KloutResponse>();
			    List<KloutResponse> influenceeResponseList = new List<KloutResponse>();
			    
			    
			    // query and loop through all contacts passed in from the trigger.  if there is a twitter username
			    // add the username to the list, then add the <username, contact> pair to the map.
			    for(Contact c : [select id, twitter_username__c from Contact where id IN :ids]) {
			    	if(c.twitter_username__c != null) 
			    		usernames.add(c.twitter_username__c);
			    		usernameToContactMap.put(c.twitter_username__c, c);
			    }
			    
			    // ensure that there was at least one contact with a twitter username before proceeding.
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
			       	   if(usernameToContactMap.get(user.getUsername()) != null) {      // to prevent a null error, ensure the username exists as a key in the map.
			       	      Contact c = usernameToContactMap.get(user.getUsername());       // use the map to get the contact from the username, then assign it to a new contact. 
			       	      c.klout_score__c = user.getKscore();                      // assign the klout score (from the response) to the corresponding contact field.
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
			       	      contactsToUpdate.add(c);                                     // add the contact to the list for updating.
			       	   }
			       }
			       update contactsToUpdate;
			       contactsToUpdate.clear();
			       
			       for(KloutResponse topic : topicResponseList) {
			       	    if(usernameToContactMap.get(topic.getUsername()) != null) {
			       	    	Contact c = usernameToContactMap.get(topic.getUsername());
			       	    	c.Klout_Most_Discussed_Topics__c = topic.getTopics();
			       	    	contactsToUpdate.add(c);
			       	    }
			       }
			       update contactsToUpdate;
			       contactsToUpdate.clear();
			       
			       for(KloutResponse influencers : influencerResponseList) {
			       	    if(usernameToContactMap.get(influencers.getUsername()) != null) {
			       	    	Contact c = usernameToContactMap.get(influencers.getUsername());
			       	    	c.Klout_Influenced_By__c = influencers.getInfluencers();
			       	    	contactsToUpdate.add(c);
			       	    }
			       }
			       update contactsToUpdate;
			       contactsToUpdate.clear();
			       
			       for(KloutResponse influencees : influenceeResponseList) {
			       	    if(usernameToContactMap.get(influencees.getUsername()) != null) {
			       	    	Contact c = usernameToContactMap.get(influencees.getUsername());
			       	    	c.Klout_Influencer_Of__c = influencees.getInfluencees();
			       	    	contactsToUpdate.add(c);
			       	    }
			       }
			       update contactsToUpdate;
			   }
		}
		
		// @params:  Boolean
		// @returns: Void
		// @summary: Sets the isTest variable.
		public static void setIsTest(Boolean value) {
			   isTest = value;
		}
		
		// @params:  List of Contacts
		// @returns: Set of Ids
		// @summary: Puts the contact's id into a Set for all Contacts who have a Twitter Username.	
		public static Set<Id> makeIdSet(List<Contact> contactList) {
			    Set <Id> contactIdSet = new Set <Id>();
			    for(Contact c : contactList) {
				    if(c.twitter_username__c != null) 
					   contactIdSet.add(c.Id);
			    }
			    return contactIdSet;
		}
}