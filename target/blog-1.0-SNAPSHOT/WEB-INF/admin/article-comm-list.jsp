<%--
  Created by IntelliJ IDEA.
  User: ChaoSir
  Date: 2020/7/20
  Time: 9:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="x-admin-sm">

<head>
    <meta charset="UTF-8">
    <title>欢迎页面-X-admin2.2</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi"/>
    <%@ include file="staticSource.jsp" %>
</head>

<body>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a href="">首页</a>
                <a href="">演示</a>
                <a>
                    <cite>导航元素</cite></a>
            </span>
    <a class="layui-btn layui-btn-small" style="line-height:1.6em;margin-top:3px;float:right"
       onclick="location.reload()" title="刷新">
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
    <br/>
</div>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body ">
                    <form class="layui-form layui-col-space5">
                        <div class="layui-inline layui-show-xs-block">
                            <input class="layui-input" autocomplete="off" placeholder="作者" name="start" id="start">
                        </div>
                        <div class="layui-inline layui-show-xs-block">
                            <input class="layui-input" autocomplete="off" placeholder="标题" name="end" id="end"></div>
                        <div class="layui-inline layui-show-xs-block">
                            <input type="text" name="username" placeholder="状态" autocomplete="off"
                                   class="layui-input"></div>
                        <div class="layui-inline layui-show-xs-block">
                            <button class="layui-btn" lay-submit="" lay-filter="sreach">
                                <i class="layui-icon">&#xe615;</i></button>
                        </div>
                    </form>
                </div>
                <!--表格-->
                <div class="layui-card-body ">
                    <table id="article" lay-filter="articleTable"></table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/html" id="bar">
    <div class="layui-btn-container">
        <a class="layui-btn layui-btn-xs  layui-btn-normal" lay-event="top"><i class="layui-icon">&#xe604;</i></a>
        <a class="layui-btn layui-btn-xs" lay-event="edit"> <i class="layui-icon">&#xe605;</i></a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon">&#xe640;</i></a>
    </div>
</script>
<script>
    layui.use('table', function () {
        var table = layui.table;
        //第一个实例
        table.render({
            elem: '#article'
            , url: '/admin/getCommArticle' //数据接口
            , size: 'lg'
            , page: true //开启分页
            , cols: [[ //表头
                {field: 'id', title: 'ID', width: 60, sort: true, fixed: 'left'}
                , {field: 'title', title: '标题', width: 173, edit: 'text'}
                , {field: 'assistant', title: '描述', width: 110, edit: 'text'}
                , {
                    field: 'picture',
                    title: '封面',
                    width: 90,
                    templet: '<div><img src="{{ d.picture }}" style="width:350px; height:150px;"></div>', edit: 'text'
                }
                , {field: 'content', title: '内容', width: 149}
                , {field: 'author', title: '作者', width: 78, sort: true, edit: 'text'}
                , {field: 'status', title: '状态', width: 69, sort: true, edit: 'text'}
                , {field: 'createTime', title: '创建时间', width: 142, sort: true}
                , {field: 'updateTime', title: '最近修改', width: 142, sort: true}
                , {fixed: 'right', width: 170, align: 'center', toolbar: '#bar'}
            ]]
        });

        //监听行双击事件
        table.on('rowDouble(articleTable)', function (obj) {
            layer.open({
                type: 2,
                anim: 1,
                title: '修改文章',
                content: '/admin/writeBlog?id=' + obj.data.id,
                area: ['1200px', '650px'],
                cancel: function () {
                    layer.msg('回调');
                }
            });
        });

        //监听事件
        table.on('tool(articleTable)', function (obj) {
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）

            //置顶
            if (layEvent === 'top') {
                layer.confirm('确定要置顶吗？' + data.id, function (index) {
                    obj.del();
                    layer.close(index);
                });
            } else if (layEvent === 'edit') { //编辑
                $.ajax({
                    type: 'post',
                    url: '/admin/updateArticle',
                    data: data,
                    success: function (res) {
                        obj.update({
                            res
                        });
                    },
                    dataType: 'json'
                })

            } else if (layEvent === 'delete') {//删除
                layer.confirm('真的删除行么？' + data.id, function (index) {
                    obj.del();
                    layer.close(index);
                    //服务器删除
                    $.ajax({
                        type: 'post',
                        url: '/admin/deleteArticle',
                        data: data,
                        success: function (res) {
                            if (res.code === 1000) {
                                layer.msg("删除成功！");
                            } else {
                                layer.msg("删除失败！服务器错误！");
                            }
                        },
                        dataType: 'json'
                    })
                });
            }
        });


    });


</script>
</html>
