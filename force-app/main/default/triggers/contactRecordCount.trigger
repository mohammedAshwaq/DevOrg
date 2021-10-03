trigger contactRecordCount on Contact (after insert, after update, after delete, after undelete) {
    
    List<Id> accIds = new List<Id>();
    if(trigger.isInsert || trigger.isUndelete){        
        for(Contact con: trigger.new ){
            accIds.add(con.AccountId);
        }    
    }
    if(trigger.isdelete){
        for(Contact con: trigger.old){
            accIds.add(con.AccountId);
        }    
    }
    
     List<Account> updAccount = new List<Account>();
     List<Account> accList = [select id , (select AccountId from Contacts), name from Account where id IN:accIds];
        for(Account acc : accList ){
            acc.Contact_Record_Count__c = acc.Contacts.size();
            updAccount.add(acc);
        }
        update updAccount;

}