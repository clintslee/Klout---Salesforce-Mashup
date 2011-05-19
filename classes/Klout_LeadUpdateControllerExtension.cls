public with sharing class Klout_LeadUpdateControllerExtension {
	   public Lead lead {get; set;}
	   public Boolean success { get; private set; }
	   
	   public Klout_LeadUpdateControllerExtension(ApexPages.StandardController stdController) {
              this.lead = (Lead)stdController.getRecord();
              callKlout();
       }
       
       public PageReference callKlout() {
       	      lead = [select twitter_username__c from lead where id= : lead.id];
       	      if(lead.Twitter_Username__c != null) {
       	         Set<Id> leadId = new Set<Id>{ lead.id };
       	         try {
       	             Klout_LeadManager.futureKloutCall(leadId);
       	             success = true;
       	             return null;
       	         } catch(System.Exception e) {
       	         	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Whoops! There was an error. ' + e));
       	         	 return null;
       	         }
       	         
       	         return null;
       	      } else {
       	      	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This lead does not have a Twiter username.'));
       	      	 return null;
       	      }
       }

}