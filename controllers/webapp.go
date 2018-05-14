package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/db"
)

type WebAppController struct {
	beego.Controller
}

func (c *WebAppController) Prepare() {
	//c.BaseController.Prepare()
}

func (c *WebAppController) Index() {
	count, _ := gtdb.Manager().GetAppCount()
	applist, _ := gtdb.Manager().GetAppList(0, int(count))
	c.Data["applist"] = applist
	c.TplName = "webapp.tpl"
}

func (c *WebAppController) ZoneList() {
	appname := c.GetString("appname")
	println("appname:", appname)
	if appname == "" {
		c.Ctx.Output.Body([]byte(""))
		return
	}

	var err error
	var errtext = ""
	var retjson []byte
	var zonelist []*gtdb.AppZone
	var pagezone PageData

	dbMgr := gtdb.Manager()
	flag, err := dbMgr.IsAppExists(appname)
	if err != nil {
		errtext = "数据库错误:" + err.Error()
		goto end
	}
	if !flag {
		errtext = "appname " + appname + " not exists!"
		goto end
	}

	zonelist, err = dbMgr.GetAppZoneList(appname)

	if err != nil {
		println(err.Error())
		errtext = "数据库错误:" + err.Error()
		goto end
	}

	pagezone = PageData{Total: uint64(len(zonelist)), Rows: zonelist}
	retjson, err = json.Marshal(pagezone)
	if err != nil {
		println(err.Error())
		errtext = "json解析错误:" + err.Error()
		goto end
	}

	c.Ctx.Output.Body(retjson)
end:
	c.Ctx.Output.Body([]byte("{\"error\":" + errtext + "}"))
}
