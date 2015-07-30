<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MobileOne.Login" %>

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

   	<!--JQM globals you can edit or remove file entirely... note it needs to be loaded before jquerymobile js -->
	<script src="js/jqm.globals.js"></script>

    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>


    <title>로그인</title>

    <!-- 동서 모바일 공통 기능 -->
	<link rel="stylesheet" href="css/themes/jqmfb.min.css" />
	<link rel="stylesheet" href="css/jqm.slidemenu.css" />

    <script src="/js/ds.common.js"></script>
	<script src="/js/jqm.slidemenu.js"></script>

    <script>
        //사용자 로그인
        function login() {

            //유효성 체크
            if ($('#txtUserName').val() == "") {
                alert("사용자 ID를 입력하세요!");
                $('#txtUserName').focus();
                return;
            }

            if ($('#txtPassword').val() == "") {
                alert("비밀번호를 입력하세요!");
                $('#txtPassword').focus();
                return;
            }

            pageLoading('show');

            var dataSet = reqAjaxService('LoginService.asmx/Login', { userid: $('#txtUserName').val(), password: $('#txtPassword').val() });

            pageLoading('hide');

            if (dataSet != "") {
                switch (dataSet.msg_ID) {
                    case "OK":
                        sessionStorage['usr_ID'] = $('#txtUserName').val();
                        // sessionStorage['SSNID'] = dataSet[0].SSNID;

                        alert("OK...");
                        setMenu($('#txtUserName').val());

                        //$.cookie('SMENU', getMenudString($('#txtUserName').val()), { path: '/' });
                        location.replace('Index.aspx');

                        return;
                    case "ERR0008":
                        alert("사용자가 등록되어 있지 않습니다!");
                        $('#txtUserName').focus();
                        return;
                    case "ERR0009":
                        alert("비밀번호를 다시 입력하세요!");
                        $('#txtPassword').focus();

                        return;
                    case "ERR0010":
                        alert("사용 권한이 없습니다!");
                        $('#txtPassword').focus();

                        return;
                }
            }

            pageLoading('hide');
        }
    </script>

</head>

<body>
    <div data-role="page"  class='ui_bar_body' >
        <div data-role="header"  data-position="fixed" class='ui-bar-head'>
            <div style="width:100%;height:20px;background:#b3cee9"></div>
            <div style="width:100%;height:10px;background:#ddf0f8"></div>
            <div style ="background: White;"><img src="/img/logo.png" style='display:block;padding: 6px 0px 0px 10px;' /></div>
        </div>

         <div data-role="content" style="margin:80px 40px 80px 40px" >	            
            <div >
                <label for="username">사용자:</label>
                <input type="text" name="username" id="txtUserName"  placeholder="Username" />
               
                <label for="password">비밀번호:</label>
                <input type="password" name="password" id="txtPassword"  placeholder="Password" />
              
                <input type="checkbox" id="chkIdSave" name="chkSave" class="ui-btn-inline" />
	            <label for="chkIdSave" >아이디 저장</label>

                <input type="button" value="로그인" id="btnLogin" onclick='login();'  />	               
            </div>      
	    </div> 

       <div data-role="footer" data-position="fixed" style="background:#b3cee9;border:0px" >
            <div class="ui_span">본사 : 경상남도 창원시 성산구 공단로80</div>
            <div class="ui_span">서울사무소 : 서울시 강남구 영동대로 511 트레이드타워 1102호</div>
            <div class="ui_span">TEL:055-268-3777 FAX:055-286-0281,055-286-4447</div>
            <div class="ui_span">Copyright 2011 PKVALVE Corporation. All rights reserved.</div>            
        </div>        
    </div>    	 

</body>

</html>
