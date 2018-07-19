<div class="modal fade" id="modal-addgroup" style="display: none;">
    <div class="modal-dialog" style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
            <h6 class="modal-title">Add Friend</h6>
            </div>
            <div class="modal-body">
                <label>GroupName</label>
                <input id="groupname" type="text" class="form-control" placeholder="Enter GroupName...">
                
                <button onclick='doAddGroup();' type="button" class="btn btn-primary">Add</button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
            </div>
        </div>
    <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-renamegroup" style="display: none;">
    <div class="modal-dialog" style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
            <h6 class="modal-title">Rename Group</h6>
            </div>
            <div class="modal-body">
                <label>OldGroupName</label>
                <input id="oldgroupname" type="text" class="form-control" disabled>

                <label>NewGroupName</label>
                <input id="newgroupname" type="text" class="form-control" placeholder="Enter NewGroupName...">
                
                <button onclick='doRenameGroup();' type="button" class="btn btn-primary">Rename</button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
            </div>
        </div>
    <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-modifycomment" style="display: none;">
    <div class="modal-dialog" style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
            <h6 class="modal-title">Modify Friend Comment</h6>
            </div>
            <div class="modal-body">
                <label>Comment</label>
                <input id="modifycomment" type="text" class="form-control" placeholder="Enter Comment...">
                
                <button onclick='doModifyComment();' type="button" class="btn btn-primary">Modify</button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
            </div>
        </div>
    <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="modal-info" style="display: none;">
    <div class="modal-dialog" style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
            <h6 class="modal-title">User Info</h6>
            </div>
            <div class="modal-body">
                <label>ID</label>
                <input id="info-id" type="text" class="form-control" disabled>
                <label>Nickname</label>
                <input id="info-nickname" type="text" class="form-control">
                <label>Desc</label>
                <input id="info-desc" type="text" class="form-control">
                <label>Birthday</label>
                <input id="info-birthday" type="text" class="form-control">
                <label>Country</label>
                <input id="info-country" type="text" class="form-control">
                
                <button onclick='doUpdateAppData();' type="button" class="btn btn-primary">Save</button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
            </div>
        </div>
    <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<script>
$( function() {
    $( "#info-birthday" ).datepicker();
    $("#info-country").countrySelect();
} );

function doAddGroup(){
    var groupname = $("#groupname").val();
    if(groupname == "") {
        alert("groupname should not be empty!");
        return;
    }
    reqCreateGroup(groupname);
    $("#modal-addgroup").modal("hide");
}

function doRenameGroup(){
    var newgroupname = $("#newgroupname").val();
    if(newgroupname == "") {
        alert("newgroupname should not be empty!");
        return;
    }
    reqRenameGroup($("#oldgroupname").val(), newgroupname);
    $("#modal-renamegroup").modal("hide");
}

function doModifyComment(){
    var modifycomment = $("#modifycomment").val();
    if(modifycomment == "") {
        alert("modifycomment should not be empty!");
        return;
    }
    modifyFriendComment($("#modifycomment").data('id'), modifycomment);
    $("#modal-modifycomment").modal("hide");
}

function doUpdateAppData(){
    var nickname = $("#info-nickname").val();
    if(nickname == "") {
        alert("nickname should not be empty!");
        return;
    }
    var desc = $("#info-desc").val();
    var birthday = $("#info-birthday").val();
    var country = $("#info-country").val();

    var udata = $("#modal-info").data("user");

    var flag = false;
    var jsondata = {};
    if(udata.nickname != nickname){
        jsondata["nickname"] = nickname;
        flag = true;
    }
    if(udata.desc != desc){
        jsondata["desc"] = desc;
        flag = true;
    }
    if(udata.birthday != birthday){
        jsondata["birthday"] = birthday;
        flag = true;
    }
    if(udata.country != country){
        jsondata["country"] = country;
        flag = true;
    }
    updateAppdata(jsondata);
    $("#modal-info").modal("hide");
}

function showAddGroupPanel() {
    $("#modal-addgroup").modal("show");
}

function showRenameGroupPanel(groupname) {
    $("#oldgroupname").val(groupname);
    $("#modal-renamegroup").modal("show");
}

function showModifyCommentPanel(idstr) {
    $("#modifycomment").data('id', idstr);
    $("#modal-modifycomment").modal("show");
}

function showUserInfoPanel(jsondata) {
    $("#modal-info .modal-title").html("User Info-<b>" + jsondata.nickname + "</b>");
    $("#info-id").val(jsondata.id);
    $("#info-nickname").val(jsondata.nickname);
    $("#info-desc").val(jsondata.desc);
    $("#info-birthday").val(jsondata.birthday);
    $("#info-country").val(jsondata.country);
    if(userdata.id != jsondata.id) {
        $("#info-nickname").attr("disabled", true);
        $("#info-desc").attr("disabled", true);
        $("#info-birthday").attr("disabled", true);
        $("#info-country").attr("disabled", true);
    } else {
        $("#info-nickname").attr("disabled", false);
        $("#info-desc").attr("disabled", false);
        $("#info-birthday").attr("disabled", false);
        $("#info-country").attr("disabled", false);
    }
    $("#info-country").countrySelect("refresh");
    $("#modal-info").data("user", jsondata);
    $("#modal-info").modal("show");
}
</script>