package routers

import (
	"github.com/astaxie/beego"
	"github.com/gtechx/chatwebsite/controllers"
	"github.com/gtechx/chatwebsite/controllers/admin"
)

func init() {
	beego.Router("/", &controllers.MainController{}, "*:Index")
	beego.Router("/index", &controllers.MainController{}, "*:Index")
	beego.Router("/default", &controllers.MainController{}, "*:Index")
	beego.Router("/index.*", &controllers.MainController{}, "*:Index")
	beego.Router("/default.*", &controllers.MainController{}, "*:Index")
	beego.Router("/install", &controllers.MainController{}, "*:Install")
	beego.Router("/user", &controllers.UserController{}, "*:Index")
	//beego.Router("/admin", &controllers.UserController{}, "*:Index")
	//beego.Router("/admin/index", &controllers.UserController{}, "*:Index")
	beego.AutoRouter(&controllers.MainController{})
	// beego.Router("/user/logout", &controllers.UserController{}, "*:Logout")
	// beego.Router("/user/index", &controllers.UserController{}, "*:Index")
	beego.AutoRouter(&controllers.UserController{})
	//beego.AutoRouter(&admin.AccountController{})
	//beego.AutoRouter(&admin.AppDataController{})

	ns := beego.NewNamespace("/user",
		//CRUD Create(创建)、Read(读取)、Update(更新)和Delete(删除)
		//beego.NSAutoRouter(&controllers.UserController{}),
		beego.NSAutoRouter(&controllers.AppController{}),
		beego.NSAutoRouter(&controllers.ZoneController{}),
		beego.NSAutoRouter(&controllers.AppDataController{}),
	)
	beego.AddNamespace(ns)
	ns = beego.NewNamespace("/admin",
		//CRUD Create(创建)、Read(读取)、Update(更新)和Delete(删除)
		//beego.NSAutoRouter(&controllers.UserController{}),
		beego.NSAutoRouter(&admin.AccountController{}),
		beego.NSAutoRouter(&admin.AppDataController{}),
	)
	beego.AddNamespace(ns)
}
