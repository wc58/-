package com.chao.wssf.pojo;

import com.chao.wssf.entity.*;
import lombok.Data;
import lombok.ToString;

import java.util.List;

/**
 * 该类包括文章的所有信息：
 * 文章的主要信息，点击量，评论，标签，置顶等等
 */
@Data
@ToString
public class FullBlog {

    private Article article;
    private Other other;
    private List<Comment> comment;

}
