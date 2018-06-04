{{template "header.tpl" .}}

<script type="text/javascript">
    var WsClient = {
        new : function (addr) {
            var client = {};
            client.addr = addr;
            client.onopen = null;
            client.onmessage = null;
            client.onclose = null;
            client.onerror = null;

            var ws;
            var headerParser;
            var msgParser;
            client.connect = function () {
                ws = new WebSocket("ws://" + addr);
                ws.binaryType = "arraybuffer";

                ws.onopen = onopen;
                ws.onmessage = onmessage;
                ws.onclose = onclose;
                ws.onerror = onerror;
            };
            client.close = function () {
                ws.close();
                ws = null;
            };
            client.send = function (data) {
                ws.send(data);
            };
            client.setHeaderParser = function (fn) {
                headerParser = fn;
            };
            client.setMsgParser = function (fn) {
                msgParser = fn;
            };
            function onopen(evt) {
                if(client.onopen != null){
                    client.onopen(evt);
                }
            };
            function onmessage(evt) {
                // if(headerParser != null) {
                //     var datasize = headerParser(evt.data);
                //     if(datasize > 0) {
                //         msgParser(evt.data.slice(2));
                //     }
                // }
                if(client.onmessage != null){
                    client.onmessage(evt.data);
                }
            };
            function onclose(evt) {
                if(client.onclose != null){
                    client.onclose(evt);
                }
            };
            function onerror(evt) {
                if(client.onerror != null){
                    client.onerror(evt);
                }
            };

            return client;
        }
    };
</script>
<script src="/static/js/long.js"></script>
<script src="/static/js/webapp/binarystream.js?{{RandString}}"></script>

{{template "webapp_login_form.tpl" .}}

<script src="/static/js/webapp/app.js?{{RandString}}"></script>
<script src="/static/js/webapp.js?{{RandString}}"></script>

{{template "footer.tpl" .}}