<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BasicWebPage.aspx.cs" Inherits="MobileOne.view.Example.BasicWebPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css"/>

    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>

    <title>Hello</title>
</head>

<body>
    <div data-role="page">
      <div data-role="header">
        <h1>Welcome To My Homepage</h1>
      </div>

      <div data-role="main" class="ui-content">
        <p>I Am Now A Mobile Developer!!</p>
      </div>

      <div data-role="footer">
        <h1>Footer Text</h1>
      </div>
    </div> 
</body>
</html>
