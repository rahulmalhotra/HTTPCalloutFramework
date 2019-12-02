/*
* Application Name:- HTTPCalloutFramework
* License:- BSD 3-Clause "New" or "Revised" License
* Created:- 28/11/2019
* Last Updated:- 02/12/2019
* Description:- This is the test class for HTTPCalloutService class.
*               Test Coverage:- HttpCalloutService.cls (99%), HTTPCalloutFrameworkException.cls (100%)
* Dependencies:- TestMetadata record in HTTPCalloutConfiguration__mdt
* Contributors:-
*    1. Rahul Malhotra
*/
@isTest
public class HTTPCalloutServiceTest {

    /*
    * Initializing constants
    */
    private static String CUSTOM_METADATA_NAME = 'TestMetadata';
    private static String ENDPOINT = 'https://www.test.com';
    private static String METHOD = 'POST';
    private static String REQUEST_BODY = '{"input":"Test Input"}';
    private static String RESPONSE_BODY = '{"output":"Test Output"}';
    private static Integer RESPONSE_SUCCESS = 200;
    private static Integer TIMEOUT = 120000;
    private static Boolean ISCOMPRESSED = true;
    private static String KEY1 = 'key1';
    private static String KEY2 = 'key2';
    private static String VALUE1 = 'value1';
    private static String VALUE2 = 'value2';
    private static String CERTIFICATE = 'Test Certificate';

    /*
    * Testing with predefined custom metadata record
    */
    @isTest
    public static void testWithCustomMetadata() {
        Test.startTest();
        HTTPCalloutServiceMock testMock = new HTTPCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        HTTPCalloutService service = new HTTPCalloutService(CUSTOM_METADATA_NAME);
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        Test.stopTest();
    }

    /*
    * Testing with wrong custom metadata record to cover the custom exception scenario
    */
    @isTest
    public static void testWithWrongCustomMetadata() {
        Test.startTest();
        try {
            HTTPCalloutService service = new HTTPCalloutService('TestMetadata1');
        } catch(Exception e) {
            System.assertEquals(HTTPCalloutFrameworkException.CUSTOM_METADATA_NOT_FOUND, e.getMessage());
        }
        Test.stopTest();
    }

    /*
    * Testing with custom metadata and wrong certificate
    * to cover the getters and setters for client certificate
    */
    @isTest
    public static void testWithCustomMetadataWrongCertificate() {
        Test.startTest();
        HTTPCalloutServiceMock testMock = new HTTPCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        HTTPCalloutService service = new HTTPCalloutService(CUSTOM_METADATA_NAME);
        service.setRequestCertificate(CERTIFICATE);
        System.assertEquals(CERTIFICATE, service.getRequestCertificate());
        Test.stopTest();
    }

    /*
    * Testing without custom metadata
    */
    @isTest
    public static void testWithoutCustomMetadata() {
        Test.startTest();
        HTTPCalloutServiceMock testMock = new HTTPCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        // Initializing service and testing all the getters and setters
        HTTPCalloutService service = new HTTPCalloutService();
        service.setEndpointURL(ENDPOINT);
        System.assertEquals(ENDPOINT, service.getEndpointURL());
        service.setRequestMethod(METHOD);
        System.assertEquals(METHOD, service.getRequestMethod());
        service.setRequestBody(REQUEST_BODY);
        System.assertEquals(REQUEST_BODY, service.getRequestBody());
        service.setRequestTimeout(TIMEOUT);
        System.assertEquals(TIMEOUT, service.getRequestTimeout());
        service.setIsCompressedRequest(ISCOMPRESSED);
        System.assertEquals(ISCOMPRESSED, service.getIsCompressedRequest());
        service.setHeaderParameter(KEY1, VALUE1);
        System.assertEquals(VALUE1, service.getHeaderParameter(KEY1));
        service.setHeaderParameter(KEY2, VALUE2);
        System.assertEquals(VALUE2, service.getHeaderParameter(KEY2));
        service.removeHeaderParameter(KEY2);
        System.assertEquals(null, service.getHeaderParameter(KEY2));
        Map<String, String> headerParams = service.getHeaderParameters();
        System.assertEquals(VALUE1, headerParams.get(KEY1));
        service.setURLParameter(KEY1, VALUE1);
        System.assertEquals(VALUE1, service.getURLParameter(KEY1));
        service.setURLParameter(KEY2, VALUE2);
        System.assertEquals(VALUE2, service.getURLParameter(KEY2));
        service.removeURLParameter(KEY2);
        System.assertEquals(null, service.getURLParameter(KEY2));
        service.setURLParameter(KEY2, null);
        Map<String, String> urlParams = service.getURLParameters();
        System.assertEquals(VALUE1, urlParams.get(KEY1));
        System.assertEquals(null, urlParams.get(KEY2));
        // Testing the request and response
        HTTPRequest testRequest = service.getRequest();
        System.assertEquals(METHOD, testRequest.getMethod());
        System.assertEquals(ENDPOINT + '?key1=value1&key2=null', testRequest.getEndpoint());
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        Test.stopTest();
    }

    /*
    * Testing with custom metadata and multiple requests
    * Covered the successful request and response
    * Covered the custom exception in the case of wrong endpoint
    */
    @isTest
    public static void testWithCustomMetadataMultipleRequests() {
        Test.startTest();
        // Initializing multi mock class
        HTTPCalloutServiceMultiMock testMultiMock = new HTTPCalloutServiceMultiMock();
        // Testing the successful response
        HTTPCalloutServiceMock testMock = new HTTPCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        testMultiMock.addCalloutMock(ENDPOINT + '?key1=&key2=value2', testMock);
        Test.setMock(HTTPCalloutMock.class, testMultiMock);
        HTTPCalloutService service = new HTTPCalloutService(CUSTOM_METADATA_NAME);
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        // Testing the custom exception in case of wrong URL
        service.setEndpointURL('https://www.wrongurl.com');
        try {
            service.sendRequest();
        } catch(Exception e) {
            System.assertEquals(HTTPCalloutFrameworkException.MOCK_NOT_FOUND, e.getMessage());
        }
        Test.stopTest();
    }
}