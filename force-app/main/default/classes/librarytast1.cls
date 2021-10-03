public with sharing class librarytast1 {

    public string str {get;set;}
    public List<Book_Library__c > bk {get;set;}
    public string bk1 {get;set;}
    public Book_Library__c b1 {get;set;}
    public boolean flag {get;set;}
    
   
    
    public librarytast1(ApexPages.StandardController controller) {
            b1= (Book_Library__c)Controller.getRecord();
    
    
    
       
    }
    
//Search criteria using string  ***important***  
public void search(){
   bk = new list<Book_Library__c>();
  
   //this is syntax for dispalaying matching search result in first and last name
   String str1= '%'+str+'%';
   
   //this is syntax for dispalaying matching search result in only last name
   //String str1 = str+'%';
   
    bk = [select id , name,Discount__c,Description__c,category__c,Price__c from Book_Library__c where name Like:str1];
    
    //searching through only STRING.....same as above
    //bk = database.query('select id , name,Discount__c,Description__c,category__c,Price__c from Book_Library__c where name Like  \''+str1+'\'');
    
    //searching with complete name
    //bk = [select id , name,Discount__c,Description__c,category__c,Price__c from Book_Library__c where name =: str];
    
    if(bk.size()==0){
    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, +str1+'- Book does not exist'));
    }
}

 
 public void newrecord(){
     flag = true;
 
 
 }
}