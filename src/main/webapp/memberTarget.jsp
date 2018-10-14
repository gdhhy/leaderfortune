<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>礼德财富 标的信息</title>
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
    </style>
    <script type="text/javascript">
        jQuery(function ($) {
            function showDetail(d) {
                return 'Full name:  <br>' +
                    'Salary:  <br>' +
                    'The child row can contain any data you wish, including links, images, inner tables etc.';
            }

            function kk() {
                return $('#rowDetail').html();
            }

            // kk();
            var memberNo = $.getUrlParam("memberNo");

            var url = "/memberTarget.jspx?memberNo=" + memberNo;

            function showMemberInfo(memberNo) {
                $.getJSON("/listMember.jspx?memberNo=" + memberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    if (result.data.length > 0) {
                        $('#realName').text(result.data[0].realName);
                        $('#idCard').text(result.data[0].idCard);
                        var memberInfo = JSON.parse(result.data[0].memberInfo);
                        $('#bankCardNo').text(memberInfo.银行账户.银行卡号 === '' ? '(空)' : memberInfo.银行账户.银行卡号);
                    }
                });
            }

            showMemberInfo(memberNo);
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            /*
            订单号, 项目名称,借款金额,借款利息,借款期数,总成本,还款方式,借款用途,上线时间,满标时间,放款时间, 债权人,状态

        银行名称,支行名称,到期时间,归属银行,
        合作机构,委托人姓名,投资人,借款类型,签单号,签单时间,开户支行,
        (旧)银行卡号, (旧)汇付天下用户,(旧)汇付天下账号


        */
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "user_id", "sClass": "center"},
                        {"class": "details-control", "orderable": false, "data": null, "defaultContent": ""},
                        {"data": "订单号", "sClass": "center"},
                        {"data": "项目名称", "sClass": "center"},
                        {"data": "借款金额", "sClass": "center"},
                        {"data": "借款利息", "sClass": "center"},
                        {"data": "借款期数", "sClass": "center"},
                        {"data": "总成本", "sClass": "center"},
                        {"data": "还款方式", "sClass": "center"},
                        {"data": "借款用途", "sClass": "center"},
                        {"data": "上线时间", "sClass": "center"},
                        {"data": "满标时间", "sClass": "center"},
                        {"data": "放款时间", "sClass": "center"},
                        {"data": "债权人", "sClass": "center"},
                        {"data": "状态", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {"orderable": false, 'targets': 0, width: 20},
                        {"orderable": false, 'targets': 2, title: '订单号'},
                        {"orderable": false, 'targets': 3, title: '项目名称'},
                        {"orderable": false, "targets": 4, title: '借款金额'},
                        {"orderable": false, "targets": 5, title: '借款利息'},
                        {"orderable": false, "targets": 6, title: '借款期数'},
                        {"orderable": false, "targets": 7, title: '总成本'},
                        {"orderable": false, "targets": 8, title: '还款方式'},
                        {"orderable": false, "targets": 9, title: '借款用途'},
                        {"orderable": false, "targets": 10, title: '上线时间'},
                        {"orderable": false, "targets": 11, title: '满标时间'},
                        {"orderable": false, "targets": 12, title: '放款时间'},
                        {"orderable": false, "targets": 13, title: '债权人'},
                        {"orderable": false, "targets": 14, title: '状态'}
                    ],
                    "aLengthMenu": [[20, 100, 1000, -1], ["20", "100", "1000", "全部"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    "ajax": url,
                    scrollY: '60vh',
                    "processing": true,
                    "footerCallback": function (tfoot, data, start, end, display) {
                        var total = 0.0;
                        $.each(data, function (index, value) {
                            if (value["投资状态"] === '投资成功')
                                total += value["投资金额"];
                        });

                        // Update footer
                        $(tfoot).find('th').eq(0).html('投资成功金额合计： ' + accounting.formatMoney(total, '￥'));
                    }/*,
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
                    row.child(kk(row.data())).show();

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
            myTable.on('order.dt search.dt', function () {
                myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                    cell.innerHTML = i + 1;
                });
            });
            myTable.on('xhr', function (e, settings, json, xhr) {
                if (json.recordsTotal > 0)
                    $('#wechatCard').text(json.data[0].微商银行账号);
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
                                    姓名：<span id="realName"></span>，身份证号：<span id="idCard"></span>，
                                    绑定的银行卡号：<span id="bankCardNo"></span>，微商银行账号 <span id="wechatCard"></span>
                                    ，标的信息
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                        <tfoot>
                                        <tr>
                                            <th colspan="12" style="text-align:right">
                                                <div id="footTotal">&nbsp;</div>
                                            </th>
                                        </tr>
                                        </tfoot>
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
<div class="hidden" id="rowDetail">
    <div class="table-detail">
        <div class="row">
            <div class="col-xs-12 col-sm-2">
                <div class="text-center">
                    <img height="150" class="thumbnail inline no-margin-bottom" alt="Domain Owner's Avatar" src="../assets/avatars/profile-pic.jpg"/>
                    <br/>
                    <div class="width-80 label label-info label-xlg arrowed-in arrowed-in-right">
                        <div class="inline position-relative">
                            <a class="user-title-label" href="#">
                                <i class="ace-icon fa fa-circle light-green"></i>
                                &nbsp;
                                <span class="white">Alex M. Doe</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-7">
                <div class="space visible-xs"></div>

                <div class="profile-user-info profile-user-info-striped">
                    <div class="profile-info-row">
                        <div class="profile-info-name"> Username</div>

                        <div class="profile-info-value">
                            <span>alexdoe</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> Location</div>

                        <div class="profile-info-value">
                            <i class="fa fa-map-marker light-orange bigger-110"></i>
                            <span>Netherlands, Amsterdam</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> Age</div>

                        <div class="profile-info-value">
                            <span>38</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> Joined</div>

                        <div class="profile-info-value">
                            <span>2010/06/20</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> Last Online</div>

                        <div class="profile-info-value">
                            <span>3 hours ago</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> About Me</div>

                        <div class="profile-info-value">
                            <span>Bio</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-3">
                <div class="space visible-xs"></div>
                <h4 class="header blue lighter less-margin">Send a message to Alex</h4>

                <div class="space-6"></div>

                <form>
                    <fieldset>
                        <textarea class="width-100" resize="none" placeholder="Type something…"></textarea>
                    </fieldset>

                    <div class="hr hr-dotted"></div>

                    <div class="clearfix">
                        <label class="pull-left">
                            <input type="checkbox" class="ace"/>
                            <span class="lbl"> Email me a copy</span>
                        </label>

                        <button class="pull-right btn btn-sm btn-primary btn-white btn-round" type="button">
                            Submit
                            <i class="ace-icon fa fa-arrow-right icon-on-right bigger-110"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>