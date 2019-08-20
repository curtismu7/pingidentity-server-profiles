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

    <h1>Case 3 : Resource Owner</h1>

    <h2>Step 1 : Send Resource Owner Credentials</h2>
    <p>Enter the user's credentials that will be validated using the associated PingFederate password validator.</p>

    <h3>Endpoint Parameters</h3>
    <form name="input" action="token-endpoint-proxy.jsp" method="post" onsubmit="onSubmit(this)">
        <table>
            <tr><th>Name</th><th>Value</th><th>Description</th></tr>
            <tr><td class = "required">*grant_type</td><td><input type="text" name="grant_type" value="password"/></td><td>A value of password indicates that the username and password of the resource owner (end user) will be used to request the token.</td></tr>
			<tr><td class = "required">*username</td><td><input type="text" name="username" value=""/></td><td>The username, encoded as UTF-8. (ex. joe)</td></tr>
            <tr><td class = "required">*password</td><td><input type="text" name="password" value=""/><td>The password, encoded as UTF-8. (ex. 2Federate)</td></td></tr>
			<tr><td>client_id</td><td><input type="text" name="client_id" value="<%=ro_client_id%>"/></td><td>The client identifier (as defined on the PingFederate client management page).</td></tr>
			<tr><td>client_secret</td><td><input type="text" name="client_secret" value="<%=ro_client_secret%>"/></td><td>The client secret (as defined on the PingFederate client management page).  Not typically required with this flow.</td></tr>
            <tr><td>scope</td><td><input type="text" name="scope"/></td><td>The scope of the access request.</td></tr>
            <tr><td>validator_id</td><td><input type="text" name="validator_id" /></td><td>A PingFederate OAuth AS parameter indicating the instance id of the password credential validator to be used to check the username and password (and the associated attribute mapping into the USER_KEY of the persistent grant). If multiple password credential validator instances are configured and mapped and no validator_id is provided, each instance will be tried sequentially until one succeeds or they all fail.</td></tr>
            <tr><td>access_token_manager_id</td><td><input type="text" name="access_token_manager_id" /></td><td>The Instance ID of the desired access token manager. When specified, the PingFederate AS uses the desired access token management instance for the request if it is eligible.</td></tr>
            <tr><td>aud</td><td><input type="text" name="aud" /></td><td>The resource URI the client wants to access. The provided value is matched against resource URIs configured in access token management instances. When a match is found, the PingFederate AS uses the corresponding access token management instance for the request if it is eligible.</td></tr>
        </table>
		<p class = "required">* Required</p>
        <p class="buttons"><input type="submit" value="Request Token" /></p>
    </form> 
    
<%@include file="footer.jsp" %>