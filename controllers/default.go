package controllers

import (
	"github.com/astaxie/beego"
	"github.com/gtechx/chatserver/data"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	// c.Data["Website"] = "beego.me"
	// c.Data["Email"] = "astaxie@gmail.com"
	c.TplName = "index.tpl"
}

func (c *MainController) Register() {
	if req.Method == "POST" {
		account := c.GetString("account")
		password := c.GetString("password")

		c.Data["account"] = account

		flag, err := gtdata.Manager().IsAccountExists(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if flag {
			c.Data["error"] = "账号已经存在"
			goto end
		}

		err = gtdata.Manager().CreateAccount(account, password, this.Ctx.Input.IP())

		if err != nil {
			c.Data["error"] = "数据库错误"
		}
	}
	c.TplName = "register.tpl"
}

func (c *MainController) Create() {
	account := c.GetString("account")
	password := c.GetString("password")

	c.Data["account"] = account

	flag, err := gtdata.Manager().IsAccountExists(account)

	if err != nil {
		c.Data["error"] = "数据库错误"
		goto end
	}

	if flag {
		c.Data["error"] = "账号已经存在"
		goto end
	}

	err = gtdata.Manager().CreateAccount(account, password, this.Ctx.Input.IP())

	if err != nil {
		c.Data["error"] = "数据库错误"
	}

	c.Redirect

end:
	c.TplName = "register.tpl"
}

func (c *MainController) Login() {
}
