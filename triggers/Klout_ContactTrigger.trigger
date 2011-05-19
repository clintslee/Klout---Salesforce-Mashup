trigger Klout_ContactTrigger on Contact (after insert) {
	    Klout_Setup__c setup = Klout_Setup__c.getOrgDefaults();
	    
	    if(setup.Enable_Contact_Trigger__c) {
	        Klout_ContactManager.handleNewContactsAfterInsert(Trigger.New);
	    }

}