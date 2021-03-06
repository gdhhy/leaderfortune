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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller

@RequestMapping("/")
public class MemberController {
    private static Logger log = LoggerFactory.getLogger(MemberController.class);
    @Autowired
    private MemberMapper memberMapper;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

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

        return "/memberInfo";
    }

    @ResponseBody
    @RequestMapping(value = "/memberWithdraw", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberWithdraw(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                                 @RequestParam(value = "draw", required = false) Integer draw,
                                 @RequestParam(value = "start", required = false) Integer start,
                                 @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberNo);
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
    @RequestMapping(value = "/memberDeposit", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberDeposit(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                                @RequestParam(value = "draw", required = false) Integer draw,
                                @RequestParam(value = "start", required = false) Integer start,
                                @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberNo);
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
    @RequestMapping(value = "/memberFunds", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberFunds(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                              @RequestParam(value = "draw", required = false) Integer draw,
                              @RequestParam(value = "start", required = false) Integer start,
                              @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberNo);
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

    @ResponseBody
    @RequestMapping(value = "/memberInvestment", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberInvestment(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                                   @RequestParam(value = "borrower", required = false) String borrower,
                                   @RequestParam(value = "draw", required = false) Integer draw,
                                   @RequestParam(value = "start", required = false) Integer start,
                                   @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberNo);
        param.put("borrower", borrower);
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
    @RequestMapping(value = "/memberReturn", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberReturn(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                               @RequestParam(value = "draw", required = false) Integer draw,
                               @RequestParam(value = "start", required = false) Integer start,
                               @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberNo);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getReturnCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectReturn(param));
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
        param.put("user_id", memberNo);
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

    @ResponseBody
    @RequestMapping(value = "/memberTarget", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberTarget(@RequestParam(value = "memberNo", required = false) Integer memberNo,
                               @RequestParam(value = "investor", required = false) String investor,
                               @RequestParam(value = "cooperative", required = false) String cooperative,
                               @RequestParam(value = "draw", required = false) Integer draw,
                               @RequestParam(value = "start", required = false) Integer start,
                               @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberNo);
        param.put("investor", investor);
        param.put("cooperative", cooperative);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getTargetCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectTarget(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

}
