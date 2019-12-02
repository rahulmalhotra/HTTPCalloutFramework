/*
* Application Name:- HTTPCalloutFramework
* License:- BSD 3-Clause "New" or "Revised" License
* Created:- 27/11/2019
* Last Updated:- 01/12/2019
* Description:- This is the custom exception class with error messages
* Contributors:-
*    1. Rahul Malhotra
*/
public class HTTPCalloutFrameworkException extends Exception {
    public static String CUSTOM_METADATA_NOT_FOUND = 'Unable to query custom metadata. Make sure you\'ve passed the correct developer name.';
    public static String MOCK_NOT_FOUND = 'Response Mock not found for the current request URL';
}