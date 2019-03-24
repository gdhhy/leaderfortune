package com.zcreate.tree.dao;

import com.zcreate.tree.pojo.Member;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 17-5-5.
 */
@Mapper
public interface MemberMapper {
    int getMemberCount(@Param("param") Map<String, Object> param);

    List<Member> selectMember(@Param("param") Map<String, Object> param);

    int getOrderCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectOrder(@Param("param") Map<String, Object> param);

    int getDepositCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectDeposit(@Param("param") Map<String, Object> param);

    int getRepaymentCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectRepayment(@Param("param") Map<String, Object> param);

    int getStockCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectStock(@Param("param") Map<String, Object> param);

    int getWithdrawCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectWithdraw(@Param("param") Map<String, Object> param);

    int getInvestmentCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectInvestment(@Param("param") Map<String, Object> param);

    int getFundsCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectFunds(@Param("param") Map<String, Object> param);

}
