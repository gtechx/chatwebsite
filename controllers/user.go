package controllers

import (
	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
)

type UserController struct {
	beego.Controller
}

func (c *UserController) Index() {
	account := String(c.GetSession("account"))

	if account == "" {
		c.Redirect("/", 301)
		return
	}
	c.Data["account"] = c.GetSession("account")
	c.TplName = "user.tpl"
}

func (c *UserController) Logout() {
	c.DelSession("account")
	c.DelSession("password")
	c.DelSession("uid")

	c.Redirect("/", 301)
}
