package controllers

import (
	"encoding/json"
	"fmt"
	"reflect"
	"time"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/db"
)

type AppDataController struct {
	beego.Controller
	account string
}

func (c *AppDataController) Prepare() {
	account := String(c.GetSession("account"))
	if account == "" {
		c.Redirect("/", 302)
		return
	}
	c.Data["account"] = account
	c.Data["isadmin"] = true
	c.account = account
}

func (c *AppDataController) Index() {
	count, _ := gtdb.Manager().GetAppCountByAccount(c.account)
	applist, _ := gtdb.Manager().GetAppListByAccount(c.account, 0, int(count))
	c.Data["applist"] = applist
	c.TplName = "appdata.tpl"
}

func (c *AppDataController) Create() {
	if c.Ctx.Request.Method == "POST" {
		appname := c.GetString("appname")
		zonename := c.GetString("zonename")
		nickname := c.GetString("nickname")
		desc := c.GetString("desc")
		sex := c.GetString("sex")
		country := c.GetString("country")
		//birthday := c.GetString("birthday")
		birthday, _ := time.Parse("01/02/2006", c.GetString("birthday"))

		c.Data["post"] = true

		dbManager := gtdb.Manager()
		var flag bool
		var err error
		var tbl_appdata *gtdb.AppData

		//check app
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

		//check zone
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

		//check nickname
		if nickname == "" {
			c.Data["error"] = "nickname不能为空"
			goto end
		}
		flag, err = dbManager.IsNicknameExists(appname, zonename, nickname)
		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}
		if flag {
			c.Data["error"] = "nickname:" + nickname + " 已经存在"
			goto end
		}

		tbl_appdata = &gtdb.AppData{Appname: appname, Zonename: zonename, Account: c.account, Nickname: nickname, Desc: desc, Sex: sex, Country: country, Birthday: birthday, Regip: c.Ctx.Input.IP()}
		err = dbManager.CreateAppData(tbl_appdata)

		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误"
			goto end
		}

		c.Redirect("index", 302)
		return
	} else {
		count, _ := gtdb.Manager().GetAppCountByAccount(c.account)
		applist, _ := gtdb.Manager().GetAppListByAccount(c.account, 0, int(count))
		c.Data["applist"] = applist
	}
end:
	c.TplName = "appdata_create.tpl"
}

func (c *AppDataController) Update() {
	id := Uint64(c.GetString("id"))
	dbmanager := gtdb.Manager()
	c.Data["id"] = id

	if id <= 0 {
		c.Data["error"] = "id不应小于0"
		goto end
	}

	if c.Ctx.Request.Method == "POST" {
		nickname := c.GetString("nickname")
		desc := c.GetString("desc")
		sex := c.GetString("sex")
		country := c.GetString("country")
		//birthday := c.GetString("birthday")
		birthday, _ := time.Parse("01/02/2006", c.GetString("birthday"))
		c.Data["post"] = true

		blank_appdata := &gtdb.AppData{}
		old_appdata, err := dbmanager.GetAppData(id)
		new_appdata := &gtdb.AppData{Nickname: nickname, Desc: desc, Sex: sex, Country: country, Birthday: birthday}

		oldt := reflect.TypeOf(*old_appdata)
		oldv := reflect.ValueOf(old_appdata).Elem()
		//newt := reflect.TypeOf(new_account)
		newv := reflect.ValueOf(new_appdata).Elem()
		//blankt := reflect.TypeOf(old_account)
		blankv := reflect.ValueOf(blank_appdata).Elem()

		if err != nil {
			fmt.Println("error:", err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}

		for k := 0; k < oldt.NumField(); k++ {
			//fmt.Printf("%s -- %v \n", t.Filed(k).Name, v.Field(k).Interface())
			if oldv.Field(k).Type().Kind() != reflect.Slice && oldv.Field(k).Interface() != newv.Field(k).Interface() && newv.Field(k).Interface() != blankv.Field(k).Interface() {
				oldv.Field(k).Set(newv.Field(k))
			}
		}

		fmt.Println("old_appdata:", old_appdata)
		err = gtdb.Manager().UpdateAppData(old_appdata)

		if err != nil {
			fmt.Println("error:", err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
		}
	} else {
		appdata, err := dbmanager.GetAppData(id)

		if err == nil {
			c.Data["appdata"] = appdata
		} else {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
		}
	}
end:
	c.TplName = "appdatamodify.tpl"
}

func (c *AppDataController) Del() {
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

func (c *AppDataController) List() {
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	id, _ := c.GetUint64("id", 0)
	appname := c.GetString("appname")
	zonename := c.GetString("zonename")
	account := c.GetString("account")
	// if account != c.account {
	// 	account = c.account
	// }

	appdatafilter := &gtdb.AppDataFilter{}
	appdatafilter.Nickname = c.GetString("nickname")
	appdatafilter.Desc = c.GetString("desc")
	appdatafilter.Sex = c.GetString("sex")
	appdatafilter.Country = c.GetString("country")
	appdatafilter.Regip = c.GetString("regip")
	appdatafilter.Lastip = c.GetString("lastip")
	// lastloginbegindate := c.GetString("lastloginbegindate")
	// lastloginenddate := c.GetString("lastloginenddate")
	// createbegindate := c.GetString("createbegindate")
	// createenddate := c.GetString("createenddate")

	bbdate, err := time.Parse("01/02/2006", c.GetString("birthdaybegindate"))
	if err == nil {
		appdatafilter.Birthdaybegindate = &bbdate
	}
	bedate, err := time.Parse("01/02/2006", c.GetString("birthdayenddate"))
	if err == nil {
		appdatafilter.Birthdayenddate = &bedate
	}
	lbdate, err := time.Parse("01/02/2006", c.GetString("lastloginbegindate"))
	if err == nil {
		appdatafilter.Lastloginbegindate = &lbdate
	}
	ledate, err := time.Parse("01/02/2006", c.GetString("lastloginenddate"))
	if err == nil {
		appdatafilter.Lastloginenddate = &ledate
	}
	cbdate, err := time.Parse("01/02/2006", c.GetString("createbegindate"))
	if err == nil {
		appdatafilter.Createbegindate = &cbdate
	}
	cedate, err := time.Parse("01/02/2006", c.GetString("createenddate"))
	if err == nil {
		appdatafilter.Createenddate = &cedate
	}

	println("pageNumber:", index, " pageSize:", pagesize)

	dataManager := gtdb.Manager()

	if id != 0 {
		appdata, err := dataManager.GetAppData(id)

		if err != nil {
			println(err.Error())
			c.Ctx.Output.Body([]byte("[]"))
			return
		}

		pageapp := PageData{Total: 1, Rows: []*gtdb.AppData{appdata}}
		retjson, err := json.Marshal(pageapp)
		if err != nil {
			println(err.Error())
			c.Ctx.Output.Body([]byte("[]"))
			return
		}

		c.Ctx.Output.Body(retjson)
		return
	}

	if appname == "" {
		println("appname must not null")
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	totalcount, err := dataManager.GetAppDataCount(appname, zonename, account, appdatafilter)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	if totalcount == 0 {
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	appdatalist, err := dataManager.GetAppDataList(appname, zonename, account, index*pagesize, index*pagesize+pagesize-1, appdatafilter)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	pageapp := PageData{Total: totalcount, Rows: appdatalist}
	retjson, err := json.Marshal(pageapp)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	c.Ctx.Output.Body(retjson)
}

func (c *AppDataController) ZoneList() {
	appname := c.GetString("appname")
	account := c.GetString("account")
	if account != c.account {
		account = c.account
	}
	zonelist, err := gtdb.Manager().GetAppZoneList(appname)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	pagezone := PageData{Total: uint64(len(zonelist)), Rows: zonelist}
	retjson, err := json.Marshal(pagezone)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	c.Ctx.Output.Body(retjson)
}
