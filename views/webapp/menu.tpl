<ul id="fmenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick="openChatPanel($(this).parent().data('user'));"><div>Send Message</div></li>
    <li onclick=""><div>Show Data</div></li>
    <li onclick=""><div>Modify Comment</div></li>
    
    <li><div>Move To Group</div>
        <ul>
            <li onclick=""><div>Car Hifi</div></li>
            <li onclick=""><div>Utilities</div></li>
        </ul>
    </li>
    <li onclick="if (confirm('确认要该好友吗？')==false){return;};delFriend($(this).parent().data('user').who);removeFriendItem($(this).parent().data('user'));"><div>Delete</div></li>
</ul>

<ul id="gmenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick=""><div>Create New Group</div></li>
    <li onclick=""><div>Rename Group</div></li>

    <li onclick="if (confirm('确认要该分组吗？')==false){return;};delFriend($(this).parent().data('user').who);removeFriendItem($(this).parent().data('user'));"><div>Delete Group</div></li>
</ul>

<ul id="bodymenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick=""><div>Create New Group</div></li>
    <li onclick="reqFriendList();"><div>Refresh Friend List</div></li>
</ul>

<script>
    $( function() {
        $( "#fmenu" ).menu();
        $( "#gmenu" ).menu();
        $( "#bodymenu" ).menu();
    } );

    function showFriendMenu(e, data) {
        var menu = $( "#fmenu" );
        menu.removeClass("hide");
        menu.data("user", data);
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);
    }

    function showGroupMenu(e, data) {
        var menu = $( "#gmenu" );
        menu.removeClass("hide");
        menu.data("group", data);
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);
    }

    function showBodyMenu(e) {
        var menu = $( "#bodymenu" );
        menu.removeClass("hide");
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);
    }

    function stopPropagation(e) {
        if (e.stopPropagation) 
            e.stopPropagation();//停止冒泡  非ie
        else 
            e.cancelBubble = true;//停止冒泡 ie
    }

    $(document).bind('mousedown',function(e){
        //$('#fmenu').addClass("hide");

        var e = e || window.event; //浏览器兼容性
        //console.info(e);
        var elem = e.target || e.srcElement;
        while (elem) { //循环判断至跟节点，防止点击的是div子元素
            if (elem.id && (elem.id=='fmenu' || elem.id=='gmenu' || elem.id=='bodymenu')) {
                return;
            }

            elem = elem.parentNode;
        }
        $('#fmenu').addClass("hide"); //点击的不是div或其子元素
        $('#gmenu').addClass("hide");
        $('#bodymenu').addClass("hide");
    });
    $(document).bind('click',function(e){
        //$('#fmenu').addClass("hide");

        var e = e || window.event; //浏览器兼容性
        var elem = e.target || e.srcElement;
        while (elem) { //循环判断至跟节点，防止点击的是div子元素
            if (elem.id && (elem.id=='fmenu' || elem.id=='gmenu' || elem.id=='bodymenu')) {
                $('#fmenu').addClass("hide");
                $('#gmenu').addClass("hide");
                return;
            }

            elem = elem.parentNode;
        }
    });
    document.oncontextmenu = function(){return false};   //禁止鼠标右键菜单显示
</script>