<%--*************************************************************
* Copyright (C) 2013 Ping Identity Corporation                  *
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

    <h1>Case 1-A : OpenID Connect - Basic Client Profile </h1>

    <h2>Step 1 : Request Authorization</h2>
    <p>The Client (for us - this tester application) first redirects the user to the Authorization Server (AS - PingFederate) to issue an authorization code, which will in turn be used to request an access token and id token.</p>
    
    <h3>Endpoint Parameters</h3>
    <form name="input" action="<%=base_pf_url%>/as/authorization.oauth2" method="post" onsubmit="onSubmit(this)">
        <table>
            <tr><th>Name</th><th>Value</th><th>Description</th></tr>
            <tr><td class="required">*client_id</td><td><input type="text" name="client_id" value="<%=ac_oic_client_id%>"/></td><td>The client identifier (as defined on the PingFederate client management page).</td></tr>
            <tr><td class="required">*response_type</td><td><input type="text" name="response_type" value="code"/></td><td>A value of code results in the Authorization Code grant type while a value of token implies the Implicit grant type.</td></tr>
            <tr><td>response_mode</td><td><input type="text" name="response_mode"/></td><td>The mode that values will be returned to the client. Possible values: fragment, query, form_post</td></tr>
            <tr><td>code_challenge</td><td><input type="text" name="code_challenge" /></td><td>A one-time code sent with the authorization request. If used, this code must be re-sent when using the authorization code to obtain an access token.</td></tr>
            <tr><td>code_challenge_method</td><td><input type="text" name="code_challenge_method" /></td><td>The format of the one-time code sent in the code_challenege parameter. Possible values: 'plain' or 'S256'. If left blank, it will default to 'plain'.</td></tr>
            <tr><td>redirect_uri</td><td><input type="text" name="redirect_uri" /></td><td>If present, the requested redirect_uri must match the one configured for the client.</td></tr>
            <tr><td>scope</td><td><input type="text" name="scope" value="<%=scope%>"/></td><td>The scope of the access request expressed as a list of space-delimited, case sensitive strings.  A value of openid means the client is making an OpenID Connect request.  Other supported scopes from the standard include: profile, email, address and phone. These must be defined in PingFederate before requesting them.</td></tr>
            <tr><td>nonce</td><td><input type="text" name="nonce"/></td><td>A random string value to assosciate a client session with ID Token.</td></tr>
            <tr><td>prompt</td><td><input type="text" name="prompt"/></td><td>The Authorization Server prompts the End-user based on a list of space-delimited, case sensitive strings. The supported values are <i>none, login, consent </i>and <i>select_account</i>.</td></tr>
            <tr><td>state</td><td><input type="text" name="state" /></td><td>An opaque value used by the client to maintain state between the request and callback. The OAuth AS sends this parameter and its given value back when redirecting the user-agent back to the client.</td></tr>
            <tr><td>idp</td><td><input type="text" name="idp" /></td><td>A PingFederate OAuth AS parameter indicating the Entity ID/Connection ID of the IdP with whom to initiate Browser SSO for user authentication.</td></tr>
            <tr><td>pfidpadapterid</td><td><input type="text" name="pfidpadapterid" /></td><td>A PingFederate OAuth AS parameter indicating the IdP Adapter Instance ID of the adapter to use for user authentication.</td></tr>
            <tr><td>acr_values</td><td><input type="text" name="acr_values"/></td><td>Space-delimited requested authentication context class reference values.  The values are listed in order of preference.</td></tr>
            <tr><td>max_age</td><td><input type="text" name="max_age"/></td><td>The allowable elapsed time (in seconds) since the end users last authenticated. If the elapsed time exceeds the value of max_age, the end users are prompted for reauthentication.</td></tr>
            <tr><td>login_hint</td><td><input type="text" name="login_hint"/></td><td>Provides a hint to the PingFederate AS about the end user. For example, when an OAuth client includes a login_hint in its authorization request and the authentication source is an HTML Form IdP Adapter instance, the username field in the login form is pre-populated with the login_hint value.</td></tr>
            <tr><td>ui_locales</td><td><input type="text" name="ui_locales"/></td><td>Specifies the end-user's preferred languages for OAuth user interactions in a space-separated list, ordered by preference.</td></tr>
            <tr><td>id_token_hint</td><td><input type="text" name="id_token_hint"/></td><td>Includes an ID token as a hint to the PingFederate AS about the end user. If the authenticated user does not match the information stored in the ID token, the PingFederate AS rejects the authorization request and returns an error message.</td></tr>
            <tr><td>claims_locales</td><td><input type="text" name="claims_locales"/></td><td>Specifies the end-user's preferred languages for claims being returned in a space-separated list, ordered by preference.</td></tr>
            <tr><td>access_token_manager_id</td><td><input type="text" name="access_token_manager_id" /></td><td>The Instance ID of the desired access token manager. When specified, the PingFederate AS uses the desired access token management instance for the request if it is eligible.</td></tr>
            <tr><td>aud</td><td><input type="text" name="aud" /></td><td>The resource URI the client wants to access. The provided value is matched against resource URIs configured in access token management instances. When a match is found, the PingFederate AS uses the corresponding access token management instance for the request if it is eligible.</td></tr>
        </table>
    <p class="required">* Required</p>
    <p class="buttons"><input type="submit" value="Request Authorization (/as/authorization.oauth2)" /></p>
    </form>

<%@include file="footer.jsp" %>
