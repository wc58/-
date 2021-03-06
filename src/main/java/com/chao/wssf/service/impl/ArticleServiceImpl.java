package com.chao.wssf.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chao.wssf.entity.Article;
import com.chao.wssf.entity.ArticleLabel;
import com.chao.wssf.entity.Other;
import com.chao.wssf.entity.Top;
import com.chao.wssf.mapper.ArticleLabelMapper;
import com.chao.wssf.mapper.ArticleMapper;
import com.chao.wssf.mapper.OtherMapper;
import com.chao.wssf.mapper.TopMapper;
import com.chao.wssf.pojo.TopArticle;
import com.chao.wssf.properties.WssfProperties;
import com.chao.wssf.query.ArticleQuery;
import com.chao.wssf.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.text.ParseException;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ArticleServiceImpl implements IArticleService {
    @Autowired
    private IOtherService otherService;
    @Autowired
    private ArticleLabelMapper articleLabelMapper;
    @Autowired
    private TopMapper topMapper;
    @Autowired
    private ITopService topService;
    @Autowired
    private OtherMapper otherMapper;
    @Autowired
    private ArticleCache articleCache;
    @Autowired
    private ILabelService labelService;
    @Autowired
    private ArticleMapper articleMapper;
    @Autowired
    private WssfProperties wssfProperties;
    @Autowired
    private ICommentService commentService;

    /**
     * 点击量排序查询
     *
     * @return
     */
    @Override
    public List<Article> getHotArticle() {
        List<Integer> articleIds = otherService.getOtherPaging().stream().map(Other::getArticleId).collect(Collectors.toList());
        //查出对应的文章
        return articleCache.getArticleByIds(articleIds);
    }

    /**
     * 置顶文章
     *
     * @return
     */
    @Override
    public List<Article> getTopArticle() {
        //查出对应的文章
        return articleCache.getTops();
    }

    /**
     * 分页查询出文章信息（置顶，普通，分类）
     *
     * @param currentPage
     * @param size
     * @return
     */
    @Override
    public Map<String, Object> listArticle(Integer currentPage, Integer size, Boolean isSort, Boolean isCondition) {
        HashMap<String, Object> map = new HashMap<>();

        map.put("tops", 0);
        //若是第一页且是普通查询（非条件），查出置顶文章
        if (currentPage.equals(1) && !isSort && !isCondition) {
            int topArticleTotal = articleCache.getTopArticleTotal();
            //若出现异常则可能一直在转圈圈！！！
            if (topArticleTotal > size)
                throw new RuntimeException("置顶文章不能大于首页最大显示数量");
            map.put("tops", topArticleTotal);
        }

        //分页文章
        map.put("data", articleCache.getAllOrSortArticle(currentPage, size, isSort, isCondition));
        //当前状态总页
        map.put("total", articleCache.getCurrentTotal());
        return map;
    }

    /**
     * 按标签进行分类
     *
     * @param id
     */
    @Override
    public void sortArticle(Integer id) {
        articleCache.sortArticle(labelService.getArticleIdsByLabelId(id));
    }

    /**
     * 条件查询
     *
     * @param condition
     */
    @Override
    public void conditionArticle(String condition) {
        articleCache.conditionArticle(condition);
    }

    //==========================================================================================================

    /**
     * 获取所有文章数（包括未展示）
     */
    @Override
    public int getAllArticleSize() {
        return articleMapper.selectCount(new QueryWrapper<>());
    }


    /**
     * 更新或者添加文章
     *
     * @return
     */
    @Transactional
    @Override
    public int insertOrUpdateArticle(ArticleQuery articleQuery) {
        Article article = new Article();
        article.setTitle(articleQuery.getTitle());
        article.setAssistant(articleQuery.getAssistant());
        article.setPicture(articleQuery.getPicture());
        article.setContent(articleQuery.getContent());
        article.setAuthor(articleQuery.getAuthor());
        article.setStatus(articleQuery.getStatus());
        if (articleQuery.getDel()) {
            article.setDel("0");
        } else {
            article.setDel("1");
        }
        article.setUpdateTime(new Date());
        Integer clientId = articleQuery.getClientId();
        //id存在说明更新
        if (clientId != null) {
            article.setId(clientId);
            articleMapper.updateById(article);
            //删除旧的重新添加
            labelService.deleteLabelsByArticleId(clientId);
            //设置标签
            setLabels(clientId, articleQuery.getLabels());
            //置顶表
            QueryWrapper<Top> topQueryWrapper = new QueryWrapper<>();
            topQueryWrapper.eq("article_id", clientId);
            //设置置顶状态
            setTop(clientId, articleQuery.getTop());
            articleCache.updateData();
        } else {//添加
            article.setCreateTime(new Date());
            articleMapper.insert(article);
            Integer daoId = article.getId();
            //其他表
            Other other = new Other();
            other.setArticleId(daoId);
            other.setFlow(0);
            other.setCommentSize(0);
            otherMapper.insert(other);
            //设置标签
            setLabels(daoId, articleQuery.getLabels());
            //设置置顶状态
            setTop(daoId, articleQuery.getTop());
            articleCache.updateData();
        }
        return article.getId();
    }

    /**
     * 设置置顶状态
     *
     * @param articleId 文章ID
     * @param top       是否置顶
     */
    private int setTop(Integer articleId, Boolean top) {
        //目前置顶数
        Integer tops = topMapper.selectCount(new QueryWrapper<>());
        //既是置顶又在可控数量内
        if (top && tops < wssfProperties.getQuerySize()) {
            if (topMapper.selectOne(new QueryWrapper<Top>().eq("article_id", articleId)) == null)
                topService.addTop(articleId);
            return 1;
        } else {
            topService.cancelTop(articleId);
        }
        return 0;
    }


    /**
     * 为文章设置标签
     *
     * @param articleId
     * @param labels
     */
    private void setLabels(Integer articleId, Integer[] labels) {
        for (Integer labelId : labels) {
            ArticleLabel articleLabel = new ArticleLabel();
            articleLabel.setArticleId(articleId);
            articleLabel.setLabelId(labelId);
            articleLabelMapper.insert(articleLabel);
        }
    }


    /**
     * 既不是置顶也没有被删除
     *
     * @param tops
     * @return
     */
    @Override
    public Page<Article> getCommArticle(List<Integer> tops, ArticleQuery articleQuery) throws ParseException {
        QueryWrapper<Article> articleQueryWrapper = new QueryWrapper<>();
        //必备条件
        articleQueryWrapper.notIn("id", tops).eq("del", "0").orderByDesc("create_time");
        //可选条件
        condition(articleQuery, articleQueryWrapper);
        Page<Article> articlePage = new Page<>(articleQuery.getPage(), articleQuery.getLimit());
        return articleMapper.selectPage(articlePage, articleQueryWrapper);
    }

    /**
     * 既不是置顶也没有被删除
     *
     * @param tops
     * @return
     */
    @Override
    public Page getTopArticle(List<Top> tops, ArticleQuery articleQuery) {
        QueryWrapper<Article> articleQueryWrapper = new QueryWrapper<>();
        //必备条件
        List<Integer> ids = tops.stream().map(Top::getArticleId).collect(Collectors.toList());
        //防止sql错误
        ids.add(-1);
        articleQueryWrapper.in("id", ids);
        //可选条件
        condition(articleQuery, articleQueryWrapper);
        Page<Article> articlePage = new Page<>(articleQuery.getPage(), articleQuery.getLimit());
        Page selectPage = articleMapper.selectPage(articlePage, articleQueryWrapper);
        //偷梁换柱，因为涉及多张表，而前端响应格式限定，所有只能这样来改变数据=======================================
        List records = selectPage.getRecords();
        ArrayList<TopArticle> topArticles = new ArrayList<>();

        for (Top top : tops) {
            for (Object obj : records) {
                Article article = (Article) obj;
                if (top.getArticleId().equals(article.getId())) {
                    TopArticle topArticle = new TopArticle();
                    //对象属性复制
                    BeanUtils.copyProperties(top, topArticle);
                    BeanUtils.copyProperties(article, topArticle);
                    topArticles.add(topArticle);
                    break;
                }
            }
        }
        selectPage.setRecords(topArticles);
        //偷梁换柱=======================================
        return selectPage;
    }

    /**
     * 根据标题查找文章
     *
     * @param title
     * @return
     */
    @Override
    public List<Article> getArticleByTitle(String title) {
        return articleMapper.selectList(new QueryWrapper<Article>().like("title", title));
    }

    /**
     * 根据id查询文章
     *
     * @param id
     * @return
     */
    @Override
    public Article getArticleById(Integer id) {
        return articleMapper.selectById(id);
    }

    /**
     * 主要用于在列表中更新使用
     *
     * @param article
     */
    @Override
    public void updateArticle(Article article) {
        articleMapper.updateById(article);
    }

    /**
     * 逻辑删除文章
     *
     * @param id
     */
    @Override
    public void deleteArticleById(Integer id) {
        Article article = new Article();
        article.setId(id);
        article.setDel("1");
        articleMapper.updateById(article);
    }

    /**
     * 被逻辑删除的文章
     */
    @Override
    public Page<Article> getDelArticle(ArticleQuery articleQuery) {
        QueryWrapper<Article> articleQueryWrapper = new QueryWrapper<>();
        //必备条件
        articleQueryWrapper.ne("del", "0").orderByDesc("create_time");
        //可选条件
        condition(articleQuery, articleQueryWrapper);
        Page<Article> articlePage = new Page<>(articleQuery.getPage(), articleQuery.getLimit());
        return articleMapper.selectPage(articlePage, articleQueryWrapper);
    }

    /**
     * 指定文章置顶
     *
     * @param id
     * @return
     */
    @Override
    public int topArticle(Integer id) {
        return setTop(id, true);
    }

    /**
     * 真实的删除
     *
     * @param articleId
     */
    @Override
    public void deleteRealArticleById(Integer articleId) {
        //删除文章
        articleMapper.deleteById(articleId);
        //以及对应的评论
        commentService.deleteRealCommentByArticleId(articleId);
        //其他信息
        otherService.deleteRealOtherByArticleId(articleId);
        //标签信息
        labelService.deleteLabelsByArticleId(articleId);
    }

    /**
     * 还原文章
     *
     * @param id
     */
    @Override
    public void restoreArticle(Integer id) {
        Article article = new Article();
        article.setId(id);
        article.setDel("0");
        articleMapper.updateById(article);
    }

    /**
     * 非必要的条件
     */
    private void condition(ArticleQuery articleQuery, QueryWrapper<Article> articleQueryWrapper) {
        Integer label = articleQuery.getLabel();
        String title = articleQuery.getTitle();
        String author = articleQuery.getAuthor();
        String status = articleQuery.getStatus();
        Date startTime = articleQuery.getStartTime();
        Date endTime = articleQuery.getEndTime();

        if (!StringUtils.isEmpty(label) && !label.equals(-1)) {
            List<Integer> articleIds = labelService.getArticleIdsByLabelId(label);
            articleQueryWrapper.in("id", articleIds);
        }
        if (!StringUtils.isEmpty(title)) {
            articleQueryWrapper.like("title", title);
        }
        if (!StringUtils.isEmpty(author)) {
            articleQueryWrapper.like("author", author);
        }
        if (!StringUtils.isEmpty(status)) {
            articleQueryWrapper.like("status", status);
        }
        if (!StringUtils.isEmpty(startTime)) {
            articleQueryWrapper.ge("create_time", startTime);
        }
        if (!StringUtils.isEmpty(endTime)) {
            articleQueryWrapper.le("create_time", endTime);
        }
    }


}
