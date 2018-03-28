{{template "header.tpl" .}}

{{if eq .error ""}}
注册成功
<br/>
{{else}}
注册失败：{{str2html .error}}
{{end}}
<script type="text/javascript">
    function checkPassword(){
        if(document.getElementById('password1').value != document.getElementById('password2').value){
            alert("两次输入的密码不一致!");
            return false;
        }
        return true;
    }
</script>

<form method="post" action="main/register" onsubmit="return checkPassword();">
账号：<input type="text" name="account" />
<br/>
密码：<input type="password" name="password1" id="password1" oninput="document.getElementById('password').value = md5(this.value);" onpropertychange="document.getElementById('password').value = md5(this.value);" />
<br/>
确认密码：<input type="password" name="password2" id="password2" />
<input type="hidden" name="password" id="password" />
<br/>
<input type="submit" name="login_button" value="提交">
</form>

{{template "footer.tpl" .}}