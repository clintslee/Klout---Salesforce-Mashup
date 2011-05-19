@isTest
private class TEST_BATCH_UpdateKlout {

    // @summary: 
    static testMethod void positiveUpdateLeads() {
           List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	   if(setupList.size() == 0) {
    	      Klout_Setup__c setup = new Klout_Setup__c();
    	      setup.SetupOwnerId = UserInfo.getOrganizationId();
    	      setup.API_KEY__c = '12345678';
    	      setup.RESPONSE_FORMAT__c = 'XML';
    	      setup.URI__c = 'http://api.klout.com';
              insert setup;
    	   }
           
           Lead lead = new Lead();
           lead.firstName = 'Joe';
           lead.lastName = 'Testerson';
           lead.email = 'joetesterson@gooogle.com';
           lead.Company = 'NA';
           lead.Twitter_Username__c = 'clintslee';
           insert lead;
           
           Test.startTest();
           BATCH_UpdateKloutForLeads batch = new BATCH_UpdateKloutForLeads();
           batch.query = 'select id, twitter_username__c from Lead where email = \'joetesterson@gooogle.com\'';
           batch.isTest = true;
           batch.sendEmail = true;
           Id batchProcessId = database.executebatch(batch, 5);
           Test.stopTest();
           
           lead = 
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
                     from Lead
                    where id = :lead.id];
          
              System.assertEquals(lead.Klout_Amplification_Score__c , 100);
   	          System.assertEquals(lead.Klout_Delta_1_Day__c, 100);
   	          System.assertEquals(lead.Klout_Delta_5_Day__c, 100 );
   	          System.assertEquals(lead.Klout_Network_Score__c, 100);
   	          System.assertEquals(lead.Klout_Slope__c, 100);
   	          System.assertEquals(lead.Klout_True_Reach__c, 100);
   	          System.assertEquals(lead.Klout_Class__c, 'Explorer');
   	          System.assertEquals(lead.Klout_Class_Description__c,'You actively engage in the social web, constantly trying out new ways to interact and network.');
   	          System.assertEquals(lead.Klout_Score_Description__c, null);
   	          System.assertEquals(lead.Klout_Twitter_Id__c, '15007218');
   	          System.assertEquals(lead.Klout_Most_Discussed_Topics__c, 'SFDC, San Francisco');
   	          System.assertEquals(lead.Klout_Influenced_By__c, 'forcedotcom');
   	          System.assertEquals(lead.Klout_Influencer_Of__c, 'everybody');
    }
    
    static testMethod void positiveUpdateContacts() {
    	   List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	   if(setupList.size() == 0) {
    	      Klout_Setup__c setup = new Klout_Setup__c();
    	      setup.SetupOwnerId = UserInfo.getOrganizationId();
    	      setup.API_KEY__c = '12345678';
    	      setup.RESPONSE_FORMAT__c = 'XML';
    	      setup.URI__c = 'http://api.klout.com';
              insert setup;
    	   }
    	   
    	   Account acct = new Account();
    	   acct.Name = 'Test Acct';
    	   insert acct;
    	   
    	   Contact contact = new Contact();
           contact.firstName = 'Joe';
           contact.lastName = 'Testerson';
           contact.email = 'joetesterson@gooogle.com';
           contact.accountId = acct.id;
           contact.twitter_username__c = 'clintslee';
           insert contact;
           
           Test.startTest();
           BATCH_UpdateKloutForContacts batch = new BATCH_UpdateKloutForContacts();
           batch.query = 'select id, twitter_username__c from Contact where email = \'joetesterson@gooogle.com\'';
           batch.isTest = true;
           batch.sendEmail = true;
           Id batchProcessId = database.executebatch(batch, 5);
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