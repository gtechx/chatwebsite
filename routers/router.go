package routers

import (
	"github.com/astaxie/beego"
	"github.com/gtechx/website/controllers"
)

func init() {
	beego.Router("/", &controllers.MainController{})
	beego.AutoRouter(&controllers.MainController{})
}
