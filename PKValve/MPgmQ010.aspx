<%@ Page Language="C#" Inherits="PKMobileWeb.PKPage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PKMobileWeb-작업지시현황</title>
    <meta charset="utf-8" /> 
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" >
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.css" />
    <style type="text/css">
        .ui-tbl-caption 
        {
             width: 20%;                           
             text-align : right;
        }
        
        .ui-tbl-content 
        {
             width: 80%;                           
             padding-left : 10px;
        }        
        
        .ui-panel-inner
        {
            padding-top : 0px;          
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
       
        //지시번호 필터링 설정
        $(document).on("pagecreate", "#idOrderInfoPage", function () { setOrderSearch('fn_getOrderInformation();'); });

        //페이지 초기화
        $(document).ready(function () {
            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idOrderInfoPage', 'idMenu', true);

            //페이지 리로드(스캔 또는 파라미터 호출)
            if (isReloadParamPage('input[data-type="search"]')) {
                fn_getOrderInformation();
            }

            //지시번호 EnterKey 이벤트 설정
            $('input[data-type="search"]').keydown(function (key) {
                if (key.keyCode == 13) {
                    $("#idSearchOrdno *").hide();
                    fn_getOrderInformation();
                }
            });
        });

        //지시정보 가져오기
        function fn_getOrderInformation() {

            var sInput = $('input[data-type="search"]');
            if (sInput.val() == "") {
                alert("지시번호를 입력하세요!");
                sInput.focus();
                return;
            }

            fn_loading('show');

            var dataSet = fn_GetData('Momast.asmx/GetOrderInfomation', { ordno: sInput.val() });

            if (dataSet != "") {

                dataSet.forEach(function (data) {

                    $('#idContentNone').hide();
                    $('#idContent').show();

                    $('#idOrdno').text(data.ORDNO.trim() + ' ( ' + data.MOSTS.trim() + ' )');
                    $('#idCusnm').text(data.CUSNM.trim());
                    $('#idPrjnm').text(data.PRJNM.trim());
                    $('#idItnbr').text(data.FITEM.trim());
                    $('#idItdsc').text(data.ITDSC.trim());
                    $('#idItstd').text(data.ITSTD.trim());
                    $('#idItmat').text(data.ITMAT.trim());
                    $('#idPoint').text(data.POINT.trim());
                    $('#idImpty').text(data.IMPTY.trim());
                    $('#idWkseq').text(data.WKSEQ == '0' ? '' : data.WKSEQ);
                    $('#idOrdqt').text(data.ORDQT);
                    $('#idScrqt').text(data.SCRQT);
                    $('#idOpnqt').text(data.OPNQT);
                    $('#idStkqt').text(data.STKQT);
                    $('#idReldt').text(data.RELDT.trim());
                    $('#idStrdt').text(data.STRDT.trim());
                    $('#idDuedt').text(data.DUEDT.trim());
                    $('#idMtcnt').text('할당수 : ' + data.MTCNT);
                    $('#idMrcnt').text('공정수 : ' + data.MRCNT);
                    $('#idMosts').text(data.MOSTS.trim());

                });

                $('#idAallocateItem').attr('href', 'MPgmQ030.aspx?code=' + sInput.val());
                $('#idAprocess').attr('href', 'MPgmQ020.aspx?code=' + sInput.val());

            } else {

                $('#idContentNone').show();
                $('#idContent').hide();

                $('#idAallocateItem').attr('href', 'MPgmQ030.aspx');
                $('#idAprocess').attr('href', 'MPgmQ020.aspx');
            }

            fn_loading('hide');
        }        

    </script>
</head>
<body>   
    <div data-role="page" id="idOrderInfoPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay"> 
               
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>작업지시현황</h1>            
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
                                        <a href="zxing://scan/?ret=http://mbl.pkvalve.co.kr/MPgmQ010.aspx?code={CODE}" target="_self" id="idBtnSearch" class="ui-btn ui-icon-tag ui-btn-icon-notext ui-corner-all ui-btn-inline">바코드</a>
                                       <%-- <a href="http://mbl.pkvalve.co.kr/MPgmQ010.aspx?code=13-00633-012-0001" target="_self" id="idBtnSearch" class="ui-btn ui-icon-tag ui-btn-icon-notext ui-corner-all ui-btn-inline">바코드</a>--%>
                                    </cfoutput>
                                    <%--<input type=ㅌ"button" class="ui-btn-icon-notext" id="idBtnSearch" value="" data-icon="tag"  onclick="fn_getOrderInformation()"/>--%>
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

                <!--검색내역-존재-->
                <ul id="idContent" data-role="listview" data-inset="true"style="margin-top:10px;display:none">
                    <li data-role="list-divider"><div style="font-size:1.2em">작 업 지 시 서</div>
                        <a class="ui-a-link" id="idAallocateItem" href="MPgmQ030.aspx" data-ajax="false" ><span id="idMtcnt" class="ui-li-count" style="margin-right:85px;">할당수 :</span></a>
                        <a class="ui-a-link" id="idAprocess" href="MPgmQ020.aspx" data-ajax="false" ><span id="idMrcnt" class="ui-li-count">공정수 :</span></a>
                    </li>
                    <li>
                        <table>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>지시번호 :</span>
                                </td>
                                <td class="ui-tbl-content">
                                    <span id="idOrdno"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>고 객 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idCusnm"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>프로젝트 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idPrjnm"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>품목번호 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idItnbr"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>품  명 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idItdsc"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>규  격 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idItstd"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>재  질 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idItmat"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>조립주차 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idWkseq"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>출고계획 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idPoint"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>매출계획 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idImpty"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>지시수량 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idOrdqt"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>폐기수량 :</span>
                                </td>
                                 <td class="ui-tbl-content">
                                    <span id="idScrqt"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>미입고량 :</span>
                                </td>
                                    <td class="ui-tbl-content">
                                    <span id="idOpnqt"></span>
                                </td>                               
                            </tr>
                             <tr>
                                <td class="ui-tbl-caption" >
                                    <span>입고량 :</span>
                                </td>
                                    <td class="ui-tbl-content">
                                    <span id="idStkqt"></span>
                                </td>            
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>작업지시일 :</span>
                                </td>
                                    <td class="ui-tbl-content">
                                    <span id="idReldt"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>시작예정일 :</span>
                                </td>
                                    <td class="ui-tbl-content">
                                    <span id="idStrdt"></span>
                                </td>                               
                            </tr>
                            <tr>
                                <td class="ui-tbl-caption" >
                                    <span>종료예정일 :</span>
                                </td>
                                    <td class="ui-tbl-content">
                                    <span id="idDuedt"></span>
                                </td>                               
                            </tr>
                        </table>                      
                    </li>               
                </ul>        

	    </div>    
    </div>
</body>e
</html>
