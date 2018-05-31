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
<script type="text/javascript">
  
  $( function() {
    onAppnameChange(document.getElementsByName( "appname" )[0]);
  } );
  function onAppnameChange(obj) {
    if(obj.selectedIndex == -1)
      return;
    var opt = obj.options[obj.selectedIndex];

    $.post("/webapp/zonelist", {'appname': $('#appname').val()},
    function(data) {
      var jsondata = JSON.parse(data);
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
  };

  var client = null;
  function login() {
    client = WsClient.new("127.0.0.1:9090");
    client.onopen = function () {
      console.info("connect success")
    }
    client.onclose = function () {
      console.info("disconnect")
    }
    client.onerror = function (evt) {
      console.info("error " + evt)
    }
    client.setHeaderParser(headerParser);
    client.setMsgParser(msgParser);
    client.connect();
  };

  function headerParser(buffer) {
    var dataView = new DataView(buffer);
    console.info("recv datasize:" + dataView.getInt16(0, true));
    return dataView.getInt16(0, true);
  };

  function msgParser(buffer) {
    var dataView = new DataView(buffer);
    var int8View = new Int8Array(buffer);
    var str = new TextDecoder("utf-8").decode(buffer);
    console.info("recv msg:" + str);
  }

  function sendmsg(){
			var msg = document.getElementById("msg").value;
      console.info("send:" + msg);
			let uint8Array = new TextEncoder("utf-8").encode(msg);
			var buffer = new ArrayBuffer(uint8Array.byteLength + 2);
			var dataView = new DataView(buffer);
			dataView.setUint16(0, uint8Array.byteLength, true)
			var int8View = new Int8Array(buffer);
			int8View.set(uint8Array, 2)
			//dataView.setInt32(0, 0x1234ABCD);
			console.info(int8View.buffer)
			client.send(int8View.buffer);
			
			document.getElementById("msg").value = "";
		 }
</script>

</div>