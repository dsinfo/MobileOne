<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="MobileONE.view.Main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>메인화면</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>   
    <script type="text/javascript" src="http://code.jquery.com/mobile/1.4.2/jquery.mobile-1.4.2.min.js"></script>  
      
    <script type="text/javascript">
        $(document).ready(function () {
            $("#Result").click(function () {
                $.ajax({
                    type: "POST",
                    url: "/service/LoginService.asmx/Login",
                    data: JSON.stringify({"userid":"guest", "password":"guest"}),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // 페이지 메서드 반환 값을 Result div에 삽입한다.
                        
                        var uph = JSON.parse(msg.d);

                        //$("#Result").text("line=" + uph.line_cd + ", plan_tot_qty=" + uph.plan_tot_qty);
                        $("#Result").text(msg.d);
                    },

                    error: function (err) {
                        alert("오류");
                        alert(err.toLocaleString());
                    }
                });
            });
        });

        function JSONParse_Test() {
            var jsontext = '{"firstname":"Jesper","surname":"Aaberg","phone":["555-0100","555-0120"]}';
            var contact = JSON.parse(jsontext);

            $("#Result").text(contact.firstname + "," + contact.surname + contact.phone);
        }

    </script>
</head>

<body>
    <section id="page2" data-role="page">
        <header data-role="header"><h1>메인화면</h1></header>
        <div data-role="content" class="content">
            <div id="Result">
                    Click here for the time.   
            </div>
            <button id ="btnTest" title="test"  onclick="JSONParse_Test()" />
        </div>
        <footer data-role="footer"><h1>창원4공장</h1></footer>
    </section>
</body>
</html>
