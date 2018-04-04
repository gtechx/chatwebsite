package controllers

import (
	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/data"
)

type MainController struct {
	beego.Controller
}

// func (c *MainController) Prepare() {
// 	account := String(c.GetSession("account"))

// 	println("MainController Index account ", account)
// 	if account != "" {
// 		c.Redirect("/user/index", 303)
// 		return
// 	}
// }

func (c *MainController) Index() {
	// c.Data["Website"] = "beego.me"
	// c.Data["Email"] = "astaxie@gmail.com"
	account := String(c.GetSession("account"))

	if account != "" {
		c.Redirect("/user/index", 302)
		return
	}

	c.TplName = "index.tpl"
}

func (c *MainController) Register() {
	if c.Ctx.Request.Method == "POST" {
		account := c.GetString("account")
		password := c.GetString("password")

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

		c.Data["post"] = true

		flag, err := gtdata.Manager().IsAccountExists(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if !flag {
			c.Data["error"] = "账号不存在！"
			goto end
		}

		// uid, err := gtdata.Manager().GetUIDByAccount(account)

		// if err != nil {
		// 	c.Data["error"] = "数据库错误"
		// 	goto end
		// }

		upass, err := gtdata.Manager().GetPassword(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if upass != password {
			c.Data["error"] = "密码错误"
			goto end
		}

		println("account ", account, " logined success")

		c.Data["account"] = account

		c.SetSession("account", account)
		c.SetSession("password", password)
		//c.SetSession("uid", uid)

		datakey := new(gtdata.DataKey)
		datakey.Init("", "", account, 0, 0)
		c.SetSession("datakey", datakey)

		c.Redirect("/user/index", 302)
		return
	}
end:
	c.TplName = "login.tpl"
}
