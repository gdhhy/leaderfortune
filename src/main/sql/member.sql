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
select id,用户名,真实姓名,身份证号码,电话号码,
    CONCAT('{"基本信息":{"注册时间":"',`注册时间`,'","类型":"',ifnull(类型,''),'","合作机构":"',ifnull(合作机构,''),'","邮箱账号":"',ifnull(邮箱账号,''),'","注册地址":"',ifnull(注册地址,''),'"},',
           '"银行账户":{"银行卡号":"',ifnull(绑定的银行卡号,''),'","支行名称":"',ifnull(支行名称,''),'","开户行地址":"',ifnull(开户行地址,''),'","银行名称":"',ifnull(银行名称,''),'","第三方账号":"',ifnull(第三方账号,''),'"},',
           '"资金":{"借款总金额":"',ifnull(借款总金额,''),'","借款次数":"',ifnull(借款次数,''),'","应还本息":"',ifnull(应还本息,''),'","已还利息":"',ifnull(已还利息,''),'","总投资金额":"',ifnull(总投资金额,''),'","已收本金":"',ifnull(已收本金,''),'","已收利息":"',ifnull(已收利息,''),'"},',

           '"旧资料":{"uid":"',旧uid,'","汇付天下账户":"',ifnull(`(旧)汇付天下账户`,''),'","汇付天下id":"',ifnull(`(旧)汇付天下id`,''),'","银行":"',ifnull(`(旧)银行`,''),
           '","银行卡号":"',ifnull(`(旧)银行卡号`,''),'","支行":"',ifnull(`(旧)支行`,''),'","借款总金额":"',ifnull(`(旧)借款总金额`,''),'","借款次数":"',ifnull(`(旧)借款次数`,''),
           '","担保公司":"',ifnull(`(旧)担保公司`,''),'","已还总利息":"',ifnull(`(旧)已还总利息`,''),'","已还总本金":"',ifnull(`(旧)已还总本金`,''),'","已收总利息":"',ifnull(`(旧)已收总利息`,''),
           '","已收总本金":"',ifnull(`(旧)已收总本金`,''),'","注册时间":"',ifnull(`(旧)注册时间`,''),'"},',

           '"资金汇总":{"总充值":"',ifnull(总充值,''),'","总提现":"',ifnull(总提现,''),'"}',
           '}')
from user ;

update  member set target_count=0,deposit_count=0,repayment_count=0,return_count=0,withdraw_count=0,investment_count=0,funds_count=0;
update member A
join (select user_id,count(user_id)  cc from biaodi group by  user_id  ) B on A.member_no=B.user_id set A.target_count=B.cc;

update member A
join (select user_id,count(user_id)  cc from chongzhi group by  user_id  ) B on A.member_no=B.user_id set A.deposit_count=B.cc;
update member A
join (select 用户id,count(用户id)  cc from huankuan group by  用户id  ) B on A.member_no=B.用户id set A.repayment_count=B.cc;
update member A
join (select user_id,count(user_id)  cc from huikuan group by  user_id  ) B on A.member_no=B.user_id  set A.return_count=B.cc;
update member A
join (select user_id,count(user_id)  cc from tixian group by  user_id  ) B on A.member_no=B.user_id set A.withdraw_count=B.cc;
update member A
join (select user_id,count(user_id)  cc from touzi group by  user_id  ) B on A.member_no=B.user_id set A.investment_count=B.cc;
update member A
join (select 用户id,count(用户id)  cc from useraccount group by  用户id  ) B on A.member_no=B.用户id set A.funds_count=B.cc;