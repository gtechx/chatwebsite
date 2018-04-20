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

type AdminController struct {
	beego.Controller
	account string
}

func (c *AdminController) Prepare() {
	account := String(c.GetSession("account"))
	if account == "" {
		c.Redirect("/", 302)
		return
	}
	c.Data["account"] = account
	c.account = account
}

func (c *AdminController) Account() {
	c.TplName = "admin_account.tpl"
}

func (c *AdminController) AccountList() {
	index := Int(c.GetString("pageNumber")) - 1 //Int(c.Ctx.Input.Param("0"))
	pagesize := Int(c.GetString("pageSize"))    //Int(c.Ctx.Input.Param("1"))

	accountfilter := c.GetString("accountfilter")
	emailfilter := c.GetString("emailfilter")
	ipfilter := c.GetString("ipfilter")

	var begindate *time.Time
	var enddate *time.Time
	bdate, err := time.Parse("01/02/2006", c.GetString("begindate"))
	if err == nil {
		begindate = &bdate
	}
	edate, err := time.Parse("01/02/2006", c.GetString("enddate"))
	if err == nil {
		enddate = &edate
	}

	//fmt.Println("begindate", c.GetString("begindate"), begindate)
	//fmt.Println("enddate", c.GetString("enddate"), enddate)

	println("pageNumber:", index, " pageSize:", pagesize)

	dataManager := gtdb.Manager()
	totalcount, err := dataManager.GetAccountCount()

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	acclist, err := dataManager.GetAccountListByFilter(index*pagesize, index*pagesize+pagesize-1, accountfilter, emailfilter, ipfilter, begindate, enddate)

	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	pageapp := pageData{Total: totalcount, Rows: acclist}
	retjson, err := json.Marshal(pageapp)
	if err != nil {
		println(err.Error())
		c.Ctx.Output.Body([]byte("[]"))
		return
	}

	c.Ctx.Output.Body(retjson)
}

func (c *AdminController) AccountCreate() {
	account := c.GetString("account")
	password := c.GetString("password")
	email := c.GetString("email")

	var tbl_account *gtdb.Account
	errtext := ""
	salt := ""
	md5password := ""
	flag, err := gtdb.Manager().IsAccountExists(account)

	if err != nil {
		errtext = "数据库错误:" + err.Error()
		goto end
	}

	if flag || account == "admin" || account == "root" {
		errtext = "账号已经存在"
		goto end
	}

	if password == "" {
		errtext = "密码不能为空"
		goto end
	}

	salt = getSalt()
	md5password = getSaltedPassword(password, salt)
	println("salt:", salt, "password:", password, "md5password:", md5password)
	tbl_account = &gtdb.Account{Account: account, Password: md5password, Salt: salt, Email: email, Regip: c.Ctx.Input.IP()}
	err = gtdb.Manager().CreateAccount(tbl_account)

	if err != nil {
		errtext = "数据库错误:" + err.Error()
	}
end:
	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

func (c *AdminController) AccountUpdate() {
	account := c.GetString("account")
	password := c.GetString("password")
	email := c.GetString("email")

	dbmanager := gtdb.Manager()
	//var tbl_account *gtdb.Account
	errtext := ""
	//salt := ""
	//md5password := ""

	blank_account := &gtdb.Account{}
	old_account, err := dbmanager.GetAccount(account)
	new_account := &gtdb.Account{Account: account, Password: old_account.Password, Email: email}

	oldt := reflect.TypeOf(*old_account)
	oldv := reflect.ValueOf(old_account).Elem()
	//newt := reflect.TypeOf(new_account)
	newv := reflect.ValueOf(new_account).Elem()
	//blankt := reflect.TypeOf(old_account)
	blankv := reflect.ValueOf(blank_account).Elem()

	if err != nil {
		fmt.Println("error:", err.Error())
		errtext = "数据库错误:" + err.Error()
		goto end
	}

	if password != "" {
		new_account.Password = getSaltedPassword(password, old_account.Salt)
	}

	for k := 0; k < oldt.NumField(); k++ {
		//fmt.Printf("%s -- %v \n", t.Filed(k).Name, v.Field(k).Interface())
		if oldv.Field(k).Type().Kind() != reflect.Slice && oldv.Field(k).Interface() != newv.Field(k).Interface() && newv.Field(k).Interface() != blankv.Field(k).Interface() {
			oldv.Field(k).Set(newv.Field(k))
		}
	}

	fmt.Println("old_account:", old_account)
	err = gtdb.Manager().UpdateAccount(old_account)

	if err != nil {
		fmt.Println("error:", err.Error())
		errtext = "数据库错误:" + err.Error()
	}
end:
	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

func (c *AdminController) AccountDel() {
	accounts := c.GetStrings("account[]")
	dataManager := gtdb.Manager()

	errtext := ""
	err := dataManager.DeleteAccounts(accounts)

	if err != nil {
		errtext = "数据库错误:" + err.Error()
	}

	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

func (c *AdminController) AccountBan() {
	accounts := c.GetStrings("account[]")
	dataManager := gtdb.Manager()

	errtext := ""
	err := dataManager.BanAccounts(accounts)

	if err != nil {
		errtext = "数据库错误:" + err.Error()
	}

	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}

func (c *AdminController) AccountUnban() {
	accounts := c.GetStrings("account[]")
	dataManager := gtdb.Manager()

	errtext := ""
	err := dataManager.UnbanAccounts(accounts)

	if err != nil {
		errtext = "数据库错误:" + err.Error()
	}

	c.Ctx.Output.Body([]byte("{error:\"" + errtext + "\"}"))
}
