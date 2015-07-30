<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-PK Valve</title>
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
    
    </style>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script type= "text/javascript" src="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script>     
    <script type="text/javascript" src="JScript/CommonFunc.js"></script>

    <script type="text/javascript">

        var orgData = null;
        var dataSet = null;
        var $fdate = null;
        var $tdate = null;

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idUserHistoryPage', 'idMenu', true);


            //날짜선택 이벤트 연결
            $('#idOptDay').find('input').on('click', function () {
                var cday = Number($(this).attr('value'));

                document.getElementById("idFdate").value = convertDate(new Date(), cday);
                document.getElementById("idTdate").value = formatDate(new Date());

//                $fdate.val(convertDate(new Date(), cday));
//                $tdate.val(formatDate(new Date()));

                fn_getLogHistory();
            });

            //검색 이벤트 연결
            $('#idSearch').on('click', function () {
                fn_getLogHistory();
            });


            $fdate = $('#idFdate');
            $tdate = $('#idTdate');

            document.getElementById("idFdate").value = formatDate(new Date());
            document.getElementById("idTdate").value = formatDate(new Date());

            //            $fdate.attr('value', formatDate(new Date()));
            //            $tdate.attr('value', formatDate(new Date()));

            fn_getLogHistory();

        });

        //사용이력 데이터 가져오기
        function fn_getLogHistory() {

            fn_loading('show');

            orgData = fn_GetData('Usrmas.asmx/GetLoghistory', { fdate: $fdate.val().replace(/-/ig, ""), tdate: $tdate.val().replace(/-/ig, "") });

            if (orgData == "") {
                $('#idContent').empty();
                fn_loading('hide');
                return;
            }

            dataSet = orgData.filter(function (elem) { return elem.QTYPE == 'S' });

            fn_setLogHistory();
        }

        //사용이력 UI 만들기
        function fn_setLogHistory() {

            fn_loading('show');

            var $idContent = $('#idContent');
            var prevDate = '';

            if (dataSet != "") {

                var filterText = '';
                var liHtml = '';
                var $div = null;
                var $h3 = null;
                var $ul = null;
                var $li = null;
                var nCnt = 0;

                $idContent.empty();
                dataSet.forEach(function (data, index) {

                    if (prevDate == '' || prevDate != data.CDATE.trim()) {

                        if ($div != null) {
                            $div.attr('data-filtertext', filterText);
                            $h3.append('<span class="ui-li-count">' + String(nCnt) + '</span>');
                            nCnt = 0;
                        }

                        filterText = '';
                        $div = $('<div data-role="collapsible"></div>');
                        $h3 = $('<h3>' + convertDateString(data.CDATE) + '</h3>');
                        //                        $h3.html(data.DPTNM.trim() + '<span class="ui-li-count">' + data.WPCNT + '</span>');
                        $div.append($h3);
                        $idContent.append($div);
                        filterText = data.USRNM.trim();

                        $ul = $('<ul data-role="listview" data-inset="false"></ul>');
                        $div.append($ul);
                    }

                    liHtml = '';
                    liHtml = '<h2>' + data.USRNM.trim() + '</h2><p>' + data.CONDT + '</p><p class="ui-li-aside"><a href="#" style="text-decoration:none;color:black"><strong>' + data.CNCNT + '</strong></a></p>';
                    $li = $('<li data-filtertext="' + data.USRNM.trim() + '"></li>');
                    $li.html(liHtml);
                    $ul.append($li);
                    filterText = filterText == '' ? data.USRNM.trim() : filterText + ' ' + data.USRNM.trim();
                    prevDate = data.CDATE.trim();
                    nCnt = nCnt + 1;

                    if (dataSet.length - 1 == index) {
                        $h3.append('<span class="ui-li-count">' + String(nCnt) + '</span>');
                    }
                });

                $idContent.collapsibleset({ refresh: true });
                $idContent.find('ul').listview({ refresh: true });

                $idContent.show();
            } else {

                $idContent.hide();
            }

            fn_loading('hide');
        } 

    </script>
</head>
<body>   
    <div data-role="page" id="idUserHistoryPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>사용자 이력조회</h1>           
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>           
	    </div>

        <!--본문-->
	    <div data-role="content" style="padding:0px 5px 0px 5px">
            <ul data-role="listview" data-inset="true">
                <li style="text-align:center;margin:0px;padding:0px">
                   <%-- <table>
                        <tr>
                            <td>--%>
                                 <fieldset data-role="controlgroup" data-type="horizontal" data-mini="true" id="idOptDay">                
                                    <input type="radio" name="radio-choice-b" id="radio-choice-1" value="-1">
                                    <label for="radio-choice-1">전일</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-2" value="0" checked="checked">
                                    <label for="radio-choice-2">당일</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-3" value="-3">
                                    <label for="radio-choice-3">3일</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-4" value="-7">
                                    <label for="radio-choice-4">1주일</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-5" value="-30">
                                    <label for="radio-choice-5">30일전</label>
                                    <input type="radio" name="radio-choice-b" id="radio-choice-6" value="-90">
                                    <label for="radio-choice-6">90일전</label>                    
                                </fieldset>              
                         <%--   </td>
                            <td>
                               <select name="slider2" id="slider2" data-role="slider">
                                    <option value="off">보기</option>
                                    <option value="on">감추기</option>
                                </select>
                            </td>
                        </tr>
                    </table>         --%>            
                    <table>
                        <tr>
                            <td style="width:10%">
                                조회기간:
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
                    </table>
                </li>
            </ul>         
             <div class="ui-input-search ui-body-inherit ui-corner-all ui-shadow-inset ui-input-has-clear">
                <input data-type="search" data-enhanced="true" data-inset="false" id="searchForCollapsibleSetChildren" data-filter-placeholder="이름 검색..." >
            </div>
            <div id='idContent' data-role="collapsibleset" data-filter="true"  data-children="> div, > div div ul li" data-inset="true" data-input="#searchForCollapsibleSetChildren">
              
            </div>
	    </div>    
    </div>
</body>e
</html>
