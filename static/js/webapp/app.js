var MsgType = {
  ReqFrame: 0,
  RetFrame: 1,
  TickFrame: 2,
  EchoFrame: 3,
}

var PresenceType = {
  PresenceType_Subscribe: 0,
  PresenceType_Subscribed: 1,
  PresenceType_Unsubscribe: 2,
  PresenceType_Unsubscribed: 3,
  PresenceType_Available: 4,
  PresenceType_Unavailable: 5,
  PresenceType_Invisible: 6,
}

var DataType = {
  DataType_Friend: 0,
  DataType_Presence: 1,
  DataType_Black: 2,
  DataType_Offline_Message: 3,
}

var App = {
  new: function () {
    var app = {};
    app.onconnected = null;
    app.onlogined = null;
    app.onloginfailed = null;
    app.onerror = null;
    app.onclose = null;
    app.onpresence = null;
    app.onmessage = null;
    app.onkickout = null;

    app.platform = "web";

    var ws = null;
    var sendstream = BinaryStream.new();
    var recvstream = BinaryStream.new();
    var readstream = BinaryStream.new();

    app.connect = function(addr) {
      ws = new WebSocket("ws://" + addr);
      ws.binaryType = "arraybuffer";
      ws.onopen = onopen;
      ws.onclose = onclose;
      ws.onerror = onerror;
      ws.onmessage = onData;
    };

    function onopen() {
      if(app.onconnected != null)
        app.onconnected();
    }

    function onclose() {
      if(app.onclose != null)
        app.onclose();

      if(tickinstance != null){
        clearInterval(tickinstance);
        tickinstance = null;
      }
    }

    function onerror() {
      if(app.onerror != null)
        app.onerror();
    }

    app.setplatform = function (platform){
      app.platform = platform;
    }
    
    app.login = function (account, password, appname, zonename){
      var accountbytes = stringToBytes(account);
      var passwordbytes = stringToBytes(password);
      var appnamebytes = stringToBytes(appname);
      var zonenamebytes = stringToBytes(zonename);
      var platformbytes = stringToBytes(app.platform);

      sendstream.reset();
      sendstream.writeUint8(accountbytes.byteLength);
      sendstream.writeArray(accountbytes);
      sendstream.writeUint8(passwordbytes.byteLength);
      sendstream.writeArray(passwordbytes);
      sendstream.writeUint8(appnamebytes.byteLength);
      sendstream.writeArray(appnamebytes);
      sendstream.writeUint8(zonenamebytes.byteLength);
      sendstream.writeArray(zonenamebytes);
      sendstream.writeUint8(platformbytes.byteLength);
      sendstream.writeArray(platformbytes);
      //console.info(sendstream.length);
      //console.info(sendstream.getBuffer());
      sendMsg(MsgType.ReqFrame, sendstream.length, 1001, sendstream.getBuffer(), onLogined);
    };

    function onLogined(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(errcode == 0) {
        var idcount = (bs.length - 2) / 8;
        var idlist = new Array();
        for(var i = 0; i < idcount; i++){
          idlist[i] = bs.readUint64().toString();
        }
        if(app.onlogined != null)
          app.onlogined(idlist);
      } else {
        if(app.onloginfailed != null)
          app.onloginfailed(errcode);
      }
    }

    var appdatacreatecb = null;
    app.createappdata = function (nickname, cb){
      appdatacreatecb = cb;
      sendstream.reset();
      var nicknamebytes = stringToBytes("testnickname");
      //sendstream.writeUint8(nicknamebytes.byteLength);
      sendstream.writeArray(nicknamebytes);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1004, sendstream.getBuffer(), onAppDataCreated);
    }

    function onAppDataCreated(buffer) {
      var bs = readstream.reset(buffer);
      //console.info("onAppDataCreated:" + bs.length);
      var errcode = bs.readUint16();
      //console.info("errcode:" + errcode);
      if(errcode == 0) {
        var appdataid = bs.readUint64();
        //console.info("appdataid:" + appdataid);
        if(appdatacreatecb != null) {
          appdatacreatecb(errcode, appdataid);
        }
      } else {
        if(appdatacreatecb != null) {
          appdatacreatecb(errcode);
        }
      }
    }

    app.quitchat = function (){
      sendMsg(MsgType.ReqFrame, 0, 1003, null, null);
      ws.close();
    }

    var enterchatcb = null;
    app.enterchat = function (strid, cb){
      enterchatcb = cb;
      var appdataid = Long.fromString(strid, true, 10);
      sendstream.reset();
      sendstream.writeUint64(appdataid);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1002, sendstream.getBuffer(), onEnterChat);
    }

    var tickinstance = null;
    var tickbuffer = null;
    function onEnterChat(buffer){
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(errcode == 0) {
        if(tickbuffer == null){
          tickbuffer = new ArrayBuffer(1);
          var dataview = new DataView(tickbuffer);
          dataview.setUint8(0, MsgType.TickFrame);
        }
        
        tickinstance = setInterval(sendTick, 30000);
      }
      if(enterchatcb != null)
        enterchatcb(errcode);
    }

    function sendTick() {
      ws.send(tickbuffer);
    }

    var userinfocb = null;
    app.requserdata = function (idstr, cb) {
      userinfocb = cb;
      
      sendstream.reset();
      var id = Long.fromString(idstr, true)
      sendstream.writeUint64(id)

      sendMsg(MsgType.ReqFrame, sendstream.length, 1005, sendstream.getBuffer(), onUserData);
    }

    function onUserData(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      var strdata = "";
      if(errcode == 0) {
        strdata = readstream.readString(buffer.byteLength - 2);
      }
      var jsondata = JSON.parse(strdata);
      if(userinfocb != null)
        userinfocb(errcode, jsondata);
    }

    var refreshgroupcb = null;
    app.refreshgroup = function (groupname, cb) {
      refreshgroupcb = cb;
      
      sendstream.reset();
      sendstream.writeString(groupname)

      sendMsg(MsgType.ReqFrame, sendstream.length, 1016, sendstream.getBuffer(), onGroupFriendData);
    }

    function onGroupFriendData(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      var strdata = "";
      if(errcode == 0) {
        strdata = readstream.readString(buffer.byteLength - 2);
      }
      var jsondata = JSON.parse(strdata);
      if(refreshgroupcb != null)
      refreshgroupcb(errcode, jsondata);
    }

    var msgcb = null;
    app.sendmessage = function (msg, cb) {
      msgcb = cb;
      sendstream.reset();
      sendstream.writeString(JSON.stringify(msg))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1008, sendstream.getBuffer(), onMsgResult);
    }

    function onMsgResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(msgcb != null)
        msgcb(errcode);
    }

    var presencecb = null;
    app.addfriend = function (idstr, message, cb) {
      presencecb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.presencetype = PresenceType.PresenceType_Subscribe;
      jsondata.who = idstr;
      jsondata.message = message;
      console.info(JSON.stringify(jsondata));
      sendstream.writeString(JSON.stringify(jsondata))
      // sendstream.writeUint8(PresenceType_Subscribe);
      // sendstream.writeUint64(Long.fromString(idstr));
      // sendstream.writeInt64(Long.fromNumber((new Date()).getTime()));
      // sendstream.writeString(message);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1007, sendstream.getBuffer(), onPresenceResult);
    }

    function onPresenceResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(presencecb != null)
      presencecb(errcode);
    }

    var modifycommentcb = null;
    app.modifyfriendcomment = function (idstr, comment, cb) {
      modifycommentcb = cb;
      sendstream.reset();
      var appdataid = Long.fromString(idstr, true, 10);
      sendstream.writeUint64(appdataid);
      sendstream.writeString(comment)
      sendMsg(MsgType.ReqFrame, sendstream.length, 1021, sendstream.getBuffer(), onModifyCommentResult);
    }

    function onModifyCommentResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(modifycommentcb != null)
      modifycommentcb(errcode);
    }

    app.delfriend = function (idstr, cb) {
      presencecb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.presencetype = PresenceType.PresenceType_Unsubscribe;
      jsondata.who = idstr;
      sendstream.writeString(JSON.stringify(jsondata))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1007, sendstream.getBuffer(), onPresenceResult);
    }

    app.agreefriend = function (idstr, cb) {
      presencecb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.presencetype = PresenceType.PresenceType_Subscribed;
      jsondata.who = idstr;
      sendstream.writeString(JSON.stringify(jsondata))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1007, sendstream.getBuffer(), onPresenceResult);
    }

    app.refusefriend = function (idstr, cb) {
      presencecb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.presencetype = PresenceType.PresenceType_Unsubscribed;
      jsondata.who = idstr;
      sendstream.writeString(JSON.stringify(jsondata))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1007, sendstream.getBuffer(), onPresenceResult);
    }

    var presencelistcb = null;
    app.reqpresencelist = function (cb) {
      presencelistcb = cb;
      sendstream.reset();
      sendstream.writeUint8(DataType.DataType_Presence);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1014, sendstream.getBuffer(), onDataList);
    }

    var friendlistcb = null;
    app.reqfriendlist = function (cb) {
      friendlistcb = cb;
      sendstream.reset();
      sendstream.writeUint8(DataType.DataType_Friend);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1014, sendstream.getBuffer(), onDataList);
    }

    var blacklistcb = null;
    app.reqblacklist = function (cb) {
      blacklistcb = cb;
      sendstream.reset();
      sendstream.writeUint8(DataType.DataType_Black);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1014, sendstream.getBuffer(), onDataList);
    }

    var offlinemsglistcb = null;
    app.reqofflinemsglist = function (cb) {
      offlinemsglistcb = cb;
      sendstream.reset();
      sendstream.writeUint8(DataType.DataType_Offline_Message);
      var id= sendMsg(MsgType.ReqFrame, sendstream.length, 1014, sendstream.getBuffer(), onDataList);
      addToWaitMap(id, DataType.DataType_Offline_Message, cb);
    }

    function addToWaitMap(id, data, cb) {
      waitMap[id] = id;
      timerinstance = setInterval(timeOut, 15000, id);
      waitMap["timer"] = timerinstance;
      waitMap["cb"] = cb;
      waitMap["data"] = data;
    }

    function timeOut(id) {
      if (waitMap[id]) {
        clearInterval(waitMap["timer"]);
        if(waitMap["cb"])
          waitMap["cb"](1, waitMap["data"]);
        delete waitMap[id];
      }
    }

    function removeFromWaitMap(id) {
      if (waitMap[id]) {
        delete waitMap[id];
      }
    }

    function onDataList(buffer) {
      var bs = readstream.reset(buffer);
      
      var errcode = bs.readUint16();
      var datatype = bs.readUint8();
      if(datatype == DataType.DataType_Presence){
        if(presencelistcb != null)
        {
          var jsonstr = bs.readStringAll();
          console.info(jsonstr);
          var datalist = JSON.parse(jsonstr);
          presencelistcb(errcode, datalist);
        }
      } else if(datatype == DataType.DataType_Friend) {
        if(friendlistcb != null)
        {
          var jsonstr = bs.readStringAll();
          console.info(jsonstr);
          var datalist = JSON.parse(jsonstr);
          friendlistcb(errcode, datalist);
        }
      } else if(datatype == DataType.DataType_Offline_Message) {
        if(offlinemsglistcb != null)
        {
          var jsonstr = bs.readStringAll();
          console.info(jsonstr);
          var datalist = JSON.parse(jsonstr);
          offlinemsglistcb(errcode, datalist);
        }
      } else if(datatype == DataType.DataType_Black) {
        if(blacklistcb != null)
        {
          var jsonstr = bs.readStringAll();
          console.info(jsonstr);
          var datalist = JSON.parse(jsonstr);
          blacklistcb(errcode, datalist);
        }
      }
    }

    //group msg start
    var groupcb = null;
    app.creategroup = function (name, cb) {
      groupcb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.cmd = "create";
      jsondata.name = name;
      console.info(JSON.stringify(jsondata));
      sendstream.writeString(JSON.stringify(jsondata))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1015, sendstream.getBuffer(), onGroupResult);
    }

    app.deletegroup = function (name, cb) {
      groupcb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.cmd = "delete";
      jsondata.name = name;
      console.info(JSON.stringify(jsondata));
      sendstream.writeString(JSON.stringify(jsondata))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1015, sendstream.getBuffer(), onGroupResult);
    }

    app.renamegroup = function (oldname, newname, cb) {
      groupcb = cb;
      sendstream.reset();
      var jsondata = {}
      jsondata.cmd = "rename";
      jsondata.oldname = oldname;
      jsondata.newname = newname;
      console.info(JSON.stringify(jsondata));
      sendstream.writeString(JSON.stringify(jsondata))
      sendMsg(MsgType.ReqFrame, sendstream.length, 1015, sendstream.getBuffer(), onGroupResult);
    }

    app.movetogroup = function (idstr, name, cb) {
      groupcb = cb;
      sendstream.reset();
      var appdataid = Long.fromString(idstr, true, 10);
      sendstream.writeUint64(appdataid);
      sendstream.writeString(name);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1019, sendstream.getBuffer(), onGroupResult);
    }

    function onGroupResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(groupcb != null)
      groupcb(errcode);
    }
    //group msg end

    //black msg start
    var blackcb = null;
    app.addblack = function (idstr, cb) {
      blackcb = cb;
      sendstream.reset();
      var appdataid = Long.fromString(idstr, true, 10);
      sendstream.writeUint64(appdataid);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1017, sendstream.getBuffer(), onBlackResult);
    }

    app.removeblack = function (idstr, cb) {
      blackcb = cb;
      sendstream.reset();
      var appdataid = Long.fromString(idstr, true, 10);
      sendstream.writeUint64(appdataid);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1018, sendstream.getBuffer(), onBlackResult);
    }

    function onBlackResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(blackcb != null)
      blackcb(errcode);
    }
    //black msg end

    //appdata update
    var updateappdatacb = null;
    app.updateappdata = function (jsondata, cb) {
      updateappdatacb = cb;
      sendstream.reset();
      sendstream.writeString(JSON.stringify(jsondata));
      sendMsg(MsgType.ReqFrame, sendstream.length, 1020, sendstream.getBuffer(), onUpdateAppdataResult);
    }

    function onUpdateAppdataResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(updateappdatacb != null)
      updateappdatacb(errcode);
    }
    //appdata update end

    //room msg start
    var createroomcb = null;
    app.createroom = function (jsondata, cb) {
      createroomcb = cb;
      sendstream.reset();
      sendstream.writeString(JSON.stringify(jsondata));
      sendMsg(MsgType.ReqFrame, sendstream.length, 1100, sendstream.getBuffer(), onCreateRoomResult);
    }

    function onCreateRoomResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(createroomcb != null)
      createroomcb(errcode);
    }

    var deleteroomcb = null;
    app.deleteroom = function (strrid, cb) {
      deleteroomcb = cb;
      sendstream.reset();
      var rid = Long.fromString(strrid, true, 10);
      sendstream.writeUint64(rid);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1101, sendstream.getBuffer(), onDeleteRoomResult);
    }

    function onDeleteRoomResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(deleteroomcb != null)
      deleteroomcb(errcode);
    }

    var updateroomsettingcb = null;
    app.updateroomsetting = function (jsondata, cb) {
      updateroomsettingcb = cb;
      sendstream.reset();
      sendstream.writeString(JSON.stringify(jsondata));
      sendMsg(MsgType.ReqFrame, sendstream.length, 1102, sendstream.getBuffer(), onUpdateRoomSettingResult);
    }

    function onUpdateRoomSettingResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(updateroomsettingcb != null)
      updateroomsettingcb(errcode);
    }

    var joinroomcb = null;
    app.joinroom = function (jsondata, cb) {
      joinroomcb = cb;
      sendstream.reset();
      sendstream.writeString(JSON.stringify(jsondata));
      sendMsg(MsgType.ReqFrame, sendstream.length, 1102, sendstream.getBuffer(), onUpdateRoomSettingResult);
    }

    function onUpdateRoomSettingResult(buffer) {
      var bs = readstream.reset(buffer);
      var errcode = bs.readUint16();
      if(updateroomsettingcb != null)
      updateroomsettingcb(errcode);
    }
    //room msg end

    function onPresence(buffer) {
      var bs = readstream.reset(buffer);
      
      if(app.onpresence != null)
      {
        var presence = JSON.parse(bs.readStringAll());
        app.onpresence(presence);
      }
    }

    function onMessage(buffer) {
      var bs = readstream.reset(buffer);
      
      if(app.onmessage != null)
      {
        var msg = JSON.parse(bs.readStringAll());
        app.onmessage(msg);
      }
    }

    function packageMsg(type, id, size, msgid, databuff) {
      sendstream.reset();
      sendstream.writeUint8(type);
      if(type != MsgType.TickFrame) {
        sendstream.writeUint16(id);
        sendstream.writeUint16(size);
        sendstream.writeUint16(msgid);
        if(databuff != null && size > 0)
          sendstream.writeArrayBuffer(databuff);
      }
    
      return sendstream.getBuffer();
    }

    var id = 0;
    var cbMap = {}; //internal use
    var waitMap = {}; //[id:id, data:jsondata: cb:cb, timer:timer]
    function sendMsg(type, size, msgid, databuff, cb) {
      if(waitMap.length > 3) {
        if(app.onerror) {
          app.onerror(0, "too many sending data")
        }
        return;
      }
      id++;
      id = id % 0xffff;
      var sendbuff = packageMsg(type, id, size, msgid, databuff);
      if(cb != null)
        cbMap[id] = cb;
      
      ws.send(sendbuff);
      return id;
    }

    function onData(evt) {
      var header = readMsgHeader(evt.data)
      //console.info(header)
      switch (header.type) {
        case MsgType.TickFrame:
          //console.info("recv tick from server..");
          break;
        case MsgType.EchoFrame:
          console.info("recv echo from server:" + header.databuff);
          break;
        default:
          if (cbMap[header.id]) {
            removeFromWaitMap(header.id);
            cbMap[header.id](header.databuff);
            delete cbMap[header.id];
          } else {
            if(header.msgid == 1007){
              onPresence(header.databuff);
            } else if(header.msgid == 1008){
              onMessage(header.databuff);
            } else if(header.msgid == 1022 && app.onkickout != null){
              app.onkickout();
            }
          }
      }
    }

    function readMsgHeader(buffer) {
      recvstream.reset(buffer);
      var dataView = new DataView(buffer);
      var ret = {};
      ret.type = recvstream.readUint8();
      if (ret.type == MsgType.TickFrame)
        return ret;
      ret.id = recvstream.readUint16();
      ret.size = recvstream.readUint16();
      ret.msgid = recvstream.readUint16();
      if (ret.size == 0)
        return ret;
      ret.databuff = recvstream.readArrayBuffer(ret.size);
      return ret;
    }

    return app;
  }
}

//BinaryStream test
// var bs = BinaryStream.new();
// bs.writeInt8(0x01).writeInt16(0x0302).writeInt32(0x07060504).writeInt64(Long.fromString("0x0f0e0d0c0b0a0908", true, 16));
// console.info(bs.getBuffer());
// var newbs = BinaryStream.new(bs.getBuffer());

// console.info(newbs.readInt8().toString(16));
// console.info(newbs.readInt16().toString(16));
// console.info(newbs.readInt32().toString(16));
// console.info(newbs.readInt64().toString(16));

// var strbs = BinaryStream.new();
// strbs.writeString("abcdefg");
// console.info(strbs.getBuffer());
// console.info(strbs.cur);
// console.info(strbs.length);
