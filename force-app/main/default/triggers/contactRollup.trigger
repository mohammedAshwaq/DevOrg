trigger contactRollup on Contact (after insert, after update, after delete, after undelete) {
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete || trigger.isDelete){
        set<id> accIds = new set<id>();
        for(contact con: trigger.new){
            accIds.add(con.accountid);
        }
		list<Account> updateAcc = new List<Account>();        
        if(!accIds.isEmpty()){
            List<Account> listAccount = [select id, name, (select id, name from contacts) ,Contact_Record_Count__c from account where id in: accIds];
            for(Account acc: listAccount){
                Integer conSize =0;
                if(acc.Contacts.size() > 0){
                    conSize = acc.Contacts.size();
                }
                acc.Contact_Record_Count__c = conSize;    
                updateAcc.add(acc);
            }
        }
        if(!updateAcc.isEmpty()){
            update updateAcc;
        }
    }
}