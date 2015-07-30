<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PKMobileWeb-작업지시(할당)</title>
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
       
       #custom-collapsible h3 .ui-collapsible-heading-toggle {
           font-size : 13px;          
        }
        
        #custom-collapsible-red h3 .ui-collapsible-heading-toggle {
           font-size : 13px;  
           color : Red;        
        }
        
        #custom-collapsible-blue h3 .ui-collapsible-heading-toggle {
           font-size : 13px;  
           color : Blue;        
        }
        
        .ui-panel-inner
        {
            padding-top : 0px;                      
        }
        
        .ui-tbl-list
        {
            font-size:0.7em;width:100%;
        }
        
        .ui-tbl-list td .ui-td-caption
        {
            width:20px;
        }
        
        .ui-tbl-list td .ui-td-data
        {
            margin-left:4px;
            
        }

         
    </style>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script type= "text/javascript" src="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script>     
    <script type="text/javascript" src="JScript/CommonFunc.js"></script>
    <script type="text/javascript">
       
        //지시번호 필터링 설정
        $(document).on("pagecreate", "#idOrderAllocatePage", function () { setOrderSearch('fn_getOrderAllocateItem();'); });

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

            var dataSet = fn_GetData('Momast.asmx/GetOrderAllocateItem', { ordno: sInput.val() });
            var $idContent = $('#idContentNone');
            var $idContentNone = $('#idContentNone');

            if (dataSet != "") {
               
                var strHtml = '';
                var strUniss = '';

                $idContent.empty();
                dataSet.forEach(function (data) {

                    var div = document.createElement('div');
                    var h1 = document.createElement('h3');
                    var s1 = document.createElement('span');
                    var s2 = document.createElement('span');
                    var ul = document.createElement('ul');
                    var li = document.createElement('li');


                    //속성 & 스타일 부여
                    $(div).attr('data-role', 'collapsible').attr('data-collapsed', 'true').attr('data-inset', 'false').attr('data-iconpos', 'right');
                    $(h1).css('padding-left', '0px').text(data.CITEM.trim());
                    if (Number(data.UNISS) > 0) {
                        if (Number(data.ISQTY) > 0) {
                            $(div).attr('id', 'custom-collapsible-blue');
                        }else{
                            $(div).attr('id', 'custom-collapsible-red');
                        }                        
                    } else {
                        $(div).attr('id', 'custom-collapsible');
                    }
                    $(s1).addClass('ui-li-count').css('margin-right', '70px').css('font-size', '0.8em').text(data.REQTY + ' ( ' + data.ISQTY + ' )');
                    $(s2).addClass('ui-li-count').css('margin-right', '4px').css('font-size', '0.8em').text(data.REQDT);
                    $(ul).attr('data-role', 'listview').attr('data-inset', 'false').attr('id', 'id' + data.ORDSQ).css('list-style', 'none');

                    strUniss = data.UNISS + ' ( ' + data.MOHTQ + ' )';                    

                    strHtml = '<table class="ui-tbl-list"><tr><td class="ui-td-caption" style="text-align:right;">품목명 : </td><td colspan="3" style="width:100%" class="ui-td-data">' + data.ITDSC.trim() + '</td></tr>';
                    strHtml = strHtml + '<tr><td class="ui-td-caption" style="text-align:right;">규  격 : </td><td colspan="3" class="ui-td-data">' + data.ITSTD.trim() + '</td></tr>';
                    strHtml = strHtml + '<tr><td class="ui-td-caption" style="text-align:right;">재  질 : </td><td colspan="3" class="ui-td-data">' + data.ITMAT.trim() + '</td></tr>';
                    strHtml = strHtml + '<tr><td class="ui-td-caption" style="text-align:right;">구성수 : </td><td style="width:40%" class="ui-td-data">' + data.QTYPR + '</td><td class="ui-td-caption" style="text-align:right;">미불출량 : </td><td style="width:40%" class="ui-td-data">' + strUniss + '</td></tr>';
                    strHtml = strHtml + '<tr><td class="ui-td-caption" style="text-align:right;">불  량 : </td><td style="width:40%" class="ui-td-data">' + data.NGQTY + '</td><td class="ui-td-caption" style="text-align:right;">사용량 : </td><td style="width:40%" class="ui-td-data">' + data.USQTY + '</td></tr></table>';
                   
//                    strHtml = '<div class="ui-grid-b ui-responsive"><div class="ui-block-a" style="font-size:0.8em">품목명: ' + data.ITDSC.trim() + '</div>';
//                    strHtml = strHtml + '<div class="ui-block-a" style="font-size:0.8em">규  격</span>: ' + data.ITSTD.trim() + '</div>';
//                    strHtml = strHtml + '<div class="ui-block-a" style="font-size:0.8em">재  질: ' + data.ITMAT.trim() + '</div>';
//                    strHtml = strHtml + '<div class="ui-block-a" style="font-size:0.8em">구성수: ' + data.QTYPR + '</div><div class="ui-block-b" style="font-size:0.8em">미불출량: ' + data.UNISS + '</div>';
//                    strHtml = strHtml + '<div class="ui-block-a" style="font-size:0.8em">불  량: ' + data.NGQTY + '</div><div class="ui-block-b" style="font-size:0.8em">사용량: ' + data.USQTY + '</div></div>';

                    $(li).html(strHtml);                    
                    $(ul).append(li);

                    //컨텐츠에 넣기
                    $(h1).append(s1).append(s2);
                    $(div).append(h1).append(ul);
                    $idContent.append(div);
                    

                });

                $('div[data-role="collapsible"]').collapsible({ refresh: true });
                $('ul[data-role="listview"]').listview({ refresh: true });
                $idContentNone.hide();
                $idContent.show();
            }else {
                $idContentNone.show();
                $idContent.hide();
            }

            fn_loading('hide');
        }

    </script>
</head>
<body>   
    <div data-role="page" id="idOrderAllocatePage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
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
                                        <a href="zxing://scan/?ret=http://mbl.pkvalve.co.kr/MPgmQ020.aspx?code={CODE}" target="_self" id="idBtnSearch" class="ui-btn ui-icon-tag ui-btn-icon-notext ui-corner-all ui-btn-inline">바코드</a>
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

                <div id="idContent"  style="margin-top:16px">
                </div>
	    </div>    
    </div>
</body>e
</html>
