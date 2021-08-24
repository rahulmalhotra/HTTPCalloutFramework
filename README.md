# HTTPCalloutFramework [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&logo=twitter)](https://twitter.com/intent/tweet?text=Check%20out%20this%20amazing%20callout%20framework%20for%20Apex%20HTTP%20Callouts.%20&url=https://github.com/rahulmalhotra/HTTPCalloutFramework&via=rahulcoder&hashtags=salesforce,sfdcstop,integration,salesforceohana)

HTTPCalloutFramework is a light weight framework for apex HTTP callouts in salesforce.

## Overview

HTTPCalloutFramework can be used to perform apex callouts to external systems. 
It has in-built apex classes that can be used to perform HTTPCallouts. 
The required information for the callout can be stored in the custom metadata named **HTTPCalloutConfiguration**.
The framework also consists of mock classes that can be used to define mocks for single
and multiple HTTP Callouts in a single transaction. The code used in the framework is already covered
so that you don't need to worry during the deployments.

### Prerequisites

There are no such pre-requisites for installing and using this framework. 
If you want to download the code in your local system, 
you can do it by the executing the below command or downloading the code directly as a zip file.

```
git clone https://github.com/rahulmalhotra/HTTPCalloutFramework.git
```

### Installing

HTTPCalloutFramework is very easy to use. You can install this application in your salesforce org as an unmanaged package or by using the **deploy to salesforce** button
present in the [deployment](#deployment) section of this readme. Installing this will add the following to your org :- 

1. HTTPCalloutService - Apex Class
2. HTTPCalloutServiceMock - Apex Class
3. HTTPCalloutServiceMultiMock - Apex Class
4. HTTPCalloutFrameworkException - Apex Class
5. HTTPCalloutServiceTest - Apex Class
6. HTTPCalloutConfiguration - Custom Metadata
7. TestMetadata - HTTPCalloutConfiguration record used in test class (should not be deleted)
8. SFDCStopBlogs - HTTPCalloutConfiguration record (Not included in unmanaged package. For demo purposes - can be deleted if installed through deploy to salesforce button)
9. HTTPCalloutConfiguration Layout - Layout for HTTPCalloutConfiguration metadata
10. SFDCStopAPI - Remote Site Settings record for SFDC Stop API (Not included in unmanaged package. For demo purposes - can be deleted if installed through deploy to salesforce button)

**HTTPCalloutFramework** is now ready for use.

## Deployment

You can deploy HTTPCalloutFramework directly to your org by clicking the button below

<a href="https://githubsfdeploy.herokuapp.com?owner=rahulmalhotra&repo=HTTPCalloutFramework&ref=gsdt">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

I have also created an unmanaged package so that you can install it in your org very easily if you don't wish to use the above button.

<a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t7F0000054q4h">Click Here</a> to install the package now in a production/developer environment.

or use the below URL:-

```
https://login.salesforce.com/packaging/installPackage.apexp?p0=04t7F0000054q4h
```

<a href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t7F0000054q4h">Click Here</a> to install the package now in a sandbox environment.

or use the below URL:-

```
https://test.salesforce.com/packaging/installPackage.apexp?p0=04t7F0000054q4h
```

## Usage

### Synchronous Callouts

Once installed you'll see the below custom metadata records created in your org:-

![HTTPCalloutConfigurationMetadata](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/HTTPCalloutConfigurationMetadata.JPG)

You'll have a SFDCStopBlogs metadata record along with a remote site setting record created for the same that you can use for testing the framework.
You can see that I have specified details of the request in the metadata itself.

![SFDCStopBlogsMetadataRecord](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/SFDCStopBlogsMetadataRecord.JPG)
![SFDCStopAPIRemoteSiteSettingsRecord](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/SFDCStopAPIRemoteSiteSettingsRecord.JPG)

You can copy and execute the below code in developer console to test the framework.
As you can see below, I have passed the custom metadata record developer name in the constructor.
Rest of the details are fetched automatically.

```apex
HttpCalloutService service = new HTTPCalloutService('SFDCStopBlogs');
System.debug(service.getRequest());
System.debug(service.sendRequest().getBody());
```

![DeveloperConsole](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/DeveloperConsole.JPG)

You can check the logs once the code is executed and it should have the output as below

![DeveloperConsoleLog](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/DeveloperConsoleLog.JPG)

Custom metadata and remote site setting record of SFDC Stop API are for demo purposes only. 
You can delete these records after installation and create your own records for HTTP callouts.
Make sure you **Do not delete the TestMetadata** record  of HTTPCalloutConfiguration custom metadata as it's being used in the test class for code coverage.

### Asynchronous Callouts

Now, let's jump on to the asynchronous apex callouts part. As you must be aware that the asynchronous callouts in apex are implemented using the [Continuation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Continuation.htm) class. The continuation class has different syntax for Visualforce Pages and Lightning Components. So, we're going to see the syntax for implementation in both cases. The good thing is that we have a single [HTTPCalloutAsyncService](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/force-app/main/default/classes/HTTPCalloutAsyncService.cls) class that we can use for both Visualforce Pages and Lightning Components.

#### Visualforce Page

The syntax of vf page controller is given below:-

```apex
HTTPCalloutAsyncService service {get;set;} // Creating an instance of HTTPCalloutAsyncService in controller
List<String> requestLabels; // This list will be used to store the request labels returned by the continuation process
// Define your action method (should have return type of Object)
public Object sendAsyncCalloutRequest() {
    service = new HTTPCalloutAsyncService(<Integer Timeout>, new List<String> {<CustomMetadata1>, <CustomMetadata2>, <CustomMetadata3>});       
    Continuation con = service.sendRequest('getAsyncCalloutResponse'); // Pass the callback method name in the parameter
    requestLabels = service.getRequestLabels(); // Storing the request labels returned by continuation
    return con; // Returning the continuation
}

// Define a callback method with the same name as passed in the sendRequest method of service class
public Object getAsyncCalloutResponse() {
    // Getting a list of responses by passing the request labels in the parameter
    List<HTTPResponse> responses = service.getResponse(requestLabels);
    // Process the responses (Set variables that are being used in VF Page)
    // Returning null to re-render the vf page
    return null;
}
```

The visualforce page should have an command button calling our controller method as shown below:-
```html
<apex:commandButton action="{!sendAsyncCalloutRequest}" value="Send Request"  reRender="<id of the block to re render>"/>
```

#### Lightning Component

The syntax of lightning component controller is given below:-

```apex
// This method will be called from lightning component (should have return type of Object)
@AuraEnabled(cacheable=true continuation=true)
public static Object fetchData() {
    HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(<Integer Timeout>, new List<String> {<CustomMetadata1>, <CustomMetadata2>, <CustomMetadata3>});
    return service.sendRequest('sendResponse'); // Pass the response method name in the parameter
}

// Define a callback method with the same name as passed in the sendRequest method of service class
@AuraEnabled(cacheable=true)
public static Object sendResponse(List<String> labels, Object state) {
    HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(<Integer Timeout>, new List<String> {<CustomMetadata1>, <CustomMetadata2>, <CustomMetadata3>});
    // Getting a list of responses by passing the request labels in the parameter
    List<HTTPResponse> responses = service.getResponse(labels);
    // Process the responses (Create a wrapper to send the response)
    // Returning the wrapper in JSON format back to lightning component
    return JSON.serialize(<wrapper>);
}
```

We should have call our apex method in lightning component helper as shown below:-
```js
var fetchDataAction = component.get('c.fetchData');
fetchDataAction.setCallback(this, function(response) {
  if(response.getState() === 'SUCCESS') {
    var data = JSON.parse(response.getReturnValue());
  }
}
$A.enqueueAction(fetchDataAction);
```

I have created a working example for both VF and Lightning that you can deploy in your org by clicking the below button. **Make sure that you've installed the framework in your org first otherwise the deployment of examples will fail.**

<a href="https://githubsfdeploy.herokuapp.com?owner=rahulmalhotra&repo=HTTPCalloutFramework&ref=asyncexample">
  <img alt="Deploy Asynchronous Examples to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

The working example consist of a VF Page named **SFDCStopCallout** and a Lightning Application named **BlogsContinuationApp** that will make an asynchronous continuation call to SFDC Stop APIs and fetch the data using our framework.

*Visualforce Page Output :-*

![SFDCStopCalloutVFPage](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/SFDCStopCalloutVFPage.JPG)

*Lightning Component Output :-*

![BlogsContinuationApp](https://github.com/rahulmalhotra/HTTPCalloutFramework/blob/master/Images/BlogsContinuationApp.JPG)

## Tools and Softwares used

You just need a salesforce org to run this application. 
If you want to make any changes in the code, you can do that by using the developer console provided by Salesforce. 
However I like to use VS Code IDE to keep a local copy of code on my system too. For regular deployments, 
I use SFDX Deploy Tool. So below are the tools or softwares I use personally :-

* [VS Code](https://code.visualstudio.com) - Open Source IDE for Salesforce
* [SFDX Deploy Tool](https://github.com/rahulmalhotra/SFDX-Deploy-Tool) - SFDX Deploy Tool for Windows and Mac

## Todo

- [ ] Find a way to cover code adding client certificate to HTTP callout in test class. 
It will increase the code coverage of HTTPCalloutService class to 100% (Current coverage:- 99%)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on code of conduct and the process for submitting pull requests.

## Authors

* **Rahul Malhotra** - [@rahulcoder](https://twitter.com/rahulcoder)

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE.md](LICENSE.md) file for details.
