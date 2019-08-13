<%--*************************************************************
* Copyright (C) 2013 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>

    <h1>Case 1-A : OpenID Connect - Basic Client Profile</h1>

    <h2>Step 2 : Exchange Code for Access Token</h2>
    <p>Callback received from AS.  If an authorization code was received, it can be exchanged for an access token.</p>

<%
// Check for an error parameter from the callback
String error = request.getParameter("error");
if (error != null)
{
%>
    <div class="error">Error: <%=StringEscapeUtils.escapeHtml(error)%>
<%
    String errorDesc = request.getParameter("error_description");
    if (errorDesc != null) out.println(": " + StringEscapeUtils.escapeHtml(errorDesc));
%>
    </div>
<%
}
else
{
%>
    <h3>Endpoint Parameters</h3>
    <form name="input" action="token-endpoint-proxy.jsp" method="post">
        <table>
            <tr><th>Name</th><th>Value</th><th>Description</th></tr>
            <tr><td class="required">*client_id</td><td><input type="text" name="client_id" value="<%=ac_oic_client_id%>"/></td><td>The client identifier (as defined on the PingFederate client management page).</td></tr>
            <tr><td class="required">*grant_type</td><td><input type="text" name="grant_type" value="authorization_code"/></td><td>A value of authorization_code for grant type indicates that the received code from the callback will be exchanged for an access and refresh token pair.</td></tr>
            <tr><td class="required">*code</td><td><input type="text" name="code" id="code" value="<%=request.getParameter("code")%>"/></td><td>The authorization code received from the authorization server during the redirect interaction at the authorization endpoint when the response_type parameter is code.</td></tr>
            <tr><td>response_mode</td><td><input type="text" name="response_mode"/></td><td>The mode that values will be returned to the client. Possible values: fragment, query, form_post</td></tr>
            <tr><td>code_verifier</td><td><input type="text" name="code_verifier" /></td><td>The same value as the code_challenge sent in the previous step (if used). This proves that the client initiated the initial authorization request.</td></tr>
			<tr><td>client_secret</td><td><input type="text" name="client_secret" value="<%=ac_oic_client_secret%>"/></td><td>The client secret (as defined on the PingFederate client management page).  Not typically required with this flow.</td></tr>
			<tr><td>redirect_uri</td><td><input type="text" name="redirect_uri" /></td><td>This parameter is required only if the redirect_uri parameter was included in the authorization request that resulted in the issuance of the code, and the values must match. Similarly, the value must match the one configured for the client. PingFederate supports only a single redirection URI per client; therefore we recommend omitting the value here and on the authorization request.</td></tr>
            <tr><td>access_token_manager_id</td><td><input type="text" name="access_token_manager_id" /></td><td>The Instance ID of the desired access token manager. When specified, the PingFederate AS uses the desired access token management instance for the request if it is eligible.</td></tr>
            <tr><td>aud</td><td><input type="text" name="aud" /></td><td>The resource URI the client wants to access. The provided value is matched against resource URIs configured in access token management instances. When a match is found, the PingFederate AS uses the corresponding access token management instance for the request if it is eligible.</td></tr>

        </table>
		<p class="required">* Required</p>
	<input type="hidden" name="case1A" value="case1A">
        <p class="buttons"><input type="submit" value="Request Token" /></p>
    </form> 

    <script>
        if(window.location.hash) { 
            document.getElementById('code').value=window.location.hash.substring(window.location.hash.indexOf("=")+1)
        }
    </script>
<%
}
%>

<%@include file="footer.jsp" %>
