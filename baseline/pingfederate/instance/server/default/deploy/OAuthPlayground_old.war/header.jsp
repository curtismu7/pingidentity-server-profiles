<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="EN" lang="EN">
<head>
    <title>OAuth 2 Playground</title>
    <link href="css/stylesheet.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">
        var cookieName = "op-data";
        var skipRestoration = false;

        // We shouldn't be submitting parameters that aren't filled out. Remove the name from empty items so they are
        // not included in the POST.
        function clearEmptyFields(myForm) {
            var inputs = myForm.getElementsByTagName('input');
            var input;
            for (var i = 0; input = inputs[i]; i++) {
                if (!input.value) {
                    input.setAttribute('name', '');
                }
            }
        }

        // We want to save the values for a few parameters that will be used in later pages as well. So store those
        // values in the "op-data" cookie.
        function saveValues(myForm) {
            var atm_id = ('undefined' !== typeof myForm['access_token_manager_id']) ? myForm['access_token_manager_id'].value : null;
            var aud = ('undefined' !== typeof myForm['aud']) ? myForm['aud'].value : null;
            var data = {"atm_id": atm_id, "aud": aud};
            createCookie(JSON.stringify(data));
        }

        function getAtmId()
        {
            var data = readCookie();
            return data['atm_id'];
        }

        function getAud()
        {
            var data = readCookie();
            return data['aud'];
        }

        function onSubmit(myForm) {
            clearEmptyFields(myForm);
            saveValues(myForm);
        }

        function createCookie(value) {
            var date = new Date();
            date.setTime(date.getTime() + (24 * 60 * 60 * 1000));
            var expires = "; expires=" + date.toGMTString();
            document.cookie = encodeURIComponent(cookieName) + "=" + encodeURIComponent(value) + expires + "; path=/";
        }

        function readCookie() {
            var nameEQ = encodeURIComponent(cookieName) + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) === ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) === 0) {
                    var data = decodeURIComponent(c.substring(nameEQ.length, c.length));
                    return JSON.parse(data);
                }
            }
            return null;
        }

        function eraseCookie() {
            document.cookie = encodeURIComponent(cookieName) + "=" + encodeURIComponent("") + "-1; path=/";
        }
    </script>

</head>
<body>
<div class="width">
    <div class="header">
        <a title="PingFederate - OAuth 2 Playground" href="index.jsp"><img src="images/pf-oauth-header.png"></a>
    </div>
    <div class="menubar">
        <div class="menubar-left">
            <a href="index.jsp"><img title="Home" src="images/home.png"></a>
        </div>
        <div class="menubar-right">
            <a href="settings-page.jsp"><img title="Settings" src="images/settings.png"></a>
        </div>
    </div>
    <div class="mainbody">