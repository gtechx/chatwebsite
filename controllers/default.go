package controllers

import (
	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/data"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	// c.Data["Website"] = "beego.me"
	// c.Data["Email"] = "astaxie@gmail.com"
	account := String(c.GetSession("account"))

	if account != "" {
		c.Redirect("/user/index", 301)
		return
	}
	c.TplName = "index.tpl"
}

func (c *MainController) Register() {
	if c.Ctx.Request.Method == "POST" {
		account := c.GetString("account")
		password := c.GetString("password")

		c.Data["account"] = account
		c.Data["post"] = true

		flag, err := gtdata.Manager().IsAccountExists(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if flag {
			c.Data["error"] = "账号已经存在"
			goto end
		}

		err = gtdata.Manager().CreateAccount(account, password, c.Ctx.Input.IP())

		if err != nil {
			c.Data["error"] = "数据库错误"
		}
	}
end:
	c.TplName = "register.tpl"
}

func (c *MainController) Login() {
	if c.Ctx.Request.Method == "POST" {
		account := c.GetString("account")
		password := c.GetString("password")

		c.Data["account"] = account
		c.Data["post"] = true

		flag, err := gtdata.Manager().IsAccountExists(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if !flag {
			c.Data["error"] = "账号存在"
			goto end
		}

		uid, err := gtdata.Manager().GetUIDByAccount(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		upass, err := gtdata.Manager().GetPassword(uid)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if upass != password {
			c.Data["error"] = "密码错误"
			goto end
		}

		println("account ", account, " logined success")

		c.SetSession("account", account)
		c.SetSession("password", password)
		c.SetSession("uid", uid)

		c.Redirect("/user/index", 301)
		return
	}
end:
	c.TplName = "login.tpl"
}
