package com.zcreate.tree.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.tree.dao.MemberMapper;
import com.zcreate.tree.pojo.Member;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@Controller

@RequestMapping("/")
public class MemberController {
    private static Logger log = LoggerFactory.getLogger(MemberController.class);
    @Autowired
    private MemberMapper memberMapper;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();
    @Resource
    private Properties configs;

    @ResponseBody
    @RequestMapping(value = "/listMember", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listMember(@RequestParam(value = "memberNo", required = false) String memberNo,
                             @RequestParam(value = "phone", required = false) String phone,
                             @RequestParam(value = "idCard", required = false) String idCard,
                             @RequestParam(value = "userName", required = false) String userName,
                             @RequestParam(value = "realName", required = false) String realName,
                             @RequestParam(value = "borrower", required = false) String borrower,
                             @RequestParam(value = "investor", required = false) String investor,
                             @RequestParam(value = "cooperative", required = false) String cooperative,
                             @RequestParam(value = "threeThirty", required = false) Boolean threeThirty,
                             @RequestParam(value = "draw", required = false) Integer draw,
                             @RequestParam(value = "start", required = false) Integer start,
                             @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length
    ) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("phone", phone);
        param.put("idCard", idCard);
        param.put("userName", userName);
        param.put("realName", realName);
        param.put("borrower", borrower);
        param.put("investor", investor);
        param.put("cooperative", cooperative);
        param.put("threeThirty", threeThirty);
        param.put("start", start);
        param.put("length", length);
        int recordCount = memberMapper.getMemberCount(param);
        List<Member> members = memberMapper.selectMember(param);
       /* for(Member map:members){
            JsonObject json=gson.fromJson(map.getMemberInfo(), JsonObject.class);
            map.put("usertype",((JsonObject)json.get("基本信息")).get("类型"));
            map.put("deposit",((JsonObject)json.get("资金汇总")).get("总充值"));
            map.put("withdraw",((JsonObject)json.get("资金汇总")).get("总提现"));
            log.debug("usertype="+map.get("usertype"));
        }*/

        Map<String, Object> result = new HashMap<>();
        result.put("data", members);
        result.put("draw", draw);//draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }


    @RequestMapping(value = "/member", method = RequestMethod.GET)
    public String member(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        log.debug("url = member");

        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/member";
    }


    @RequestMapping(value = "/memberInfo", method = RequestMethod.GET)
    public String memberInfo(@RequestParam(value = "memberNo", required = false) String memberNo,
                             @RequestParam(value = "realName", required = false) String realName,
                             @RequestParam(value = "userName", required = false) String userName,
                             ModelMap model) {
        //log.debug("url = memberInfo");
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("realName", realName);
        param.put("userName", userName);
        List<Member> members = memberMapper.selectMember(param);
        if (members.size() >= 1)
            model.addAttribute("member", members.get(0));
       /* else
            model.addAttribute("member", new Member());*/

        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberInfo";
    }

    @ResponseBody
    @RequestMapping(value = "/withdraw", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String withdraw(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                                 @RequestParam(value = "draw", required = false) Integer draw,
                                 @RequestParam(value = "start", required = false) Integer start,
                                 @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getWithdrawCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectWithdraw(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/deposit", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String deposit(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                          @RequestParam(value = "draw", required = false) Integer draw,
                          @RequestParam(value = "start", required = false) Integer start,
                          @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getDepositCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectDeposit(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/funds", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String funds(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                        @RequestParam(value = "draw", required = false) Integer draw,
                        @RequestParam(value = "start", required = false) Integer start,
                        @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getFundsCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectFunds(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @RequestMapping(value = "/memberInvestment", method = RequestMethod.GET)
    public String memberInvestment(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberInvestment";
    }

    @RequestMapping(value = "/memberFunds", method = RequestMethod.GET)
    public String memberFunds(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberFunds";
    }

    @RequestMapping(value = "/memberDeposit", method = RequestMethod.GET)
    public String memberDeposit(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberDeposit";
    }
    @RequestMapping(value = "/memberWithdraw", method = RequestMethod.GET)
    public String memberWithdraw(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberWithdraw";
    }
    @RequestMapping(value = "/memberStock", method = RequestMethod.GET)
    public String memberStock(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberStock";
    }

    @ResponseBody
    @RequestMapping(value = "/investment", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String investment(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                             @RequestParam(value = "draw", required = false) Integer draw,
                             @RequestParam(value = "start", required = false) Integer start,
                             @RequestParam(value = "length", required = false, defaultValue = "1000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getInvestmentCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectInvestment(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/stock", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String stock(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                               @RequestParam(value = "draw", required = false) Integer draw,
                               @RequestParam(value = "start", required = false) Integer start,
                               @RequestParam(value = "length", required = false, defaultValue = "1000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getStockCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectStock(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/memberRepayment", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberRepayment(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                                  @RequestParam(value = "draw", required = false) Integer draw,
                                  @RequestParam(value = "start", required = false) Integer start,
                                  @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getRepaymentCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectRepayment(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @RequestMapping(value = "/memberOrder", method = RequestMethod.GET)
    public String memberOrder(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        model.addAttribute("title", configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/memberOrder";
    }

    @ResponseBody
    @RequestMapping(value = "/order", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String order(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                        @RequestParam(value = "draw", required = false) Integer draw) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);

        int recordCount = memberMapper.getOrderCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectOrder(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);

        result.put("title", configs.getProperty("title"));
        result.put("short_title", configs.getProperty("short_title"));
        return gson.toJson(result);
    }

}
