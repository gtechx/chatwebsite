<div class="col-md-3 hide" id="fpanel">
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