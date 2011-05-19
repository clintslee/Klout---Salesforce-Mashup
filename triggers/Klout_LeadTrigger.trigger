trigger Klout_LeadTrigger on Lead (after insert) {
	    Klout_Setup__c setup = Klout_Setup__c.getOrgDefaults();
	
	    if(setup.Enable_Lead_Trigger__c) {
	       Klout_LeadManager.handleNewLeadsAfterInsert(Trigger.New);
	    }
}