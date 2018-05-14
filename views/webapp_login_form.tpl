<div style="position:absolute;top:30%;left:50%; transform:translate(-50%, -50%);">  

{{if .post}}
    {{if .error}}
    <div class="alert alert-danger">登录失败：{{str2html .error}}</div>
    <br/>
    {{end}}
{{end}}
<form>
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
    <input type="text" class="form-control" name="account" id="account" placeholder="Account">
  </div>
  <div class="form-group">
    <label for="password1">密码：</label>
    <input type="password" class="form-control" name="password1" id="password1" placeholder="Password" oninput="document.getElementById('password').value = this.value;" onpropertychange="document.getElementById('password').value = this.value;">
    <input type="hidden" name="password" id="password" />
  </div>
  <button onclick="return false;" class="btn btn-outline-primary btn-lg btn-block">登录</button>
</form>

<script type="text/javascript">
  $( function() {
    onAppnameChange(document.getElementsByName( "appname" )[0]);
  } );
  function onAppnameChange(obj) {
      if(obj.selectedIndex == -1)
        return;
      var opt = obj.options[obj.selectedIndex];
      console.info("text:"+opt.text);
      console.info("value:"+opt.value);

      $.post("/webapp/zonelist", {'appname': $('#appname').val()},
      function(data) {
        console.info(data);
        var jsondata = JSON.parse(data);
        console.info(jsondata["rows"]);
        var liststr = '';
        var count = jsondata["total"];
        var html = "";
        for (i in jsondata["rows"])
        {
            var row = jsondata["rows"][i];
            html += '<option>' + row.zonename + '</option>';
        }
        $('#zonename').html(html);
      });
  }
  </script>

</div>
