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

HTTPCalloutFramework is very easy to use. You can install this application in your salesforce org by using the **deploy to salesforce** button
present in the [deployment](#deployment) section of this readme. Installing this will add the following to your org :- 

1. HTTPCalloutService - Apex Class
2. HTTPCalloutServiceMock - Apex Class
3. HTTPCalloutServiceMultiMock - Apex Class
4. HTTPCalloutFrameworkException - Apex Class
5. HTTPCalloutServiceTest - Apex Class
6. HTTPCalloutConfiguration - Custom Metadata
7. TestMetadata - HTTPCalloutConfiguration record used in test class (should not be deleted)
8. SFDCStopBlogs - HTTPCalloutConfiguration record (For demo purposes - can be deleted)
9. HTTPCalloutConfiguration Layout - Layout for HTTPCalloutConfiguration metadata
10. SFDCStopAPI - Remote Site Settings record for SFDC Stop API (For demo purposes - can be deleted)

**HTTPCalloutFramework** is now ready for use.

## Deployment

You can deploy HTTPCalloutFramework directly to your org by clicking the button below

<a href="https://githubsfdeploy.herokuapp.com?owner=rahulmalhotra&repo=HTTPCalloutFramework&ref=gsdt">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

An alternative way can be to use [SFDX Deploy Tool](https://github.com/rahulmalhotra/SFDX-Deploy-Tool) for deployment.
For that you can download the zip directly and rename it to unpackaged
that can be used by placing it inside the metadata folder of the application structure

## Usage

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

## Tools and Softwares used

You just need a salesforce org to run this application. 
If you want to make any changes in the code, you can do that by using the developer console provided by Salesforce. 
However I like to use VS Code IDE to keep a local copy of code on my system too. For regular deployments, 
I use SFDX Deploy Tool. So below are the tools or softwares I use personally :-

* [VS Code](https://code.visualstudio.com) - Open Source IDE for Salesforce
* [SFDX Deploy Tool](https://github.com/rahulmalhotra/SFDX-Deploy-Tool) - SFDX Deploy Tool for Windows

## Todo

- [ ] Find a way to cover code adding client certificate to HTTP callout in test class. 
It will increase the code coverage of HTTPCalloutService class to 100% (Current coverage:- 99%)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on code of conduct and the process for submitting pull requests.

## Authors

* **Rahul Malhotra** - [@rahulcoder](https://twitter.com/rahulcoder)

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE.md](LICENSE.md) file for details.
