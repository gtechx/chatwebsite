<div style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">  

<div id="loading" class="loader-inner line-scale d-flex justify-content-center">
  <div class="bg-info"></div>
  <div class="bg-info"></div>
  <div class="bg-info"></div>
  <div class="bg-info"></div>
  <div class="bg-info"></div>
</div>
<br/>

    <div class="alert alert-danger d-none" id="error">dfdddd</div>
    <br/>

<div id="loginpanel">
<form class="animated" onsubmit="return false;">
  <div class="form-group">
    <label for="appname">选择应用：</label>
    <select class="form-control" onchange="onAppnameChange(this);" name="appname" id="appname">
        {{range $index, $elem := .applist}}
        <option>{{$elem.Appname}}</option>
        {{end}}
    </select>
  </div>
  <div class="form-group">
    <label for="zonename">选择分区：</label>
    <select class="form-control" name="zonename" id="zonename">
        <option></option>
    </select>
  </div>
  <div class="form-group">
    <label for="account">账号：</label>
    <input type="text" class="form-control" name="account" id="account" placeholder="Account" value="{{if .appaccount}}{{.appaccount}}{{else}}wyq{{end}}" />
  </div>
  <div class="form-group">
    <label for="password1">密码：</label>
    <input type="password" class="form-control" name="password1" id="password1" placeholder="Password" oninput="document.getElementById('password').value = this.value;" onpropertychange="document.getElementById('password').value = this.value;" value="123" />
    <input type="hidden" name="password" id="password" value="123" />
  </div>
  <button onclick="dologin(); return false;" class="btn btn-outline-primary btn-lg btn-block">登录</button>
</form>
      <div id="sse">
          <input id="msg" type="textarea" />
		      <button onclick="sendmsg();">send</button>
      </div>
  <script type="text/javascript">
    $(function () {
      onAppnameChange(document.getElementsByName("appname")[0]);
    });

    function onAppnameChange(obj) {
      if (obj.selectedIndex == -1)
        return;
      var opt = obj.options[obj.selectedIndex];

      $.post("/webapp/zonelist", { 'appname': $('#appname').val() },
        function (data) {
          var jsondata = JSON.parse(data);
          var liststr = '';
          var count = jsondata["total"];
          var html = "";
          for (i in jsondata["rows"]) {
            var row = jsondata["rows"][i];
            html += '<option>' + row.zonename + '</option>';
          }
          $('#zonename').html(html);
        });
    };

    function dologin() {
      login($('#account').val(), $('#password').val(), $('#appname').val(), $('#zonename').val());
    }
  </script>
  </div>

  <div id="idselect" class="d-none">
    <div id="idlist" class="list-group">
    </div>
    <button onclick="quitChat();" class="btn btn-outline-primary btn-lg btn-block">退出聊天</button>
  </div>
</div>



