
console.info(Long.fromString("18446744073709551615", true, 10).toBytes());
console.info(5/2);
console.info((new Date()).getTime());
var timestamp4 = new Date((new Date()).getTime());
var ThisInt = '1529994598312'
console.info(parseInt(ThisInt))

var messagelist = {};
var userdata = null;
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
  myapp.onmessage = onMessage;
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
    userdata = jsondata;
    $("#idselect").addClass('hide');
    $("#fpanel").removeClass('hide');
    $("#fpanelheader .box-title").html(jsondata.nickname);

    reqFriendList();
    reqPresenceList();
    myapp.reqofflinemsglist();
  }
}

function addFriend(idstr, message) {
  myapp.addfriend(idstr, message, onPresenceResult);
}

function delFriend(idstr, message) {
  myapp.delfriend(idstr, onPresenceResult);
}

function agreeFriend(idstr) {
  myapp.agreefriend(idstr, onPresenceResult);
}

function refuseFriend(idstr) {
  myapp.refusefriend(idstr, onPresenceResult);
}

function reqPresenceList() {
  myapp.reqpresencelist(onPresenceList);
}

function onPresenceList(errcode, data) {
  console.info("onPresenceList errcode:" + errcode);
  console.info("onPresenceList data length:" + data.length);
  for(var i = 0; i < data.length; i ++) {
    console.info("onPresenceList data:" + JSON.stringify(data[i]));
    addPresence(data[i]);
    if(data[i].presencetype == PresenceType.PresenceType_Unsubscribe){
      removeFriendItemById(data[i].who);
    }
  }
}

function reqFriendList() {
  myapp.reqfriendlist(onFriendList);
}

function onFriendList(errcode, data) {
  console.info("onFriendList errcode:" + errcode);
  console.info("onFriendList data length:" + data.length);
  clearFriendList();
  for(var i = 0; i < data.length; i ++) {
    console.info("onFriendList data:" + JSON.stringify(data[i]));
    console.info(data[i].nickname + " " + data[i].group);
    addFriendItem(data[i]);
  }
}

function onPresenceResult(errcode) {
  console.info("onPresenceResult errcode:" + errcode);
  reqFriendList();
}

function onPresence(jsondata) {
  console.info("onPresence jsondata:" + jsondata);
  addPresence(jsondata);
  if(jsondata.presencetype == PresenceType.PresenceType_Unsubscribe){
    console.info("PresenceType_Unsubscribe " + jsondata.who)
    removeFriendItemById(jsondata.who);
  } else if(jsondata.presencetype == PresenceType.PresenceType_Subscribed){
    reqFriendList();
  }
}

function sendMessage(msg) {
  myapp.sendmessage(msg, onMessageResult);
}

function onMessageResult(errcode) {
  console.info("onMessageResult errcode:" + errcode);
}

function onMessage(jsondata) {
  console.info("onMessage jsondata:" + jsondata);
  var msgarray = messagelist[jsondata.who];
  if(msgarray == null){
    msgarray = new Array();
    messagelist[jsondata.who] = msgarray;
  }
  msgarray[msgarray.length] = jsondata;
  addMessage(jsondata);
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