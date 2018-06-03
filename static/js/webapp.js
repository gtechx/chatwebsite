var MsgType = {
  ReqFrame: 0,
  RetFrame: 1,
  TickFrame: 2,
  EchoFrame: 3,
}

var ws = null;
var sendstream = BinaryStream.new();
var recvstream = BinaryStream.new();

function login(account, password, appname, zonename) {
  ws = new WebSocket("ws://" + "127.0.0.1:9090");
  ws.binaryType = "arraybuffer";

  // ws.onopen = onopen;
  // ws.onmessage = onmessage;
  // ws.onclose = onclose;
  // ws.onerror = onerror;
  // client = WsClient.new("127.0.0.1:9090");
  ws.onopen = function () {
    console.info("connect success")
    var accountbytes = stringToBytes(account);
    var passwordbytes = stringToBytes(password);
    var appnamebytes = stringToBytes(appname);
    var zonenamebytes = stringToBytes(zonename);

    sendstream.writeUint8(accountbytes.byteLength);
    sendstream.writeArray(accountbytes);
    sendstream.writeUint8(passwordbytes.byteLength);
    sendstream.writeArray(passwordbytes);
    sendstream.writeUint8(appnamebytes.byteLength);
    sendstream.writeArray(appnamebytes);
    sendstream.writeUint8(zonenamebytes.byteLength);
    sendstream.writeArray(zonenamebytes);
    //console.info(sendstream.length);
    //console.info(sendstream.getBuffer());
    sendMsg(MsgType.ReqFrame, sendstream.length, 1001, sendstream.getBuffer(), onLogined)
  }
  ws.onclose = function () {
    console.info("disconnect")
  }
  ws.onerror = function (evt) {
    console.info("error " + evt)
  }
  ws.onmessage = onMessage
  //client.setHeaderParser(headerParser);
  //client.setMsgParser(msgParser);
  //ws.connect();
};

function enterChat(id) {
  console.info("id:" + typeof(id));
  var appdataid = Long.fromString(id, true, 10);
  sendstream.reset();
  //sendstream.writeUint8(nicknamebytes.byteLength);
  sendstream.writeUint64(appdataid);
  sendMsg(MsgType.ReqFrame, sendstream.length, 1002, sendstream.getBuffer(), onEnterChatSuccess);
}

var tickinstance = null;
function onEnterChatSuccess(buffer){
  var bs = BinaryStream.new(buffer);
  var errcode = bs.readUint16();
  console.info("errcode:" + errcode);
  if(errcode == 0) {
    tickinstance = setInterval("sendTick();",5000);
  }
}

function onTick() {
  console.info("recv tick from server..");
}

function sendTick() {
  var bs = BinaryStream.new();
  sendMsg(MsgType.TickFrame, 0, 0, null, null);
}

function onLogined(token) {
  var bs = BinaryStream.new(token);
  console.info("onLogined:" + bs.length)
  var errcode = bs.readUint16();
  console.info("errcode:" + errcode);

  if(errcode == 0) {
    var idcount = (bs.length - 2) / 8;
    console.info("id count:" + idcount);
    console.info(token);
    if(idcount == 0){
      sendstream.reset();
      var nicknamebytes = stringToBytes("testnickname");
      //sendstream.writeUint8(nicknamebytes.byteLength);
      sendstream.writeArray(nicknamebytes);
      sendMsg(MsgType.ReqFrame, sendstream.length, 1004, sendstream.getBuffer(), onAppDataCreated);
    } else {
      var appdataid = bs.readUint64();
      console.info("appdataid:" + appdataid.toString());
      var html = '<button type="button" onclick="enterChat(\''+appdataid.toString()+'\');" class="list-group-item list-group-item-action">';
      html += appdataid;
      html += '</button>';
      $("#idlist").html(html);

      $("#idselect").removeClass('d-none');
      $("#loginpanel").addClass('d-none');
    }
  }
}

function onAppDataCreated(data) {
  var bs = BinaryStream.new(data);
  console.info("onAppDataCreated:" + bs.length);
  var errcode = bs.readUint16();
  console.info("errcode:" + errcode);
  if(errcode == 0) {
    var appdataid = bs.readUint64();
    console.info("appdataid:" + appdataid);
  }
}

function packageMsg(type, id, size, msgid, databuff) {
  sendstream.reset();
  sendstream.writeUint8(type);
  if(type != MsgType.TickFrame) {
    sendstream.writeUint16(id);
    sendstream.writeUint16(size);
    sendstream.writeUint16(msgid);
    sendstream.writeArrayBuffer(databuff);
  }

  //
  // var tmpbs = BinaryStream.new(sendstream.getBuffer());
  // console.info("length " + tmpbs.length)
  // console.info("type " + tmpbs.readUint8())
  // console.info("id " + tmpbs.readUint16())
  // console.info("size " + tmpbs.readUint16())
  // console.info("msgid " + tmpbs.readUint16())
  // var alen = tmpbs.readUint8();
  // console.info("alen " + alen)
  // console.info("account " + tmpbs.readString(alen));

  return sendstream.getBuffer();
}

var id = 0;
var cbMap = {}
function sendMsg(type, size, msgid, databuff, cb) {
  id++;
  var sendbuff = packageMsg(type, id, size, msgid, databuff);
  if(cb != null)
    cbMap[id] = cb;
  ws.send(sendbuff);
}

function onMessage(evt) {
  var header = readMsgHeader(evt.data)
  console.info(header)
  switch (header.type) {
    case MsgType.TickFrame:
      console.info("recv tick from server..");
      break;
    case MsgType.EchoFrame:
      console.info("recv echo from server:" + header.databuff);
      break;
    default:
      if (cbMap[header.id]) {
        cbMap[header.id](header.databuff);
        delete cbMap[header.id];
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