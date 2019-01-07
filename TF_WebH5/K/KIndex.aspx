<%@ Page Language="C#" AutoEventWireup="true" CodeFile="KIndex.aspx.cs" Inherits="K_KIndex" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="renderer" content="webkit" /><title>
	首页-<% =Resources.Lan.K1Title2 %>
</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
    <link href="../Css/index.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../Css/style2.0.css" />
	<link rel="stylesheet" type="text/css" href="../EasyUI/themes/default/easyui.css">    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css" />    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css" />     <script type="text/javascript" src="../EasyUI/jquery.min.js"></script>      <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script>      <script type="text/javascript" src="../Js/JsCookies.js"></script> 
    <script type="text/javascript" src="../Js/JsBase64.js"></script>  
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=l4zKPgF3ihF8lciY2QGmpsvW"></script><!--C9f93589d92e645b1a9a4cf2fb53caa4-->
	<script type="text/javascript" src="../Js/Baidu/BaiduLatLngCorrect.js"></script>
    <style type="text/css">
        body
        {
            font-size: 12px;
            background-color: #F7F7F7;
            overflow: auto;
            color: #333333;
            margin: 0px 5px 0px 5px;
            border: 1px solid red;
        }
        
        a
        {
            text-decoration: none;
            color: #333333;
        }

        inputSearch a:hover
        {
            text-decoration: none;
            color: #333333;
        }

        a:active
        {
            text-decoration: none;
            border-color: #333333;
        }

        .top
        {
            border: 0px solid red;
            height: 0px;
            padding-left: 20px;
            vertical-align: middle;
            background-color: #1E293D;
            color: #FFFFFF;
        }

            .top table
            {
                width: 100%;
                margin: 0;
                padding: 0;
                height: 40px;
            }

        .menu
        {
            border: 0px solid #8DB2E3;
            height: 45px;
            line-height: 40px;
            padding-left: 20px;
            background-color: #F7F7F7;
            font-size: 12px;
        }

        .tab
        {
            border: 0px solid red;
            margin-top: 1px;
        }


        .btnOver
        {
            height: 20px;
            width: 60px;
            text-align: center;
            background-color: #1E293D;
            color: #FFFFFF;
        }

        .btnOut
        {
            height: 20px;
            width: 60px;
            text-align: center;
            background-color: #F7F7F7;
            color: #333333;
        }

        .btnOverLeft
        {
            height: 20px;
            width: 60px;
            text-align: right;
            background-color: #1E293D;
            color: #FFFFFF;
        }

        .btnOutLeft
        {
            height: 20px;
            width: 60px;
            text-align: right;
            background-color: #F7F7F7;
            color: #333333;
        }

        .btnOverRight
        {
            height: 20px;
            width: 20px;
            text-align: left;
            background-color: #1E293D;
            color: #FFFFFF;
        }

        .btnOutRight
        {
            height: 20px;
            width: 20px;
            text-align: left;
            background-color: #F7F7F7;
            color: #333333;
        }

        .menuPOver
        {
            color: #FFFFFF;
            background-color: #1E293D;
        }

        .menuPOut
        {
            color: #000000;
            background-color: #F7F7F7;
        }

        .menuCOver
        {
            color: #DA6931;
        }

        .menuCOut
        {
            color: #FFFFFF;
        }

        .header-nav
        {
            list-style: none;
        }

        .inputSearch
        {
            margin-right: 10px;
            border: none;
            padding-left: 30px;
            float: right;
            width: 220px;
            height: 25px;
            margin-top: 5px;
            background: url('../EasyUI/themes/icons/offline.png') no-repeat center left;
            background-position: 8px;
            background-color: white;
            border-radius: 2px;
        }

            .inputSearch:focus
            {
                outline: none;
            }

        /*菜单*/


        li a
        {
            color: #FFFFFF;
            text-decoration: none;
            font-size: 15px;
        }

            li a:hover
            {
                color: #f8cb3b;
                text-decoration: none;
            }



        .rp:hover
        {
            background-color: rgb(255, 255, 255);
            border-left: 1px solid #AAA;
            border-right: 1px solid #AAA;
        }

        #mn li
        {
            float: left;
            padding: 9.5px;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
        }


        .rpContext
        {
            margin-left: -11px;
            position: absolute;
            display: none;
        }


        .reprr
        {
            color: #777777;
        }

        .moveon
        {
            margin-left: -11px;
            position: absolute;
            display: block;
        }




        .reptype
        {
            color: #D32338;
            font-size: 15px;
        }

        .repnav
        {
            color: #5993AA;
            margin-left: 15px;
            margin-top: 10px;
        }

            .repnav:hover
            {
                color: #494748;
                margin-left: 15px;
                margin-top: 10px;
            }

        .userContext
        {
            height: 55px;
            width: 100px;
            background-color: white;
            position: absolute;
            border: 1px solid #AAA;
            -moz-box-shadow: 2px 6px 10px #D1D1D1;
            -webkit-box-shadow: 2px 6px 10px #D1D1D1;
            box-shadow: 2px 6px 10px #D1D1D1;
            float: right;
            margin-left: -70px;
            margin-top: -5px;
            display: none;
        }

        .userContextmoveon
        {
            border-top: 1px solid #bbb;
            border-bottom: 1px solid #8F8A8A;
            border-left: 1px solid #bbb;
            border-right: 1px solid #BBB8B8;
            -moz-box-shadow: 0px 1px 0px #ABB0B4;
            -webkit-box-shadow: 0px 1px 0px #ABB0B4;
            box-shadow: 0px 1px 0px #ABB0B4;
            border-radius: 3px;
            background-color: white;
            float: right;
            margin-left: -70px;
            margin-top: -1px;
            display: block;
        }

        .gaishu
        {
        }

            .gaishu:hover
            {
                background-color: #4da7dc;
                border: 1px solid white;
            }

        .duser:hover
        {
            border-radius: 3px;
            background-color: #73C9FF;
            cursor: pointer;
        }

        .tx:hover
        {
            background-color: rgb(213, 213, 213);
            border-radius: 3px;
        }

        .repLis
        {
            color: #777777;
            text-decoration: none;
            font-size: 15px;
        }

        /*导航框样式*/
        #Navigation
        {
            width: 45px;
            height: 200px;
            border: 1px solid #e0e0e0;
            background-color: #fdfdfd;
            position: fixed;
            top: 205px;
            right: 0;
            z-index: 1024;
        }

        #NavTop
        {
            text-align: center;
            line-height: 43px;
            font-size: 14px;
            border-bottom: 1px solid #eaeaea;
            color: #999;
        }

        #NavShowIcon div
        {
            width: 40px;
            margin-top: 10px;
            height: 40px;
            margin-left: 8px;
        }

        .navRight
        {
            cursor: pointer;
            margin-top: -2px;
            width: 30px;
            height: 30px;
            line-height: 30px;
            color: white;
            border: 1px solid #ccc;
            background-color: #4f9cee;
            float: left;
            font-size: 16px;
            border-radius: 20px;
            text-align: center;
            margin-left: -16px;
        }
        /*#Remind
        {
            background: transparent url(Images/Nav/到期提醒灰色.png) no-repeat!important;
        }

            #Remind:hover
            {
                background: transparent url(Images/Nav/到期提醒黄色.png) no-repeat!important;
                cursor: pointer;
            }

        #vehMap
        {
            background: transparent url(Images/Nav/车辆分布图灰色.png) no-repeat!important;
        }

            #vehMap:hover
            {
                background: transparent url(Images/Nav/车辆分布图黄色.png) no-repeat!important;
                cursor: pointer;
            }

        #OnlineRate
        {
            background: transparent url(Images/Nav/车辆在线率灰色.png) no-repeat!important;
        }

            #OnlineRate:hover
            {
                background: transparent url(Images/Nav/车辆在线率黄色.png) no-repeat!important;
                cursor: pointer;
            }*/

        #refresh
        {
            background-color: none;
        }

            #refresh:hover
            {
                border-radius: 3px;
                background-color: #73C9FF;
                cursor: pointer;
            }
    </style>


</head>

<body id="context" style="width: 100%; height: 100%; overflow: auto;" class="yui-skin-sam">
<form  id="formcs" runat="server">
    <div style="position: fixed; width: 100%; z-index: 100;">
        <div style="min-width: 1000px; height: 35px; background-color: #6296DD; border-bottom: 1px solid #5B85E0; position: relative;">
            <div style="margin-left: 10px; margin-top:3px; float: left; position: absolute;color: #ffffff; font-weight:bold; font-size:x-large;" ><% =Resources.Lan.K1Title2 %></div>
            <div style="min-width: 500px; margin-left: 240px; float: left; position: absolute; bottom: 0;">
                <ul id="mn" style="height: 35px;">
                    <li><a style="color: #f8cb3b;">首页</a>
                    </li>
                    <li><a href="MonitorCenter.aspx" target="_blank">监控中心</a>
                    </li>
                    <li><a href="javascript:GotoBackEnd();">资料管理后台</a>
                    </li>
                </ul>
            </div>

            
            <div class="duser" onmouseout="usermove();" onmouseover="userover();" style="height: 25px; cursor: pointer; margin-top: 5px; float: right; width: 30px; margin-right: 5px;">
                <table>
                    <tr>
                        <td>
                            <img src="../EasyUI/themes/icons/man.png" style="height: 18px; margin-left: 5px; margin-top: 2px;">
                        </td>
                    </tr>
                </table>
                <div id="userContext" class="userContext">
                    <!--<li style="list-style-type: none; height: 25px;" class="timeline">
                        <a class="repLis" style="margin-left: 20px; margin-top: 5px; float: left" href="navigation/TimeLine1.aspx" target="_blank">成长历程</a>

                    </li>-->
                    <li style="list-style-type: none; height: 25px;">
                        <a class="repLis" style="margin-left: 20px; margin-top: 5px; float: left" href="javascript:void(0)" onclick="LogOutClick()">退出</a>
                        <asp:Button ID="btnClearSessionCS" Height="0" Width="0" runat="server" Text="" OnClick="btnClearSessionCS_Click" />
                    </li>
                </div>
            </div>
            <div id="refresh" style="float: right; height: 25px; width: 30px; margin-top: 5px; text-align: center; vertical-align: middle; display:none;">
                <img src="../EasyUI/themes/icons/reload.png" title="刷新" style="height: 18px; margin-top: 3px;" />
            </div>
            <div style="display:none;">
                <input id="inputSearch" class="inputSearch" placeholder="单车今日概况" visible="false" />
            </div>
        </div>
        <%--<div style="width:0px; height:0px;">
            <div id="map" style="width:100px; height:100px;"></div>
        </div>--%>
    </div>
    

    <div style="overflow: auto; width: 100%; position: relative; height: 1740px; background-color: #f5f5f5;">
        <div style="margin-top: 65px;"></div>

        <div style="width: 1200px; background-color: white; height: 1620px; margin: 0 auto 0 auto; border: 1px solid #E3E3E3; -moz-box-shadow: 2px 6px 10px #D1D1D1; -webkit-box-shadow: 2px 6px 10px #D1D1D1; box-shadow: 2px 6px 10px #D1D1D1;">
            <div style="height: 100px; width: 30px; position: absolute; background-color: #4f9cee; margin-left: -30px; margin-top: 50px; border: 1px solid #5D9BDF; border-right: 0px; cursor: pointer;">
                <img src="../EasyUI/themes/icons/report.png" style="height: 20px; margin-left: 3px; margin-top: 5px; margin-bottom: 5px;" />
                <div>
                    <a style="color: white; margin-left: 7px; font-weight: bold;">统</a>
                    <a style="color: white; margin-left: 7px; margin-top: 2px; font-weight: bold;">计 </a>
                    <a style="color: white; margin-left: 7px; margin-top: 2px; font-weight: bold;">信</a>
                    <a style="color: white; margin-left: 7px; margin-top: 2px; font-weight: bold;">息 </a>
                </div>
            </div>
            
            <div style="margin-top: 20px; margin-left: 20px; height: 490px; width: 95%; border-left: 2px dotted #ccc">

                <div id="btnItemAlarm" style="height: 25px; width: 100%;">
                    <div id="Remind" class="navRight" onclick="navTo(this)">1</div>
                    <h1 style="float: left; margin-left: 15px; position: absolute; font-size: 25px; font-weight: bold;">到期及提醒
                    </h1>
                    <div style="float: right; height: 13px; margin-left: 60px; border-bottom: 1px solid #ccc; width: 950px;"></div>
                </div>

                <div id="Div1" style="float: left; min-width: 100%; height: 450px; margin-top: 10px; border-radius: 3px;">

                    <div style="float: left; width: 100px; background-color: #f5f5f5; height: 450px; margin-left: 50px; border: 1px solid #ebebeb">

                        
                        <div id="btnItemServeTime" class="icoBg" style="height: 90px; float: left; margin: 10px 0px 0px 10px; cursor: pointer;">
                            <div id="dServeTime" style="float: left; height: 20px; width: 32px; background-color: rgb(250, 85, 0); color: White; margin: 1px 0 0 55px; position: absolute; vertical-align: top; border-radius: 15px; text-align: center; font-size: 12px; line-height: 20px; font-weight: bold; border: 1px white  solid; display: none;">
                                <span id="txtServeTime"></span>
                            </div>
                            <div class="tx">
                                <img src="../Img/ServerEnd.png" height="80px" width="80px" alt="" />
                            </div>
                            <span style="text-align: center; margin-left: 5px;">服务到期提醒</span>
                        </div>

                        
                        <div id="btnItemAnnual" class="icoBg" style="height: 90px; float: left; margin: 10px 0px 0px 10px; cursor: pointer;">
                            <div id="dAnnual" style="float: left; height: 20px; width: 32px; background-color: rgb(250, 85, 0); color: White; margin: 1px 0 0 55px; position: absolute; vertical-align: top; border-radius: 15px; text-align: center; font-size: 12px; line-height: 20px; font-weight: bold; border: 1px white  solid; display: none;">
                                <span id="txtAnnual"></span>
                            </div>
                            <div class="tx">
                                <img src="../Img/AnnualEnd.png" height="80px" width="80px" />
                            </div>
                            <span style="text-align: center; margin-left: 5px;">年检到期提醒</span>
                        </div>
                        
                        <div id="btnItemMileMaintain" class="icoBg" style="height: 90px; float: left; margin: 10px 0px 0px 10px; cursor: pointer;">
                            <div id="dMileMaintain" style="float: left; height: 20px; width: 32px; background-color: rgb(250, 85, 0); color: White; margin: 1px 0 0 55px; position: absolute; vertical-align: top; border-radius: 15px; text-align: center; font-size: 12px; line-height: 20px; font-weight: bold; border: 1px white  solid; display: none;">
                                <span id="txtMileMaintain"></span>
                            </div>
                            <div class="tx">
                                <img src="../Img/Mile.png" height="80px" width="80px" />
                            </div>
                            <span style="text-align: center; margin-left: 5px;">里程保养提醒</span>
                        </div>
                        
                        <div id="btnItemLongTimeOff" class="icoBg" style="height: 90px; float: left; margin: 10px 0px 0px 10px; cursor: pointer;">
                            <div id="dLongTimeOff" style="float: left; height: 20px; width: 32px; background-color: rgb(250, 85, 0); color: White; margin: 1px 0 0 55px; position: absolute; vertical-align: top; border-radius: 15px; text-align: center; font-size: 12px; line-height: 20px; font-weight: bold; border: 1px white  solid; display: none;">
                                <span id="txtLongTimeOff"></span>
                            </div>
                            <div class="tx">
                                <img src="../Img/Offline.png" height="80px" width="80px" />
                            </div>
                            <span style="text-align: center; margin-left: 5px;">长时间掉线</span>
                        </div>
                    </div>




                    <div style="float: left; width: 900px; height: 450px; margin-left: 20px;">
                        <!--<div style="width: 100%; height: 25px; background-color:#f5f5f5;border:1px solid #ebebeb">
                            <label id="tbTitle" style="float: left; margin-left: 5px; margin-top: 3px; color: #444; ">
                                服务到期提醒</label>
                            
                        </div>-->
                        <img id="tableImg" src="../Img/BYBG.jpg" width="950px" height="448px" alt="" style="margin-left: 1px; margin-top: 0px; position: absolute; z-index: 10" />
                        <div id="divCover" class="dataTables_Loading" style="position: absolute; background-color: #FFFFFF; z-index: 99; width: 897px; height: 397px; margin-left: 1px; margin-top: 26px; text-align: center; display: none">
                            <img id="img1" src="../Img/loading.gif" style="margin-top: 50px;" alt="" />
                            <div><a style="font-weight: bold; color: rgb(22, 21, 20); font-size: 15px;">正在加载...</a></div>
                        </div>
                        <div id="divServeTime" style="width: 100%">
                            <table id="tableServeTime" class="easyui-datagrid" title="服务到期提醒" style="width:100%; height:448px;  " data-options="showHeader:true,striped:true,nowrap:false,singleSelect:true,collapsible:true,toolbar:toolbarServeTime">
		                        <thead>
			                        <tr>
				                        <th data-options="field:'name',width:115,halign:'center',align:'left'" >车组</th>
				                        <th data-options="field:'team',align:'left',halign:'center',width:130" >车牌号码</th>
				                        <th data-options="field:'timebegin',align:'left',halign:'center',width:160" >服务开始时间</th>
				                        <th data-options="field:'timeend',align:'left',halign:'center',width:160" >服务到期时间</th>
				                        <th data-options="field:'daysur',align:'left',halign:'center',width:130" >剩余天数</th>
				                    </tr>
		                        </thead>
	                        </table>
                        </div>
                        <div id="divAnnual" style="width: 100%">
                            <table id="tableAnnual" class="easyui-datagrid" title="年检到期提醒" style="width:100%; height:448px;  " data-options="showHeader:true,striped:true,nowrap:false,singleSelect:true,collapsible:true,toolbar:toolbarAnnual">
		                        <thead>
			                        <tr>
				                        <th data-options="field:'name',width:115,halign:'center',align:'left'" >车组</th>
				                        <th data-options="field:'team',align:'left',halign:'center',width:130" >车牌号码</th>
				                        <%--<th data-options="field:'lasttime',align:'left',halign:'center',width:160" >上次年检时间</th>--%>
				                        <th data-options="field:'thistime',align:'left',halign:'center',width:160" >年检时间</th>
				                        <th data-options="field:'timesur',align:'left',halign:'center',width:130" >剩余天数</th>
				                    </tr>
		                        </thead>
	                        </table>
                        </div>
                        <div id="divLongTimeOff" style="width: 100%">
                            <table id="tableLongTimeOff" class="easyui-datagrid" title="长时间掉线提醒" style="width:100%; height:448px;  " data-options="showHeader:true,striped:true,nowrap:false,singleSelect:true,collapsible:true,toolbar:toolbarLongTimeOff">
		                        <thead>
			                        <tr>
				                        <th data-options="field:'name',width:115,halign:'center',align:'left'" >车组</th>
				                        <th data-options="field:'team',align:'left',halign:'center',width:130" >车牌号码</th>
				                        <th data-options="field:'time',align:'left',halign:'center',width:160" >最后在线时间</th>
				                        <th data-options="field:'offlinesetday',align:'left',halign:'center',width:160" >掉线阀值(天)</th>
				                        <th data-options="field:'offlineday',align:'left',halign:'center',width:130" >掉线天数(天)</th>
				                    </tr>
		                        </thead>
	                        </table>
                        </div>
                        <div id="divMileMaintain" style="width: 100%">
                            <table id="tableMileMaintain" class="easyui-datagrid" title="里程保养提醒" style="width:100%; height:448px;  " data-options="showHeader:true,striped:true,nowrap:false,singleSelect:true,collapsible:true">
		                        <thead>
			                        <tr>
				                        <th data-options="field:'name',width:115,halign:'center',align:'left'" >车组</th>
				                        <th data-options="field:'team',align:'left',halign:'center',width:130" >车牌号码</th>
				                        <th data-options="field:'time',align:'left',halign:'center',width:130" >时间</th>
				                        <th data-options="field:'mile',align:'left',halign:'center',width:130" >当前里程(公里)</th>
				                        <th data-options="field:'milesur',align:'left',halign:'center',width:130" >剩余保养里程(公里)</th>
				                        <th data-options="field:'milenext',align:'left',halign:'center',width:130" >下次保养里程(公里)</th>
				                        <%--<th data-options="field:'daysur',align:'left',halign:'center',width:100" >剩余天数</th>--%>
				                    </tr>
		                        </thead>
	                        </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div style="width: 95%; margin-left: 20px; height: 565px; border-left: 2px dotted #ccc">

                <div style="float: left; margin-top: 20px; width: 100%; height: 25px;">
                    <div id="vehMap" class="navRight" onclick="navTo(this)">2</div>
                    <h1 style="float: left; position: absolute; margin-left: 15px; font-size: 25px; font-weight: bold;">车辆分布图
                    </h1>
                    <div style="float: right; height: 13px; margin-left: 8px; border-bottom: 1px solid #ccc; width: 950px;"></div>

                </div>
                <div style="min-width: 95%; height: 500px; margin-top: 10px; float: left">
                    <div id="mapchart" style="min-width: 95%; height: 480px; margin-top: 10px; float: left; margin-left: 100px;">
                    </div>
                </div>

            </div>

            
            <div style="width: 95%; margin-left: 20px; height: 505px; border-left: 2px dotted #ccc">

                <div style="float: left; height: 25px; width: 100%;">
                    <div id="OnlineRate" class="navRight" onclick="navTo(this)">3</div>
                    <h1 style="float: left; position: absolute; margin-left: 15px; font-size: 25px; font-weight: bold;">车辆使用率 
                    </h1>
                    <div style="float: right; height: 13px; margin-left: 8px; border-bottom: 1px solid #ccc; width: 950px;"></div>

                    

                    
                </div>
                <div id="barchart" style="width: 98%; height: 480px; margin-top: 10px;">
                </div>
                
            </div>
        </div>
        <div style="width: 95%; margin-top: 20px;">
            <div id="divState" style="float:left; color: red;line-height: 23px;font-weight: bold;"></div>
            <label style="margin-left: 45%; width: 100px;">
                </label>
        </div>
    </div>

    
    <div onclick="$('body').animate({scrollTop:0},800);$('html').animate({scrollTop:0},800);" style="width: 28px; position: fixed; vertical-align: middle; text-align: center; background-color: #0074CC; vertical-align: baseline; right: 0; bottom: 10px; z-index: 99; height: 90px; border: 1px solid #ccc; cursor: pointer;">
        <img src="../EasyUI/themes/icons/top.png" style="margin: 5px 0 0 0;" alt="" />
        <div style="width: 25px; text-align: center;">
            <a style="color: White; text-align: center;">返</a>
            <a style="color: White; text-align: center;">回</a>
            <a style="color: White; text-align: center;">顶</a>
            <a style="color: White; text-align: center;">部</a>
        </div>
    </div>
</form>
</body>
    
    <link href="../Css/K/base2.css" rel="stylesheet" type="text/css" />
    <link href="../Css/K/style.css" rel="stylesheet" type="text/css" />
    <script src="../Js/echarts/www/js/echarts.js" type="text/javascript"></script>

    <script src="../Js/Common.js" type="text/javascript"></script>
    <script src="../Js/divResize.js" type="text/javascript"></script>
    <script src="../Js/jquery-migrate-1.1.1.js" type="text/javascript"></script>
    
    <script src="../Js/echarts/asset/js/esl/esl.js"></script>
    <script src="../Js/echarts/asset/js/codemirror.js"></script>
    <script src="../Js/echarts/asset/js/javascript.js"></script>
    <script src="../Js/echarts/placeholder.js"></script>
    
    
    <script type="text/javascript" src="../Js/K/jQueryScrollFix.js"></script>
    <script type="text/javascript" src="../Js/K/browser.js"></script>
    <script type="text/javascript">   
        function GotoBackEnd()
        {
            var sName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            sName = utf16to8(base64encode(sName));
            sPwd = utf16to8(base64encode(sPwd));
            window.open("../mng/Login.aspx?k=2&rUser=" + sName + "&rPwd=" + sPwd);        
        }
        
        var a1;
        var a2;
        var tabpanel;
        var isReload = false;       // 标识是否重新加载
        var timeout = 30000;        // 默认ajax超时时间为30秒
        var rate = new Array();

        var vehicleList = new Array();
        var groupList = new Array();
        var isCompletedFlex;
        var isCompletedServeTime;
        var isCompletedAnnual;
        var isCompletedLongTimeOff;
        var isCompletedMileMaintain;
        var isCompletedAlarm;
        var isCompletedAlarmListCount;
        var alarmListCount = new Array();
        var dataServeTime = new Array();
        var dataAnnual = new Array();
        var dataLongTimeOff = new Array();
        var dataMileMaintain = new Array();
        var dataAlarm = new Array();
        var dataOnline = new Array();
        var strAlarm = "";
        var tableServerTime;
        var tableAnnual;
        var tableLongTimeOff;
        var tableMileMaintain;
        var tableAlarm;
        var chart;
        var timeout = 30000;        // 默认ajax超时时间为30秒
        var user;
        var map;
        
        var iLongTimeOff = 3;
        var toolbarLongTimeOff = [{
			text: ''
		}];
		
        var toolbarServeTime = [{
			text: ''
		}];
		
		var toolbarAnnual = [{
			text: ''
		}]; 
        
        function SetLongTimeOffDay()
        {
              iLongTimeOff = parseInt($('#txtLongTimeOffDayNum').val());
              $("#btnItemLongTimeOff").click();
        }
        
        var iServerTime = 7;
        function SetServeTime()
        {
            iServerTime = parseInt($('#txtServeTimeNum').val());
            $("#btnItemServeTime").click();
        }
        
        var iAnnual = 7;
        function SetAnnual()
        {
            iAnnual = parseInt($('#txtAnnualNum').val());
            $("#btnItemAnnual").click();
        }
        
        $(document).ready(function() { 
            var toolbar = $('#divLongTimeOff').find('.datagrid-toolbar');
            toolbar.empty();
            toolbar.append('<table cellspacing="0" cellpadding="0"><tbody><tr><td><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">掉线阀值(天)：<input class="easyui-numberbox" id="txtAnnualNum" data-options="min:1,max:366,required:true" value="3" /></span><span class="l-btn-icon icon-edit">&nbsp;</span></span></a></td><td><a href="javascript:void(0)" onclick="SetLongTimeOffDay()" class="l-btn l-btn-small l-btn-plain" group="" id="btnLongTimeOff"><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">筛选</span><span class="l-btn-icon icon-search">&nbsp;</span></span></td></tr></tbody></table>');
              
            toolbar = $('#divServeTime').find('.datagrid-toolbar');
            toolbar.empty();
            toolbar.append('<table cellspacing="0" cellpadding="0"><tbody><tr><td><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">服务到期提前：<input class="easyui-numberbox" id="txtServeTimeNum" data-options="min:1,max:366,required:true" value="7" /> 天提醒</span><span class="l-btn-icon icon-edit">&nbsp;</span></span></a></td><td><a href="javascript:void(0)" onclick="SetServeTime()" class="l-btn l-btn-small l-btn-plain" group="" id="btnLongTimeOff"><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">筛选</span><span class="l-btn-icon icon-search">&nbsp;</span></span></td></tr></tbody></table>');
              
            toolbar = $('#divAnnual').find('.datagrid-toolbar');
            toolbar.empty();
            toolbar.append('<table cellspacing="0" cellpadding="0"><tbody><tr><td><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">保险到期提前：<input class="easyui-numberbox" id="txtAnnualNum" data-options="min:1,max:366,required:true" value="7" /> 天提醒</span><span class="l-btn-icon icon-edit">&nbsp;</span></span></a></td><td><a href="javascript:void(0)" onclick="SetAnnual()" class="l-btn l-btn-small l-btn-plain" group="" id="btnLongTimeOff"><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">筛选</span><span class="l-btn-icon icon-search">&nbsp;</span></span></td></tr></tbody></table>');
               
        });

        // 判断数据加载完毕并关闭遮挡效果
        var loadCompleted = function () {
//            getOnlineRate();
            barChart.showLoading({
                text: "数据加载中...",
                effect: "whirling",
                textStyle: {
                    fontSize: 20
                }
            });

        }
        // ajax加载数据回传方法
        var AlarmListCountCallBack = function (isTimeout, alarmListCount) {
            
        }
        var ServeTimeCallBack = function (isTimeout, dataList) {
            
        }
        var AnnualCallBack = function (isTimeout, dataList) {
            
        }
        var MileMaintainCallBack = function (isTimeout, dataList) {

            
        }
        var LongTimeOffCallBack = function (isTimeout, dataList) {
            
        }
        //每次清空table 
        function clearTable() {
//            $('#tableServeTime').datagrid('loadData', { total: 0, rows: [] });
//            $('#tableAnnual').datagrid('loadData', { total: 0, rows: [] });
//            $('#tableLongTimeOff').datagrid('loadData', { total: 0, rows: [] });
//            $('#tableMileMaintain').datagrid('loadData', { total: 0, rows: [] });  
            var item = $('#tableServeTime').datagrid('getRows');    
             for (var i = item.length - 1; i >= 0; i--) {    
                 var index = $('#tableServeTime').datagrid('getRowIndex', item[i]);    
                 $('#tableServeTime').datagrid('deleteRow', index);    
             }    
             
            var item = $('#tableLongTimeOff').datagrid('getRows');    
             for (var i = item.length - 1; i >= 0; i--) {    
                 var index = $('#tableLongTimeOff').datagrid('getRowIndex', item[i]);    
                 $('#tableLongTimeOff').datagrid('deleteRow', index);    
             }    
             
            var item = $('#tableAnnual').datagrid('getRows');    
             for (var i = item.length - 1; i >= 0; i--) {    
                 var index = $('#tableAnnual').datagrid('getRowIndex', item[i]);    
                 $('#tableAnnual').datagrid('deleteRow', index);    
             }    
             
            var item = $('#tableMileMaintain').datagrid('getRows');    
             for (var i = item.length - 1; i >= 0; i--) {    
                 var index = $('#tableMileMaintain').datagrid('getRowIndex', item[i]);    
                 $('#tableMileMaintain').datagrid('deleteRow', index);    
             }           
        }
        function getalarm() {


        }

        //获取地图上的车辆数据
        var adds = new Array();
        var mapdataList = new Array();
        var mapaddXY = new Array();
        var iAddIndex = 0;
        var myGeo;
        var mapProvince = new Array();        
        function getMapData() {
//            var myDate = new Date();
//            var eDate = formatterTime(myDate);
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            $.ajax({
                url: "../Ashx/Province.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                async:true, 
                data:{username:sUserName,Pwd:sPwd,DoType:1},
                success:function(data){
                        if(data.result == "true")
                        {
                            if(data.data.length > 0)
                            {
                                 mapProvince = data.data;
                            }
                        }
                        else
                        {
//	                           $("#divState").text(GetErr(data.err));
                        }
                        getMapDataFromMap();
                },
                error: function(e) { 
	                 $("#divState").text(e.responseText);
	                 getMapDataFromMap();
                } 
            }) ;   
        }
        
        var oldProvince = new Array();
        function getMapDataFromMap() {
            iAddIndex = 0;
            if(jsonVehs == undefined || jsonVehs.length == 0)
            {
                myChart2.hideLoading();
                loadMap([], [], []);
                return;
            }
            else
            {
                myGeo = new BMap.Geocoder();
                adds = new Array();
                oldProvince = new Array();
                $.each(jsonVehs,function(i,value)
                {
                    if(value["lng"] != undefined && value["lat"] != undefined)
                    {
                        if(value["lng"] == 0 && value["lat"] == 0)
                        {
                            return true;
                        }
                        var baiduXY = CheckXYGpsToBaidu(value["lng"], value["lat"]);
                        var x = baiduXY[0].lng;
                        var y = baiduXY[0].lat;
                        adds.push(new BMap.Point(x,y));
                        oldProvince.push({"VehID":value.id,"GID":value.GID});
                    }
                });
//	            adds = [
//		            new BMap.Point(116.307852,40.057031),
//		            new BMap.Point(114.0402,22.6502)
//	            ];
	            if(adds.length > 0)
	            {
	                bdGEO();
	            }
            }
        }
        
        function AddToMap()
        {
            try
            {
                var dataList = mapdataList;
                var Mapdata = new Array();
                var rightData = new Array();
                var otherValue = 0;
                for (var i = 0; i < dataList.length; i++) {
                    var obj = new Object();
                    if (dataList[i].Province.indexOf("新疆") >= 0) { obj.name = "新疆"; }
                    else if (dataList[i].Province.indexOf("西藏") >= 0) { obj.name = "西藏"; }
                    else if (dataList[i].Province.indexOf("内蒙古") >= 0) { obj.name = "内蒙古"; }
                    else if (dataList[i].Province.indexOf("广西") >= 0) { obj.name = "广西"; }
                    else if (dataList[i].Province.indexOf("宁夏") >= 0) { obj.name = "宁夏"; }
                    else {
                        obj.name = dataList[i].Province.replace("省", "").replace("市", "");
                    }
                    obj.value = Math.round(dataList[i].Count);
                    Mapdata.push(obj);
                    //data += "{ name:'" + dataList[i].Province.replace("省", "").replace("自治区", "").replace("壮族", "") + "',value:" + Math.round(dataList[i].Count) + "},"
                }
                //如果大于二十个省，则将数据从大到小排列，排名小于20的省合并为其他
                if (Mapdata.length > 10) {
                    var newData = new Array();//重新排序后的data
                    var count = Mapdata.length;
                    while (count > 0) {
                        var maxData = 0;
                        var index = 0;
                        var obj = Mapdata[0];
                        //每次循环找到最大的值，插入新数组，然后删除最大的项。
                        for (var i = 0; i < Mapdata.length; i++) {
                            if (maxData < Mapdata[i].value) {//如果最大值比当前值小，则将当前项记为最大项
                                maxData = Mapdata[i].value;
                                index = i;
                                obj = Mapdata[i];
                            }
                        }
                        newData.push(obj);//新数组中插入最大项
                        Mapdata.splice(index, 1);//删除原数组中的最大项
                        count--;
                    }
                    //直到数组中数据全部清空，则排序完毕，
                    Mapdata = newData;//将排序好的数据重新插入数组
                    //新得的数组取前二十项插入右边数组，后面剩下的项合并为其他
                    var otherData = 0;
                    for (var i = 0; i < Mapdata.length; i++) {
                        if (i < 10) {
                            rightData.push(Mapdata[i]);
                        }
                        else {
                            otherData += Mapdata[i].value;
                        }
                    }
                    if (otherData != 0) {//如果存在其他数据
                        var obj = new Object();
                        obj.name = "其他";
                        obj.value = otherData;
                        rightData.push(obj);

                    }
                }
                else {
                    rightData = Mapdata;
                }
                loadMap(dataList, Mapdata, rightData);
            }
            catch(e)
            {}
        }
        
        function GetShortDistance(lon1, lat1, lon2, lat2)
        {
            var  DEF_PI = 3.14159265359; // PI
            var DEF_2PI= 6.28318530712; // 2*PI
            var DEF_PI180= 0.01745329252; // PI/180.0
            var DEF_R =6370693.5; // radius of earth
            var ew1, ns1, ew2, ns2;
            var dx, dy, dew;
            var distance;
            // 角度转换为弧度
            ew1 = lon1 * DEF_PI180;
            ns1 = lat1 * DEF_PI180;
            ew2 = lon2 * DEF_PI180;
            ns2 = lat2 * DEF_PI180;
            // 经度差
            dew = ew1 - ew2;
            // 若跨东经和西经180 度，进行调整
            if (dew > DEF_PI)
            dew = DEF_2PI - dew;
            else if (dew < -DEF_PI)
            dew = DEF_2PI + dew;
            dx = DEF_R * Math.cos(ns1) * dew; // 东西方向长度(在纬度圈上的投影长度)
            dy = DEF_R * (ns1 - ns2); // 南北方向长度(在经度圈上的投影长度)
            // 勾股定理求斜边长
            distance = Math.sqrt(dx * dx + dy * dy);
            return distance;
        }
        
        function bdGEO(){	
		    if(iAddIndex < adds.length){
			    
		    }
		    else
		    {
		        //地址获取完成
		        AddToMap();
		        return;
		    }
		    var pt = adds[iAddIndex];
		    var bExitst = false;
		    $.each(mapaddXY,function(i,value)
		    {
		        try
		        {
		            var iD = GetShortDistance(value.x,value.y,pt.lng,pt.lat);
		            if(iD < 5000)
		            {
		                bExitst = true;
		                var iFindType = 0;// 0没找到，1找到省，2找到市
			            $.each(mapdataList,function(i,value2)
			            {
			                if(value2.Province == value.p)
			                {
			                    iFindType = 1;
			                    $.each(value2.CityList,function(j,value3)
			                    {
			                        if(value3.City == value.c)
			                        {
			                            iFindType = 2;
			                            value3.Count = value3.Count + 1;
			                            value2.Count = value2.Count + 1;
			                            return false;
			                        }
			                    });
			                    if(iFindType == 1)
			                    {
			                        var row = {"City":value.c,"Count":1};
			                        value2.CityList.push(row);
			                        value2.Count = value2.Count + 1;
			                    }
			                    return false;
			                }
			            });
			            if(iFindType == 0) //省市都没
			            {
			                var row= {"Province":value.p,"CityList":[{"City":value.c,"Count":1}],"Count":1};
			                mapdataList.push(row);
			            }
		                return false;
		            }
		        }
		        catch(e)
		        {}
		    });
		    if(bExitst)
		    {
		        iAddIndex++;
		        bdGEO();
		        return;
		    }
		    else
		    {
		        if(!getProvinceFirst())
		        {
		            geocodeSearch(pt);
		        }
		        else
		        {
		            bdGEO();
		        }
		    }
	    }
	    
	    function SaveProvince(province,city,id,gid) {
//            var myDate = new Date();
//            var eDate = formatterTime(myDate);
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            $.ajax({
                url: "../Ashx/Province.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                async:true, 
                data:{username:sUserName,Pwd:sPwd,DoType:2,P:province,C:city,VehID:id,GID:gid},
                success:function(data){
                        if(data.result == "true")
                        {
                            
                        }
                        else
                        {
//	                           $("#divState").text(GetErr(data.err));
                        }
                },
                error: function(e) { 
                
                } 
            }) ;   
        }
	    
	    function getProvinceFirst()
	    {
	        try
	        {
	            var bExist = false;
	            var rowP = undefined;
	            $.each(mapProvince,function(i,value)
	            {
	                if("V" + value.VehID == oldProvince[iAddIndex].VehID)
	                {
	                    bExist = true;
	                    rowP = value;
	                    return false;
	                }
	            });
	            if(!bExist)
	            {
	                return false;
	            }
		        iAddIndex++;
	            var iFindType = 0;// 0没找到，1找到省，2找到市
			    $.each(mapdataList,function(i,value)
			    {
			        if(value.Province == rowP.Province)
			        {
			            iFindType = 1;
			            $.each(value.CityList,function(j,value2)
			            {
			                if(value2.City == rowP.City)
			                {
			                    iFindType = 2;
			                    value2.Count = value2.Count + 1;
			                    value.Count = value.Count + 1;
			                    return false;
			                }
			            });
			            if(iFindType == 1)
			            {
			                var row = {"City":rowP.City,"Count":1};
			                value.Count = value.Count + 1;
			                value.CityList.push(row);
			            }
			            return false;
			        }
			    });
			    if(iFindType == 0) //省市都没
			    {
			        var row= {"Province":rowP.Province,"CityList":[{"City":rowP.City,"Count":1}],"Count":1};
			        mapdataList.push(row);
			    }
	            return bExist;
	        }
	        catch(e)
	        {
	            return false;
	        }
	    }
	    
	    function geocodeSearch(pt){
		    try
		    { 
		        myGeo.getLocation(pt, function(rs){
			        var addComp = rs.addressComponents;
			        var iFindType = 0;// 0没找到，1找到省，2找到市
			        SaveProvince(addComp.province,addComp.city,oldProvince[iAddIndex].VehID,oldProvince[iAddIndex].GID);
			        $.each(mapdataList,function(i,value)
			        {
			            if(value.Province == addComp.province)
			            {
			                iFindType = 1;
			                $.each(value.CityList,function(j,value2)
			                {
			                    if(value2.City == addComp.city)
			                    {
			                        iFindType = 2;
			                        value2.Count = value2.Count + 1;
			                        value.Count = value.Count + 1;
			                        return false;
			                    }
			                });
			                if(iFindType == 1)
			                {
			                    var row = {"City":addComp.city,"Count":1};
			                    value.Count = value.Count + 1;
			                    value.CityList.push(row);
			                }
			                return false;
			            }
			        });
			        if(iFindType == 0) //省市都没
			        {
			            var row= {"Province":addComp.province,"CityList":[{"City":addComp.city,"Count":1}],"Count":1};
			            mapdataList.push(row);
			        }
			        mapaddXY.push({"x":adds[iAddIndex].lng,"y":adds[iAddIndex].lat,"p":addComp.province,"c":addComp.city});
		            iAddIndex++;
			        setTimeout(window.bdGEO,1);
			    });
		    }
		    catch(e)
		    {
		        iAddIndex++;
		        setTimeout(window.bdGEO,1);
		    }
	    }
	
        //获取在线率
        function getOnlineRate() {
//            barChart = echarts.init(document.getElementById('barchart'));
//            barChart.showLoading({
//                text: "数据加载中...",
//                effect: "whirling",
//                textStyle: {
//                    fontSize: 20
//                }
//            });
            //火狐不兼容问题（界面变形）
            $("#barchart div").css("position", "absolute");
            var myDate = new Date();
            var eDate = formatterTime(myDate);
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            $.ajax({
                url: "../Ashx/VehicleUsage.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                async:true, 
                data:{username:sUserName,Pwd:sPwd,time:eDate},
                success:function(data){
                        if(data.result == "true")
                        {
                              $.each(data.data,function(i,value)
                              {
                                value["Sum"] = jsonVehs.length;
                                if(value.Value > jsonVehs.length)
                                {
                                    value.Value = jsonVehs.length;
                                }
                                value["ErrorCode"] = "";
                              });
                              var iCount = 0;
                              $.each(jsonVehs,function(i,value)
                              {
                                if(value["time"] == undefined)
                                {
                                    return true;
                                }
                                var sVehTime = value["time"].replace(/-/g,"/");
                                var vehdate = new Date(sVehTime);
                                if(myDate.getFullYear() == vehdate.getFullYear() && myDate.getMonth() && myDate.getDate() == vehdate.getDate())
                                {
                                    iCount = iCount + 1;
                                }
                              });
                              if(iCount > jsonVehs.length)
                                {
                                    iCount = jsonVehs.length;
                                }
                              var sDate = myDate.getFullYear() + "-" + (myDate.getMonth() + 1) + "-" + myDate.getDate()
                              var row = {"Date": sDate, "Value": iCount, "Sum":jsonVehs.length, "ErrorCode":""}
                              data.data.push(row);
                              if(data.data.length == 0)
                              {
                                OnlineRateCallBack(true,data.data);
                              }
                              else
                              {
                                OnlineRateCallBack(false,data.data);
                              }
//                              $("#tableVehDetail").datagrid('loadData',data.data);
                        }
                        else
                        {
//	                           $("#divState").text(GetErr(data.err));
                        }
                },
                error: function(e) { 
	                 $("#divState").text(e.responseText);
                } 
            }) ;   
            return;
            var datalist = new Array();
            //Value使用的车辆，Sum总共多少车辆
            var row = {"Date":"2016-12-06","Sum":3,"Value":3,"ErrorCode":""};
            datalist.push(row);
            row = {"Date":"2016-12-07","Sum":3,"Value":2,"ErrorCode":""};
            datalist.push(row);
            row = {"Date":"2016-12-08","Sum":2,"Value":1,"ErrorCode":""};
            datalist.push(row);
            row = {"Date":"2016-12-09","Sum":2,"Value":1,"ErrorCode":""};
            datalist.push(row);
            row = {"Date":"2016-12-10","Sum":2,"Value":1,"ErrorCode":""};
            datalist.push(row);
//            row = {"Date":"2016-12-11","Sum":2,"Value":1,"ErrorCode":""};
//            datalist.push(row);
//            row = {"Date":"2016-12-12","Sum":2,"Value":1,"ErrorCode":""};
//            datalist.push(row);
            OnlineRateCallBack(false,datalist);
//            getData(url, alarmListCount, 0, timeout, OnlineRateCallBack);
        }
        
        function success_VehUsageCallback(data)
        {
        alert(data);
        }
        
        //获取运行状况
        function getRunState() {
            var date = new Date();
            var today = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            //var user = $.parseJSON(localStorage.getItem("User"));
            var url = "/v1/RunState?";
            url += "&uid=" + user.Uid;
            url += "&token=" + user.Token;
            url += "&date=" + today;
//            getData(url, alarmListCount, 0, timeout, runStateCallBack);
        }
        //位置数据获取后回调
        function LocationCallBack(istimeout, dataList) {
            if (dataList.length == 0) {  // 没有数据时清理数据
                //MessageBox("没有数据", '提示');
                myChart2.hideLoading();
                loadMap([], [], []);
                return;
            }
            else if (dataList.length == 1 && dataList[0].ErrorCode != undefined && dataList[0].ErrorCode != null) {  // 没有数据时清理数据
               // MessageBox(dataList[0].Detail, '提示');
                myChart2.hideLoading();
                return;
            }
            else {
                //var dat   a = eval(dataList);
                var Mapdata = new Array();
                var rightData = new Array();
                var otherValue = 0;
                for (var i = 0; i < dataList.length; i++) {
                    var obj = new Object();
                    if (dataList[i].Province.indexOf("新疆") >= 0) { obj.name = "新疆"; }
                    else if (dataList[i].Province.indexOf("西藏") >= 0) { obj.name = "西藏"; }
                    else if (dataList[i].Province.indexOf("内蒙古") >= 0) { obj.name = "内蒙古"; }
                    else if (dataList[i].Province.indexOf("广西") >= 0) { obj.name = "广西"; }
                    else if (dataList[i].Province.indexOf("宁夏") >= 0) { obj.name = "宁夏"; }
                    else {
                        obj.name = dataList[i].Province.replace("省", "").replace("市", "");
                    }
                    obj.value = Math.round(dataList[i].Count);
                    Mapdata.push(obj);
                    //data += "{ name:'" + dataList[i].Province.replace("省", "").replace("自治区", "").replace("壮族", "") + "',value:" + Math.round(dataList[i].Count) + "},"
                }
                //如果大于二十个省，则将数据从大到小排列，排名小于20的省合并为其他
                if (Mapdata.length > 10) {
                    var newData = new Array();//重新排序后的data
                    var count = Mapdata.length;
                    while (count > 0) {
                        var maxData = 0;
                        var index = 0;
                        var obj = Mapdata[0];
                        //每次循环找到最大的值，插入新数组，然后删除最大的项。
                        for (var i = 0; i < Mapdata.length; i++) {
                            if (maxData < Mapdata[i].value) {//如果最大值比当前值小，则将当前项记为最大项
                                maxData = Mapdata[i].value;
                                index = i;
                                obj = Mapdata[i];
                            }
                        }
                        newData.push(obj);//新数组中插入最大项
                        Mapdata.splice(index, 1);//删除原数组中的最大项
                        count--;
                    }
                    //直到数组中数据全部清空，则排序完毕，
                    Mapdata = newData;//将排序好的数据重新插入数组
                    //新得的数组取前二十项插入右边数组，后面剩下的项合并为其他
                    var otherData = 0;
                    for (var i = 0; i < Mapdata.length; i++) {
                        if (i < 10) {
                            rightData.push(Mapdata[i]);
                        }
                        else {
                            otherData += Mapdata[i].value;
                        }
                    }
                    if (otherData != 0) {//如果存在其他数据
                        var obj = new Object();
                        obj.name = "其他";
                        obj.value = otherData;
                        rightData.push(obj);

                    }
                }
                else {
                    rightData = Mapdata;
                }
                loadMap(dataList, Mapdata, rightData);
            }
        }
        //加载地图数据
        var barChart;
        //加载在线率图表
        function loadOnlineRate(timeArr, data, sumData, datalist) {

            option2 = {
                tooltip: {
                    trigger: 'axis',
                    //formatter: "{a} <br/>{b}<br/> 在线{c}<br/>离线 {d}"
                    //formatter: function (a, b, c) {

                    //}
                },
                //dataZoom: {
                //    show: true,
                //    realtime: true,
                //    start: 0,
                //    end: 100
                //},
                color: [

                    "#6495ED",
                     "#cccccc"

                ],
                normal: {
                    itemStyle: {
                        color: '#000'
                    }
                },
                xAxis: [
                     {

                         type: 'category',
                         data: timeArr
                     }
                ],
                calculable: true,
                yAxis: [
                    {
                        splitArea: { show: true },
                        position: "right",
                        type: 'value'
                    }
                ],
                series: [{
                    name: '使用车辆',
                    type: 'bar',
                    barGap: "50%",
                    stack: 'sum',
                    barCategoryGap: "70%",
                    itemStyle: {
                        normal: {
                            label: {
                                show: true, position: 'insideTop',
                                formatter: function (a, b, c) {
                                    b = a.name;
                                    c = a.value;
                                    var count = parseInt(c);//车辆数
                                    var total = c;
                                    $.each(datalist,function(d1,dvalue)
                                    {
                                        if(dvalue.Date == b)
                                        {
                                            total = dvalue.Sum;
                                        }
                                    });
//                                    var total = 10;//$.parseJSON(localStorage.getItem("vehicleList")).length;
                                    if(total == 0)
                                    {
                                        return "0%";
                                    }
                                    return (count / total * 100).toFixed(1) + "%";
                                }
                            }
                        }
                    },
                    data: data
                },
                {
                    name: '未使用车辆',
                    type: 'bar',
                    stack: 'sum',
                    //itemStyle: {
                    //    normal: {
                    //        label: {
                    //            show: true, position: 'insideTop',
                    //            textStyle: {
                    //                color: 'black'
                    //            }
                    //        }
                    //    }
                    //},
                    data: sumData

                }]
            }

            barChart.hideLoading();
            barChart.setOption(option2, true);
        }
        //加载地图图表
        function loadMap(datalist, Mapdata, rightData) {
            option = {
                tooltip: {
                    trigger: 'item',
                    formatter: "{b} : {c}"
                },
                dataRange: {
                    x: -10,
                    y: -500,
                    min: 0,
                    max: 2000,
                    color: ['orangered', 'yellow', 'lightskyblue']
                },
                series: [
                    {
                        name: '中国',
                        type: 'map',
                        mapType: 'china',
                        selectedMode: 'single',
                        mapLocation: {
                            x: 'left'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{b} : {c} "
                        },
                        itemStyle: {
                            normal: { label: { show: true } },
                            emphasis: { label: { show: true } }
                        },
                        data: Mapdata
                        //data: [
                        //    { name: '广东', value: Math.round(500), selected: false },
                        //    { name: '河北省', value: Math.round(100), selected: false }
                        //]
                    },
                    {
                        name: '车辆分布比',
                        type: 'pie',
                        //roseType: 'radius',
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c} ({d}%)"
                        },
                        itemStyle : {
                            normal : {
                                label : {
                                    position : 'inner',
                                    formatter : function (params) {                         
                                      return params.name + "：" + (params.percent - 0).toFixed(0) + '%'
                                    }
                                },
                                labelLine : {
                                    show : false
                                }
                            },
                            emphasis : {
                                label : {
                                    show : true,
                                    formatter : "{b}\n{d}%"
                                }
                            }
                            
                        },
                        center: [document.getElementById('mapchart').offsetWidth - 250, 320],
                        radius: 120,
                        data: rightData
                    }
                ]
            }
            myChart2.hideLoading();
            myChart2.setOption(option, true);
            var ecConfig = require('echarts/config');
            myChart2.on(ecConfig.EVENT.MAP_SELECTED, function (param) {

                option = myChart2.getOption();
                var mapType = [
                  '中国',
                    // 23个省
                  '广东', '青海', '四川', '海南', '陕西',
                  '甘肃', '云南', '湖南', '湖北', '黑龙江',
                  '贵州', '山东', '江西', '河南', '河北',
                  '山西', '安徽', '福建', '浙江', '江苏',
                  '吉林', '辽宁', '台湾',
                    // 5个自治区
                  '新疆', '广西', '宁夏', '内蒙古', '西藏',
                    // 4个直辖市
                  '北京', '天津', '上海', '重庆',
                    // 2个特别行政区
                  '香港', '澳门'
                ];
                var selected = param.selected;
                var selectedProvince;
                var name;
                var selectData = new Array();
                for (var i = 0, l = option.series[0].data.length; i < l; i++) {
                    name = option.series[0].data[i].name;
                    option.series[0].data[i].selected = selected[name];
                    if (selected[name]) {
                        selectedProvince = name;
                    }
                }
                for (var i = 0; i < datalist.length; i++) {
                    if (datalist[i].Province.indexOf(selectedProvince) >= 0) {
                        for (var j = 0; j < datalist[i].CityList.length; j++) {
                            var obj = new Object();
                            obj.name = datalist[i].CityList[j].City;
                            obj.value = datalist[i].CityList[j].Count;
                            selectData.push(obj);

                        }

                    }
                }
                if (typeof selectedProvince == 'undefined' || mapType.indexOf(selectedProvince) < 0) {
                    option.series = [{
                        name: '中国',
                        type: 'map',
                        mapType: 'china',
                        selectedMode: 'single',
                        mapLocation: {
                            x: 'left'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{b} : {c}"
                        },
                        itemStyle: {
                            normal: { label: { show: true } },
                            emphasis: { label: { show: true } }
                        },
                        data: Mapdata
                        //data: [
                        //    { name: '广东', value: Math.round(500), selected: false }, 
                        //    { name: '河北', value: Math.round(500), selected: false }
                        //]
                    },
                    {
                        name: '车辆分布比',
                        type: 'pie',
                        //roseType: 'area',
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c} ({d}%)"
                        },
                        itemStyle : {
                            normal : {
                                label : {
                                    position : 'inner',
                                    formatter : function (params) {                         
                                      return params.name + "：" + (params.percent - 0).toFixed(0) + '%'
                                    }
                                },
                                labelLine : {
                                    show : false
                                }
                            },
                            emphasis : {
                                label : {
                                    show : true,
                                    formatter : "{b}\n{d}%"
                                }
                            }
                            
                        },
                        center: [document.getElementById('mapchart').offsetWidth - 250, 320],
                        radius: 100,
                        data: rightData
                    }
                    ]
                    //  option.series.splice(1);
                    myChart2.setOption(option, true);
                    return;
                }

                option.series[0] = {
                    name: selectedProvince,
                    type: 'map',
                    mapType: selectedProvince,
                    selectedMode: 'single',
                    mapLocation: {
                        x: 'left'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{b} : {c}"
                    },
                    itemStyle: {
                        normal: { label: { show: true } },
                        emphasis: { label: { show: true } }
                    },
                    data: selectData
                    //data: [
                    //    { name: '深圳市', value: Math.round(500), selected: true }
                    //]
                }
                option.series[1] =
                  {
                      name: '车辆分布比',
                      type: 'pie',
                      //roseType: 'area',
                      tooltip: {
                          trigger: 'item',
                          formatter: "{a} <br/>{b} : {c} ({d}%)"
                      },
                      itemStyle : {
                          normal : {
                              label : {
                                  position : 'inner',
                                  formatter : function (params) {                         
                                    return params.name + "：" + (params.percent - 0).toFixed(0) + '%'
                                  }
                              },
                              labelLine : {
                                  show : false
                              }
                          },
                          emphasis : {
                              label : {
                                  show : true,
                                  formatter : "{b}\n{d}%"
                              }
                          }
                          
                      },
                      center: [document.getElementById('mapchart').offsetWidth - 250, 320],
                      radius: [30, 120],
                      data: selectData
                  }

                //option.series.splice(1);
                myChart2.setOption(option, true);

            });
        }
        var myChart2;
        function initMap() {
            require.config({
                paths: {
                    echarts: '../Js/echarts/www/js'
                }
            });

            require(
                [
                    'echarts',
                    'echarts/chart/bar',
                    'echarts/chart/pie',
                    'echarts/chart/line',
                    'echarts/chart/map'
                ],
                function (ec) {
                    //--图表--
                    barChart = ec.init(document.getElementById('barchart'));
                    loadCompleted();
                    // --- 地图 ---
                    myChart2 = ec.init(document.getElementById('mapchart'));
                    myChart2.showLoading({
                        text: "数据加载中...",
                        effect: "whirling",
                        textStyle: {
                            fontSize: 20
                        }
                    });
//                    getMapData();
                }
            );

        }

        // 加载类型比例报表
        function loadTypeRate() {
            var seriesData = new Array();
            $.each(window.parent.rate, function (index, item) {
                var seriesDataItem = new Array();
                seriesDataItem.push(item.type);
                seriesDataItem.push(parseFloat(item.rate));
                seriesData.push(seriesDataItem);
            });
            $('#container').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                credits: {
                    enabled: false        // 屏蔽官网链接
                },
                title: {
                    text: "类型比例图"
                },
                tooltip: {
                    pointFormat: "{series.name}: <b>{point.percentage:.1f}%</b>",
                    lable: {
                        enabled: false
                    }
                },
                legend: {
                    enabled: true
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: "pointer",
                        dataLabels: {
                            enabled: false,
                            color: "#000000",
                            connectorColor: "#000000",
                            format: "<b>{point.name}</b>: {point.percentage:.1f} %"
                        },
                        showInLegend: true
                    }
                },
                exporting: {
                    buttons: {
                        contextButton: {
                            contextButtonTitle: "",
                            symbol: null,    // 设置导出按钮样式
                            onclick: function () {   // 导出按钮点击事件，这里需要服务端处理，后期尝试处理为鼠标滑过显示略缩图，点击下载
                                this.exportChart();
                            },
                            text: "导出图片"
                        }
                    }
                },
                series: [{
                    type: "pie",
                    name: "百分比",
                    data: seriesData
                }]
            });
        }
        //在线率数据获取后回调
        function OnlineRateCallBack(istimeout, datalist) {
            if (datalist.length == 1 && datalist[0].ErrorCode != undefined && datalist[0].ErrorCode != null) {  // 没有数据时清理数据
                //MessageBox(datalist[0].Detail, '提示');
                barChart.hideLoading();
                return;
            }
            else {
                var data = new Array();
                var timeArr = new Array();
                var sumData = new Array();
                for (var i = 0; i < 7 - datalist.length; i++) {
                    if (datalist.length > 0) {
                        var arr = datalist[datalist.length - 1].Date.split("-");
                        var date = new Date(arr[0], arr[1] - 1, arr[2]);
                        var aheadDays = 7 - i - 1;

                        var d = dateAdd(-aheadDays, date);
                        data.push(0);
//                        sumData.push(datalist[0].Sum - 0);
                        sumData.push(0);//datalist[0].Sum - 0);
                        timeArr.push(d);
                    }
                    else {
                        var date = new Date();
                        var aheadDays = 7 - i - 1;
                        var d = dateAdd(-aheadDays, date);
                        data.push(0);
                        sumData.push(0);
                        timeArr.push(d);
                    }
                }
                for (var i = 0; i < datalist.length; i++) {
                    data.push(datalist[i].Value);
                    sumData.push(datalist[i].Sum - datalist[i].Value);
                    timeArr.push(datalist[i].Date);
                }
                loadOnlineRate(timeArr, data, sumData, datalist);
            }
        }
        //今日运行状况数据获取后回调
        function runStateCallBack(istimeout, datalist) {
            if (datalist.length == 0) {  // 没有数据时清理数据
                //MessageBox("没有数据", '提示');
                myChart3.hideLoading();
                return;
            }
            else if (datalist.length == 1 && datalist[0].ErrorCode != undefined && datalist[0].ErrorCode != null) {  // 没有数据时清理数据
                //MessageBox(datalist[0].Detail, '提示');
                myChart3.hideLoading();
                return;
            }
            else {
                var mileData = new Array();//里程数据
                var timeData = new Array();//时间数据
                var runStateData = new Array();//工作时长数据
                var dateData = new Array();//日期数据
                var workHour = 0;//所有工作时长
                var maxMile = 0;
                var maxTime = 0;
                var vehCount = $.parseJSON(localStorage.getItem("vehicleList")).length;//获取所有车辆数
                for (var i = 0; i < datalist.length; i++) {
                    if (maxMile == 0) {
                        maxMile = datalist[i].RunMileage;
                    }
                    else {
                        if (maxMile < datalist[i].RunMileage) {
                            maxMile = datalist[i].RunMileage;
                        }
                    }
                    if (maxTime == 0) {
                        maxTime = datalist[i].WorkHour;
                    }
                    else {
                        if (maxTime < datalist[i].WorkHour) {
                            maxTime = datalist[i].WorkHour;
                        }
                    }
                    mileData.push(datalist[i].RunMileage);
                    timeData.push(datalist[i].WorkHour);
                    dateData.push(datalist[i].Date.split(" ")[0]);
                    workHour += datalist[i].WorkHour;
                }
                var obj = new Object();
                obj.value = workHour;
                obj.name = "运行";
                runStateData.push(obj);
                obj = new Object();
                obj.value = 7 * 24 * vehCount - workHour;
                obj.name = "停运";
                runStateData.push(obj);
                loadShiyonglv(mileData, timeData, runStateData, dateData, maxTime * 1.7, maxMile * 1.7);
            }
        }

        var getGroupList = function (isTimeout, groupList) {
            if (isTimeout == true) {
                //MessageBox("网络超时，数据未加载完整", '提示');
            }
            if (groupList.length == 0) {  // 没有数据时清理数据
                //MessageBox("没有数据", '提示');
                asyncbox.alert("没有车组数据，自动跳转后台管理", "提示", function (action) {
                    if (action == "ok") {
                        window.location.href = "VehicleMgr/Login.aspx";
                    }
                });
                return;
            }
            else if (groupList.length == 1 && groupList[0].ErrorCode != undefined && groupList[0].ErrorCode != null) {  // 没有数据时清理数据
                //MessageBox(groupList[0].Detail, '提示');
                return;
            }
            else {
                localStorage.setItem("groupList", JSON.stringify(groupList));
                window.isCompletedGroup = true;
                loadCompleted(); // 判断是否加载完成
            }
        }
        var getVehicleList = function (isTimeout, vehicleList) {
            if (isTimeout == true) {
                //MessageBox("网络超时，数据未加载完整", '提示');
            }
            if (vehicleList.length == 0) {  // 没有数据时清理数据
                asyncbox.alert("没有车辆数据，自动跳转后台管理", "提示", function (action) {
                    if (action == "ok") {
                        window.location.href = "VehicleMgr/Login.aspx";
                    }
                });



                //MessageBox("没有数据", '提示');
                return;
            }
            else if (vehicleList.length == 1 && vehicleList[0].ErrorCode != undefined && vehicleList[0].ErrorCode != null) {  // 没有数据时清理数据
                //MessageBox(vehicleList[0].Detail, '提示');
                return;
            }
            else {
                localStorage.setItem("vehicleList", JSON.stringify(vehicleList));
                window.isCompletedVehicle = true;
                loadCompleted(); // 判断是否加载完成
            }
        }


        var jsonVehGroup;
        var jsonVehs;

        $(function () {
             //loadMap();
             //页面resize的时候

             //数组indexOf
             if (!Array.prototype.indexOf) {
                 Array.prototype.indexOf = function (elt /*, from*/) {
                     var len = this.length >>> 0;
                     var from = Number(arguments[1]) || 0;
                     from = (from < 0)
                          ? Math.ceil(from)
                          : Math.floor(from);
                     if (from < 0)
                         from += len;
                     for (; from < len; from++) {
                         if (from in this &&
                             this[from] === elt)
                             return from;
                     }
                     return -1;
                 };
             }
                $(".userContext").css("height", "30px");
            var sTempVehGroup = '<% =sVehGroup %>';
	        jsonVehGroup = $.parseJSON(sTempVehGroup);
//	        map = new BMap.Map("map");
            if(jsonVehGroup == undefined || jsonVehGroup.length == 0)
            {
            
            }
            else
            {
                GetVeh();
            }
            if (window.Browser.name == "msie" && window.Browser.version == "8.0") {
                $("#inputSearch").height(20);
                $("#inputSearch").css("margin-top", "5px");
                $("#inputSearch").css("padding-top", "3px");
                $("#inputSearch").css("line-height", "18px");
            }
            $(window).resize(function () {
            });
            
             initMap();
             $("#btnItemServeTime").click(function () {
                 $("[id^=div]").each(function () {
                     if ($(this).css("display") == "block") {
                         $(this).hide();
                     }
                 });
                 clearTable();
                 $("#tableImg").hide();
//                 $("#tbTitle").text("服务到期提醒");
                 //var count = tableServerTime._oRecordSet.getRecords().length;
                 //if (count > 0) {
                 //    tableServerTime.deleteRows(0, count);
                 //}
                 $("#divServeTime").show();
                 //var divLoading = '';
                 //$("#divServeTime").append(divLoading);
//                 $("#divCover").show();
                 var sUserName = GetCookie("username");
                 var sPwd = GetCookie("pwd");
                 $.ajax({
                     url: "../Ashx/ServerTime.ashx",
                     cache:false,
                     type:"post",
                     dataType:'json',
                     async:true, 
                     data:{username:sUserName,Pwd:sPwd,Day:iServerTime},
                     success:function(data){
                             if(data.result == "true")
                             {
                                var ssss = jsonVehs[0];
                                $.each(data.data,function(i,valuei)
                                {
                                    $.each(jsonVehs,function(j,valuej)
                                    {
                                        if("V" + valuei.VehID == valuej.id)
                                        {
                                            valuei["name"] = valuej["name"];
                                            valuei["team"] = valuej["team"];
                                            return false;
                                        }
                                    });
                                });
                                 $("#tableServeTime").datagrid('loadData',data.data);
                             }
                             else
                             {
        //	                        $("#divState").text(GetErr(data.err));
                             }
                     },
                     error: function(e) { 
                     
                     } 
                 }) ;
             });

             $("#btnItemAnnual").click(function () {
                 $("[id^=div]").each(function () {
                     if ($(this).css("display") == "block") {
                         $(this).hide();
                     }
                 });
                 clearTable();
                 $("#tableImg").hide();
//                 $("#tbTitle").text("年检到期提醒");
                 $("#divAnnual").show();
                 //var divLoading = '<div class="dataTables_Loading" style="background-color:#FFFFFF;position:absolute; z-index:99; top:35px; left:0px; overflow: auto; height: 243px; width: 100%; text-align:center;" ><img id="imgLoading" src="../Images/loading.gif"  style=" margin-top:50px;" alt="" /><div><a style="font-weight:bold; color:rgb(22, 21, 20); font-size:15px;">正在加载...</a></div></div>';
                 //$("#divAnnual .dataTables_scroll").append(divLoading);
//                 $("#divCover").show();
                 var sUserName = GetCookie("username");
                 var sPwd = GetCookie("pwd");
                 $.ajax({
                     url: "../Ashx/VehAnnual.ashx",
                     cache:false,
                     type:"post",
                     dataType:'json',
                     async:true, 
                     data:{username:sUserName,Pwd:sPwd,Day: iAnnual},
                     success:function(data){
                             if(data.result == "true")
                             {
                                var ssss = jsonVehs[0];
                                $.each(data.data,function(i,valuei)
                                {
                                    $.each(jsonVehs,function(j,valuej)
                                    {
                                        if("V" + valuei.VehID == valuej.id)
                                        {
                                            valuei["name"] = valuej["name"];
                                            valuei["team"] = valuej["team"];
                                            return false;
                                        }
                                    });
                                });
                                 $("#tableAnnual").datagrid('loadData',data.data);
                             }
                             else
                             {
        //	                        $("#divState").text(GetErr(data.err));
                             }
                     },
                     error: function(e) { 
                     
                     } 
                 }) ;
             });

             $("#btnItemMileMaintain").click(function () {
                 $("[id^=div]").each(function () {
                     if ($(this).css("display") == "block") {
                         $(this).hide();
                     }
                 });
                 clearTable();
                 $("#tableImg").hide();
//                 $("#tbTitle").text("里程保养提醒");
                 $("#divMileMaintain").show();
                 //var divLoading = '<div class="dataTables_Loading" style="background-color:#FFFFFF;position:absolute; z-index:99; top:35px; left:0px; overflow: auto; height: 243px; width: 100%; text-align:center;" ><img id="imgLoading" src="../Images/loading.gif"  style=" margin-top:50px;" alt="" /><div><a style="font-weight:bold; color:rgb(22, 21, 20); font-size:15px;">正在加载...</a></div></div>';
                 //$("#divMileMaintain .dataTables_scroll").append(divLoading);
//                 $("#divCover").show();
                 url = "/v1/VehWarn?";
                 url += "&uid=" + user.Uid;
                 url += "&type=MileMaintain"; // 里程保养
                 url += "&token=" + user.Token;
//                 getDataForIndex(url, dataMileMaintain, 0, 0, timeout, MileMaintainCallBack);
             });

             $("#btnItemLongTimeOff").click(function () {
                 $("[id^=div]").each(function () {
                     if ($(this).css("display") == "block") {
                         $(this).hide();
                     }
                 });
                 clearTable();
                 $("#tableImg").hide();
//                 $("#tbTitle").text("长时间掉线提醒");
                 $("#divLongTimeOff").show();
//                 $("#divCover").show();
                 if(jsonVehs != undefined)
                 {
                    var datas = new Array();
                    $.each(jsonVehs,function(i,value)
                    {
                        if(value.time == undefined)
                        {
                            var row = {"name":"","time":"1900/01/01 00:00:01","team":"","offlinesetday":3,"offlineday":3};
                            row.name = value.name;
                            row.time = "";
                            row.team = value.team;
                            row.offlinesetday = iLongTimeOff;
                            row.offlineday = "没上过线";
                            datas.push(row);
                            return true;
                        }
                        var gpsDate = new Date(value.time.replace(/-/g,"/")); 
                        var timeNow =new Date();
                        var date3=timeNow.getTime()-gpsDate.getTime();  //时间差的毫秒数
                        if((date3 / 1000 / 60 / 60 / 24) < iLongTimeOff)
                        {
                        
                        } 
                        else
                        {
                            var row = {"name":"","time":"1900/01/01 00:00:01","team":"","offlinesetday":3,"offlineday":"3"};
                            row.name = value.name;
                            row.time = value.time;
                            row.team = value.team;
                            row.offlinesetday = iLongTimeOff;
                            row.offlineday = (date3 / 1000 / 60 / 60 /24).toFixed(0);//4舍5入
                            datas.push(row);
                        }
                    });
                    if(datas.length > 0)
                    {
                        $('#tableLongTimeOff').datagrid('loadData',datas); 
                    }
                 }
             });
             $("#divServeTime").resize(function () {
                 $("#divServeTime").css("width", "100%");
             });
             $("#divAnnual").resize(function () {
                 $("#divAnnual").css("width", "100%");
             });
             $("#divLongTimeOff").resize(function () {
                 $("#divLongTimeOff").css("width", "100%");
             });
             $("#divMileMaintain").resize(function () {
                 $("#divMileMaintain").css("width", "100%");
             });
             $("#divAnnual").hide();
             $("#divLongTimeOff").hide();
             $("#divMileMaintain").hide();

             $("#Remind").scrollFix(37, "top", "");
             $("#vehMap").scrollFix(77, "top", "#Remind");
             $("#OnlineRate").scrollFix(117, "top", "#vehMap");

             $("#refresh").click(function () {
                 //loadLocalData(user.Uid, user.Token, timeout, refreshBack);
             });

         });
         
         function GetVeh()
        {
            try
            {
                var sUserName = GetCookie("username");
                var sPwd = GetCookie("pwd");
                var sLoginType = GetCookie("logintype");
                var sUserID = GetCookie("userid");
                $.ajax({
                    url: "../Ashx/Vehicle.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:false,//false是同步 
                    data:{username:sUserName,Pwd:sPwd,doType:1},
                    success:function(data){
                            if(data.result == "true")
                            {
    //                            OpenInfo("绑定成功！");
                                   var dsVeh = data.data;
                                   jsonVehs = dsVeh;
                                   $.each(jsonVehs, function(i, value){
                                        $.each(jsonVehGroup, function(j, value2){
                                                if(value.GID == value2.id)
                                                {
                                                    value["team"] = value2.name;
                                                    return false;//true=continue,false=break
                                                }
                                         });
                                   });
    //                               $("#divState").text("<% =Resources.Lan.LoadVehComplete %>");
                                   connectSocketServer();
                                   return;
                            }
                    },
                    error: function(e) { 
	                     $("#divState").text(e.responseText);
                    } 
                })
            }
            catch(e)
            {}
        }
        
        //------socket ------------------------------------------------------------------------------------
        var bGetLastposition = false;
        var ws;
        function connectSocketServer() {
                var support = "MozWebSocket" in window ? 'MozWebSocket' : ("WebSocket" in window ? 'WebSocket' : null);
                if (support == null) {
                    $("#divState").text(noSupportMessage);
                    return;
                }

                $("#divState").text("<% =Resources.Lan.ConnectingServer %>");
                // create a new websocket and connect
                ws = new window[support]('<% =ConfigurationManager.AppSettings["WebPort"] %>');
//                ws = new window[support]('ws://192.168.1.159:2012/');
                // when data is comming from the server, this metod is called
                ws.onmessage = function (evt) {
                    try
                    {
                        var sReturn = "";
                        if(typeof(evt.data)=="string"){ 
                            sReturn = evt.data;
                            Analize(sReturn);
                        }else{ 
                            var reader = new FileReader(); 
                            reader.onload = function(evt){ 
                                if(evt.target.readyState == FileReader.DONE){ 
                                    var dataBlob = new Uint8Array(evt.target.result); 
                                    for(var k = 0; k < dataBlob.length; k++)
                                    {
                                        sReturn = sReturn + String.fromCharCode(dataBlob[k]);
                                    }
                                    Analize(sReturn);
                                } 
                            } 
                            reader.readAsArrayBuffer(evt.data); 
                        }
                        
                    }
                    catch(e)
                    {
                        $("#divState").text(e.message);
                    }
                };

                // when the connection is established, this method is called
                ws.onopen = function () {
                    $("#divState").text("<% =Resources.Lan.SuccessfulConnectionCenter %>");
                    var sUserName = GetCookie("username");
                    var sPwd = GetCookie("pwd");
                    if(sUserName == undefined || sPwd == undefined)
                    {
                        $("#divState").text("<% =Resources.Lan.PleaseLogin %>");
                        return;
                    }
                    var sLogin = "[{'key':'1_1','ver':1,'rows':1,'cols':2,data:[{'name':'" + sUserName + "','pwd':'" + sPwd + "','type':1}]}]";
                    ws.send(sLogin); 
                };

                ws.onclose = function () {
//                    $("#divState").text('<% =Resources.Lan.ConnectionClosed %>');
//                    setTimeout("connectSocketServer()", 2000 )
                }
            }
            function Decodeuint8arr(uint8array){
                return new TextDecoder("utf-8").decode(uint8array);
            }
            
            function Encodeuint8arr(myString){
                return new TextEncoder("utf-8").encode(myString);
            }
            
            function Analize(sReturn)
            {
                try
                {
                    if(sReturn == undefined || sReturn.length == 0)
                    {
                        return;
                    } 
                    var data = eval(sReturn)[0];
                    switch(data.key)
                    {
                        case "2_1":
                            if(data.data[0].result)
                            {
                                $("#divState").text("<% =Resources.Lan.SuccessfulLoginCenter %>");
                                if(!bGetLastposition)
                                {
                                    var sGetLocation = "[{'key':'1_2','ver':1,'rows':0,'cols':0,data:[{}]}]";
                                    ws.send(sGetLocation);
                                    $("#divState").text("<% =Resources.Lan.LodingLastpostion %>");
                                }
                            }
                            else
                            {
                                $("#divState").text("<% =Resources.Lan.PleaseLogin %>");
                            }
                            break;
                        case "2_2"://位置数据
                        case "2_4"://点名返回
                            $.each(data.data,function(k,item)
                            {
                                var dataDetail = item;// data.data[0];
                                var vID = "V" + dataDetail.id;
                                if(dataDetail.id == -1)
                                {
                                    bGetLastposition = true;
                                    $("#divState").text("");//<% =Resources.Lan.LodingLastpostionComplete %>");
                                    ws.close();
                                    getMapData();
                                    getOnlineRate();
                                    return false;
                                }
                                $.each(jsonVehs,function(i,value)
                                {
                                    if(value.id == vID)
                                    {
                                        if(data.key == "2_4")
                                        {
                                        
                                        }
                                        value["time"] = dataDetail.time;
                                        var gpsDate = new Date(dataDetail.time.replace(/-/g,"/")); 
                                        var timeNow =new Date();
                                        var date3=timeNow.getTime()-gpsDate.getTime();  //时间差的毫秒数
                                        var bonline = value["online"];
                                        if(bGetLastposition || (date3 / 1000 / 60) < 10)
                                        {
                                            value["online"] = true;
                                        } 
                                        else
                                        {
                                            value["online"] = false;
                                        }
                                        value["Veh"] = dataDetail.iVeh;
                                        value["Angle"] = dataDetail.iAngle;
                                        value["lat"] = dataDetail.lat;
                                        value["lng"] = dataDetail.lng;
                                        value["address"] = "";
                                        value["velocity"] = dataDetail.iVel;
                                        value["angle"] = dataDetail.iAngle;
                                        //value["speedangle"] =  (Array(3).join(0) + dataDetail.iVel).slice(-3) + "km/h " + AngleToString(dataDetail.iAngle); 
                                        value["location"] = dataDetail.location;   
                                        value["mileage"] = dataDetail.mile; 
                                        value["fuelscale"] = dataDetail.oilScale;                                         
                                        return false;
                                    }
                                });
                            });
                            break;
                        case "2_3":
    //                        bGetLastposition = true;
    //                        $("#divState").text("<% =Resources.Lan.LodingLastpostionComplete %>");
                            break;
                        default:                                
                            break;
                    }
                 }
                 catch(e)
                 {}
            }
            
            function formatterTime(date){
			    var y = date.getFullYear();
			    var m = date.getMonth()+1;
			    var d = date.getDate();
			    var h = date.getHours();
			    var f = date.getMinutes();
			    var s = date.getSeconds();
			    return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ (h<10?('0'+h):h)+':'+(f<10?('0'+f):f)+':'+(s<10?('0'+s):s);
		    }
        //--------------------------------------------------------------------------------------------------
         
         function refreshBack() { }
         var myChart3;
         var loadShiyonglv = function (mileData, timeData, runStateData, dateData, maxTime, maxMile) {
             var dataStyle = {
                 normal: {
                     label: { show: false },
                     labelLine: { show: false }
                 }
             };
             var placeHolderStyle = {
                 normal: {
                     color: 'rgba(0,0,0,0)',
                     label: { show: false },
                     labelLine: { show: false }
                 },
                 emphasis: {
                     color: 'rgba(0,0,0,0)'
                 }
             };

             option = {
                 tooltip: {
                     trigger: 'axis'
                 },
                 calculable: true,
                 legend: {
                     data: ['运行里程', '运行时间', '运行', '停运']
                 },
                 xAxis: [
                     {
                         type: 'category',
                         splitLine: { show: false },
                         data: dateData
                     }
                 ],
                 yAxis: [
                     {
                         type: 'value',
                         name: '里程',
                         axisLabel: {
                             formatter: '{value} 公里'
                         },
                         max: maxMile
                     },
                     {
                         type: 'value',
                         name: '时间',
                         axisLabel: {
                             formatter: '{value} 小时'
                         },
                         max: maxTime
                     }

                 ],
                 series: [

                     {
                         name: '运行里程',
                         type: 'bar',
                         barWidth: 45,
                         data: mileData
                     },
                     {
                         name: '运行时间',
                         type: 'line',
                         yAxisIndex: 1,
                         data: timeData
                     },

                     {
                         name: '运行状况',
                         type: 'pie',
                         tooltip: {
                             trigger: 'item',
                             formatter: '{a} <br/>{b} : {c} ({d}%)'
                         },
                         center: [200, 130],
                         radius: [0, 50],
                         itemStyle: {
                             normal: {
                                 labelLine: {
                                     length: 20
                                 }
                             }
                         },
                         data: runStateData
                     }
                 ]
             };
             myChart3.hideLoading();
             myChart3.setOption(option, true);
         }
    // 改变窗口大小
         var changeWidthAndHeight = function () {
             getBrowserInfo();
             if (window.screen.width >= 1280 && window.screen.width >= 768) {
                 //                alert($("#header").height());
                 //                $("#header").height(window.browserHeight - 49);
                 //                $("#header").width(window.browserWidth);
             }

             if (window.Browser.name == "msie" && window.Browser.version == "8.0") {
                 $("#inputSearch").height(20);
                 $("#inputSearch").css("margin-top", "5");
                 $("#inputSearch").css("padding-top", "5");
                 $("#inputSearch").css("line-height", "18px");
             }
         }

         // 自动填充
         // 处理自动补全数据
         var autocompleteJson = function (vehicleList) {
//             var autocompleteList = new Array();
//             if (vehicleList.length > 0) {
//                 $.each(vehicleList, function (index, item) {
//                     autocompleteList.push({ "id": item.A, "txt": item.B });
//                     autocompleteList.push({ "id": item.A, "txt": item.C });
//                 });
//             }

//             $('#inputSearch').autocomplete(autocompleteList, {
//                 max: 20,    //列表里的条目数
//                 minChars: 1,    //自动补全激活之前填入的最小字符
//                 width: 220,     //提示的宽度，溢出隐藏
//                 scrollHeight: 500,   //提示的高度，溢出显示滚动条
//                 matchContains: true,    //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
//                 autoFill: false,    //自动填充
//                 formatItem: function (item, i, max) {
//                     return item.txt;
//                 }
//             }).result(function (event, item, formatted) {
//                 //findChooseNode(item.id);
//                 window.open("VehMonit.aspx?&vehid=" + item.id + "&plateNo=" + escape(item.txt));
//             });
         }





         /***菜单js函数***/
         function rpover() {

             $("#rpContext").addClass("moveon");
             $("#report").addClass("reprr");

         };

         function rpmove() {

             $("#rpContext").removeClass("moveon");
             $("#report").removeClass("reprr");

         };
         function userover() {

             $("#userContext").addClass("userContextmoveon");

         };

         function usermove() {

             $("#userContext").removeClass("userContextmoveon");

         };

         function resizeTable() {
             $(".yui-dt-bd").css("width", "100%");
             $(".yui-dt-bd").css("overflow-x", "hidden");
             $(".yui-dt-bd").css("text-overflow", "ellipsis");
             $("#divServeTime").css("width", "100%");
             $("#divAnnual").css("width", "100%");
             $("#divLongTimeOff").css("width", "100%");
             $("#divMileMaintain").css("width", "100%");
         }
         //导航到
         function navTo(div) {
             var div = div;
             if (div.id == "Remind") {
                 $("body").animate({ "scrollTop": 0 }, "normal");
                 $("html").animate({ "scrollTop": 0 }, "normal");
             }
             else if (div.id == "vehMap") {
                 $("body").animate({ "scrollTop": 550 }, "normal");
                 $("html").animate({ "scrollTop": 550 }, "normal");
             }
             else if (div.id == "OnlineRate") {
                 $("body").animate({ "scrollTop": 1300 }, "normal");
                 $("html").animate({ "scrollTop": 1300 }, "normal");
             }
         }

         //退出
         function LogOutClick() {
             $.messager.confirm('提示', '确认退出系统？', function(r){
				 if (r){
                     $("#btnClearSessionCS")[0].click();
                 }
                 else {

                 }
             });
         }
     </script>
</html>
