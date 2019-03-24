-- drop table member;
CREATE TABLE member (
  member_id   int          auto_increment,
  member_no   varchar(20) NOT NULL,
  user_name   varchar(100) default '', -- 用户名
  real_name   varchar(100) default '',
  id_card     varchar(100) default '', -- 身份证号码
  phone       varchar(100) default '', -- 电话
  email       varchar(100) default '', -- email
  member_info json         DEFAULT NULL,
  target_count int default 0,
  deposit_count int default 0,
  repayment_count int default 0,
  return_count int default 0,
  withdraw_count int default 0,
  investment_count int default 0,
  funds_count int default 0,
  PRIMARY KEY (member_id)
);


alter table member
  add index ix_memberno (member_no);
alter table member
  add index ix_realname (real_name);
alter table member
  add index ix_idcard (id_card);
alter table member
  add index ix_phone(phone);
alter table member
  add index ix_user_name(user_name);


insert into member (member_no,user_name,real_name,id_card,phone,member_info)
select 会员id,姓名,真实姓名,证件号码,手机号码,
       CONCAT('{"基本信息":{"银行卡号":"',银行卡号,
       '","支行地址":"',ifnull(支行地址,''),
       '","住址":"',ifnull(住址,''),
       '","等级":"',ifnull(等级,''),
       '","注册时间":"',ifnull(注册时间,''),
       '","充值积分":"',ifnull(充值积分,''),
       '","提现金额":"',ifnull(提现金额,''),
       '","赠送积分":"',ifnull(赠送积分,''),
       '","客服股权充入、积分转股权、赠送股权等":"',ifnull(客服股权充入、积分转股权、赠送股权等,''),
       '","购买股权":"',ifnull(购买股权,''),
       '","股权份额赠送":"',ifnull(股权份额赠送,''),
       '","积分余额":"',ifnull(积分余额,''),
       '","创业金余额":"',ifnull(创业金余额,''),
       '"}',

      '}') from (
select a.member_id 会员id,a.name 姓名,f.real_name 真实姓名,f.card_id 证件号码,a.phone 手机号码,c.account 银行卡号 ,c.`network` 支行地址 ,a.address 住址,d.`level` 等级,FROM_UNIXTIME(d.reg_time) 注册时间,cz.integral 充值积分,tx.amount 提现金额,zs.buy_quota 赠送积分,gq.`客服股权充入、积分转股权、赠送股权等`,gq.`购买股权`,gq.`股权份额赠送`,jac.integral_balance 积分余额,cac.wallet_balance 创业金余额
from gcy_v3.mm_profile a
left join gcy_v3.mm_bank c on a.member_id=c.member_id
left join gcy_v3.mm_member d on a.member_id=d.id
left join gcy_v3.mm_trusted_info f on a.member_id=f.member_id
left join (select a.member_id ,sum(a.integral) integral
from ppi_log a
WHERE type in(2,6) AND (title  LIKE '%wechat%' or title  LIKE '%alipay%' or
 title  LIKE '%ICBC%' or title LIKE '现金%' or title  LIKE '%积分充值%' or title like '冲正原交易%') and integral<1000000
group by a.member_id)  cz on a.member_id=cz.member_id
left join (select a.member_id ,sum(a.amount) amount
from gcy_v3.mm_wallet_log a
where a.kind in(12,13) and a.state>=3 group by a.member_id) tx on a.member_id=tx.member_id
left join (select a.member_id ,sum(a.buy_quota*a.price*b.rate) buy_quota
from ppi_order a
left join ppi_item b on a.item_id=b.id
where is_refund=0  group by a.member_id) zs on a.member_id=zs.member_id
left join (select b.member_id  ,sum(case when  a.kind in(1,4,5,6)  then  a.quota end) '客服股权充入、积分转股权、赠送股权等', sum(case when a.kind in(2,3) then a.quota end) '购买股权' ,sum(case when a.kind =7 then a.quota end) '股权份额赠送'
from gq1_quota_log a
inner join gq1_account b on a.account_id=b.id
group by b.member_id
) gq on a.member_id=gq.member_id
left join (select member_id,sum(integral_balance) integral_balance from ppi_account group by member_id) jac on a.member_id=jac.member_id
left join (select member_id,sum(wallet_balance) wallet_balance from gcy_v3.mm_account group by member_id) cac on a.member_id=cac.member_id
 where (ifnull(cz.integral,0) + ifnull(tx.amount,0) + IFNULL(zs.buy_quota,0)+ IFNULL(gq.`客服股权充入、积分转股权、赠送股权等`,0)+ IFNULL(gq.`购买股权`,0)+ IFNULL(gq.`股权份额赠送`,0)+IFNULL(jac.integral_balance,0)+ IFNULL(cac.wallet_balance,0)  )!=0
order by a.member_id )A