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
            <h6 class="modal-title">Add Friend</h6>
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

<script>
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

function showAddGroupPanel() {
    $("#modal-addgroup").modal("show");
}

function showRenameGroupPanel(groupname) {
    $("#oldgroupname").val(groupname);
    $("#modal-renamegroup").modal("show");
}
</script>