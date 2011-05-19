/****************************************************************************************
* Author: Clint Lee @ The Flywheel Group
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 
* 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/
* licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, 
* Suite 900, Mountain View, California, 94041, USA.
*
****************************************************************************************/

public with sharing class Klout_UpdateKloutButtonController {
	   public String param;
	   public Boolean success { get; private set; }
	   public static Boolean isTest = false;
	   
	   /*********************************************************************
	   * Constructor
	   *********************************************************************/
	   
	   public Klout_UpdateKloutButtonController() { }
	   
	   /*********************************************************************
	   * Methods
	   *********************************************************************/
	   
	   // @params:  None
	   // @returns: PageReference
	   // @summary: Queries the lead using the page's id parameter.  Calls the instance 
	   //           method callKlout() and then returns the user to the Lead's detail record. 
	   public PageReference init() {
	   	      param = ApexPages.currentPage().getParameters().get('id');
	   	      callKlout(param);
	   	      PageReference page = new PageReference('/' + param);
		      return page;
	   }
	   
	   // @params:  Id from the lead.
	   // @returns: Void
	   // @summary: Creates a Set<Id> with one id to pass to the futureKloutCall() method.
	   private static void callKlout(String objId) {
	   	       Set<Id> idSet = new Set<Id>{ objId };
	   	       if(objId.startsWith('00Q')) {
	   	       	  try {
	   	       	  	  if(isTest)
	   	       	  	     Klout_LeadManager.setIsTest(true);
	   	              Klout_LeadManager.kloutCall(idSet);
	   	          } catch(System.Exception e) {
	   	       	      System.debug(e);
	   	          }	   	      
	   	       } else if(objId.startsWith('003')) {
	   	       	  try {
	   	       	  	  System.debug(isTest);
	   	       	  	  if(isTest)
	   	       	  	     Klout_ContactManager.setIsTest(true);
	   	       	   	  Klout_ContactManager.kloutCall(idSet);
	   	       	  } catch(System.Exception e) {
	   	       	      System.debug(e);
	   	       	  }
	   	       } 
	   }
	   
	   // @params:  Boolean
	   // @returns: Void
	   // @summary: Setter for the isTest variable.
	   public void setIsTest(Boolean test) {
	   	      isTest = test;
	   }
}