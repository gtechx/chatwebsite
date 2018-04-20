package admin

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
	c.account = account
}

func (c *AppDataController) AppData() {
	c.TplName = "user_app.tpl"
}

func (c *AppDataController) AppDataCreate() {
	if c.Ctx.Request.Method == "POST" {
		appname := c.GetString("appname")
		zonename := c.GetString("zonename")
		account := c.GetString("account")
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
		var tbl_app *gtdb.App

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

		//check account
		if account == "" {
			c.Data["error"] = "account不能为空"
			goto end
		}
		flag, err = dbManager.IsAccountExists(account)
		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}
		if !flag {
			c.Data["error"] = "account:" + account + " 不存在"
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
		if !flag {
			c.Data["error"] = "nickname:" + nickname + " 已经存在"
			goto end
		}

		tbl_appdata = &gtdb.AppData{Appname: appname, Zonename: zonename, Account: account, Nickname: nickname, Desc: desc, Sex: sex, Country: country, Birthday: birthday, Regip: c.Ctx.Input.IP()}
		err = dbManager.CreateAppData(tbl_appdata)

		if err != nil {
			println(err.Error())
			c.Data["error"] = "数据库错误"
			goto end
		}

		c.Redirect("appdata", 302)
		return
	}
end:
	c.TplName = "user_appdatacreate.tpl"
}

func (c *AppDataController) AppDataModify() {
	id := c.GetString("id")
	dataManager := gtdb.Manager()
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
		new_appdata := &gtdb.Account{Nickname: nickname, Desc: desc, Sex: sex, Country: country, Birthday: birthday}

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
		appdata, err := dataManager.GetAppData(id)

		if err == nil {
			c.Data["appdata"] = appdata
		} else {
			println(err.Error())
			c.Data["error"] = "数据库错误:" + err.Error()
		}
	}
end:
	c.TplName = "user_appmodify.tpl"
}

func (c *AppDataController) AppDataDel() {
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

func (c *AppDataController) AppDataList() {
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	appname := c.GetString("appname")
	zonename := c.GetString("zonename")
	account := c.GetString("account")

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

	lbdate, err := time.Parse("01/02/2006", c.GetString("lastloginbegindate"))
	if err == nil {
		appdatafilter.Lastloginbegindate = &lbdate
	}
	ledate, err := time.Parse("01/02/2006", c.GetString("lastloginenddate"))
	if err == nil {
		appdatafilter.Lastloginenddate = &ledate
	}
	cbdate, err := time.Parse("01/02/2006", c.GetString("lastloginenddate"))
	if err == nil {
		appdatafilter.Createbegindate = &cbdate
	}
	cedate, err := time.Parse("01/02/2006", c.GetString("createenddate"))
	if err == nil {
		appdatafilter.Createenddate = &cedate
	}

	println("pageNumber:", index, " pageSize:", pagesize)

	dataManager := gtdb.Manager()
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

	appdatalist, err := dataManager.GetAppDataList(appname, zonename, account, index*pagesize, index*pagesize+pagesize-1, appdatafilter)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	pageapp := pageData{Total: totalcount, Rows: appdatalist}
	retjson, err := json.Marshal(pageapp)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	c.Ctx.Output.Body(retjson)
}
