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

    <h1>Case 5 : Grant Management</h1>

    <h2>Access Grant Management Page</h2>
    <p>The client (for us - this tester application) redirects the user to the grant management page with some optional parameters to control how the user authenticates.</p>
    
    <h3>Endpoint Parameters</h3>
    <form name="input" action="<%=base_pf_url%>/as/grants.oauth2">
        <table>
            <tr><th>Name</th><th>Value</th><th>Description</th></tr>
            <tr><td>idp</td><td><input type="text" name="idp" /></td><td>Indicates the Entity ID/Connection ID of the IdP with whom to initiate Browser SSO for user authentication.</td></tr>
            <tr><td>pfidpadapterid</td><td><input type="text" name="pfidpadapterid" /></td><td>Indicates the IdP Adapter Instance ID of the adapter to use for user authentication.</td></tr>
        </table>
        <p class="buttons"><input type="submit" value="Manage Grants (/as/grants.oauth2)" /></p>
    </form>

<%@include file="footer.jsp" %>