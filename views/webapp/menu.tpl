<ul id="fmenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick="openChatPanel($(this).parent().data('user'));"><div>Send Message</div></li>
    <li onclick="reqUserData($(this).parent().data('user').who);"><div>Show Info</div></li>
    <li onclick="showModifyCommentPanel($(this).parent().data('user').who);"><div>Modify Comment</div></li>
    
    <li><div>Move To Group</div>
        <ul id="movetogrouplist">
            <li onclick=""><div>秦时明月</div></li>
            <li onclick=""><div>Utilities</div></li>
        </ul>
    </li>
    <li onclick="if (confirm('确认要删除该好友吗？')==false){return;};delFriend($(this).parent().data('user').who);removeFriendItem($(this).parent().data('user'));"><div>Delete</div></li>
    <li onclick="reqAddBlack($(this).parent().data('user').who);"><div>Add To Black</div></li>
</ul>

<ul id="gmenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick="showAddGroupPanel();"><div>Create New Group</div></li>
    <li onclick="showRenameGroupPanel($(this).parent().data('groupname'));"><div>Rename Group</div></li>

    <li onclick="if (confirm('确认要该分组吗？')==false){return;};reqDeleteGroup($(this).parent().data('groupname'));"><div>Delete Group</div></li>
</ul>

<ul id="bodymenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick="showAddGroupPanel();"><div>Create New Group</div></li>
    <li onclick="reqFriendList();"><div>Refresh Friend List</div></li>
</ul>

<ul id="roommenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick="openRoomChatPanel($(this).parent().data('room'));"><div>Send Message</div></li>
    <li onclick="showRoomInfoPanel($(this).parent().data('room'));"><div>Show Info</div></li>
    <li class="quitroom" onclick="reqQuitRoom($(this).parent().data('room').rid);"><div>Quit Room</div></li>
    
    <li onclick="if (confirm('确认要删除该房间？这将移除房间所有成员')==false){return;};reqDeleteRoom($(this).parent().data('room').rid);"><div>Delete</div></li>
    <li onclick="reqRoomList();"><div>Refresh Room List</div></li>
</ul>

<style>
  .ui-menu { width: 150px; }
</style>

<script>
    var allMenus = ["fmenu", "gmenu", "bodymenu", "roommenu"];
    $( function() {
        // $( "#fmenu" ).menu();
        // $( "#gmenu" ).menu();
        // $( "#bodymenu" ).menu();
        // $( "#roommenu" ).menu();
        for(var i in allMenus) {
            $('#'+allMenus[i]).menu();
        }
    } );

    function showFriendMenu(e, data) {
        var menu = $( "#fmenu" );
        menu.removeClass("hide");
        menu.data("user", data);
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);

        $("#movetogrouplist").html("");
        for(var group in frienddata) {
            if(group != data.groupname) {
                $("#movetogrouplist").append('<li onclick="reqMoveToGroup(\'' + data.who + '\', \'' + group + '\');"><div>' + group + '</div></li>');
            }
        }
        $( "#fmenu" ).menu("refresh");
    }

    function showGroupMenu(e, data) {
        var menu = $( "#gmenu" );
        menu.removeClass("hide");
        menu.data("groupname", data);
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);
    }

    function showBodyMenu(e) {
        var menu = $( "#bodymenu" );
        menu.removeClass("hide");
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);
    }

    function showRoomMenu(e, data) {
        var menu = $( "#roommenu" );
        menu.data("room", data);
        menu.removeClass("hide");
        menu.css("top", e.clientY);
        menu.css("left", e.clientX);
        if(data.ownerid == userdata.id){
            menu.find(".quitroom").addClass("hide");
        } else {
            menu.find(".quitroom").removeClass("hide");
        }
    }

    function stopPropagation(e) {
        if (e.stopPropagation) 
            e.stopPropagation();//停止冒泡  非ie
        else 
            e.cancelBubble = true;//停止冒泡 ie
    }

    function hideAllMenus() {
        for(var i in allMenus) {
            $('#'+allMenus[i]).addClass("hide");
        }
    }

    function isMenu(eid) {
        for(var i in allMenus) {
            if(allMenus[i] == eid)
                return true;
        }
    }

    $(document).bind('mousedown',function(e){
        //$('#fmenu').addClass("hide");

        var e = e || window.event; //浏览器兼容性
        //console.info(e);
        var elem = e.target || e.srcElement;
        while (elem) { //循环判断至跟节点，防止点击的是div子元素
            if (elem.id && isMenu(elem.id)) {
                return;
            }

            elem = elem.parentNode;
        }
        hideAllMenus();
    });
    $(document).bind('click',function(e){
        //$('#fmenu').addClass("hide");

        var e = e || window.event; //浏览器兼容性
        var elem = e.target || e.srcElement;
        while (elem) { //循环判断至跟节点，防止点击的是div子元素
            if (elem.id && isMenu(elem.id)) {
                hideAllMenus();
                return;
            }

            elem = elem.parentNode;
        }
    });
    document.oncontextmenu = function(){return false};   //禁止鼠标右键菜单显示
</script>