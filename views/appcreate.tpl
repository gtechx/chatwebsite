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

<div class="bg-light">
{{if .post}}
    {{if .error}}
    <div class="alert alert-danger">创建失败：{{str2html .error}}</div>
    <br/>
    {{end}}
{{end}}
  <form method="post" action="create" onsubmit="return checkData();">
    <div class="form-group">
      <label for="name">应用名字：</label>
      <input type="text" class="form-control" id="name" name="name">
    </div>
    <div class="form-group">
      <label for="desc">应用介绍：</label>
      <textarea class="form-control" id="desc" name="desc" rows="3"></textarea>
    </div>
    <div class="form-group">
      <label for="share">共享数据应用名字：</label>
      <input type="text" class="form-control" id="share" name="share">
    </div>    
    <button type="submit" class="btn btn-outline-primary btn-lg btn-block mb-3" style="width:100px;">创建</button>
  </form>

</div>

{{template "footer.tpl" .}}