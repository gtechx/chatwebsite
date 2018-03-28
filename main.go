package main

import (
	"html/template"

	"github.com/astaxie/beego"
	"github.com/gtechx/chatserver/data"
	_ "github.com/gtechx/website/routers"
)

func Add(a, b int) int {
	return a + b
}

func HtmlAttr(attr string) template.HTMLAttr {
	return template.HTMLAttr(attr)
}

func main() {
	gtdata.Manager().Initialize()
	beego.AddFuncMap("Add", Add)
	beego.AddFuncMap("HtmlAttr", HtmlAttr)
	beego.Run()
	gtdata.Manager().UnInitialize()
}
