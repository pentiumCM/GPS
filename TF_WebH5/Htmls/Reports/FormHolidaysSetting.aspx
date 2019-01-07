<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormHolidaysSetting.aspx.cs" Inherits="Htmls_Reports_FormHolidaysSetting" %>

<!DOCTYPE html>
<html>
<head >
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />--%>
    <title><% =Resources.Lan.Holidays %></title>
    <style type="text/css">
        body, html {width: 100%;height: 100%;overflow: hidden;margin:0;}
	    
	    #webfont {
		    font: 24px/150% BaiduCar;
		    width: 300px;
	    }
	    /* 以下为自动提示框*/
	    .search{ 
            text-align: left; 
            position:relative; 
        } 
        .autocomplete{ 
            border: 1px solid #9ACCFB; 
            background-color: white; 
            text-align: left; 
        } 
        .autocomplete li{ 
            list-style-type: none; 
            font-size:14px;
            padding:2px;
        } 
        .autocomplete ul{ 
            list-style-type: none; 
        } 
        .clickable { 
            cursor: default; 
        } 
        .highlight { 
            background-color: #9ACCFB; 
        } 
    </style>  
    <link href="../../Css/index.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css" />  
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/color.css"/> 
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css"/> 
    <script type="text/javascript" src="../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../Js/AutoComplete.js"></script> 
    <script type="text/javascript" src="../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../Js/JExcel.js"></script> 
    <%--<script type="text/javascript" src="../EasyUI/easyui-lang-zh_CN.js"></script> --%>
    <script type="text/javascript">
        
        $(document).ready(function() { 
               Query();
        });
               		
		function GetRequest() {  
          var url = location.search; //获取url中"?"符后的字串
           var theRequest = new Object();
           if (url.indexOf("?") != -1) {
              var str = url.substr(1);
              strs = str.split("&");
              for(var i = 0; i < strs.length; i ++) {
                 theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);
              }
           }
           return theRequest;
        }
		
        function Query()
        {
           
            var Request = GetRequest();            
            $.ajax({
                url: "../../Ashx/Holidays.ashx",
                cache:false,
                type:"get",
                dataType:'json',
                success:function(data){
                    if(data.result == "true")
                    {
                        $('#dg').datagrid('loadData',data.data); 
                    }
                    else
                    {
                        
                    }
                },
                error: function(e) { 
                    OpenInfo(e.responseText); 
                } 
            });
        }
               
        function OpenInfo(info)
        {
            $("#dlgInfo").html("<p>" + info + "</p>");
            $("#dlg1").dialog('open').dialog('center');
        }
        
        function OpenLoding(value)
        {
            $("#dlgLoding").dialog('open').dialog('center');
//            var value = $('#p').progressbar('getValue');
			$('#p').progressbar('setValue', value);
        }
         
         function ClearHistoryTable()
        {
            $('#GridReport').datagrid('loadData', { total: 0, rows: [] });  
        }
        
       function ShowInfo(info)
       {
           $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
       }
       
       
       		var editIndex = undefined;
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#dg').datagrid('validateRow', editIndex)){
				var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'year'});
				var yearname = $(ed.target).combobox('getText');
				$('#dg').datagrid('getRows')[editIndex]['text'] = yearname;
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
		    endEditing();
			var rowInserts = $('#dg').datagrid('getChanges','inserted');
			var rowDels = $('#dg').datagrid('getChanges','deleted');
			var rowUpdates = $('#dg').datagrid('getChanges','updated');
			var arrSave = new Array();
			$.each(rowInserts,function(i,value){
			    var row = {"Do":"I","Year":value.text,"Days":value.days,"workdays":value.workdays};
			    if(parseInt(value.text) < 2000 || parseInt(value.text) > 2099)
			    {
			        OpenInfo("<% =Resources.Lan.Year %>[" + value.text + "] <% =Resources.Lan.FillInError %>");
			        return;
			    }
			    arrSave.push(row);
			});
			$.each(rowUpdates,function(i,value){
			    var row = {"Do":"U","Year":value.text,"Days":value.days,"workdays":value.workdays};
			    if(parseInt(value.text) < 2000 || parseInt(value.text) > 2099)
			    {
			        OpenInfo("<% =Resources.Lan.Year %>[" + value.text + "] <% =Resources.Lan.FillInError %>");
			        return;
			    }
			    arrSave.push(row);
			});
			$.each(rowDels,function(i,value){
			    var row = {"Do":"D","Year":value.text,"Days":value.days,"workdays":value.workdays};
			    if(parseInt(value.text) < 2000 || parseInt(value.text) > 2099)
			    {
			        OpenInfo("<% =Resources.Lan.Year %>[" + value.text + "] <% =Resources.Lan.FillInError %>");
			        return;
			    }
			    arrSave.push(row);
			});
			if(arrSave.length == 0)
			{
			    accept();
			    OpenInfo("<% =Resources.Lan.Successful %>");
			    return;
			}
			$.ajax({
                url: "../../Ashx/Holidays.ashx",
                cache:false,
                type:"get",
                data:{"Save":JSON.stringify(arrSave)},
                dataType:'json',
                success:function(data){
                    if(data.result == "true")
                    {
                         accept();
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
    </script>
</head><%--oncontextmenu="return false" --%>
<body class="easyui-layout" id="bodyLayout" style="overflow-y: hidden; scroll:"no">
    <div region="center" style="background: #eee; overflow-y:hidden">       
    
            	<table id="dg" class="easyui-datagrid" title="<% =Resources.Lan.HolidayFormat %>" style="width:580px;height:auto"
			        data-options="
				        iconCls: 'icon-edit',
				        singleSelect: true,
				        toolbar: '#tb',
				        onClickRow: onClickRow
			        ">
		        <thead>
			        <tr>
				        <%--<th data-options="field:'itemid',width:80">Item ID</th>--%>
				        <th data-options="field:'year',width:60,
						        formatter:function(value,row){
							        return row.text;
						        },
						        editor:{
							        type:'combobox',
							        options:{
								        valueField:'id',
								        textField:'text',
								        method:'get',
								        url:'HolidayJson.json',
								        required:true
							        }
						        }"><% =Resources.Lan.Year %></th>
				        <th data-options="field:'days',width:300,editor:'textbox'"><% =Resources.Lan.Holidays%></th>
				        <th data-options="field:'workdays',width:200,editor:'textbox'"><% =Resources.Lan.WorkDay %></th>
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
     </div>
     <%--进度条--%>
	<div id="dlgLoding" class="easyui-dialog" style="padding:20px 6px;width:200px; text-align:center;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Loading %>'">
		<div id="p" class="easyui-progressbar" style="width:100%;"></div>
	</div>
	<div id="dlg1" class="easyui-dialog" style="padding:20px 6px;width:200px;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Prompt %>'">
		<div id="dlgInfo">This is a message dialog.</div>
		<div class="dialog-button">
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100%;height:35px" onclick="$('#dlg1').dialog('close')"><% =Resources.Lan.Confirm%></a>
		</div>
	</div>
</body>
</html>
