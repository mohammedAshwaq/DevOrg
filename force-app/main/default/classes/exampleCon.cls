public class exampleCon {
    String uname;

    public String getUsername() {
        return uname;
    }
            
    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }
            
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
            
    public PageReference methodOne() {
        return null;
    }
    
    
    
    
    //action pollar
    Integer count = 0;
            
    public PageReference incrementCounter() {
        count++;
        return null;
    }
            
    public Integer getCount() {
        return count;
    }
            
    private String state = 'no';
}