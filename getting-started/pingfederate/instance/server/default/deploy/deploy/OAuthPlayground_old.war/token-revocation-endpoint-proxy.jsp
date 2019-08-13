<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>

<%! 
    public boolean hasValue(String str)
    {
        return ((str != null) && (str.length() > 0));
    }
%>
    <h1>Token Revocation Endpoint Proxy</h1>

    <p>This page is proxying the received parameters to the backend AS HTTPS token revocation endpoint: <span class="endpoint">/as/revoke_token.oauth2</span></p>
	<p>The HTTP POST method is used, as dictated by the OAuth 2.0 specification.  Parameters are sent using the Content-Type "application/x-www-form-urlencoded".  No response body should be present unless an error has occurred, in which case the response will have an HTTP 4XX status code and include error details in the returned JSON structure.</p>
	<p>Note that a 200 OK is returned even if the token was invalid (as mentioned in the specification).</p>
<%
String requestParms = "";
String fullRequestParms = "";

try
{
	
	// Proxy all received known parameters to backend call
	String request_body = request.getParameter("request_body");
	String client_id = request.getParameter("client_id");
	String client_secret = request.getParameter("client_secret");
	String grant_type = request.getParameter("grant_type");
	String redirect_uri = request.getParameter("redirect_uri");
	String response_type = request.getParameter("response_type");
    String response_mode = request.getParameter("response_mode");
	String code = request.getParameter("code");
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String validator_id = request.getParameter("validator_id");
	scope = request.getParameter("scope");
	String refresh_token = request.getParameter("refresh_token");
    String token = request.getParameter("token");
	String token_type_hint = request.getParameter("token_type_hint");
    String assertion = request.getParameter("assertion");
	String case1A = request.getParameter("case1A");
    String access_token_manager_id = request.getParameter("access_token_manager_id");
    String aud = request.getParameter("aud");

	String validate_grant_type = "urn:pingidentity.com:oauth2:grant_type:validate_bearer";
    
	URL url = new URL(base_pf_url + "/as/revoke_token.oauth2");
    URLConnection urlConnection = url.openConnection();
    HttpURLConnection httpURLConnection = (HttpURLConnection)urlConnection;
	
	// HTTP POST required according to OAuth 2.0 spec
	httpURLConnection.setRequestMethod("POST");
	httpURLConnection.setDoOutput(true);
    
    if (hasValue(request_body))
    {
        // Override for individual parameters
        requestParms = request_body;
        
        grant_type = "";
        String grant_type_var = "grant_type=";
        
        int start = requestParms.indexOf(grant_type_var);
        
        if (start != -1)
        {
            int end = requestParms.indexOf("&", start);
            
            if (end != -1)
                grant_type = requestParms.substring(start + grant_type_var.length(), end);
            else
                grant_type = requestParms.substring(start + grant_type_var.length());
        }
    }
    else
    {
        if (hasValue(client_id))
        {
            // Save as param for manual replay
            fullRequestParms += "client_id=" + client_id + "&";
            
            // Put client_id [and client_secret] in HTTP Authorization header
            // (because we can, and spec says we should in that case)
            String creds = client_id;
            if (hasValue(client_secret))
            {
                creds += ":" + client_secret;
                
                 // Save as param for manual replay
                fullRequestParms += "client_secret=" + client_secret + "&";
            }
            
            byte[] credBytes = creds.getBytes();
            httpURLConnection.setRequestProperty("Authorization", "Basic " +  new String(Base64.encodeBase64(credBytes)));
        }
        
        if (hasValue(grant_type)) requestParms += "grant_type=" + URLEncoder.encode(grant_type) + "&";
        if (hasValue(redirect_uri)) requestParms += "redirect_uri=" + URLEncoder.encode(redirect_uri) + "&";
        if (hasValue(response_type)) requestParms += "response_type=" + URLEncoder.encode(response_type) + "&";
        if (hasValue(response_mode)) requestParms += "response_mode=" + URLEncoder.encode(response_mode) + "&";
        if (hasValue(code)) requestParms += "code=" + URLEncoder.encode(code) + "&";
        if (hasValue(username)) requestParms += "username=" + URLEncoder.encode(username) + "&";
        if (hasValue(password)) requestParms += "password=" + URLEncoder.encode(password) + "&";
        if (hasValue(validator_id)) requestParms += "validator_id=" + URLEncoder.encode(validator_id) + "&";
        if (hasValue(scope)) requestParms += "scope=" + URLEncoder.encode(scope) + "&";
        if (hasValue(refresh_token)) requestParms += "refresh_token=" + URLEncoder.encode(refresh_token) + "&";
        if (hasValue(token)) requestParms += "token=" + URLEncoder.encode(token) + "&";
        if (hasValue(token)) requestParms += "token_type_hint=" + URLEncoder.encode(token_type_hint) + "&";
        if (hasValue(assertion)) requestParms += "assertion=" + URLEncoder.encode(assertion) + "&";
        if (hasValue(access_token_manager_id)) requestParms += "access_token_manager_id=" + URLEncoder.encode(access_token_manager_id) + "&";
        if (hasValue(aud)) requestParms += "aud=" + URLEncoder.encode(aud) + "&";
        
        if (requestParms.length() > 0) 
            requestParms = requestParms.substring(0, requestParms.length() - 1);
    }
    
    // Save for manual replay
    fullRequestParms += requestParms;
    
    OutputStreamWriter writer = new OutputStreamWriter(httpURLConnection.getOutputStream());
    writer.write(requestParms);
	writer.flush();
	
	int statusCode = httpURLConnection.getResponseCode();
    
    String contentType = httpURLConnection.getHeaderField("content-type");
    
	if ((statusCode == 200) || ((statusCode >=400) && (statusCode <= 499)))
	{
%>
<h2>HTTP Response (<%=statusCode%> <%=httpURLConnection.getResponseMessage()%>)</h2>
<h3>Content-Type: <%=contentType%></h3>
<%
		String line;
		String body = "";
		BufferedReader reader;
        
        // Read the error stream should an error case occur
        if (httpURLConnection.getErrorStream() != null)
        {
            reader = new BufferedReader(new InputStreamReader(httpURLConnection.getErrorStream()));
        }
        else
        {
            reader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
        }
        
		while ((line = reader.readLine()) != null)
		{
			body += line;
		}
		
		reader.close();

%>
		<h3>Response Body</h3>
        <textarea cols="72" rows="10" readonly="readonly"><%=body%></textarea>
<%
        if (contentType.toLowerCase().indexOf("application/json") != -1)
        {
            // Found JSON - parse it display nicely
            Object obj = JSONValue.parse(body);
            JSONObject jsonObj = (JSONObject)obj;
            Iterator iterator = jsonObj.keySet().iterator();  
%>
		<h3>Parsed JSON</h3>
		<table  style="table-layout:fixed">
            <tr><th>Name</th><th>Value</th><th>Action</th></tr>
<%
            while (iterator.hasNext())
            {
                String key = iterator.next().toString();  
                String value = "";
				
                if (jsonObj.get(key) != null)
                {
                    value = jsonObj.get(key).toString();
                }
                
                out.println("<tr><td>" + key + "</td><td  style=\"word-wrap: break-word;\">" + value +  "</td><td></td></tr>");
            }
        }
%>
		</table>
<%
	}
	else
	{
		throw new IOException("Unable to retrieve data via a back channel. HTTP " + statusCode + ": " + httpURLConnection.getResponseMessage());
	}
	
    writer.close();
}
catch (Exception e)
{
%>
    <div class="error">An exception occurred while proxying request to backend: <%=e%></div>
<%
}
%>
<br>
<hr>
<script>
function toggleAdvanced(){
	objLink = document.getElementById("advanced_disclosure");
	objAdvanced = document.getElementById("advanced");
	if (objLink.innerHTML == "&gt;&gt;"){
		objLink.innerHTML = "&lt;&lt;";
		objAdvanced.style.display = "block";
	}else{
		objLink.innerHTML = "&gt;&gt;";
		objAdvanced.style.display = "none";
	}
}
</script>

<h2>Advanced <a href="javascript:toggleAdvanced();" id="advanced_disclosure">&gt;&gt;</a></h2>
<div id="advanced" style="display:none">
<h2>HTTP POST Request</h2>
<p>The following is a summary of the previously sent HTTP POST request (with the exception of client credentials now being HTTP parameters instead of in the Authorization header).  The request body can be manually adjusted here and resent for testing purposes.</p>
<p>Note: Some requests (such as authorization code for token exchange) will result in an error response if re-sent 'as is' since they are one time operations.</p>
<h3>Request Body</h3>
<form method="post">
    <textarea name="request_body" cols="72" rows="10"><%=fullRequestParms%></textarea>
    <p class="buttons"><input type="submit" value="Send Request" /></p>
</form>
</div>
<%@include file="footer.jsp" %>
