public class actionfunction {
    String uname;
    
    public PageReference methodOne() {
        return null;
    }



    public String username { get; set; }

    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }
    
     public String getUsername() {
        return uname;
    }
      
       
   
            
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
            
   
            
    private String state = 'no';
}