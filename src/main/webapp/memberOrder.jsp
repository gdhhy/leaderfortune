<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>订单信息 - ${short_title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->

    <script src="js/jquery-3.2.0.min.js"></script>

    <!--<script src="components/bootstrap/dist/js/bootstrap.js"></script>-->
    <script src="js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->
    <!-- static.html end-->
    <script src="js/datatables/jquery.dataTables.min.js"></script>
    <script src="js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <%--<script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>--%>

    <script src="components/datatables.net-buttons/js/dataTables.buttons.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.html5.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.print.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="js/jquery.form.js"></script>--%>
    <script src="js/func.js"></script>
    <script src="js/common.js"></script>
    <script src="js/accounting.min.js"></script>

    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>
    <style>
        td.details-control {
            background: url('resources/details_open.png') no-repeat center center;
            cursor: pointer;
        }

        tr.details td.details-control {
            background: url('resources/details_close.png') no-repeat center center;
        }

        .profile-info-value {
            background-color: white
        }
    </style>
    <script type="text/javascript">
        jQuery(function ($) {
            function showDetail(d) {
                return $('#rowDetail').html().format(d["订单状态"], d["子订单状态"], d["收货人电话"], d["收货人地址"]);
            }

            var memberNo = $.getUrlParam("memberNo");

            var url = "/order.jspx?memberNo=" + memberNo;

            function showMemberInfo(memberNo) {
                $.getJSON("/listMember.jspx?memberNo=" + memberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    if (result.data.length > 0) {
                        var userInfo = "姓名：{0}，身份证号：{1}";

                        $('#userInfo').text(userInfo.format(result.data[0].realName, result.data[0].idCard));
                        $(document).attr("title", result.data[0].realName + ' - ' + $(document).attr("title"));//修改title值
                    }
                });
            }

            showMemberInfo(memberNo);
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)

                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "订单号", "sClass": "center"},
                        {"class": "details-control", "orderable": false, "data": null, "defaultContent": ""},
                        {"data": "订单号", "sClass": "center"},

                        {"data": "下单时间", "sClass": "center"},
                        {"data": "子订单编号", "sClass": "center"},
                        {"data": "公司名称", "sClass": "center"},
                        {"data": "商店名称", "sClass": "center"},
                        {"data": "商品总价", "sClass": "center"},
                        {"data": "订单最终金额", "sClass": "center"},
                        {"data": "商品名称", "sClass": "center"},
                        {"data": "商品单价", "sClass": "center"},
                        {"data": "销售数量", "sClass": "center"},
                        {"data": "商品实际金额", "sClass": "center"},
                        {"data": "收货人姓名", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {
                            "orderable": false, 'targets': 0, width: 20, render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }
                        },
                        {"orderable": true, 'targets': 2, title: '订单号'},
                        {"orderable": true, 'targets': 3, title: '下单时间',width:120},
                        {"orderable": false, 'targets': 4, title: '子订单号'},
                        {"orderable": false, "targets": 5, title: '商家名称'},
                        {"orderable": false, "targets": 6, title: '商店名称'},
                        {"orderable": false, "targets": 7, title: '商品总价'},
                        {"orderable": false, "targets": 8, title: '订单最终金额'},
                        {"orderable": false, "targets": 9, title: '商品名称'},
                        {"orderable": false, "targets": 10, title: '商品单价'},
                        {"orderable": true, "targets": 11, title: '销售数量'},
                        {"orderable": true, "targets": 12, title: '小计'},
                        {"orderable": true, "targets": 13, title: '收货人姓名'}

                    ],
                    "aLengthMenu": [[20, 100, 1000, -1], ["20", "100", "1000", "全部"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    "ajax": url,
                    scrollY: '60vh',
                    "paging": false,
                    "processing": true
                    /*,
                    select: {style: 'single'}*/
                });
            var detailRows = [];
            $('#dynamic-table tbody').on('click', 'tr td.details-control', function () {
                var tr = $(this).closest('tr');
                var row = myTable.row(tr);
                var idx = $.inArray(tr.attr('id'), detailRows);

                if (row.child.isShown()) {
                    tr.removeClass('details');
                    row.child.hide();

                    // Remove from the 'open' array
                    detailRows.splice(idx, 1);
                }
                else {
                    tr.addClass('details');
                    row.child(showDetail(row.data())).show();

                    // Add to the 'open' array
                    if (idx === -1) {
                        detailRows.push(tr.attr('id'));
                    }
                }
            });

            // On each draw, loop over the `detailRows` array and show any child rows
            myTable.on('draw', function () {
                $.each(detailRows, function (i, id) {
                    $('#' + id + ' td.details-control').trigger('click');
                });

            });


            //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';
            new $.fn.dataTable.Buttons(myTable, {
                buttons: [
                    {
                        "extend": "copy",
                        "text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>Copy to clipboard</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "csv",
                        "text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "excel",
                        "text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "pdf",
                        "text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>Export to PDF</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "print",
                        "text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
                        "className": "btn btn-white btn-primary btn-bold",
                        autoPrint: false
                    }
                ]
            }); // todo why only copy csv print
            myTable.buttons().container().appendTo($('.tableTools-container'));

        })
    </script>
</head>
<body class="no-skin">
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">
            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    <span id="userInfo"></span>  &nbsp;&nbsp;订单信息
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
    <div class="footer">
        <div class="footer-inner">
            <!-- #section:basics/footer -->
            <div class="footer-content">
                <span class="bigger-120"><span class="blue bolder">广东鑫证</span>司法鉴定所 &copy; 2018
                </span>
            </div>
            <!-- /section:basics/footer -->
        </div>
    </div>
</div><!-- /.main-container -->
<div class="detail-row hidden" id="rowDetail">
    <div class="table-detail">
        <div class="row">

            <div class="col-xs-12 col-sm-6">
                <div class="space visible-xs"></div>

                <div class="profile-user-info profile-user-info-striped">
                    <div class="profile-info-row">
                        <div class="profile-info-name" style="width: 120px;">订单状态</div>

                        <div class="profile-info-value">
                            <span>{0}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name">子订单状态</div>

                        <div class="profile-info-value">
                            <span>{1}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-6">
                <div class="space visible-xs"></div>

                <div class="profile-user-info profile-user-info-striped">

                    <div class="profile-info-row">
                        <div class="profile-info-name">收货人电话</div>

                        <div class="profile-info-value">
                            <span>{2}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name">收货地址</div>

                        <div class="profile-info-value">
                            <span>{3}</span>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>