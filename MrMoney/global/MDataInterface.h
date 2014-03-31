//
//  MDataInterface.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//https://www.qianxs.com
//http://124.207.84.165:97
 /**
 *  接口URL
 */
extern const NSString* M_URL_Regist;               //用户注册
extern const NSString* M_URL_ObtainCode;           //获取短信验证码
extern const NSString* M_URL_Login;                //登录接口
extern const NSString* M_URL_FinanceProduct;       //理财产品
extern const NSString* M_URL_internetProduct;      //金融产品
extern const NSString* M_URL_productDetail;        //产品详情
extern const NSString* M_URL_GetAuthCode;          //获取验证码
extern const NSString* M_URL_BuyProduct;           //购买
extern const NSString* M_URL_queryInvestState;     //查询我的钱宝宝
extern const NSString* M_URL_fund;                 //基金产品
extern const NSString* M_URL_queryAssetAccount;    //查询关联卡信息
extern const NSString* M_URL_SubmitOrder;          //提交订单
extern const NSString* M_URL_Pay;                  //盛付通支付
extern const NSString* M_URL_TradeRecords;         //查询交易明细
extern const NSString* M_URL_AllComment;           //产品评论
extern const NSString* M_URL_ModifyPassword;       //修改密码
extern const NSString* M_URL_ModifyEmail;          //修改邮箱
extern const NSString* M_URL_queryTransStreams;    //我的投资记录
extern const NSString* M_URL_Calendar;             //投资日记
extern const NSString* M_URL_resetPwd;             //重置密码
extern const NSString* M_URL_sendEmail;            //发送邮件
extern const NSString* M_URL_uploadIcon;           //上传头像
extern const NSString* M_URL_risk;                 //提交风险
extern const NSString* M_URL_appendAssetAccount;   //添加银行账号到本地
extern const NSString* M_URL_syncAssetAccount;     //同步账户信息
extern const NSString* M_URL_unbindAssetAccount;   //解除绑定银行卡
extern const NSString* M_URL_listActivity;         //活动聊天列表
extern const NSString* M_URL_withdraw;             //申请提现
extern const NSString* M_URL_useBalanceToBuy;      //钱宝宝支付
extern const NSString* M_URL_queryProduct;         //首页查询产品
extern const NSString* M_URL_rechargeOrder;        //充值订单
extern const NSString* M_URL_signAlipay;           //一键签约余额宝
extern const NSString* M_URL_qqoauth;              //认证qq
extern const NSString* M_URL_binding;              //绑定qq
extern const NSString* M_URL_presentedPrincipal;   //分享返还现金
extern const NSString* M_URL_addComment;           //发表评论
extern const NSString* M_URL_fuzzyQuery;           //地址模糊查询
/**
 *  公用字段
 */
extern const NSString* M_KEY_REQUESTID;//请求标识，由客户端产生，客户端唯一(weblogid)
extern const NSString* M_KEY_MSGTOKEN;//信息校验令牌
extern const NSString* M_KEY_DEVICEID;//客户端设备标识
extern const NSString* M_KEY_APPVERSION;//客户端版本号
extern const NSString* M_VALUE_APPVERSION;//客户端版本号
extern const NSString* M_KEY_DEVICEMODEL;//终端设备的型号信息
extern const NSString* M_KEY_PLATTYPE;//系统平台类型
extern const NSString* M_VALUE_PLATTYPE;//系统平台类型
extern const NSString* M_KEY_PLATDESC;//系统平台信息描述,比如ios4.0
extern const NSString* M_KEY_CHANNELCODE;//推广渠道编号
extern const NSString* M_VALUE_CHANNELCODE;//推广渠道编号

extern const NSString* M_KEY_USERID;//用户唯一标示
extern const NSString* M_KEY_LOGINNAME;//用户名或email地址
extern const NSString* M_KEY_PASSWORD;//密码
extern const NSString* M_KEY_EMAILREGLIMIT;//注册用户名限制，只能邮件地址
extern const NSString* M_KEY_DOWNLOADURL;//下载地址
extern const NSString* M_KEY_PRODUCTDISPLAYIMG;//购物车商品展示图片
extern const NSString* M_KEY_ISREMEMBERUSER;//是否记录用户信息
extern const NSString* M_KEY_DEVICETOKEN;//设备deviceToke

 

 

@interface MDataInterface : NSObject

+(void) initialize;
+(void)initializeCommonParams;
+(void) setCommonParam:(id)key value:(id)value;
+(id) commonParam:(id) key;
+(NSMutableDictionary *)commonParams;
+(void)walkDataInterface;
@end
