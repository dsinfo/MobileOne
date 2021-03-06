﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuTest.aspx.cs" Inherits="MobileOne.MenuTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <meta charset="utf-8"name="viewport" content="width=device-width, initial-scale=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    
	<meta name="HandheldFriendly" content="True" />
	<meta name="MobileOptimized" content="width"/>
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />

    <title>메인 메뉴</title>

	<!--JQM globals you can edit or remove file entirely... note it needs to be loaded before jquerymobile js -->
	<script src="/js/jqm.globals.js"></script>

	<!--Include JQuery -->
	<link rel="stylesheet" href="http://code.jquery.com/mobile/latest/jquery.mobile.structure.min.css" />

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/mobile/latest/jquery.mobile.min.js"></script>
	<script src="/js/jquery.animate-enhanced.min.js"></script>


	<!--JQM SlideMenu-->
	<link rel="stylesheet" href="/css/themes/jqmfb.min.css" />
	<link rel="stylesheet" href="/css/jqm.slidemenu.css" />
	<script src="/js/jqm.slidemenu.js"></script>

</head>

<body>

    <!-- Main Page -->
	<div data-role="page" id="main_page" data-theme="a">

		<div data-role="header" data-position="fixed" data-tap-toggle="false" data-update-page-padding="false">
			<a href="#" data-slidemenu="#slidemenu" data-slideopen="true" data-icon="smico" data-corners="false" data-iconpos="notext">Menu</a>
			<h1>Slide Menu</h1>
		</div>

		<div data-role="content" id="slidemenu">
            <!-- 메뉴 -->  
		    <div id="profile">
			    <img src="/img/tegan.jpg" />
			    <div class="profile_info"><strong>Tegan Snyder</strong><br/><small>Web &amp; Mobile Developer</small></div>
		    </div>

		    <h3>MENU</h3>
		    <ul>
			    <li><a href="/view/bas/TestBas1.aspx" rel="external"><img src="img/smico3.png"/>TestBas1</a></li>
			    <li><a href="/view/bas/TestBas2.aspx" rel="external"><img src="img/smico2.png"/>TestBas2</a></li>
			    <li><a href="/view/bas/TestBas3.aspx" rel="external"><img src="img/smico5.png"/>TestBas3</a></li>
		    </ul>

		    <h3>SOMETHING</h3>
		    <ul>
			    <li><a href="/view/ras/MRasEcnStsView.aspx" rel="external"><img src="img/smico3.png"/>TestRpt1</a></li>
			    <li><a href="/view/rpt/TestRpt2.aspx" rel="external"><img src="img/smico2.png"/>TestRpt2</a></li>
			    <li><a href="/view/rpt/TestRpt3.aspx" rel="external"><img src="img/smico5.png"/>TestRpt3</a></li>
		    </ul>
	     </div>
	</div>

</body>
</html>
