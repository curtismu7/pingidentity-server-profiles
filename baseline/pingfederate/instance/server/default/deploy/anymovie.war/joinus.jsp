<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1">
		
		<title>AnyProductionCompany | Join Us</title>

		<!-- Loading third party fonts -->
		<link href="http://fonts.googleapis.com/css?family=Roboto:300,400,700|" rel="stylesheet" type="text/css">
		<link href="fonts/font-awesome.min.css" rel="stylesheet" type="text/css">

		<!-- Loading main css file -->
		<link rel="stylesheet" href="style.css">
		
		<!--[if lt IE 9]>
		<script src="js/ie-support/html5.js"></script>
		<script src="js/ie-support/respond.js"></script>
		<![endif]-->

	</head>

      <body style="background-image:url('showcase.jpg');background-position:center;background-size: 100%;">


                <div id="site-content" style="background-image:url('showcase.jpg');background-position:center;background-size: 100%;">
						 <header class="site-header">
                                <div class="container">
                                        <a href="index.jsp" id="branding">
                                                <img src="anycologo3.png" alt="" class="logo">
						<div class="logo-copy">
							<h1 class="site-title"></h1>
							<small class="site-description">Now Casting for AnyMovie the Trilogy</small>
						</div>
					</a> <!-- #branding -->

					<div class="main-navigation">
						<button type="button" class="menu-toggle"><i class="fa fa-bars"></i></button>
						<ul class="menu">
							
						</ul> <!-- .menu -->

						<form action="#" class="search-form">
							<input type="text" placeholder="Search...">
							<button><i class="fa fa-search"></i></button>
						</form>
					</div> <!-- .main-navigation -->

					<div class="mobile-navigation"></div>
				</div>
			</header>
			<main class="main-content">
				<div class="container">
					<div class="page">
						<div class="breadcrumbs">
							<a href="index.html">Home</a>
							<span>Join Us</span>
						</div>

						<div class="content">

<h2 class="section-title">Submit your information for a callback! <br/><br/><h3> Check your profile below for accuracy, we will be submitting them to a trusted third party for identity verification.</h3></h2>
<b>Note: We cannot submit your profile if we cannot verify the information below.<br/><br/><br/></b>
<h25>
<%


 out.println("<b>");
 	out.println("First Name:"); 
 out.println("</b>");
	out.println(request.getHeader("X-GIVENNAME"));
 out.println("<br/><br/>");

 out.println("<b>");
        out.println("Last Name:");
 out.println("</b>");
        out.println(request.getHeader("X-LASTNAME"));
 out.println("<br/><br/>");

 out.println("<b>");
        out.println("Email:");
 out.println("</b>");
        out.println(request.getHeader("X-USER"));
 out.println("<br/><br/>");

 out.println("<b>");
        out.println("Mobile:");
 out.println("</b>");
        out.println(request.getHeader("X-MOBILE"));
 out.println("<br/><br/>");

 out.println("<b>");
        out.println("Address:");
 out.println("</b>");
        out.println( request.getHeader("X-STREET") + ", " + request.getHeader("X-CITY") + request.getHeader("X-STATE") );
 out.println("<br/><br/>");

 out.println("<b>");
        out.println("Birthdate:");
 out.println("</b>");
        out.println(request.getHeader("X-BIRTHDAY"));
 out.println("<br/><br/>");


 %>
</h25>

<br/><br/><br/>
									<a href="success.jsp" class="button">APPLY NOW</a> &nbsp;&nbsp;
                                                                                 <a href="https://sso.anycompany.org:9031/pf/idprofile.ping?LocalIdentityProfileID=Ggk9wkFaCPgk4K0X" target="_new" class="button">MODIFY MY PROFILE</a>
				</div> <!-- .container -->
			</main>
			<footer class="site-footer">
				<div class="container">
					<div class="row">
						<div class="col-md-2">
							<div class="widget">
								<h3 class="widget-title">About Us</h3>
								<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia tempore vitae mollitia nesciunt saepe cupiditate</p>
							</div>
						</div>
						<div class="col-md-2">
							<div class="widget">
								<h3 class="widget-title">Recent Review</h3>
								<ul class="no-bullet">
									<li>Lorem ipsum dolor</li>
									<li>Sit amet consecture</li>
									<li>Dolorem respequem</li>
									<li>Invenore veritae</li>
								</ul>
							</div>
						</div>
						<div class="col-md-2">
							<div class="widget">
								<h3 class="widget-title">Help Center</h3>
								<ul class="no-bullet">
									<li>Lorem ipsum dolor</li>
									<li>Sit amet consecture</li>
									<li>Dolorem respequem</li>
									<li>Invenore veritae</li>
								</ul>
							</div>
						</div>
						<div class="col-md-2">
							<div class="widget">
								<h3 class="widget-title">Join Us</h3>
								<ul class="no-bullet">
									<li>Lorem ipsum dolor</li>
									<li>Sit amet consecture</li>
									<li>Dolorem respequem</li>
									<li>Invenore veritae</li>
								</ul>
							</div>
						</div>
						<div class="col-md-2">
							<div class="widget">
								<h3 class="widget-title">Social Media</h3>
								<ul class="no-bullet">
									<li>Facebook</li>
									<li>Twitter</li>
									<li>Google+</li>
									<li>Pinterest</li>
								</ul>
							</div>
						</div>
						<div class="col-md-2">
							<div class="widget">
								<h3 class="widget-title">Newsletter</h3>
								<form action="#" class="subscribe-form">
									<input type="text" placeholder="Email Address">
								</form>
							</div>
						</div>
					</div> <!-- .row -->

					<div class="colophon">Copyright 2014 Company name, Designed by Themezy. All rights reserved</div>
				</div> <!-- .container -->

			</footer>
		</div>
		<!-- Default snippet for navigation -->
		


		<script src="js/jquery-1.11.1.min.js"></script>
		<script src="js/plugins.js"></script>
		<script src="js/app.js"></script>
		
	</body>

</html>
