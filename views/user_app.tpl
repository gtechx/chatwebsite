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
      <button id="btn_add" onclick="window.location.href='appcreate';" type="button" class="btn btn-info btn-sm rightSize">
          <span class="oi oi-plus"></span>新增
      </button>
      <button id="btn_edit" type="button" class="btn btn-info btn-sm rightSize">
          <span class="oi oi-pencil"></span>修改
      </button>
      <button id="btn_delete" type="button" class="btn btn-info btn-sm rightSize">
          <span class="oi oi-x"></span>删除
      </button>
  </div>
  <table id="table">
  </table>
</div>
<div class="col-2">
</div>
</div>

<script type="text/javascript">
  var index = 0;
  // $('#btn_add').on('click', function (e) {
  //   index++;
  //   index = index % 2;
  //   if(index % 2 == 0)
  //       $("#table").bootstrapTable("refresh", {url: '/user/appdata/0'});
  //     else
  //       $("#table").bootstrapTable("refresh", {url: '/user/appdata/1'});
  //   });
    // $('#Previous').on('click', function (e) {
    //   $('ul.pagination').children().eq(index+1).removeClass("active");
    //   index--;
    //   if(index < 0)
    //     index = 1;
    //   if(index % 2 == 0)
    //     $("#table").bootstrapTable("refresh", {url: '/user/appdata/0/2'});
    //   else
    //     $("#table").bootstrapTable("refresh", {url: '/user/appdata/1/2'});

    //   $('ul.pagination').children().eq(index+1).addClass("active");
    // });
    // $('#Next').on('click', function (e) {
    //   $('ul.pagination').children().eq(index+1).removeClass("active");
    //   index++;
    //   index = index % 2;
    //   if(index % 2 == 0)
    //     $("#table").bootstrapTable("refresh", {url: '/user/appdata/0/2'});
    //   else
    //     $("#table").bootstrapTable("refresh", {url: '/user/appdata/1/2'});

    //     $('ul.pagination').children().eq(index+1).addClass("active");
    // });

    $("#table").bootstrapTable({ // 对应table标签的id
      url: "appdata", // 获取表格数据的url
      cache: false, // 设置为 false 禁用 AJAX 数据缓存， 默认为true
      clickToSelect: true,
      pagination: true,
      height: 460,
      toolbar: "#toolbar",
      striped: true,  //表格显示条纹，默认为false
      pagination: true, // 在表格底部显示分页组件，默认false
      pageList: [2, 5, 10], // 设置页面可以显示的数据条数
      pageSize: 2, // 页面数据条数
      pageNumber: 1, // 首页页码
      sidePagination: 'server', // 设置为服务器端分页
      queryParamsType: "",
      queryParams: function (params) { // 请求服务器数据时发送的参数，可以在这里添加额外的查询参数，返回false则终止请求

          return {
              pageSize: params.pageSize, // 每页要显示的数据条数
              //offset: params.offset, // 每页显示数据的开始行号
              pageNumber: params.pageNumber
              //sort: params.sort, // 要排序的字段
              //sortOrder: params.order, // 排序规则
              //dataId: $("#dataId").val() // 额外添加的参数
          }
      },
      //sortName: 'id', // 要排序的字段
      //sortOrder: 'desc', // 排序规则
      columns: [
          {
              checkbox: true, // 显示一个勾选框
              align: 'center' // 居中显示
          }, {
              field: 'appid', // 返回json数据中的name
              title: '应用ID', // 表格表头显示文字
              align: 'center', // 左右居中
              valign: 'middle' // 上下居中
          }, {
              field: 'name',
              title: '名称',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'owner',
              title: 'owner',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'desc',
              title: 'desc',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'regdate',
              title: 'regdate',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'sregdate',
              title: '创建日期',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'type',
              title: 'type',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'share',
              title: 'share',
              align: 'center',
              valign: 'middle'
          }, {
              title: "操作",
              align: 'center',
              valign: 'middle',
              width: 160, // 定义列的宽度，单位为像素px
              formatter: function (value, row, index) {
                  return '<button class="btn btn-primary btn-sm" onclick="del(\'' + row.stdId + '\')">删除</button>';
              }
          }
      ],
      onLoadSuccess: function(data){  //加载成功时执行
            console.info("加载成功");
            //console.info(data);
            //$('#table').bootstrapTable('append', data);
      },
      onLoadError: function(status, res){  //加载失败时执行
            console.info("加载数据失败");
      }

});
</script>

{{template "footer.tpl" .}}