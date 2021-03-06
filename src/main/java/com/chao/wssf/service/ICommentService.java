package com.chao.wssf.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chao.wssf.entity.Comment;
import com.chao.wssf.pojo.FullComment;
import com.chao.wssf.query.CommentQuery;

import java.text.ParseException;
import java.util.List;

public interface ICommentService {

    public int getCommentSizeByArticleId(Integer articleId);

    List<FullComment> getCommentsByArticleId(Integer id);

    void addReply(Comment comment);

    int getAllCommentSize();

    void deleteRealCommentByArticleId(Integer id);

    Page getComments(Boolean isDel, CommentQuery commonQuery) throws ParseException;

    void deleteById(Integer id);

    void deleteRealById(Integer id);

    void updateComment(Integer id, String content);

    void restoreCommentById(Integer id);

}
