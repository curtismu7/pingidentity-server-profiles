<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>
<script type="text/javascript">
    eraseCookie();
</script>

    <h1>Case 2 : Implicit</h1>

    <h2>Step 1 : Request Authorization</h2>
    <p>The Client (for us - this tester application) first redirects the user to the Authorization Server (AS - PingFederate) to ask for authorization of an access token.  Since this is implicit type, the callback will contain the token details.</p>
    
    <h3>Endpoint Parameters</h3>
    <form name="input" action="<%=base_pf_url%>/as/authorization.oauth2" method="post" onsubmit="onSubmit(this)">
        <table>
            <tr><th>Name</th><th>Value</th><th>Description</th></tr>
            <tr><td class = "required">*client_id</td><td><input type="text" name="client_id" value="<%=im_client_id%>"/></td><td>The client identifier (as defined on the PingFederate client management page).</td></tr>
            <tr><td class = "required">*response_type</td><td><input type="text" name="response_type" value="token"/></td><td>A value of code results in the Authorization Code grant type while a value of token implies the Implicit grant type.</td></tr>
            <tr><td>response_mode</td><td><input type="text" name="response_mode"/></td><td>The mode that values will be returned to the client. Possible values: fragment, query, form_post</td></tr>
			<tr><td>client_secret</td><td><input type="text" name="client_secret" value="<%=ac_client_secret%>"/></td><td>The client secret (as defined on the PingFederate client management page).  Not typically required with this flow.</td></tr>
            <tr><td>redirect_uri</td><td><input type="text" name="redirect_uri" /></td><td>If present, the requested redirect_uri must match the one configured for the client.</td></tr>
            <tr><td>scope</td><td><input type="text" name="scope" /></td><td>The scope of the access request expressed as a list of space-delimited, case sensitive strings. Valid scope values are defined on the PingFederate OAuth AS settings page, and requests for values not defined there result in an error response.</td></tr>
            <tr><td>state</td><td><input type="text" name="state" /></td><td>An opaque value used by the client to maintain state between the request and callback. The OAuth AS includes sends this value back when redirecting the user-agent back to the client.</td></tr>
            <tr><td>idp</td><td><input type="text" name="idp" /></td><td>A PingFederate OAuth AS parameter indicating the Entity ID/Connection ID of the IdP with whom to initiate Browser SSO for user authentication.</td></tr>
            <tr><td>pfidpadapterid</td><td><input type="text" name="pfidpadapterid" /></td><td>A PingFederate OAuth AS parameter indicating the IdP Adapter Instance ID of the adapter to use for user authentication.</td></tr>
            <tr><td>access_token_manager_id</td><td><input type="text" name="access_token_manager_id" /></td><td>The Instance ID of the desired access token manager. When specified, the PingFederate AS uses the desired access token management instance for the request if it is eligible.</td></tr>
            <tr><td>aud</td><td><input type="text" name="aud" /></td><td>The resource URI the client wants to access. The provided value is matched against resource URIs configured in access token management instances. When a match is found, the PingFederate AS uses the corresponding access token management instance for the request if it is eligible.</td></tr>
        </table>
	<p class = "required">* Required</p>
    <p class="buttons"><input type="submit" value="Request Authorization (/as/authorization.oauth2)" /></p>
    </form>

<%@include file="footer.jsp" %>