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

    <h1>Case 2-A : OpenID Connect Implicit Client Profile</h1>

    <h2>Step 2 : Token Received</h2>
    <p>Following the OAuth 2.0 specification the callback URL received the token details as parameters in the hash fragment.  The hash fragment is used to prevent sending the parameters back to the server, as the intent is they will be used client side (e.g.: by JavaScript).  View the source of this page for sample JavaScript on parsing these attributes. In OpenID Connect Implicit Client Profile the response includes ID Token.</p>
    
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
    <h3>Parameters Received</h3>
    <table style="table-layout:fixed">
        <tr><th>Name</th><th>Value</th><th>Action</th></tr>
        <script>
            if (window.location.hash)
            {
                var params = (window.location.hash.substr(1)).split("&");

                for (i = 0; i < params.length; i++)
                {
                    var pair = params[i].split("=");
                    document.write("<tr><td>" + pair[0] + "</td><td style=\"word-wrap: break-word;\">" + pair[1] + "</td><td>");
                    if (pair[0] == "access_token")
                    {
						document.write("<span class=\"side-by-side\"> \
											<form action='token-endpoint-proxy.jsp' method='post'> \
												<input type='hidden' name='client_id' value='<%=rs_client_id%>'> \
												<input type='hidden' name='client_secret' value='<%=rs_client_secret%>'> \
												<input type='hidden' name='grant_type' value='urn:pingidentity.com:oauth2:grant_type:validate_bearer'> \
												<input type='hidden' name='token' value=" + pair[1] + "> \
												<input type='hidden' name='access_token_manager_id' value=''> \
                                                <input type='hidden' name='aud' value=''> \
												<button type='submit' name='validate'>Validate</button> \
											</form> \
										</span>");
						document.write("<span class=\"side-by-side\"> \
											<form action='token-revocation-endpoint-proxy.jsp' method='post'> \
												<input type='hidden' name='client_id' value='<%=im_oic_client_id%>'> \
												<input type='hidden' name='client_secret' value='<%=im_oic_client_secret%>'> \
												<input type='hidden' name='token' value=" + pair[1] + "> \
												<input type='hidden' name='token_type_hint' value='access_token'> \
												<input type='hidden' name='access_token_manager_id' value=''> \
                                                <input type='hidden' name='aud' value=''> \
												<button type='submit' name='revoke'>Revoke</button> \
											</form> \
										</span>");
						document.write("<form action='user-info.jsp' method='post'> \
											<input type='hidden' name='access_token' value=" + pair[1] + "> \
											<button class='user-info' type='submit' name='get_user_info'>Get User Info</button> \
										</form>");
		          }
                    if (pair[0] == "id_token")
                    {
						document.write("<span class=\"side-by-side\"> \
											<form action='id-token-verify.jsp' method='post'> \
												<input type='hidden' name='id_token' value=" + pair[1] + "> \
												<input type='hidden' name='im_oic_client_secret' value='<%=im_oic_client_secret%>'> \
												<input type='hidden' name='grant_type' value='urn:pingidentity.com:oauth2:grant_type:validate_bearer'> \
												<button type='submit' name='validate'>Validate</button> \
											</form> \
										</span>");
                    }                   
                    document.write("</td></tr>");
                }
            
            
            } else {
            <%
                Map<String, String[]> parameters = request.getParameterMap();
                for(String parameter : parameters.keySet()) {
            %>
                    document.write("<tr><td><%=parameter%></td><td style='word-wrap: break-word;'><%=((String[])parameters.get(parameter))[0]%></td><td>");
            <%
                    if (parameter.equals("access_token")) {
            %>
                        document.write("<span class=\"side-by-side\"> \
                                            <form action='token-endpoint-proxy.jsp' method='post'> \
                                                <input type='hidden' name='client_id' value='<%=rs_client_id%>'> \
                                                <input type='hidden' name='client_secret' value='<%=rs_client_secret%>'> \
                                                <input type='hidden' name='grant_type' value='urn:pingidentity.com:oauth2:grant_type:validate_bearer'> \
                                                <input type='hidden' name='token' value='<%=((String[])parameters.get(parameter))[0]%>'> \
                                                <button type='submit' name='validate'>Validate</button> \
                                            </form> \
                                        </span>");
                        document.write("<span class=\"side-by-side\"> \
                                            <form action='token-revocation-endpoint-proxy.jsp' method='post'> \
                                                <input type='hidden' name='client_id' value='<%=im_oic_client_id%>'> \
                                                <input type='hidden' name='client_secret' value='<%=im_oic_client_secret%>'> \
                                                <input type='hidden' name='token' value='<%=((String[])parameters.get(parameter))[0]%>'> \
                                                <input type='hidden' name='token_type_hint' value='access_token'> \
                                                <button type='submit' name='revoke'>Revoke</button> \
                                            </form> \
                                        </span>");
                        document.write("<form action='user-info.jsp' method='post'> \
                                            <input type='hidden' name='access_token' value='<%=((String[])parameters.get(parameter))[0]%>'> \
                                            <button class='user-info' type='submit' name='get_user_info'>Get User Info</button> \
                                        </form>");
            <%
                    }
                    
                         
                    if (parameter.equals("id_token")) {
                    %>
                        document.write("<span class=\"side-by-side\"> \
                                            <form action='id-token-verify.jsp' method='post'> \
                                                <input type='hidden' name='id_token' value='<%=((String[])parameters.get(parameter))[0]%>'> \
                                                <input type='hidden' name='im_oic_client_secret' value='<%=im_oic_client_secret%>'> \
                                                <input type='hidden' name='grant_type' value='urn:pingidentity.com:oauth2:grant_type:validate_bearer'> \
                                                <button type='submit' name='validate'>Validate</button> \
                                            </form> \
                                        </span>");
                    <%
                    }
                    
                    %>
                    document.write("</td></tr>");
                    <%
                    
                }
            %>    
            }            
            
            
        </script>
    </table>
<%
}
%>
<%@include file="footer.jsp" %>
