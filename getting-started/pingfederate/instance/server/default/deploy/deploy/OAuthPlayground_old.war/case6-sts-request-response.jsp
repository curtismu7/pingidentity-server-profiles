<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="javax.xml.xpath.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>
<script type="text/javascript">
    eraseCookie();
</script>

<%
try
{
    String stsRequest = request.getParameter("sts_request");
    
    if (stsRequest == null)
    {
        throw new Exception("Required parameter sts_request is null.");
    }
    
    URL url = new URL(base_pf_url + "/idp/sts.wst");
    URLConnection urlConnection = url.openConnection();
    HttpURLConnection httpURLConnection = (HttpURLConnection)urlConnection;
	
	httpURLConnection.setRequestMethod("POST");
    httpURLConnection.setRequestProperty("content-type", "application/soap+xml");
	httpURLConnection.setDoOutput(true);
    
    OutputStreamWriter writer = new OutputStreamWriter(httpURLConnection.getOutputStream());
    writer.write(stsRequest);
	writer.flush();  
    
%>
    <h1>Case 6 : OAuth SAML Bearer Profile</h1>

    <h2>Step 2 : Handle STS Response</h2>
    <p>Security token request sent to the PingFederate STS.  Response details are summarized below.</p>

<%
    int statusCode = httpURLConnection.getResponseCode();
    
    String contentType = httpURLConnection.getHeaderField("content-type");
    
%>
<h3>HTTP Response (<%=statusCode%> <%=httpURLConnection.getResponseMessage()%>)</h3>
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
    if (statusCode == 200)
    {
        // Parse XML
        DocumentBuilder db;
        DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
        db = docBuilderFactory.newDocumentBuilder();
        
        ByteArrayInputStream inStream = new ByteArrayInputStream(body.getBytes());
        Document doc = db.parse(inStream);
        
        XPathExpression xPathExpr;
        XPathFactory xpathFactory = XPathFactory.newInstance();
        
        XPath xPath = xpathFactory.newXPath();
        xPathExpr = xPath.compile("Envelope/Body/RequestSecurityTokenResponseCollection/RequestSecurityTokenResponse/RequestedSecurityToken/BinarySecurityToken");	
        
        String token = (String)xPathExpr.evaluate(doc, XPathConstants.STRING);
%>
        <h3>SAML Assertion Token (Base 64 Encoded)</h3>
        <textarea cols="72" rows="10" readonly="readonly"><%=token%></textarea>
<%
        String decodedSaml = new String(Base64.decodeBase64(token));
%>
        <h3>SAML Assertion Token</h3>
        <textarea cols="72" rows="10" readonly="readonly"><%=decodedSaml%></textarea>
        
        <br>
        <br>
        <hr>

        <h2>Token Endpoint Request</h2>
        <p>Complete this form to submit the received Assertion to the PingFederate OAuth token endpoint.  This will exchange the SAML Assertion for an OAuth access token.</p>
        <form name="input" action="token-endpoint-proxy.jsp" method="post" onsubmit="onSubmit(this)">
            <table>
                <tr><th>Name</th><th>Value</th><th>Description</th></tr>
                <tr><td class = "required">*assertion</td><td><input type="text" name="assertion" value="<%=token%>"/></td><td>The SAML Assertion (base 64 encoded with URL and filename safe alphabet) to exchange for an OAuth access token.</td></tr>
                <tr><td class = "required">*grant_type</td><td><input type="text" name="grant_type" value="urn:ietf:params:oauth:grant-type:saml2-bearer"/></td><td>Grant type for SAML 2.0 Bearer Assertion OAuth profile.</td></tr>
                <tr><td>client_id</td><td><input type="text" name="client_id" value="<%=saml_client_id%>"/></td><td>The client identifier (as defined on the PingFederate client management page).  May be omitted if anonymous clients are permitted to make extension grant type requests.</td></tr>
                <tr><td>client_secret</td><td><input type="text" name="client_secret" value="<%=saml_client_secret%>"/></td><td>The client secret (as defined on the PingFederate client management page).  Not typically required with this flow.</td></tr>
                <tr><td>access_token_manager_id</td><td><input type="text" name="access_token_manager_id" /></td><td>The Instance ID of the desired access token manager. When specified, the PingFederate AS uses the desired access token management instance for the request if it is eligible.</td></tr>
                <tr><td>aud</td><td><input type="text" name="aud" /></td><td>The resource URI the client wants to access. The provided value is matched against resource URIs configured in access token management instances. When a match is found, the PingFederate AS uses the corresponding access token management instance for the request if it is eligible.</td></tr>
            </table>
            <p class = "required">* Required</p>
            <p class="buttons"><input type="submit" value="Request Token" /></p>
        </form> 
<%
    }
}
catch (Exception e)
{
%>
    <div class="error">An unexpected exception occurred: <%=e%></div>
<%
}
%>    
<%@include file="footer.jsp" %>