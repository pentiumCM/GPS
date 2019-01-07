function AutoText(textName,jsonContent)
{
    //取得div层 
    var $searchInput = $('#' + textName);
    //取得输入框JQuery对象 
//    var $searchInput = $search.find('#' + textName);
    //关闭浏览器提供给输入框的自动完成 
    $searchInput.attr('autocomplete', 'off');
    //创建自动完成的下拉列表，用于显示服务器返回的数据,插入在搜索按钮的后面，等显示的时候再调整位置 
    var $autocompleteParrent = $('<div class="panel combo-p" style="z-index: 110003; position: absolute; display: none; "></div>');
    $autocompleteParrent.hide().insertAfter('#DivAutoComplete');//'#submit');
    var $autocomplete = $('<div class="autocomplete" style="z-index: 110003; display: block; " ></div>');
    $autocomplete.appendTo($autocompleteParrent);
    //清空下拉列表的内容并且隐藏下拉列表区 
    var clear = function() {
        $autocomplete.empty();//.hide();
        $autocompleteParrent.hide();
    };
    //注册事件，当输入框失去焦点的时候清空下拉列表并隐藏 
    $searchInput.blur(function() {
        setTimeout(clear, 500);
    });
    //下拉列表中高亮的项目的索引，当显示下拉列表项的时候，移动鼠标或者键盘的上下键就会移动高亮的项目，想百度搜索那样 
    var selectedItem = null;
    //timeout的ID 
    var timeoutid = null;
    //设置下拉项的高亮背景 
    var setSelectedItem = function(item) {
        //更新索引变量 
        selectedItem = item;
        //按上下键是循环显示的，小于0就置成最大的值，大于最大值就置成0 
        if (selectedItem < 0) {
            selectedItem = $autocomplete.find('li').length - 1;
        } else if (selectedItem > $autocomplete.find('li').length - 1) {
            selectedItem = 0;
        }
        //首先移除其他列表项的高亮背景，然后再高亮当前索引的背景 
        $autocomplete.find('li').removeClass('highlight').eq(selectedItem).addClass('highlight');
    };
    var ajax_request = function() {
        //ajax服务端通信 
        //遍历jsonContent，添加到自动完成区 
        iSearchID = "";
        $.each(jsonContent,
        function(index, term) { 
            var sSearchT = $searchInput.val().toUpperCase();
            if(term.name.toUpperCase().indexOf(sSearchT) > -1)
            {           
                //创建li标签,添加到下拉列表中 
                $('<li></li>').text(term.name).appendTo($autocomplete).addClass('clickable').hover(function() {
                    //下拉列表每一项的事件，鼠标移进去的操作 
                    $(this).siblings().removeClass('highlight');
                    $(this).addClass('highlight');
                    selectedItem = index;
                },
                function() {
                    //下拉列表每一项的事件，鼠标离开的操作 
                    $(this).removeClass('highlight');
                    //当鼠标离开时索引置-1，当作标记 
                    selectedItem = -1;
                }).click(function() {
                    //鼠标单击下拉列表的这一项的话，就将这一项的值添加到输入框中 
                    $searchInput.val(term.name);
                    iSearchID = term.id;//.substring(1);
                    if( typeof SearchReturn === 'function' ){
                        SearchReturn(iSearchID);
                    }else{
                        
                    }
                    //清空并隐藏下拉列表 
                    $autocomplete.empty();//.hide();
                    $autocompleteParrent.hide();
                });
            }
        }); //事件注册完毕 
        //设置下拉列表的位置，然后显示下拉列表 
        var ypos = $searchInput.position().top;
        ypos = getAbsoluteTop($searchInput[0]);
        var xpos = $searchInput.position().left;
        xpos = getAbsoluteLeft($searchInput[0]);
        $autocompleteParrent.css('width', $searchInput[0].offsetWidth);//.css('width'));
        $autocomplete.css('width', $searchInput[0].offsetWidth);//.css('width'));
        $autocompleteParrent.css({
            'position': 'absolute',
            'left': (xpos) + "px",
            'top': (ypos + $searchInput[0].offsetHeight) + "px"
        });
        $autocomplete.addClass("combo-panel");
        $autocomplete.addClass("panel-body");
        $autocomplete.addClass("panel-body-noheader");
        setSelectedItem(0);
        //显示下拉列表 
        $autocompleteParrent.show();
    };
    //对输入框进行事件注册 
    $searchInput.keyup(function(event) {
        //字母数字，退格，空格 
        if (event.keyCode > 40 || event.keyCode == 8 || event.keyCode == 32) {
            //首先删除下拉列表中的信息 
            $autocomplete.empty();//.hide();
            $autocompleteParrent.hide();
            clearTimeout(timeoutid);
            timeoutid = setTimeout(ajax_request, 100);
        } else if (event.keyCode == 38) {
            //上 
            //selectedItem = -1 代表鼠标离开 
            if (selectedItem == -1) {
                setSelectedItem($autocomplete.find('li').length - 1);
            } else {
                //索引减1 
                setSelectedItem(selectedItem - 1);
            }
            event.preventDefault();
        } else if (event.keyCode == 40) {
            //下 
            //selectedItem = -1 代表鼠标离开 
            if (selectedItem == -1) {
                setSelectedItem(0);
            } else {
                //索引加1 
                setSelectedItem(selectedItem + 1);
            }
            event.preventDefault();
        }
    }).keypress(function(event) {
        //enter键 
        if (event.keyCode == 13) {
            //列表为空或者鼠标离开导致当前没有索引值 
            if ($autocomplete.find('li').length == 0 || selectedItem == -1) {
                return;
            }
            $searchInput.val($autocomplete.find('li').eq(selectedItem).text());
            $autocomplete.empty();//.hide();
            $autocompleteParrent.hide();
            event.preventDefault();
        }
    }).keydown(function(event) {
        //esc键 
        if (event.keyCode == 27) {
            $autocomplete.empty();//.hide();
            $autocompleteParrent.hide();
            event.preventDefault();
        }
    });
    //注册窗口大小改变的事件，重新调整下拉列表的位置 
    $(window).resize(function() {
        var ypos = $searchInput.position().top;
        ypos = getAbsoluteTop($searchInput[0]);
        var xpos = $searchInput.position().left;
        xpos = getAbsoluteLeft($searchInput[0]);
        $autocompleteParrent.css('width', $searchInput[0].offsetWidth);//.css('width'));
        $autocompleteParrent.css({
            'position': 'absolute',
            'left': (xpos + 8) + "px",
            'top': (ypos + $searchInput[0].offsetHeight) + "px"
        });
        $autocomplete.addClass("combo-panel");
        $autocomplete.addClass("panel-body");
        $autocomplete.addClass("panel-body-noheader");
    });
};

//获取控件上绝对位置
function getAbsoluteTop(o) {
    oTop = o.offsetTop;
    while(o.offsetParent!=null)
    {  
    oParent = o.offsetParent 
    oTop += oParent.offsetTop  // Add parent top position
    o = oParent
    }
    return oTop
}

//获取控件宽度
function getElementWidth(objectId) {
    x = document.getElementById(objectId);
    return x.offsetWidth;
}

//获取控件左绝对位置

function getAbsoluteLeft(o) {
    oLeft = o.offsetLeft            
    while(o.offsetParent!=null) { 
    oParent = o.offsetParent    
    oLeft += oParent.offsetLeft 
    o = oParent
    }
    return oLeft
}