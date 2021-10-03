trigger toupdatequantity on Book_Request__c (before update){

Book_Request__c bk = trigger.new[0];

Book_Request__c b = trigger.old[0];



if(bk.Status__c == 'returned'){

bk.Quantity__c= bk.Quantity__c- b.Quantity__c;
}
}