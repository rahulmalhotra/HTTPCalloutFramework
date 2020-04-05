/*
* Application Name:- HTTPCalloutFramework
* License:- BSD 3-Clause "New" or "Revised" License
* Created:- 07/12/2019
* Last Updated:- 05/04/2020
* Description:- This is the test class for HTTPCalloutAsyncService class.
*               Test Coverage:- HttpCalloutAsyncService.cls (100%)
* Dependencies:- TestMetadata record in HTTPCalloutConfiguration__mdt
* Contributors:-
*    1. Rahul Malhotra
*/
@isTest
public class HTTPCalloutAsyncServiceTest {

    /*
    * Initializing constants
    */
    private static final String CUSTOM_METADATA_NAME = 'TestMetadata';
    private static final String RESPONSE_BODY = '{"output":"Test Output"}';
    private static final Integer RESPONSE_SUCCESS = 200;
    private static final Integer TIMEOUT = 120;

    /*
    * Testing with predefined custom metadata record
    */
    @isTest
    public static void testWithCustomMetadata() {
        Test.startTest();
        List<HTTPResponse> mockResponses = new List<HTTPResponse>();
        HTTPCalloutServiceMock mock = new HTTPCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(TIMEOUT, new List<String>{ CUSTOM_METADATA_NAME });
        Continuation con = service.sendRequest('getAsyncCalloutResponse');
        Map<String, HTTPRequest> requests = con.getRequests();
        System.assert(requests.size() == 1);
        for(String requestLabel : service.getRequestLabels()) {
            HTTPRequest request = requests.get(requestLabel);
            HTTPresponse response = mock.respond(request);
            System.assert(request!=null);
            System.assert(response!=null);
            mockResponses.add(response);
            Test.setContinuationResponse(requestLabel, response);
        }
        List<HTTPResponse> responses = service.getResponse(service.getRequestLabels());
        System.assertEquals(mockResponses[0].getBody(), responses[0].getBody());
        Test.stopTest();
    }

    /*
    * Testing with predefined custom metadata record and no timeout
    */
    @isTest
    public static void testWithCustomMetadataAndNoTimeout() {
        Test.startTest();
        HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(null, new List<String>{ CUSTOM_METADATA_NAME });
        System.assertEquals(120, service.getRequestTimeout());
        service.setRequestTimeout(40);
        System.assertEquals(40, service.getRequestTimeout());
        service.setContinuationState('Test State');
        System.assertEquals('Test State', service.getContinuationState());
        Map<String, HTTPRequest> requestMap = service.getRequestMap();
        HTTPRequest request = requestMap.get(CUSTOM_METADATA_NAME);
        System.assertEquals(true, request.getCompressed());
        request.setCompressed(false);
        requestMap.put(CUSTOM_METADATA_NAME, request);
        service.setRequestMap(requestMap);
        System.assertEquals(false, service.getRequestMap().get(CUSTOM_METADATA_NAME).getCompressed());
        Test.stopTest();
    }

    /*
    * Testing without custom metadata record and request limit exceeded
    */
    @isTest
    public static void testWithoutCustomMetadataRequestLimitExceeded() {
        Test.startTest();
        HTTPCalloutService service = new HTTPCalloutService(CUSTOM_METADATA_NAME);
        try {
            HTTPCalloutAsyncService service1 = new HTTPCalloutAsyncService(TIMEOUT, new List<HTTPRequest>{ service.getRequest(), service.getRequest(), service.getRequest(), service.getRequest() });
        } catch(Exception e) {
            System.assertEquals(HTTPCalloutFrameworkException.CONTINUATION_LIMIT_EXCEEDED, e.getMessage());
        }
        Test.stopTest();
    }

    /*
    * Testing without custom metadata record
    */
    @isTest
    public static void testWithoutCustomMetadata() {
        Test.startTest();
        List<HTTPResponse> mockResponses = new List<HTTPResponse>();
        HTTPCalloutServiceMock mock = new HTTPCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        HTTPCalloutService service = new HTTPCalloutService(CUSTOM_METADATA_NAME);
        HTTPCalloutAsyncService service1 = new HTTPCalloutAsyncService(TIMEOUT, new List<HTTPRequest>{ service.getRequest(), service.getRequest(), service.getRequest() });
        Continuation con = service1.sendRequest('getAsyncCalloutResponse');
        Map<String, HTTPRequest> requests = con.getRequests();
        System.assert(requests.size() == 3);
        for(String requestLabel : service1.getRequestLabels()) {
            HTTPRequest request = requests.get(requestLabel);
            HTTPresponse response = mock.respond(request);
            System.assert(request!=null);
            System.assert(response!=null);
            mockResponses.add(response);
            Test.setContinuationResponse(requestLabel, response);
        }
        List<HTTPResponse> responses = service1.getResponse(service1.getRequestLabels());
        System.assertEquals(mockResponses[0].getBody(), responses[0].getBody());
        System.assertEquals(mockResponses[1].getBody(), responses[1].getBody());
        System.assertEquals(mockResponses[2].getBody(), responses[2].getBody());
        Test.stopTest();
    }

    /*
    * Testing with predefined custom metadata record and request limit exceeded
    */
    @isTest
    public static void testWithCustomMetadataRequestLimitExceeded() {
        Test.startTest();
        try {
            HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(TIMEOUT, new List<String>{ CUSTOM_METADATA_NAME, CUSTOM_METADATA_NAME, CUSTOM_METADATA_NAME, CUSTOM_METADATA_NAME });
        } catch(Exception e) {
            System.assertEquals(HTTPCalloutFrameworkException.CONTINUATION_LIMIT_EXCEEDED, e.getMessage());
        }
        Test.stopTest();
    }
}