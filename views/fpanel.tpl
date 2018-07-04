<div class="col-md-3 hide" id="fpanel" style="position:absolute;">
  <div id="fpanelpart" class="box box-warning box-solid">
    <div class="overlay hide">
      <i class="fa fa-refresh fa-spin"></i>
    </div>
    <div class="box-header with-border" id="fpanelheader">
      <h3 class="box-title">Collapsable</h3>

      
      <!-- /.box-tools -->
    </div>
    <!-- /.box-header -->
    <div id="fpanelbody" class="box-body" style="padding:2px;width:100%;">
        <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->
        <!-- Custom Tabs -->
        <div style="width:100%;margin-bottom:2px;" class="btn-group" data-toggle="buttons">
        <button style="width:50%;" class="btn btn-primary active" id="btn_friend" onclick="$('#tab_presence').hide('slide', {direction:'right'});$('#tab_friend').show('slide', {direction:'left'});">
            <span>6</span><input type="radio" autocomplete="off" checked /> <i class="fa fa-users"></i>
        </button>
        <button style="width:50%;" class="btn btn-primary" id="btn_presence" onclick="$('#tab_friend').hide('slide', {direction:'left'});$('#tab_presence').show('slide', {direction:'right'});">
            <span>6</span><input type="radio" autocomplete="off" /> <i class="fa fa-comments"></i>
        </button>
      </div>

                <div class="tab-pane dragscroll" id="tab_friend" style="max-height:390px;overflow-y:auto;position:absolute;width:245px;">
                            
                </div>
                <!-- /.tab-pane -->
                <div class="tab-pane" id="tab_presence" style="max-height:390px;overflow-y:auto;position:absolute;width:245px;">
                    <ul id="presencelist" class="products-list product-list-in-box">
                        
                    </ul>
                </div>
                <!-- /.tab-pane -->
    </div>
  <!-- /.box-body -->
    <div class="bg-yellow-gradient" style="width:100%;position:absolute;bottom:0;">
        <button type="button" class="btn btn-box-tool" data-toggle="modal" data-target="#modal-add"><i class="fa fa-plus"></i></button>
        <button type="button" class="btn btn-box-tool"><i class="fa fa-search"></i></button>
    </div>
  </div>
  
</div>

<script>
    $( function() {
        $( "#fpanel" ).draggable({handle: "#fpanelheader", cursor: "move"});
        $("#fpanelpart").resizable({handles: "se", minWidth: 250, maxWidth:500, minHeight:500, maxHeight:650});
        $("#fpanelpart").css("height", 500).css("width", 250);
        $('#tab_presence').hide();
        $('#tab_friend').show('slide');
        //$('#btn_friend').addClass('active');
        $( "#radio" ).controlgroup();

        // $('#tab_friend').slimScroll({
        //         height: '500px'
        //     });
    } );

    function createGroup(name) {
        var div = $(document.createElement("div"));
        div.addClass("box box-primary collapsed-box");
        div.boxWidget();

        //var html = '<div class="box box-primary collapsed-box">\
        var html = '<div class="box-header with-border">\
                <h3 class="box-title">';
        html += name;
        html += '</h3>\
                <div class="box-tools pull-right">\
                    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>\
                    </button>\
                </div>\
            </div>\
            <div class="box-body" style="">\
                <ul id="';
        html += 'group' + name;
        html += '" class="contacts-list">\
                </ul>\
            </div>';
        //</div>';

        div.append(html);
        return div;
    }

    function createContactItem(data) {
        var li = $(document.createElement("li"));
        li.data("user", data);
        li.dblclick(function(){
            openChatPanel(data);
        });
        li.mouseup(function(e){
            if(e.button===2){
                showFriendMenu(e, data);
                stopPropagation(e);//调用停止冒泡方法,阻止document方法的执行
            }
        });
        //var html = '<li>\
        var html = '<a href="#">\
            <img class="contacts-list-img" src="static/dist/img/user1-128x128.jpg" alt="User Image">\
            <div class="contacts-list-info">\
                    <span class="contacts-list-name text-black">';
        html += data.nickname;//     Count Dracula
        html +=     '</span>\
                <span class="contacts-list-msg">';
        html += data.desc + '</span>\
            </div>\
            </a>';
        //</li>';
        li.append(html);
        return li;
    }

    var groups = {};
    function addFriendItem(data) {
        var group = groups[data.group];
        if(group == null){
            group = createGroup(data.group);
            groups[data.group] = group;
        }
        $("#tab_friend").append(group);
        group.find('ul').append(createContactItem(data));
    }

    function createPresence(data) {
        var newDate=new Date(parseInt(data.timestamp) * 1000);
        //var html = '<li class="item"> \
        var html = '';
        if(data.presencetype == PresenceType.PresenceType_Subscribe)
            html += '<div>friend request:</div>';
        else if(data.presencetype == PresenceType.PresenceType_Subscribed)
            html += '<div>friend agree:</div>';
        else if(data.presencetype == PresenceType.PresenceType_Unsubscribe)
            html += '<div>friend delete:</div>';
        else if(data.presencetype == PresenceType.PresenceType_Unsubscribed)
            html += '<div>friend refuse:</div>';
        else if(data.presencetype == PresenceType.PresenceType_Available)
            html += '<div>friend online:</div>';
        else if(data.presencetype == PresenceType.PresenceType_Unavailable)
            html += '<div>friend offline:</div>';
        else if(data.presencetype == PresenceType.PresenceType_Invisible)
            html += '<div>friend hidden:</div>';
        else
            return null;
        html += '<a href="javascript:void(0)" class="product-title">';
        html += 'ID:' + data.who + ' nickname:' + data.nickname;
        html += '</a>';
        
        if(data.presencetype == PresenceType.PresenceType_Subscribe){
            html += '<span class="product-description">';
            html += data.message;
            html += '</span> <span>\
                <button onclick="agreeFriend(\''+data.who+'\');$(this).parent().html(\'agreed\');">add</button> \
                <button onclick="refuseFriend(\''+data.who+'\');$(this).parent().html(\'refused\');">refuse</button></span>';
        }
            
        html += '<span class="label label-warning pull-left">' + newDate.Format() + '</span></a>';
        //</li>';

        var li = $(document.createElement("li"));
        li.data("user", data);
        li.addClass("item");
        li.append(html);

        return li;
    }

    function addPresence(data) {
        var presence = createPresence(data);
        $("#presencelist").prepend(presence);
    }

    addFriendItem({nickname:"WYQ", desc:"How are you?", group:"GroupC"});
    addFriendItem({nickname:"WLN", desc:"How are you?", group:"GroupC"});
    addFriendItem({"dataid":4, "nickname":"WLN", "desc":"How are you?", "group":"GroupC1","comment":""});

    addPresence({presencetype:0, who:"123456", nickname:"wyq", timestamp:"1529994598", message:"Hello, friend please"});
    addPresence({presencetype:1, who:"523455", nickname:"wln", timestamp:"1529994598", message:"Hello, friend please"});

    function showFriendMenu(e, data) {
        var menu = $( "#fmenu" );
        menu.removeClass("hide");
        menu.data("user", data);
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
            if (elem.id && elem.id=='fmenu') {
                return;
            }

            elem = elem.parentNode;
        }
        $('#fmenu').addClass("hide"); //点击的不是div或其子元素
    });
    $(document).bind('click',function(e){
        //$('#fmenu').addClass("hide");

        var e = e || window.event; //浏览器兼容性
        var elem = e.target || e.srcElement;
        while (elem) { //循环判断至跟节点，防止点击的是div子元素
            if (elem.id && elem.id=='fmenu') {
                $('#fmenu').addClass("hide");
                return;
            }

            elem = elem.parentNode;
        }
    });
    document.oncontextmenu = function(){return false};   //禁止鼠标右键菜单显示
</script>

<div class="modal fade" id="modal-add" style="display: none;">
    <div class="modal-dialog" style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
            <h6 class="modal-title">Add Friend</h6>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>ID</label>
                    <input id="ID" type="text" value="3" class="form-control" placeholder="Enter id...">
                    <label>Message</label>
                    <input id="message" type="text" value="hello!" class="form-control" placeholder="Enter message...">
                    </div>
                    
                    <button onclick='addFriend($("#ID").val(), $("#message").val());$("#modal-add").modal("hide");' type="button" class="btn btn-primary">Add</button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
            </div>
        </div>
    <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<ul id="fmenu" class="hide" style="position:absolute;z-index:9999;">
    <li onclick="openChatPanel($(this).parent().data('user'));"><div>Send Message</div></li>
    <li onclick=""><div>Show Data</div></li>
    <li onclick=""><div>Modify Comment</div></li>
    
    <li><div>Move To Group</div>
        <ul>
            <li class="ui-state-disabled"><div>Home Entertainment</div></li>
            <li onclick="$('#fmenu').addClass('hide');"><div>Car Hifi</div></li>
            <li onclick="$('#fmenu').addClass('hide');"><div>Utilities</div></li>
        </ul>
    </li>
    <li onclick=""><div>Delete</div></li>
</ul>

<script>
    $( function() {
        $( "#fmenu" ).menu();
    } );
</script>