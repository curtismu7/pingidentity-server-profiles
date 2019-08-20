<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package                       *
************************************************************--%>

<%@include file="header.jsp" %>
<script type="text/javascript">
    eraseCookie();
</script>

        <h1>OAuth 2 Playground</h1>
        <h2>Overview</h2>
        <p>The overview will show how the grant types differ within OAuth 2.0. Each grant type is similar but it's important to understand when to use each depending on the nature of the target application.</p>
        <p>Tutorials:   <a href="https://developer.pingidentity.com/oauth" target="_blank">OAuth 2.0 Protocol <img src="images/html_link.png" alt="HTML" /></a>&nbsp;&nbsp;
                                <a href="https://developer.pingidentity.com/openidconnect" target="_blank">OpenID Connect 1.0 <img src="images/html_link.png" alt="HTML" /></a>
    <h2><a href="case1-authorization.jsp">Case 1 : Authorization Code</a></h2>
    <p>An authorization code is returned to the client through a browser redirect after the resource owner gives consent to the OAuth AS. The client subsequently exchanges the authorization code for an access (and often a refresh) token. Resource owner credentials are never exposed to the client.</p>
    <h2><a href="case1A-authorization.jsp">Case 1-A : OpenID Connect Basic Client Profile </a></h2>
    <p>PingFederate supports the OpenID Connect protocol to act as an OpenID Provider (OP).  The OAuth Playground demonstrates a Relying Party (RP) login use case.  In essence, OpenID Connect is an identity layer on top of the OAuth 2.0 protocol.  Client applications can verify the end user's identity and obtain their basic profile information via a standard UserInfo Endpoint.  The OpenID Connect Basic Client Profile is a standard profile designed for relying parties using OAuth authorization code grant type.</p>
    <p>
    <h2><a href="case2-implicit.jsp">Case 2 : Implicit</a></h2>
    <p>An access token is returned to the client through a browser redirect in response to the resource owner authorization request (rather than an intermediate authorization code). This grant type is suitable for clients incapable of keeping client credentials confidential (for use in authenticating with the OAuth AS) such as client applications implemented in a browser using a scripting language such as Javascript.</p>
    <h2><a href="case2A-implicit.jsp">Case 2-A : OpenID Connect Implicit Client Profile </a></h2>
    <p>The OpenID Connect Implicit Client Profile is a profile of the OpenID Connect Standard. The specification is designed for relying parties using the OAuth implicit grant type to verify the end user's identity and obtain their basic profile information via a standard UserInfo Endpoint.</p>
    <p>
    <h2><a href="case3-password.jsp">Case 3 : Resource Owner</a></h2>
    <p>The client collects the resource owners password and exchanges it at the OAuth AS for an access (and often a refresh) token. This grant type is suitable in cases where the RO has a trust relationship with the client, such as its computer operation system or a highly privileged application since the client must discard the password after using it to obtain the access token.</p>
    <h2><a href="case4-client-credentials.jsp">Case 4 : Client Credentials</a></h2>
    <p>The client presents its own credentials to the OAuth AS in order to obtain an access token. This access token is either associated with the client's own resources, and not a particular resource owner, or is associated with a resource owner for whom the client is otherwise authorized to act.</p>
    <h2><a href="case5-manage-grants.jsp">Case 5 : Grant Management</a></h2>
    <p>Once persistent grants (refresh tokens) have been stored, they can be managed by end users using an out of the box page available in the PingFederate OAuth AS.  Management involves first authenticating the user, then displaying the page of all stored grants with the option to revoke each.</p>

<%@include file="footer.jsp" %>
