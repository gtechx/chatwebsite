{{template "header.tpl" .}}

<script type="text/javascript">
    function checkData(){
        if(document.getElementById('name').value == ""){
            alert("请输入应用名字!");
            return false;
        }
        return true;
    }
</script>

<div class="row">
<div class="col-2">
</div>
<div class="col-8 bg-light">
  <div aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="index">主菜单</a></li>
      <li class="breadcrumb-item"><a href="app">应用管理</a></li>
      <li class="breadcrumb-item active" aria-current="page">应用创建</li>
    </ol>
  </div>

{{if .post}}
    {{if .error}}
    <div class="alert alert-danger">创建失败：{{str2html .error}}</div>
    <br/>
    {{end}}
{{end}}
  <form method="post" action="appcreate"  onsubmit="return checkData();">
    <div class="form-group">
      <label for="name">应用名字：</label>
      <input type="text" class="form-control" id="name" name="name">
    </div>
    <div class="form-group">
      <label for="desc">应用介绍：</label>
      <textarea class="form-control" id="desc" name="desc" rows="3"></textarea>
    </div>
    <div class="form-group">
      <label for="type">应用类型：</label>
      <select id="type" name="type" class="form-control col-1">
        <option selected>app</option>
        <option>game</option>
      </select>
    </div>
    
    <button type="submit" class="btn btn-outline-primary btn-lg btn-block mb-3" style="width:100px;">创建</button>
  </form>

</div>
<div class="col-2">
</div>
</div>

{{template "footer.tpl" .}}