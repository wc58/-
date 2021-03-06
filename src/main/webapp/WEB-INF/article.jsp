<%--
  Created by IntelliJ IDEA.
  User: ChaoSir
  Date: 2020/7/10
  Time: 15:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width"/>
    <meta name="author" content="www.yanshisan.cn"/>
    <meta name="robots" content="all"/>
    <title>文章列表</title>
    <link rel="icon" href="${pageContext.request.contextPath}/logo.png" type="image/x-icon"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/master.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gloable.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/blog.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nprogress.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/blog.css"/>
</head>
<body>
<div class="header">
</div>
<header class="gird-header">
    <div class="header-fixed">
        <div class="header-inner">
            <a href="/blog/list" class="header-logo" id="logo">Chao.Sir</a>
            <%@ include file="include-bar.jsp" %>

            <a class="phone-menu ">
                <i></i>
                <i></i>
                <i></i>
            </a>

        </div>
    </div>
</header>
<div class="doc-container" id="doc-container">
    <div class="container-fixed">
        <div class="col-content">

            <span class="searchphone d5 article-list">
                 <br class="searchphone"/>
                <form>
                    <input id="searchtxtphone" onkeydown="return disableTextSubmit(event)"
                           value="${condition != null&& !condition.equals("")?condition:''}" type="text"
                           placeholder="搜索从这里开始...">
                    <button id="searchbtnphone" class="layui-anim-rotate" type="button"></button>
                </form>
            </span>
            <div class="inner">
                <article class="article-list bloglist" id="LAY_bloglist">
                    <%--文章位置--%>
                </article>
            </div>
        </div>
        <div class="col-other">
            <div class="inner">
                <div class="other-item" id="categoryandsearch">
                    <div class="search">
                        <label class="search-wrap">
                            <input type="text" id="searchtxt"
                                   value="${condition != null&& !condition.equals("")?condition:''}"
                                   placeholder="输入关键字搜索"/>
                            <span class="search-icon">
					                <i id="searchbtn" class="fa fa-search"></i>
					            </span>
                        </label>
                        <ul class="search-result"></ul>
                    </div>
                    <ul class="category mt20" id="category">
                        <li data-index="0" class="slider"></li>
                        <li data-index="1"><a href="/blog/list">全部文章</a></li>
                        <%--标签--%>
                        <c:forEach items="${labels}" var="label" varStatus="i">
                            <li data-index="${i.count+1}"><a href="/blog/list?sortId=${label.id}">${label.name}</a></li>
                        </c:forEach>
                    </ul>
                </div>

                <!--右边悬浮 平板或手机设备显示-->
                <div class="category-toggle"><i class="layui-icon">&#xe603;</i></div>
                <div class="article-category">
                    <%--标签--%>
                    <div class="article-category-title">标签导航</div>
                    <a href="/blog/list">全部文章</a>
                    <c:forEach items="${labels}" var="label">
                        <a href="/blog/list?sortId=${label.id}">${label.name}</a>
                    </c:forEach>
                </div>

                <!--遮罩-->
                <div class="blog-mask animated layui-hide"></div>
                <div class="other-item">
                    <h5 class="other-item-title">热门文章</h5>
                    <div class="inner">
                        <ul class="hot-list-article">
                            <%--热门文章--%>
                            <c:forEach items="${hotArticles}" var="hotArticle" begin="0" end="7">
                                <li><a href="/blog/read/${hotArticle.id}">${hotArticle.title}</a></li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="other-item">
                    <h5 class="other-item-title">置顶推荐</h5>
                    <div class="inner">
                        <ul class="hot-list-article">
                            <%--置顶文章--%>
                            <c:forEach items="${topArticles}" var="topArticle">
                                <li><a href="/blog/read/${topArticle.id}">${topArticle.title}</a></li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="other-item">
                    <h5 class="other-item-title">最近访客</h5>
                    <div class="inner">
                        <dl class="vistor">
                            <c:forEach items="${users}" var="user">
                                <dd><a href="javasript:;"><img
                                        src="${user.icon}"><cite>${user.name}</cite></a>
                                </dd>
                            </c:forEach>
                        </dl>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<%@ include file="include-footer.jsp" %>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script src="${pageContext.request.contextPath}/js/yss/gloable.js"></script>
<script src="${pageContext.request.contextPath}/js/plugins/nprogress.js"></script>
<script>NProgress.start();</script>
<script src="${pageContext.request.contextPath}/js/yss/article.js"></script>
<script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
<script>

    let isAuto = true;
    //平台、设备和操作系统
    var system = {
        win: false,
        mac: false,
        xll: false
    };
    //检测平台
    var p = navigator.platform;
    system.win = p.indexOf("Win") == 0;
    system.mac = p.indexOf("Mac") == 0;
    system.x11 = (p == "X11") || (p.indexOf("Linux") == 0);
    //跳转语句，如果是手机访问就自动跳转到wap.baidu.com页面
    if (system.win || system.mac || system.xll) {
        //电脑端自动加载
        isAuto = true;
    } else {
        //手机端手动加载
        isAuto = false;
    }
    /*加载文章*/
    layui.use('flow', function () {
        var $ = layui.jquery;
        var flow = layui.flow;
        flow.load({
            elem: '#LAY_bloglist',
            isAuto: isAuto,
            mb: 1,
            end: '-----------我也是有底线的-----------',
            done: function (page, next) {
                $.ajax({
                    type: 'post',
                    url: 'article?page=' + page,
                    success: function (data) {
                        next(data.articles, page < data.pageTotal);

                    },
                    error: function () {
                        layer.msg('服务器出现了错误，请联系管理员，谢谢。<br/>QQ：2258354832<br/>email：2258354832@qq.com', {
                            icon: 2,
                            time: 4000
                        }, function (index) {
                            location.href = "${pageContext.request.contextPath}/"
                            layer.close(index);
                        });
                    },
                    dataType: 'json'
                })

            }
        });

    });

    window.onload = function () {
        NProgress.done();
    };


    layui.use('element', function () {
        var $ = layui.$
        $("#searchbtn").click(function () {
            var condition = $("#searchtxt").val();
            location.href = "/blog/list?condition=" + condition
        })

        $("#searchbtnphone").click(function () {
            var conditionphone = $("#searchtxtphone").val();
            location.href = "/blog/list?condition=" + conditionphone
        })

    });

    function disableTextSubmit(e) {
        if (e.keyCode == 13) {
            return false;
        }
    }


</script>
</body>
</html>
