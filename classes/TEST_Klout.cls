@isTest
private class TEST_Klout {

    static testMethod void testKloutScore() {  
    	
    	List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	if(setupList.size() == 0) {
    	   Klout_Setup__c setup = new Klout_Setup__c();
    	   setup.SetupOwnerId = UserInfo.getOrganizationId();
    	   setup.API_KEY__c = '12345678';
    	   setup.RESPONSE_FORMAT__c = 'XML';
    	   setup.URI__c = 'http://api.klout.com';
           insert setup;
    	}
           	  	
    	Klout klout = new Klout();
    	klout.isTestOne = true;
    	KloutResponse kResponse = klout.getKlout('clintslee', 'klout');
    	
    	System.assertEquals(kResponse.getUsername(), 'clintslee');
    	System.assertEquals(kResponse.getKScore(), 35.5);
   }
   
   static testMethod void testKloutUser() {
   	      List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	  if(setupList.size() == 0) {
    	     Klout_Setup__c setup = new Klout_Setup__c();
    	     setup.SetupOwnerId = UserInfo.getOrganizationId();
    	     setup.API_KEY__c = '12345678';
    	     setup.RESPONSE_FORMAT__c = 'XML';
    	     setup.URI__c = 'http://api.klout.com';
             insert setup;
    	  }
   	      
   	      Klout klout = new Klout();
   	      klout.isTestOne = true;
   	      KloutResponse kResponse = klout.getKlout('clintslee', 'show');
   	      
   	      System.assertEquals(kResponse.hasUser(), true);
   	      System.assertEquals(kResponse.getAmpScore(), 100);
   	      System.assertEquals(kResponse.getDelta_1day(), 100);
   	      System.assertEquals(kResponse.getDelta_5day(), 100 );
   	      System.assertEquals(kResponse.getNetworkScore(), 100);
   	      System.assertEquals(kResponse.getSlope(), 100);
   	      System.assertEquals(kResponse.getTrueReach(), 100);
   	      System.assertEquals(kResponse.getKClass(), 'Explorer');
   	      System.assertEquals(kResponse.getKClassDesc(),'You actively engage in the social web, constantly trying out new ways to interact and network.');
   	      System.assertEquals(kResponse.getKScoreDesc(), '');
   	      System.assertEquals(kResponse.getTwitterId(), '15007218');
   	      System.assertEquals(kResponse.getTopics(), ' SFDC, San Francisco');
   	      System.assertEquals(kResponse.getInfluencers(), ' forcedotcom');
   	      System.assertEquals(kResponse.getInfluencees(), ' everybody');
   	      System.assertEquals(kResponse.hasTopics(), true);
   	      System.assertEquals(kResponse.hasInfluencers(), true);
   	      System.assertEquals(kResponse.hasInfluencees(), true);
   }
   
   static testMethod void testKloutNoUser() {
   	      List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	  if(setupList.size() == 0) {
    	     Klout_Setup__c setup = new Klout_Setup__c();
    	     setup.SetupOwnerId = UserInfo.getOrganizationId();
    	     setup.API_KEY__c = '12345678';
    	     setup.RESPONSE_FORMAT__c = 'XML';
    	     setup.URI__c = 'http://api.klout.com';
             insert setup;
    	  }
   	      
   	      Klout klout = new Klout();
   	      klout.isTestTwo = true;
   	      KloutResponse kResponse = klout.getKlout('clintslee', 'show');
   	      	  
   	      System.assertEquals(kResponse.hasUser(), false);
   	      System.assertEquals(kResponse.hasTopics(), false);
   	      System.assertEquals(kResponse.hasInfluencers(), false);
   	      System.assertEquals(kResponse.hasInfluencees(), false);
   	      System.assertEquals(kResponse.getAmpScore(), null);
   	      System.assertEquals(kResponse.getDelta_1day(), null);
   	      System.assertEquals(kResponse.getDelta_5day(), null);
   	      System.assertEquals(kResponse.getNetworkScore(), null);
   	      System.assertEquals(kResponse.getSlope(), null);
   	      System.assertEquals(kResponse.getTrueReach(), null);
   	      System.assertEquals(kResponse.getKClass(), null);
   	      System.assertEquals(kResponse.getKClassDesc(), null);
   	      System.assertEquals(kResponse.getKScoreDesc(), null);
   	      System.assertEquals(kResponse.getTwitterId(), null);
   	      System.assertEquals(kResponse.getTopics(), null);
   	      System.assertEquals(kResponse.getInfluencers(), null);
   	      System.assertEquals(kResponse.getInfluencees(), null);
   	      System.assertEquals(kResponse.getUsername(), null);
   	      System.assertEquals(kResponse.getkScore(), null);
   }
   
   
}