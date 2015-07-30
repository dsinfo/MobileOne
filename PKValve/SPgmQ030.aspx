<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-영업일보-생산(수압)부하현황</title>
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
         text-decoration:none
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
      
        
        var $tdate = null;
        var orgData = null;
        var dataSet = null;
        var $idContent = null;
        var $idContentChart = null;
        var $idContentNone = null;
        var arrCaption = new Array(8);
        var arrDept = ['기계-대형', '기계-소형', '기계-SUS', '외    주'];
        var arrDeptColor = ['#0000FF', '#FF0000', '#FF8000', '#04B404'];
        var sAMT = 0;
        var sQty = 0;
        var stype = "l";
        var gubun = "ALL";
        var ctype = "AMT";

        google.load("visualization", "1", { packages: ["corechart"] });
        

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            //pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idProductionLoadPage', 'idMenu', true);

            //오늘일자 설정
            $tdate = $('#idTdate');
            document.getElementById("idTdate").value = formatDate(new Date());

            $idContent = $('#idContent');
            $idContentChart = $('#idContentChart');
            $idContentNone = $('#idContentNone');

            //$tdate.attr('value', formatDate(new Date()));

            //검색 이벤트 연결
            $('#idSearch').on('click', function () {
                fn_getProductionLoad();
            });

            //리스트/챠트 보기
            $('#idOptQuery').find('input').on('click', function () {
                stype = $(this).val();
                if (orgData == null) {
                    fn_getProductionLoad();
                    return;
                }
                if (stype == "l") fn_setProductionLoad();
                else fn_setProductionLoadChart();
            });

            //챠트항목 구분
            $('#divNav').find('a').on('click', function () {
                if (orgData == null || orgData == '') return;
                gubun = $(this).attr('GUBUN');
                fn_setProductionLoadChart();
            });

            //수량/금액
            $('#idOptCtype').find('input').on('click', function () {
                ctype = $(this).attr('value');
                fn_setProductionLoadChart();
            });

        });

        //영업
        function fn_getProductionLoad() {

            fn_loading('show');


            $.ajax({
                type: "POST",
                url: 'WebService/Salsum.asmx/GetProductionLoad',
                data: JSON.stringify({ tdate: $tdate.val().replace(/-/ig, "") }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    makeCaption();
                    $idContent.empty();
                    if (data.d != "") {

                        orgData = JSON.parse(data.d);

                        if (stype == "l") {
                            fn_setProductionLoad();
                        }
                        else {
                            fn_setProductionLoadChart();
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

        //정보 설정
        function fn_setProductionLoad() {

            $idContent.empty();            
                
            var strHtml = '';
            sAMT = 0;
            sQty = 0;             

              
            orgData.forEach(function (data, index) {

                makeProductionLoad(data);

            });

            $('div[data-role="collapsible"]').collapsible({ refresh: true });
            $('ul[data-role="listview"]').listview({ refresh: true });

            fn_showContent(true);
          
        }

        //부하내역 만들기
        function makeProductionLoad(data) {

            var div = null;
            var h1 = null;
            var ul = null;
            var $li = null;

            div = document.createElement('div');
            h3 = document.createElement('h3');
            ul = document.createElement('ul');

            //속성 & 스타일 부여
            $(div).attr('data-role', 'collapsible').attr('data-collapsed', 'true').attr('data-inset', 'false').attr('data-iconpos', 'right');
            $(h3).text( data.DPTNM.trim());
            $(ul).attr('data-role', 'listview').attr('data-theme', 'a').attr('data-divider-theme', 'b').attr('id', 'idUl' + data.DPTNM);

            if (data.DPTNM.trim() == '합    계') $(div).attr('data-collapsed', 'false');

            //컨텐츠에 넣기                        
            $(div).append(h3).append(ul);

            if (data.DPTNM.trim() == '합    계') $idContent.prepend(div);
            else $idContent.append(div);

            sAMT = 0;
            sAMT = Number(data['01AMT']) + Number(data['02AMT']) + Number(data['03AMT']) + Number(data['04AMT']) + Number(data['05AMT']) + Number(data['06AMT']) + Number(data['07AMT']);

            sQTY = 0;
            sQTY = Number(data['01QTY']) + Number(data['02QTY']) + Number(data['03QTY']) + Number(data['04QTY']) + Number(data['05QTY']) + Number(data['06QTY']) + Number(data['07QTY']);

          
            $li = $('<li></li>');
            strHtml = ''
            strHtml = strHtml + '<table class="ui-tbl-list"><tr><td class="ui-tbl-caption">' + arrCaption[0] + '</td><td class="ui-tbl-content">' +  $.number(data['01AMT']) + ' ( ' + $.number(data['01QTY']) + ' )</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[1] + '</td><td class="ui-tbl-content">' + $.number(data['02AMT']) + ' ( ' + $.number(data['02QTY']) + ' )</td></tr>';
            strHtml = strHtml + '<tr><td class="ui-tbl-caption">' + arrCaption[2] + '</td><td class="ui-tbl-content">' + $.number(data['03AMT'])  + ' ( ' +  $.number(data['03QTY']) + ' )</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[3] + '</td><td class="ui-tbl-content">' + $.number(data['04AMT'])  + ' ( ' +  $.number(data['04QTY']) + ' )</td></tr>';
            strHtml = strHtml + '<tr><td class="ui-tbl-caption">' + arrCaption[4] + '</td><td class="ui-tbl-content">' + $.number(data['05AMT'])  + ' ( ' + $.number(data['05QTY']) + ' )</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[5] + '</td><td class="ui-tbl-content">' +  $.number(data['06AMT'])  + ' ( ' + $.number(data['06QTY']) + ' )</td></tr>'
            strHtml = strHtml + '<tr><td class="ui-tbl-caption">' + arrCaption[6] + '</td><td class="ui-tbl-content">' + $.number(data['07AMT']) + ' ( ' +  $.number(data['07QTY']) + ' )</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[7] + '</td><td class="ui-tbl-content">' + $.number(sAMT)  + ' ( ' + $.number(sQTY) + ' )</td></tr></table>'
            $li.html(strHtml);
            $(ul).append($li);
        }

        //캡션 만들기
        function makeCaption() {
            var mm = $tdate.val().replace(/-/ig, "");
            mm = Number(mm.substr(4, 2));

            for (var i = 0; i < 8; i++) {
                if (i == 0) {
                    if ((mm - 1) == 0) arrCaption[0] = "12월 이전"
                    else arrCaption[i] = String(mm - 1) + '월 이전';
                } else {
                    if ((mm + i-1) > 12) arrCaption[i] = String((mm + i-1) - 12) + '월';
                    else  arrCaption[i] = String(mm + i-1) + '월';

                    if (i == 6) arrCaption[i] = arrCaption[i] + "이후";
                }

                if (i == 7) arrCaption[7] = "합계";
            }
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
        function fn_setProductionLoadChart() {
    
            var numValue = 0;   
            var dataTable = new google.visualization.DataTable();
            var dataValue = [0, 0, 0, 0, 0];
            var chart = null;
            var options = null;

            
            //월별
            if(gubun=="ALL" || gubun=="MSUM"){

                dataTable.addColumn({ type: 'string', id: '월' });
                if (gubun == "ALL") {
                    dataTable.addColumn({ type: 'number', id: '기계-대형', label: '대형' });
                    dataTable.addColumn({ type: 'number', id: '기계-소형', label: '소형' });
                    dataTable.addColumn({ type: 'number', id: '기계-SUS', label: 'SUS' });
                    dataTable.addColumn({ type: 'number', id: '외    주', label: '외주' });
                } else {
                    dataTable.addColumn({ type: 'number', id: '합    계', label: '합계' });
                }


                for (var i = 0; i < arrCaption.length - 1; i++) {
                    dataValue = [0, 0, 0, 0, 0];
                    orgData.forEach(function (data, index) {
                        switch (data.DPTNM.trim()) {
                            case "기계-대형":
                                dataValue[0] = data['0' + (i + 1) + ctype];
                                break;
                            case "기계-소형":
                                dataValue[1] = data['0' + (i + 1) + ctype];
                                break;
                            case "기계-SUS":
                                dataValue[2] = data['0' + (i + 1) + ctype];
                                break;
                            case "외    주":
                                dataValue[3] = data['0' + (i + 1) + ctype];
                                break;
                            case "합    계":
                                dataValue[4] = data['0' + (i + 1) + ctype];
                                break;
                        }
                    });

                    if (gubun == "ALL") {
                        dataTable.addRow([arrCaption[i], { v: dataValue[0], f: $.number(dataValue[0]) }, { v: dataValue[1], f: $.number(dataValue[1]) },
                                                { v: dataValue[2], f: $.number(dataValue[2]) }, { v: dataValue[3], f: $.number(dataValue[3])}]);
                    } else {
                        dataTable.addRow([arrCaption[i], { v: dataValue[4], f: $.number(dataValue[4])}]);
                    }
                }

                chart = new google.visualization.LineChart(document.getElementById('idChartArea'));
                options = {
                    //                title: "생산(수압)부하현황",
                    //                titleTextStyle: { color: 'blue', fontSize: '12', bold: true }    
                    //                legend: { position: 'top' }
                    tooltip: { trigger: 'selection' },
                    pointSize: 4
                };

            } else {

                dataTable.addColumn({ type: 'string', id: '부서' });
                dataTable.addColumn({ type: 'number', id: '금액', label: '합계' })
                dataTable.addColumn({ type: 'string', role: 'style' })

                for (var i = 0; i < arrDept.length; i++) {
                    numValue = 0;
                    orgData.forEach(function (data, index) {
                        if (data.DPTNM.trim() == arrDept[i]) {
                            numValue = data['01' + ctype] + data['02' + ctype] + data['03' + ctype] + data['04' + ctype] + data['05' + ctype] + data['06' + ctype] + data['07' + ctype];  
                        }    
                    });
                    dataTable.addRow([arrDept[i], { v: numValue, f: $.number(numValue)}, arrDeptColor[i]]);
                }

                chart = new google.visualization.ColumnChart(document.getElementById('idChartArea'));
                options = {
                    //                title: "생산(수압)부하현황",
                    //                titleTextStyle: { color: 'blue', fontSize: '12', bold: true }    
                    //                legend: { position: 'top' }
                    tooltip: { trigger: 'selection' },
                    legend: 'none'
                };
            }
            
           

            // The select handler. Call the chart's getSelection() method
//            function selectHandler() {
//                var selectedItem = chart.getSelection()[0];
//                if (selectedItem) {
//                    var value = dataTable.getValue(selectedItem.row, 0);
//                    alert(value);
//                }
//            }

//            google.visualization.events.addListener(chart, 'select', selectHandler);

            fn_showContent(true);

//            dataTable.hideRows([0]);
            chart.draw(dataTable, options);
        }

        $(window).resize(function () {
            if (stype == "c" && dataSet != '') fn_setProductionLoadChart();
        });

    </script>
</head>
<body>
    <!--페이지 정보-->   
    <div data-role="page" id="idProductionLoadPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>영업일보-생산(수압)부하현황</h1>           
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>            
	    </div>


        <!--본문-->
	    <div data-role="content">           
            <ul data-role="listview" data-inset="true" style="margin:0px;padding:0px">
                <li style="text-align:center; ">                    
                     <table style="text-align:center;margin:auto">
                        <tr>
                            <td style="width:10%">
                                일 자 :
                            </td>                          
                            <td style="width:80%">
                                <input type="date"  id="idTdate" />
                            </td>
                            <td style="width:10%">
                                <a href="#" id='idSearch' class="ui-btn ui-icon-search ui-btn-icon-notext ui-corner-all">No text</a>     
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="text-align:center">
                                <fieldset  style="text-align:center;margin:auto" data-role="controlgroup" id="idOptQuery" data-type="horizontal" data-mini="true">              
                                    <input type="radio" name="radio-choice-b" id="radio-choice-c" value="l" checked="checked">
                                    <label for="radio-choice-c">리스트</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-d" value="c">
                                    <label for="radio-choice-d">챠트</label>                                                    
                                </fieldset>                            
                            </td>                            
                        </tr>
                    </table>
                     <span style="font-size:0.8em">(금액:천원)</span>             
                </li>                
            </ul> 

            <!--검색내역-미존재-->
            <ul id="idContentNone" data-role="listview" data-inset="true" style="margin: 10px 0px 0px 0px;display:none">
                <li>
                    <div><string>내역이 존재하지 않습니다!</string></div> 
                </li>                    
            </ul>

            <div id="idContent" style="margin:10px 0px 0px 0px;display:none">          
            </div><!--CONTENT 끝-->   
            
             <div id="idContentChart"  style="padding:10px 0px 0px 0px;display:none">
                <div data-role="navbar" id="divNav">
                    <ul>
                        <li><a href="#" GUBUN="ALL" class="ui-btn-active">전체(월별)</a></li>                        
                        <li><a href="#" GUBUN="MSUM">합계(월별)</a></li>
                        <li><a href="#" GUBUN="DSUM">합계(부서별)</a></li>
                    </ul>
                </div><!-- /navbar -->
                <div style="text-align:center;margin:auto">                    
                    <fieldset data-role="controlgroup" data-type="horizontal" id="idOptCtype" data-mini="true">                                  
                        <input type="radio" name="c" id="radio1" value="AMT" checked="checked">
                        <label for="radio1">금액</label>
                        <input type="radio" name="c" id="radio2" value="QTY">
                        <label for="radio2">수량</label>                                    
                    </fieldset>
                </div><!-- /navbar -->
                <div id="idChartArea" style="width:100%;height:340px;"></div>
            </div>
                 
        </div>
    </div>
</body>
</html>
