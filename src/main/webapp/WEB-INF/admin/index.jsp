<%--
  Created by IntelliJ IDEA.
  User: ChaoSir
  Date: 2020/7/17
  Time: 20:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html class="x-admin-sm">
<head>
    <meta charset="UTF-8">
    <title>后台登录-X-admin2.2</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi"/>
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <%@ include file="staticSource.jsp" %>
    <script>
        // 是否开启刷新记忆tab功能
        var is_remember = true;
    </script>
</head>
<body class="index">
<!-- 顶部开始 -->
<div class="container">
    <div class="logo">
        <a href="/admin/index">往事随风</a></div>
    <div class="left_open">
        <a><i title="展开左侧栏" class="iconfont">&#xe699;</i></a>
    </div>
    <ul class="layui-nav left fast-add">
        <li class="layui-nav-item">
            <a href="javascript:;" onclick="xadmin.open('发布文章','writeBlog.html')">发布文章</a>
        </li>
        <li class="layui-nav-item">
            <a href="javascript:;" onclick="xadmin.open('写写日记','/admin/writeDiary',1100,600)">写写日记</a>
        </li>
    </ul>
    <ul class="layui-nav right" lay-filter="">
        <li class="layui-nav-item">
            <a href="javascript:;">${sessionScope.admin.name}</a>
            <dl class="layui-nav-child">
                <dd>
                    <a href="/admin/logout">退出</a>
                </dd>
            </dl>
        </li>
        <li class="layui-nav-item to-index">
            <a href="javascript:;" onclick="xadmin.open('最大化','http://chao58.top')">前台首页</a></li>
    </ul>
</div>
<!-- 顶部结束 -->
<!-- 中部开始 -->
<!-- 左侧菜单开始 -->
<div class="left-nav">
    <div id="side-nav">
        <ul id="nav">
            <li>
                <a href="javascript:;">
                    <i class="iconfont left-nav-li" lay-tips="文章管理">&#xe744;</i>
                    <cite>文章管理</cite>
                    <i class="iconfont nav_right">&#xe697;</i></a>
                <ul class="sub-menu">
                    <li>
                        <a onclick="xadmin.add_tab('添加文章','/admin/writeBlog')">
                            <i class="iconfont">&#xe74e;</i>
                            <cite>添加文章</cite></a>
                    </li>

                    <li>
                        <a onclick="xadmin.add_tab('普通文章','/admin/articleCommList',true)">
                            <i class="iconfont">&#xe74a;</i>
                            <cite>普通文章</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('置顶文章','/admin/articleTopList',true)">
                            <i class="iconfont">&#xe71d;</i>
                            <cite>置顶文章</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('删除文章','/admin/articleDelList',true)">
                            <i class="iconfont">&#xe69d;</i>
                            <cite>删除文章</cite></a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="javascript:;">
                    <i class="iconfont left-nav-li" lay-tips="评论管理">&#xe69b;</i>
                    <cite>评论管理</cite>
                    <i class="iconfont nav_right">&#xe697;</i></a>
                <ul class="sub-menu">
                    <li>
                        <a onclick="xadmin.add_tab('普通评论','/admin/commentCommList',true)">
                            <i class="iconfont">&#xe699;</i>
                            <cite>普通评论</cite></a>
                    </li>

                    <li>
                        <a onclick="xadmin.add_tab('删除评论','/admin/commentDelList',true)">
                            <i class="iconfont">&#xe69d;</i>
                            <cite>删除评论</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('普通吐槽','/admin/leaveCommList',true)">
                            <i class="iconfont">&#xe699;</i>
                            <cite>普通吐槽</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('删除吐槽','/admin/leaveDelList',true)">
                            <i class="iconfont">&#xe69d;</i>
                            <cite>删除吐槽</cite></a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="javascript:;">
                    <i class="iconfont left-nav-li" lay-tips="日记管理">&#xe75e;</i>
                    <cite>日记管理</cite>
                    <i class="iconfont nav_right">&#xe697;</i></a>
                <ul class="sub-menu">
                    <li>
                        <a onclick="xadmin.add_tab('添加日记','/admin/writeDiary')">
                            <i class="iconfont">&#xe6b9;</i>
                            <cite>添加日记</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('友链管理','/admin/diaryList',true)">
                            <i class="iconfont">&#xe699;</i>
                            <cite>日记列表</cite></a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="javascript:;">
                    <i class="iconfont left-nav-li" lay-tips="其他管理">&#xe696;</i>
                    <cite>其他管理</cite>
                    <i class="iconfont nav_right">&#xe697;</i></a>
                <ul class="sub-menu">
                    <li>
                        <a onclick="xadmin.add_tab('标签管理','/admin/labelList',true)">
                            <i class="iconfont">&#xe6c5;</i>
                            <cite>标签管理</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('友链管理','/admin/linkList',true)">
                            <i class="iconfont">&#xe6f7;</i>
                            <cite>友链管理</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('标签管理','/admin/userList',true)">
                            <i class="iconfont">&#xe726;</i>
                            <cite>用户管理</cite></a>
                    </li>
                </ul>
            </li>

            <li>
                <a href="javascript:;">
                    <i class="iconfont left-nav-li" lay-tips="系统管理">&#xe6ae;</i>
                    <cite>系统管理</cite>
                    <i class="iconfont nav_right">&#xe697;</i></a>
                <ul class="sub-menu">
                    <li>
                        <a onclick="xadmin.add_tab('系统配置','/admin/labelList',true)">
                            <i class="iconfont">&#xe6b5;</i>
                            <cite>系统配置</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('系统问题','/admin/linkList',true)">
                            <i class="iconfont">&#xe6b2;</i>
                            <cite>系统问题</cite></a>
                    </li>
                    <li>
                        <a onclick="xadmin.add_tab('数据可视化','/admin/userList',true)">
                            <i class="iconfont">&#xe6e6;</i>
                            <cite>数据可视化</cite></a>
                    </li>
                </ul>
            </li>

        </ul>
    </div>
</div>
<!-- <div class="x-slide_left"></div> -->
<!-- 左侧菜单结束 -->
<!-- 右侧主体开始 -->
<div class="page-content">
    <div class="layui-tab tab" lay-filter="xbs_tab" lay-allowclose="false">
        <ul class="layui-tab-title">
            <li class="home">
                <i class="layui-icon">&#xe68e;</i>我的桌面
            </li>
        </ul>
        <div class="layui-unselect layui-form-select layui-form-selected" id="tab_right">
            <dl>
                <dd data-type="this">关闭当前</dd>
                <dd data-type="other">关闭其它</dd>
                <dd data-type="all">关闭全部</dd>
            </dl>
        </div>
        <div class="layui-tab-content">
            <div class="layui-tab-item layui-show">
                <iframe src='/admin/desk' frameborder="0" scrolling="yes" class="x-iframe"></iframe>
            </div>
        </div>
        <div id="tab_show"></div>
    </div>
</div>
<div class="page-content-bg"></div>
<style id="theme_style"></style>
</body>

</html>
