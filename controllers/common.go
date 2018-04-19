package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"math/rand"
	"time"
)

type pageData struct {
	Total uint64      `json:"total"`
	Rows  interface{} `json:"rows"`
}

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
