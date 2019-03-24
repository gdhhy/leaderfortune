<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title><c:out value="${member.realName}"/> - 成员信息 - 礼德财富</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->

    <!-- text fonts -->

    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]-->
    <script src="js/html5shiv/dist/html5shiv.js"></script>
    <script src="js/respond/dest/respond.min.js"></script>
    <!--[endif]-->

    <!-- basic scripts -->

    <!--[if !IE]> -->
    <script src="js/jquery-3.2.0.min.js"></script>

    <!-- <![endif]-->

    <!--[if IE]-->
    <script src="js/jquery-1.11.3.min.js"></script>
    <!--[endif]-->
    <script src="js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->

    <!-- static.html end-->

    <script src="js/datatables/jquery.dataTables.min.js"></script>

    <script src="js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <script src="js/accounting.min.js"></script>
    <script src="js/fuelux/tree.js"></script>
    <script src="js/func.js"></script>

    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script src="assets/js/ace.js"></script>
    <script type="text/javascript">
        jQuery(function ($) {
            var row2 = '<div class="profile-info-row">' +
                '<div class="profile-info-name">{0}</div>' +
                '<div class="profile-info-value">{1}</div>' +
                '<div class="profile-info-name">{2}</div>' +
                '<div class="profile-info-value">{3}</div>' +
                '</div>';
            var row3 = '<div class="profile-info-row">' +
                '<div class="profile-info-name">{0}</div>' +
                '<div class="profile-info-value">{1}</div>' +
                '<div class="profile-info-name">{2}</div>' +
                '<div class="profile-info-value">{3}</div>' +
                '<div class="profile-info-name">{4}</div>' +
                '<div class="profile-info-value">{5}</div>' +
                '</div>';

            var divObject = '<div class="widget-main padding-8" >' +
                '<h5 class="widget-title blue bigger-120">{0}</h5>' +
                '<div class="profile-user-info profile-user-info-striped">' +
                '{1}' +
                '</div>' +
                '</div>';

            function showDivObject(propName, obj) {
                var keyVals = [];
                var kk = 0;
                $.each(obj, function (key, val) {
                    keyVals[kk++] = {'key': key, 'value': val};
                });
                var html = "";
                if (keyVals.length % 3 === 0) {
                    for (kk = 0; kk < keyVals.length; kk += 3)
                        html += row3.format(keyVals[kk].key, keyVals[kk].value,
                            keyVals[kk + 1].key, keyVals[kk + 1].value,
                            keyVals[kk + 2].key, keyVals[kk + 2].value);
                }
                else
                    for (kk = 0; kk < keyVals.length; kk += 2) {
                        if (keyVals[kk + 1])
                            html += row2.format(keyVals[kk].key, keyVals[kk].value, keyVals[kk + 1].key, keyVals[kk + 1].value);
                        else
                            html += row2.format(keyVals[kk].key, keyVals[kk].value, '', '');
                    }
                return divObject.format(propName, html);
            }

            function showTable(propName, obj) {
                var th = "";
                var td = "";
                for (var i = 0; i < obj.length; i++) {
                    var row_td = "";
                    var row_th = "";
                    $.each(obj[i], function (key, val) {
                        if (i === 0)
                            row_th += "<th>{0}</th>".format(key);
                        row_td += "<td>{0}</td>".format(val);
                    });
                    if (i === 0)
                        th = "<thead><tr>{0}</tr></thead>".format(row_th);
                    td += "<tbody><tr>{0}</tr></tbody>".format(row_td);
                }
                var html = '<table border="0" cellspacing="1" cellpadding="0" class="table table-striped table-bordered table-hover">{0}{1}</table>'
                    .format(th, td);
                return divObject.format(propName, html);
            }

            var infoString = '<c:out value="${member.memberInfo}" escapeXml="false"/>';

            showMemberInfo();

            function showMemberInfo() {
                if (infoString !== '') {
                    var memberInfo = JSON.parse(infoString);
                    var baseInfo = {"姓名": '<c:out value="${member.realName}"/>', "身份证号码": '<c:out value="${member.idCard}"/>',
                        "用户名": '<c:out value="${member.userName}"/>',"电话号码": '<c:out value="${member.phone}"/>'};
                    $.each(memberInfo["基本信息"], function (key, val) {
                        baseInfo[key] = val;
                    });

                    var html1 = "";
                    //var html2 = "";
                    html1 += showDivObject("基本信息", baseInfo);
                  /*  html2 += showDivObject("资金", memberInfo["资金"]);
                    html2 += showDivObject("旧资料", memberInfo["旧资料"]);
                    html1 += showDivObject("银行账户", memberInfo["银行账户"]);*/
                    $('#aaa').html(html1);
                    //$('#bbb').html(html2);

                    $(".profile-info-name:contains('姓名')").next().addClass("bigger-150");
                    $(".profile-info-name:contains('身份证号码')").next().addClass("bigger-130");
                }

            }

            $('button:last').click(function () {
                $(window).attr('location', 'member.jspx');
            });

            /*Disclose all folders (expand the entire tree).*/
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
                        <!-- PAGE CONTENT BEGINS -->

                        <!-- #section:plugins/fuelux.treeview -->
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="widget-box widget-color-green2">
                                    <div class="widget-header">
                                        <h4 class="widget-title smaller">
                                            成员详细信息
                                            <span class="smaller-80"></span>
                                        </h4>
                                        <button class="btn btn-info btn-xs pull-right">
                                            <i class="ace-icon fa fa-reply icon-only"></i>
                                            返回
                                        </button>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="widget-body">
                                            <div class="widget-main padding-8">
                                                <!-- #section:pages/profile.info -->
                                                <%--<div class="profile-user-info profile-user-info-striped" id="baseInfo">

                                                </div>--%>
                                                <!-- /section:pages/profile.info -->
                                                <div id="aaa"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="widget-body">
                                            <div class="widget-main padding-8">
                                                <!-- #section:pages/profile.info -->
                                                <%-- <div class="profile-user-info profile-user-info-striped" id="baseInfo2">

                                                 </div>--%>
                                                <!-- /section:pages/profile.info -->
                                                <div id="bbb"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- /section:plugins/fuelux.treeview -->

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

</body>
</html>