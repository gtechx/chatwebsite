<div class="col-md-3" id="fpanel">
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

                <div class="tab-pane" id="tab_friend" style="max-height:400px;overflow-y:auto;">
                            
                </div>
                <!-- /.tab-pane -->
                <div class="tab-pane" id="tab_presence" style="max-height:400px;overflow-y:auto;">
                    <ul class="products-list product-list-in-box">
                        <li class="item">
                            <div class="">
                                <a href="javascript:void(0)" class="product-title">ID:222222 request friend
                                <span class="label label-warning pull-right">2018/9/10</span></a>
                                <span class="product-description">
                                Samsung 32" 1080p 60Hz LED Smart HDTV.
                                </span>
                                <button>add</button>
                                <button>refuse</button>
                            </div>
                        </li>
                        <li class="item">
                            <div class="">
                                <a href="javascript:void(0)" class="product-title">ID:222222 request friend
                                <span class="label label-warning pull-right">2018/9/10</span></a>
                                <span class="product-description">
                                Samsung 32" 1080p 60Hz LED Smart HDTV.
                                </span>
                                <button>add</button>
                                <button>refuse</button>
                            </div>
                        </li>
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
    } );

    function createGroup(name) {
        //var div = document.createElement("div");
        //div.addClass("box box-primary collapsed-box");

        var html = '<div class="box box-primary collapsed-box">\
            <div class="box-header with-border">\
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
            </div>\
        </div>';

        //div.append(html);
        return html;
    }

    function createContactItem(data) {
        var html = '<li>\
            <a href="#">\
            <img class="contacts-list-img" src="static/dist/img/user1-128x128.jpg" alt="User Image">\
            <div class="contacts-list-info">\
                    <span class="contacts-list-name text-black">';
        html += data.name;//     Count Dracula
        html +=     '</span>\
                <span class="contacts-list-msg">';
        html += data.desc + '</span>\
            </div>\
            </a>\
        </li>';
        return html;
    }

$("#tab_friend").append(createGroup("GroupC1"));
$("#tab_friend").append(createGroup("GroupC2"));
$("#tab_friend").append(createGroup("GroupC3"));
$("#tab_friend").append(createGroup("GroupC4"));
$("#tab_friend").append(createGroup("GroupC5"));
$("#tab_friend").append(createGroup("GroupC6"));
$("#tab_friend").append(createGroup("GroupC7"));
$("#tab_friend").append(createGroup("GroupC8"));
    $("#tab_friend").append(createGroup("GroupC"));
    $("#groupGroupC").append(createContactItem({name:"WYQ", desc:"How are you?"}));
    $("#groupGroupC").append(createContactItem({name:"WLN", desc:"How are you?"}));
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
                    <input id="ID" type="text" class="form-control" placeholder="Enter id...">
                    <label>Message</label>
                    <input id="message" type="text" class="form-control" placeholder="Enter message...">
                    </div>
                    
                    <button type="button" class="btn btn-primary">Add</button>
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
