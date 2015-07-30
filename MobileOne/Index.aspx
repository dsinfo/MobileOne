<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="MobileONE.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"name="viewport" content="width=device-width, initial-scale=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    
	<meta name="HandheldFriendly" content="True" />
	<meta name="MobileOptimized" content="width"/>
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />

   	<!--JQM globals you can edit or remove file entirely... note it needs to be loaded before jquerymobile js -->
	<script src="js/jqm.globals.js"></script>

    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>


    <title>창원4공장</title>

    <!-- 동서 모바일 공통 기능 -->
	<link rel="stylesheet" href="css/themes/jqmfb.min.css" />
	<link rel="stylesheet" href="css/jqm.slidemenu.css" />

    <script src="/js/ds.common.js"></script>
	<script src="js/jqm.slidemenu.js"></script>

        <script type="text/javascript">

            //페이지 초기화
            $(document).ready(function () {

                //메뉴 슬라이더 사용여부
                if (localStorage["isSwipe"] == 'false') {
                    $("#idSwipe option:eq(1)").attr("selected", "selected");
                } else {

                    $("#idSwipe option:eq(0)").attr("selected", "selected");
                }

                //적용
                $('#idApply').on('click', function () {
                    if ($("#idSwipe option:selected").val() == 'yes') {
                        localStorage["isSwipe"] = 'true';
                    } else {
                        localStorage["isSwipe"] = 'false';
                    }
                });

                //설치
                $('#idDownload').on('click', function () {
                    $(this).attr('href', $("#idOs option:selected").val());
                });

                //메뉴설정
                pageDisplayMenu();

            });
    </script>  
</head>

<body>
    <div data-role="page" id="idIndexPage">

	    <div data-role="header" id='idIndex'>        
            <a href="#idConfigPage" data-rel="dialog" data-role="button" data-icon="gear" data-transition="pop">설정</a>
		    <h1>HOME-MENU</h1>            
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>
	    </div>
	    <div data-role="content" id='idMenuContent'>		    
	    </div>    
    </div>  


    <!-- 
        titile : 환경 설정 페이지 
        desc   : 메인 화면 우측 상단 설정 버튼 선택 시 나타남.
    -->
    <div data-role="page" id="idConfigPage" >
        <div data-role="header">
		    <h1>환경설정</h1>
		</div>


		<div role="main" class="ui-content">

            <label for="select-choice-a" class="select">바코드 스캔 앱:</label>
            <select name="select-choice-a" id="idOs" data-native-menu="false" data-inline="true">
                <option value="#">운영체제(OS)</option>
                <option value="market://details?id=com.google.zxing.client.android" selected="true">안드로이드</option>
                <option value="https://itunes.apple.com/kr/app/quik/id417257150">IOS(애플)</option>                
            </select>
            <a id="idDownload" href="market://details?id=com.google.zxing.client.android" class="ui-btn ui-btn-inline">설치하기</a>
            
            <label for="slider2">메뉴 슬라이더:</label>
            <select name="slider2" id="idSwipe" data-role="slider">
                <option value="yes">사용</option>
                <option value="no">미사용</option>
            </select>

          <%--  <label for="slider3">테마:</label>
            <select name="slider3" id="idTheme" data-role="slider">
                <option value="a">a</option>
                <option value="b">b</option>
            </select>--%>
            		
			<a href="#idIndexPage" id='idApply' data-rel="back" class="ui-btn ui-shadow ui-corner-all ui-btn-a">적 용</a>
			<a href="#idIndexPage" id='idClose' data-rel="back" class="ui-btn ui-shadow ui-corner-all ui-btn-a">닫 기</a>
		</div>
    </div>

</body>
</html>
