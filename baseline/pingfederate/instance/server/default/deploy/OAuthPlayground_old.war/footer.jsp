<%--*************************************************************
* Copyright (C) 2012 Ping Identity Corporation                  *
* All rights reserved.                                          *
*                                                               *
* The contents of this file are subject to the disclaimer       *
* of the ReadMeFirst.pdf file included in the package			    *
************************************************************--%>

    </div>
    <div class="footer">
      <a href="http://www.pingidentity.com/"><img src="images/ping-logo.png"></a>
    </div>
  </div>

<script type="text/javascript">
    function restoreFieldValues(){
        fillInFields("access_token_manager_id", getAtmId());
        fillInFields("aud", getAud());
    }

    function fillInFields(name, value){
        if(value){
            var inputs = document.getElementsByName(name);
            var input;
            for (var i = 0; input = inputs[i]; i++) {
                input.value = value;
            }
        }
    }

    if(!skipRestoration)
        restoreFieldValues();
</script>
</body>
</html>
