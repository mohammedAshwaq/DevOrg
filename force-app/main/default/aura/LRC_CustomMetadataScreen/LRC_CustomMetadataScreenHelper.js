({
	fetchMetadataRecords : function(component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        
		var action = component.get("c.getMetadataRecords");
        action.setParams({
            'sObj' : component.get("v.selectedValue")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("@@AVAILABLE METADATA RECORDS: " + JSON.stringify(response.getReturnValue()));
                var dataWrap = response.getReturnValue();
                var cols = dataWrap.lstCols;
                var data = dataWrap.lstData;
                var columns = [];
                for(var index = 0 ;index < cols.length; index++){
                    if(cols[index].fieldName.includes('DeveloperName')){
                         columns.push({label: cols[index].fieldLabel, fieldName: cols[index].fieldName, type: cols[index].fieldType, editable: false, typeAttributes: { required: true }});
                    }else{
                         columns.push({label: cols[index].fieldLabel, fieldName: cols[index].fieldName, type: cols[index].fieldType, editable: true, typeAttributes: { required: true }});
                    }
                }
                component.set('v.columns', columns);
                component.set("v.data", data); 
				this.filter(component, event, helper);
               
                $A.util.toggleClass(spinner, 'slds-hide');
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        this.showToast(errors[0].message,'Error','error');
                    }
                } else {
                   this.showToast('Unknown Erro','Error','error');
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    filter: function(component, event, helper) {
        var data = component.get("v.data"),
            term = component.get("v.filter"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            //results = data.filter(row=>regex.test(row.DeveloperName) || regex.test(row.MasterLabel));
            results = data.filter(function(row){ return (regex.test(row.DeveloperName) || regex.test(row.MasterLabel))});
        	
        } catch(e) {
            // invalid regex, use full list
        }
        if(!$A.util.isEmpty(results)){
            for(var index = 0; index < results.length; index++){
                results[index].rowId = "row-"+index;
            }
            component.set("v.filteredData", results);
        }else{
            component.set("v.filteredData", data);
        }
    },

    
    csvToJson : function (component,csv) {
        //console.log('@@@ Incoming csv = ' + csv);
        var arr = []; 
        arr =  csv.split('\n');
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            if(arr[i].length > 0){
                var data = arr[i].split(',');
                var obj = {};
                for(var j = 0; j < data.length; j++) {
                    obj[headers[j].trim()] = data[j].trim();
                }
                jsonObj.push(obj);
            }
        }
        var json = JSON.stringify(jsonObj);
        //console.log('@@@JSON STR: '+ json);
        return json;
    },
    
    readFile: function (component, event, helper) {
		//var fileInput = component.find("file").getElement();
        var fileInput = event.getSource().get("v.files");
        var file = fileInput.files[0];
        if (file) {
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            
            reader.onload = function (evt) {
                var csv = evt.target.result;
                //console.log('@@@ csv file contains'+ csv);
                var result = helper.csvToJson(component,csv);
                helper.createMetadataFromCSV(component,result);
            }
            reader.onerror = function (evt) {
                this.showToast($A.get("$Label.c.LRC_Error_Reading_File"),'Error','error');
            }
        }    
    },
    
    createMetadataFromCSV : function(component, result){
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        
        var action = component.get("c.saveCSVRecords");
        action.setParams({
            'sObj' : component.get("v.selectedValue"),
            'jsonStr' : result
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.fileName", "");
                component.set("v.isUploadButtonDisabled", true);
                //console.log("@@CSV SAVE STATUS: " + JSON.stringify(response.getReturnValue()));
                var successLabel = $A.get("$Label.c.LRC_Success_Message");
				this.showToast(successLabel,'Success','success');                    
                //setTimeout($A.getCallback(() => this.fetchMetadataRecords(component)), 20000);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        this.showToast(errors[0].message,'Error','error');
                    }
                } else {
                    this.showToast("Unknown error",'Error','error');
                }
            }
            $A.util.toggleClass(spinner, 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    
    saveEdition : function(component, event, draftValues){
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        
    	var action = component.get("c.saveRecords");
        action.setParams({
            'sObj' : component.get("v.selectedValue"),
            'draftValues' : JSON.stringify(draftValues),
            'data' : JSON.stringify(component.get("v.filteredData"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("@@RECORDS SAVE STATUS: " + JSON.stringify(response.getReturnValue()));
                if(JSON.stringify(response.getReturnValue()).includes("SUCCESS")){
                    component.set("v.draftValues" ,null);
                    var successLabel = $A.get("$Label.c.LRC_Success_Message");
                    this.showToast(successLabel,'Success','success');                    
					//this.showToast('The list will auto refresh after 20 secs or you can refresh it manually after some time to view the changes.','Information','info');
                    //setTimeout($A.getCallback(() => this.fetchMetadataRecords(component)), 20000);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                       //console.log("Error message: " + errors[0].message);
                       this.showToast(errors[0].message,'Error','error');
                    }
                } else {
                    this.showToast("Unknown error",'Error','error');
                }
            }
            $A.util.toggleClass(spinner, 'slds-hide');
        });
        $A.enqueueAction(action);
	},
    
        
    showToast : function(msg, title, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: msg,
            messageTemplate: msg,
            messageTemplateData: [{
                url: '/lightning/setup/DeployStatus/home',
                label: 'Deployment Status',
            	}
            ],
            duration:' 8000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    /*For future use
    setFocusedTabLabel : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Custom Metadata Editor"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    setFocusedTabIcon : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
                workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "custom:custom108",
                iconAlt: "Custom Metadata Editor"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    }
    */
})