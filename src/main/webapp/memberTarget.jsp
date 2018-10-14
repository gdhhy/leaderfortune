<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>标的信息 - 礼德财富</title>
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
                var investors = d["投资人"].split(",");
                var html = "";
                if (investors.length > 0) {
                    $.each(investors, function (i, item) {
                        html += "<a href='memberInfo.jspx?realName={0}' target='_blank'>{1}</a>&nbsp;&nbsp;".format(item,item);
                    });
                }
                return $('#rowDetail').html().format(d["银行名称"], d["支行名称"], d["归属银行"], d["开户支行"], d["(旧)银行卡号"], d["(旧)汇付天下用户"], d["(旧)汇付天下账号"],
                    d["合作机构"], d["委托人姓名"], html, d["借款类型"], d["签单号"], d["签单时间"], d["到期时间"]);
            }

            var memberNo = $.getUrlParam("memberNo");

            var url = "/memberTarget.jspx?memberNo=" + memberNo;

            function showMemberInfo(memberNo) {
                $.getJSON("/listMember.jspx?memberNo=" + memberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    if (result.data.length > 0) {
                        $('#realName').text(result.data[0].realName);
                        $('#idCard').text(result.data[0].idCard);
                        var memberInfo = JSON.parse(result.data[0].memberInfo);
                        $('#bankCardNo').text(memberInfo.银行账户.银行卡号 === '' ? '(空)' : memberInfo.银行账户.银行卡号);
                        $(document).attr("title", result.data[0].realName + ' - ' + $(document).attr("title"));//修改title值
                    }
                });
            }

            showMemberInfo(memberNo);
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            /*
            订单号, 项目名称,借款金额,借款利息,借款期数,总成本,还款方式,借款用途,上线时间,满标时间,放款时间, 债权人,状态

        银行名称,支行名称,归属银行,开户支行, (旧)银行卡号, (旧)汇付天下用户,(旧)汇付天下账号
        合作机构,委托人姓名,投资人,借款类型,签单号,签单时间,到期时间,
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
                        {"orderable": true, 'targets': 2, title: '订单号'},
                        {"orderable": false, 'targets': 3, title: '项目名称'},
                        {"orderable": false, "targets": 4, title: '借款金额'},
                        {"orderable": false, "targets": 5, title: '借款利息'},
                        {"orderable": false, "targets": 6, title: '借款期数'},
                        {"orderable": false, "targets": 7, title: '总成本'},
                        {"orderable": false, "targets": 8, title: '还款方式'},
                        {"orderable": false, "targets": 9, title: '借款用途'},
                        {"orderable": true, "targets": 10, title: '上线时间'},
                        {"orderable": true, "targets": 11, title: '满标时间'},
                        {"orderable": true, "targets": 12, title: '放款时间'},
                        {
                            "orderable": false, "targets": 13, title: '债权人',
                            render: function (data, type, row, meta) {
                                return '<a href="#"  data-memberNo="{0}">{1}</a>'.format(row["债权人"], row["债权人姓名"] === '' ? '（空）' : row["债权人姓名"]);
                            }
                        },
                        {"orderable": false, "targets": 14, title: '状态'}
                    ],
                    "aLengthMenu": [[20, 100, 1000, -1], ["20", "100", "1000", "全部"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    "ajax": url,
                    scrollY: '60vh',
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
                $('#dynamic-table tr').find('a:eq(0)').click(function () {
                    url = "/memberInfo.jspx?memberNo={0}".format($(this).attr("data-memberNo"));
                    window.open(url, "_blank");
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
                        <div class="profile-info-name" style="width: 120px;"> 银行名称</div>

                        <div class="profile-info-value">
                            <span>{0}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 支行名称</div>

                        <div class="profile-info-value">
                            <span>{1}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 归属银行</div>

                        <div class="profile-info-value">
                            <span>{2}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 开户支行</div>

                        <div class="profile-info-value">
                            <span>{3}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> (旧)银行卡号</div>

                        <div class="profile-info-value">
                            <span>{4}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> (旧)汇付天下用户</div>

                        <div class="profile-info-value">
                            <span>{5}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> (旧)汇付天下账号</div>

                        <div class="profile-info-value">
                            <span>{6}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-6">
                <div class="space visible-xs"></div>

                <div class="profile-user-info profile-user-info-striped">
                    <div class="profile-info-row">
                        <div class="profile-info-name"> 合作机构</div>

                        <div class="profile-info-value">
                            <span>{7}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 委托人姓名</div>

                        <div class="profile-info-value">
                            <span>{8}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 投资人</div>

                        <div class="profile-info-value">
                            <span>{9}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 借款类型</div>

                        <div class="profile-info-value">
                            <span>{10}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 签单号</div>

                        <div class="profile-info-value">
                            <span>{11}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 签单时间</div>

                        <div class="profile-info-value">
                            <span>{12}</span>
                        </div>
                    </div>

                    <div class="profile-info-row">
                        <div class="profile-info-name"> 到期时间</div>

                        <div class="profile-info-value">
                            <span>{13}</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>