<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.io.FileUtils" %>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>
<script type="text/javascript">
    eraseCookie();
</script>

<%
    String sampleRequest = "";
    
    try
    {
        File rstFile = new File(application.getRealPath("rst.xml"));
        sampleRequest = FileUtils.readFileToString(rstFile);
    }
    catch (IOException e)
    {
        // Ignore
    }
%>

    <h1>Case 6 : OAuth SAML Bearer Profile</h1>

    <h2>Step 1 : Request SAML Assertion</h2>
    <p>A SAML Assertion is required in order to request an OAuth access token.  The OAuth 2.0 Bearer Assertion Profile does not dictate where this comes from.  A request can be made to the PingFederate STS to obtain a properly formatted one.  The requesting token type must be: urn:ietf:params:oauth:grant-type:saml2-bearer</p>
    
    <h3>STS Request</h3>
    <form name="input" action="case6-sts-request-response.jsp" method="post">
        <textarea name="sts_request" cols="72" rows="30"><%=sampleRequest%></textarea>
        <p class="buttons"><input type="submit" value="Send Request"/></p>
    </form>

<%@include file="footer.jsp" %>