<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-영업일보-부하(출고)현황</title>
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
        var $idContentMain = null;
        var $idContent = null;
        var $idContentChart = null;
        var $idContentNone = null;
        var arrTotal = new Array(8);
        var arrCaption = new Array(8);
        var arrDept = ['본사', '해외', '서울', '수리'];
        var arrColor = ['#0000FF', '#FF0000', '#FF8000', '#04B404', '#FFFF00'];
        var arrMtype = ['사내생산', 'OEM(일부)', 'OEM(전체)', '구매(생산)', '구매(영업)'];
        var gubun = "ALL";
        var ctype = "DEPT";
        var stype = "l";

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
            pageMakeMenu('idDeliveryLoadPage', 'idMenu', true);

            //오늘일자 설정
            $tdate = $('#idTdate');
            document.getElementById("idTdate").value = formatDate(new Date());
            //$tdate.attr('value', formatDate(new Date()));
            $idContentMain = $('#idContentMain');
            $idContent = $('#idContent');
            $idContentChart = $('#idContentChart');
            $idContentNone = $('#idContentNone');

            //검색 이벤트 연결
            $('#idSearch').on('click', function () {
                fn_getDeliveryLoad();
            });

            //부서구분 클릭이벤트 연결
            $('#divNav').find('a').on('click', function () {
                if (orgData == null || orgData == '') return;
                var sagrp = $(this).attr('SAGRP');
                dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == sagrp });
                fn_setDeliveryLoad();
            });

            //리스트/챠트 보기
            $('#idOptQuery').find('input').on('click', function () {
                stype = $(this).val();
                if (orgData == null) {
                    fn_getDeliveryLoad();
                    return;
                }
                if (stype == "l") {
                    var sagrp = $('#divNav').find('a.ui-btn-active').attr('SAGRP');
                    dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == sagrp });
                    fn_setDeliveryLoad();
                }
                else {
                    fn_setDeliveryLoadChart();
                }
            });

            //챠트구분 클릭이벤트 연결
            $('#IdNavGubun').find('a').on('click', function () {
                if (orgData == null || orgData == '') return;
                gubun = $(this).attr('GUBUN');
                fn_setDeliveryLoadChart();
            });

            //챠트타입 
            $('#idOptCtype').find('input').on('click', function () {
                if (orgData == null || orgData == '') return;
                ctype = $(this).attr('value');
                fn_setDeliveryLoadChart();
            });

        });

        //영업
        function fn_getDeliveryLoad() {

            fn_loading('show');

            $.ajax({
                type: "POST",
                url: 'WebService/Salsum.asmx/GetDeliveryLoad',
                data: JSON.stringify({ tdate: $tdate.val().replace(/-/ig, "") }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    makeCaption();
                    $idContent.empty();
                    if (data.d != "") {

                        orgData = JSON.parse(data.d);

                        if (stype == "l") {
                            var sagrp = $('#divNav').find('a.ui-btn-active').attr('SAGRP');
                            dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == sagrp });
                            fn_setDeliveryLoad();
                        }
                        else {
                            fn_setDeliveryLoadChart();
                        }
                       
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
        function fn_setDeliveryLoad() {

            $idContent.empty();

            if (dataSet == null || dataSet == '') {
                fn_showContent(false);            
                return;
            }
                
            var strHtml = '';
            var sAMT = 0;

            arrTotal = [0,0,0,0,0,0,0,0];
             
            dataSet.forEach(function (data, index) {

                makeDeliveryLoad(data);

                if (dataSet.length - 1 == index) {
                    makeDeliveryLoad(data, true);
                }

            });

            $('div[data-role="collapsible"]').collapsible({ refresh: true });
            $('ul[data-role="listview"]').listview({ refresh: true });

            fn_showContent(true);

            fn_loading('hide');
        }

        //부하내역 만들기
        function makeDeliveryLoad(data,  isTotal) {

            var div = null;
            var h1 = null;
            var ul = null;
            var $li = null;

            div = document.createElement('div');
            h3 = document.createElement('h3');
            ul = document.createElement('ul');

            //속성 & 스타일 부여
            $(div).attr('data-role', 'collapsible').attr('data-collapsed', 'true').attr('data-inset', 'false').attr('data-iconpos', 'right');
            $(h3).text( isTotal == true ? "소계" : data.PDMDS.trim());
            $(ul).attr('data-role', 'listview').attr('data-theme', 'a').attr('data-divider-theme', 'b').attr('id', 'idUl' + (isTotal == true ? "소계" : data.PDMDS));

            if (isTotal) $(div).attr('data-collapsed', 'false');

            //컨텐츠에 넣기                        
            $(div).append(h3).append(ul);

            if (isTotal) $idContent.prepend(div);
            else $idContent.append(div);

            sAMT = 0;
            sAMT = Number(data['01AMT']) + Number(data['02AMT']) + Number(data['03AMT']) + Number(data['04AMT']) + Number(data['05AMT']) + Number(data['06AMT']) + Number(data['07AMT']);

            if (isTotal != true) {
                arrTotal[0] = arrTotal[0] + Number(data['01AMT']);
                arrTotal[1] = arrTotal[1] + Number(data['02AMT']);
                arrTotal[2] = arrTotal[2] + Number(data['03AMT']);
                arrTotal[3] = arrTotal[3] + Number(data['04AMT']);
                arrTotal[4] = arrTotal[4] + Number(data['05AMT']);
                arrTotal[5] = arrTotal[5] + Number(data['06AMT']);
                arrTotal[6] = arrTotal[6] + Number(data['07AMT']);
                arrTotal[7] = arrTotal[7] + Number(sAMT);
            }


            $li = $('<li></li>');
            strHtml = ''
            strHtml = strHtml + '<table class="ui-tbl-list"><tr><td class="ui-tbl-caption">' + arrCaption[0] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[0]) : $.number(data['01AMT'])) + '</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[1] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[1]) : $.number(data['02AMT'])) + '</td></tr>';
            strHtml = strHtml + '<tr><td class="ui-tbl-caption">' + arrCaption[2] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[2]) : $.number(data['03AMT'])) + '</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[3] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[3]) : $.number(data['04AMT'])) + '</td></tr>';
            strHtml = strHtml + '<tr><td class="ui-tbl-caption">' + arrCaption[4] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[4]) : $.number(data['05AMT'])) + '</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[5] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[5]) : $.number(data['06AMT'])) + '</td></tr>'
            strHtml = strHtml + '<tr><td class="ui-tbl-caption">' + arrCaption[6] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[6]) : $.number(data['07AMT'])) + '</td>';
            strHtml = strHtml + '<td class="ui-tbl-caption">' + arrCaption[7] + '</td><td class="ui-tbl-content">' + (isTotal == true ? $.number(arrTotal[7]) : $.number(sAMT)) + '</td></tr></table>'
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
                    $idContentMain.show();                    
                    $idContentChart.hide();
                }
                else {
                    $idContentMain.hide();
                    $idContentChart.show();
                }
                $idContentNone.hide();
            } else {
                $idContentMain.hide();
                $idContentChart.hide();
                $idContentNone.show();
            }
        }

        //챠트 그리기
        function fn_setDeliveryLoadChart() {
            var numValue = 0;
            var dataTable = new google.visualization.DataTable();
            var dataValue = [0, 0, 0, 0, 0];
            var chart = null;
            var options = null;

            //월별 전체 또는 합계
            if (gubun == "ALL" || gubun == "MSUM") {

                dataTable.addColumn({ type: 'string', id: '월' });
                if (gubun == "ALL") {

                    if (ctype == "DEPT") {
                        //테이블 생성
                        for (var i = 0; i < arrDept.length; i++) {
                            dataTable.addColumn({ type: 'number', id: arrDept[i], label: arrDept[i] });
                        }

                        //데이터 생성
                        for (var i = 0; i < arrCaption.length - 1; i++) {
                            dataValue = [0, 0, 0, 0, 0];
                            orgData.forEach(function (data, index) {
                                switch (data.DPTNM.trim()) {
                                    case "본사":
                                        dataValue[0] = dataValue[0] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "해외":
                                        dataValue[1] = dataValue[1] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "서울":
                                        dataValue[2] = dataValue[2] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "수리":
                                        dataValue[3] = dataValue[3] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                }
                            });

                            dataTable.addRow([arrCaption[i], { v: dataValue[0], f: $.number(dataValue[0]) }, { v: dataValue[1], f: $.number(dataValue[1]) },
                                                { v: dataValue[2], f: $.number(dataValue[2]) }, { v: dataValue[3], f: $.number(dataValue[3])}]);
                        }

                    } else {
                        //테이블 생성
                        for (var i = 0; i < arrMtype.length; i++) {
                            dataTable.addColumn({ type: 'number', id: arrMtype[i], label: arrMtype[i] });
                        }
                        //데이터 생성
                        for (var i = 0; i < arrCaption.length - 1; i++) {
                            dataValue = [0, 0, 0, 0, 0];
                            orgData.forEach(function (data, index) {
                                switch (data.PDMDS.trim()) {
                                    case "사내생산":
                                        dataValue[0] = dataValue[0] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "OEM(일부)":
                                        dataValue[1] = dataValue[1] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "OEM(전체)":
                                        dataValue[2] = dataValue[2] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "구매(생산)":
                                        dataValue[3] = dataValue[3] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                    case "구매(영업)":
                                        dataValue[4] = dataValue[4] + data['0' + (i + 1) + 'AMT'];
                                        break;
                                }
                            });

                            dataTable.addRow([arrCaption[i], { v: dataValue[0], f: $.number(dataValue[0]) }, { v: dataValue[1], f: $.number(dataValue[1]) },
                                                { v: dataValue[2], f: $.number(dataValue[2]) }, { v: dataValue[3], f: $.number(dataValue[3]) }, { v: dataValue[4], f: $.number(dataValue[4])}]);
                        }
                    } //월별 전체 끝 (if)

                } else {

                    dataTable.addColumn({ type: 'number', id: '합계', label: '합계' });

                    //데이터 생성
                    dataSet = orgData.filter(function (elem) { return elem.DPTNM.trim() == '합계' });
                    dataValue = [0, 0, 0, 0, 0];

                    //데이터 생성
                    for (var i = 0; i < arrCaption.length - 1; i++) {
                        numValue = 0;
                        dataSet.forEach(function (data, index) {
                            numValue = numValue + data['0' + (i + 1) + 'AMT'];
                        });
                        dataTable.addRow([arrCaption[i], { v: numValue, f: $.number(numValue)}]);
                    }
                } ////월별 전체 또는 합계 끝(if)
                chart = new google.visualization.LineChart(document.getElementById('idChartArea'));
                options = {
                    //                title: "생산(수압)부하현황",
                    //                titleTextStyle: { color: 'blue', fontSize: '12', bold: true }    
                    //                legend: { position: 'top' }
                    tooltip: { trigger: 'selection' },
                    pointSize: 4
                };
            } else {

                if (ctype == "DEPT") {

                    dataTable.addColumn({ type: 'string', id: '부서' });
                    dataTable.addColumn({ type: 'number', id: '금액', label: '합계' })
                    dataTable.addColumn({ type: 'string', role: 'style' })

                    for (var i = 0; i < arrDept.length; i++) {
                        numValue = 0;
                        orgData.forEach(function (data, index) {
                            if (data.DPTNM.trim() == arrDept[i]) {
                                numValue = numValue + data['01AMT'] + data['02AMT'] + data['03AMT'] + data['04AMT'] + data['05AMT'] + data['06AMT'] + data['07AMT'];
                            }
                        });
                        dataTable.addRow([arrDept[i], { v: numValue, f: $.number(numValue) }, arrColor[i]]);
                    }
                } else {
                    dataTable.addColumn({ type: 'string', id: '생산' });
                    dataTable.addColumn({ type: 'number', id: '금액', label: '합계' })
                    dataTable.addColumn({ type: 'string', role: 'style' })

                    for (var i = 0; i < arrMtype.length; i++) {
                        numValue = 0;
                        orgData.forEach(function (data, index) {
                            if (data.PDMDS.trim() == arrMtype[i]) {
                                numValue = numValue + data['01AMT'] + data['02AMT'] + data['03AMT'] + data['04AMT'] + data['05AMT'] + data['06AMT'] + data['07AMT'];
                            }
                        });
                        dataTable.addRow([arrMtype[i], { v: numValue, f: $.number(numValue) }, arrColor[i]]);
                    }
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

            fn_showContent(true);
            chart.draw(dataTable, options);
        }

        $(window).resize(function () {
            if (stype == "c" && dataSet != '') fn_setDeliveryLoadChart();
        });

    </script>
</head>
<body>
    <!--페이지 정보-->   
    <div data-role="page" id="idDeliveryLoadPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>영업일보-부하(출고)현황</h1>           
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

            <div id="idContentMain">
                <div data-role="navbar" id="divNav" style="margin:10px 0px 0px 0px;">
                    <ul>
                        <li><a href="#" class="ui-btn-active" SAGRP="99">합계</a></li>
                        <li><a href="#" SAGRP="40">본사</a></li>
                        <li><a href="#" SAGRP="50">해외</a></li>
                        <li><a href="#" SAGRP="60">서울</a></li>
                        <li><a href="#" SAGRP="70">수리</a></li>
                    </ul>
                </div><!-- /navbar -->
                <div id="idContent">          
                </div><!--CONTENT 끝-->   
            </div>


            <!--검색내역-미존재-->
            <ul id="idContentNone" data-role="listview" data-inset="true" style="margin: 10px 0px 0px 0px;display:none">
                <li>
                    <div><string>내역이 존재하지 않습니다!</string></div> 
                </li>                    
            </ul>
            
             <div id="idContentChart"  style="padding:10px 0px 0px 0px;display:none">
                <div data-role="navbar" id="IdNavGubun">
                    <ul>
                        <li><a href="#" GUBUN="ALL" class="ui-btn-active">전체</a></li>                        
                        <li><a href="#" GUBUN="MSUM">합계(월별)</a></li>
                        <li><a href="#" GUBUN="DSUM">합계(항목별)</a></li>
                    </ul>
                </div><!-- /navbar -->
                <div style="text-align:center;margin:auto">                    
                    <fieldset data-role="controlgroup" data-type="horizontal" id="idOptCtype" data-mini="true">                                  
                        <input type="radio" name="c" id="radio1" value="DEPT" checked="checked">
                        <label for="radio1">부서</label>
                        <input type="radio" name="c" id="radio2" value="MTYPE">
                        <label for="radio2">생산</label>                                    
                    </fieldset>
                </div><!-- /navbar -->
                <div id="idChartArea" style="width:100%;height:340px;"></div>
            </div>
                 
        </div>
    </div>
</body>
</html>
