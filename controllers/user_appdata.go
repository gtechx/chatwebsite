package controllers

import (
	"encoding/json"

	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/db"
)

func (c *UserController) AppData() {
	c.TplName = "user_app.tpl"
}

func checkEmptyAndExists(data, name string) {
	dbManager := gtdb.Manager()
	if data == "" {
		c.Data["error"] = name + "不能为空"
	}
}

func (c *UserController) AppDataCreate() {
	if c.Ctx.Request.Method == "POST" {
		appname := c.GetString("appname")
		zonename := c.GetString("zonename")
		nickname := c.GetString("nickname")
		desc := c.GetString("desc")
		sex := c.GetString("sex")
		country := c.GetString("country")
		birthday := c.GetString("birthday")

		println("AppDataCreate ", name, desc, share)
		c.Data["post"] = true

		dbManager := gtdb.Manager()
		var flag bool
		var err error
		var tbl_app *gtdb.App

		if appname == "" {
			c.Data["error"] = "appname不能为空"
			goto end
		}
		flag, err = dbManager.IsAppExists(appname)
		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}
		if !flag {
			c.Data["error"] = "appname:" + appname + " 不存在"
			goto end
		}
		if zonename == "" {
			c.Data["error"] = "zonename不能为空"
			goto end
		}
		flag, err = dbManager.IsAppZoneExists(appname, zonename)
		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}
		if !flag {
			c.Data["error"] = "zonename:" + zonename + " 不存在"
			goto end
		}
		if nickname == "" {
			c.Data["error"] = "nickname不能为空"
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

		c.Redirect("appdata", 302)
		return
	end:
		c.TplName = "user_appdatacreate.tpl"
	} else {
		c.TplName = "user_appdatacreate.tpl"
	}
}

func (c *UserController) AppDataModify() {
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

func (c *UserController) AppDataDel() {
	strappdatas := c.GetStrings("appdata[]")
	appdatas := make([]uint64, len(strappdatas))

	for i, strappdata := range strappdatas {
		appdatas[i] = Uint64(strappdata)
	}

	errtext := ""
	err := gtdb.Manager().DeleteAppDatas(appdatas)
	if err != nil {
		errtext = "数据库错误:" + err.Error()
	}

	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

func (c *UserController) AppDataList() {
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	appname := c.GetString("appname")
	zonename := c.GetString("zonename")

	println("pageNumber:", index, " pageSize:", pagesize)

	dataManager := gtdb.Manager()
	if appname == "" {
		println("appname must not null")
		c.Ctx.Output.Body([]byte("[]"))
		return
	}
	appowner, err := dataManager.GetAppOwner(appname)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}
	if appowner != c.account {
		println("no privilege")
		c.Ctx.Output.Body([]byte("[]"))
		return
	}
	totalcount, err := dataManager.GetAppDataCount(appname, zonename)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	applist, err := dataManager.GetAppByAccount(c.account, index*pagesize, index*pagesize+pagesize-1)

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
