<%--*************************************************************
* Copyright (C) 2013 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.net.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>

    <h1>OpenID Connect</h1>

    <h2>Get User Info</h2>
    <p>This page has made a request to the OpenID Connect UserInfo Endpoint using the provided access token to fetch the end user's attributes.  Which claims are returned depends on the access token's associated scope.  The raw response appears below along with the parsed JSON results for legibility.</p>
<%
try 
{
	String access_token = request.getParameter("access_token");  
	String parameters = "?schema=openid&access_token=" +access_token;
	oic_user_info_endpoint = oic_user_info_endpoint + parameters;
	URL userInfoURL = new URL(oic_user_info_endpoint);
    HttpURLConnection userInfoConn = (HttpURLConnection) userInfoURL.openConnection();
    
    userInfoConn.setRequestMethod("GET");
    userInfoConn.setDoOutput(true);
    int statusCode = userInfoConn.getResponseCode();
	String contentType = userInfoConn.getHeaderField("content-type");
    String body = ""; 
    if ((statusCode == 200) || ((400 <= statusCode) && (statusCode <= 499)))
    {   
            String line;
            BufferedReader reader;
            // Read the error stream should an error case occur
            if (userInfoConn.getErrorStream() != null)
            {   
                    reader = new BufferedReader(new InputStreamReader(userInfoConn.getErrorStream()));
            }   
            else
            {   
                    reader = new BufferedReader(new InputStreamReader(userInfoConn.getInputStream()));
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
        if ( contentType.toLowerCase().indexOf("application/json") != -1) 
        {   
            Object obj = JSONValue.parse(body);
            JSONObject jsonObj = (JSONObject)obj;
            Iterator iterator = jsonObj.keySet().iterator();  
%>
                <h3>Parsed JSON</h3>
                <table>
            	<tr><th>Name</th><th>Value</th></tr>
<%
            while (iterator.hasNext())
            {   
                String key = iterator.next().toString();  
                String value = ""; 
    
                if (jsonObj.get(key) != null)
                {   
                    value = jsonObj.get(key).toString();
                }   
    
                out.println("<tr><td>" + key + "</td><td>" + value +  "</td><td>");
                out.println("</td></tr>");
            }   
        }   
%>
                </table>
<%
	}
        else
        {   
          %>  
               <div class="error">"<%= body%>"</div>
          <%  
        }
}   
catch(Exception e)
{
%>
        <div class="error">Exception: <%=e%></div>
<%
      
}
%>


<%@include file="footer.jsp" %>
