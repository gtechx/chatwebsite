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

<div id="zonepanel" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="d-flex flex-wrap" id="zonelist">
          <label class="checkbox-inline border border-success ml-2 bg-danger">
            <input type="checkbox" id="inlineCheckbox1" value="option1"> 国色天香
          </label>
          <label class="checkbox-inline border border-success ml-2 bg-danger">
            <input type="checkbox" id="inlineCheckbox2" value="option2"> 国色天香
          </label>
          <label class="checkbox-inline border border-success ml-2 bg-danger">
            <input type="checkbox" id="inlineCheckbox3" value="option3"> 国色天香
          </label>
          <label class="checkbox-inline border border-success ml-2 bg-danger">
            <input type="checkbox" id="inlineCheckbox3" value="option3"> 国色天香
          </label>
        </div>
        
      </div>
      <div class="modal-footer">
        <input type="text" class="invisible" id="zoneappname" name="zoneappname">
        <form onsubmit="return addZone();">
          <div class="form-group row">
            <label class="col-sm-5 col-form-label" for="zonename">分区名字：</label>
            <input type="text" class="form-control col-sm-4" id="zonename" name="zonename">
            <button type="submit" class="btn btn-outline-primary col-sm-2 col-form-label ml-2">添加</button>
          </div>   
        </form>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
  $('#zonepanel').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget); // Button that triggered the modal
    var appname = button.data('whatever'); // Extract info from data-* attributes
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this);
    modal.find('.modal-title').text(appname + ' 分区管理');
    $('#zoneappname').val(appname);
    $.post("zonelist", { appname: "\""+appname+"\"" },
    function(data) {
      console.info("Data Loaded: " + data);
      var jsondata = JSON.parse(data);
      var liststr = '';
      for (i in jsondata)
      {
        var zone = jsondata[i].replace(/"/g, '');
        liststr += '<label class="checkbox-inline border border-success ml-2 bg-danger">\n';
        liststr += '<input type="checkbox" id="\''+zone+'\'" name="\''+zone+'\'" value="\''+zone+'\'">' + zone + '\n';
        liststr += '</label>';
      }
      $('#zonelist').html(liststr)
    });
  });
  function addZone(){
    $.post("zoneadd", { appname: "\""+$('#zoneappname').val()+"\"", zonename: "\""+$('#zonename').val()+"\"" },
    function(data) {
      var jsondata = JSON.parse(data);
      var liststr = '';
      for (i in jsondata)
      {
        var zone = jsondata[i].replace(/"/g, '');
        liststr += '<label class="checkbox-inline border border-success ml-2 bg-danger">\n';
        liststr += '<input type="checkbox" id="\''+zone+'\'" name="\''+zone+'\'" value="\''+zone+'\'">' + zone + '\n';
        liststr += '</label>';
      }
      $('#zonelist').html(liststr)
    });
    return false;
  }
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
      url: "applist", // 获取表格数据的url
      cache: false, // 设置为 false 禁用 AJAX 数据缓存， 默认为true
      clickToSelect: true,
      pagination: true,
      height: 650,
      toolbar: "#toolbar",
      striped: true,  //表格显示条纹，默认为false
      pagination: true, // 在表格底部显示分页组件，默认false
      pageList: [10, 15], // 设置页面可以显示的数据条数
      pageSize: 10, // 页面数据条数
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
              field: 'name',
              title: '名称',
              align: 'center',
              valign: 'middle',
              formatter: function (value, row, index) {
                  return '<a class="" href="appmodify?appname='+value+'">'+value+'</button>';
              }
          }, {
              field: 'desc',
              title: '描述',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'sregdate',
              title: '创建日期',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'share',
              title: '共享数据应用名',
              align: 'center',
              valign: 'middle'
          }, {
              field: 'share',
              title: "操作",
              align: 'center',
              valign: 'middle',
              width: 160, // 定义列的宽度，单位为像素px
              formatter: function (value, row, index) {
                if(value == "")
                  return '<button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#zonepanel" data-whatever="'+row.name+'">分区管理</button>';
              }
          }
      ],
      onLoadSuccess: function(data){  //加载成功时执行
            console.info("加载成功");
            //console.info(data);
      },
      onLoadError: function(status, res){  //加载失败时执行
            console.info("加载数据失败");
      }

});
</script>

{{template "footer.tpl" .}}