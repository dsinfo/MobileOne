


//페이지 초기화
function pageInit() {
    $('body').on('contextmenu', function () {
        return false;
    });
}

//사용자 권한 체크
function pageUserAuthorityCheck() {
    //인증 체크
    /*
    if (sessionStorage['SSNID'] == null || sessionStorage['SSNID'] == undefined) {
        location.replace('view/Login.aspx');
        return;
    }

    //페이지 실행권한 체크
    var spliteFile = $(document).attr('URL');
    var arr = spliteFile.split("/");
    var docuName = arr[arr.length - 1];

    if (docuName.indexOf('?') != -1) {
        docuName = docuName.split("?")[0];
    }

    if (docuName != 'Index.aspx') {
        alert('다른 기기에서 로그인을 했거나 세션정보가 존재하지 않습니다!');
        location.replace('view/Login.aspx');
    }
    */
}

//테마 설정
function pageSetTheme() {
    for (var pageId = 0; pageId < arguments.length; pageId++) {
        //        $('#' + arguments[pageId]).attr('data-theme',$.cookie("theme") == 'b' ? 'b': 'a');
        //        $('#' + arguments[pageId] ).removeClass( "ui-page-theme-a ui-page-theme-b" ).addClass( "ui-page-theme-" + $.cookie("theme") == 'b' ? 'b': 'a' );
    }
}

//로그아웃 이벤트 설정
function pageSetLogoutEvent(logoutTagId) {
    $('#' + logoutTagId).on("click", function () {
        sessionStorage.removeItem('SSNID');
    });
}
