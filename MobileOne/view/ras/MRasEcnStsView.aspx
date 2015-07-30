<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MRasEcnStsView.aspx.cs" Inherits="MobileOne.view.ras.MRasEcnStsView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <meta charset="utf-8"name="viewport" content="width=device-width, initial-scale=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    
	<meta name="HandheldFriendly" content="True" />
	<meta name="MobileOptimized" content="width"/>
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />

    <title>설비상태정보 수집</title>


	<!--Include JQuery -->
	<link rel="stylesheet" href="http://code.jquery.com/mobile/latest/jquery.mobile.structure.min.css" />

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>

	<!--JQM globals you can edit or remove file entirely... note it needs to be loaded before jquerymobile js -->
	<script src="/js/jqm.globals.js"></script>

	<script src="http://code.jquery.com/mobile/latest/jquery.mobile.min.js"></script>
	<script src="/js/jquery.animate-enhanced.min.js"></script>


	<!--JQM SlideMenu-->
	<link rel="stylesheet" href="/css/themes/jqmfb.min.css" />
	<link rel="stylesheet" href="/css/jqm.slidemenu.css" />
	<script src="/js/jqm.slidemenu.js"></script>
    
    <script>

        // 특정 설비에 대한 정보를 검색함
        function find() {
            var searchData = new Object();

            searchData.eqcd = $("#workdate").val();

            requestAjaxService("RasService.asmx/Find", searchData);
        }


        // 특정 설비에 대한 정보를 검색함
        function select() {
            var searchData = new Object();

            searchData.workdate = $("#workdate").val();

            requestAjaxService01("Hello.asmx/Select", searchData);
        }


        function requestAjaxService01(serviceName, jsonParam) {
            var result = "";

            alert("call ajax");

            $.ajax({
                type: "POST",
                url: "/service/" + serviceName,
                data: JSON.stringify(jsonParam),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    alert("성공");
                    if (data.d != "") {
                        alert(data.d);
                        result = JSON.parse(data.d);
                        drawTable(result);
                    }
                    else {
                        alert("SUCCESS not");
                    }
                },
                error: function (err) {
                    alert("오류");

                    alert(err.toLocaleString());
                }
            });

            return "OK";  //result;
        }


        function drawTable(data) {
            for (var i = 0; i < data.length; i++) {
                drawRow(data[i]);
            }
        }

        function drawRow(rowData) {
            var row = $("<tr />")
            $("#RasEcnStsTable").append(row); //this will append tr element to table... keep its reference for a while since we will add cels into it
            row.append($("<td>" + rowData.line_cd + "</td>"));
            row.append($("<td>" + rowData.eq_cd + "</td>"));
            row.append($("<td>" + rowData.qty + "</td>"));
        }

    </script>
</head>

<body>
   <div data-role="page" data-position="fixed" data-tap-toggle="false" data-update-page-padding="false" id="pageone">
        <div data-role="header">
            <a href="#" class="ui-btn" data-rel="back">Go Back</a>
            <h1>Styling Column Toggle Table</h1>
            <button class="ui-btn ui-corner-all ui-icon-search ui-btn-icon-left" onclick="select();" >select</button>
            <button class="ui-btn ui-corner-all ui-icon-search ui-btn-icon-left" onclick="find();" >find</button>
        </div>

        <div class="ui-field-contain">
        <label for="workdate">작업일:</label>
        <input type="text" name="workdate" id="workdate"/>
        </div>
  
        <div data-role="main" class="ui-content">
        <div>
            <table data-role="table" data-mode="columntoggle" class="ui-responsive ui-shadow" id="myTable">
              <thead>
                <tr>
                  <th data-priority="3">라인</th>
                  <th data-priority="1">설비</th>
                  <th data-priority="2">건수</th>
                </tr>
              </thead>
              <tbody id="RasEcnStsTable">
             </tbody>
            </table>
         </div>
      </div>
      <div data-role="footer">
        <h1>Footer Text</h1>
      </div>
   </div>
  
</body>
</html>
