/*
* Application Name:- HTTPCalloutFramework
* License:- BSD 3-Clause "New" or "Revised" License
* Created:- 27/11/2019
* Last Updated:- 05/04/2020
* Description:- This is the service class for performing HTTP Callouts
* Contributors:-
*    1. Rahul Malhotra
*/
public class HTTPCalloutService {

    HTTPCalloutConfiguration__mdt calloutMetadata;
    String endpointURL, requestMethod, requestBody, requestCertificate;
    Blob requestBodyAsBlob;
    Dom.Document requestBodyAsDocument;
    Integer requestTimeout;
    Boolean isCompressedRequest;
    Map<String, String> urlParametersMap;
    Map<String, String> headerParametersMap;
    static final String TYPE_URL_PARAMETERS = 'URL_PARAMETERS';
    static final String TYPE_HEADER_PARAMETERS = 'HEADER_PARAMETERS';
    HTTPRequest request;

    /*
    * Getters and Setters - Begin
    */
	public String getEndpointURL() {
		return endpointURL;
	}

	public void setEndpointURL(String endpointURL) {
		this.endpointURL = endpointURL;
	}

	public String getRequestMethod() {
		return requestMethod;
	}

	public void setRequestMethod(String requestMethod) {
		this.requestMethod = requestMethod;
	}

	public String getRequestBody() {
		return requestBody;
	}

	public void setRequestBody(String requestBody) {
		this.requestBody = requestBody;
	}

	public Blob getRequestBodyAsBlob() {
		return requestBodyAsBlob;
	}

	public void setRequestBodyAsBlob(Blob requestBodyAsBlob) {
		this.requestBodyAsBlob = requestBodyAsBlob;
	}

	public Dom.Document getRequestBodyAsDocument() {
		return requestBodyAsDocument;
	}

	public void setRequestBodyAsDocument(Dom.Document requestBodyAsDocument) {
		this.requestBodyAsDocument = requestBodyAsDocument;
	}

	public String getRequestCertificate() {
		return requestCertificate;
	}

	public void setRequestCertificate(String requestCertificate) {
		this.requestCertificate = requestCertificate;
	}

	public Integer getRequestTimeout() {
		return requestTimeout;
	}

	public void setRequestTimeout(Integer requestTimeout) {
		this.requestTimeout = requestTimeout;
	}

	public Boolean getIsCompressedRequest() {
		return isCompressedRequest;
	}

	public void setIsCompressedRequest(Boolean isCompressedRequest) {
		this.isCompressedRequest = isCompressedRequest;
	}

    public String getHeaderParameter(String key) {
        return headerParametersMap.get(key);
    }

    public Map<String, String> getHeaderParameters() {
        return headerParametersMap;
    }

    public void setHeaderParameter(String key, String value) {
        if(String.isNotEmpty(key) && String.isNotEmpty(value)) {
            headerParametersMap.put(key, value);
        }
    }

    public void removeHeaderParameter(String key) {
        headerParametersMap.remove(key);
    }

    public String getURLParameter(String key) {
        return urlParametersMap.get(key);
    }

    public Map<String, String> getURLParameters() {
        return urlParametersMap;
    }

    public void setURLParameter(String key, String value) {
        if(String.isNotEmpty(key) && String.isNotEmpty(value)) {
            urlParametersMap.put(key, value);
        } else if(String.isNotEmpty(key)) {
            urlParametersMap.put(key, value);
        }
    }

    public void removeURLParameter(String key) {
        urlParametersMap.remove(key);
    }
    /*
    * Getters and Setters - End
    */

    /*
    * Constructor
    */
    public HTTPCalloutService() {
        initialize();
    }

    /*
    * Constructor with Custom Metadata
    */
    public HTTPCalloutService(String customMetadataName) {
        try {
            calloutMetadata = [
                SELECT Method__c, URLParameters__c, HeaderParameters__c, Endpoint__c,
                Body__c, Timeout__c, CertificateName__c, IsCompressed__c
                FROM HTTPCalloutConfiguration__mdt
                WHERE DeveloperName =:customMetadataName
            ];
        } catch (Exception e) {
            throw new HTTPCalloutFrameworkException(HTTPCalloutFrameworkException.CUSTOM_METADATA_NOT_FOUND);
        }
        initialize();
    }

    /*
    * Initialization of class variables
    */
    private void initialize() {
        urlParametersMap = new Map<String, String>();
        headerParametersMap = new Map<String, String>();
        if(calloutMetadata != null) {
            endpointURL = calloutMetadata.Endpoint__c;
            requestMethod = calloutMetadata.Method__c;
            requestBody = calloutMetadata.Body__c;
            requestTimeout = Integer.valueOf(calloutMetadata.Timeout__c);
            isCompressedRequest = calloutMetadata.IsCompressed__c;
            requestCertificate = calloutMetadata.CertificateName__c;
            setUrlOrHeaderParameters(TYPE_URL_PARAMETERS, calloutMetadata.URLParameters__c);
            setUrlOrHeaderParameters(TYPE_HEADER_PARAMETERS, calloutMetadata.HeaderParameters__c);
        }
    }

    /*
    * This method is used to set URL or Header parameters from Custom Metadata
    */
    private void setUrlOrHeaderParameters(String parameterType, String parameterInfo) {
        if(String.isNotEmpty(parameterInfo)) {
            Map<String, String> parametersMap = new Map<String, String>();
            List<String> parameters = parameterInfo.split('\n');
            for(String urlParam : parameters) {
                List<String> keyValuePair = urlParam.trim().split(':');
                if(!keyValuePair.isEmpty()) {
                    if(keyValuePair.size() == 2) {
                        if(String.isNotEmpty(keyValuePair[0]) && String.isNotEmpty(keyValuePair[1])) {
                            parametersMap.put(keyValuePair[0], keyValuePair[1]);
                        }
                    } else if(
                        (keyValuePair.size() == 1) &&
                        (parameterType != TYPE_HEADER_PARAMETERS)
                    ) {
                        if(String.isNotEmpty(keyValuePair[0])) {
                            parametersMap.put(keyValuePair[0], '');
                        }
                    }
                }
            }
            if(parameterType == TYPE_URL_PARAMETERS) {
                urlParametersMap.putAll(parametersMap);
            } else if(parameterType == TYPE_HEADER_PARAMETERS) {
                headerParametersMap.putAll(parametersMap);
            }
        }
    }

    /*
    * This method is used to append the URL parameters at the end of URL
    */
    private void appendURLParameters() {
        Set<String> urlParamKeys = urlParametersMap.keySet();
        if(!urlParamKeys.isEmpty()) {
            endpointURL += '?';
            for(String urlParamKey : urlParamKeys) {
                endpointURL += urlParamKey + '=' + urlParametersMap.get(urlParamKey) + '&';
            }
            endpointURL = endpointURL.substringBeforeLast('&');
        }
    }

    /*
    * This method is used to set Header parameters using headerParametersMap
    */
    private void addHeaderParameters() {
        for(String key : headerParametersMap.keySet()) {
            request.setHeader(key, headerParametersMap.get(key));
        }
    }

    /*
    * This method is used to form HTTP Request
    */
    public void formHTTPRequest() {
        request = new HTTPRequest();
        addHeaderParameters();
        if(String.isNotEmpty(endpointURL)) {
            endpointURL = endpointURL.substringBefore('?');
            appendURLParameters();
            request.setEndpoint(endpointURL);
        }
        if(String.isNotEmpty(requestMethod)) {
            request.setMethod(requestMethod);
        }
        if(String.isNotEmpty(requestBody)) {
            request.setBody(requestBody);
        } else if((requestBodyAsBlob != null) &&  String.isNotEmpty(requestBodyAsBlob.toString())) {
            request.setBodyAsBlob(requestBodyAsBlob);
        } else if((requestBodyAsDocument != null) && String.isNotEmpty(requestBodyAsDocument.toXmlString())) {
            request.setBodyDocument(requestBodyAsDocument);
        }
        if(requestTimeout!=null) {
            request.setTimeout(requestTimeout);
        }
        if(String.isNotEmpty(requestCertificate)) {
            request.setClientCertificateName(requestCertificate);
        }
        if(isCompressedRequest!=null) {
            request.setCompressed(isCompressedRequest);
        }
    }

    /*
    * This method forms and returns the HTTP Request without sending (for debugging purposes)
    */
    public HTTPRequest getRequest() {
        formHTTPRequest();
        return request;
    }

    /*
    * This method is used to send HTTP Request and return the response
    */
    public HTTPResponse sendRequest() {
        formHTTPRequest();
        Http http = new Http();
        return http.send(request);
    }

    /*
    * This method is used to send HTTP Request received in parameter and return the response
    */
    public HTTPResponse sendRequest(HTTPRequest request) {
        Http http = new Http();
        return http.send(request);
    }
}