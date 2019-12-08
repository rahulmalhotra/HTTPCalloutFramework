public class BlogsContinuationLightningController {

    class Record {
        String id;
        String title;
        String url;
    }
    
    class BlogsWrapper {
        String author;
        List<Record> blogs;
    }
	    
    class AppsWrapper {
        String author;
        List<Record> apps;
    }

    class SessionsWrapper {
        String author;
        List<Record> sessions;
    }

    class ResponseWrapper {
        BlogsWrapper blogData;
        AppsWrapper appData;
        SessionsWrapper sessionData;
    }

    @AuraEnabled(cacheable=true continuation=true)
    public static Object fetchData() {
	    /*
		    You can also pass the list of requests in the constructor in case you don't want to use custom metadata
		*/
        /*
        HTTPRequest req = new HTTPRequest();
        req.setMethod('GET');
        req.setEndpoint('https://sfdcstop.herokuapp.com/blogs');
        HTTPRequest req1 = new HTTPRequest();
        req1.setMethod('GET');
        req1.setEndpoint('https://sfdcstop.herokuapp.com/apps');
        HTTPRequest req2 = new HTTPRequest();
        req2.setMethod('GET');
        req2.setEndpoint('https://sfdcstop.herokuapp.com/sessions');
        HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(40, new List<HttpRequest> {req, req1, req2});        
		*/
        HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(40, new List<String>{'SFDCStopBlogs', 'SFDCStopApps', 'SFDCStopSessions'});
        return service.sendRequest('sendResponse');
    }
    
    @AuraEnabled(cacheable=true)
    public static Object sendResponse(List<String> labels, Object state) {
        HTTPCalloutAsyncService service = new HTTPCalloutAsyncService(40, new List<String>{'SFDCStopBlogs', 'SFDCStopApps', 'SFDCStopSessions'});
        List<HTTPResponse> responses = service.getResponse(labels);
        BlogsWrapper bWrapper = (BlogsWrapper) JSON.deserialize(responses.get(0).getBody(), BlogsWrapper.class);
        AppsWrapper aWrapper = (AppsWrapper) JSON.deserialize(responses.get(1).getBody(), AppsWrapper.class);
        SessionsWrapper sWrapper = (SessionsWrapper) JSON.deserialize(responses.get(2).getBody(), SessionsWrapper.class);
        ResponseWrapper wrapper = new ResponseWrapper();
        wrapper.blogData = bWrapper;
        wrapper.appData = aWrapper;
        wrapper.sessionData = sWrapper;
        return JSON.serialize(wrapper);
    }
}