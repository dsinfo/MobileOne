﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DialogBox.aspx.cs" Inherits="MobileOne.view.Example.DialogBox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css"/>

    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>

    <title>MultiplePages</title>
</head>
<body>

    <div data-role="page" id="pageone">
      <div data-role="header">
        <h1>Welcome To My Homepage</h1>
      </div>

      <div data-role="main" class="ui-content">
        <p>Welcome!</p>
        <a href="#pagetwo">Go to Dialog Page</a>
      </div>

      <div data-role="footer">
        <h1>Footer Text</h1>
      </div>
    </div> 

    <div data-role="page" data-dialog="true" id="pagetwo">
      <div data-role="header">
        <h1>I'm A Dialog Box!</h1>
      </div>

      <div data-role="main" class="ui-content">
        <p>The dialog box is different from a normal page, it is displayed on top of the current page and it will not span the entire width of the page. The dialog has also an icon of "X" in the header to close the box.</p>
        <a href="#pageone">Go to Page One</a>
      </div>

      <div data-role="footer">
        <h1>Footer Text In Dialog</h1>
      </div>
    </div> 

</body>
</html>