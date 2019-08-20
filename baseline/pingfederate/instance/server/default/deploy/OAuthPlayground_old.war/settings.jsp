<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    String base_pf_url = "https://localhost:9031";
    String ws_username = "";
    String ws_password = "";
    String rs_client_id = "rs_client";
    String rs_client_secret = "2Federate";
    String ac_client_id = "ac_client";
    String ac_client_secret = "";
    String ac_oic_client_id = "ac_oic_client";
    String ac_oic_client_secret = "abc123DEFghijklmnop4567rstuvwxyzZYXWUT8910SRQPOnmlijhoauthplaygroundapplication";
    String im_client_id = "im_client";
    String im_client_secret = "";
    String im_oic_client_id = "im_oic_client";
    String im_oic_client_secret = "abc123DEFghijklmnop4567rstuvwxyzZYXWUT8910SRQPOnmlijhoauthplaygroundapplication";
    String ro_client_id = "ro_client";
    String ro_client_secret = "";
    String cc_client_id = "cc_client";
    String cc_client_secret = "2Federate";
    String saml_client_id = "saml_client";
    String saml_client_secret = "";
    String oic_user_info_endpoint = base_pf_url + "/idp/userinfo.openid"; 
    String scope = "openid"; 
    //String oic_client_reg_redirect_uris = base_pf_url + "/OAuthPlayground/case1A-callback.jsp"; 
    String oic_client_reg_id_token_alg = "HS256"; 
    String oic_im_client_reg_id_token_alg = "HS256";
     
    // Read settings
    try
    {
        Properties props = new Properties();
    
        String fileName = application.getRealPath("settings.properties");
        FileInputStream fis = new FileInputStream(new File(fileName));
        props.load(fis);
        fis.close();
        
        base_pf_url = props.getProperty("base_pf_url", base_pf_url);
        ws_username = props.getProperty("ws_username", ws_username);
        ws_password = props.getProperty("ws_password", ws_password);
        rs_client_id = props.getProperty("rs_client_id", rs_client_id);
        rs_client_secret = props.getProperty("rs_client_secret", rs_client_secret);
        ac_client_id = props.getProperty("ac_client_id", ac_client_id);
        ac_client_secret = props.getProperty("ac_client_secret", ac_client_secret);
        ac_oic_client_id = props.getProperty("ac_oic_client_id", ac_oic_client_id);
        ac_oic_client_secret = props.getProperty("ac_oic_client_secret", ac_oic_client_secret);
        im_client_id = props.getProperty("im_client_id", im_client_id);
        im_client_secret = props.getProperty("im_client_secret", im_client_secret);
        ro_client_id = props.getProperty("ro_client_id", ro_client_id);
        ro_client_secret = props.getProperty("ro_client_secret", ro_client_secret);
        cc_client_id = props.getProperty("cc_client_id", cc_client_id);
        cc_client_secret = props.getProperty("cc_client_secret", cc_client_secret);
        saml_client_id = props.getProperty("saml_client_id", saml_client_id);
        saml_client_secret = props.getProperty("saml_client_secret", saml_client_secret);
	   	
        oic_client_reg_id_token_alg = props.getProperty("oic_client_reg_id_token_alg", oic_client_reg_id_token_alg);
        oic_im_client_reg_id_token_alg = props.getProperty("oic_im_client_reg_id_token_alg", oic_im_client_reg_id_token_alg);
	
		im_oic_client_id = props.getProperty("im_oic_client_id", im_oic_client_id);
        im_oic_client_secret = props.getProperty("im_oic_client_secret", im_oic_client_secret);
		oic_user_info_endpoint = props.getProperty("oic_user_info_endpoint", oic_user_info_endpoint);
		scope = props.getProperty("scope", scope);
    }
    catch (Exception e)
    {
        // Ignore and assume defaults are OK.
    }
%>
