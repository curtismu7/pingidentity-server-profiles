<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>

    <h1>Settings</h1>

<%
if (request.getMethod().equals("POST") && request.getParameter("action") != null)
{
    // Save settings
    try
    {
        Properties props = new Properties();
        
        String fileName = application.getRealPath("settings.properties");
        FileOutputStream fos = new FileOutputStream(new File(fileName));
        ws_username = request.getParameter("ws_username");
        ws_password = request.getParameter("ws_password");
        base_pf_url = request.getParameter("base_pf_url");
        rs_client_id = request.getParameter("rs_client_id");
        rs_client_secret = request.getParameter("rs_client_secret");
        ac_client_id = request.getParameter("ac_client_id");
        ac_client_secret = request.getParameter("ac_client_secret");
        ac_oic_client_id = request.getParameter("ac_oic_client_id");
        ac_oic_client_secret = request.getParameter("ac_oic_client_secret");
		im_client_id = request.getParameter("im_client_id");
        im_client_secret = request.getParameter("im_client_secret");
        im_oic_client_id = request.getParameter("im_oic_client_id");
        im_oic_client_secret = request.getParameter("im_oic_client_secret");

		ro_client_id = request.getParameter("ro_client_id");
        ro_client_secret = request.getParameter("ro_client_secret");
        cc_client_id = request.getParameter("cc_client_id");
        cc_client_secret = request.getParameter("cc_client_secret");
        saml_client_id = request.getParameter("saml_client_id");
        saml_client_secret = request.getParameter("saml_client_secret");
	    oic_user_info_endpoint = request.getParameter("oic_user_info_endpoint"); 	
	    scope = request.getParameter("scope"); 
        oic_client_reg_id_token_alg = request.getParameter("oic_client_reg_id_token_alg");
        oic_im_client_reg_id_token_alg = request.getParameter("oic_im_client_reg_id_token_alg");
	
	    
        props.setProperty("base_pf_url", base_pf_url);
        props.setProperty("ws_username", ws_username);
        props.setProperty("ws_password", ws_password);
        props.setProperty("rs_client_id", rs_client_id);
        props.setProperty("rs_client_secret", rs_client_secret);
        props.setProperty("ac_client_id", ac_client_id);
        props.setProperty("ac_client_secret", ac_client_secret);
		props.setProperty("ac_oic_client_id", ac_oic_client_id);
		props.setProperty("ac_oic_client_secret", ac_oic_client_secret);
		props.setProperty("im_client_id", im_client_id);
    	props.setProperty("im_client_secret", im_client_secret);
		props.setProperty("im_oic_client_id", im_oic_client_id);
		props.setProperty("im_oic_client_secret", im_oic_client_secret);
        props.setProperty("ro_client_id", ro_client_id);
        props.setProperty("ro_client_secret", ro_client_secret);
        props.setProperty("cc_client_id", cc_client_id);
        props.setProperty("cc_client_secret", cc_client_secret);
        props.setProperty("saml_client_id", saml_client_id);
        props.setProperty("saml_client_secret", saml_client_secret);
        props.setProperty("oic_user_info_endpoint", oic_user_info_endpoint);
	    if (scope != null)
		   props.setProperty("scope", scope);
       	props.setProperty("oic_client_reg_id_token_alg", oic_client_reg_id_token_alg);
       	props.setProperty("oic_im_client_reg_id_token_alg", oic_im_client_reg_id_token_alg);

		props.store(fos, "");
            
        fos.close();
    }
    catch (Exception e)
    {
%>
	    <div class="error">Exception: <%=e%></div>
<%  
    }
%>
    <div class="info">Settings saved.</div>
<%
	if (request.getParameter("action").equalsIgnoreCase("Create Clients"))
	{
%>
		<%@include file="create-clients.jsp" %> 
<%
	}
%>

<%		
}
%>
    <p>Adjust the PingFederate base URL and OAuth Client settings below to match your PingFederate installation.  Settings must be aligned before running most of the available cases. Settings must be in sync with PingFederate, hence if any settings (e.g. client_secret) are changed on the PingFederate server then save the changes in the Settings page as well.</p>
    <form name="input" method="post" class="settings-page">
        <h3>PingFederate</h3>
        <table>
            <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
            <tr><td>Base URL</td><td><input type="text" name="base_pf_url" value="<%=base_pf_url%>"/></td><td>The base URL (including protocol and port) of  PingFederate.</td></tr>
        </table>
        <p class="buttons"><input type="submit" name="action" value="Save Settings" /></p>
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
		
		<h2>Advanced Settings <a href="javascript:toggleAdvanced();" id="advanced_disclosure">&gt;&gt;</a></h2>
		<div id="advanced" style="display:none">
			<h2>Client Settings</h2>
        	<h3>Resource Server</h3>
        	<p>OAuth client supporting the "Access Token Validation (Client is a Resource Server)" grant type.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="rs_client_id" value="<%=rs_client_id%>"/></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="rs_client_secret" value="<%=rs_client_secret%>"/></td><td>The client secret.</td></tr>
        	</table>
        	
        	<h3>Authorization Code</h3>
        	<p>OAuth client supporting the "Authorization Code" and (optionally) the "Refresh Token" grant types.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="ac_client_id" value="<%=ac_client_id%>"/></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="ac_client_secret" value="<%=ac_client_secret%>"/></td><td>The client secret, not required with this flow.</td></tr>
        	</table>
        	
        	<h3>OpenID Connect Basic Client Profile</h3>
        	<p>OAuth client supporting the "Authorization Code" and OpenID Connect.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="ac_oic_client_id" value="<%=ac_oic_client_id%>" /></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="ac_oic_client_secret" value="<%=ac_oic_client_secret%>" /></td><td>The client secret.</td></tr>
        	    <tr><td>id_token_signed_response_alg</td><td><input type="text" name="oic_client_reg_id_token_alg" value="<%=oic_client_reg_id_token_alg%>"/></td><td>The JWS algorithm (for eg. HS256, HS384, RS256, ES265 etc.) to sign the id_token.</td></tr>
        	</table>
        	
        	<h3>OpenID Connect Implicit Client Profile</h3>
        	<p>OAuth client supporting the Implicit and OpenID Connect.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="im_oic_client_id" value="<%=im_oic_client_id%>" /></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="im_oic_client_secret" value="<%=im_oic_client_secret%>" /></td><td>The client secret.</td></tr>
        	    <tr><td>id_token_signed_response_alg</td><td><input type="text" name="oic_im_client_reg_id_token_alg" value="<%=oic_im_client_reg_id_token_alg%>"/></td><td>The JWS algorithm (for eg. HS256, HS384, RS256, ES265 etc.) to sign the id_token.</td></tr>
        	</table>
			<h3>OpenID Connect - UserInfo Endpoint</h3>
        	<p>The User info request requires access token to access the User info.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>user_info_endpoint</td><td><input type="text" name="oic_user_info_endpoint" value="<%=oic_user_info_endpoint%>" /></td><td>The Client may send request to this endpoint to get additional attributes about the end-user.</td></tr>
        	</table> 
        	
        	<h3>Implicit</h3>
        	<p>OAuth client supporting the "Implicit" grant type.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="im_client_id" value="<%=im_client_id%>"/></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="im_client_secret" value="<%=im_client_secret%>"/></td><td>The client secret, not required with this flow.</td></tr>
        	</table>
        	
        	<h3>Resource Owner</h3>
        	<p>OAuth client supporting the "Resource Owner Password Credentials" and (optionally) the "Refresh Token" grant types.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="ro_client_id" value="<%=ro_client_id%>"/></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="ro_client_secret" value="<%=ro_client_secret%>"/></td><td>The client secret, not required with this flow.</td></tr>
        	</table>
        	
        	<h3>Client Credentials</h3>
        	<p>OAuth client supporting the "Client Credentials" grant type.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="cc_client_id" value="<%=cc_client_id%>"/></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="cc_client_secret" value="<%=cc_client_secret%>"/></td><td>The client secret.</td></tr>
        	</table>
        	
        	<h3>SAML Bearer Assertion Profile Client Credentials</h3>
        	<p>OAuth client supporting the "SAML 2.0 Bearer Assertion Profile" grant type.</p>
        	<table>
        	    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
        	    <tr><td>client_id</td><td><input type="text" name="saml_client_id" value="<%=saml_client_id%>"/></td><td>The client identifier.</td></tr>
        	    <tr><td>client_secret</td><td><input type="text" name="saml_client_secret" value="<%=saml_client_secret%>"/></td><td>The client secret, not required with this flow.</td></tr>
        	</table>
			<br><hr>
			<h2>Database Client Management (optional)</h2>
    		<p>If your PingFederate server is storing OAuth clients in a backend database, the following "Create Clients" button may be used to bootstrap the required configuration via the OAuth Client Management Service. Note that a default PingFederate setup initialized with the OAuth Playground's configuration archive already contains the prerequisite client configuration.</p>   			
   			<p>HTTP Basic credentials to authenticate to the OAuth Administrative Web Services. If you haven't done so already, configure a PCV for the service as described in the <a href="https://documentation.pingidentity.com/pingfederate/pf/index.shtml?contextId=help_AuthorizationServerSettingsTasklet_OAuthAuthorizationServerSettingsState">PingFederate documentation</a>.</p>
    		<table>
    		    <tr><th class="name">Name</th><th class="value">Value</th><th class="desc">Description</th></tr>
    		    <tr><td>Username</td><td><input type="text" name="ws_username"/></td><td>Username for the OAuth Administrative Web Services.</td></tr>
    		    <tr><td>Password</td><td><input type="text" name="ws_password"/></td><td>Password for the OAuth Administrative Web Services.</td></tr>
    		</table>
    		
    		<p class="buttons"><input type="submit" name="action" value="Create Clients" /></p>
		</div>
    </form>
<%@include file="footer.jsp" %>
