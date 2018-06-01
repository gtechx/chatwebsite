var MsgType = {
  ReqFrame: 0,
  RetFrame: 1,
  TickFrame: 2,
  EchoFrame: 3,
}

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

function stringToBytes(str) {
  return new TextEncoder("utf-8").encode(str);
}

function appendString(buffer, str) {
  var bytes = stringToBytes(str)
  var newbuffer = new ArrayBuffer(buffer.byteLength + bytes.byteLength);
  var uint8View = new Uint8Array(newbuffer);
  uint8View.set(0, new Uint8Array(buffer))
  uint8View.set(buffer.byteLength, bytes)
  return newbuffer
}

function appendArrayBuffer(buffer, arrbuffer) {
  var newbuffer = new ArrayBuffer(buffer.byteLength + arrbuffer.byteLength);
  var uint8View = new Uint8Array(newbuffer);
  uint8View.set(0, new Uint8Array(buffer))
  uint8View.set(buffer.byteLength, new Uint8Array(arrbuffer))
  return newbuffer
}

var BinaryStream = {
  new: function () {
    var stream = {};
    stream.length = 0;
    stream.cur = 0;
    stream.cap = 512;
    stream.buffer = new ArrayBuffer(stream.cap);
    stream.dataview = new DataView(stream.buffer);
    stream.littleEndian = true;

    stream.writeUint8 = function (data){
      stream.dataview.setUint8(stream.cur, data);
      stream.cur = stream.cur + 1;
    };

    stream.writeUint16 = function (data){
      stream.dataview.setUint8(stream.cur, data, stream.littleEndian);
      stream.cur = stream.cur + 2;
    };

    return stream;
  }
}

var client = null;
function login() {
  client = WsClient.new("127.0.0.1:9090");
  client.onopen = function () {
    console.info("connect success")
    var account = stringToBytes("wyq");
    var password = stringToBytes("123");
    var size = account.byteLength + password.byteLength + 2;
    var buffer = new ArrayBuffer(size);
    var int8View = new Int8Array(buffer);
    var dataView = new DataView(buffer);
    console.info(account)
    console.info(password)
    dataView.setUint8(0, account.byteLength)
    int8View.set(account, 1)
    dataView.setUint8(account.byteLength + 1, password.byteLength)
    int8View.set(password, 1 + account.byteLength + 1)
    console.info("buffer.byteLength " + buffer.byteLength)
    console.info(new TextDecoder("utf-8").decode(buffer.slice(1, account.byteLength + 1)))
    sendMsg(MsgType.ReqFrame, size, 1000, buffer, onLogined)
  }
  client.onclose = function () {
    console.info("disconnect")
  }
  client.onerror = function (evt) {
    console.info("error " + evt)
  }
  client.onmessage = onMessage
  //client.setHeaderParser(headerParser);
  //client.setMsgParser(msgParser);
  client.connect();
};

function onLogined(token) {
  var dataView = new DataView(token);
  console.info("onLogined:" + token.byteLength)
  console.info("errcode:" + dataView.getUint16(0, true))
  console.info("token:" + new TextDecoder("utf-8").decode(token.slice(2)))
}

function packageMsg(type, id, size, msgid, databuff) {
  var buffer = new ArrayBuffer(databuff.byteLength + 7);
  console.info("type " + type)
  console.info("id " + id)
  console.info("size " + size)
  console.info("msgid " + msgid)
  console.info("databuff " + new TextDecoder("utf-8").decode(databuff))
  var dataView = new DataView(buffer);

  dataView.setUint8(0, type)
  dataView.setUint16(1, id, true)
  dataView.setUint16(3, size, true)
  dataView.setUint16(5, msgid, true)
  var int8View = new Uint8Array(buffer);
  int8View.set(new Uint8Array(databuff), 7)

  console.info("type " + dataView.getUint8(0))
  console.info("id " + dataView.getUint16(1, true))
  console.info("size " + dataView.getUint16(3, true))
  console.info("msgid " + dataView.getUint16(5, true))
  console.info("account " + new TextDecoder("utf-8").decode(buffer.slice(8)))

  return buffer
}

var id = 0;
var cbMap = {}
function sendMsg(type, size, msgid, databuff, cb) {
  id++;
  var sendbuff = packageMsg(type, id, size, msgid, databuff);
  cbMap[id] = cb;
  client.send(sendbuff);
}

function onMessage(buffer) {
  var header = readMsgHeader(buffer)
  console.info(header)
  switch (header.type) {
    case MsgType.TickFrame:
      console.info("recv tick from server..")
      break;
    case MsgType.EchoFrame:
      console.info("recv echo from server:" + header.databuff)
      break;
    default:
      if (cbMap[header.id]) {
        cbMap[header.id](header.databuff)
        delete cbMap[header.id]
      }
  }
}

function readMsgHeader(buffer) {
  var dataView = new DataView(buffer);
  var ret = {};
  ret.type = dataView.getUint8();
  if (ret.type == MsgType.TickFrame)
    return ret;
  ret.id = dataView.getUint16(1, true);
  ret.size = dataView.getUint16(3, true);
  ret.msgid = dataView.getUint16(5, true);
  if (ret.size == 0)
    return ret;
  ret.databuff = buffer.slice(7);
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
  client.send(int8View.buffer);

  document.getElementById("msg").value = "";
}