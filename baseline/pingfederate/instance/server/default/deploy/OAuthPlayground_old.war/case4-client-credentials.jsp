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

    <h1>Case 4 : Client Credentials</h1>

    <h2>Step 1 : Send Client Credentials</h2>
    <p>Enter the client's credentials that will be validated using the associated client configuration.</p>

    <h3>Endpoint Parameters</h3>
    <form name="input" action="token-endpoint-proxy.jsp" method="post" onsubmit="onSubmit(this)">
        <table>
            <tr><th>Name</th><th>Value</th><th>Description</th></tr>
            <tr><td class = "required">*client_id</td><td><input type="text" name="client_id" value="<%=cc_client_id%>"/></td><td>The client identifier as set in PingFederate.</td></tr>
            <tr><td class = "required">*client_secret</td><td><input type="text" name="client_secret" value="<%=cc_client_secret%>" /></td><td>The client secret as set in PingFederate.</td></tr>
            <tr><td class = "required">*grant_type</td><td><input type="text" name="grant_type" value="client_credentials"/></td><td>The value client_credentials indicates that the configured client identifier and secret alone are enough to request an access token.</td></tr>
            <tr><td>scope</td><td><input type="text" name="scope" /></td><td>The scope of the access request expressed as a list of space-delimited, case sensitive strings. Valid scope values are defined on the OAuth AS settings page, and requests for values not defined there result in an error response.</td></tr>
            <tr><td>access_token_manager_id</td><td><input type="text" name="access_token_manager_id" /></td><td>The Instance ID of the desired access token manager. When specified, the PingFederate AS uses the desired access token management instance for the request if it is eligible.</td></tr>
            <tr><td>aud</td><td><input type="text" name="aud" /></td><td>The resource URI the client wants to access. The provided value is matched against resource URIs configured in access token management instances. When a match is found, the PingFederate AS uses the corresponding access token management instance for the request if it is eligible.</td></tr>

        </table>
		<p class = "required">* Required</p>
        <p class="buttons"><input type="submit" value="Request Token" /></p>
    </form> 

<%@include file="footer.jsp" %>