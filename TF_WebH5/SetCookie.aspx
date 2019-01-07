<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetCookie.aspx.cs" Inherits="SetCookie" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>设置Cookie</title>    <script type="text/javascript" src="Js/JsCookies.js"></script> 
    <script language="javascript" type="text/javascript">
        function SetLoginCookie(rember,userid,username,pwd,logintype)
        {
            SetCookie("rember",rember);
            SetCookie("userid",userid);
            SetCookie("username",username);
            SetCookie("pwd",pwd);
            SetCookie("logintype",logintype);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%--<input type="button" id="sss" value="ssss" onclick="SetLoginCookie(1,1,1,1,1)" />--%>
    </div>
    </form>
</body>
</html>
