{{template "header.tpl" .}}

<div class="row">
<div class="col-5">
</div>
<div class="col-2 list-group" style="position:absolute;top:30%;left:50%; transform:translate(-50%, -50%);">
  <a href="app" class="list-group-item list-group-item-action text-center">
    我的应用
  </a>
  <a href="data" class="list-group-item list-group-item-action text-center">
    我的应用数据
  </a>

  <a href="/admin/account/index" class="list-group-item list-group-item-action text-center mt-4">
    用户管理
  </a>
  <a href="/admin/appdata/index" class="list-group-item list-group-item-action text-center">
    应用管理
  </a>
  <a href="data" class="list-group-item list-group-item-action text-center">
    数据管理
  </a>
  <a href="data" class="list-group-item list-group-item-action text-center">
    在线玩家管理
  </a>
</div>
<div class="col-5">
</div>
</div>

{{template "footer.tpl" .}}