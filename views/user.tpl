{{template "header.tpl" .}}

欢迎 <a>{{str2html .account}}</a>
<a href="logout">退出登录</a>

{{template "footer.tpl" .}}