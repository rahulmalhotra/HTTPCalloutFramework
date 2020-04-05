/*
* Application Name:- HTTPCalloutFramework
* License:- BSD 3-Clause "New" or "Revised" License
* Created:- 27/11/2019
* Last Updated:- 07/12/2019
* Description:- This is the custom exception class with error messages
* Contributors:-
*    1. Rahul Malhotra
*/
public class HTTPCalloutFrameworkException extends Exception {
    public static final String CUSTOM_METADATA_NOT_FOUND = 'Unable to query custom metadata. Make sure you\'ve passed the correct developer name.';
    public static final String MOCK_NOT_FOUND = 'Response Mock not found for the current request URL';
    public static final String CONTINUATION_LIMIT_EXCEEDED = 'You can add upto ' + HTTPCalloutAsyncService.CONTINUATION_LIMIT + ' callouts in a single continuation request.';
}