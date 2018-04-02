{{template "header.tpl" .}}

<div class="row">
<div class="col-2">
</div>
<div class="col-8 bg-light">
  <div aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="index">主菜单</a></li>
      <li class="breadcrumb-item active" aria-current="page">应用管理</li>
    </ol>
  </div>

  <div id="toolbar" class="btn-group">
      <button id="btn_add" type="button" class="btn btn-info btn-sm rightSize">
          <span class="oi oi-plus"></span>新增
      </button>
      <button id="btn_edit" type="button" class="btn btn-info btn-sm rightSize">
          <span class="oi oi-pencil"></span>修改
      </button>
      <button id="btn_delete" type="button" class="btn btn-info btn-sm rightSize">
          <span class="oi oi-x"></span>删除
      </button>
  </div>
  <table id="table"
          data-toggle="table"
          data-toolbar="#toolbar"
          data-height="460"
          data-click-to-select="true"
          data-url="/user/appdata/0"
          >
      <thead>
      <tr>
          <th data-field="state" data-checkbox="true"></th>
          <th data-field="id">ID</th>
          <th data-field="name">Item Name</th>
          <th data-field="price">Item Price</th>
      </tr>
      </thead>

  </table>

  <nav aria-label="Page navigation example">
  <ul class="pagination">
    <li class="page-item">
      <a class="page-link" id="Previous" href="#" aria-label="Previous">
        <span aria-hidden="true">&laquo;</span>
        <span class="sr-only">Previous</span>
      </a>
    </li>
    <li class="page-item active"><a class="page-link" href="#">1</a></li>
    <li class="page-item"><a class="page-link" href="#">2</a></li>
    <li class="page-item">
      <a class="page-link" id="Next" href="#" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
        <span class="sr-only">Next</span>
      </a>
    </li>
  </ul>
</nav>

  <table class="table table-striped mt-3">
    <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">appid</th>
        <th scope="col">name</th>
        <th scope="col">regdate</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th scope="row">1</th>
        <td>Mark</td>
        <td>Otto</td>
        <td>@mdo</td>
      </tr>
      <tr>
        <th scope="row">2</th>
        <td>Jacob</td>
        <td>Thornton</td>
        <td>@fat</td>
      </tr>
      <tr>
        <th scope="row">3</th>
        <td>Larry</td>
        <td>the Bird</td>
        <td>@twitter</td>
      </tr>
      <tr>
        <th scope="row">4</th>
        <td>Larry</td>
        <td>the Bird</td>
        <td>@twitter</td>
      </tr>
    </tbody>
  </table>

</div>
<div class="col-2">
</div>
</div>

<script type="text/javascript">
  var index = 0;
  $('ul.pagination').children()
  $('#btn_add').on('click', function (e) {
    index++;
    index = index % 2;
    if(index % 2 == 0)
        $("#table").bootstrapTable("refresh", {url: '/user/appdata/0'});
      else
        $("#table").bootstrapTable("refresh", {url: '/user/appdata/1'});
    });
    $('#Previous').on('click', function (e) {
      $('ul.pagination').children().eq(index+1).removeClass("active");
      index--;
      if(index < 0)
        index = 1;
      if(index % 2 == 0)
        $("#table").bootstrapTable("refresh", {url: '/user/appdata/0'});
      else
        $("#table").bootstrapTable("refresh", {url: '/user/appdata/1'});

      $('ul.pagination').children().eq(index+1).addClass("active");
    });
    $('#Next').on('click', function (e) {
      $('ul.pagination').children().eq(index+1).removeClass("active");
      index++;
      index = index % 2;
      if(index % 2 == 0)
        $("#table").bootstrapTable("refresh", {url: '/user/appdata/0'});
      else
        $("#table").bootstrapTable("refresh", {url: '/user/appdata/1'});

        $('ul.pagination').children().eq(index+1).addClass("active");
    });
</script>

{{template "footer.tpl" .}}