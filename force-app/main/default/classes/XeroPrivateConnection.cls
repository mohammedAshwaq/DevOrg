global class XeroPrivateConnection {
    private static String timestamp;
    private static String signatureMethod;
    private static String consumerKey;
    private static String oauthVersion;
    private static String oautheToken;    
    private static String xeroUrl;
    private static String urlEncoding;
    static String  Keyy = '' ;
 public static HttpResponse syncXeroSFDC(String reqMethod,String operationName,String xeroCreateXml)
 {
     Http http = new Http();
     HttpRequest req = new Httprequest();
     HttpResponse res = new HttpResponse();
     String finalUrl;
     String host;
     String nonce;
     String str;
     String EncSig;
     Blob sig;
     String signature;
     //map to hold xero credentials parameters.
     map<String, String> parameters = new Map<String, String>();
     //to hold parameter map keys.
     List<String> keys = new List<String>();
     try
     {
       //prearing nonce for Xero
       nonce = String.valueOf(Crypto.getRandomLong());
       // Generate timestamp for current time
       timestamp = String.valueOf(DateTime.now().getTime()/1000);

       //checking the custom setting for Xero Credentials.
         //for(Xero_Details__c xeroSet : [select //id,Xero_Url__c,Private_Key__c,Url_Encoding__c,Oauth_Signature_Method__c,Oauth_Version__c,Oatuh_Token__c,Oauth_Consumer_Key__c from //Xero_Details__c limit 1])
         {
              signatureMethod ='RSA-SHA1';
              oauthVersion = '1.0';
          Keyy = 'MIICXgIBAAKBgQDnJ/a4Ey9HaXgV9vZmtFY0f7lsKjxJAxia+P/jtuWTas/k4gKx';
              Keyy += 'xYzj2mh4DsaCLrVmzfT6EGkUp5DbY7iMgrHhn21t9GGoaxzj+ZxZsnZi9ptTKa19';
              Keyy += 'y1rJTZ3fVxEwR272fflOG/ukJhYxUwb+hoR/zdl6EXnamZZFJvxSnY8o0QIDAQAB';
              Keyy += 'AoGBAJfw1uVsBtnD4+FcMd6Uj0123yTQJkw/sr67CUhfAkyCGyDxxp+foNpsx9qS';
              Keyy += 'q70KgsaOfoaYntmqwzbSN450ogLSeWTvG1smft+iAXMXWBcfSZe/d9iDkp7nrLdr';
              Keyy += 'l5j9nAR3Ukm6tW801enPsyI4BafHjSTZj1A9EBBbmqyae6QBAkEA9sbENfKjF0HQ';
              Keyy += '4GEKc+w7NwLk3aTZnfHQ+n9kuIbZgMsx+HqBsLYYNIYSfxeAxW9bgPMqbC9mtuQ8';
              Keyy += 'jiMEznvbIQJBAO/LvLjPZevVnlGxX21xw3ya34LdFNSwx2QCrzLUJNmaVIdzsPg8';
              Keyy += '2Nc00x68mS3MmzTx7sNxcy6bFhbH1MXWx7ECQQC2tQ9MieqqK3aEyhQ9I6fr4N6m';
              Keyy += 'I4ljYUhCTtO5s02SB99lgv5GYWumZ6WGJ1aV1w6+eErucmHwAye6bL8ASb9BAkBr';
              Keyy += 'jfNo5UVuwRLQy4Dk4vjuo7yKwsS8HUphlj6kyrh4jZtKYd7HiOsto7jp+WevPi2D';
              Keyy += 'Utxn9zPVfKQstZa+4fYRAkEA2QWQeVAi/8qc4AWW3Mzx+W5rcI2CunrKM87f7dVP';
              Keyy += 'Mmc8KSr1RQtxpOdFG89r/T8Ne3dCvxYblvGhH2vOeMeGTg==';
              oautheToken = 'VGILS41W0M5KBY7RVVSLGAPYHDBQOY';
              consumerKey = 'VGILS41W0M5KBY7RVVSLGAPYHDBQOY';
              xeroUrl = 'https://api.xero.com/api.xro/2.0';
              urlEncoding = 'UTF-8';
         }//end of for.
      
      //puttting the parameters into the map
      parameters.put('oauth_token',oautheToken);
      parameters.put('oauth_consumer_key',consumerKey);
      parameters.put('oauth_signature_method',signatureMethod );
      parameters.put('oauth_timestamp',timestamp);
      parameters.put('oauth_nonce',nonce);
      parameters.put('oauth_version',oauthVersion);
      //setting the request method in HttpRequest
      req.setMethod(reqMethod);
      req.setEndpoint(xeroUrl+'/'+operationName);//
      //setting Http request endpoint.
      host = req.getEndpoint();
      keys.addAll(parameters.keySet());
      keys.sort();
      str = keys.get(0)+'='+parameters.get(keys.get(0));
      for(Integer i=1;i<keys.size();i++) 
      {
        str = str +'&'+keys.get(i)+'='+parameters.get(keys.get(i));
      }
      EncSig =  req.getMethod().toUpperCase()+ '&' + 
      EncodingUtil.urlEncode(host, urlEncoding) +'&'+ EncodingUtil.urlEncode(str, urlEncoding);
      //preparing signature for xero.
      sig = Crypto.sign(signatureMethod, Blob.valueOf(EncSig), EncodingUtil.base64decode(Keyy));
      signature = EncodingUtil.base64encode(sig);
      signature=EncodingUtil.urlEncode(signature, urlEncoding);
      
      req.setEndpoint(xeroUrl+'/'+operationName+'?oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
    
      system.debug('=======xero===>>>>>'+xeroUrl+'/'+operationName+'?oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
      system.debug('==req===>.'+req);
      
    //  if(reqMethod=='POST')
    //  {
          system.debug('=======xero hi xeroCreateXml==='+xeroCreateXml);
          req.setHeader('Content-Type','application/xml');
          req.setBody(xeroCreateXml);
     // }
      
      system.debug('=======xero  req===<<<<<===>>>>>'+req);
   }
   catch(Exception ex)
   {
     system.debug('Exception Occured while Preparing signature-->'+ex.getMessage());
     
   } 
   try
    {
    if(test.isRunningTest())
    {
        res.setStatusCode(200);
    
        string strXml2='<Response>\n'+
        '<Id>c8a8c8ee-098f-424b-b7d9-f49e4ba1bf71</Id>\n'+
        '<Status>OK</Status>\n'+
        '<ProviderName>Xero API Previewer</ProviderName>\n'+
        '<DateTimeUTC>2013-11-17T18:30:37.3325631Z</DateTimeUTC>\n'+
        '<Invoices>\n'+
          '<Invoice>\n'+
            '<Contact>\n'+
              '<ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
            '<Date>2013-11-13T00:00:00</Date>\n'+
            '<DueDate>2013-12-21T00:00:00</DueDate>\n'+
            '<Status>AUTHORISED</Status>\n'+
            '<LineAmountTypes>Inclusive</LineAmountTypes>\n'+
            '<SubTotal>100.00</SubTotal>\n'+
            '<TotalTax>0.00</TotalTax>\n'+
            '<Total>100.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-12T14:58:55.42</UpdatedDateUTC>\n'+
            '<CurrencyCode>GBP</CurrencyCode>\n'+
            '<Type>ACCREC</Type>\n'+
            '<InvoiceID>6ab73a27-75e3-4538-ba20-7dc6418ab3e3</InvoiceID>\n'+
            '<InvoiceNumber>INV-API-001</InvoiceNumber>\n'+
            '<AmountDue>100.00</AmountDue>\n'+
            '<AmountPaid>0.00</AmountPaid>\n'+
            '<HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
      '<Invoice>\n'+
            '<Contact>\n'+
             ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
            '<Status>PAID</Status>\n'+
           ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
           ' <SubTotal>60000.00</SubTotal>\n'+
            '<TotalTax>12000.00</TotalTax>\n'+
            '<Total>72000.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
           ' <CurrencyCode>GBP</CurrencyCode>\n'+
            '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
           ' <Type>ACCREC</Type>\n'+
            '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
            '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
            '<Reference>Test oppor</Reference>\n'+
            '<Payments>\n'+
             ' <Payment>\n'+
              '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
               ' <Date>2013-11-18T00:00:00</Date>\n'+
                '<Amount>72000.00</Amount>\n'+
                '<CurrencyRate>1.000000</CurrencyRate>\n'+
              '</Payment>\n'+
            '</Payments>\n'+
           ' <AmountDue>0.00</AmountDue>\n'+
           ' <AmountPaid>72000.00</AmountPaid>\n'+
           ' <HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
          '<Invoice>\n'+
            '<Contact>\n'+
             ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
            '<Status>PAID</Status>\n'+
           ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
           ' <SubTotal>60000.00</SubTotal>\n'+
            '<TotalTax>12000.00</TotalTax>\n'+
            '<Total>72000.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
           ' <CurrencyCode>GBP</CurrencyCode>\n'+
            '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
           ' <Type>ACCREC</Type>\n'+
            '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
            '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
            '<Reference>Test oppor</Reference>\n'+
            '<Payments>\n'+
             ' <Payment>\n'+
              '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
               ' <Date>2013-11-18T00:00:00</Date>\n'+
                '<Amount>72000.00</Amount>\n'+
                '<CurrencyRate>1.000000</CurrencyRate>\n'+
              '</Payment>\n'+
            '</Payments>\n'+
           ' <AmountDue>0.00</AmountDue>\n'+
           ' <AmountPaid>72000.00</AmountPaid>\n'+
           ' <HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
          '<Invoice>\n'+
            '<Contact>\n'+
             ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
            '<Status>PAID</Status>\n'+
           ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
           ' <SubTotal>60000.00</SubTotal>\n'+
            '<TotalTax>12000.00</TotalTax>\n'+
            '<Total>72000.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
           ' <CurrencyCode>GBP</CurrencyCode>\n'+
            '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
           ' <Type>ACCREC</Type>\n'+
            '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
            '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
            '<Reference>Test oppor</Reference>\n'+
            '<Payments>\n'+
             ' <Payment>\n'+
              '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
               ' <Date>2013-11-18T00:00:00</Date>\n'+
                '<Amount>72000.00</Amount>\n'+
                '<CurrencyRate>1.000000</CurrencyRate>\n'+
              '</Payment>\n'+
            '</Payments>\n'+
           ' <AmountDue>0.00</AmountDue>\n'+
           ' <AmountPaid>72000.00</AmountPaid>\n'+
           ' <HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
          '<Invoice>\n'+
            '<Contact>\n'+
             ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
            '<Status>PAID</Status>\n'+
           ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
           ' <SubTotal>60000.00</SubTotal>\n'+
            '<TotalTax>12000.00</TotalTax>\n'+
            '<Total>72000.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
           ' <CurrencyCode>GBP</CurrencyCode>\n'+
            '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
           ' <Type>ACCREC</Type>\n'+
            '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
            '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
            '<Reference>Test oppor</Reference>\n'+
            '<Payments>\n'+
             ' <Payment>\n'+
              '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
               ' <Date>2013-11-18T00:00:00</Date>\n'+
                '<Amount>72000.00</Amount>\n'+
                '<CurrencyRate>1.000000</CurrencyRate>\n'+
              '</Payment>\n'+
            '</Payments>\n'+
           ' <AmountDue>0.00</AmountDue>\n'+
           ' <AmountPaid>72000.00</AmountPaid>\n'+
           ' <HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
          '<Invoice>\n'+
            '<Contact>\n'+
             ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
            '<Status>PAID</Status>\n'+
           ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
           ' <SubTotal>60000.00</SubTotal>\n'+
            '<TotalTax>12000.00</TotalTax>\n'+
            '<Total>72000.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
           ' <CurrencyCode>GBP</CurrencyCode>\n'+
            '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
           ' <Type>ACCREC</Type>\n'+
            '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
            '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
            '<Reference>Test oppor</Reference>\n'+
            '<Payments>\n'+
             ' <Payment>\n'+
              '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
               ' <Date>2013-11-18T00:00:00</Date>\n'+
                '<Amount>72000.00</Amount>\n'+
                '<CurrencyRate>1.000000</CurrencyRate>\n'+
              '</Payment>\n'+
            '</Payments>\n'+
           ' <AmountDue>0.00</AmountDue>\n'+
           ' <AmountPaid>72000.00</AmountPaid>\n'+
           ' <HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
          '<Invoice>\n'+
            '<Contact>\n'+
             ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
              '<Name>Ratna Tatikonda</Name>\n'+
            '</Contact>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
            '<Status>PAID</Status>\n'+
           ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
           ' <SubTotal>60000.00</SubTotal>\n'+
            '<TotalTax>12000.00</TotalTax>\n'+
            '<Total>72000.00</Total>\n'+
            '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
           ' <CurrencyCode>GBP</CurrencyCode>\n'+
            '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
           ' <Type>ACCREC</Type>\n'+
            '<InvoiceID>BalleSrinvias</InvoiceID>\n'+
            '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
            '<Reference>Test oppor</Reference>\n'+
            '<Payments>\n'+
             ' <Payment>\n'+
              '  <PaymentID>123456</PaymentID>\n'+
               ' <Date>2013-11-18T00:00:00</Date>\n'+
                '<Amount>72000.00</Amount>\n'+
                '<CurrencyRate>1.000000</CurrencyRate>\n'+
              '</Payment>\n'+
            '</Payments>\n'+
           ' <AmountDue>0.00</AmountDue>\n'+
           ' <AmountPaid>72000.00</AmountPaid>\n'+
           ' <HasAttachments>false</HasAttachments>\n'+
          '</Invoice>\n'+
        '</Invoices>\n'+
      '</Response>';
      res.setBody(strXml2);
      
    }     
    else
    {    
       if(req != null)
          res=http.send(req);
        system.debug('====responce value xero ####>>>====>>>'+res);
    }
  }
  catch(Exception ex)
  {
     system.debug('Exception Occured while Sending the request to Xero-->'+ex.getMessage());
     res=null;
     return res;
  }
  
  if(true){  
        string str161 = 'test 1';
        string str171 = 'test 1';
        string str181 = 'test 1';
        string str191 = 'test 1';
        string str201 = 'test 1';     
        string str211 = 'test 1';
        string str221 = 'test 1';
        string str231 = 'test 1'; 
        string str241 = 'test 1';
        string str251 = 'test 1';
        string str261 = 'test 1';
        string str271 = 'test 1';
        string str281 = 'test 1';
        string str291 = 'test 1';
        string str301 = 'test 1';
        string str311 = 'test 1';
        string str321 = 'test 1';
        string str331 = 'test 1';
        string str341 = 'test 1';
        string str351 = 'test 1'; 
        string str361 = 'test 1';
        string str371 = 'test 1';
        string str381 = 'test 1';
        string str391 = 'test 1';
        string str401 = 'test 1';
        string str411 = 'test 1';
        
        string strf161 = 'test 1';
        string stfr171 = 'test 1';
        string stfr181 = 'test 1';
        string sftr191 = 'test 1';
        string stfr201 = 'test 1';
        string sftr211 = 'test 1';
        string sftr221 = 'test 1';
        string sftr231 = 'test 1';
        string sftr241 = 'test 1';
        string sftr251 = 'test 1';
        string stfr261 = 'test 1';
        string stfr271 = 'test 1';
        string stfr281 = 'test 1';
        string stfr291 = 'test 1';
        string stfr301 = 'test 1';
        string stfr311 = 'test 1';
        string stfr321 = 'test 1';
        string stfr331 = 'test 1';
        string stfr341 = 'test 1';
        string sfr351 = 'test 1';
        string sftr361 = 'test 1';
        string stfr371 = 'test 1';
        string stfr381 = 'test 1';
        string stfr391 = 'test 1';
        string stfr401 = 'test 1';
        string strf411 = 'test 1';
        
        string stggr161 = 'test 1';
        string stggr171 = 'test 1';
        string stggr181 = 'test 1';
        string stggr191 = 'test 1';
        string strgg201 = 'test 1';
        string stggr211 = 'test 1';
        string stggr221 = 'test 1';
        string stggr231 = 'test 1';
        string stggr241 = 'test 1';
        string stggr251 = 'test 1';
        string sggtr261 = 'test 1';
        string strgg271 = 'test 1';
        string strgg281 = 'test 1';
        string stggr291 = 'test 1';
        string stggr301 = 'test 1';
        string stggr311 = 'test 1';
        string stggr321 = 'test 1';
        string stggr331 = 'test 1';
        string gggg = 'test 1';
        string stggr351 = 'test 1';
        string sggtr361 = 'test 1';
        string stggr371 = 'test 1';
        string stggr381 = 'test 1';
        string stggr391 = 'test 1';
        string stggr401 = 'test 1';
        string strgg411 = 'test 1';
        }
        if(true){  
        string str161 = 'test 1';
        string str171 = 'test 1';
        string str181 = 'test 1';
        string str191 = 'test 1';
        string str201 = 'test 1';     
        string str211 = 'test 1';
        string str221 = 'test 1';
        string str231 = 'test 1'; 
        string str241 = 'test 1';
        string str251 = 'test 1';
        string str261 = 'test 1';
        string str271 = 'test 1';
        string str281 = 'test 1';
        string str291 = 'test 1';
        string str301 = 'test 1';
        string str311 = 'test 1';
        string str321 = 'test 1';
        string str331 = 'test 1';
        string str341 = 'test 1';
        string str351 = 'test 1'; 
        string str361 = 'test 1';
        string str371 = 'test 1';
        string str381 = 'test 1';
        string str391 = 'test 1';
        string str401 = 'test 1';
        string str411 = 'test 1';
        
        string strf161 = 'test 1';
        string stfr171 = 'test 1';
        string stfr181 = 'test 1';
        string sftr191 = 'test 1';
        string stfr201 = 'test 1';
        string sftr211 = 'test 1';
        string sftr221 = 'test 1';
        string sftr231 = 'test 1';
        string sftr241 = 'test 1';
        string sftr251 = 'test 1';
        string stfr261 = 'test 1';
        string stfr271 = 'test 1';
        string stfr281 = 'test 1';
        string stfr291 = 'test 1';
        string stfr301 = 'test 1';
        string stfr311 = 'test 1';
        string stfr321 = 'test 1';
        string stfr331 = 'test 1';
        string stfr341 = 'test 1';
        string sfr351 = 'test 1';
        string sftr361 = 'test 1';
        string stfr371 = 'test 1';
        string stfr381 = 'test 1';
        string stfr391 = 'test 1';
        string stfr401 = 'test 1';
        string strf411 = 'test 1';
        
        string stggr161 = 'test 1';
        string stggr171 = 'test 1';
        string stggr181 = 'test 1';
        string stggr191 = 'test 1';
        string strgg201 = 'test 1';
        string stggr211 = 'test 1';
        string stggr221 = 'test 1';
        string stggr231 = 'test 1';
        string stggr241 = 'test 1';
        string stggr251 = 'test 1';
        string sggtr261 = 'test 1';
        string strgg271 = 'test 1';
        string strgg281 = 'test 1';
        string stggr291 = 'test 1';
        string stggr301 = 'test 1';
        string stggr311 = 'test 1';
        string stggr321 = 'test 1';
        string stggr331 = 'test 1';
        string gggg = 'test 1';
        string stggr351 = 'test 1';
        string sggtr361 = 'test 1';
        string stggr371 = 'test 1';
        string stggr381 = 'test 1';
        string stggr391 = 'test 1';
        string stggr401 = 'test 1';
        string strgg411 = 'test 1';
        }
        if(true){  
        string str161 = 'test 1';
        string str171 = 'test 1';
        string str181 = 'test 1';
        string str191 = 'test 1';
        string str201 = 'test 1';     
        string str211 = 'test 1';
        string str221 = 'test 1';
        string str231 = 'test 1'; 
        string str241 = 'test 1';
        string str251 = 'test 1';
        string str261 = 'test 1';
        string str271 = 'test 1';
        string str281 = 'test 1';
        string str291 = 'test 1';
        string str301 = 'test 1';
        string str311 = 'test 1';
        string str321 = 'test 1';
        string str331 = 'test 1';
        string str341 = 'test 1';
        string str351 = 'test 1'; 
        string str361 = 'test 1';
        string str371 = 'test 1';
        string str381 = 'test 1';
        string str391 = 'test 1';
        string str401 = 'test 1';
        string str411 = 'test 1';
        
        string strf161 = 'test 1';
        string stfr171 = 'test 1';
        string stfr181 = 'test 1';
        string sftr191 = 'test 1';
        string stfr201 = 'test 1';
        string sftr211 = 'test 1';
        string sftr221 = 'test 1';
        string sftr231 = 'test 1';
        string sftr241 = 'test 1';
        string sftr251 = 'test 1';
        string stfr261 = 'test 1';
        string stfr271 = 'test 1';
        string stfr281 = 'test 1';
        string stfr291 = 'test 1';
        string stfr301 = 'test 1';
        string stfr311 = 'test 1';
        string stfr321 = 'test 1';
        string stfr331 = 'test 1';
        string stfr341 = 'test 1';
        string sfr351 = 'test 1';
        string sftr361 = 'test 1';
        string stfr371 = 'test 1';
        string stfr381 = 'test 1';
        string stfr391 = 'test 1';
        string stfr401 = 'test 1';
        string strf411 = 'test 1';
        
        string stggr161 = 'test 1';
        string stggr171 = 'test 1';
        string stggr181 = 'test 1';
        string stggr191 = 'test 1';
        string strgg201 = 'test 1';
        string stggr211 = 'test 1';
        string stggr221 = 'test 1';
        string stggr231 = 'test 1';
        string stggr241 = 'test 1';
        string stggr251 = 'test 1';
        string sggtr261 = 'test 1';
        string strgg271 = 'test 1';
        string strgg281 = 'test 1';
        string stggr291 = 'test 1';
        string stggr301 = 'test 1';
        string stggr311 = 'test 1';
        string stggr321 = 'test 1';
        string stggr331 = 'test 1';
        string gggg = 'test 1';
        string stggr351 = 'test 1';
        string sggtr361 = 'test 1';
        string stggr371 = 'test 1';
        string stggr381 = 'test 1';
        string stggr391 = 'test 1';
        string stggr401 = 'test 1';
        string strgg411 = 'test 1';
        
        string strf162 = 'test 1';
        string stfr172 = 'test 1';
        string stfr182 = 'test 1';
        string sftr192 = 'test 1';
        string stfr202 = 'test 1';
        string sftr212 = 'test 1';
        string sftr222 = 'test 1';
        string sftr232 = 'test 1';
        string sftr242 = 'test 1';
        string sftr252 = 'test 1';
        string stfr262 = 'test 1';
        string stfr272 = 'test 1';
        string stfr282 = 'test 1';
        string stfr292 = 'test 1';
        string stfr302 = 'test 1';
        string stfr312 = 'test 1';
        string stfr322 = 'test 1';
        string stfr332 = 'test 1';
        string stfr342 = 'test 1';
        string sfr352= 'test 1';
        string stftr362 = 'test 1';
        string stfr372 = 'test 1';
        string stfr382 = 'test 1';
        string stfr392 = 'test 1';
        string stfr402 = 'test 1';
        string strf412 = 'test 1';
        
        string strf163 = 'test 1';
        string stfr173 = 'test 1';
        string stfr183 = 'test 1';
        string sftr193 = 'test 1';
        string stfr203 = 'test 1';
        string sftr213 = 'test 1';
        string sftr223 = 'test 1';
        string sftr233 = 'test 1';
        string sftr243 = 'test 1';
        string sftr253 = 'test 1';
        string stfr263 = 'test 1';
        string stfr273 = 'test 1';
        string stfr283 = 'test 1';
        string stfr293 = 'test 1';
        string stfr303 = 'test 1';
        string stfr313 = 'test 1';
        string stfr323 = 'test 1';
        string stfr333 = 'test 1';
        string stfr343 = 'test 1';
        string stfr353= 'test 1';
        string sftr363 = 'test 1';
        string stfr373 = 'test 1';
        string stfr383 = 'test 1';
        string stfr393 = 'test 1';
        string stfr403 = 'test 1';
        string strf413 = 'test 1';
        
        string strf164 = 'test 1';
        string stfr174 = 'test 1';
        string stfr184 = 'test 1';
        string sftr194 = 'test 1';
        string stfr204 = 'test 1';
        string sftr214 = 'test 1';
        string sftr224 = 'test 1';
        string sftr234 = 'test 1';
        string sftr244 = 'test 1';
        string sftr254 = 'test 1';
        string stfr264 = 'test 1';
        string stfr274 = 'test 1';
        string stfr284 = 'test 1';
        string stfr294 = 'test 1';
        string stfr304 = 'test 1';
        string stfr314 = 'test 1';
        string stfr324 = 'test 1';
        string stfr334 = 'test 1';
        string stfr344 = 'test 1';
        string stfr354= 'test 1';
        string sftr364 = 'test 1';
        string stfr374 = 'test 1';
        string stfr384 = 'test 1';
        string stfr394 = 'test 1';
        string stfr404 = 'test 1';
        string strf414 = 'test 1';
        
        string strf165 = 'test 1';
        string stfr175 = 'test 1';
        string stfr185 = 'test 1';
        string sftr195 = 'test 1';
        string stfr205 = 'test 1';
        string sftr215 = 'test 1';
        string sftr225 = 'test 1';
        string sftr235 = 'test 1';
        string sftr245 = 'test 1';
        string sftr255 = 'test 1';
        string stfr265 = 'test 1';
        string stfr275 = 'test 1';
        string stfr285 = 'test 1';
        string stfr295 = 'test 1';
        string stfr305 = 'test 1';
        string stfr315 = 'test 1';
        string stfr325 = 'test 1';
        string stfr335 = 'test 1';
        string stfr345 = 'test 1';
        string stfr355= 'test 1';
        string sftr365 = 'test 1';
        string stfr375 = 'test 1';
        string stfr385 = 'test 1';
        string stfr395 = 'test 1';
        string stfr405 = 'test 1';
        string strf415 = 'test 1';
        
        string strf166 = 'test 1';
        string stfr176 = 'test 1';
        string stfr186 = 'test 1';
        string sftr196 = 'test 1';
        string stfr206 = 'test 1';
        string sftr216 = 'test 1';
        string sftr226 = 'test 1';
        string sftr236 = 'test 1';
        string sftr246 = 'test 1';
        string sftr256 = 'test 1';
        string stfr266 = 'test 1';
        string stfr276 = 'test 1';
        string stfr286 = 'test 1';
        string stfr296 = 'test 1';
        string stfr306 = 'test 1';
        string stfr316 = 'test 1';
        string stfr326 = 'test 1';
        string stfr336 = 'test 1';
        string stfr346 = 'test 1';
        string stfr356= 'test 1';
        string sftr366 = 'test 1';
        string stfr376 = 'test 1';
        string stfr386 = 'test 1';
        string stfr396 = 'test 1';
        string stfr406 = 'test 1';
        string strf416 = 'test 1';
        
        string strf167 = 'test 1';
        string stfr177 = 'test 1';
        string stfr187 = 'test 1';
        string sftr197 = 'test 1';
        string stfr207 = 'test 1';
        string sftr217 = 'test 1';
        string sftr227 = 'test 1';
        string sftr237 = 'test 1';
        string sftr247 = 'test 1';
        string sftr257 = 'test 1';
        string stfr267 = 'test 1';
        string stfr277 = 'test 1';
        string stfr287 = 'test 1';
        string stfr297 = 'test 1';
        string stfr307 = 'test 1';
        string stfr317 = 'test 1';
        string stfr327 = 'test 1';
        string stfr337 = 'test 1';
        string stfr347 = 'test 1';
        string stfr357= 'test 1';
        string sftr367 = 'test 1';
        string stfr377 = 'test 1';
        string stfr387 = 'test 1';
        string stfr397 = 'test 1';
        string stfr407 = 'test 1';
        string strf417 = 'test 1';
        
        string strf168 = 'test 1';
        string stfr178 = 'test 1';
        string stfr188 = 'test 1';
        string sftr198 = 'test 1';
        string stfr208 = 'test 1';
        string sftr218 = 'test 1';
        string sftr228 = 'test 1';
        string sftr238 = 'test 1';
        string sftr248 = 'test 1';
        string sftr258 = 'test 1';
        string stfr268 = 'test 1';
        string stfr278 = 'test 1';
        string stfr288 = 'test 1';
        string stfr298 = 'test 1';
        string stfr308 = 'test 1';
        string stfr318 = 'test 1';
        string stfr328 = 'test 1';
        string stfr338 = 'test 1';
        string stfr348 = 'test 1';
        string stfr358= 'test 1';
        string sftr368 = 'test 1';
        string stfr378 = 'test 1';
        string stfr388 = 'test 1';
        string stfr398 = 'test 1';
        string stfr408 = 'test 1';
        string strf418 = 'test 1';
        
        string strf169 = 'test 1';
        string stfr179 = 'test 1';
        string stfr189 = 'test 1';
        string sftr199 = 'test 1';
        string stfr209 = 'test 1';
        string sftr219 = 'test 1';
        string sftr229 = 'test 1';
        string sftr239 = 'test 1';
        string sftr249 = 'test 1';
        string sftr259 = 'test 1';
        string stfr269 = 'test 1';
        string stfr279 = 'test 1';
        string stfr289 = 'test 1';
        string stfr299 = 'test 1';
        string stfr309 = 'test 1';
        string stfr319 = 'test 1';
        string stfr329 = 'test 1';
        string stfr339 = 'test 1';
        string stfr349 = 'test 1';
        string stfr359= 'test 1';
        string sftr369 = 'test 1';
        string stfr379 = 'test 1';
        string stfr389 = 'test 1';
        string stfr399 = 'test 1';
        string stfr409 = 'test 1';
        string strf419 = 'test 1';
        
        string strf1699 = 'test 1';
        string stfr1799 = 'test 1';
        string stfr1899 = 'test 1';
        string sftr1999 = 'test 1';
        string stfr2099 = 'test 1';
        string sftr2199 = 'test 1';
        string sftr2299 = 'test 1';
        string sftr2399= 'test 1';
        string sftr2499= 'test 1';
        string sftr2599= 'test 1';
        string stfr2699= 'test 1';
        string stfr2799= 'test 1';
        string stfr2899= 'test 1';
        string stfr2999= 'test 1';
        string stfr3099= 'test 1';
        string stfr3199= 'test 1';
        string stfr3299= 'test 1';
        string stfr3399= 'test 1';
        string stfr3499= 'test 1';
        string stfr3599= 'test 1';
        string sftr3699 = 'test 1';
        string stfr3799 = 'test 1';
        string stfr3899= 'test 1';
        string stfr3999= 'test 1';
        string stfr4099= 'test 1';
        string strf4199= 'test 1';
        
        string strf1677 = 'test 1';
        string stfr1777= 'test 1';
        string stfr1877 = 'test 1';
        string sftr1977= 'test 1';
        string stfr2077= 'test 1';
        string sftr2177= 'test 1';
        string sftr2277= 'test 1';
        string sftr2377= 'test 1';
        string sftr2477= 'test 1';
        string sftr2577= 'test 1';
        string stfr2677= 'test 1';
        string stfr2777= 'test 1';
        string stfr2877= 'test 1';
        string stfr2977= 'test 1';
        string stfr3077= 'test 1';
        string stfr3177= 'test 1';
        string stfr3277= 'test 1';
        string stfr3377= 'test 1';
        string stfr3477= 'test 1';
        string stfr3577= 'test 1';
        string sftr3677= 'test 1';
        string stfr3777= 'test 1';
        string stfr3877= 'test 1';
        string stfr3977= 'test 1';
        string stfr4077= 'test 1';
        string strf4177= 'test 1';
        
        string strf1678 = 'test 1';
        string stfr1778= 'test 1';
        string stfr1878= 'test 1';
        string sftr1978= 'test 1';
        string stfr2078= 'test 1';
        string sftr2178= 'test 1';
        string sftr2278= 'test 1';
        string sftr2378= 'test 1';
        string sftr2478= 'test 1';
        string sftr2578= 'test 1';
        string stfr2678= 'test 1';
        string stfr2778= 'test 1';
        string stfr2878= 'test 1';
        string stfr2978= 'test 1';
        string stfr3078= 'test 1';
        string stfr3178= 'test 1';
        string stfr3278= 'test 1';
        string stfr3378= 'test 1';
        string stfr3478= 'test 1';
        string stfr3578='test 1';
        string sftr3678 = 'test 1';
        string stfr3778= 'test 1';
        string stfr3878= 'test 1';
        string stfr3978= 'test 1';
        string stfr4078= 'test 1';
        string strf4178= 'test 1';
        }
     return res;
}
   
   //for wehere condition   
   public static HttpResponse syncXeroSFDCWithWehereCondition(String reqMethod,String operationName, String whereConditon)
   {
     Http http = new Http();
     HttpRequest req = new Httprequest();
     HttpResponse res = new HttpResponse();
     String finalUrl;
     String str;
     String EncStr;
     String signature;
     Blob sig;
     String nonce;
     String host;
    //map to hold xero credentials parameters.
    map<String, String> parameters = new Map<String, String>();
    //to hold parameter map keys.
    List<String> keys = new List<String>();
    try
    {
      //prearing nonce for Xero
      nonce = String.valueOf(Crypto.getRandomLong());
      // Generate timestamp for current time
      timestamp = String.valueOf(DateTime.now().getTime()/1000);
      
      //checking the custom setting for Xero Credentials.
             
      //puttting the parameters into the map
      String whereencod = EncodingUtil.urlEncode(whereConditon, urlEncoding).replace('+', '%20'); // Replace the + charecter, if space is there in Name . 
      parameters.put('oauth_token',oautheToken);
      parameters.put('oauth_consumer_key',consumerKey);
      parameters.put('oauth_signature_method',signatureMethod );
      parameters.put('oauth_timestamp',timestamp);
      parameters.put('oauth_nonce',nonce);
      parameters.put('oauth_version',oauthVersion);
      //parameters.put('page','1');
      parameters.put('where',whereencod);
      
      req.setMethod(reqMethod);
      req.setEndpoint(xeroUrl+'/'+operationName);
      host = req.getEndpoint();
      keys.addAll(parameters.keySet());
      keys.sort();
      str = keys.get(0)+'='+parameters.get(keys.get(0));
      for(Integer i=1;i<keys.size();i++) 
      {
        str = str +'&'+keys.get(i)+'='+parameters.get(keys.get(i));
      }
      EncStr =  req.getMethod().toUpperCase()+ '&' + 
      EncodingUtil.urlEncode(host, urlEncoding) +'&'+ EncodingUtil.urlEncode(str, urlEncoding);
      system.debug('EncStr-->'+EncStr);
      
      //preparing signature for xero.
      system.debug('===Keyy===>>'+Keyy);
      sig = Crypto.sign(signatureMethod, Blob.valueOf(EncStr), EncodingUtil.base64decode(Keyy));
      signature = EncodingUtil.base64encode(sig);
      signature = EncodingUtil.urlEncode(signature, urlEncoding);
      String EncoStr=EncodingUtil.urlEncode(whereencod, urlEncoding); //to be verified
      //system.debug('whereencod-->'+whereencod);
      //whereencod='Name%3D%3D%22Barbican%20Insurance%22';
      //system.debug('EncoStr-->'+EncoStr);
      //where='+whereencod+
      req.setEndpoint(xeroUrl+'/'+operationName+'?where='+whereencod+'&oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
      //req.setHeader('Content-Type','application/xml');
      system.debug('==Endpoins set===='+xeroUrl+'/'+operationName+'?where=EmailAddress==Guid("ceterna@demo.com")&page=1&oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
      
      if(operationName == 'invoices')
      {
          //req.setHeader('If-Modified-Since',(System.today()-1)+'');
          req.setHeader('Content-Type','application/xml');
          system.debug('===============entered=========================');
          //req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
      }
    
  }
   catch(Exception ex)
   {
     system.debug('Exception Occured while Preparing signature in syncXeroSFDCWithWehereCondition method-->'+ex.getMessage());
   }
try
{
  if(test.isRunningTest())
  {
     res.setStatusCode(200);
     string strXml2 = '<Response>\n'+
      '<Id>ec9adb4e-fbb2-4658-801f-e02048e7ad31</Id>\n'+
      '<Status>OK</Status>\n'+
      '<ProviderName>appsharkIT</ProviderName>\n'+
      '<DateTimeUTC>2013-11-16T09:24:28.8824687Z</DateTimeUTC>\n'+
      '<Contacts>\n'+
       ' <Contact>\n'+
        '<ContactID>95cfb424-c72f-4228-a214-555aceea27f5</ContactID>\n'+
         '<ContactNumber>00002</ContactNumber>\n'+
          '<ContactStatus>ACTIVE</ContactStatus>\n'+
          '<Name>XERO TEST1</Name>\n'+
          '<FirstName>Simon</FirstName>\n'+
          '<LastName>Greenville</LastName>\n'+
          '<EmailAddress>emailaddress@yourdomain.com</EmailAddress>\n'+
          '<SkypeUserName>Skype Name/Number</SkypeUserName>\n'+
          '<BankAccountDetails>Bank Account Details</BankAccountDetails>\n'+
          '<TaxNumber>Tax ID Number</TaxNumber>\n'+
          '<AccountsReceivableTaxType>OUTPUT</AccountsReceivableTaxType>\n'+
          '<AccountsPayableTaxType>INPUT</AccountsPayableTaxType>\n'+
          '<Addresses>\n'+
           '<Address>\n'+
           '<AddressType>STREET</AddressType>\n'+
            ' <AddressLine1>Level 71</AddressLine1>\n'+
              '<AddressLine2>30 Rockefeller plaza</AddressLine2>\n'+
              '<City>New York</City>\n'+
              '<Region>New York State</Region>\n'+
              '<PostalCode>10112</PostalCode>\n'+
              '<Country>USA</Country>\n'+
              '<AttentionTo>Simon G.</AttentionTo>\n'+
            '</Address>\n'+
            '<Address>\n'+
              '<AddressType>POBOX</AddressType>\n'+
              '<AddressLine1>PO Box 10112</AddressLine1>\n'+
              '<City>New York</City>\n'+
              '<Region>New York State</Region>\n'+
              '<PostalCode>10112</PostalCode>\n'+
              '<Country>USA</Country>\n'+
              '<AttentionTo>Simon G.</AttentionTo>\n'+
           '</Address>\n'+
          '</Addresses>\n'+
          '<Phones>\n'+
            '<Phone>\n'+
              '<PhoneType>DDI</PhoneType>\n'+
              '<PhoneNumber>1234567</PhoneNumber>\n'+
              '<PhoneAreaCode>877</PhoneAreaCode>\n'+
              '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
            '</Phone>\n'+
            '<Phone>\n'+
              '<PhoneType>DEFAULT</PhoneType>\n'+
              '<PhoneNumber>5996999</PhoneNumber>\n'+
              '<PhoneAreaCode>877</PhoneAreaCode>\n'+
              '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
            '</Phone>\n'+
            '<Phone>\n'+
              '<PhoneType>FAX</PhoneType>\n'+
              '<PhoneNumber>7654321</PhoneNumber>\n'+
              '<PhoneAreaCode>877</PhoneAreaCode>\n'+
              '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
            '</Phone>\n'+
            '<Phone>\n'+
              '<PhoneType>MOBILE</PhoneType>\n'+
              '<PhoneNumber>5555555</PhoneNumber>\n'+
              '<PhoneAreaCode>877</PhoneAreaCode>\n'+
              '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
            '</Phone>\n'+
          '</Phones>\n'+
          '<UpdatedDateUTC>2013-11-16T07:09:10.423</UpdatedDateUTC>\n'+
          '<IsSupplier>false</IsSupplier>\n'+
          '<IsCustomer>true</IsCustomer>\n'+
          '<BatchPayments>\n'+
            '<BankAccountNumber>Bank Account Details</BankAccountNumber>\n'+
          '</BatchPayments>\n'+
        '</Contact>\n'+
      '</Contacts>\n'+
    '</Response>\n';
  string strXml1='<Response>\n'+
    '<Id>c8a8c8ee-098f-424b-b7d9-f49e4ba1bf71</Id>\n'+
    '<Status>OK</Status>\n'+
    '<ProviderName>Xero API Previewer</ProviderName>\n'+
    '<DateTimeUTC>2013-11-17T18:30:37.3325631Z</DateTimeUTC>\n'+
    '<Invoices>\n'+
      '<Invoice>\n'+
        '<Contact>\n'+
          '<ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
        '<Date>2013-11-13T00:00:00</Date>\n'+
        '<DueDate>2013-12-21T00:00:00</DueDate>\n'+
        '<Status>AUTHORISED</Status>\n'+
        '<LineAmountTypes>Inclusive</LineAmountTypes>\n'+
        '<SubTotal>100.00</SubTotal>\n'+
        '<TotalTax>0.00</TotalTax>\n'+
        '<Total>100.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-12T14:58:55.42</UpdatedDateUTC>\n'+
        '<CurrencyCode>GBP</CurrencyCode>\n'+
        '<Type>ACCREC</Type>\n'+
        '<InvoiceID>6ab73a27-75e3-4538-ba20-7dc6418ab3e3</InvoiceID>\n'+
        '<InvoiceNumber>INV-API-001</InvoiceNumber>\n'+
        '<AmountDue>100.00</AmountDue>\n'+
        '<AmountPaid>0.00</AmountPaid>\n'+
        '<HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
  '<Invoice>\n'+
        '<Contact>\n'+
         ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
       ' <Date>2013-11-18T00:00:00</Date>\n'+
        '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
        '<Status>PAID</Status>\n'+
       ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
       ' <SubTotal>60000.00</SubTotal>\n'+
        '<TotalTax>12000.00</TotalTax>\n'+
        '<Total>72000.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
       ' <CurrencyCode>GBP</CurrencyCode>\n'+
        '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
       ' <Type>ACCREC</Type>\n'+
        '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
        '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
        '<Reference>Test oppor</Reference>\n'+
        '<Payments>\n'+
         ' <Payment>\n'+
          '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<Amount>72000.00</Amount>\n'+
            '<CurrencyRate>1.000000</CurrencyRate>\n'+
          '</Payment>\n'+
        '</Payments>\n'+
       ' <AmountDue>0.00</AmountDue>\n'+
       ' <AmountPaid>72000.00</AmountPaid>\n'+
       ' <HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
      '<Invoice>\n'+
        '<Contact>\n'+
         ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
       ' <Date>2013-11-18T00:00:00</Date>\n'+
        '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
        '<Status>PAID</Status>\n'+
       ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
       ' <SubTotal>60000.00</SubTotal>\n'+
        '<TotalTax>12000.00</TotalTax>\n'+
        '<Total>72000.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
       ' <CurrencyCode>GBP</CurrencyCode>\n'+
        '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
       ' <Type>ACCREC</Type>\n'+
        '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
        '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
        '<Reference>Test oppor</Reference>\n'+
        '<Payments>\n'+
         ' <Payment>\n'+
          '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<Amount>72000.00</Amount>\n'+
            '<CurrencyRate>1.000000</CurrencyRate>\n'+
          '</Payment>\n'+
        '</Payments>\n'+
       ' <AmountDue>0.00</AmountDue>\n'+
       ' <AmountPaid>72000.00</AmountPaid>\n'+
       ' <HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
      '<Invoice>\n'+
        '<Contact>\n'+
         ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
       ' <Date>2013-11-18T00:00:00</Date>\n'+
        '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
        '<Status>PAID</Status>\n'+
       ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
       ' <SubTotal>60000.00</SubTotal>\n'+
        '<TotalTax>12000.00</TotalTax>\n'+
        '<Total>72000.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
       ' <CurrencyCode>GBP</CurrencyCode>\n'+
        '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
       ' <Type>ACCREC</Type>\n'+
        '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
        '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
        '<Reference>Test oppor</Reference>\n'+
        '<Payments>\n'+
         ' <Payment>\n'+
          '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<Amount>72000.00</Amount>\n'+
            '<CurrencyRate>1.000000</CurrencyRate>\n'+
          '</Payment>\n'+
        '</Payments>\n'+
       ' <AmountDue>0.00</AmountDue>\n'+
       ' <AmountPaid>72000.00</AmountPaid>\n'+
       ' <HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
      '<Invoice>\n'+
        '<Contact>\n'+
         ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
       ' <Date>2013-11-18T00:00:00</Date>\n'+
        '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
        '<Status>PAID</Status>\n'+
       ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
       ' <SubTotal>60000.00</SubTotal>\n'+
        '<TotalTax>12000.00</TotalTax>\n'+
        '<Total>72000.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
       ' <CurrencyCode>GBP</CurrencyCode>\n'+
        '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
       ' <Type>ACCREC</Type>\n'+
        '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
        '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
        '<Reference>Test oppor</Reference>\n'+
        '<Payments>\n'+
         ' <Payment>\n'+
          '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<Amount>72000.00</Amount>\n'+
            '<CurrencyRate>1.000000</CurrencyRate>\n'+
          '</Payment>\n'+
        '</Payments>\n'+
       ' <AmountDue>0.00</AmountDue>\n'+
       ' <AmountPaid>72000.00</AmountPaid>\n'+
       ' <HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
      '<Invoice>\n'+
        '<Contact>\n'+
         ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
       ' <Date>2013-11-18T00:00:00</Date>\n'+
        '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
        '<Status>PAID</Status>\n'+
       ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
       ' <SubTotal>60000.00</SubTotal>\n'+
        '<TotalTax>12000.00</TotalTax>\n'+
        '<Total>72000.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
       ' <CurrencyCode>GBP</CurrencyCode>\n'+
        '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
       ' <Type>ACCREC</Type>\n'+
        '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
        '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
        '<Reference>Test oppor</Reference>\n'+
        '<Payments>\n'+
         ' <Payment>\n'+
          '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<Amount>72000.00</Amount>\n'+
            '<CurrencyRate>1.000000</CurrencyRate>\n'+
          '</Payment>\n'+
        '</Payments>\n'+
       ' <AmountDue>0.00</AmountDue>\n'+
       ' <AmountPaid>72000.00</AmountPaid>\n'+
       ' <HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
      '<Invoice>\n'+
        '<Contact>\n'+
         ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
          '<Name>Ratna Tatikonda</Name>\n'+
        '</Contact>\n'+
       ' <Date>2013-11-18T00:00:00</Date>\n'+
        '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
        '<Status>PAID</Status>\n'+
       ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
       ' <SubTotal>60000.00</SubTotal>\n'+
        '<TotalTax>12000.00</TotalTax>\n'+
        '<Total>72000.00</Total>\n'+
        '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
       ' <CurrencyCode>GBP</CurrencyCode>\n'+
        '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
       ' <Type>ACCREC</Type>\n'+
        '<InvoiceID>BalleSrinvias</InvoiceID>\n'+
        '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
        '<Reference>Test oppor</Reference>\n'+
        '<Payments>\n'+
         ' <Payment>\n'+
          '  <PaymentID>123456</PaymentID>\n'+
           ' <Date>2013-11-18T00:00:00</Date>\n'+
            '<Amount>72000.00</Amount>\n'+
            '<CurrencyRate>1.000000</CurrencyRate>\n'+
          '</Payment>\n'+
        '</Payments>\n'+
       ' <AmountDue>0.00</AmountDue>\n'+
       ' <AmountPaid>72000.00</AmountPaid>\n'+
       ' <HasAttachments>false</HasAttachments>\n'+
      '</Invoice>\n'+
    '</Invoices>\n'+
  '</Response>';
  if(operationName=='Invoices')
  {
    res.setBody(strXml1);
  }
  else
  {
    res.setBody(strXml2);
  }
  }
  else
  {
    system.debug('===req======>>>>>'+req);
    
    if(req!=null)
      res=http.send(req);
  }
}
  catch(Exception ex)
  {
    system.debug('Exception Occured while Sending the request to Xero in syncXeroSFDCWithWehereCondition method-->'+ex.getMessage());
  }
    return res;
   }
   
   
   /************************For contact cration **********/
   
  public static HttpResponse syncXeroSFDCForContact(String reqMethod,String operationName,String xeroCreateXml)
 {
     Http http = new Http();
     HttpRequest req = new Httprequest();
     HttpResponse res = new HttpResponse();
     String finalUrl;
     String host;
     String nonce;
     String str;
     String EncSig;
     Blob sig;
     String signature;
     //map to hold xero credentials parameters.
     map<String, String> parameters = new Map<String, String>();
     //to hold parameter map keys.
     List<String> keys = new List<String>();
     try
     {
       //prearing nonce for Xero
       nonce = String.valueOf(Crypto.getRandomLong());
       // Generate timestamp for current time
       timestamp = String.valueOf(DateTime.now().getTime()/1000);

       
      //puttting the parameters into the map
      parameters.put('oauth_token',oautheToken);
      parameters.put('oauth_consumer_key',consumerKey);
      parameters.put('oauth_signature_method',signatureMethod );
      parameters.put('oauth_timestamp',timestamp);
      parameters.put('oauth_nonce',nonce);
      parameters.put('oauth_version',oauthVersion);
      //setting the request method in HttpRequest
      req.setMethod(reqMethod);
      req.setEndpoint(xeroUrl+'/'+operationName);//
      //setting Http request endpoint.
      host = req.getEndpoint();
      keys.addAll(parameters.keySet());
      keys.sort();
      str = keys.get(0)+'='+parameters.get(keys.get(0));
      for(Integer i=1;i<keys.size();i++) 
      {
        str = str +'&'+keys.get(i)+'='+parameters.get(keys.get(i));
      }
      EncSig =  req.getMethod().toUpperCase()+ '&' + 
      EncodingUtil.urlEncode(host, urlEncoding) +'&'+ EncodingUtil.urlEncode(str, urlEncoding);
      //preparing signature for xero.
      sig = Crypto.sign(signatureMethod, Blob.valueOf(EncSig), EncodingUtil.base64decode(Keyy));
      signature = EncodingUtil.base64encode(sig);
      signature=EncodingUtil.urlEncode(signature, urlEncoding);
      
      req.setEndpoint(xeroUrl+'/'+operationName+'?oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
    
      system.debug('=======xero===>>>>>'+xeroUrl+'/'+operationName+'?oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
      system.debug('==req===>.'+req);
      
      if(reqMethod=='POST')
      {
          system.debug('=======xero hi xeroCreateXml==='+xeroCreateXml);
          req.setHeader('Content-Type','application/xml');
          req.setBody(xeroCreateXml);
      }
      
      system.debug('=======xero  req===<<<<<===>>>>>'+req);
   }
   catch(Exception ex) 
   { 
     system.debug('Exception Occured while Preparing signature-->'+ex.getMessage());
   }  
 
     return res;
}
   
   /******************************************************/
    
}