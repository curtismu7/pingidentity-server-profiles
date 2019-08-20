<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>

<%	
	// This code will create client objects and add them into array for the loop process where
	// each object will be sent to the PF service and response is processed one by one
	
	JSONArray clientArray=new JSONArray();
	 
    //Create im_client
    clientArray.add( createClientObject(createGrantsArray("implicit"),
							im_client_id,
							null,	//secret
							"Implicit",	
							"Implicit OAuth Client",
							base_pf_url + "/OAuthPlayground/case2-callback.jsp") );
    	
  	//Create ro_client
    clientArray.add( createClientObject(createGrantsArray("password","refresh_token"),
							ro_client_id,
							null,  	//secret
							"Resource Owner",
							"Resource Owner OAuth Client",
							null) );

  	//Create saml_client object
	clientArray.add( createClientObject(createGrantsArray("extension"),
							saml_client_id,
							saml_client_secret,  	//secret
							"SAML Client",
							"SAML 2.0 Bearer Assertion Profile OAuth Client",
							null) );

    //Create rs_client object
	clientArray.add( createClientObject(createGrantsArray("urn:pingidentity.com:oauth2:grant_type:validate_bearer"),
							rs_client_id,
							rs_client_secret,  	//secret
							"Resource Server",
							"Resource Server OAuth Client",
							null) );
  	
  	//Create ac_client object
	clientArray.add( createClientObject(createGrantsArray("authorization_code","refresh_token"),
							ac_client_id,
							null,  	//secret
							"Authorization Code",
							"Authorization Code OAuth Client",
							base_pf_url + "/OAuthPlayground/case1-callback.jsp") );	
  
    //Create cc_client object
	clientArray.add( createClientObject(createGrantsArray("client_credentials"),
							cc_client_id,
							cc_client_secret,  	//secret
							"Client Credentials",
							"Client Credentials OAuth Client",
							null) );
	//Create ac_oic_client_id object
	clientArray.add( createClientObject(createGrantsArray("authorization_code","refresh_token"),
							ac_oic_client_id,
							ac_oic_client_secret,  	//secret
							"Authorization Code OpenID Connect",
							"OpenID Connect Basic Client Profile",
							base_pf_url + "/OAuthPlayground/case1A-callback.jsp",
							oic_client_reg_id_token_alg) );

	//Create im_oic_client_id
    	clientArray.add( createClientObject(createGrantsArray("implicit"),
							im_oic_client_id,
							im_oic_client_secret,	//secret
							"Implicit OpenID Connect",	
							"OpenID Implicit Client Profile",
							base_pf_url + "/OAuthPlayground/case2A-callback.jsp",
							oic_im_client_reg_id_token_alg) );
 
    //Prepare Base64 encoded http basic credential
   	String creds = ws_username + ":" + ws_password;
   	String b64Creds = new String(Base64.encodeBase64(creds.getBytes()));
   	
	URL url = new URL(base_pf_url + "/pf-ws/rest/oauth/clients");
	
	//Single client to be sent out
	JSONObject singleRec = new JSONObject(); 
	
	// Send client entry one by one
	for (Object client : clientArray)
	{
		try
		{
    		HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
	
			// HTTP POST containing json and http basic credential 
			httpURLConnection.setRequestMethod("POST");
			httpURLConnection.setRequestProperty("Content-Type", "application/json");
			httpURLConnection.setDoOutput(true);
    		httpURLConnection.setRequestProperty("Authorization", "Basic " + b64Creds);
    		OutputStreamWriter writer = new OutputStreamWriter(httpURLConnection.getOutputStream());
  			
    		//Prepare single client to send
			singleRec.clear();
			singleRec.put("client",(JSONObject) client);
			
			writer.write(singleRec.toString());
			writer.flush();
			writer.close();
			
			int statusCode = httpURLConnection.getResponseCode();
			
			if ((statusCode == 200) || ((400 <= statusCode) && (statusCode <= 499)))
			{
				String line;
				String body = "";
				BufferedReader reader;
        
        		// Read the error stream should an error case occur
	        	if (httpURLConnection.getErrorStream() != null)
   	     		{
            		reader = new BufferedReader(new InputStreamReader(httpURLConnection.getErrorStream()));
    	    	}
	        	else
    	    	{
        	    	reader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
        		}
        
				while ((line = reader.readLine()) != null)
				{
					body += line;
				}

				reader.close();
				
				if (statusCode == 200)
				{
%>	
    				<div class="info">Client "<%= ((JSONObject) client).get("clientId") %>" created.</div>
<%
				}
				else if (statusCode == 400)
				{
					if (body.contains("Client ID is already in use"))
					{ // For nicer look&feel. If hardcoded description changes in PF, same will be caught by the 'else' below.
%>
						<div class="info">Client "<%= ((JSONObject) client).get("clientId") %>" already exists. Creation skipped.</div>
<%
					}
					else
					{
%>
						<div class="error">Creating client "<%= ((JSONObject) client).get("clientId") %>" failed.</div>
	        			<textarea cols="72" rows="1" readonly="readonly"><%=body%></textarea>
<%
	        		}
	        	}
	        	else if (statusCode == 401)
	        	{
%>
	        		<div class="error">Creating client "<%= ((JSONObject) client).get("clientId") %>" failed: Invalid Credentials.</div>
<%
	        	}
	        	else
	        	{
%>
	        		<div class="error">Creating client "<%= ((JSONObject) client).get("clientId") %>" failed.</div>
	        		<textarea cols="72" rows="1" readonly="readonly"><%=body%></textarea>
<%
	        	}
			}
			else
			{
				throw new IOException("Unable to communicate with server." + statusCode + ": " + httpURLConnection.getResponseMessage());
			}
		}
		catch (Exception e)
		{
		%>
        	<div class="error">Exception: <%=e%></div>
        <%
		}
	}
%>
<%!
	/**
 	 *
 	 *
 	 */
	private JSONArray createGrantsArray(String... types)
	{
		JSONArray typeArray = new JSONArray();
		for (int i = 0; i < types.length; i++)
		{
			typeArray.add(types[i]);
		}
		return typeArray;
	}
%>
<%!
	/**
 	 * 
 	 * 
 	 */
	private JSONObject createClientObject(JSONArray grantsArray, 
									String clientId,
									String secret, 
									String name, 
									String desc, 
									String redirectUris)
	{			    		
	    JSONObject objFields=new JSONObject();
			
		//Assume clientId, name and grantTypes are always there (as they are mandatory)
		//If empty, let the PF server returns proper error. 
		objFields.put("clientId",clientId);
		objFields.put("name",name);
		objFields.put("grantTypes",grantsArray);
		
		if ((secret != null)&&(secret.length() != 0))
		{
			objFields.put("secret",secret);
		}
		if ((desc != null)&&(desc.length() != 0))
		{
			objFields.put("description",desc);
		}
		if ((redirectUris != null)&&(redirectUris.length() != 0))
		{
			objFields.put("redirectUris",redirectUris);
		}
	  			
		return objFields;
	}

	private JSONObject createClientObject(JSONArray grantsArray, 
									String clientId,
									String secret, 
									String name, 
									String desc, 
									String redirectUris,
									String idTokenSigningAlgorithm)
	{			    		
	    	JSONObject objFields = createClientObject(grantsArray, clientId, secret, name, desc, redirectUris);
		// Optionally set the policy group ID
		// objFields.put("policyGroupId", policyGroupId);
		objFields.put("idTokenSigningAlgorithm",idTokenSigningAlgorithm);
		return objFields;
	}	
%>
