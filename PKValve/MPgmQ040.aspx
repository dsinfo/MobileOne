<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-작업지시(공정-챠트)</title>
    <meta charset="utf-8" /> 
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" >
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.css" />
    <style type="text/css">
         
    </style>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script type= "text/javascript" src="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script> 
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="JScript/CommonFunc.js"></script>
    <script type="text/javascript">
       
        //지시번호 필터링 설정
        $(document).on("pagecreate", "#idOrderProcessChartPage", function () { setOrderSearch('fn_getOrderAllocateItem();'); });

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();
            

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idOrderAllocatePage', 'idMenu', true);


            //페이지 리로드(스캔 또는 파라미터 호출)
            if (isReloadParamPage('input[data-type="search"]')) {
                fn_getOrderAllocateItem();
            }

            //지시번호 EnterKey 이벤트 설정
            $('input[data-type="search"]').keydown(function (key) {

                if (key.keyCode == 13) {                  
                    $("#idSearchOrdno *").hide();
                    fn_getOrderAllocateItem();
                }
            });

        });

        //지시정보(할당) 가져오기
        function fn_getOrderAllocateItem() {

            var sInput= $('input[data-type="search"]');
            if (sInput.val() == "") {
                alert("지시번호를 입력하세요!");
                 sInput.focus();
                return;
            }

            fn_loading('show');

            drawChart();

            fn_loading('hide');
        }


        // Load the Visualization API and the piechart package.
        google.load('visualization', '1.0', { 'packages': ['corechart'] });
        google.setOnLoadCallback(drawChart);

        function drawChart() {

            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', '토핑');
            data.addColumn('number', '슬라이스');
            data.addRows([
                                  ['머시룸', 3],
                                  ['양파', 1],
                                  ['올리브', 1],
                                  ['쥬치니', 1],
                                  ['파파로니', 2]
                                ]);

            // Set chart options
            var options = { 'title': '피자'
            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.BarChart(document.getElementById('idContent'));
            chart.draw(data, options);


        }

        $(window).resize(function () {
            drawChart();
        });
    </script>
</head>
<body>   
    <div data-role="page" id="idOrderProcessChartPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay" data-theme="a">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>작업지시-할당품목</h1>           
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>
	    </div>

        <!--본문-->
	    <div data-role="content">  
                <!--검색바-->
                <ul data-role="listview" data-inset="true" style="margin:0px">
                    <li class="ui-field-contain" style="padding:5px">
                        <table>
                            <tr>                                
                                <td style="width:100%">
                                    <ul id="idSearchOrdno" data-role="listview" data-inset="true" data-filter="true" data-filter-placeholder="지시번호...">
                                    </ul>
                                    <%--<input type="search" id="idSearchOrdno" placeholder="지시번호" />--%>
                                </td>
                                <td style="width:40px">
                                      <cfoutput>
                                        <a href="#" onclick='drawChart();' id="idBtnSearch" class="ui-btn ui-icon-tag ui-btn-icon-notext ui-corner-all ui-btn-inline">바코드</a>
                                       <%-- <a href="http://mbl.pkvalve.co.kr/MPgmQ020.aspx?code=13-00633-012-0001" target="_self" id="idBtnSearch" class="ui-btn ui-icon-tag ui-btn-icon-notext ui-corner-all ui-btn-inline">바코드</a>--%>
                                    </cfoutput>
                                    <%--<input type="button" class="ui-btn-icon-notext" id="idBtnSearch" value="" data-icon="tag"  onclick="fn_getOrderInformation()"/>--%>
                                </td>
                            </tr>
                        </table>  
                    </li>
                </ul>

                <!--검색내역-미존재-->
                <ul id="idContentNone" data-role="listview" data-inset="true" style="margin: 10px 0px 0px 0px;display:none">
                    <li>
                       <div><string>지시번호에 해당되는 내역이 존재하지 않습니다!</string></div> 
                    </li>                    
                </ul>

                <div id="idContent"  style="margin-top:16px;width:100%;height:400px">
                </div>
	    </div>    
    </div>
</body>
</html>
