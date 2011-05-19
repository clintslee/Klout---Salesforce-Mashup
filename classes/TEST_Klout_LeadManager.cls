@isTest
private class TEST_Klout_LeadManager {

    static testMethod void testKloutCall() {
    	   List<Klout_Setup__c> setupList = [select id from Klout_Setup__c where setupOwnerId = :UserInfo.getOrganizationId()];
    	   if(setupList.size() == 0) {
    	      Klout_Setup__c setup = new Klout_Setup__c();
    	      setup.SetupOwnerId = UserInfo.getOrganizationId();
    	      setup.API_KEY__c = '12345678';
    	      setup.RESPONSE_FORMAT__c = 'XML';
    	      setup.URI__c = 'http://api.klout.com';
    	      setup.Enable_Lead_Trigger__c = true;
              insert setup;
    	   }
    	   
    	   Lead lead = new Lead();
    	   lead.firstName = 'Joe';
    	   lead.lastName = 'Testerson';
    	   lead.email = 'joetesterson@gooogle.com';
    	   lead.twitter_username__c = 'clintslee';
    	   lead.company = 'NA';
    	   insert lead;
    	   
    	   Test.startTest();
    	   Set<Id> leadIdSet = new Set<Id>{ lead.id };
    	   Klout_LeadManager.setIsTest(true);
    	   Klout_LeadManager.kloutCall(leadIdSet);
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
                where id =:lead.id];
    	   
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
    
    static testMethod void testMakeIdSet() {
    	   List<Lead> leadList = new List<Lead>();
    	   for(Integer i = 0; i < 5; i++) {
    	   	   Lead l = new Lead();
    	   	   l.FirstName = 'Joe' + i;
    	   	   l.LastName = 'Testerson' + i;
    	   	   l.Email = 'joe' + i + 'testerson@gooogle.com';
    	   	   l.Twitter_Username__c = 'joe' + i;
    	   	   l.company = 'NA';
    	   	   insert l;
    	   	   leadList.add(l);
    	   }
    	   
    	   Set<Id> leadIdSet = Klout_LeadManager.makeIdSet(leadList);
    	   
    	   System.assertEquals(leadIdSet.size(), 5);
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
    	   
    	   Lead lead = new Lead();
    	   lead.firstName = 'Joe';
    	   lead.lastName = 'Testerson';
    	   lead.email = 'joetesterson@gooogle.com';
    	   lead.twitter_username__c = 'clintslee';
    	   lead.company = 'NA';
    	   insert lead;
    	   
    	   Test.startTest();
    	   Set<Id> leadIdSet = new Set<Id>{ lead.id };
    	   Klout_LeadManager.setIsTest(true);
    	   Klout_LeadManager.futureKloutCall(leadIdSet);
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
                where id =:lead.id];
    	   
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
    
    static testMethod void testHandleNewLeadsAfterInsert() {
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
    	   lead.twitter_username__c = 'clintslee';
    	   lead.company = 'NA';
    	   insert lead;
    	   
    	   List<Lead> leadList = new List<Lead> { lead };
    	   
    	   Test.startTest();
    	   Klout_LeadManager.setIsTest(true);
    	   Klout_LeadManager.handleNewLeadsAfterInsert(leadList);
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
                where id =:lead.id];
    	   
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
}