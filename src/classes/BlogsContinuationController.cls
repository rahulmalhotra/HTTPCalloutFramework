public class BlogsContinuationController {

    HTTPCalloutAsyncService service {get;set;}
    List<String> requestLabels;
    
    public class Record {
        public String id {get;set;}
        public String title {get;set;}
        public String url {get;set;}
    }

    public class BlogsWrapper {
        public String author {get;set;}
        public List<Record> blogs {get;set;}                
	}

    public class AppsWrapper {
        public String author {get;set;}
        public List<Record> apps {get;set;}                
	}

    public class SessionsWrapper {
        public String author {get;set;}
        public List<Record> sessions {get;set;}                
	}

    public BlogsWrapper bWrapper{get;set;}
    public AppsWrapper aWrapper{get;set;}
    public SessionsWrapper sWrapper{get;set;}
    
    public Object sendAsyncCalloutRequest() {
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
        service = new HTTPCalloutAsyncService(40, new List<HttpRequest> {req, req1, req2});        
		*/
        service = new HTTPCalloutAsyncService(40, new List<String> {'SFDCStopBlogs','SFDCStopApps','SFDCStopSessions'});        
        Continuation con = service.sendRequest('getAsyncCalloutResponse');
        requestLabels = service.getRequestLabels();
        return con;
    }

    public Object getAsyncCalloutResponse() {
        List<HTTPResponse> responses = service.getResponse(requestLabels);
        bWrapper = (BlogsWrapper) JSON.deserialize(responses[0].getBody(), BlogsWrapper.class);
        aWrapper = (AppsWrapper) JSON.deserialize(responses[1].getBody(), AppsWrapper.class);
        sWrapper = (SessionsWrapper) JSON.deserialize(responses[2].getBody(), SessionsWrapper.class);
        return null;
    }
}