//-------------------------------------------------------------------------------  
// 当然页面文件中还需要引入的文件如下：  
// easyui.css 和其它页面用到的CSS文件  
// jquery-1-8-3-min.js, easyui-lang-zh_CN.js, jquery-easyui-min.js, datagrid-detailview.js,  和其它页面用到的JS文件  
//-------------------------------------------------------------------------------  
//     结合SHIFT,CTRL,ALT键实现单选或多选  
//-------------------------------------------------------------------------------  
var KEY = { SHIFT:16, CTRL:17, ALT:18, DOWN:40, RIGHT:39, UP:38, LEFT:37};    
var selectIndexs = {firstSelectRowIndex:0, lastSelectRowIndex:0};  
var inputFlags = {isShiftDown:false, isCtrlDown:false, isAltDown:false}  
  
function keyPress(event){//响应键盘按下事件  
    var e = event || window.event;    
    var code = e.keyCode | e.which | e.charCode;        
    switch(code) {    
//        case KEY.SHIFT:    
//        inputFlags.isShiftDown = true;  
//        $('#tgVeh').datagrid('options').singleSelect = false;             
//        break;  
    case KEY.CTRL:  
        inputFlags.isCtrlDown = true;  
        $('#tgVeh').datagrid('options').singleSelect = false;             
        break;  
    /* 
    case KEY.ALT:    
        inputFlags.isAltDown = true; 
        $('#dataListTable').datagrid('options').singleSelect = false;            
        break; 
    */    
    default:          
    }  
}  
  
function keyRelease(event) { //响应键盘按键放开的事件  
    var e = event || window.event;    
    var code = e.keyCode | e.which | e.charCode;        
    switch(code) {    
        case KEY.SHIFT:   
        inputFlags.isShiftDown = false;  
        selectIndexs.firstSelectRowIndex = 0;  
        $('#tgVeh').datagrid('options').singleSelect = true;              
        break;  
    case KEY.CTRL:  
        inputFlags.isCtrlDown = false;  
        selectIndexs.firstSelectRowIndex = 0;  
        $('#tgVeh').datagrid('options').singleSelect = true;  
        break;  
    /* 
    case KEY.ALT:    
        inputFlags.isAltDown = false; 
        selectIndexs.firstSelectRowIndex = 0; 
        $('#dataListTable').datagrid('options').singleSelect = true;             
        break; 
    */  
    default:          
    }  
}  