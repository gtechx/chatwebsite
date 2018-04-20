package controllers

import (
	"encoding/json"
	"strings"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/db"
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

		dataManager := gtdb.Manager()
		var flag bool
		var err error
		var tbl_app *gtdb.App

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

		tbl_app = &gtdb.App{Name: name, Owner: c.account, Desc: desc, Share: share}
		err = dataManager.CreateApp(tbl_app)

		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误"
			goto end
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
	dataManager := gtdb.Manager()
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
		err := dataManager.SetShareApp(appname, share)
		if err != nil {
			println("dataManager.SetShareApp ", err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}

		err = dataManager.SetAppField(appname, "desc", desc)

		if err != nil {
			println("dataManager.SetAppField ", err.Error())
			c.Data["error"] = "设置应用描述时数据库错误:" + err.Error()
			goto end
		}

		c.Data["desc"] = desc
		c.Data["share"] = share
	} else {
		app, err := dataManager.GetApp(appname)

		if err == nil {
			c.Data["desc"] = app.Desc
			c.Data["share"] = app.Share
		} else {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
		}
	}
end:
	c.TplName = "user_appmodify.tpl"
}

func (c *UserController) AppDel() {
	appnames := c.GetStrings("appname[]")

	errtext := ""
	err := gtdb.Manager().DeleteApps(appnames)
	if err != nil {
		errtext = "数据库错误:" + err.Error()
	}

	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

type pageApp struct {
	Total uint64      `json:"total"`
	Rows  []*gtdb.App `json:"rows"`
}

func (c *UserController) AppList() {
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	println("pageNumber:", index, " pageSize:", pagesize)

	dataManager := gtdb.Manager()
	totalcount, err := dataManager.GetAppCountByAccount(c.account)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	applist, err := dataManager.GetAppListByAccount(c.account, index*pagesize, index*pagesize+pagesize-1)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	pageapp := pageData{Total: totalcount, Rows: applist}
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
	var retjson []byte
	//var err error
	var zonelist []*gtdb.AppZone
	var tbl_zone *gtdb.AppZone
	if c.Ctx.Request.Method == "POST" {
		appname := c.GetString("appname")
		zonename := c.GetString("zonename")
		println(appname, " ", zonename)
		if zonename == "" {
			c.Ctx.Output.Body([]byte(""))
			return
		}
		zonenamearr := strings.Split(zonename, ";")

		dataManager := gtdb.Manager()
		appowner, err := dataManager.GetAppOwner(appname)
		if err != nil {
			errtext = "数据库错误:" + err.Error()
			goto end
		}
		if appowner != c.account {
			errtext = "没有权限操作该应用：" + appname
			goto end
		}
		for _, zname := range zonenamearr {
			flag, err := dataManager.IsAppZoneExists(appname, zname)

			if err != nil {
				errtext = "zone " + zname + " add redis error"
				continue
			}

			if flag {
				errtext = "zone " + zname + " already exists"
				continue
			}

			tbl_zone = &gtdb.AppZone{Name: zname, Owner: appname}
			err = dataManager.AddAppZone(tbl_zone)

			if err != nil {
				errtext = "zone " + zname + " add redis error"
			}
		}

		println(errtext)
		zonelist, err = dataManager.GetAppZones(appname)

		retjson, err = json.Marshal(zonelist)
		if err != nil {
			println(err.Error())
			c.Ctx.Output.Body([]byte(""))
			return
		}

		c.Ctx.Output.Body(retjson)
		return
	end:
		println(errtext)
		c.Ctx.Output.Body([]byte("{error:" + errtext + "}"))
	}
}

func (c *UserController) ZoneDel() {
	appname := c.GetString("appname")
	zonenames := c.GetStrings("zonename[]")
	dataManager := gtdb.Manager()

	errtext := ""
	for _, zonename := range zonenames {
		err := dataManager.RemoveAppZone(appname, zonename)

		if err != nil {
			errtext = "数据库错误:" + err.Error()
		}
	}

	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

func (c *UserController) ZoneList() {
	appname := c.GetString("appname")
	println(appname)
	if appname == "" {
		c.Ctx.Output.Body([]byte(""))
		return
	}

	var err error
	var errtext = ""
	var retjson []byte
	var zonelist []*gtdb.AppZone

	dbMgr := gtdb.Manager()
	appowner, err := dbMgr.GetAppOwner(appname)
	if err != nil {
		errtext = "数据库错误"
		goto end
	}
	if appowner != c.account {
		errtext = "没有权限操作该app"
		goto end
	}

	zonelist, err = dbMgr.GetAppZones(appname)

	retjson, err = json.Marshal(zonelist)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte(""))
		return
	}

	c.Ctx.Output.Body(retjson)
	return
end:
	c.Ctx.Output.Body([]byte("{error:" + errtext + "}"))
}
