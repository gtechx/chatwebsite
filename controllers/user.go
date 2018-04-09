package controllers

import (
	"encoding/json"
	"strings"

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
		c.Redirect("/", 302)
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
		share := c.GetString("share")

		println("appcreate ", name, desc, share)
		c.Data["post"] = true

		dataManager := gtdata.Manager()
		var flag bool
		var err error

		if name == "" {
			c.Data["error"] = "应用名字不能为空"
			goto end
		}

		flag, err = dataManager.IsAppExists(name)

		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误"
			goto end
		}

		if flag {
			c.Data["error"] = "应用名字已经存在"
			goto end
		}

		if share != "" {
			flag, err = dataManager.IsAppExists(share)

			if err != nil {
				println(err.Error())
				c.Data["error"] = "数据库错误"
				goto end
			}

			if !flag {
				c.Data["error"] = "共享数据应用名字不存在"
				goto end
			}
		}

		err = dataManager.CreateApp(c.datakey.Account, name)

		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误"
			goto end
		}
		c.datakey.SetAppname(name)

		if share != "" {
			err = dataManager.AddShareApp(c.datakey, share)

			if err != nil {
				println(err.Error())
				c.Data["error"] = "数据库错误"
				goto end
			}
		}

		if desc != "" {
			err = dataManager.SetAppField(c.datakey, "desc", desc)

			if err != nil {
				println(err.Error())
				c.Data["error"] = "应用已经创建成功，但是设置应用描述时数据库错误"
				goto end
			}
		}

		c.Redirect("app", 302)
		return
	end:
		c.TplName = "user_appcreate.tpl"
	} else {
		c.TplName = "user_appcreate.tpl"
	}
}

func (c *UserController) AppModify() {
	appname := c.GetString("appname")
	dataManager := gtdata.Manager()
	c.datakey.SetAppname(appname)
	c.Data["appname"] = appname

	if appname == "" {
		c.Data["error"] = "应用名字为空"
		goto end
	}

	if c.Ctx.Request.Method == "POST" {
		desc := c.GetString("desc")
		share := c.GetString("share")
		c.Data["post"] = true

		println(appname, desc, share)
		shareappname, err := dataManager.GetShareApp(c.datakey)

		if err != nil {
			shareappname = ""
		}

		if share != "" {
			if shareappname != "" {
				err = dataManager.DelShareApp(c.datakey, shareappname)
				if err != nil {
					println("dataManager.DelShareApp ", err.Error())
					c.Data["error"] = "数据库错误"
					goto end
				}
			}
			err = dataManager.AddShareApp(c.datakey, share)

			if err != nil {
				println("dataManager.AddShareApp ", err.Error())
				c.Data["error"] = "数据库错误"
				goto end
			}
		}

		err = dataManager.SetAppField(c.datakey, "desc", desc)

		if err != nil {
			println("dataManager.SetAppField ", err.Error())
			c.Data["error"] = "设置应用描述时数据库错误"
			goto end
		}

		c.Data["desc"] = desc
		c.Data["share"] = share
	} else {
		app, err := dataManager.GetApp(c.datakey)

		if err == nil {
			c.Data["desc"] = app.Desc
			c.Data["share"] = app.Share
		} else {
			println(err.Error())
			c.Data["error"] = "数据库错误"
		}
	}
end:
	c.TplName = "user_appmodify.tpl"
}

type pageApp struct {
	Total uint64        `json:"total"`
	Rows  []*gtdata.App `json:"rows"`
}

func (c *UserController) AppList() {
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

	dataManager := gtdata.Manager()
	totalcount, err := dataManager.GetAppCount(c.datakey)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	appnamelist, err := dataManager.GetAppnameByPage(c.datakey, index*pagesize, index*pagesize+pagesize-1)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	applist := []*gtdata.App{}
	for _, appname := range appnamelist {
		c.datakey.SetAppname(appname)
		app, err := dataManager.GetApp(c.datakey)
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

func (c *UserController) ZoneAdd() {
	errtext := ""
	if c.Ctx.Request.Method == "POST" {
		appname := c.GetString("appname")
		zonename := c.GetString("zonename")
		println(appname, " ", zonename)
		if zonename == "" {
			c.Ctx.Output.Body([]byte(""))
			return
		}
		zonenamearr := strings.Split(zonename, ";")
		c.datakey.SetAppname(appname)

		dataManager := gtdata.Manager()
		for _, zname := range zonenamearr {
			flag, err := dataManager.IsAppZone(c.datakey, zname)

			if err != nil {
				errtext = "zone " + zname + " add redis error"
				continue
			}

			if flag {
				errtext = "zone " + zname + " already exists"
				continue
			}

			c.datakey.SetZonename(zname)
			err = dataManager.AddAppZone(c.datakey)

			if err != nil {
				errtext = "zone " + zname + " add redis error"
			}
		}

		println(errtext)
		zonelist, err := dataManager.GetAppZones(c.datakey)

		retjson, err := json.Marshal(zonelist)
		if err != nil {
			println(err.Error())
			c.Ctx.Output.Body([]byte(""))
			return
		}

		c.Ctx.Output.Body(retjson)
	}
}

func (c *UserController) ZoneList() {
	appname := c.GetString("appname")
	println(appname)
	if appname == "" {
		c.Ctx.Output.Body([]byte(""))
		return
	}

	c.datakey.SetAppname(appname)

	zonelist, err := gtdata.Manager().GetAppZones(c.datakey)

	retjson, err := json.Marshal(zonelist)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte(""))
		return
	}

	c.Ctx.Output.Body(retjson)
}
