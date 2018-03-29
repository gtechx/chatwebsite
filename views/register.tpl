{{template "header.tpl" .}}

{{if .post}}
    {{if not .error}}
        注册成功
        <br/>
    {{else}}
        注册失败：{{str2html .error}}
        <br/>
        {{template "register_form.tpl" .}}
    {{end}}
{{else}}
    {{template "register_form.tpl" .}}
{{end}}

<a href="login">点击这里登录</a>

{{template "footer.tpl" .}}