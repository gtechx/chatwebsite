package routers

import (
	"github.com/astaxie/beego"
	"github.com/gtechx/chatwebsite/controllers"
)

func init() {
	beego.Router("/", &controllers.MainController{}, "*:Index")
	beego.Router("/install", &controllers.MainController{}, "*:Install")
	beego.AutoRouter(&controllers.MainController{})
	// beego.Router("/user/logout", &controllers.UserController{}, "*:Logout")
	// beego.Router("/user/index", &controllers.UserController{}, "*:Index")
	beego.AutoRouter(&controllers.UserController{})
}
