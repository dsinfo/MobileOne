<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-영업일보-일일현황</title>
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
            width: 100%;                           
            text-align : right;
            
    }
        
    .ui-tbl-content 
    {
            width: 50%;                           
            padding-right : 10px;
            text-align : left;
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
      
        
        var $tdate = null;
        var orgData = null;
        var dataSet = null;
        var $idContent = null;
        var $idContentNone = null;
        var jsonList = null;
        var gubun = "D";

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idDailyOrderPage', 'idMenu', true);

            //오늘일자 설정
            $tdate = $('#idTdate');
            document.getElementById("idTdate").value = formatDate(new Date());
            //            $tdate.attr('value', formatDate(new Date()));

            //검색 이벤트 연결
            $('#idSearch').on('click', function () {
                fn_getDailyOrderReport();
            });

            //부서구분 클릭이벤트 연결
            $('#divNav').find('a').on('click', function () {
                gubun = $(this).attr('gubun');

                chagneView();

            });

            jsonList = {
                STYPE: [
                              { key: "D1", value: "수주내역", gubun: "D" },
                              { key: "D2", value: "출고내역", gubun: "D" },
                              { key: "D3", value: "매출내역", gubun: "D" },
                              { key: "D4", value: "수금내역", gubun: "D" },
                              { key: "N1", value: "수주(미승인)내역", gubun: "N" },
                              { key: "N2", value: "출고(미확정)내역", gubun: "N" },
                              { key: "N3", value: "매출(미확정)내역", gubun: "N" }
                           ]
            };
        });

        //영업
        function fn_getDailyOrderReport() {

            fn_loading('show');

            var $idContent = $('#idContentList');
            var $idContentNone = $('#idContentNone');

            fn_loading('show');

            $.ajax({
                type: "POST",
                url: 'WebService/Salsum.asmx/GetDailyOrderReport',
                data: JSON.stringify({ tdate: $tdate.val().replace(/-/ig, "") }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $idContent.empty();
                    if (data.d != "") {

                        result = JSON.parse(data.d);

                        var gkey = "";
                        var strHtml = '';

                        for (var i = 0; i < jsonList.STYPE.length; i++) {

                            var div = null;
                            var h1 = null;
                            var ul = null;
                            var $li = null;

                            div = document.createElement('div');
                            h3 = document.createElement('h3');
                            ul = document.createElement('ul');

                            //속성 & 스타일 부여
                            $(div).attr('data-role', 'collapsible').attr('data-collapsed', 'true').attr('data-inset', 'false').attr('gubun', jsonList.STYPE[i].gubun);
                            $(ul).attr('data-role', 'listview');
                            //                            $(h3).html(jsonList.STYPE[i].value);

                            //컨텐츠에 넣기
                            $idContent.append(div);
                            $(div).append(h3).append(ul);

                            dataSet = result.filter(function (elem) { return elem.STYPE.trim() == jsonList.STYPE[i].key; });

                            if (dataSet != "") {
                                dataSet.forEach(function (data, index) {
                                    strHtml = '';
                                    strHtml = strHtml + '<table class="ui-tbl-list"><tr><td class="ui-td-caption" colspan="2"><span style="font-weight:bold;font-size:1.2em;">' + data.CUSDS.trim() + '</span></td></tr>';
                                    strHtml = strHtml + '<tr><td class="ui-tbl-content">' + data.ORDNO.trim() + '</td><td class="ui-tbl-content" style="text-align:right">' + $.number(data.ORDAM) + '</td></tr></table>';
                                    $li = $('<li></li>').html(strHtml);
                                    $(ul).append($li);
                                });
                            } else {
                                $(ul).html('<li>내역이 없습니다!</li>');
                            }

                            $(h3).html(jsonList.STYPE[i].value + '<span class="ui-li-count">' + dataSet.length + '</span>');
                        }

                        chagneView();

                        $('ul[data-role="listview"]').listview({ refresh: true });
                        $('div[data-role="collapsible"]').collapsible({ refresh: true });

                        $idContent.show();
                        $idContentNone.hide();
                    } else {
                        $idContent.hide();
                        $idContentNone.show();
                    }

                    fn_loading('hide');
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

        function chagneView() {

            if (gubun == 'D') {
                $('div[data-role="collapsible"][gubun="D"]').show();
                $('div[data-role="collapsible"][gubun="N"]').hide();
            } else {
                $('div[data-role="collapsible"][gubun="D"]').hide();
                $('div[data-role="collapsible"][gubun="N"]').show();
            }

        }  

    </script>
</head>
<body>
    <!--페이지 정보-->   
    <div data-role="page" id="idDailyOrderPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>영업일보-일일현황</h1>           
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
                    </table>             
                </li>                
            </ul>           

            <div data-role="navbar" id="divNav" style="margin:10px 0px 0px 0px;">
                <ul>
                    <li><a href="#" class="ui-btn-active" gubun="D">일일현황</a></li>
                    <li><a href="#" gubun="N">미처리내역</a></li>
                </ul>
            </div><!-- /navbar -->

            <!--검색내역-미존재-->
            <ul id="idContentNone" data-role="listview" data-inset="true" style="margin: 10px 0px 0px 0px;display:none">
                <li>
                    <div><string>내역이 존재하지 않습니다!</string></div> 
                </li>                    
            </ul>

            <div id="idContentList">                        
            </div><!--CONTENT 끝-->   
                 
        </div>
    </div>
</body>
</html>
