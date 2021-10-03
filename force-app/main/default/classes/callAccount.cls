/*  
   The urlMapping acts as an accessible endpoint and adds to the full URL used to call this webservice from an external point  
   For example, something like "https://ap1.salesforce.com/services/apexrest/Account"  
 */  
 @RestResource(urlMapping='/Account/*')  
 global with sharing class callAccount {  
  /*  
   HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.  
   Used to retrieve data coming in the request body and performing corressponding actions  
  */  
  @HttpPost  
   global static String doPost() {  
     /*  
       RestContext Class - Allows us to access the RestRequest and RestResponse objects in your Apex REST methods.   
       RestRequest class - Allows us to pass request data into our Apex RESTful Web service method.  
       RestResponse class - Allows us to pass or send back response data from our Apex RESTful web service method  
     */  
     //Returns the RestRequest object for our Apex REST method.  
     RestRequest request = RestContext.request;  
     //Returns the RestResponse for our Apex REST method.  
     RestResponse response = RestContext.response;  
     //Access the request body with input data coming in the JSON format  
     String jSONRequestBody=request.requestBody.toString().trim();  
     //Deserializes the input JSON string into an Account object  
     Account accObj = (Account)JSON.deserializeStrict(jSONRequestBody,Account.class);  
     //insert the account object and return the account ID   
     insert accObj;  
     return accObj.Id;  
   }  
   /*  
   HttpGet method is used to capture a HttpGet request has been sent to our rest apex class.  
   Used to request data on the basis of a parameter sent in the URL  
  */  
  @HttpGet  
   global static Account doGet() {  
   /*  
       RestContext Class - Allows us to access the RestRequest and RestResponse objects in your Apex REST methods.   
       RestRequest class - Allows us to pass request data into our Apex RESTful Web service method.  
       RestReponse class - Allows us to pass or send back response data from our Apex RESTful web service method  
     */  
     //Returns the RestRequest object for our Apex REST method.  
     RestRequest request = RestContext.request;  
     //Returns the RestResponse for our Apex REST method.  
     RestResponse response = RestContext.response;  
     //Retrieve the parameter sent in the URL  
     String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);  
     //query the account on the basis of id sent and return the record  
     Account acc= [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];  
     return acc;  
   }  
 }