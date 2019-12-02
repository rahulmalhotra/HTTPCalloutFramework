/*
* Application Name:- HTTPCalloutFramework
* License:- BSD 3-Clause "New" or "Revised" License
* Created:- 28/11/2019
* Last Updated:- 02/12/2019
* Description:- This is the mock class for multiple HTTP Callouts during testing
* Contributors:-
*    1. Rahul Malhotra
*/
@isTest
public class HTTPCalloutServiceMultiMock implements HTTPCalloutMock {

    Map<String, HTTPCalloutServiceMock> calloutMocks;

    /*
    * Constructor initializing the class variables
    */
    public HTTPCalloutServiceMultiMock() {
        calloutMocks = new Map<String, HTTPCalloutServiceMock>();
    }

    /*
    * Constructor initializing the class variables (from user input if available)
    */
    public HTTPCalloutServiceMultiMock(Map<String, HTTPCalloutServiceMock> calloutMocks) {
        this.calloutMocks = calloutMocks;
        if(this.calloutMocks == null) {
            calloutMocks = new Map<String, HTTPCalloutServiceMock>();
        }
    }

    /*
    * Adding a callout mock class instance to (URL - Mock) map
    */
    public void addCalloutMock(String endpoint, HTTPCalloutServiceMock calloutMock) {
        calloutMocks.put(endpoint, calloutMock);
    }

    /*
    * This method is used to generate and send a mock HTTP response for the incoming request
    * It also throws a custom exception in case the mock is not found for the input request URL
    */
    public HTTPResponse respond(HTTPRequest request) {
        HTTPCalloutServiceMock calloutMock = calloutMocks.get(request.getEndpoint());
        if(calloutMock != null) {
            return calloutMock.respond(request);
        } else {
            throw new HTTPCalloutFrameworkException(HTTPCalloutFrameworkException.MOCK_NOT_FOUND);
        }
    }
}