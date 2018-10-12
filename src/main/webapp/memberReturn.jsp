<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>礼德财富 回款记录</title>
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

    <script type="text/javascript">
        jQuery(function ($) {
            var memberNo = $.getUrlParam("memberNo");

            var url = "/memberReturn.jspx?memberNo=" + memberNo;

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
            /*绑定的银行卡号,微商银行账号,借款项目名称,借款订单号,资金总额,应还本金,应还利息,"收款期数/总期数",
        要求还款时间,借款用户还款时间,提前还款时间,交易状况,类型,还款状态*/
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "user_id", "sClass": "center"},
                        {"data": "借款用户还款时间", "sClass": "center"},
                        {"data": "借款订单号", "sClass": "center"},
                        {"data": "借款项目名称", "sClass": "center"},
                        {"data": "资金总额", "sClass": "center"},
                        {"data": "应还本金", "sClass": "center"},
                        {"data": "应还利息", "sClass": "center"},
                        {"data": "收款期数/总期数", "sClass": "center"},
                        {"data": "要求还款时间", "sClass": "center"},
                        {"data": "提前还款时间", "sClass": "center"},
                        {"data": "交易状况", "sClass": "center"},
                        {"data": "类型", "sClass": "center"},
                        {"data": "还款状态", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {"orderable": false, 'targets': 0, width: 20},
                        {"orderable": false, "targets": 1, title: '要求还款时间', width: 140},
                        {"orderable": false, "targets": 2, title: '借款订单号'},
                        {"orderable": false, "targets": 3, title: '借款项目名称'},
                        {"orderable": false, "targets": 4, title: '资金总额'},
                        {"orderable": false, "targets": 5, title: '应还本金'},
                        {"orderable": false, "targets": 6, title: '应还利息'},
                        {"orderable": false, "targets": 7, title: '收款期数/总期数'},
                        {"orderable": false, "targets": 8, title: '借款用户还款时间', width: 140},
                        {"orderable": false, "targets": 9, title: '提前还款时间'},
                        {"orderable": false, "targets": 10, title: '交易状况'},
                        {"orderable": false, "targets": 11, title: '类型'},
                        {"orderable": false, "targets": 12, title: '还款状态'}

                    ],
                    "aLengthMenu": [[20, 100, 1000, -1], ["20", "100", "1000", "全部"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    searching: false,
                    "ajax": url,
                    "processing": true,
                    "footerCallback": function (tfoot, data, start, end, display) {
                        var total = 0.0;
                        $.each(data, function (index, value) {
                            if (value["还款状态"].indexOf('已还') > 0)

                                total += value["资金总额"];
                        });

                        // Update footer
                        $(tfoot).find('th').eq(0).html('已还资金总额合计： ' + accounting.formatMoney(total, '￥'));
                    },
                    select: {style: 'single'}
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
                                    绑定的银行卡号：<span id="bankCardNo"></span>，微商银行账号 <span id="wechatCard"></span> ，回款记录
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                        <tfoot>
                                        <tr>
                                            <th colspan="13" style="text-align:right">
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

</body>
</html>