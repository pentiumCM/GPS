<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormOilSetting.aspx.cs" Inherits="MHtmls_Cmd_FormOilSetting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.OilTestingParametersSetting %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../Js/GridTreeMulSelect.js"></script> 
    <script type="text/javascript">
        $(document).ready(function() { 
            window.parent.window.GetCmdVeh();
            window.parent.window.InitOil();
        });
        
        function send()
        {
            try
            {
                if(endEditing())
		        {
		            accept();
		        }
		        else
		        {
		            return;
		        }
                var rows = $('#dg').datagrid('getData');
                var sStealOil = $("#txtStealOil").textbox('getValue');
                var iStealOil = parseInt(sStealOil);
                if(isNaN(iStealOil) || isNaN(sStealOil) || iStealOil <0)
                {
                    $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
                    return ;
                }
                var sChkPresent = $("#chkPresent")[0].checked;
                var sOilValue = $("#txtOilValue").textbox('getValue');
                var sOil = "1," + $("#txtOilValue").textbox('getValue');
                var iOilValue = parseInt(sOilValue);
                if(isNaN(iOilValue) || isNaN(sOilValue) || iOilValue <0)
                {
                    $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
                    return ;
                }
                var bCheck = true;
                if(!sChkPresent)
                {
                    sOil = "";
                    rows.rows.sort(function(a,b){
                        return a.Scale-b.Scale;
                    });
//                    if(rows.rows.length < 2)
//                    {
//                        $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
//                        return;
//                    }
                    var iValue = 0;
                    $.each(rows.rows,function(i,value){
                        if(parseInt(value.OilValue) < parseInt(iValue))
                        {
                            bCheck = false;
                            $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
                            return false;
                        }
                        iValue = value.OilValue;
                        if(i == 0)
                        {
                            sOil = value.Scale + "," + value.OilValue;
                        }
                        else
                        {
                            sOil = sOil + ";" + value.Scale + "," + value.OilValue;
                        }
                    });
                }
                if(!bCheck)
                {
                    return;
                }
                var sVehs = "";
                var sName = "";
                $.each(arrVehs,function(i,value){
                    if(i == 0)
                    {
                        sVehs = value.id.substring(1);
                        sName = value.name;
                    }
                    else
                    {
                        sVehs = sVehs + "," + value.id.substring(1);
                        sName = sName + "," + value.name;
                    }
                });
                var sUserName = GetCookie("username");
                var sPwd = GetCookie("pwd");
                $.ajax({
                    url: "../../Ashx/OilSettings.ashx",
                    cache:false,
                    type:"get",
                    data:{"DoType":"2","username":sUserName,"Pwd":sPwd,"StealOil":sStealOil,"IsPresent":sChkPresent,"Oils":sOil,"Vehs":sVehs,"Names":sName},
                    dataType:'json',
                    success:function(data){
                        if(data.result)
                        {
                            window.parent.window.UpdateOil(iOilID,sStealOil,sChkPresent,sOil);
			                OpenInfo("<% =Resources.Lan.Successful %>");
			                return;
                        }
                        else
                        {
                            OpenInfo("<% =Resources.Lan.Fault %>");
                        }
                    },
                    error: function(e) { 
                        OpenInfo(e.responseText); 
                    } 
                });
            }
            catch(e)
            {
                ShowInfo(e.message);
            }
        }  
        
        function OpenInfo(info)
        {
            $.messager.show({
			    title:'<% =Resources.Lan.Prompt %>',
			    msg:info,
			    showType:'fade',
			    style:{
			        right:'',
			        bottom:''
			    }
			});
        }
        
        var arrVehs ;
        function SetCmdVeh(rows)
        {
            arrVehs = rows;
            $.each(rows,function(i,value)
            {
                 $('#ulList').datalist('appendRow',{text:value.name,value:value.name});
            });
            $('#ulList').datalist('deleteRow',0);
        }
        
        var iOilID = -1;
        function InitOil(cOil)
        {
            $("#txtStealOil").textbox('setValue',cOil.StealOil);
            iOilID = cOil.id;
            if(cOil.lstDetail.length == 1)
            {
                $("#chkPresent")[0].checked = true;
                $("#txtOilValue").textbox('setValue',cOil.lstDetail[0].OilValue);
            }
            else
            {
                var rows = new Array();
                $.each(cOil.lstDetail,function(i,value){
                    rows.push({"Scale":value.Scale,"OilValue":value.OilValue});
                });
                $('#dg').datagrid('loadData',rows); 
            }
        }
        
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
        function ShowInfo(info)
        {
            $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
        }
        
        var editIndex = undefined;
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#dg').datagrid('validateRow', editIndex)){
				var sScaleTar = $('#dg').datagrid('getEditor', {index:editIndex,field:'Scale'});
				var sScale = $(sScaleTar.target).textbox('getText');
                var sOilValueTar = $('#dg').datagrid('getEditor', {index:editIndex,field:'OilValue'});
                var sOilValue = $(sOilValueTar.target).textbox('getText');
                try
                {
                    var iScale = parseInt(sScale);
                    var iOil = parseInt(sOilValue);
                    if(isNaN(sScale) || isNaN(iScale) || iScale <0)
                    {
                        $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
                        return false;
                    }
                    if(isNaN(sOilValue) || isNaN(iOil) || iOil < 0)
                    {
                        $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
                        return false;
                    }
                }
                catch(e)
                {
                    $.messager.alert('<% =Resources.Lan.Tip %>','<% =Resources.Lan.ParameterError %>','info');
                    return false;
                }
				$('#dg').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
		function onClickRow(index){
			if (editIndex != index){
				if (endEditing()){
					$('#dg').datagrid('selectRow', index)
							.datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#dg').datagrid('selectRow', editIndex);
				}
			}
		}
		function append(){
			if (endEditing()){
				$('#dg').datagrid('appendRow',{status:'A'});
				editIndex = $('#dg').datagrid('getRows').length-1;
				$('#dg').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
			}
		}
		function removeit(){
			if (editIndex == undefined){return}
			$('#dg').datagrid('cancelEdit', editIndex)
					.datagrid('deleteRow', editIndex);
			editIndex = undefined;
		}
		function accept(){
			if (endEditing()){
				$('#dg').datagrid('acceptChanges');
			}
		}
		function reject(){
			$('#dg').datagrid('rejectChanges');
			editIndex = undefined;
		}
		function getChanges(){
		    if(endEditing())
		    {
		        accept();
		    }
		}
    </script>
</head>
<body>
    <div class="easyui-navpanel" style="-webkit-overflow-scrolling: touch;">
        <div style="float:left; height:99%; display:none;" id="divList">
            <ul class="easyui-datalist" id="ulList" title="<% =Resources.Lan.VehList %>" lines="true" style="width:140px; height:350px">
		        <li value=""></li>
            </ul>
        </div>
        <div style="float:left">
        <div class="easyui-panel" title="<% =Resources.Lan.OilTestingParametersSetting %>" style="width:280px; height:350px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		        <tr>
	    			        <td style="width:95px; text-align:right;">
	    			            <% =Resources.Lan.OilSuddenlyFall %>:
	    			        </td>	  
	    			        <td>
	    			            <input style="width:40px" class="easyui-textbox" type="text" id="txtStealOil" value="30" name="txtStealOil" />&nbsp;<% =Resources.Lan.LitreIsStealingOil%>
	    			        </td>  			    
	    		        </tr>
	    		        <tr>
	    			        <td style="text-align:right; width:95px;">
	    			            <input type="checkbox" id="chkPresent" /> <% =Resources.Lan.Percent %>:
	    			       </td>
	    			       <td>     
	    			            <input style="width:40px" class="easyui-textbox" type="text" id="txtOilValue" value="380" name="txtOilValue" />&nbsp;(<% =Resources.Lan.FuelCapatity %>)
	    			       </td>
	    		        </tr>
	    		        <tr>
	    			        <td colspan="2">
	    			            <table id="dg" class="easyui-datagrid" style="width:99%;height:auto"
			                    data-options="
				                    iconCls: 'icon-edit',
				                    singleSelect: true,
				                    toolbar: '#tb',
				                    onClickRow: onClickRow
			                    ">
		                        <thead>
			                        <tr>
				                        <th data-options="field:'Scale',width:100,editor:'textbox'"><% =Resources.Lan.Scale %></th>
				                        <th data-options="field:'OilValue',width:100,editor:'textbox'"><% =Resources.Lan.Fuel %></th>
			                        </tr>
		                        </thead>
	                         </table>
             
	                         <div id="tb" style="height:auto">
		                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()"><% =Resources.Lan.Add%></a>
		                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()"><% =Resources.Lan.Del%></a>
		                        <%--<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="accept()">Accept</a>--%>
		                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true" onclick="reject()"><% =Resources.Lan.Cancel%></a>
		                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="getChanges()"><% =Resources.Lan.Save%></a>
	                        </div>
	    			    </td>
	    		    </tr>
	    	    </table>
	            </form>
	        </div>
	        <div style="text-align:center;padding:5px">
	    	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="send()"><% =Resources.Lan.Confirm %></a>
	    	    &nbsp;&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeForm()"><% =Resources.Lan.Close %></a>
	        </div>
	    </div>
    </div>
    </div>
</body>
</html>
