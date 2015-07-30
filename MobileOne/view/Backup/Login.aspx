<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MobileONE.view.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>창원4공장 로그인</title>
    <meta charset="utf-8" /> 
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>   
    <script type="text/javascript" src="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script>    
    <script type="text/javascript" src="js/DsiCommon.js"></script>    

    <style type="text/css">
       
         /*상단 header 바 설정*/
        .ui-bar-head 
        {
             border: 0;
             background: White;
             color:      #2e78bf;
             font-weight: bold;    
        }
        
        .ui_bar_body
        {
            background-image: -webkit-gradient(linear,left top,left bottom,
                                color-stop(0,   #FFFFFF),
                                color-stop(1,   #b3cee9));
                                -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorStr='#FFFFFF', EndColorStr='#b3cee9')";
        }
        
        .ui_bar_center 
        {
	        width: 300px;	/* 폭이나 높이가 일정해야 합니다. */
	        height: 200px;	/* 폭이나 높이가 일정해야 합니다. */
	        position: absolute;
	        top: 50%;	/* 화면의 중앙에 위치 */
	        left: 50%;	/* 화면의 중앙에 위치 */
	        margin: -100px 0 0 -150px;	/* 높이의 절반과 너비의 절반 만큼 margin 을 이용하여 조절 해 줍니다. */	  
	        padding : 8px;	  		   
         }
        
        .ui_span
        {
            font-size: x-small;
            font-weight:bold;
            text-align:center;        
        }
    </style>
    
    <script type="text/javascript">
        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            //pageInit();

            //사용자ID 포커스
            /*
            if (localStorage["userId"] != null) {
                $('#txtUserName').val(localStorage["userId"]);
                $("#chkIdSave").prop('checked', true).checkboxradio("refresh");
                $('#txtPassword').focus();
            }
            else {
                $('#txtUserName').focus();
            }

            //EnterKey 이벤트 설정
            $("#txtUserName, #txtPassword").keydown(function (key) {
                if (key.keyCode == 13) {
                    fn_login1();
                }
            });

            $("#chkIdSave").on("click", function () {
                if ($('#txtUserName').val() != null) {
                    if ($(this).is(':checked') == true) {
                        localStorage["userId"] = $('#txtUserName').val();
                    } else {
                        localStorage.removeItem("userId");
                    }
                }
            });
            */

        });

        //function fn_login() {
            //alert("로그인 버튼 선택1");
            //var dataSet = fn_GetData('LoginService.asmx/Login', { userid: $('#txtUserName').val(), password: $('#txtPassword').val() });
            //fn_GetData1('LoginService.asmx/Login', { userid: $('#txtUserName').val(), password: $('#txtPassword').val() });
            //fn_login1();
        //}

        //사용자 로그인
        function fn_login1() {

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

            //fn_loading('show');

            var dataSet = fn_GetData1('LoginService.asmx/Login', { userid: $('#txtUserName').val(), password: $('#txtPassword').val() });

            //alert(dataSet.toString());

            //location.replace('Index.aspx');

            if (dataSet != "") {
                switch (dataSet) {
                    case "OK":
                        alert("OK!");
                        //sessionStorage['USRID'] = $('#txtUserName').val();
                        //sessionStorage['SSNID'] = dataSet[0].SSNID;
                        // setMenudString($('#txtUserName').val());
                        //$.cookie('SMENU', getMenudString($('#txtUserName').val()), { path: '/' });
                        location.replace('Main.aspx');
                        return;
                    case "ERR0008":
                        alert("사용자가 등록되어 있지 않습니다!");
                        $('#txtUserName').focus();
                        fn_loading('hide');
                        return;
                    case "ERR0009":
                        alert("비밀번호를 다시 입력하세요!");
                        $('#txtPassword').focus();
                        fn_loading('hide');
                        return;
                    case "ERR0010":
                        alert("사용 권한이 없습니다!");
                        $('#txtPassword').focus();
                        fn_loading('hide');
                        return;
                }
            }


           // fn_loading('hide');

        }

        function fn_GetData1(serviceName, jsonParam) {
            var result = "";

            $.ajax({
                type: "POST",
                url: "/service/" + serviceName,
                data: JSON.stringify(jsonParam),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d != "") {
                        result = JSON.parse(data.d);
                        alert("SUCCESS");
                    }
                    else {
                        alert("SUCCESS not");
                    }
                },
                error: function (err) {
                    alert("오류");

                    alert(err.toLocaleString());
                }
            });

            return "OK";  //result;
        }
    </script>  
</head>

<body>
    <section id="Login" data-role="page">
        <header data-role="header"><h1>로그인</h1></header>
        <div data-role="content"  class='ui_bar_body'  >
            <div data-role="header"  data-position="fixed" class='ui-bar-head'>
                <div style="width:100%;height:20px;background:#b3cee9"></div>
                <div style="width:100%;height:10px;background:#ddf0f8"></div>
                <div style ="background: White;"><img src="Images/logo.png" style='display:block;padding: 6px 0px 0px 10px;' /></div>
            </div>
            <div data-role="content" style="margin:80px 40px 80px 40px" >	            
                <div >
                    <label for="username">사용자:</label>
                    <input type="text" name="username" id="txtUserName"  placeholder="Username" />
               
                    <label for="password">비밀번호:</label>
                    <input type="password" name="password" id="txtPassword"  placeholder="Password" />
              
                    <input type="checkbox" id="chkIdSave" name="chkSave" class="ui-btn-inline" />
	                <label for="chkIdSave" >아이디 저장</label>

                    <input type="button" value="로그인" id="btnLogin" onclick='fn_login1();'  />	               
                </div>      
	       </div> 
           <div data-role="footer" data-position="fixed" style="background:#b3cee9;border:0px" >
                <div class="ui_span">본사 : 경상남도 창원시 성산구 공단로80</div>
                <div class="ui_span">서울사무소 : 서울시 강남구 영동대로 511 트레이드타워 1102호</div>
                <div class="ui_span">TEL:055-268-3777 FAX:055-286-0281,055-286-4447</div>
                <div class="ui_span">Copyright 2011 PKVALVE Corporation. All rights reserved.</div>            
            </div>        
        </div>    	 
    </section>

</body>
</html>
