<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%--************************************************************
* Copyright (C) 2012 Ping Identity Corporation                 *
* All rights reserved.                                         *
*                                                              *
* The contents of this file are subject to the terms of the    *
* PingFederate Agentless Integration Kit Users Guide.          *
************************************************************--%>

<%--

This is a basic example of an Agentless SP integration with PingFederate.

--%>

<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.security.KeyManagementException"%>
<%@ page import="java.security.KeyStore"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.security.cert.Certificate"%>
<%@ page import="java.security.cert.CertificateException"%>
<%@ page import="java.security.cert.CertificateFactory"%>
<%@ page import="java.security.cert.X509Certificate"%>
<%@ page import="javax.net.ssl.*"%>
<%@ page import="org.apache.commons.codec.binary.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>

<%!
// Authentication Methods
public enum ADAPTER_AUTH_METHOD { HTTPBASIC, HTTPHEADERS, NONE } // BASIC, HEADER or NONE (none must use mutual auth)
public enum ADAPTER_INCOMING_FORMAT { JSON, QUERYSTRING }  // JSON or QUERYSTRING [INCOMING ATTRIBUTE FORMAT] (from App to PF)
public enum ADAPTER_OUTGOING_FORMAT { JSON, PROPERTIES } // JSON or PROPERTIES [OUTGOING ATTRIBUTE FORMAT] (from PF to APP)

// PingFederate URLs and endpoints
private final static String PF_BASE_URL = "https://localhost";
private final static String PF_PRIMARY_SSL_PORT = "9031";
private final static String PF_SECONDARY_SSL_PORT = "9032"; // Must match PF setting for Mutual TLS AuthN
private final static String PF_DROPOFF_URL = "/ext/ref/dropoff";
private final static String PF_PICKUP_URL = "/ext/ref/pickup";

// ReferenceID Adapter configuration
private final static String REFID_INSTANCE_ID = "spadapter";
private final static String REFID_USERNAME = "spuser"; // Config: [USER NAME]
private final static String REFID_PASSWORD = "sppassword"; // Config [PASS PHRASE]
private final static ADAPTER_AUTH_METHOD REFID_AUTH_METHOD = ADAPTER_AUTH_METHOD.HTTPBASIC; 
private final static ADAPTER_INCOMING_FORMAT REFID_INCOMING_ATTRIBUTE_FORMAT = ADAPTER_INCOMING_FORMAT.JSON;
private final static ADAPTER_OUTGOING_FORMAT REFID_OUTGOING_ATTRIBUTE_FORMAT = ADAPTER_OUTGOING_FORMAT.JSON;

// For certificate authentication
private final static boolean USE_MUTUAL_TLS_AUTH = false;
private final static String  CLIENT_KEY_FILE_PATH = "/FULL/PATH/TO/CERTIFICATES/sampleClientSSLCert.p12"; // Full pathname for PKCS12 (.p12) key file.
private final static String  CLIENT_KEY_FILE_PASSWORD = "password";
private final static String  SERVER_CERTIFICATE_PATH = "/FULL/PATH/TO/CERTIFICATES/pfserverSSLCert.crt"; //Full pathname to X.509 Server SSL cert file.
private final static boolean SKIP_HOSTNAME_VERIFICATION = true;
// Certificate details must match the values of the [ALLOWED SUBJECT DN] and/or [ALLOWED ISSUER DN]

/* 
  Adapter Configuration Summary:
  
  [AUTHENTICATION ENDPOINT] - authentication endpoint (entry point into adapter)
  [USER NAME] - client username (REFID_USERNAME)
  [PASS PHRASE] - client password (REFID_PASSWORD)
  [ALLOWED SUBJECT DN] - used for mutal TLS authn
  [ALLOWED ISSUER DN] - used for mutal TLS authn
  [LOGOUT SERVICE ENDPOINT] - used for SLO only (SLO endpoint)
  [ACCOUNT LINKING AUTHENTICATION ENDPOINT] - used for account linking
  [TRANSPORT MODE] - Browser to/from PF - Form Post or Query Param
  [REFERENCE DURATION] - REF validity duration (1 - 95 seconds)
  [REFERENCE LENGTH] - REF length
  [REQUIRE SSL/TLS] - if checked, App MUST use https to connect to PF
  [OUTGOING ATTRIBUTE FORMAT] - PF to App - JSON or Properties
  [INCOMING ATTRIBUTE FORMAT] - App to PF - JSON or Query Parameter
  [LOGOUT MODE] - used for SLO only - Front Channel or Back Channel 
  [SKIP HOSTNAME VALIDATION] - used for SLO only
*/

%>

<%

/*
** ADAPTER ENTRY POINT
*/

try
{
	// 1 - Gather the authentication attributes from the parameters
	// Depending on the [TRANSPORT MODE] config parameter you will receive these params via POST or GET
	
	String PARAM_TARGET_RESOURCE = request.getParameter("TargetResource");
	String PARAM_REFERENCE_VALUE = request.getParameter("REF");


	// 2 - Grab the attributes that correspond to the REF
	Map<String, String> returnAttributes = pickUpAttributesFromReferenceIdAdapter( PARAM_REFERENCE_VALUE );


	// 3 - Implement the local login process - create session, place a cookie, add a session to the DB
	// You should have:
	// authnCtx, partnerEntityID, instanceId, sessionid, authnInst + the attribute contract
	

	// 4 - Redirect to the application

%>

<h1>App</h1>
<p>You are authenticated</p>
<table border="0">
<tr><td>authnCtx</td><td><%= returnAttributes.get("authnCtx") %></td></tr>
<tr><td>partnerEntityID</td><td><%= returnAttributes.get("partnerEntityID") %></td></tr>
<tr><td>instanceId</td><td><%= returnAttributes.get("instanceId") %></td></tr>
<tr><td>sessionid</td><td><%= returnAttributes.get("sessionid") %></td></tr>
<tr><td>authnInst</td><td><%= returnAttributes.get("authnInst") %></td></tr>
<tr><td>subject</td><td><%= returnAttributes.get("subject") %></td></tr>
<tr><td>realm</td><td><%= returnAttributes.get("realm") %></td></tr>
</table>

<%
	//response.sendRedirect(PARAM_TARGET_RESOURCE);

} catch (Exception e) 
{
	// If something went wrong, log error and forward to error page.
	System.err.println( ""+new Date()+" signin.jsp caught exception: "+e );
	e.printStackTrace(System.err);
	request.setAttribute("errorMessage", e.toString());
	getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request, response);
}
%>

<%!
/** Pick up user attributes from the ReferenceID adapter using the the reference value received in the SSO request.
 *
 *  Uses URLConnection class to connect to ReferenceID adapter using HTTPS with a custom Trust Manager.
 *  This is for demonstration purposes only and SHOULD NOT BE USED IN PRODUCTION!  
 *
 *  Authenticate to the Reference Adapter using username and password passed via ONE of: 
 *     - HTTP Basic Authentication authorization header
 *     - Ping proprietary special request properties ping.uname and ping.pwd
 *
 *  In addition, can authenticate using SSL Certificate.
 *
 * @return Map of user attributes
 */
private Map<String,String> pickUpAttributesFromReferenceIdAdapter(String referenceValue) throws Exception
{
	// 1 - Get an SSL connection for the attribute dropoff service - use secondary port if certificate authentication specified
	URL pickupUrl = new URL(PF_BASE_URL +":" + ((USE_MUTUAL_TLS_AUTH) ? PF_SECONDARY_SSL_PORT : PF_PRIMARY_SSL_PORT) + PF_PICKUP_URL + "?REF=" + referenceValue);
	URLConnection urlConnection = pickupUrl.openConnection();


	// 2 - Identify the adapter to use.  Need to do if more than one ReferenceID adapter defined (get in good habits.. do it anyway..)
	
	urlConnection.setRequestProperty("ping.instanceId", REFID_INSTANCE_ID);


	// 3 - Authenticate to the dropoff service

	if (REFID_AUTH_METHOD == ADAPTER_AUTH_METHOD.HTTPBASIC) {
		// 3A - Authenticate using HTTP Basic Authentication; values Base64 encoded
		String basicAuth = REFID_USERNAME + ":" + REFID_PASSWORD;
		urlConnection.setRequestProperty("Authorization", "Basic " + Base64.encodeBase64String(basicAuth.getBytes()));
				
	} else if (REFID_AUTH_METHOD == ADAPTER_AUTH_METHOD.HTTPHEADERS) {
		// 3B - Authenticate using http header values
		urlConnection.setRequestProperty("ping.uname", REFID_USERNAME);
		urlConnection.setRequestProperty("ping.pwd", REFID_PASSWORD);
		
	} else if (REFID_AUTH_METHOD == ADAPTER_AUTH_METHOD.NONE) {
		// FAIL if we are not using Mutual TLS Auth
		if (USE_MUTUAL_TLS_AUTH) {
			throw new Exception("Mutual TLS is required if not using client authentication.");
		}
		
	} else {
		throw new Exception("Invalid reference adapter authentication method. Check the REFID_AUTH_METHOD variable.");
	}

	// 3C - and optionally - Mutual TLS Authentication
	if (USE_MUTUAL_TLS_AUTH) {
		configureCertificateAuthentication( urlConnection );
	} else {
		acceptAllCertificates( urlConnection );
	}


	// 4 - Get the attributes
	// Convert attributes from applicable format (according to the [OUTGOING ATTRIBUTE FORMAT] config item
	Map<String,String> userAttributes = new HashMap<String,String>();

	// Use UTF-8 if no encoding found in request.
    String encoding = urlConnection.getContentEncoding();
    InputStream is = urlConnection.getInputStream();
    InputStreamReader streamReader = new InputStreamReader(is, encoding != null ? encoding : "UTF-8");

	if (REFID_OUTGOING_ATTRIBUTE_FORMAT == ADAPTER_OUTGOING_FORMAT.JSON) {
	    
 	    JSONObject userAttributesJSON = (JSONObject)new JSONParser().parse(streamReader);

     	if ( userAttributesJSON == null || userAttributesJSON.size() == 0 ) {
     		throw new Exception( "Problem retrieving attributes from adapter!");
 	    }
 	    
 	    Iterator i = userAttributesJSON.keySet().iterator();
 	    
 	    while ( i.hasNext() ) {
 	    	String k = (String) i.next();
 	    	userAttributes.put(k, (String)userAttributesJSON.get(k));
 	    }
 	    
//  	    for (String jsonKey : userAttributesJSON.keySet()) {
//  	    	userAttributes.put(jsonKey, (String)userAttributesJSON.get(jsonKey));
//  	    }
	    
	} else if (REFID_OUTGOING_ATTRIBUTE_FORMAT == ADAPTER_OUTGOING_FORMAT.PROPERTIES) {
	
		Properties responseProperties = new Properties();
		responseProperties.load(streamReader);
		
 	    Iterator i = responseProperties.keySet().iterator();
 	    
 	    while ( i.hasNext() ) {
 	    	String k = (String) i.next();
 	    	userAttributes.put(k, (String)responseProperties.get(k));
 	    }

// 		for (String propsKey : responseProperties.keySet() ) {
// 			userAttributes.put(propsKey, (String)responseProperties.getProperty(propsKey));
// 		}
		
	} else {
		throw new Exception("Invalid outgoing format. Check the REFID_OUTGOING_ATTRIBUTE_FORMAT variable.");
	}

	return userAttributes;
}
%>

<%!
/** Drop off user attributes to the ReferenceID adapter and return the reference value string received in exchange.
 *
 *  Uses URLConnection class to connect to ReferenceID adapter using HTTPS with a custom Trust Manager.
 *  This is for demonstration purposes only and SHOULD NOT BE USED IN PRODUCTION!  
 *
 *  Authenticate to the Reference Adapter using username and password passed via ONE of: 
 *     - HTTP Basic Authentication authorization header
 *     - Ping proprietary special request properties ping.uname and ping.pwd
 *
 *  In addition, can authenticate using SSL Certificate.
 *
 * @return reference value
 */
private String dropOffAttributesToRefererenceIdAdapter(Map<String, String> returnAttributes) throws Exception
{
	// 1 - Get an SSL connection for the attribute dropoff service - use secondary port if certificate authentication specified
	String urlQueryString = "";

	if (REFID_INCOMING_ATTRIBUTE_FORMAT == ADAPTER_INCOMING_FORMAT.QUERYSTRING) {
		// Because we are using the querystring method, we need to include the attributes in the url
		urlQueryString = "?" + attributesToQueryString(returnAttributes);
	} else {
		urlQueryString = "";
	}
	
	URL dropOffUrl = new URL(PF_BASE_URL +":" + ((USE_MUTUAL_TLS_AUTH) ? PF_SECONDARY_SSL_PORT : PF_PRIMARY_SSL_PORT) + PF_DROPOFF_URL + urlQueryString);
	URLConnection urlConnection = dropOffUrl.openConnection();


	// 2 - Identify the adapter to use.  Need to do if more than one ReferenceID adapter defined (get in good habits.. do it anyway..)
	
	urlConnection.setRequestProperty("ping.instanceId", REFID_INSTANCE_ID);


	// 3 - Authenticate to the dropoff service

	if (REFID_AUTH_METHOD == ADAPTER_AUTH_METHOD.HTTPBASIC) {
		// 3A - Authenticate using HTTP Basic Authentication; values Base64 encoded
		String basicAuth = REFID_USERNAME + ":" + REFID_PASSWORD;
		urlConnection.setRequestProperty("Authorization", "Basic " + Base64.encodeBase64String(basicAuth.getBytes()));
				
	} else if (REFID_AUTH_METHOD == ADAPTER_AUTH_METHOD.HTTPHEADERS) {
		// 3B - Authenticate using http header values
		urlConnection.setRequestProperty("ping.uname", REFID_USERNAME);
		urlConnection.setRequestProperty("ping.pwd", REFID_PASSWORD);
		
	} else if (REFID_AUTH_METHOD == ADAPTER_AUTH_METHOD.NONE) {
		// FAIL if we are not using Mutual TLS Auth
		if (USE_MUTUAL_TLS_AUTH) {
			throw new Exception("Mutual TLS is required if not using client authentication.");
		}
		
	} else {
		throw new Exception("Invalid reference adapter authentication method. Check the REFID_AUTH_METHOD variable.");
	}

	// 3C - and optionally - Mutual TLS Authentication
	if (USE_MUTUAL_TLS_AUTH) {
		configureCertificateAuthentication( urlConnection );
	} else {
		acceptAllCertificates( urlConnection );
	}


	// 4 - Send the user attributes
	// Convert attributes to applicable format (according to the [INCOMING ATTRIBUTE FORMAT] config item
	JSONObject userAttributes = new JSONObject();

	if (REFID_INCOMING_ATTRIBUTE_FORMAT == ADAPTER_INCOMING_FORMAT.JSON)
	{
		for(String k : returnAttributes.keySet()) {
			userAttributes.put(k, returnAttributes.get(k));
		}

	} else if (REFID_INCOMING_ATTRIBUTE_FORMAT == ADAPTER_INCOMING_FORMAT.QUERYSTRING) {
		// We already included these up in step #1
	} else {
		throw new Exception("Invalid incoming format. Check the REFID_INCOMING_ATTRIBUTE_FORMAT variable.");
	}

	urlConnection.setDoOutput(true);
	OutputStreamWriter outputStreamWriter = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
 	userAttributes.writeJSONString(outputStreamWriter);
	outputStreamWriter.flush();
	outputStreamWriter.close();


	// 5 - Get the response and parse out the reference value from the JSON content
	String referenceValue = "";

	InputStreamReader streamReader = new InputStreamReader(urlConnection.getInputStream(), "UTF-8");
	
	if (REFID_OUTGOING_ATTRIBUTE_FORMAT == ADAPTER_OUTGOING_FORMAT.JSON) {
		referenceValue = (String) ((JSONObject) new JSONParser().parse(streamReader)).get("REF");
	} else if (REFID_OUTGOING_ATTRIBUTE_FORMAT == ADAPTER_OUTGOING_FORMAT.PROPERTIES) {
		Properties responseProperties = new Properties();
		responseProperties.load(streamReader);
		referenceValue = (String)responseProperties.getProperty("REF");
	} else {
		throw new Exception("Invalid outgoing format. Check the REFID_OUTGOING_ATTRIBUTE_FORMAT variable.");
	}

	return referenceValue;
}

private String attributesToQueryString(Map<String, String> attribs) throws Exception {

	StringBuilder queryString = new StringBuilder();

	try {

		for(String k : attribs.keySet()) {

			if(queryString.length() > 0) { queryString.append("&"); }
			
			queryString.append(URLEncoder.encode(k, "UTF-8")).append("=").append(URLEncoder.encode(attribs.get(k), "UTF-8"));
		}
		
	} catch (java.io.UnsupportedEncodingException ex) {
		throw new Exception("Exception when encoding... " + ex.getMessage());
	}
	
	return queryString.toString();
}

/** Configure urlConnection to accept all certificates. DO NOT USE IN PRODUCTION! **/
private void acceptAllCertificates(URLConnection urlConnection) throws Exception
{
	SSLContext sslContext = SSLContext.getInstance("TLS");
	sslContext.init(null, new TrustManager[] { new SimpleTrustManager() }, null);
	SSLSocketFactory socketFactory = sslContext.getSocketFactory();
	HttpsURLConnection httpsURLConnection = (HttpsURLConnection) urlConnection;
	httpsURLConnection.setSSLSocketFactory(socketFactory);
	if (SKIP_HOSTNAME_VERIFICATION)
	{
		httpsURLConnection.setHostnameVerifier(new SimpleHostnameVerifier());
	}
}


/** Configure urlConnection to accept specified certificate. */
private void configureCertificateAuthentication(URLConnection urlConnection) throws Exception
{
	
	InputStream keyInput = new FileInputStream(CLIENT_KEY_FILE_PATH);
	KeyStore keyStore = KeyStore.getInstance("PKCS12");
	keyStore.load(keyInput, CLIENT_KEY_FILE_PASSWORD.toCharArray());
	keyInput.close();
	KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance("SunX509", "SunJSSE");
	keyManagerFactory.init(keyStore, CLIENT_KEY_FILE_PASSWORD.toCharArray());
	KeyManager[] keyManager = keyManagerFactory.getKeyManagers();

	InputStream certStream = new FileInputStream(SERVER_CERTIFICATE_PATH);
	CertificateFactory cf = CertificateFactory.getInstance("X.509");
	Certificate certificate = certStream != null ? cf.generateCertificate(certStream) : null;
	SSLContext sslContext = SSLContext.getInstance("TLS");
	sslContext.init(keyManager, new TrustManager[] { new SimpleTrustManager((X509Certificate) certificate) }, null);
	SSLSocketFactory socketFactory = sslContext.getSocketFactory();

	HttpsURLConnection httpsURLConnection = (HttpsURLConnection) urlConnection;
	httpsURLConnection.setSSLSocketFactory(socketFactory);
	if (SKIP_HOSTNAME_VERIFICATION) {
		httpsURLConnection.setHostnameVerifier(new SimpleHostnameVerifier());
	}
	
}


/**
 * A simple X509TrustManager that will check the server certificate if one is specified, else trust all. This trust manager can be constructed
 * with a single trusted server certificate which will be checked by checkServerTrusted(). By default, no trusted certificate is specified.
 * 
 * DO NOT USE IN PRODUCTION!
 */
class SimpleTrustManager implements X509TrustManager
{
	 
	private X509Certificate trustedCertificate = null;

	/** Default constructor specifies null certificate. **/
	public SimpleTrustManager() {
	}

	/** Constructor specifies a trusted certificate which can be null. **/
	public SimpleTrustManager(X509Certificate trustedCertificate) {
		this.trustedCertificate = trustedCertificate;
	}

	/** All client certificates are trusted. **/
	public void checkClientTrusted(X509Certificate[] x509Certificates, String string) {
	}

	/**
	 * If trustedCertificate is not null, compare it with first element of testCertificates array.
	 * 
	 * @param testCertificates
	 *            certificate to test, only first element is used
	 * @throws CertificateException
	 *             if trustedCertificate does not match testCertificate[0]
	 */
	public void checkServerTrusted(X509Certificate[] testCertificates, String string) throws CertificateException {
		if (trustedCertificate != null && !testCertificates[0].equals(trustedCertificate)) {
			throw new CertificateException("Server cert does not match trusted certificate!");
		}
	}

	public X509Certificate[] getAcceptedIssuers() {
		return new X509Certificate[0];
	}
}

/** Simple HostnameVerifier implementation that accepts all hostnames. DO NOT USE IN PRODUCTION! **/
public class SimpleHostnameVerifier implements HostnameVerifier
{
	public boolean verify(String hostname, SSLSession session) {
		return true;
	}
}

%>