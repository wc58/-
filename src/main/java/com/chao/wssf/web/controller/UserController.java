package com.chao.wssf.web.controller;

import com.chao.wssf.entity.Link;
import com.chao.wssf.entity.User;
import com.chao.wssf.service.ILinkService;
import com.chao.wssf.service.IUserService;
import com.chao.wssf.util.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("user")
public class UserController {

    @Autowired
    private ILinkService linkService;
    @Autowired
    private IUserService userService;

    /**
     * 用于测试
     *
     * @param thirdId
     * @param email
     */
    @RequestMapping("testLogin")
    @ResponseBody
    public R testLogin(@RequestParam("thirdId") String thirdId, @RequestParam("email") String email, HttpSession session) {
        User user = userService.checkUser(thirdId, email);
        if (user != null) {
            session.setAttribute("user", user);
            //判断该账号是否申请过友链
            Link link = linkService.getLinkByUserId(user.getId());
            session.setAttribute("isApply", link);
            //七天的有效期
            session.setMaxInactiveInterval(60 * 60 * 24 * 7);
            return R.OK();
        }
        return R.ERROR();
    }

    @RequestMapping("qqLogin")
    public String qqLogin() {
        System.out.println("=====================================");
        return "forward:/blog/list";
    }

}
