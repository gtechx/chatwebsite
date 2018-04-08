package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/data"
)

type UserController struct {
	beego.Controller
	datakey *gtdata.DataKey
}

func (c *UserController) Prepare() {
	datakey, ok := c.GetSession("datakey").(*gtdata.DataKey)

	if !ok {
		c.Redirect("/", 303)
		return
	}

	c.datakey = datakey
	c.Data["account"] = datakey.Account
}

func (c *UserController) Index() {
	c.TplName = "user.tpl"
}

func (c *UserController) Logout() {
	//c.DelSession("account")
	//c.DelSession("password")
	c.DelSession("datakey")

	c.Redirect("/", 302)
}

func (c *UserController) App() {
	c.TplName = "user_app.tpl"
}

func (c *UserController) AppCreate() {
	if c.Ctx.Request.Method == "POST" {
		name := c.GetString("name")
		desc := c.GetString("desc")
		apptype := c.GetString("type")

		println("appcreate ", name, desc, apptype)
		c.Data["post"] = true

		if name != "" {
			flag, err := gtdata.Manager().IsAppExists(name)

			if err != nil {
				println(err.Error())
				c.Data["error"] = "数据库错误"
			} else if flag {
				c.Data["error"] = "应用名字已经存在"
			} else {
				err := gtdata.Manager().CreateApp(c.datakey.Account, name)
				if err == nil {
					c.Redirect("app", 302)
					return
				}

				println(err.Error())
				c.Data["error"] = "数据库错误"
			}
		} else {
			c.Data["error"] = "应用名字不能为空"
		}
		c.TplName = "user_appcreate.tpl"
	} else {
		c.TplName = "user_appcreate.tpl"
	}
}

type pageApp struct {
	Total uint64        `json:"total"`
	Rows  []*gtdata.App `json:"rows"`
}

func (c *UserController) AppData() {
	// data := "[{\"id\": 0, \"name\": \"item0\", \"price\": \"$0\", \"amount11\": 0, \"amount\": 0}, {\"id\": 1, \"name\": \"item1\", \"price\": \"$1\", \"amount\": 1}]"
	// data1 := "[{\"id\": 2, \"name\": \"item2\", \"price\": \"$2\", \"amount\": 2}, {\"id\": 3, \"name\": \"item3\", \"price\": \"$3\", \"amount\": 3}]"

	// index := Int(c.Ctx.Input.Param("0"))
	// if index%2 == 0 {
	// 	c.Ctx.Output.Body([]byte(data))
	// } else {
	// 	c.Ctx.Output.Body([]byte(data1))
	// }
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	println("pageNumber:", index, " pageSize:", pagesize)

	totalcount, err := gtdata.Manager().GetAppCount(c.datakey)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	appnamelist, err := gtdata.Manager().GetAppnameByPage(c.datakey, index*pagesize, index*pagesize+pagesize-1)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	applist := []*gtdata.App{}
	for _, appname := range appnamelist {
		c.datakey.SetAppname(appname)
		app, err := gtdata.Manager().GetApp(c.datakey)
		if err != nil {
			println(err.Error())
			c.Ctx.Output.Body([]byte("[]"))
			return
		}
		applist = append(applist, app)
	}

	pageapp := pageApp{Total: totalcount, Rows: applist}
	retjson, err := json.Marshal(pageapp)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	c.Ctx.Output.Body(retjson)
}
