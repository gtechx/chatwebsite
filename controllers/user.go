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

func (c *UserController) AppData() {
	data := "[{\"id\": 0, \"name\": \"item0\", \"price\": \"$0\", \"amount\": 0}, {\"id\": 1, \"name\": \"item1\", \"price\": \"$1\", \"amount\": 1}]"
	data1 := "[{\"id\": 2, \"name\": \"item2\", \"price\": \"$2\", \"amount\": 2}, {\"id\": 3, \"name\": \"item3\", \"price\": \"$3\", \"amount\": 3}]"

	index := Int(c.Ctx.Input.Param("0"))
	if index%2 == 0 {
		c.Ctx.Output.Body([]byte(data))
	} else {
		c.Ctx.Output.Body([]byte(data1))
	}
}
