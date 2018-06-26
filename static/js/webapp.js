
console.info(Long.fromString("18446744073709551615", true, 10).toBytes());
console.info(5/2);
console.info((new Date()).getTime());
var timestamp4 = new Date((new Date()).getTime());
var ThisInt = '1529994598312'
console.info(parseInt(ThisInt))

var user = null;
var myapp = App.new();
function login(account, password, appname, zonename) {
  myapp.onlogined = onLogined
  myapp.onloginfailed = function(errcode) {
    console.info("login failed, errcode:" + errcode)
  };
  myapp.onconnected = function(){
    myapp.login(account, password, appname, zonename);
  };
  myapp.onclose = function() {
    console.info("disconnect from server");
  };
  myapp.onerror = function(evt) {
    console.info("error:"+evt.data);
  };
  myapp.onpresence = onPresence;
  myapp.connect("127.0.0.1:9090");
}

function onLogined(idlist) {
  console.info(idlist);
  if(idlist.length == 0){
    myapp.createappdata("testnickname", onAppDataCreated);
  } else {
    var html = '';
    for(var i = 0; i < idlist.length; i++) {
      var appdataid = idlist[i];
      console.info("appdataid:" + appdataid.toString());
      html += '<button type="button" onclick="enterChat(\''+appdataid.toString()+'\');" style="min-width:200px;" class="btn btn-default btn-block">';
      html += 'Sign in with ID: ' + appdataid;
      html += '</button>';
    }
    $("#idlist").html(html);

    $("#idselect").removeClass('hide');
    $("#loginpanel").addClass('hide');
  }
}

function onAppDataCreated(errcode, appdataid) {
  console.info("onAppDataCreated errcode:" + errcode);
  if(errcode == 0) {
    console.info("appdataid:" + appdataid);
  }
}

function enterChat(strid) {
  console.info("strid:" + typeof(strid));
  myapp.enterchat(strid, onEnterChat);
}

function onEnterChat(errcode){
  console.info("onEnterChat errcode:" + errcode);
  if(errcode == 0) {
    myapp.requserdata(onUserData);
  }
}

function onUserData(errcode, jsondata) {
  console.info("onUserData errcode:" + errcode);
  if(errcode == 0) {
    console.info(jsondata);
    $("#idselect").addClass('hide');
    $("#fpanel").removeClass('hide');
    $("#fpanelheader .box-title").html(jsondata.nickname);

    reqPresenceList();
  }
}

function addFriend(idstr, message) {
  myapp.addfriend(idstr, message, onAddFriendResult);
}

function agreeFriend(idstr) {
  myapp.addfriend(idstr, onAddFriendResult);
}

function refuseFriend(idstr) {
  myapp.addfriend(idstr, onAddFriendResult);
}

function reqPresenceList() {
  myapp.reqpresencelist(onPresenceList);
}

function onPresenceList(errcode, data) {
  console.info("onPresenceList errcode:" + errcode);
  console.info("onPresenceList data:" + data);
}

function onAddFriendResult(errcode) {
  console.info("onAddFriendResult errcode:" + errcode);
}

function onPresence(jsondata) {
  console.info("onPresence jsondata:" + jsondata);
}

function quitChat() {
  myapp.quitchat();
  $("#loginpanel").removeClass('hide');
  $("#idselect").addClass('hide');
}

function sendmsg() {
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
  ws.send(int8View.buffer);

  document.getElementById("msg").value = "";
}