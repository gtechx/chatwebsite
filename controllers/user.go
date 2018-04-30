package controllers

import (
	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
)

type UserController struct {
	beego.Controller
	account string
}

func (c *UserController) Prepare() {
	account := String(c.GetSession("account"))
	if account == "" {
		c.Redirect("/", 302)
		return
	}
	c.Data["account"] = account
	c.Data["nav"] = "user"
	c.account = account
}

func (c *UserController) Index() {
	c.TplName = "user.tpl"
}

func (c *UserController) Logout() {
	//c.DelSession("account")
	//c.DelSession("password")
	c.DelSession("account")

	c.Redirect("/", 302)
}
