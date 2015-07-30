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

        //페이지 초기화
        $(document).ready(function () {

            //페이지 초기화
            pagInit();

            //권한 체크
            pageAuthCheck();

            //로그아웃 설정
            pageSetLogoutEvent('idLogout');

            //메뉴페이지 설정
            pageMakeMenu('idDeptPage', 'idMenu', true);

            //조직도 조회
            fn_getOrganization();

            //탭 클릭이벤트 연결
            $('#divNav').find('a').on('click', function () {
                var atrgu = $(this).attr('atrgu');
                switch (atrgu) {
                    case 'A':
                        dataSet = orgData;
                        fn_setOrganization();
                        break;
                    case '4':
                    case '5':
                    case '8':
                    case '3':
                        dataSet = orgData.filter(function (elem) { return elem.ATRGU == atrgu });
                        fn_setOrganization();
                        break;
                }
            });

        });

        //조직도 데이터 가져오기
        function fn_getOrganization() {

            fn_loading('show');

            orgData = fn_GetData('Dptmas.asmx/GetOrganization', { dptcd: '' });           

            dataSet = orgData;

            fn_setOrganization();            
        }

        //조직도 UI 만들기
        function fn_setOrganization() {

            fn_loading('show');
            

            var $idContent = $('#idContent');
            var prevData = null;
        
            if (dataSet != "") {

                var filterText = '';
                var liHtml = '';
                var $div = null;
                var $ul = null;
                var $h3 = $('<h3></h3>');
                var $li = null;

                $idContent.empty();
                dataSet.forEach(function (data, index) {
                    liHtml = '';
                    if (data.GUBUN.trim() == 'D') {
                        if ($div != null) {
                            if ($div.find('ul').length == 0) {
                                $ul = $('<ul data-role="listview" data-inset="false" dptcd="' + prevData.DPTCD.trim() + '" data-split-icon="gear" data-split-theme="a"></ul>');
                                $div.append($ul);
                                $li = $('<li data-filtertext="' + prevData.DPTNM.trim() + ' ' + prevData.WPNNM.trim() + '"></li>');
                                liHtml = '<img src="#" wpnno="' + prevData.WPNNO.trim() + '" dptcd="' + prevData.DPTCD.trim() + '" >';
                                if (prevData.GNAME.trim() == '') liHtml = liHtml + '<span class="ui-span-name">' + prevData.WPNNM.trim() + '</span>';
                                else liHtml = liHtml + '<span class="ui-span-name">' + prevData.WPNNM.trim() + '</span> <span class="ui-span-gname">' + prevData.GNAME.trim() + '</span>';
                                liHtml = liHtml + '<p><a class="ui-a-link" href="tel:' + prevData.HPTEL.trim() + '">' + phone_format(prevData.HPTEL.trim()) + '</a></p>';
                                liHtml = liHtml + '<p><a class="ui-a-link" href="mailto:' + prevData.EMAIL.trim() + '">' + prevData.EMAIL.trim() + '</a></p>';
                                $li.html(liHtml);
                                $ul.append($li);
                                filterText = filterText == '' ? prevData.WPNNM.trim() : filterText + ' ' + prevData.WPNNM.trim();
                            }
                            $div.attr('data-filtertext', filterText);
                        }
                        filterText = '';
                        $div = $('<div data-role="collapsible" class="divDptcd"></div>');
                        $h3 = $('<h3 class="clsDptcd" isload="false" dptcd="' + data.DPTCD.trim() + '"></h3>'); //.text(data.DPTNM.trim());
                        $h3.html(data.DPTNM.trim() + '<span class="ui-li-count">' + data.WPCNT + '</span>');
                        $div.append($h3);
                        $idContent.append($div);
                        filterText = data.DPTNM.trim();

                        if (dataSet.length - 1 == index) {
                            $ul = $('<ul data-role="listview" data-inset="false" dptcd="' + prevData.DPTCD.trim() + '" data-split-icon="gear" data-split-theme="a"></ul>');
                            $div.append($ul);
                            $li = $('<li data-filtertext="' + data.DPTNM.trim() + ' ' + data.WPNNM.trim() + '"></li>');
                            liHtml = '<img src="#" wpnno="' + data.WPNNO.trim() + '" dptcd="' + data.DPTCD.trim() + '" >';
                            if (data.GNAME.trim() == '') liHtml = liHtml + '<span class="ui-span-name">' + data.WPNNM.trim() + '</span>';
                            else liHtml = liHtml + '<span class="ui-span-name">' + data.WPNNM.trim() + '</span> <span class="ui-span-gname">' + data.GNAME.trim() + '</span>';
                            liHtml = liHtml + '<p><a class="ui-a-link" href="tel:' + data.HPTEL.trim() + '">' + phone_format(data.HPTEL.trim()) + '</a></p>';
                            liHtml = liHtml + '<p><a class="ui-a-link" href="mailto:' + data.EMAIL.trim() + '">' + data.EMAIL.trim() + '</a></p>';
                            $li.html(liHtml);
                            $ul.append($li);
                            filterText = filterText + ' ' + data.WPNNM.trim();
                        }

                    } else {
                        if (prevData != null && prevData.GUBUN.trim() != data.GUBUN.trim()) {
                            $ul = $('<ul data-role="listview" data-inset="false" dptcd="' + data.DPTCD.trim() + '" data-split-icon="gear" data-split-theme="a"></ul>');
                            $div.append($ul);
                        }
                        $li = $('<li data-filtertext="' + data.DPTNM.trim() + ' ' + data.WPNNM.trim() + '"></li>');
                        liHtml = '<img src="#" wpnno="' + data.WPNNO.trim() + '" dptcd="' + data.DPTCD.trim() + '" >';
                        if (data.GNAME.trim() == '') liHtml = liHtml + '<span class="ui-span-name">' + data.WPNNM.trim() + '</span>';
                        else liHtml = liHtml + '<span class="ui-span-name">' + data.WPNNM.trim() + '</span> <span class="ui-span-gname">' + data.GNAME.trim() + '</span>';
                        liHtml = liHtml + '<p><a class="ui-a-link" href="tel:' + data.HPTEL.trim() + '">' + phone_format(data.HPTEL.trim()) + '</a></p>';
                        liHtml = liHtml + '<p><a class="ui-a-link" href="mailto:' + data.EMAIL.trim() + '">' + data.EMAIL.trim() + '</a></p>';
                        //                        liHtml = liHtml + '<a href="#" data-rel="popup" data-position-to="window" data-transition="pop">test</a>';
                        $li.html(liHtml);
                        $ul.append($li);
                        filterText = filterText == '' ? data.WPNNM.trim() : filterText + ' ' + data.WPNNM.trim();
                    }
                    prevData = data;
                });

                $idContent.collapsibleset({ refresh: true });
                $idContent.find('ul').listview({ refresh: true });

                $('.clsDptcd').on('click', function () {
                    var $me = $(this);
                    if ($me.attr('isload') == 'false') {

                        // 이미지 로드 실패시 대체 이미지 표시
                        $('img[dptcd="' + $me.attr('dptcd') + '"]').error(function () {
                            $(this).attr('src', 'Images/emppic/noimage.jpg');
                        }).attr('src', function (index) {
                            $(this).attr('src', 'Images/emppic/' + $(this).attr('wpnno') + '.jpg' + '?' + Math.random());
                        });

//                        $('img[dptcd="' + $me.attr('dptcd') + '"]').attr('src', function (index) {
//                            $(this).attr('src', 'Images/emppic/' + $(this).attr('wpnno') + '.jpg' + '?' + Math.random());                           
//                        });
                        $me.attr('isload', 'true');
                        //$('ul[dptcd="' + $me.attr('dptcd') + '"]').listview({ refresh: true });
                    }
                });
                              
                $idContent.show();
            }else {
              
                $idContent.hide();
            }

            fn_loading('hide');
        }

    </script>
</head>
<body>   
    <div data-role="page" id="idDeptPage">

        <!--메뉴정보-->
        <div data-role="panel" id="idMenu" data-position="left" data-display="overlay">          
	    </div>

        <!--상단바-->
	    <div data-role="header">        
            <a href="#idMenu" data-role="button" data-icon="bullets">메뉴</a>
		    <h1>PKValve-조직도</h1>           
            <a href="Login.aspx" id="idLogout" data-role="button" data-icon="user" data-direction="reverse" data-ajax="false">로그아웃</a>
            <div data-role="navbar" id="divNav">
                <ul>
                    <li><a href="#" class="ui-btn-active" atrgu="A">전체</a></li>
                    <li><a href="#" atrgu="8">임원</a></li>
                    <li><a href="#" atrgu="3">실/소</a></li>
                    <li><a href="#" atrgu="4">팀별</a></li>
                    <li><a href="#" atrgu="5">팀(하위)</a></li>
                </ul>
            </div><!-- /navbar -->
	    </div>

        <!--본문-->
	    <div data-role="content">  
         
            <div class="ui-input-search ui-body-inherit ui-corner-all ui-shadow-inset ui-input-has-clear">
                <input data-type="search" data-enhanced="true" data-inset="false" id="searchForCollapsibleSetChildren" data-filter-placeholder="이름 검색..." >
            </div>
            <div id='idContent' data-role="collapsibleset" data-filter="true"  data-children="> div, > div div ul li" data-inset="false" data-input="#searchForCollapsibleSetChildren">
              
            </div>
            
	    </div>    
    </div>
</body>e
</html>
