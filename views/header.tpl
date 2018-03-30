<!doctype html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>register</title>
<meta content="GTech Inc." name="Copyright" />
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="/static/js/md5.min.js"></script>
</head>
<body>
<header class="navbar navbar-expand-lg navbar-light" style="background-color: #e3f2fd;">
  <a class="navbar-brand mr-md-auto" href="/">
    ChatWebSite
  </a>
  
  {{if .account}}
  <div class="mr-md-2">
    欢迎 <a>{{str2html .account}}</a>
    <a href="/user/logout?{{RandString}}">退出登录</a>
  </div>
  {{end}}
</header>
<div class="container-fluid">