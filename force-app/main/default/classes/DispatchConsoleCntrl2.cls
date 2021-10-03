public class DispatchConsoleCntrl2{

    public DispatchConsoleCntrl2() {
        Date confirmedDate = Date.newInstance(1983, 10, 11);
        
        Date toCheck;
        toCheck = Date.parse('10/11/1983');
        System.assertEquals(confirmedDate, toCheck);
        
        toCheck = Date.valueOf('1983-10-11');
        System.assertEquals(confirmedDate, toCheck);
        
        
        string s = '"2013-08-20T05:06:44.160Z"';
        Datetime dt = (DateTime)JSON.deserialize(s,DateTime.class);
        system.debug('datetime'+dt);
        
        try {
          // throws System.TypeException: Invalid date: 1983-10-11
          toCheck = Date.parse('1983-10-11');
          system.debug('******************'+toCheck);
          System.assert(false);
          
        }
        catch (TypeException e) {
          // observed
        }
        
        try {
          // throws System.TypeException: Invalid date: 10/11/1983
          toCheck = Date.valueOf('10/11/1983');
          system.debug('---------------------'+toCheck);
          System.assert(false);
        }
        catch (TypeException e) {
          // observed
        }
    }
}