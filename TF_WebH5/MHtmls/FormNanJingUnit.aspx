<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormNanJingUnit.aspx.cs" Inherits="MHtmls_FormNanJingUnit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>选择单位</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../EasyUI/themes/default/easyui.css" />    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/mobile.css" />
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.mobile.js"></script>
    <script type="text/javascript" src="../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../Js/GridTreeMulSelect.js"></script> 
    <script type="text/javascript">
        var arrUnit = new Array();
        var arrTract = new Array();
        var sTitle = "";
        $(document).ready(function() { 
            arrUnit.push({"key":"340000","value":"安徽省"});
            arrUnit.push({"key":"320106","value":"鼓楼区"});
            arrUnit.push({"key":"320102","value":"玄武区"});
            arrUnit.push({"key":"320103","value":"白下区"});
            arrUnit.push({"key":"320105","value":"建邺区"});
            arrUnit.push({"key":"320115","value":"江宁区"});
            arrUnit.push({"key":"320114","value":"雨花台区"});
            arrUnit.push({"key":"320000","value":"江苏省"});
            arrUnit.push({"key":"320100","value":"南京市"});
            arrUnit.push({"key":"320101","value":"市辖区"});
            arrUnit.push({"key":"320104","value":"秦淮区"});
            arrUnit.push({"key":"320111","value":"浦口区"});
            arrUnit.push({"key":"320113","value":"栖霞区"});
            arrUnit.push({"key":"320107","value":"下关区"});
            arrUnit.push({"key":"320116","value":"六合区"});
            arrUnit.push({"key":"320124","value":"溧水县"});
            arrUnit.push({"key":"320125","value":"高淳县"});
            arrUnit.push({"key":"330000","value":"浙江省"});
            
            arrTract.push({"key":"13","value":"轨道交通产业"});
            arrTract.push({"key":"14","value":"新材料"});
            arrTract.push({"key":"16","value":"电力自动化与智能电网"});
            arrTract.push({"key":"03300","value":"塑料制品业"});
            arrTract.push({"key":"4","value":"工程建设计量"});
            arrTract.push({"key":"1","value":"民生计量"});
            arrTract.push({"key":"2","value":"能源计量"});
            arrTract.push({"key":"5","value":"汽车设备计量"});
            arrTract.push({"key":"6","value":"环保计量"});
            arrTract.push({"key":"7","value":"医药计量"});
            arrTract.push({"key":"9","value":"食品安全计量"});
            arrTract.push({"key":"3","value":"石化计量"});
            arrTract.push({"key":"8","value":"其他"});
            arrTract.push({"key":"10","value":"钢铁"});
            arrTract.push({"key":"11","value":"电子信息"});
            arrTract.push({"key":"12","value":"新能源"});
            arrTract.push({"key":"15","value":"通信"});
            arrTract.push({"key":"17","value":"航空航天"});
            $("#txtUnit").combobox({  
                 //相当于html >> select >> onChange事件  
                 onChange:function(){  
                     SelectChange();
                 }
             });  
            $("#txtTract").combobox({  
                 //相当于html >> select >> onChange事件  
                 onChange:function(){  
                     SelectChange();
                 }
             });  
             var Request = GetRequest();
             sTitle = decodeURI(Request["t"]);
            window.parent.window.GetUnit(sTitle);   
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
        
        function send()
        {
            try
            {
                var sRegion = $('#txtUnit').combobox('getValue');
                var sUnit = $('#txtTract').combobox('getValue');
                var bShow = $('#chkShow')[0].checked;
                window.parent.window.SetFindUnit(sTitle, sRegion, sUnit, rowSelect,bShow);
                closeForm();
//			    $('#dg').datagrid({loadFilter:pagerFilter}).datagrid('loadData', getData());
            }
            catch(e)
            {
                OpenInfo(e.message);
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
        
        var arrNanJingUnit = new Array();
        function InitUnit(arrNanJingUnitTemp)
        {
            arrNanJingUnit = arrNanJingUnitTemp;
            $.each(arrNanJingUnit,function(i,value){
                $.each(arrUnit,function(j,valuej){
                    if(value.RCode == valuej.key)                    
                    {
                        value["RCodeName"] = valuej.value;
                        return false;
                    }
                });
                $.each(arrTract,function(j,valuej){
                    if(value.UCode == valuej.key)                    
                    {
                        value["UCodeName"] = valuej.value;
                        return false;
                    }
                });
            });
            $('#dg').datagrid({loadFilter:pagerFilter}).datagrid('loadData', arrNanJingUnit);
        }
        
        
        function formatVehcheckbox(val,row){
            return "<input type='checkbox' onclick=showVehcheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name;
        }
                
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
        
        function getData(){
			var rows = [];
			for(var i=1; i<=800; i++){
				var amount = Math.floor(Math.random()*1000);
				var price = Math.floor(Math.random()*1000);
				rows.push({
					inv: 'Inv No '+i,
					date: $.fn.datebox.defaults.formatter(new Date()),
					name: 'Name '+i,
					amount: amount,
					price: price,
					cost: amount*price,
					note: 'Note '+i
				});
			}
			return rows;
		}
				
		function pagerFilter(data){
			if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
				data = {
					total: data.length,
					rows: data
				}
			}
			var dg = $(this);
			var opts = dg.datagrid('options');
			var pager = dg.datagrid('getPager');
			pager.pagination({
				onSelectPage:function(pageNum, pageSize){
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					dg.datagrid('loadData',data);
				}
			});
			if (!data.originalRows){
				data.originalRows = (data.rows);
			}
			var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start, end));
			return data;
		}
		
		var IsCheckFlag = true; //标示是否是勾选复选框选中行的，true - 是 , false - 否
		var iSelectIndex = -1;
		function onClickCellEx(rowIndex, field, value)
		{
//		    IsCheckFlag = false;
		}
		
		var rowSelect = undefined;
		function onSelectEx(rowIndex, rowData) {
		    if(rowIndex != iSelectIndex)
		    {
		        if(iSelectIndex != -1)
		        {
		            $("#dg").datagrid("unselectRow", iSelectIndex);
		        }
		        iSelectIndex = rowIndex;
		        $('#txtUnitDetal').textbox("setValue", rowData.CompanyName);
		        rowSelect = rowData;
		    }
		    else
		    {
		        $("#dg").datagrid("unselectRow", iSelectIndex);
		        iSelectIndex = -1;
		        $('#txtUnitDetal').textbox("setValue", "");
		        rowSelect = undefined;
		    }
//             if (!IsCheckFlag) {
//                 IsCheckFlag = true;
//                 $("#dg").datagrid("unselectRow", rowIndex);
//             }
        }                  
       function onUnselectEx(rowIndex, rowData) {
        return;
         if (!IsCheckFlag) {
             IsCheckFlag = true;
             $("#dg").datagrid("selectRow", rowIndex);
         }
       }
       
       function Find(sText)
       {
            var arrData = new Array();
            if(sText.length == 0)
            {
                $('#dg').datagrid({loadFilter:pagerFilter}).datagrid('loadData', arrNanJingUnit);
                return;
            }
            else
            {
                $.each(arrNanJingUnit,function(ii,value){
                    if(isContains(value.CompanyName,sText))
                    {
                        arrData.push(value);
                    }
                });
                $('#dg').datagrid({loadFilter:pagerFilter}).datagrid('loadData', arrData);
                return;
            }
       }
       
       function isContains(str, substr) {
            return new RegExp(substr).test(str);
        }
        
        function SelectChange()
        {
		    iSelectIndex = -1;
		    $('#txtUnitDetal').textbox("setValue", "");
		    rowSelect = undefined;
            var sText = $('#txtUnit').combobox('getValue');
            var sText2 = $('#txtTract').combobox('getValue');
            var arrData = new Array();
            $.each(arrNanJingUnit,function(j,value){
                var bFind = false;
                if(sText != "0")
                {
                    if(value.RCode == sText)                    
                    {
                        bFind = true;
                    }
                }
                else
                {
                    bFind = true;
                }
                if(bFind)
                {
                    if(sText2 != "0")
                    {
                        if(value.UCode == sText2)                    
                        {
                            bFind = true;
                        }
                        else
                        {
                            bFind = false;
                        }
                    }
                    else
                    {
                        bFind = true;
                    }
                }
                if(bFind)
                {
                    arrData.push(value);
                }
            });
            $('#dg').datagrid({loadFilter:pagerFilter}).datagrid('loadData', arrData);
        }
    </script>
</head>
<body oncontextmenu="return false">
    <div class="easyui-navpanel" style="-webkit-overflow-scrolling: touch;">
	   
	        <select class="easyui-combobox" name="txtUnit" id="txtUnit" >
		         <option value="0">不限</option>
		         <option value="340000">安徽省</option>
		         <option value="320106">鼓楼区</option>
		         <option value="320102">玄武区</option>
		         <option value="320103">白下区</option>
		         <option value="320105">建邺区</option>
		         <option value="320115">江宁区</option>
		         <option value="320114">雨花台区</option>
		         <option value="320000">江苏省</option>
		         <option value="320100">南京市</option>
		         <option value="320101">市辖区</option>
		         <option value="320104">秦淮区</option>
		         <option value="320111">浦口区</option>
		         <option value="320113">栖霞区</option>
		         <option value="320107">下关区</option>
		         <option value="320116">六合区</option>
		         <option value="320124">溧水县</option>
		         <option value="320125">高淳县</option>
		         <option value="330000">浙江省</option>
		     </select>
		     &nbsp;
		     <select class="easyui-combobox" name="txtTract" id="txtTract" >
		         <option value="0">不限</option>
		         <option value="13">轨道交通产业</option>
		         <option value="14">新材料</option>
		         <option value="16">电力自动化与智能电网</option>
		         <option value="03300">塑料制品业</option>
		         <option value="4">工程建设计量</option>
		         <option value="1">民生计量</option>
		         <option value="2">能源计量</option>
		         <option value="5">汽车设备计量</option>
		         <option value="6">环保计量</option>
		         <option value="7">医药计量</option>
		         <option value="9">食品安全计量</option>
		         <option value="3">石化计量</option>
		         <option value="8">其他</option>
		         <option value="10">钢铁</option>
		         <option value="11">电子信息</option>
		         <option value="12">新能源</option>
		         <option value="15">通信</option>
		         <option value="17">航空航天</option>
		     </select>
		     &nbsp;
		      <input type="checkbox" id="chkShow" checked name="chkShow" />显示单位
		     &nbsp;
		      <input style="width:150px" disabled class="easyui-textbox" type="text" id="txtUnitDetal" value="" name="txtUnitDetal" />
		      &nbsp;
		      <a href="javascript:void(0)" class="easyui-linkbutton" onclick="send()"><% =Resources.Lan.Confirm %></a>
		    &nbsp;&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeForm()"><% =Resources.Lan.Close %></a>
	        
	        <table id="dg" title="单击选择单位，再次点击取消选择单位" style="width:600px;height:370px" data-options="
				rownumbers:true,
				singleSelect:true,
				autoRowHeight:false,
				pagination:true,
                 checkOnSelect: false,
                 selectOnCheck: true,
				onClickCell:onClickCellEx,
				onSelect:onSelectEx,
				onUnselect:onUnselectEx,
				toolbar:'#tb',
				pageSize:10">
		<thead>
			<tr>
				<th field="CompanyName" width="200">单位名称</th>
				<th field="UCodeName" width="100">单位行业</th>
				<th field="RCodeName" width="100">行政区域</th>
				<th field="Lat" width="80">纬度</th>
				<th field="Lng" width="80">经度</th>
			</tr>
		</thead>
	</table>
	</div>
	
		<div id="tb" style="padding:5px;height:auto">
		<div>
				<input id="txtSearch" class="easyui-textbox" style="width:250px" data-options="
			prompt: '请输入单位名称!',
			iconWidth: 22,
			icons: [{
				iconCls:'icon-search',
				handler: function(e){
					var v = $(e.data.target).textbox('getValue');
					var sText = (v ? v : '');
					Find(sText);
				}
			}]
			" />
		</div>
	</div>
	
</body>
</html>
