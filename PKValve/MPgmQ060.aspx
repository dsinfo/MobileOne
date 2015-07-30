<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-일일생산실적</title>
    <meta charset="utf-8" /> 
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" >
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.css" />   
    <style type="text/css">
         
    .ui-filterable {

        margin:0px;
        padding:0px;
    }
    
    .ui-span-name
    {
         font-weight : bold;      
    }
    
    .ui-span-gname
    {
         font-size : 0.7em;
         
    }
    
    .ui-a-link
    {
         text-decoration:none;          
    }
    
    .ui-tbl-caption 
    {
            width: 15%;                           
            text-align : right;
    }
        
    .ui-tbl-content 
    {
            width: 35%;                           
            padding-right : 10px;
            text-align : right;
    }
        
    .ui-tbl-list
    {
        font-size:0.8em;width:100%;
    }

    
    </style>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script type= "text/javascript" src="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script>     
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript" src="JScript/CommonFunc.js"></script>
    <script type="text/javascript" src="JScript/jquery.number.min.js"></script>
    <script type="text/javascript">
    
        var $fdate = null;
        var $tdate = null;
        var orgData = null;
        var dataSet = null;
        var $idContent = null;
        var $idContentChart = null;
        var $idContentNone = null;
        var stype = "l";
        var gubun = "금액(환율)";
        var ctype = "ALL";
        var wrknm = '';
     

        google.load("visualization", "1", { packages: ["corechart"] });

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idDailyProductionPage', 'idMenu', true);

            //날짜설정
            $fdate = $('#idFdate');
            $tdate = $('#idTdate');

            $idContent = $('#idContent');
            $idContentChart = $('#idContentChart');
            $idContentNone = $('#idContentNone');

            document.getElementById("idFdate").value = formatDate(new Date());
            document.getElementById("idFdate").value = document.getElementById("idFdate").value.substr(0, 8) + '01';
            document.getElementById("idTdate").value = formatDate(new Date());

            //$fdate.attr('value', formatDate(new Date()));
            //$fdate.val($fdate.val().substr(0, 8) + '01');
            //$tdate.attr('value', formatDate(new Date()));

            //검색 이벤트 연결
            $('#idSearch').on('click', function () {
                fn_getDailyProduction();
            });

            //리스트/챠트 보기
            $('#idOptQuery').find('input').on('click', function () {
                stype = ttype = $(this).val();
                if (orgData == null) {
                    fn_getDailyProduction();
                    return;
                }
                if (stype == "l") fn_setDailyProduction();
                else fn_setDailyProductionChart();
            });

            //챠트항목 구분
            $('#divNav').find('a').on('click', function () {
                if (orgData == null || orgData == '') return;
                gubun = $(this).attr('GUBUN');
                fn_setDailyProductionChart();
            });

            //전체/사내/사외
            $('#idOptCtype').find('input').on('click', function () {
                ctype = $(this).attr('value');
                ShowDetailChart();
            });

        });

        //생산
        function fn_getDailyProduction() {

            fn_loading('show');

            $.ajax({
                type: "POST",
                url: 'WebService/Momast.asmx/GetDailyProduction',
                data: JSON.stringify({ fdate: $fdate.val().replace(/-/ig, ""), tdate: $tdate.val().replace(/-/ig, "") }),
//                data: JSON.stringify({ fdate: '20140701', tdate: '20140701' }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $idContent.empty();
                    if (data.d != "") {

                        orgData = JSON.parse(data.d);

                        if (stype == "l") {
                            fn_setDailyProduction();
                        }
                        else {
                            fn_setDailyProductionChart();
                        }

                        fn_showContent(true);

                    } else {

                        fn_showContent(false);
                    }

                    fn_loading('hide');
                },
                error: function (err) {
                    $idContent.empty();
                    alert(err.toLocaleString());

                    fn_showContent(false);
                    fn_loading('hide');
                }
            });
        }

        function fn_setDailyProduction() {

            var gkey = "";
            var strHtml = '';

            $idContent.empty();

            orgData.forEach(function (data) {

                var div = null;
                var h1 = null;
                var ul = null;
                var $li = null;

                if (gkey == "" || gkey != data.WCODE.trim()) {
                    div = document.createElement('div');
                    h3 = document.createElement('h3');
                    ul = document.createElement('ul');

                    //속성 & 스타일 부여
                    $(div).attr('data-role', 'collapsible').attr('data-collapsed', 'true').attr('data-inset', 'false').attr('data-iconpos', 'right');
                    $(h3).text(data.WRKNM.trim());
                    $(ul).attr('data-role', 'listview').attr('id', 'idUl' + data.WCODE);

                    //컨텐츠에 넣기
                    $idContent.append(div);
                    $(div).append(h3).append(ul);


                }

                $li = $('<li></li>');

                strHtml = ''
                strHtml = strHtml + '<table class="ui-tbl-list"><tr><td class="ui-td-caption" colspan="4"><span style="font-weight:bold;font-size:1.2em;">' + (data.GDES2.trim() != '' && data.COLSQ == '' ? data.GDESC.trim() + '(' + data.GDES2.trim() + ')' : data.GDESC.trim()) + '</span></td></tr>';
                strHtml = strHtml + '<tr><td class="ui-td-caption">수량</td><td class="ui-tbl-content">' + $.number(data.TRQTY) + '</td>';
                strHtml = strHtml + '<td class="ui-td-caption">중량</td><td class="ui-tbl-content">' + $.number(data.TRWGT) + '</td></tr>';
                strHtml = strHtml + '<tr><td class="ui-td-caption">금액</td><td class="ui-tbl-content">' + $.number(data.TRAMT) + '</td>';
                strHtml = strHtml + '<td class="ui-td-caption">금액(환율)</td><td class="ui-tbl-content">' + $.number(data.EXAMT) + '</td></tr></table>'

                $li.html(strHtml);

                if (data.COLSQ == '1') {
                    $li.css('background-color', 'LightSkyBlue');
                } else if (data.COLSQ == '2') {
                    $li.css('font-weight', 'bold').css('background-color', 'LightPink');
                }

                $('#idUl' + data.WCODE).append($li);

                gkey = data.WCODE.trim();

            });

            $('div[data-role="collapsible"]').collapsible({ refresh: true });
            $('ul[data-role="listview"]').listview({ refresh: true });

            fn_showContent(true);

        }

        function fn_showContent(isSucess) {
            if (isSucess) {
                if (stype == "l") {
                    $idContent.show();
                    $idContentChart.hide();
                }
                else {
                    $idContent.hide();
                    $idContentChart.show();
                }
                $idContentNone.hide();
            } else {
                $idContent.hide();
                $idContentChart.hide();
                $idContentNone.show();
            }
        }


        //챠트 그리기
        function fn_setDailyProductionChart() {
            var numValue = 0;
            var dataTable = new google.visualization.DataTable();

            dataSet = orgData.filter(function (elem) { return elem.COLSQ == 2 });

            dataTable.addColumn({ type: 'string', id: '공정' });
            dataTable.addColumn({ type: 'number', id: gubun });

            dataSet.forEach(function (data) {
                switch (gubun) {
                    case "수량":
                        numValue = data.TRQTY; break;
                    case "중량":
                        numValue = data.TRWGT; break;
                    case "금액":
                        numValue = data.TRAMT; break;
                    case "금액(환율)":
                        numValue = data.EXAMT; break;
                }
                dataTable.addRow([data.WRKNM.trim(), { v: numValue, f: $.number(numValue)}]);                
            });

            var chart = new google.visualization.PieChart(document.getElementById('idChartArea'));

            var options = {
//                title: "생산실적",
                //                titleTextStyle: { color: 'blue', fontSize: '12', bold: true },
                tooltip: { trigger: 'selection' },
                is3D: true               
            };

            chart.setAction({
                id: 'showDetail',                  // An id is mandatory for all actions.
                text: '상세보기',       // The text displayed in the tooltip.
                action: function () {           // When clicked, the following runs.
                    selection = chart.getSelection();
                    //상세보기
                    wrknm = dataTable.getValue(selection[0].row, 0);
                    ShowDetailChart();
                }
            });

//            google.visualization.events.addListener(chart, 'select', selectHandler);

            fn_showContent(true);

            chart.draw(dataTable, options);


        }

        //챠트보기 상세
        function ShowDetailChart() {

            var $content = $("#idDailyProductionDetailPage");
            var dataTable = new google.visualization.DataTable();

            if (wrknm == '조립' || wrknm == '수압검사') {
                $('#idDivChartOption').show();
                switch (ctype) {
                    case "ALL":
                        dataSet = orgData.filter(function (elem) { return elem.COLSQ == 1 && elem.WRKNM.trim() == wrknm });
                        break;
                    case "I":
                        dataSet = orgData.filter(function (elem) { return elem.WRKNM.trim() == wrknm && elem.COLSQ == '' && elem.GUBUN.trim().substr(0,1) != '4' });
                        break;
                    case "O":
                        dataSet = orgData.filter(function (elem) { return elem.WRKNM.trim() == wrknm &&  elem.COLSQ == '' && elem.GUBUN.trim().substr(0, 1) == '4' });
                        break;
                }
            } else {
                $('#idDivChartOption').hide();
                dataSet = orgData.filter(function (elem) { return elem.WRKNM.trim() == wrknm && elem.COLSQ == '' });
            }

            dataTable.addColumn({ type: 'string', id: '공정' });
            dataTable.addColumn({ type: 'number', id: gubun });

            dataSet.forEach(function (data) {
                switch (gubun) {
                    case "수량":
                        numValue = data.TRQTY; break;
                    case "중량":
                        numValue = data.TRWGT; break;
                    case "금액":
                        numValue = data.TRAMT; break;
                    case "금액(환율)":
                        numValue = data.EXAMT; break;
                }
                dataTable.addRow([(data.GDES2.trim() != '' && data.COLSQ == '' ? data.GDESC.trim() + '(' + data.GDES2.trim() + ')' : data.GDESC.trim()), { v: numValue, f: $.number(numValue)}]);
            });

            var chart = new google.visualization.PieChart(document.getElementById('idChartAreaDetail'));

            var options = {
                title: "생산실적 - " + wrknm,
                titleTextStyle: { color: 'blue', fontSize: '12', bold: true },
                tooltip: { trigger: 'selection' },
                is3D: true
            };

            chart.draw(dataTable, options);

            $content.popup('open');
        }

        $(window).resize(function () {
            if (stype == "c" && dataSet != '') fn_setDailyProductionChart();
        });

    </script>
</head>
<body>
    <!--페이지 정보-->   
    <div data-role="page" id="idDailyProductionPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>생산실적</h1>           
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>            
	    </div>


        <!--본문-->
	    <div data-role="content" style="padding:0px 5px 0px 5px;">           
            <ul data-role="listview" data-inset="true" >
                <li style="text-align:center;padding:0px">
                     <table style="text-align:center;margin:auto">
                        <tr>
                            <td style="width:10%">
                                일자:
                            </td>
                            <td style="width:40%">
                                <input type="date"  id="idFdate" />
                            </td>
                            <td style="width:40%">
                                <input type="date"  id="idTdate" />
                            </td>
                            <td style="width:10%">
                                <a href="#" id='idSearch' class="ui-btn ui-icon-search ui-btn-icon-notext ui-corner-all">No text</a>     
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align:center">
                                <fieldset  style="text-align:center;margin:auto" data-role="controlgroup" id="idOptQuery" data-type="horizontal" data-mini="true">              
                                    <input type="radio" name="radio-choice-b" id="radio-choice-c" value="l" checked="checked">
                                    <label for="radio-choice-c">리스트</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-d" value="c">
                                    <label for="radio-choice-d">챠트</label>                                                    
                                </fieldset>                            
                            </td>
                        </tr>
                    </table>
                  <%--  <span style="font-size:0.8em">(금액:천원)</span>         --%>
                </li>           
            </ul>           
     
        </div>
        
            <!--검색내역-미존재-->
            <ul id="idContentNone" data-role="listview" data-inset="true" style="margin: 10px 0px 0px 0px;display:none">
                <li>
                    <div><string>내역이 존재하지 않습니다!</string></div> 
                </li>                    
            </ul>

            <div id="idContent" style="padding:0px 5px 0px 5px" >          
            </div>

            <div id="idContentChart"  style="padding:0px 5px 0px 5px;display:none">
                <div data-role="navbar" id="divNav">
                    <ul>
                        <li><a href="#" GUBUN="수량">수량</a></li>
                        <li><a href="#" GUBUN="중량">중량</a></li>
                        <li><a href="#" GUBUN="금액">금액</a></li>
                        <li><a href="#" GUBUN="금액(환율)" class="ui-btn-active">금액(환율)</a></li>                        
                    </ul>
                </div><!-- /navbar -->
                <div id="idChartArea" style="width:100%;height:400px;"></div>
            </div>
            <!--팝업페이지-->
            <div data-role="popup" id="idDailyProductionDetailPage" class="ui-content">      
                <a href="#" data-rel="back" data-role="button" data-theme="a" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a> 
                <div style="text-align:center;margin:auto" id="idDivChartOption">                    
                    <fieldset data-role="controlgroup" data-type="horizontal" id="idOptCtype" data-mini="true">                                  
                        <input type="radio" name="c" id="radio1" value="ALL" checked="checked">
                        <label for="radio1">전체</label>
                        <input type="radio" name="c" id="radio2" value="I">
                        <label for="radio2">사내</label>
                        <input type="radio" name="c" id="radio3" value="O">
                        <label for="radio3">외주</label>
                    </fieldset>
                </div><!-- /navbar -->
	            <div id="idChartAreaDetail" style="width:100%;height:400px;"></div>
            </div>     
    </div>
</body>
</html>
