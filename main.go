package main

import (
	"html/template"
	"math/rand"
	"time"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/data"
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
	gtdata.Manager().Initialize()
	beego.AddFuncMap("Add", Add)
	beego.AddFuncMap("HtmlAttr", HtmlAttr)
	beego.AddFuncMap("RandString", RandString)
	beego.Run()
	gtdata.Manager().UnInitialize()
}
