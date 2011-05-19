@isTest
private class TEST_Klout_ContactManager {

    static testMethod void testKloutCall() {
    	   List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	   if(setupList.size() == 0) {
    	      Klout_Setup__c setup = new Klout_Setup__c();
    	      setup.SetupOwnerId = UserInfo.getOrganizationId();
    	      setup.API_KEY__c = '12345678';
    	      setup.RESPONSE_FORMAT__c = 'XML';
    	      setup.URI__c = 'http://api.klout.com';
    	      setup.Enable_Contact_Trigger__c = true;
              insert setup;
    	   }
    	   
    	   Account acct = new Account();
    	   acct.name = 'Acme, Inc.';
    	   insert acct;
    	   
    	   Contact contact = new Contact();
    	   contact.accountId = acct.id;
    	   contact.firstName = 'Joe';
    	   contact.lastName = 'Testerson';
    	   contact.email = 'joetesterson@gooogle.com';
    	   contact.twitter_username__c = 'clintslee';
    	   insert contact;
    	   
    	   Test.startTest();
    	   Set<Id> contIdSet = new Set<Id>{ contact.id };
    	   Klout_ContactManager.setIsTest(true);
    	   Klout_ContactManager.kloutCall(contIdSet);
    	   Test.stopTest();
    	   
    	   contact = 
               [select id
                      , Klout_Score__c                     
					  , Klout_Amplification_Score__c
					  , Klout_Class__c
					  , Klout_Class_Description__c
					  , Klout_Delta_1_Day__c
					  , Klout_Delta_5_Day__c
					  , Klout_Network_Score__c
					  , Klout_Score_Description__c
					  , Klout_Slope__c
					  , Klout_True_Reach__c
					  , Klout_Twitter_Id__c
					  , Klout_Most_Discussed_Topics__c
					  , Klout_Influenced_By__c
					  , Klout_Influencer_Of__c
                 from Contact
                where id =:contact.id];
    	   
    	  System.assertEquals(contact.Klout_Amplification_Score__c , 100);
   	      System.assertEquals(contact.Klout_Delta_1_Day__c, 100);
   	      System.assertEquals(contact.Klout_Delta_5_Day__c, 100 );
   	      System.assertEquals(contact.Klout_Network_Score__c, 100);
   	      System.assertEquals(contact.Klout_Slope__c, 100);
   	      System.assertEquals(contact.Klout_True_Reach__c, 100);
   	      System.assertEquals(contact.Klout_Class__c, 'Explorer');
   	      System.assertEquals(contact.Klout_Class_Description__c,'You actively engage in the social web, constantly trying out new ways to interact and network.');
   	      System.assertEquals(contact.Klout_Score_Description__c, null);
   	      System.assertEquals(contact.Klout_Twitter_Id__c, '15007218');
   	      System.assertEquals(contact.Klout_Most_Discussed_Topics__c, 'SFDC, San Francisco');
   	      System.assertEquals(contact.Klout_Influenced_By__c, 'forcedotcom');
   	      System.assertEquals(contact.Klout_Influencer_Of__c, 'everybody');
    }
    
    static testMethod void testMakeIdSet() {
    	   List<Contact> contList = new List<Contact>();
    	   for(Integer i = 0; i < 5; i++) {
    	   	   Contact c = new Contact();
    	   	   c.FirstName = 'Joe' + i;
    	   	   c.LastName = 'Testerson' + i;
    	   	   c.Email = 'joe' + i + 'testerson@gooogle.com';
    	   	   c.Twitter_Username__c = 'joe' + i;
    	   	   insert c;
    	   	   contList.add(c);
    	   }
    	   
    	   Set<Id> contIdSet = Klout_ContactManager.makeIdSet(contList);
    	   
    	   System.assertEquals(contIdSet.size(), 5);
    }
    
    static testMethod void testFutureKloutCall() {
    	   List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	   if(setupList.size() == 0) {
    	      Klout_Setup__c setup = new Klout_Setup__c();
    	      setup.SetupOwnerId = UserInfo.getOrganizationId();
    	      setup.API_KEY__c = '12345678';
    	      setup.RESPONSE_FORMAT__c = 'XML';
    	      setup.URI__c = 'http://api.klout.com';
              insert setup;
    	   }
    	   
    	   Contact contact = new Contact();
    	   contact.firstName = 'Joe';
    	   contact.lastName = 'Testerson';
    	   contact.email = 'joetesterson@gooogle.com';
    	   contact.twitter_username__c = 'clintslee';
    	   insert contact;
    	   
    	   Test.startTest();
    	   Set<Id> contIdSet = new Set<Id>{ contact.id };
    	   Klout_ContactManager.setIsTest(true);
    	   Klout_ContactManager.futureKloutCall(contIdSet);
    	   Test.stopTest();
    	   
    	   contact = 
               [select id
                      , Klout_Score__c                     
					  , Klout_Amplification_Score__c
					  , Klout_Class__c
					  , Klout_Class_Description__c
					  , Klout_Delta_1_Day__c
					  , Klout_Delta_5_Day__c
					  , Klout_Network_Score__c
					  , Klout_Score_Description__c
					  , Klout_Slope__c
					  , Klout_True_Reach__c
					  , Klout_Twitter_Id__c
					  , Klout_Most_Discussed_Topics__c
					  , Klout_Influenced_By__c
					  , Klout_Influencer_Of__c
                 from Contact
                where id =:contact.id];
    	   
    	  System.assertEquals(contact.Klout_Amplification_Score__c , 100);
   	      System.assertEquals(contact.Klout_Delta_1_Day__c, 100);
   	      System.assertEquals(contact.Klout_Delta_5_Day__c, 100 );
   	      System.assertEquals(contact.Klout_Network_Score__c, 100);
   	      System.assertEquals(contact.Klout_Slope__c, 100);
   	      System.assertEquals(contact.Klout_True_Reach__c, 100);
   	      System.assertEquals(contact.Klout_Class__c, 'Explorer');
   	      System.assertEquals(contact.Klout_Class_Description__c,'You actively engage in the social web, constantly trying out new ways to interact and network.');
   	      System.assertEquals(contact.Klout_Score_Description__c, null);
   	      System.assertEquals(contact.Klout_Twitter_Id__c, '15007218');
   	      System.assertEquals(contact.Klout_Most_Discussed_Topics__c, 'SFDC, San Francisco');
   	      System.assertEquals(contact.Klout_Influenced_By__c, 'forcedotcom');
   	      System.assertEquals(contact.Klout_Influencer_Of__c, 'everybody');
    }
    
    static testMethod void testHandleNewContactsAfterInsert() {
    	   List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	   if(setupList.size() == 0) {
    	      Klout_Setup__c setup = new Klout_Setup__c();
    	      setup.SetupOwnerId = UserInfo.getOrganizationId();
    	      setup.API_KEY__c = '12345678';
    	      setup.RESPONSE_FORMAT__c = 'XML';
    	      setup.URI__c = 'http://api.klout.com';
              insert setup;
    	   }
    	   
    	   Contact contact = new Contact();
    	   contact.firstName = 'Joe';
    	   contact.lastName = 'Testerson';
    	   contact.email = 'joetesterson@gooogle.com';
    	   contact.twitter_username__c = 'clintslee';
    	   insert contact;
    	   
    	   List<Contact> contList = new List<Contact> { contact };
    	   
    	   Test.startTest();
    	   Klout_ContactManager.setIsTest(true);
    	   Klout_ContactManager.handleNewContactsAfterInsert(contList);
    	   Test.stopTest();
    	   
    	   contact = 
               [select id
                      , Klout_Score__c                     
					  , Klout_Amplification_Score__c
					  , Klout_Class__c
					  , Klout_Class_Description__c
					  , Klout_Delta_1_Day__c
					  , Klout_Delta_5_Day__c
					  , Klout_Network_Score__c
					  , Klout_Score_Description__c
					  , Klout_Slope__c
					  , Klout_True_Reach__c
					  , Klout_Twitter_Id__c
					  , Klout_Most_Discussed_Topics__c
					  , Klout_Influenced_By__c
					  , Klout_Influencer_Of__c
                 from Contact
                where id =:contact.id];
    	   
    	  System.assertEquals(contact.Klout_Amplification_Score__c , 100);
   	      System.assertEquals(contact.Klout_Delta_1_Day__c, 100);
   	      System.assertEquals(contact.Klout_Delta_5_Day__c, 100 );
   	      System.assertEquals(contact.Klout_Network_Score__c, 100);
   	      System.assertEquals(contact.Klout_Slope__c, 100);
   	      System.assertEquals(contact.Klout_True_Reach__c, 100);
   	      System.assertEquals(contact.Klout_Class__c, 'Explorer');
   	      System.assertEquals(contact.Klout_Class_Description__c,'You actively engage in the social web, constantly trying out new ways to interact and network.');
   	      System.assertEquals(contact.Klout_Score_Description__c, null);
   	      System.assertEquals(contact.Klout_Twitter_Id__c, '15007218');
   	      System.assertEquals(contact.Klout_Most_Discussed_Topics__c, 'SFDC, San Francisco');
   	      System.assertEquals(contact.Klout_Influenced_By__c, 'forcedotcom');
   	      System.assertEquals(contact.Klout_Influencer_Of__c, 'everybody');
    	   
    }
}