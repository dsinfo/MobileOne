<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-영업일보</title>
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
    <script type="text/javascript" src="JScript/CommonFunc.js"></script>
    <script type="text/javascript" src="JScript/jquery.number.min.js"></script>
    <script type="text/javascript">

        var ttype = 'D';
        var $tdate = null;
        var orgData = null;
        var dataSet = null;
        var $idContent = null;
        var $idContentNone = null;

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idDailySalePage', 'idMenu', true);

            //오늘일자 설정
            $tdate = $('#idTdate');
            document.getElementById("idTdate").value = formatDate(new Date());
            //$tdate.attr('value', formatDate(new Date()));            

            //검색 이벤트 연결
            $('#idSearch').on('click', function () {
                fn_getDailySaleReport();
            });

            //부서구분 클릭이벤트 연결
            $('#divNav').find('a').on('click', function () {
                if (orgData == null || orgData == '') return;
                var sagrp = $(this).attr('SAGRP');
                //dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == $(this).attr('SAGRP') && elem.TTYPE.trim() == $('#idOptDay').find('input[checked="checked"]').val() });
                dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == sagrp && elem.TTYPE.trim() == ttype });
                fn_setDailySaleReport();
            });

            //일자별 클릭이벤트 연결
            $('#idOptDay').find('input').on('click', function () {
                if (orgData == null || orgData == '') return;
                ttype = $(this).val();
                //dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == $('#divNav').find('a.ui-btn-active').attr('SAGRP') && elem.TTYPE.trim() == $(this).val() });
                dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == $('#divNav').find('a.ui-btn-active').attr('SAGRP') && elem.TTYPE.trim() == ttype });
                fn_setDailySaleReport();
            });

            $idContent = $('#idContent');
            $idContentNone = $('#idContentNone');   
           
        });

        //영업
        function fn_getDailySaleReport() {

            fn_loading('show');


            $.ajax({
                type: "POST",
                url: 'WebService/Salsum.asmx/GetDailySaleReport',
                data: JSON.stringify({ tdate: $tdate.val().replace(/-/ig, "") }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $idContent.empty();
                    if (data.d != "") {

                        orgData = JSON.parse(data.d);

                        if (orgData == "") {
                            $idContent.empty();
                            $idContentNone.show();
                            fn_loading('hide');
                            return;
                        }

                        var sagrp = $('#divNav').find('a.ui-btn-active').attr('SAGRP');
                        dataSet = orgData.filter(function (elem) { return elem.SAGRP.trim() == sagrp && elem.TTYPE.trim() == ttype });

                        fn_setDailySaleReport();

                    }
                },
                error: function (err) {
                    $idContent.empty();
                    alert(err.toLocaleString());
                    $idContent.hide();
                    $idContentNone.show();

                    fn_loading('hide');
                }
            }); 
        }

        //정보 설정
        function fn_setDailySaleReport() {  

            if (dataSet != "") {

                var gkey = "";
                var strHtml = '';

                $idContent.empty();
                dataSet.forEach(function (data) {

                    var div = null;
                    var h1 = null;
                    var ul = null;
                    var $li = null;
                    var $li2 = null;


                    if (gkey == "" || gkey != data.CTYPE.trim()) {
                        div = document.createElement('div');
                        h3 = document.createElement('h3');
                        ul = document.createElement('ul');

                        //속성 & 스타일 부여
                        $(div).attr('data-role', 'collapsible').attr('data-collapsed', 'true').attr('data-inset', 'false').attr('data-iconpos', 'right');
                        $(h3).text(data.CTYPE.trim());
                        $(ul).attr('data-role', 'listview').attr('data-theme', 'a').attr('data-divider-theme', 'b').attr('id', 'idUl' + data.CTYPE);

                        if (data.CTYPE.trim() == '소계') {
                            $(div).attr('data-collapsed', 'false');
                            $idContent.prepend(div);
                        } else {
                            $idContent.append(div);
                        }

                        //컨텐츠에 넣기
                        $(div).append(h3).append(ul);

                    }

                    $li = $('<li data-role="list-divider">' + data.PDMTD.trim() + '</li>');
                    $li2 = $('<li></li>');
                    strHtml = ''
                    strHtml = strHtml + '<table class="ui-tbl-list"><tr><td class="ui-td-caption">수주(승인)</td><td class="ui-tbl-content">' + $.number(data.ORDAM) + '</td>';
                    strHtml = strHtml + '<td class="ui-td-caption">Rev.금액</td><td class="ui-tbl-content">' + $.number(data.CHGAM) + '</td></tr>';
                    strHtml = strHtml + '<tr><td class="ui-td-caption">출고(승인)</td><td class="ui-tbl-content">' + $.number(data.ISSAM) + '</td>';
                    strHtml = strHtml + '<td class="ui-td-caption">매출(승인)</td><td class="ui-tbl-content">' + $.number(data.SALAM) + '</td></tr>';
                    strHtml = strHtml + '<tr><td class="ui-td-caption">수금</td><td class="ui-tbl-content">' + $.number(data.RCPAM) + '</td>';
                    strHtml = strHtml + '<td class="ui-td-caption"></td><td class="ui-tbl-content"></td></tr></table>'
                    $li2.html(strHtml);

                    $('#idUl' + data.CTYPE).append($li).append($li2);

                    gkey = data.CTYPE.trim();

                });

                $('div[data-role="collapsible"]').collapsible({ refresh: true });
                $('ul[data-role="listview"]').listview({ refresh: true });
                $idContentNone.hide();
                $idContent.show();
            } else {
                $idContentNone.show();
                $idContent.hide();
            }

            fn_loading('hide');
        }

    </script>
</head>
<body>
    <!--페이지 정보-->   
    <div data-role="page" id="idDailySalePage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>영업일보</h1>           
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>            
	    </div>


        <!--본문-->
	    <div data-role="content">           
            <ul data-role="listview" data-inset="true" style="margin:0px;padding:0px">
                <li style="text-align:center; ">                                 
                    <fieldset data-role="controlgroup" data-type="horizontal" data-mini="true" id="idOptDay">                
                        <input type="radio" name="nameDay" id="radio-choice-1" value="D" checked="checked">
                        <label for="radio-choice-1">당 일</label>
                        <input type="radio" name="nameDay" id="radio-choice-2" value="M">
                        <label for="radio-choice-2">월 계</label>
                        <input type="radio" name="nameDay" id="radio-choice-3" value="Y">
                        <label for="radio-choice-3">누 계</label>                        
                    </fieldset> 
                     <table style="text-align:center;margin:auto">
                        <tr>
                            <td style="width:10%">
                                일 자 :
                            </td>                          
                            <td style="width:80%">
                                <input type="date"  id="idTdate" />
                            </td>
                            <td style="width:10%">
                                <a href="#"  id='idSearch' class="ui-btn ui-icon-search ui-btn-icon-notext ui-corner-all">No text</a>     
                            </td>
                        </tr>
                    </table>             
                </li>                
            </ul>           

            <div data-role="navbar" id="divNav" style="margin:10px 0px 0px 0px;">
                <ul>
                    <li><a href="#" class="ui-btn-active" SAGRP="99">합계</a></li>
                    <li><a href="#" SAGRP="40">본사</a></li>
                    <li><a href="#" SAGRP="50">해외</a></li>
                    <li><a href="#" SAGRP="60">서울</a></li>
                    <li><a href="#" SAGRP="70">수리</a></li>
                </ul>
            </div><!-- /navbar -->

            <!--검색내역-미존재-->
            <ul id="idContentNone" data-role="listview" data-inset="true" style="margin: 10px 0px 0px 0px;display:none">
                <li>
                    <div><string>내역이 존재하지 않습니다!</string></div> 
                </li>                    
            </ul>

            <div id="idContent">
                <%--<div data-role="collapsible" data-inset="false" data-collapsed="false">
                    <h3>내수</h3>
                    <ul data-role="listview" data-theme="a" data-divider-theme="b">
                        <li data-role="list-divider">사내생산</li>
                        <li>
                            <table class="ui-tbl-list">                          
                                <tr>                            
                                    <td class="ui-tbl-caption" >수주(승인)</td>
                                    <td class="ui-tbl-content">11,000,000</td>
                                    <td class="ui-tbl-caption">Rev.금액</td>
                                    <td class="ui-tbl-content">21,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">출고(승인)</td>
                                    <td class="ui-tbl-content">1,000,000</td>
                                    <td class="ui-tbl-caption">매출(승인)</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">수금</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                    <td class="ui-tbl-caption"></td>
                                    <td class="ui-tbl-content"></td>
                                </tr>
                            </table>
                        </li>
                        <li data-role="list-divider">OEM</li>
                        <li>
                            <table class="ui-tbl-list">                          
                                <tr>                            
                                    <td class="ui-tbl-caption" >수주(승인)</td>
                                    <td class="ui-tbl-content">11,000,000</td>
                                    <td class="ui-tbl-caption">Rev.금액</td>
                                    <td class="ui-tbl-content">21,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">출고(승인)</td>
                                    <td class="ui-tbl-content">1,000,000</td>
                                    <td class="ui-tbl-caption">매출(승인)</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">수금</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                    <td class="ui-tbl-caption"></td>
                                    <td class="ui-tbl-content"></td>
                                </tr>
                            </table>
                        </li>
                    </ul>
                </div>
                <div data-role="collapsible" data-inset="false" data-collapsed="false">
                    <h3>수출</h3>
                    <ul data-role="listview" data-theme="a" data-divider-theme="b">
                        <li data-role="list-divider">사내생산</li>
                        <li>
                            <table class="ui-tbl-list">                          
                                <tr>                            
                                    <td class="ui-tbl-caption" >수주(승인)</td>
                                    <td class="ui-tbl-content">11,000,000</td>
                                    <td class="ui-tbl-caption">Rev.금액</td>
                                    <td class="ui-tbl-content">21,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">출고(승인)</td>
                                    <td class="ui-tbl-content">1,000,000</td>
                                    <td class="ui-tbl-caption">매출(승인)</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">수금</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                    <td class="ui-tbl-caption"></td>
                                    <td class="ui-tbl-content"></td>
                                </tr>
                            </table>
                        </li>
                        <li data-role="list-divider">OEM</li>
                        <li>
                            <table class="ui-tbl-list">                          
                                <tr>                            
                                    <td class="ui-tbl-caption" >수주(승인)</td>
                                    <td class="ui-tbl-content">11,000,000</td>
                                    <td class="ui-tbl-caption">Rev.금액</td>
                                    <td class="ui-tbl-content">21,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">출고(승인)</td>
                                    <td class="ui-tbl-content">1,000,000</td>
                                    <td class="ui-tbl-caption">매출(승인)</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                </tr>
                                <tr>
                                    <td class="ui-tbl-caption">수금</td>
                                    <td class="ui-tbl-content">2,000,000</td>
                                    <td class="ui-tbl-caption"></td>
                                    <td class="ui-tbl-content"></td>
                                </tr>
                            </table>
                        </li>
                    </ul>
                </div>--%>
            </div><!--CONTENT 끝-->   
                 
        </div>
    </div>
</body>
</html>
