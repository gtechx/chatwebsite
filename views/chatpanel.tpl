<div class="col-md-3 hide" id="chatpanel">
    <!-- DIRECT CHAT PRIMARY -->
    <div class="box box-primary direct-chat direct-chat-primary">
        <div class="box-header with-border">
            <h2 class="box-id hide">Direct Chat</h2>
            <h3 class="box-title">Direct Chat</h3>

            <div class="box-tools pull-right">
                <span data-toggle="tooltip" title="" class="badge bg-light-blue hide" data-original-title="3 New Messages">3</span>
                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                </button>
                <button type="button" class="btn btn-box-tool hide" data-toggle="tooltip" title="" data-widget="chat-pane-toggle" data-original-title="Contacts">
                    <i class="fa fa-comments"></i>
                </button>
                <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
            </div>
        </div>
        <!-- /.box-header -->
        <div class="box-body">
            <!-- Conversations are loaded here -->
            <div class="direct-chat-messages">
            </div>
            <!--/.direct-chat-messages-->
        </div>
        <!-- /.box-body -->
        <div class="box-footer">
            <div class="input-group">
                <input type="text" id="msginput" name="message" placeholder="Type Message ..." class="form-control" />
                    <span class="input-group-btn">
                    <button type="submit" onclick="startSendMessage();" class="btn btn-primary btn-flat">Send</button>
                    </span>
            </div>
        </div>
        <!-- /.box-footer-->
    </div>
    <!--/.direct-chat -->
</div>

<script>
$( function() {
    // $( "#chatpanel" ).draggable({handle: "#chatpanelheader", cursor: "move"});
    // $("#chatpanelpart").resizable({handles: "se", minWidth: 250, maxWidth:500, minHeight:500, maxHeight:650});
    // $("#chatpanelpart").css("height", 500).css("width", 250);
    $(".direct-chat .box-header h3").html("Title");
    $( "#chatpanel" ).draggable({handle: ".direct-chat .box-header", cursor: "move"});
} );

function getChatTitle() {
    return $(".direct-chat .box-header h3").html();
}

function getChatId() {
    return $(".direct-chat .box-header h2").html();
}

function addMessage(msg) {
    var html = '<div class="direct-chat-msg">' +
        '<div class="direct-chat-info clearfix">' +
            '<span class="direct-chat-name pull-left">' + msg.name + '</span>' +
            '<span class="direct-chat-timestamp pull-right">' + msg.time + '</span>' +
        '</div>' +
        '<img class="direct-chat-img" src="static/dist/img/user1-128x128.jpg" alt="Message User Image">' +
        '<div class="direct-chat-text">'+
            msg.text + 
        '</div>'+
    '</div>';

    $(".direct-chat-messages").append(html);
}

function sendMessage(msg) {
    var html = '<div class="direct-chat-msg right">' +
        '<div class="direct-chat-info clearfix">' +
            '<span class="direct-chat-name pull-right">' + msg.name + '</span>' +
            '<span class="direct-chat-timestamp pull-left">' + msg.time + '</span>' +
        '</div>' +
        '<img class="direct-chat-img" src="static/dist/img/user1-128x128.jpg" alt="Message User Image">' +
        '<div class="direct-chat-text">'+
            msg.text + 
        '</div>'+
    '</div>';

    $(".direct-chat-messages").append(html);

    //console.info($(".direct-chat-msg:last").scrollTop());
    $(".direct-chat-messages").scrollTop(9999);
}
addMessage({name:"WYQ", time:"2018/6/11", text:"Hello, How are you?"});
sendMessage({name:"WLN", time:"2018/6/11", text:"Hello, I'm fine."});

function startSendMessage() {
    var text = $("#msginput").val();

    var msg = {};
    msg.name = "WYQ";
    msg.time = new Date().Format("yyyy/MM/dd hh:mm:ss");
    msg.text = text;

    sendMessage(msg);
    $("#msginput").val("");
}

Date.prototype.Format = function (fmt) { // author: meizz
    if(fmt == "" || fmt == undefined)
        fmt = "yyyy/MM/dd hh:mm:ss";
    var o = {
        "M+": this.getMonth() + 1, // 月份
        "d+": this.getDate(), // 日
        "h+": this.getHours(), // 小时
        "m+": this.getMinutes(), // 分
        "s+": this.getSeconds(), // 秒
        "q+": Math.floor((this.getMonth() + 3) / 3), // 季度
        "S": this.getMilliseconds() // 毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return fmt;
}
</script>