@isTest
private class TEST_Klout_UpdateKloutButtonController {

    static testMethod void positiveUpdateContactTest() {
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
    	   contact.Twitter_Username__c = 'clintslee';
    	   insert contact;
    	   
           PageReference pageRef = Page.Klout_UpdateKloutButtonPage;
           Test.setCurrentPage(pageRef);           
           pageRef.getParameters().put('id', contact.id);
           
           Klout_UpdateKloutButtonController controller = new Klout_UpdateKloutButtonController();
           controller.setIsTest(true);
           controller.init();
           
           // Assert that the user is returned to the contact's detail page.
           PageReference nextPage = new PageReference('/' + contact.id);
           
           // query the Klout fields that get updpated when the init() method above is called.
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
          
          // Assert that all of the lead's fields were updated correctly.          
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
    
    static testMethod void positiveUpdateLeadTest() {
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
    	   lead.firstName = 'joe';
    	   lead.lastName = 'testerson';
    	   lead.email = 'joetesterson@gooogle.com';
    	   lead.Twitter_Username__c = 'clintslee';
    	   lead.company = 'NA';
    	   insert lead;
    	   
    	   PageReference pageRef = Page.Klout_UpdateKloutButtonPage;
           Test.setCurrentPage(pageRef);           
           pageRef.getParameters().put('id', lead.id);
           
           Klout_UpdateKloutButtonController controller = new Klout_UpdateKloutButtonController();
           controller.setIsTest(true);
           controller.init();
           
           // Assert that the user is returned to the lead's detail page.
           PageReference nextPage = new PageReference('/' + lead.id);
           
           // query the Klout fields that get updpated when the init() method above is called.
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
          
          // Assert that all of the lead's fields were updated correctly.         
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