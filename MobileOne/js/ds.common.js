/*===========================================================================
                        화면 관련 공통 함수
=============================================================================*/

//1. 로딩바 보여주기/숨기기
function pageLoading(mode) {
    if (mode == "show") {
        $.mobile.loading("show", { text: "검색 중..", textVisible: true });
    } else {
        $.mobile.loading("hide");
    }
}


//메뉴정보 설정오기
function setMenu(userid) {

    var dataSet = reqAjaxService('LoginService.asmx/GetMenu', { userid: userid });
    var dataSetFilter = null;
    var html = '';

    /*
    if (dataSet != "") {
        dataSet.forEach(function (data) {
                html = html + '<li data-role="list-divider">' + data.menu_ID.trim() + '</li>';
                dataSetFilter = dataSet.filter(function (elem) { return elem.UPPGM == data.PGMID; });
                dataSetFilter.forEach(function (pgm) {
                    html = html + '<li><a href="' + pgm.FRMNM.trim() + '" orghref="' + pgm.FRMNM.trim() + '" data-ajax="false" class="code">' + pgm.PGMNM.trim() + '</a></li>';
                }
        });
    }
    */

    if (dataSet != "") {
        dataSet.forEach(function (data) {
            html = html + '<li data-role="list-divider">' + data.menu_ID.trim() + '</li>';
            html = html + '<li><a href="' + data.menu_url.trim() + '" data-ajax="false" class="code">' + data.menu_NM.trim() + '</a></li>';
        });
    }

    alert(html);

    sessionStorage['SMENU'] = html;
}

//IndexPage 메뉴설정
function pageDisplayMenu() {
    var $divMenu = $('#idMenuContent');
    var $ul = $('<ul></ul>');

    $ul.attr('data-role', 'listview');
    $ul.html(sessionStorage['SMENU']);
    $divMenu.append($ul);
    $ul.listview({ refresh: true });
}

/*===========================================================================
                        웹서비스 호출 공통 함수
=============================================================================*/
//ajax 서버호출
function reqAjaxService(serviceName, jsonParam) {
    var result = "";

    $.ajax({
        type: "POST",
        url: "service/" + serviceName,
        data: JSON.stringify(jsonParam),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            alert(data.d);

            if (data.d != "") {
                result = JSON.parse(data.d);
            }
        },
        error: function (err) {
            alert(err.toLocaleString());
        }
    });

    return result;
}
