package routers

import (
	"github.com/astaxie/beego"
	"github.com/gtechx/chatwebsite/controllers"
)

func init() {
	beego.Router("/", &controllers.MainController{})
	beego.AutoRouter(&controllers.MainController{})
	beego.AutoRouter(&controllers.UserController{})
}
