<div class="col-md-3" id="chatpanel">
  <div class="box box-warning box-solid" style="min-height:720px;">
    <div class="overlay hide">
      <i class="fa fa-refresh fa-spin"></i>
    </div>
    <div class="box-header with-border" id="chatpanelheader">
      <h3 class="box-title">Collapsable</h3>

      <div class="box-tools pull-right hide">
        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
        </button>
      </div>
      <!-- /.box-tools -->
    </div>
    <!-- /.box-header -->
    <div class="box-body">
        <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->
        <div class="box box-primary collapsed-box">
            <div class="box-header with-border">
                <h3 class="box-title">GroupA</h3>

                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
                    </button>
                </div>
                <!-- /.box-tools -->
            </div>
            <div class="box-body" style="">
                <ul class="contacts-list">
                    <li>
                        <a href="#">
                        <img class="contacts-list-img" src="static/dist/img/user1-128x128.jpg" alt="User Image">

                        <div class="contacts-list-info">
                                <span class="contacts-list-name text-black">
                                Count Dracula
                                </span>
                            <span class="contacts-list-msg">How have you been? I was...</span>
                        </div>
                        <!-- /.contacts-list-info -->
                        </a>
                    </li>
                    <li>
                        <a href="#">
                        <img class="contacts-list-img" src="static/dist/img/user1-128x128.jpg" alt="User Image">

                        <div class="contacts-list-info">
                                <span class="contacts-list-name text-black">
                                Count Dracula
                                </span>
                            <span class="contacts-list-msg">How have you been? I was...</span>
                        </div>
                        <!-- /.contacts-list-info -->
                        </a>
                    </li>
                    <!-- End Contact Item -->
                </ul>
            </div>
        </div>

        <div class="box box-primary collapsed-box">
            <div class="box-header with-border">
                <h3 class="box-title">GroupB</h3>

                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
                    </button>
                </div>
                <!-- /.box-tools -->
            </div>
            <div class="box-body" style="">
                <ul class="contacts-list">
                    <li>
                        <a href="#">
                        <img class="contacts-list-img" src="static/dist/img/user1-128x128.jpg" alt="User Image">

                        <div class="contacts-list-info">
                                <span class="contacts-list-name text-black">
                                Count Dracula
                                </span>
                            <span class="contacts-list-msg">How have you been? I was...</span>
                        </div>
                        <!-- /.contacts-list-info -->
                        </a>
                    </li>
                    <li>
                        <a href="#">
                        <img class="contacts-list-img" src="static/dist/img/user1-128x128.jpg" alt="User Image">

                        <div class="contacts-list-info">
                                <span class="contacts-list-name text-black">
                                Count Dracula
                                </span>
                            <span class="contacts-list-msg">How have you been? I was...</span>
                        </div>
                        <!-- /.contacts-list-info -->
                        </a>
                    </li>
                    <!-- End Contact Item -->
                </ul>
            </div>
        </div>
    </div>
  <!-- /.box-body -->
  </div>
</div>

<script>
  $( function() {
    $( "#chatpanel" ).draggable({handle: "#chatpanelheader", cursor: "move"});
  } );
  </script>