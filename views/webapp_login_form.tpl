<div id="loginpanel" style="position:absolute;top:40%;left:50%; transform:translate(-50%, -50%);">  

<div id="loading" class="loader-inner line-scale d-flex justify-content-center">
  <div class="bg-info"></div>
  <div class="bg-info"></div>
  <div class="bg-info"></div>
  <div class="bg-info"></div>
  <div class="bg-info"></div>
</div>
<br/>
{{if .post}}
    {{if .error}}
    <div class="alert alert-danger">登录失败：{{str2html .error}}</div>
    <br/>
    {{end}}
{{end}}
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
    <input type="text" class="form-control" name="account" id="account" placeholder="Account" value="{{.appaccount}}">
  </div>
  <div class="form-group">
    <label for="password1">密码：</label>
    <input type="password" class="form-control" name="password1" id="password1" placeholder="Password" oninput="document.getElementById('password').value = this.value;" onpropertychange="document.getElementById('password').value = this.value;">
    <input type="hidden" name="password" id="password" />
  </div>
  <button onclick="login(); return false;" class="btn btn-outline-primary btn-lg btn-block">登录</button>
</form>
<div id="sse">
         <input id="msg" type="textarea"></input>
		 <button onclick="sendmsg();">send</button>
      </div>
</div>