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
        .ui-tbl-caption 
        {
             width: 10%;                           
             text-align : right;
        }
        
        .ui-tbl-content 
        {
             width: 90%;                           
             padding-left : 10px;
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
    <script type="text/javascript">

        var orgData = null;
        var dataSet = null;
        var moData = null;
        var dataDetailSet = null;

        google.load("visualization", "1", { packages: ["corechart"] });


        //지시번호 필터링 설정
        $(document).on("pagecreate", "#idOrderProcessChartPage", function () { setOrderSearch('fn_setOrderProcessChart();'); });

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();
            

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idOrderProcessChartPage', 'idMenu', true);


            //페이지 리로드(스캔 또는 파라미터 호출)
            if (isReloadParamPage('input[data-type="search"]')) {
                fn_setOrderProcessChart();
            }

            //지시번호 EnterKey 이벤트 설정
            $('input[data-type="search"]').keydown(function (key) {

                if (key.keyCode == 13) {                  
                    $("#idSearchOrdno *").hide();
                    fn_setOrderProcessChart();
                }
            });

        });

        //지시정보(공정)
        function fn_setOrderProcessChart() {

            var sInput= $('input[data-type="search"]');
            if (sInput.val() == "") {
                alert("지시번호를 입력하세요!");
                 sInput.focus();
                return;
            }

            fn_loading('show');

            orgData = fn_GetData('Momast.asmx/GetOrderProcessChart', { ordno: sInput.val() });

            if (orgData == '') {

                $('#idContent').hide();
                $('#idContentNone').show();

                fn_loading('hide');
                return;
            }

            dataSet = orgData.filter(function (elem) { return elem.QTYPE == 'S' });
            moData = orgData.filter(function (elem) { return elem.QTYPE == 'M' });

            drawChart();

            fn_loading('hide');
        }

       
        //챠트 그리기
        function drawChart() {

            var $idContent = $('#idContent');
            var $idContentNone = $('#idContentNone');
            var opstc = 'black';

            if (dataSet != "") {

                var dataTable = new google.visualization.DataTable();
                var nORDQT = 0;

                dataTable.addColumn({ type: 'string', id: '공정' });
                dataTable.addColumn({ type: 'number', id: '작업량' });
                dataTable.addColumn({ type: 'string', role: 'style' }); // style role col.               
                dataTable.addColumn({ type: 'string', role: 'annotation' }); 
            
                $idContent.empty();
                dataSet.forEach(function (data) {
                    dataTable.addRow([data.OPSEQ.trim() + '-' + data.OPDSC.trim(), data.JOBQT, data.OPSTC.trim() >= '40' ? '#76A7FA' : 'red', String(data.JOBQT) + ' / ' + String(data.ORDQT)]);
                    nORDQT = data.ORDQT;
                });

                var gCount = 0;
                if (Number(moData[0].ORDQT) >= 10) {
                    var sNum = String(moData[0].ORDQT);
                    gCount = 4; //Number(sNum.substr(sNum.length - 1, 1))+3;                   
                } else {
                    gCount = Number(moData[0].ORDQT) + 1;
                }

                var chart = new google.visualization.BarChart(document.getElementById('idContent'));
                var options = {
                    title: moData[0].OPSEQ.trim() + ' (' + moData[0].OPDSC.trim() + ') - ' + moData[0].OPSTC.trim(),
                    titleTextStyle: { color: 'blue', fontSize: '12', bold: true },
                    hAxis: { format: '#,###', viewWindow: { min: 0, max: nORDQT }, gridlines: { count: gCount} },
                    legend: { position: 'none' },
                    tooltip: { trigger: 'none' },
                    annotations: { textStyle: { bold: true} }
                };

                  // The select handler. Call the chart's getSelection() method
                function selectHandler() {
                    var selectedItem = chart.getSelection()[0];
                    if (selectedItem) {
                        var value = dataTable.getValue(selectedItem.row,0);
                        var $content = $("#idOrderProcessChartDetailPage");
                        var $ul = $('<ul data-role="listview" data-inset="true" id="idDetailContent" ></ul>');
                        var liHtml = '';

                        $content.find('ul').empty();
                        dataDetailSet = orgData.filter(function (elem) { return elem.QTYPE == 'D' && elem.OPSEQ.trim() == value.split("-")[0]; });
                        dataDetailSet.forEach(function (data, index) {
                            liHtml = ''
                            if (index == 0) {
                                $ul.append(' <li data-role="list-divider">' + data.OPSEQ + ' ' + data.OPDSC.trim() + '(' + data.WCDSC.trim() + ')<span class="ui-li-count">' + dataDetailSet.length + '</span></li>');
                            }
                            var $li = $('<li></li>');
                            liHtml = '<table class="ui-tbl-list"><tr><td class="ui-td-caption" style="text-align:right;">처리일자 : </td><td colspan="3" style="width:100%" class="ui-td-data">' + data.TDATE.trim() + '</td></tr>';
                            liHtml = liHtml + '<tr><td class="ui-td-caption" style="text-align:right;">작 업 량 : </td><td style="width:40%" class="ui-td-data">' + data.JOBQT + '</td><td class="ui-td-caption" style="text-align:right;">불  량 : </td><td style="width:40%" class="ui-td-data">' + data.SCRQT + '</td></tr></table>';
                            $li.html(liHtml);
                            $ul.append($li);
                            $content.append($ul);
                        });

                        $content.popup('open');
                        $ul.listview({ refresh: true });
//                        alert('The user selected ' + value);
                    }
                }

                google.visualization.events.addListener(chart, 'select', selectHandler);

                chart.draw(dataTable, options);

                $idContentNone.hide();
                $idContent.show();
            } else {
                $idContentNone.show();
                $idContent.hide();
            }          
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
		    <h1>작업지시-공정(챠트)</h1>           
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
                                        <a href="zxing://scan/?ret=http://mbl.pkvalve.co.kr/MPgmQ050.aspx?code={CODE}" target="_self" id="idBtnSearch" class="ui-btn ui-icon-tag ui-btn-icon-notext ui-corner-all ui-btn-inline">바코드</a>
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

        <div data-role="popup" id="idOrderProcessChartDetailPage" class="ui-content">      
            <a href="#" data-rel="back" data-role="button" data-theme="a" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a> 
	       <%-- <ul data-role="listview" data-inset="true" id="idDetailContent" >
            </ul>--%>
        </div>    

    </div>
   

</body>
</html>