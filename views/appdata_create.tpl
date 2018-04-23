{{template "header.tpl" .}}

<script type="text/javascript">
    function checkData(){
        if(document.getElementById('nickname').value == ""){
            alert("请输入昵称!");
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
      <label for="nickname">昵称：</label>
      <input type="text" class="form-control" id="nickname" name="nickname">
    </div>
    <div class="form-group">
      <label for="desc">描述：</label>
      <textarea class="form-control" id="desc" name="desc" rows="3"></textarea>
    </div>
    <div class="form-group">
      <label for="sex">性别：</label>
      <select class="form-control" name="sex" id="sex">
          <option>男</option>
          <option>女</option>
      </select>
    </div>
    <div class="form-group">
      <label for="birthday">生日：</label>
      <input type="text" class="form-control" id="birthday" name="birthday">
    </div>
    <div class="form-group">
      <label for="country">国家：</label>
      <input type="text" class="form-control" id="country" name="country">
    </div>
    <button type="submit" class="btn btn-outline-primary btn-lg btn-block mb-3" style="width:100px;">创建</button>
  </form>

</div>

{{template "footer.tpl" .}}