({
	getData : function(component, event, helper) {
		var fetchDataAction = component.get('c.fetchData');
        fetchDataAction.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var data = JSON.parse(response.getReturnValue());
                component.set('v.blogdata', data.blogData);
                component.set('v.appdata', data.appData);
                component.set('v.sessiondata', data.sessionData);
            }
        });
        $A.enqueueAction(fetchDataAction);
	}
})