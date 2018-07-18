
console.info(Long.fromString("18446744073709551615", true, 10).toBytes());
console.info(5/2);
console.info((new Date()).getTime());
var timestamp4 = new Date((new Date()).getTime());
var ThisInt = '1529994598312'
console.info(parseInt(ThisInt))

var messagelist = {};
var userdata = null;
var frienddata = null;
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
    myapp.requserdata("0", onMyData);
  }
}

function onMyData(errcode, jsondata) {
  console.info("onMyData errcode:" + errcode);
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

function reqUserData(idstr) {
  myapp.requserdata(idstr, onUserData);
}

function onUserData(errcode, jsondata) {
  console.info("onUserData errcode:" + errcode);
  if(errcode == 0) {
    console.info(jsondata);
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
  frienddata = data;
  for(var groupname in data){
    console.info("onFriendList group:" + groupname);
    createGroup(groupname);
    for(var i in data[groupname]){
      console.info("onFriendList item:" + JSON.stringify(data[groupname][i]));
      addFriendItem(data[groupname][i]);
    }
  }
}

function reqBlackList() {
  myapp.reqblacklist(onBlackList);
}

function onBlackList(errcode, data) {
  console.info("onBlackList errcode:" + errcode);
  console.info("onBlackList data length:" + data.length);
  // clearFriendList();
  // frienddata = data;
  // for(var group in data){
  //   console.info("onFriendList group:" + group);
  //   createGroup(group);
  //   for(var i in data[group]){
  //     console.info("onFriendList item:" + JSON.stringify(data[group][i]));
  //     addFriendItem(data[group][i]);
  //   }
  // }
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

//group start
function reqCreateGroup(name) {
  myapp.creategroup(name, onGroupResult);
}

function reqDeleteGroup(name) {
  if(frienddata[name].length > 0){
    alert("can't delete group that not empty!");
    return;
  }
  myapp.deletegroup(name, onGroupResult);
}

function reqRenameGroup(oldname, newname) {
  myapp.renamegroup(oldname, newname, onGroupResult);
}

function reqMoveToGroup(idstr, name) {
  myapp.movetogroup(idstr, name, onGroupResult);
}

function onGroupResult(errcode) {
  console.info("onGroupResult errcode:" + errcode);
  reqFriendList();
}

function reqRefreshGroup(name) {
  myapp.refreshgroup(name, onRefreshGroupResult);
}

function onRefreshGroupResult(errcode, jsondata) {
  console.info("onRefreshGroupResult errcode:" + errcode);
  for(var name in jsondata){
    clearGroupFriendList(name)
    frienddata[name] = jsondata[name];
    console.info("onRefreshGroupResult group:" + name);
    for(var i in jsondata[name]){
      console.info("onRefreshGroupResult item:" + JSON.stringify(jsondata[name][i]));
      addFriendItem(jsondata[name][i]);
    }
  }
}
//group end

//black start
function addBlack(idstr) {
  myapp.addblack(idstr, onBlackResult);
}

function removeBlack(idstr) {
  myapp.removeblack(idstr, onBlackResult);
}

function onBlackResult(errcode) {
  console.info("onBlackResult errcode:" + errcode);
}
//black end

//appdata update
function updateAppdata(jsondata) {
  myapp.updateappdata(jsondata, onUpdateAppdataResult);
}

function onUpdateAppdataResult(errcode) {
  console.info("onUpdateAppdataResult errcode:" + errcode);
}
//appdata update end
