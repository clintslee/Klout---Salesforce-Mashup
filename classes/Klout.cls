/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

public with sharing class Klout {
       public Boolean isTestOne = false;
       public Boolean isTestTwo = false;
       public KloutResponse kloutResponse;
       private String API_KEY;
       private String URI;
       private String RESPONSE_FORMAT;
       private HTTPRequest request;
       private HTTPResponse response;       
       
       /*********************************************************************
       * Constructors
       *********************************************************************/
       
       // @params:  A boolean value.
       // @summary: Used when testing to set the isTest variable to true. Necessary since this
       //           class involves callouts.
       public Klout() {
       	      Klout_Setup__c kloutSettings = Klout_Setup__c.getOrgDefaults();
       	      API_KEY = kloutSettings.API_KEY__c;
       	      URI = kloutSettings.URI__c;
       	      RESPONSE_FORMAT = kloutSettings.RESPONSE_FORMAT__c;
       }
       
       
       /*********************************************************************
       * Public methods used by clients to make calls to the Klout API.
       *********************************************************************/
       
       // method for calling Klout with multiple usernames
       public List<KloutResponse> getKlout(List<String> usernames, String method) {
       	      String nameList = makeNameList(usernames);
       	      String path = '';
       	      if(method.equals('show') || method.equals('topics'))
       	          path = 'users/';
       	      if(method.equals('influencer_of') || method.equals('influenced_by'))
       	          path = 'soi/';
       	      if(method.equalsIgnoreCase('klout') || method.equalsIgnoreCase('show') || method.equalsIgnoreCase('topics') || method.equalsIgnoreCase('influencer_of') || method.equalsIgnoreCase('influenced_by'))  {
       	          String endpoint = URI + path + method + '.' + RESPONSE_FORMAT + '?key=' + API_KEY + '&users=' + nameList;
       	          request = buildKloutRequest(endpoint);
       	          System.debug(isTestOne);
       	          System.debug(isTestTwo);
       	          if(!isTestOne && !isTestTwo) {
       	             response = callKlout(request);
       	          } else if(isTestOne && !isTestTwo){ // for testing
       	      	     response = new HTTPResponse();
       	      	     response.setStatus('OK');
       	      	     response.setStatusCode(200);
       	      	     response.setBody('<?xml version="1.0" encoding="UTF-8"?><users><user><twitter_id>15007218</twitter_id><twitter_screen_name>clintslee</twitter_screen_name>' +
       	      	                      '<score><kscore>35.5</kscore><slope>100</slope><description> is effectively using social media to influence their network across a variety of topics.</description>' + 
       	      	                      '<kclass_id>4</kclass_id><kclass>Explorer</kclass><kclass_description>You actively engage in the social web, constantly trying out new ways to interact and network.</kclass_description>' + 
       	      	                      '<kscore_description/><network_score>100</network_score><amplification_score>100</amplification_score><true_reach>100</true_reach><delta_1day>100</delta_1day><delta_5day>100</delta_5day></score>' + 
       	      	                      '<topics><topic>SFDC</topic><topic>San Francisco</topic></topics><influencers><twitter_screen_name>forcedotcom</twitter_screen_name></influencers><influencees><twitter_screen_name>everybody</twitter_screen_name>' + 
       	      	                      '</influencees></user></users>');
       	          } else {
       	          	 response = new HTTPResponse();
       	      	     response.setStatus('OK');
       	      	     response.setStatusCode(200);
       	      	     response.setBody('<?xml version="1.0" encoding="UTF-8"?><users><user></user></users>');
       	          }
       	          List<KloutResponse> kResponses = handleKloutResponse(response);
       	          return kResponses;
       	      } else {
       	          throw new KloutResponse.KloutException();
       	      }       	      
       }
       
       // overloaded method for calling Klout with a single username
       public KloutResponse getKlout(String username, String method) {
       	      if(method.equalsIgnoreCase('klout') || method.equalsIgnoreCase('show') || method.equalsIgnoreCase('topics') || method.equalsIgnoreCase('influencer_of') || method.equalsIgnoreCase('influenced_by'))  {
       	         List<String> usernames = new List<String>();
       	         usernames.add(username);
       	         List<KloutResponse> kResponses = this.getKlout(usernames, method);
       	         return kResponses[0];
       	      } else {
       	      	 throw new KloutResponse.KloutException();
       	      }
       }
       
       
       /*********************************************************************
       * Private helper methods used by the getKlout() methods above.
       *********************************************************************/
       
       // @params:  A String that identifies the endpoint to use
       // @returns: An HTTPRequest
       // @summary: Constructs the HTTPRequest used in making the call to the Klout API. 
       private HTTPRequest buildKloutRequest(String endpoint) {
       	       HTTPRequest req = new HTTPRequest();
       	       req.setEndpoint(endpoint);
       	       req.setMethod('GET');
       	       return req;
       	
       }
       
       // @params:  The HTTPRequest object constructed in the above method.
       // @returns: An HTTPResponse
       // @summary: Makes an HTTP obj and sends the request, then returns its response.
       private HTTPResponse callKlout(HTTPRequest request) {
       	       try {
       	           HTTP http = new HTTP();
       	           HTTPResponse response = http.send(request);
       	           return response;
       	       } catch(System.Exception e) {
       	       	   throw new KloutResponse.KloutException('ERROR SENDING HTTP REQUEST.  ERROR: ' + e ); 
               }
       }
       
       // @params:  The HTTPResponse returned from the method above.
       // @returns: A list of KloutResponse objects.
       // @summary: Gets all of the User info that's returned in the response, then puts the info 
       //           for each User into a separate KloutResponse object. Returns the list of KloutResponse
       //           objects. 
       private List<KloutResponse> handleKloutResponse(HTTPResponse res) {
       	       List<KloutResponse> kResponseList = new List<KloutResponse>();
       	       response = res;
       	       XMLDom xmlResponse = new XMLDom(response.getBody());
       	       List<xmlDom.Element> users = xmlResponse.getElementsByTagName('user');
       	       if(response.getStatusCode() != 200) {
			      throw new KloutResponse.KloutException('ERROR IN HTTP RESPONSE. STATUS = ' + response.getStatus() + '//.' + '  Status Code = ' + response.getStatusCode());
		       }
		       for(xmlDom.Element user : users) {
		       	   KloutResponse kResponse = new KloutResponse(user);
		       	   kResponseList.add(kResponse);
		       }
		      return kResponseList;
       }
       
       // @params:  A list of Strings, each one being a twitter username
       // @returns: A single String.
       // @summary: Taks a List<String> passed in by the client and turns it into a single string where each
       //           username is separated by a comma. This is how multiple usernames are sent to the Klout API.
       private String makeNameList(List<String> usernames) {
       	       String nameList = '';
       	       for(String s : usernames) {
       	       	   nameList += ',' + s;
       	       }
       	       return nameList.substring(1);
       }
}