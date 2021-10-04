@RestResource(urlMapping='/Accounts/')
global class AccountSynctoAnotherOrg{
    @httpGet
    global static account getAccoutDetails(){
        //test 2nd commit
        //test 3rd comment
        restrequest  restRe = restContext.request;
        String accNumber = restRe.requestURI.Substring(restRe.requestURI.lastIndexOf('/')+1);
        List<Account> lstAcc= [select id, name from account where AccountNumber =:accNumber];
        if(!lstAcc.isEmpty()){ 
            return lstAcc[0];
        }
        return null;
        
        
    }
    @httpPost
    global static String saveaccountdetails(){
        restrequest  restReq = restContext.request;
        blob jasonAccount = restReq.requestBody;
        Account acc = (Account)JSON.deserialize(jasonAccount.toString(), Account.class);
        try{
            if(acc!=null){
                insert acc;
            }
        }
        catch (exception ex){
           // return ex.message();
        }
        return acc.id;
    }
    
}