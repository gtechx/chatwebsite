{{template "header.tpl" .}}

{{if .post}}
{{if .error}}
登录失败：{{str2html .error}}
<br/>
{{end}}
{{end}}

{{template "login_form.tpl" .}}

{{template "footer.tpl" .}}