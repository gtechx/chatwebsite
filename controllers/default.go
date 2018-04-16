package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"math/rand"
	"time"

	"github.com/astaxie/beego"
	. "github.com/gtechx/base/common"
	"github.com/gtechx/chatserver/db"
)

type MainController struct {
	beego.Controller
}

// func (c *MainController) Prepare() {
// 	account := String(c.GetSession("account"))

// 	println("MainController Index account ", account)
// 	if account != "" {
// 		c.Redirect("/user/index", 303)
// 		return
// 	}
// }
var saltcount = 6

func getSalt() string {
	str := "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	bytes := []byte(str)
	result := make([]byte, saltcount)
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < saltcount; i++ {
		result[i] = bytes[r.Intn(len(bytes))]
	}
	return string(result)
}

// func getSaltedPassword(password, salt string) string {
// 	h := md5.New()
// 	h.Write([]byte(password))

// 	cipherStr := string(h.Sum(nil)) + salt

// 	h.Reset()
// 	h.Write([]byte(cipherStr))

// 	return string(h.Sum(nil))
// }

func getSaltedPassword(password, salt string) string {
	h := md5.New()
	h.Write([]byte(password))

	cipherStr := h.Sum(nil)
	hexText := make([]byte, 32)
	hex.Encode(hexText, cipherStr)

	h.Reset()
	h.Write(append(hexText, []byte(salt)...))

	cipherStr = h.Sum(nil)
	hex.Encode(hexText, cipherStr)
	return string(hexText)
}

func (c *MainController) Index() {
	// c.Data["Website"] = "beego.me"
	// c.Data["Email"] = "astaxie@gmail.com"
	account := String(c.GetSession("account"))

	if account != "" {
		c.Redirect("/user/index", 302)
		return
	}

	c.TplName = "index.tpl"
}

func (c *MainController) Register() {
	if c.Ctx.Request.Method == "POST" {
		account := c.GetString("account")
		password := c.GetString("password")

		c.Data["post"] = true

		flag, err := gtdb.Manager().IsAccountExists(account)

		if err != nil {
			c.Data["error"] = "数据库错误:" + err.Error()
			goto end
		}

		if flag {
			c.Data["error"] = "账号已经存在"
			goto end
		}

		salt := getSalt()
		md5password := getSaltedPassword(password, salt)
		println("salt:", salt, "password:", password, "md5password:", md5password)
		tbl_account := &gtdb.Account{Account: account, Password: md5password, Salt: salt, Regip: c.Ctx.Input.IP()}
		err = gtdb.Manager().CreateAccount(tbl_account)

		if err != nil {
			c.Data["error"] = "数据库错误:" + err.Error()
		}
	}
end:
	c.TplName = "register.tpl"
}

func (c *MainController) Login() {
	if c.Ctx.Request.Method == "POST" {
		account := c.GetString("account")
		password := c.GetString("password")

		c.Data["post"] = true

		flag, err := gtdb.Manager().IsAccountExists(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		if !flag {
			c.Data["error"] = "账号不存在！"
			goto end
		}

		// uid, err := gtdb.Manager().GetUIDByAccount(account)

		// if err != nil {
		// 	c.Data["error"] = "数据库错误"
		// 	goto end
		// }

		tbl_account, err := gtdb.Manager().GetAccount(account)

		if err != nil {
			c.Data["error"] = "数据库错误"
			goto end
		}

		md5password := getSaltedPassword(password, tbl_account.Salt)
		if md5password != tbl_account.Password {
			c.Data["error"] = "密码错误"
			goto end
		}

		println("account ", account, " logined success")

		c.Data["account"] = account

		c.SetSession("account", account)

		c.Redirect("/user/index", 302)
		return
	}
end:
	c.TplName = "login.tpl"
}

func (c *MainController) Install() {
	err := gtdb.Manager().Install()

	if err == nil {
		c.Ctx.Output.Body([]byte("install success!<br/><a href=\"/\">点击进入主页</a>"))
	} else {
		c.Ctx.Output.Body([]byte("{error:" + err.Error() + "}"))
	}
}
