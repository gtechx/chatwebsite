package controllers

import (
	"encoding/json"
	"time"

	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/db"
)

type OnlineController struct {
	BaseController
}

func (c *OnlineController) Prepare() {
	c.BaseController.Prepare()
	c.Data["nav"] = "useronline"
}

func (c *OnlineController) Index() {
	count, _ := gtdb.Manager().GetAppCountByAccount(c.account)
	applist, _ := gtdb.Manager().GetAppListByAccount(c.account, 0, int(count))
	c.Data["applist"] = applist
	c.TplName = "online.tpl"
}

func (c *OnlineController) List() {
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	println("pageNumber:", index, " pageSize:", pagesize)

	appfilter := &gtdb.AppFilter{}
	appfilter.Appname = c.GetString("appnamefilter")
	appfilter.Desc = c.GetString("descfilter")
	appfilter.Share = c.GetString("sharefilter")

	cbdate, err := time.Parse("01/02/2006", c.GetString("createbegindate"))
	if err == nil {
		appfilter.Createbegindate = &cbdate
	}
	cedate, err := time.Parse("01/02/2006", c.GetString("createenddate"))
	if err == nil {
		appfilter.Createenddate = &cedate
	}

	dataManager := gtdb.Manager()
	totalcount, err := dataManager.GetAppCountByAccount(c.account, appfilter)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	applist, err := dataManager.GetAppListByAccount(c.account, index*pagesize, index*pagesize+pagesize-1, appfilter)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	pageapp := PageData{Total: totalcount, Rows: applist}
	retjson, err := json.Marshal(pageapp)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	c.Ctx.Output.Body(retjson)
}
