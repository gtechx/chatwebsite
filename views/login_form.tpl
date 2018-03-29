<form method="post" action="/main/login" onsubmit="return true;">
账号：<input type="text" name="account" />
<br/>
密码：<input type="password" name="password" oninput="document.getElementById('mypassword').value = md5(this.value);" onpropertychange="document.getElementById('mypassword').value = md5(this.value);" />
<input type="hidden" name="mypassword" id="mypassword" />
<br/>
<input type="submit" name="login_button" value="登录">
</form>
<br/>
<a href="/main/register">点击此处注册</a>
