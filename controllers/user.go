package controllers

import (
	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
)

type UserController struct {
	beego.Controller
}

func (c *UserController) Prepare() {
	account := String(c.GetSession("account"))

	if account == "" {
		c.Redirect("/", 303)
		return
	}

	c.Data["account"] = c.GetSession("account")
}

func (c *UserController) Index() {

	c.TplName = "user.tpl"
}

func (c *UserController) Logout() {
	c.DelSession("account")
	c.DelSession("password")
	c.DelSession("uid")

	c.Redirect("/", 302)
}

func (c *UserController) App() {
	c.TplName = "user_app.tpl"
}

func (c *UserController) AppCreate() {
	c.TplName = "user_appcreate.tpl"
}
