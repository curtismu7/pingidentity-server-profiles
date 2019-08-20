<%--*************************************************************
* Copyright (C) 2013 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@include file="settings.jsp" %>
<%@include file="header.jsp" %>
<%@ page import="org.jose4j.base64url.Base64Url" %>
<%@ page import="org.jose4j.lang.StringUtil" %>
<%@ page import="org.jose4j.jwx.CompactSerialization" %>
<%@ page import="org.jose4j.jws.JsonWebSignature" %>
<%@ page import="org.jose4j.jwk.JsonWebKeySet" %>
<%@ page import="org.jose4j.jwk.JsonWebKey" %>
<%@ page import="org.jose4j.jwk.Use" %>
<%@ page import="org.jose4j.keys.HmacKey" %>
<%@ page import="java.security.Key" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.net.*" %>

    <h1>OpenID Connect - Token Verification </h1>

    <h2>Verify Signature : id_token</h2>
    <p>The JSON Web Signature is verified using the appropriate verification key and the corresponding Algorithm. </p>
    <p>If it is an asymmetric algorithm then the verificiation key is the public key which corresponds to the private key that was used to sign the message. If it is an symmetric algorithm then the verificiation key is a shared secret that is used for both signing and verification. </p>
    <p>Note: Signature verification alone does not ensure the complete trustworthiness of an id_token. A client application should perform additional checks on the claims contained within it, such as iat, exp and c_hash.</p>

<%

	String id_token = request.getParameter("id_token");	
	Base64Url base64url = new Base64Url();
	boolean signatureVerified = false;
	boolean isNoAlg = false;
	String headerString = "";
	String bodyString = "";
	String verifyResult = "Error";
	String[] parts = null;
    String kid = null;
    String alg = null;
	String keyId = null;
try{
	parts = CompactSerialization.deserialize(id_token);
	if( parts.length == 3)
	{
		//This tutorial uses jose4j an opensource implementation of JWS, JWE, JWA and JWK (https://bitbucket.org/b_c/jose4j/)
		//Decoding the Header and Payload parts
		headerString = base64url.base64UrlDecodeToString(parts[0], StringUtil.UTF_8);
		bodyString = base64url.base64UrlDecodeToString(parts[1], StringUtil.UTF_8);

		JSONObject headerJSON = (JSONObject) JSONValue.parse(headerString);
		kid = (String) headerJSON.get("kid");
		alg = (String) headerJSON.get("alg");
		//Checking if the signing algorithm is based on symmetric key algorithm
		if(alg != null && alg.toUpperCase().startsWith("HS"))
		{
			//Verifying the signature using the client secret
			JsonWebSignature jws = new JsonWebSignature();
			jws.setCompactSerialization(id_token);
			String clientSecret = request.getParameter("ac_oic_client_secret");
			if( clientSecret == null)
				clientSecret = request.getParameter("im_oic_client_secret");
			byte[] bytes = clientSecret.getBytes("UTF-8");
			Key publicKey = new HmacKey(bytes);
			jws.setKey(publicKey);
			signatureVerified = jws.verifySignature();		
		}
		else if(alg != null && alg.toUpperCase().startsWith("NONE"))
		{
			isNoAlg = true;
		}
		else //Asymmetric key algorithm handling
		{
			URL jsonWekKeySetURL = new URL(base_pf_url + "/pf/JWKS");
			HttpURLConnection jsonWekKeySetConn = (HttpURLConnection) jsonWekKeySetURL.openConnection();
			jsonWekKeySetConn.setRequestMethod("GET");
			jsonWekKeySetConn.setDoOutput(true);
			int statusCode = jsonWekKeySetConn.getResponseCode();
			String contentType = jsonWekKeySetConn.getHeaderField("content-type");
			String jsonWebKeySetJson = "";
			if ((statusCode == 200))
			{
				String line;
				BufferedReader reader;
				// Read the error stream should an error case occur
				if (jsonWekKeySetConn.getErrorStream() != null)
				{
					reader = new BufferedReader(new InputStreamReader(jsonWekKeySetConn.getErrorStream()));
				}
				else
				{
					reader = new BufferedReader(new InputStreamReader(jsonWekKeySetConn.getInputStream()));
				}

				while ((line = reader.readLine()) != null)
				{
					jsonWebKeySetJson += line;
				}

				reader.close();
			}

			if ( contentType.toLowerCase().indexOf("application/json") != -1) 
			{   
				// Create a new JsonWebSignature object
				JsonWebSignature jws = new JsonWebSignature();
				jws.setCompactSerialization(id_token);
				// Create a new JsonWebKeySet object with the JWK Set JSON
				JsonWebKeySet jsonWebKeySet = new JsonWebKeySet(jsonWebKeySetJson);
				keyId = jws.getKeyIdHeaderValue();	
				JsonWebKey jwk = jsonWebKeySet.findJsonWebKey(keyId, jws.getKeyType(), Use.SIGNATURE, null);		
				// The verification key on the JWS is the public key from the JWK we pulled from the JWK Set.
				jws.setKey(jwk.getPublicKey());
				signatureVerified = jws.verifySignature();
			}

		}

		if (signatureVerified)
			verifyResult = "Success";	
	}
}
catch(Exception e)
{	
	%>
		<div class="error">Exception: <%=e%></div>
		<%
		return;  
}   
%>


<table  style="table-layout:fixed">
<tr><th>Steps</th><th>Results</th></tr>
<tr><td>id_token</td><td  style="word-wrap: break-word;"><%=id_token%></td>
<tr><td>Base64 Decoded Header </td><td  style="word-wrap: break-word;"><%=headerString%></td>
<tr><td>Base64 Decoded Payload </td><td  style="word-wrap: break-word;"><%=bodyString%></td>

<%
if (!isNoAlg)
{
%>
	<tr><td>Signature Verification</td><td  style="word-wrap: break-word;"><%=verifyResult%></td>
<%
}
else
{
%>
	<tr><td>Signature Verification</td><td  style="word-wrap: break-word;">Not done as no signing algorithm was selected</td>
<%
}
%>
</table>


<%@include file="footer.jsp" %>
