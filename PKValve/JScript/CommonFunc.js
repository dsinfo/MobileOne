
//페이지 초기화
function pagInit(){
    $('body').on('contextmenu', function(){
        return false;
    });
}


//메뉴정보 설정오기
function setMenudString(userid){

    var dataSet = fn_GetData('Pgmmas.asmx/GetMenu', { usrid: userid});
    var dataSetFilter = null;
    var html='';
    
    if(dataSet !=""){
        dataSet.forEach(function (data) {            
            if (data.PGMTP.trim()=='D'){
                html = html + '<li data-role="list-divider">' + data.PGMNM.trim() +'</li>';
                dataSetFilter = dataSet.filter(function(elem){ return elem.UPPGM == data.PGMID; });
                dataSetFilter.forEach(function (pgm) {  
                    html = html + '<li><a href="' +pgm.FRMNM.trim() + '" orghref="' + pgm.FRMNM.trim() + '" data-ajax="false" class="code">' + pgm.PGMNM.trim() + '</a></li>';
                });
            }            
        });
    }

    sessionStorage['SMENU']=html;
}



//사용자 권한 체크
function pageAuthCheck() {
    //인증 체크
    if (sessionStorage['SSNID'] == null || sessionStorage['SSNID'] == undefined) {
        location.replace('Login.aspx');   
        return;
    }

    //페이지 실행권한 체크
    var spliteFile = $(document).attr('URL');
    var arr = spliteFile.split("/");
    var docuName = arr[arr.length-1];

    if(docuName.indexOf('?')!=-1){
        docuName=docuName.split("?")[0];
    }

    if(docuName!='Index.aspx'){
        var result = fn_GetData('Usrmas.asmx/CheckAuth', { userid:sessionStorage['USRID'], ssnid:  sessionStorage['SSNID'], frmnm: docuName });

        if(result[0].MSGTY=='E'){
            if(result[0].MSGID=='ERR000'){
                alert('다른 기기에서 로그인을 했거나 세션정보가 존재하지 않습니다!');
                location.replace('Login.aspx');
            }else{
                alert('접근 권한이 없습니다!');
                location.replace('Index.aspx');
            }
            return;        
        }
    }

    

//    if(docuName!='Index.aspx'){
//    if(sessionStorage['SMENU'].indexOf(docuName, 0)==-1) {
//        alert('접근 권한이 없습니다!');
//        location.replace('Index.aspx');
//        }
//    }
}

//테마 설정
function pageSetTheme(){

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

//IndexPage 메뉴설정
function pageSetIndexMenu(){
    var $divMenu = $('#idMenuContent');
    var $ul = $('<ul></ul>');
    $ul.attr('data-role', 'listview');
    $ul.html(sessionStorage['SMENU']);
    $divMenu.append($ul);
    $ul.listview({ refresh: true });
}


//페이지 메뉴만들기
function pageMakeMenu(pageId, menuId, isSwipe) {
   

    var $div=$('<div></div>');    
    var $ul = $('<ul></ul>');

    var html='';
    
    html = html+ '<div style="margin-top:4px;margin-bottom:0px">';
    html = html+ '<table><tr><td style="width:100%"><a href="Index.aspx" data-ajax="false" ><img src="Images/logo_small.png" /></a></td>';
    html = html+ '<td style="width:40px" id="idCloseTd"><a href="#" id="idMenuClose" data-rel="close" class="ui-btn ui-icon-delete ui-btn-icon-notext ui-corner-all">No text</a></td></tr></table></div>';
    $div.html(html);

    $ul.attr('data-role','listview');
    $ul.html(sessionStorage['SMENU']);

    $('#' + menuId).append($div).append($ul);

    //이벤트 연결
    $ul.find('a.code').on("click", function(){
        var ordno = $('input[data-type="search"]').val();
        if(ordno!='' && ordno!=undefined){
            this.href=$(this).attr('orghref') + '?code=' + ordno;    
        }else{
            this.href=$(this).attr('orghref');
        }
    });

    //닫기 이벤트 연결
    $('#idMenuClose').on('click', function(){
        $('#' + menuId ).panel( "close" );
    });

    $ul.listview({ refresh: true });

    if(localStorage["isSwipe"] != 'false'){
         //메뉴 swipe 이벤트 설정
        $(document).on("swipeleft swiperight", '#' + pageId, function (e) {

            if ($.mobile.activePage.jqmData("panel") !== "open") {
                if (e.type === "swiperight") {
                    $('#' + menuId).panel("open");
                }
            }
            else if ($.mobile.activePage.jqmData("panel") == "open") {

                if (e.type === "swipeleft") {
                    $('#' + menuId).panel("close");
                }
            }
        });
    }
}

//페이지 리로드(스캔 OR 파라미터존재)
function isReloadParamPage(searchTag) {

    var address = unescape(location.href);
    var paramOrdno = "";
    var fIdx = address.indexOf("code=", 0);
    if (fIdx != -1) {
        paramOrdno = address.substr(fIdx + 5, address.length - fIdx - 5)
        $(searchTag).val(paramOrdno);     
        return true;
    } else {
        return false;
    }
}
  
//지시번호 필터링 설정
function setOrderSearch(excutionFunctionName) {
    $("#idSearchOrdno").on("filterablebeforefilter", function (e, data) {
        var $ul = $(this),
        $input = $(data.input),       
        value = $input.val(),
        html = "";
        $ul.html("");
        if (value && value.length > 7) {
            $ul.html("<li><div class='ui-loader'><span class='ui-icon ui-icon-loading'></span></div></li>");
            $ul.listview("refresh");
            $.ajax({
                type: "POST",
                url: "WebService/Momast.asmx/GetOrders",
                data: JSON.stringify({ ordno: $input.val() }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                if (data.d != "") {
                    $.each(JSON.parse(data.d), function (i, val) {
                        html += "<li class='ordnoList'>" + val.ORDNO + ".<span style='color:blue'>" + val.FITEM + "</span></li>";
                    });
                    $ul.html(html);
                    $('li.ordnoList').click(function () {
                        //var value = $(this).text().trim().substr(0,17);
                        $input.val($(this).text().trim().substr(0,17));
                        $("#idSearchOrdno *").hide();
                        eval(excutionFunctionName);                     
                    });
                } else {
                    $ul.html("");
                }
                $ul.listview("refresh");
                $ul.trigger("updatelayout");
                },
            });
        }
    });
}


//ajax 서버호출
function fn_GetData(serviceName, jsonParam){
 var result="";
   
    $.ajax({
        type: "POST", 
        url: "WebService/" + serviceName ,               
        data: JSON.stringify(jsonParam),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,             
        success: function (data) {
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

function fn_GetString(serviceName, jsonParam){
 var result="";
   
    $.ajax({
        type: "POST", 
        url: "WebService/" + serviceName ,               
        data: JSON.stringify(jsonParam),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,             
        success: function (data) {
           result = data.d;             
        },
        error: function (err) {                                
            alert(err.toLocaleString());            
        }
    });
    
    return result;    

}

//로딩바 보여주기/숨기기
function fn_loading(mode){

    if (mode=="show"){
        $.mobile.loading("show", { text: "검색 중..", textVisible: true });
    }else{
        $.mobile.loading("hide");
    }
}


//전화번호 형식으로 바꾸기
function phone_format(num){
    return num.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
}

//날짜유효성 체크
function isValidDate(param) {
    try
    {
        param = param.replace(/-/g,'');
        param = param.replace('.','');
 
        // 자리수가 맞지않을때
        if( isNaN(param) || param.length!=8 ) {
            return false;
        }
             
        var year = Number(param.substring(0, 4));
        var month = Number(param.substring(4, 6));
        var day = Number(param.substring(6, 8));
 
        var dd = day / 0;
 
             
        if( month<1 || month>12 ) {
            return false;
        }
             
        var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var maxDay = maxDaysInMonth[month-1];
             
        // 윤년 체크
        if( month==2 && ( year%4==0 && year%100!=0 || year%400==0 ) ) {
            maxDay = 29;
        }
             
        if( day<=0 || day>maxDay ) {
            return false;
        }
        return true;
 
    } catch (err) {
        return false;
    }                       
}

//날짜포맷 만들기
function convertDateString(dateValue,gubun){

    gubun = (gubun == undefined ? "-" : gubun);
    
    return  dateValue.substr(0, 4) + gubun + dateValue.substr(4, 2) + gubun + dateValue.substr(6, 2) 

}

function formatDate(date) {
    var mymonth = date.getMonth() + 1;
    var myweekday = date.getDate();
    return (date.getFullYear() + "-" + ((mymonth < 10) ? "0" : "") + mymonth + "-" + ((myweekday < 10) ? "0" : "") + myweekday);
}

function convertDate(date, day) {    
  
    date.setDate(date.getDate() + day);
    return formatDate(date);
    
}

