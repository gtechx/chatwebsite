<div class="col-md-3" id="fpanel">
  <div id="fpanelpart" class="box box-warning box-solid">
    <div class="overlay hide">
      <i class="fa fa-refresh fa-spin"></i>
    </div>
    <div class="box-header with-border" id="fpanelheader">
      <h3 class="box-title">Collapsable</h3>

      <div class="box-tools pull-right hide">
        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
        </button>
      </div>
      <!-- /.box-tools -->
    </div>
    <!-- /.box-header -->
    <div id="fpanelbody" class="box-body">
        <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->
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

    $("#fpanelbody").append(createGroup("GroupC"));
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
                <!-- Custom Tabs -->
                <div class="nav-tabs-custom">
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="#tab_1" data-toggle="tab">ID</a></li>
                        <li><a href="#tab_2" data-toggle="tab">Nickname</a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">
                            <div class="form-group">
                            <label>ID</label>
                            <input id="ID" type="text" class="form-control" placeholder="Enter id...">
                            </div>
                            
                            <button type="button" class="btn btn-primary">Add</button>
                        </div>
                        <!-- /.tab-pane -->
                        <div class="tab-pane" id="tab_2">
                            <div class="form-group">
                            <label>Nickname</label>
                            <input id="nickname" type="text" class="form-control" placeholder="Enter nickname...">
                            </div>
                            <button type="button" class="btn btn-primary">Add</button>
                        </div>
                        <!-- /.tab-pane -->
                    </div>
                    <!-- /.tab-content -->
                </div>
                <!-- nav-tabs-custom -->
                
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
            </div>
        </div>
    <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
