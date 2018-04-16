package main

import (
	"html/template"
	"math/rand"
	"time"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/config"
	"github.com/gtechx/chatserver/db"
	_ "github.com/gtechx/chatwebsite/routers"
)

func Add(a, b int) int {
	return a + b
}

func HtmlAttr(attr string) template.HTMLAttr {
	return template.HTMLAttr(attr)
}

func RandString() string {
	r := rand.New(rand.NewSource(time.Now().Unix()))
	return String(r.Uint32())
}

func main() {
	err := gtdb.Manager().InitializeRedis(config.RedisAddr, config.RedisPassword, config.RedisDefaultDB)
	if err != nil {
		println("InitializeRedis err:", err.Error())
		return
	}
	defer gtdb.Manager().UnInitialize()

	err = gtdb.Manager().InitializeMysql(config.MysqlAddr, config.MysqlUserPassword, config.MysqlDefaultDB, config.MysqlTablePrefix)
	if err != nil {
		println("InitializeMysql err:", err.Error())
		return
	}

	beego.AddFuncMap("Add", Add)
	beego.AddFuncMap("HtmlAttr", HtmlAttr)
	beego.AddFuncMap("RandString", RandString)
	beego.Run()
}
