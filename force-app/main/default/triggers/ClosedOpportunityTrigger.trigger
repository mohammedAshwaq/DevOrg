trigger ClosedOpportunityTrigger on Opportunity (after Insert, after Update) {
    List<Task> tasktoUpdate = new List<Task>();
    if(trigger.isInsert || trigger.isUpdate){
        for(Opportunity opp: trigger.New){
            if(opp.StageName=='Closed Won'){
                Task newTask = new Task();
                newTask.Subject ='Follow Up Test Task';
                newTask.whatId=opp.Id;
                tasktoUpdate.add(newTask);            
            }
        }
        if(!tasktoUpdate.isEmpty()){
            insert tasktoUpdate;
        }
    }

}