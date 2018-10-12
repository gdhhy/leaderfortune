package com.zcreate.tree.pojo;

import java.io.Serializable;

public class Member implements Serializable {
    private Integer memberId;
    private String memberNo;
    private String userName;
    private String realName;
    private String idCard;
    private String phone;
    private String memberInfo;
    private Integer targetCount;
    private Integer depositCount;
    private Integer repaymentCount;
    private Integer returnCount;
    private Integer withdrawCount;
    private Integer investmentCount;
    private Integer fundsCount;

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(String memberNo) {
        this.memberNo = memberNo;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMemberInfo() {
        return memberInfo;
    }

    public void setMemberInfo(String memberInfo) {
        this.memberInfo = memberInfo;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getTargetCount() {
        return targetCount;
    }

    public void setTargetCount(Integer targetCount) {
        this.targetCount = targetCount;
    }

    public Integer getDepositCount() {
        return depositCount;
    }

    public void setDepositCount(Integer depositCount) {
        this.depositCount = depositCount;
    }

    public Integer getRepaymentCount() {
        return repaymentCount;
    }

    public void setRepaymentCount(Integer repaymentCount) {
        this.repaymentCount = repaymentCount;
    }

    public Integer getReturnCount() {
        return returnCount;
    }

    public void setReturnCount(Integer returnCount) {
        this.returnCount = returnCount;
    }

    public Integer getWithdrawCount() {
        return withdrawCount;
    }

    public void setWithdrawCount(Integer withdrawCount) {
        this.withdrawCount = withdrawCount;
    }

    public Integer getInvestmentCount() {
        return investmentCount;
    }

    public void setInvestmentCount(Integer investmentCount) {
        this.investmentCount = investmentCount;
    }

    public Integer getFundsCount() {
        return fundsCount;
    }

    public void setFundsCount(Integer fundsCount) {
        this.fundsCount = fundsCount;
    }
}
