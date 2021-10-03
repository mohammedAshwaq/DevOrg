global class xeroAccountProcess{

    @future(callout=true)
        public static void sendAccounts(set<id> accounts){
            String result;
            for(Account  acc: [select Id, Phone,Name,New_Xero_Account_Id__c, BillingStreet,BillingCity,BillingState,BillingPostalCode, BillingCountry FROM Account WHERE Id IN :accounts]){
                   string strXML = '<Contacts>'; 
                       strXML += '<Contact>';
                        if(acc.New_Xero_Account_Id__c !=null)
                           strXml+='<ContactID>'+acc.New_Xero_Account_Id__c +'</ContactID>';
                     /*  strXML +='<DefaultCurrency>' + acc.CurrencyIsoCode+'</DefaultCurrency>';
                       strXML +='<BatchPayments>'; 
                       strXML +='<BankAccountNumber>';
                       strXML += acc.Bank_Account_Number__c;
                       strXML +='</BankAccountNumber>';
                       strXML +='<BankAccountName>';
                       strXML += acc.Bank_Account_Name__c;
                       strXML +='</BankAccountName>';
                       strXML +='</BatchPayments>';  */
                       strXML += '<ContactNumber>';
                       strXML += acc.Phone;
                       strXML += '</ContactNumber>';
                       strXML += '<Name>';
                       strXML += acc.Name;
                       strXML += '</Name>';
                       strXML += '<Addresses>';
                       strXML +='<Address>'; 
                       strXML +='<AddressType>POBOX</AddressType>';
                       strXML +='<AddressLine1>' + acc.BillingStreet + '</AddressLine1>';
                       strXML +='<City>' + acc.BillingCity + '</City>';
                       strXML +='<Region>' + acc.BillingState + '</Region>';
                       strXML +='<PostalCode>' + acc.BillingPostalCode + '</PostalCode>';
                       strXML +='<Country>' + acc.BillingCountry + '</Country>';
                       strXML +='</Address>'; 
                       strXML += '</Addresses>';
                       strXML += '<Addresses>';
                       strXML +='<Address>'; 
                       strXML +='<AddressType>STREET</AddressType>';
                       strXML +='<AddressLine1>' + acc.BillingStreet + '</AddressLine1>';
                       strXML +='<City>' + acc.BillingCity + '</City>';
                       strXML +='<Region>' + acc.BillingState + '</Region>';
                       strXML +='<PostalCode>' + acc.BillingPostalCode + '</PostalCode>';
                       strXML +='<Country>' + acc.BillingCountry + '</Country>';
                       strXML +='</Address>'; 
                       strXML += '</Addresses>';
                     /* strXml +='<IsSupplier>'+acc.IsSupplier__c +'</IsSupplier>';
                      strXml +='<IsCustomer>'+acc.IsCustomer__c +'</IsCustomer>';
                      strXml +='<AccountsReceivableTaxType>'+mcs.get(acc.Sales_GST__c).Xero_Code__c+'</AccountsReceivableTaxType>';
                      strXml +='<AccountsPayableTaxType>'+mcs.get(acc.Purchases_GST__c).Xero_Code__c+'</AccountsPayableTaxType>';
                      strXml +='<PaymentTerms>';
                      strXml +='<Bills>';
                      strXml +='<Day>'+acc.Days_AP__c+'</Day>';
                      strXml +=' <Type>'+mpt.get(acc.Xero_AccountPayable__c).Xero_payment_terms__c+'</Type>';
                      strXml +='</Bills>';
                      strXml +='<Sales>';
                      strXml +='<Day>'+acc.Day_AR__c+'</Day>';
                      strXml +='<Type>'+mpt.get(acc.Xero_AccountReceivable__c).Xero_payment_terms__c+'</Type>';
                      strXml +='</Sales>';
                      strXml +='</PaymentTerms>';*/
                      strXML += '</Contact>';
                      
                      strXML += '</Contacts>';    
                      HttpResponse response = XeroPrivateConnection.syncXeroSFDC('POST','Contacts',strXML); 
                      result= response.getStatus();    
                      if( result== 'OK' ){
                        Dom.Document document = new Dom.Document();
                        document.load(response.getBody());
                        DOM.XMLNode root = document.getRootElement();                    
                        Dom.XMLNode Contacts = root.getChildElement('Contacts',null);
                        Dom.XMLNode Contact = Contacts.getChildElement('Contact',null);                    
                        string conId = Contact.getChildElement('ContactID',null).getText();
                        acc.New_Xero_Account_Id__c = conId;
                        //acc.Error_Message__c='';                    
                     }  
                     else{                     
                      XmlStreamReader reader = new XmlStreamReader(response.getBody());
                      boolean isSafeToGetNextXmlElement = true;
                      //acc.Error_Message__c ='';
                      String Start ;
                      while(isSafeToGetNextXmlElement) {
                          // Start at the beginning of the book and make sure that it is a book                                 
                           if (reader.getEventType() == XmlTag.START_ELEMENT) {
                               if(String.ValueOf(reader.getLocalName())=='Message') {
                                   Start = 'Message';
                               }
                               else {
                                   Start='';
                               }
                           }
                            if(Start=='Message') {
                                if (reader.getEventType() == XmlTag.CHARACTERS) {
                                  // if(reader.getText().Trim()!=null && reader.getText().Trim()!=' ')
                                       //acc.Error_Message__c+= '- '+reader.getText();
                                }                                        
                            }      
                            // Always use hasNext() before calling next() to confirm 
                            // that we have not reached the end of the stream
                            if (reader.hasNext()) {
                                reader.next();
                            } else {                                
                                isSafeToGetNextXmlElement = false;
                                break;
                             }
                       //  objItem.Error_Message__c=reader.getText();
                        }
                    
                 }
                                           
             }
        
        }    

}