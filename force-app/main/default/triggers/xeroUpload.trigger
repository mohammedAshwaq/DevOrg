trigger xeroUpload on Account (after insert, after update, before delete) {

    set<id> accid = new set<id>();    
    for(Account acc: trigger.isInsert ? trigger.new : trigger.old){
        accid.add(acc.id);
    }
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        xeroAccountProcess.sendAccounts(accid);
    
    }
    if(trigger.isBefore && trigger.isDelete){
    
    
    }
}