/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

public with sharing class KloutResponse  {
       private xmldom.Element result;
       private String username;
       private Decimal kscore;
       
       /*********************************************************************
       * Constructor
       *********************************************************************/
       
       // @params:  An xmldom Element.
       // @summary: Assigns the xmldom Element to the local xmldom Element 
       //           variable.
       public KloutResponse(xmldom.Element element) {
       	      this.result = element;
       }
       
       /*********************************************************************
       * Methods used to determine the API call-type for this response. 
       * For example, does the data in this response pertain to the 'klout',
       * 'show', 'topics', 'influenced_by', or 'influener_of' API call?
       *********************************************************************/
       
       // @returns: A boolean value.
       // @summary: Returns true only if Klout User Object data is stored in this response.
       public Boolean hasUser() {
       	      if(getTwitterId() != null)
       	          return true;
       	      else 
       	          return false;
       }
       
       // @returns: A boolean value.
       // @summary: Returns true only if Klout Topics data is stored in this response.
       public Boolean hasTopics() {
       	      if(getTopics() != null) 
       	      	  return true;
       	      else
       	          return false;
       }
       
       // @returns: A boolean value.
       // @summary: Returns true only if Klout Influencer data is stored in this response.
       public Boolean hasInfluencers() {
       	      if(getInfluencers() != null) 
       	      	  return true;
       	      else 
       	          return false;
       }
       
       // @returns: A boolean value.
       // @summary: Returns true only if Influencee data is stored in this response.
       public Boolean hasInfluencees() {
       	      if(getInfluencees() != null) 
       	          return true;
       	      else 
       	          return false;
       }
       
       
       /*********************************************************************
       * Methods used for retrieving Klout variables.
       *********************************************************************/
       
       // @returns: String
       // @summary: Returns the twitter username for this User.
       public String getUsername() {
       	      if(result.getElementByTagName('twitter_screen_name') != null) {
       	      	 return result.getElementByTagName('twitter_screen_name').nodeValue;
       	      } else {
       	      	 System.debug('NULL USERNAME');
       	      	 return null;
       	      }
       }
       
       // @returns: Decimal Number
       // @summary: Returns the Klout Score for the User associated with this response.
       public Decimal getKscore() {
       	      if(result.getElementByTagName('kscore') != null) {
       	      	 return Decimal.valueOf(result.getElementByTagName('kscore').nodeValue);
       	      } else {
       	      	 System.debug('NULL KLOUT SCORE');
       	      	 return null;
       	      }
       }
       
       // @returns: Decimal Number
       // @summary: Returns the Amplification Score for the User associated with this response.
       public Decimal getAmpScore() {
   	          if(result.getElementByTagName('amplification_score') != null) {
   	      	     return Decimal.valueOf(result.getElementByTagName('amplification_score').nodeValue);
   	          } else {
   	      	     System.debug('NULL AMP SCORE');
   	      	     return null;
   	          }
       }
       
       // @returns: Decimal Number
       // @summary: Returns the 1-day change in this User's Klout Score.
       public Decimal getDelta_1day() {
   	          if(result.getElementByTagName('delta_1day') != null) {
   	      	      return Decimal.valueOf(result.getElementByTagName('delta_1day').nodeValue);
   	          } else {
   	      	      System.debug('NULL DELTA 1 VALUE');
   	      	      return null;
   	          }
       }
   
       // @returns: Decimal Number
       // @summary: Returns the 5-day change in this User's Klout Score.
       public Decimal getDelta_5day() {
   	          if(result.getElementByTagName('delta_5day') != null) {
   	    	      return Decimal.valueOf(result.getElementByTagName('delta_5day').nodeValue);
   	          } else {
   	      	      System.debug('NULL DELTA 5 VALUE');
   	      	      return null;
   	          }
       }
   
       // @returns: Decimal Number
       // @summary: Returns the Network Score for the User associated with this response.
   	   public Decimal getNetworkScore() {
   	          if(result.getElementByTagName('network_score') != null) {
        	      return Decimal.valueOf(result.getElementByTagName('network_score').nodeValue);
   	          } else {
   	      	      System.debug('NULL NETWORK SCORE');
   	      	      return null;
   	          }
       }
   
       // @returns: Decimal Number
       // @summary: Returns the slope of the line representing the Klout score over time.
       public Decimal getSlope() {
   	          if(result.getElementByTagName('slope') != null) {
   	    	      return Decimal.valueOf(result.getElementByTagName('slope').nodeValue);
   	          } else {
   	      	      System.debug('NULL SLOPE');
   	      	      return null;
   	          }
       }
   
       // @returns: Decimal Number
       // @summary: Returns Klout's True Reach for the User associated with this response.
       public Decimal getTrueReach() {
   	          if(result.getElementByTagName('true_reach') != null) {
   	    	      return Decimal.valueOf(result.getElementByTagName('true_reach').nodeValue);
   	          } else {
   	      	      System.debug('NULL TRUE REACH');
   	      	      return null;
   	          }
       }
       
       // @returns: String
       // @summary: Returns the name of the Klout Score Class for the User associated with this response (i.e. Explorer, etc.).
       public String getKClass() {
   	          if(result.getElementByTagName('kclass') != null) {
   	   	          return result.getElementByTagName('kclass').nodeValue;
   	          } else {
   	      	      System.debug('NULL KCLASS');
   	      	      return null;
   	          }
       }
   
       // @returns: String
       // @summary: Returns the description of the Klout Score Class for the User associated with this response.
       public String getKClassDesc() {
   	          if(result.getElementByTagName('kclass_description') != null) {
   	   	          return result.getElementByTagName('kclass_description').nodeValue;
   	          } else {
   	      	      System.debug('NULL KCLASS DESCRIPTION');
   	      	      return null;
   	          }
       }
   
       // @returns: String
       // @summary: Returns a description of the Klout Score for the User associated with this response.
       public String getKScoreDesc() {
   	          if(result.getElementByTagName('kscore_description') != null) {
   	      	      return result.getElementByTagName('kscore_description').nodeValue;
   	          } else {
   	      	      System.debug('NULL KSCORE DESCRIPTION');
   	      	      return null;
   	      	  }
       }
   
       // @returns: String
       // @summary: Returns the TwitterId for the User associated with this response.
       public String getTwitterId() {
   	          if(result.getElementByTagName('twitter_id') != null) {
   	      	      return result.getElementByTagName('twitter_id').nodeValue;
   	          } else {
   	      	      System.debug('NULL TWITTER ID');
   	      	      return null;
   	          }
       }	         
       
       // @returns: String
       // @summary: Returns this User's top 3 twitter topics as one comma-delimited String.
       public String getTopics() {
       	      String topics = '';
       	      if(result.getElementsByTagName('topic').size() != 0) {
       	      	 List<xmldom.Element> topicList = result.getElementsByTagName('topic');
       	      	 for(xmldom.Element topic : topicList) {
       	      	 	 topics += ', ' + topic.nodeValue;
       	      	 }
       	      	 return topics.substring(1);
       	      } else {
       	      	 return null;
       	      }
       }
       
       // @returns: String
       // @summary: Returns a comma-delimited string containing this User's top twitter influencers.
       public String getInfluencers() {
       	      String influencers = '';
       	      if(result.getElementByTagName('influencers') != null) {
       	      	  if(result.getElementByTagName('influencers').hasChildNodes()) {
       	      	     List<xmldom.Element> influencerList = result.getElementByTagName('influencers').getElementsByTagName('twitter_screen_name');
       	      	     for(xmldom.Element influencer : influencerList) {
       	      	  	     influencers += ', ' + influencer.nodeValue;
       	      	     }
       	      	     return influencers.substring(1);
       	      	  } else {
       	      	  	 return null;
       	      	  }
       	      } else {
       	      	  return null;
       	      }
       }
       
       // @returns: String
       // @summary: Returns a comma-delimited string of the twitter users that are most influenced by this User.
       public String getInfluencees() {
       	      String influencees = '';
       	      if(result.getElementByTagName('influencees') != null) {
       	      	  if(result.getElementByTagName('influencees').hasChildNodes()) {
       	      	     List<xmldom.Element> influenceeList = result.getElementByTagName('influencees').getElementsByTagName('twitter_screen_name');
       	      	     for(xmldom.Element influencee : influenceeList) {
       	      	  	      influencees += ', ' + influencee.nodeValue;
       	      	     }
       	      	     return influencees.substring(1);
       	      	  } else {
       	      	  	 return null;
       	      	  }
       	      } else {
       	      	  return null;
       	      }
       }
             
       // Class used for customizing exception messages.
       public class KloutException extends Exception { }
}