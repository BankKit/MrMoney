//
//  MDataInterface.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MDataInterface.h"


/**
 *  用户注册 pp
 */
const NSString* M_URL_Regist = @"https://www.qianxs.com/mrMoney/mobile/invite/member/regByMobile.html";

/**
 *  注册时获取短信验证码 ppp
 */
const NSString* M_URL_ObtainCode = @"https://www.qianxs.com/mrMoney/mobile/invite/member/validateMobileOnly.html";

/**
 *  初始化盛付通交易订单
 */
//const NSString* M_URL_SubmitOrder =  @"https://www.qianxs.com/mrMoney/mobile/invite/sdo/initOrder.html";
//银生宝接口
const NSString* M_URL_SubmitOrder =  @"https://www.qianxs.com/mrMoney/mobile/invite/ysb/initYsbOrder.html";
/**
 *  查询交易明细 记账明细
 */
const NSString* M_URL_TradeRecords = @"https://www.qianxs.com/mrMoney/mobile/invite/member/queryTransRecords.html";
/**
 *  盛付通支付界面
 */

const NSString *M_URL_Pay  = @"https://mas.sdo.com/web-acquire-channel/cashier.htm";

/**
 *  理财产品列表 searchInternetProd
 */
const NSString* M_URL_FinanceProduct = @"https://www.qianxs.com/mrMoney/mobile/Product/searchProd.json";

/**
 *  金融产品列表
 */
const NSString* M_URL_internetProduct = @"https://www.qianxs.com/mrMoney/mobile/Internet/searchProd.json";


/**
 *  产品详情
 */
const NSString* M_URL_productDetail = @"https://www.qianxs.com/mrMoney/mobile/Product/haveProdDetail";
/**
 *  我的钱宝宝
 */
const NSString* M_URL_queryInvestState  = @"https://www.qianxs.com/mrMoney/mobile/invite/member/queryInvestStatV2.html";
/**
 *  基金产品
 */
const NSString* M_URL_fund = @"https://www.qianxs.com/mrMoney/mobile/Fund/searchFund.json";
/**
 *  查询关联卡信息 pp
 */
const NSString* M_URL_queryAssetAccount = @"https://www.qianxs.com/mrMoney/mobile/invite/member/queryAssetAccount.html";

/**
 *  获取验证码 124.207.84.162:888/mrServer/GetAuthCode?hxb_2
 */
const NSString* M_URL_GetAuthCode = @"http://robot.qianxs.com:888/mrServer/GetAuthCode";

/**
 *  购买产品
 */
const NSString* M_URL_BuyProduct = @"http://robot.qianxs.com:888/mrServer/IronRobot_Login";

/**
 *  用户登录
 */
 
const NSString* M_URL_Login = @"https://www.qianxs.com/mrMoney/mobile/member/login";
/**
 *  产品评论列表
 */
const NSString* M_URL_AllComment = @"https://www.qianxs.com/mrMoney/mobile/member/getAllCommentByProductId.html";
/**
 *  修改密码
 */
const NSString* M_URL_ModifyPassword = @"https://www.qianxs.com/mrMoney/mobile/invite/joiner/modifyPassword.html";
/**
 *  修改邮箱
 */
const NSString* M_URL_ModifyEmail = @"https://www.qianxs.com/mrMoney/mobile/invite/member/modifyMem.html";
/**
 *  我的投资记录
 */
const NSString* M_URL_queryTransStreams = @"https://www.qianxs.com/mrMoney/mobile/invite/member/queryTransStreams.html";
/**
 *  投资日记
 */
const NSString* M_URL_Calendar = @"https://www.qianxs.com/mrMoney/mobile/invite/activity/queryMemberJournal.html";
/**
 *  重置密码
 */
const NSString* M_URL_resetPwd = @"https://www.qianxs.com/mrMoney/mobile/invite/member/resetPwd.html";

/**
 *  发送邮件
 */
const NSString* M_URL_sendEmail = @"http://www.huchao.org/trace/bat";
/**
 *     上传头像
 */
const NSString* M_URL_uploadIcon= @"https://www.qianxs.com/mrMoney/mobile/invite/member/uploadMemIcon.html";
/**
 *  提交风险
 */
const NSString* M_URL_risk = @"https://www.qianxs.com/mrMoney/mobile/invite/member/submitRisk.html";

/**
 *  添加银行账号到本地
 */
const NSString* M_URL_appendAssetAccount = @"https://www.qianxs.com/mrMoney/mobile/assetAccount/appendAssetAccount";
/**
 *  同步银行账户
 */
const NSString* M_URL_syncAssetAccount = @"https://www.qianxs.com/mrMoney/mobile/assetAccount/syncAssetAccount";

/**
 *  解除绑定银行卡
 */
const NSString* M_URL_unbindAssetAccount = @"https://www.qianxs.com/mrMoney/mobile/assetAccount/unbindAssetAccount";
/**
 *  活动聊天列表
 */
const NSString* M_URL_listActivity = @"https://www.qianxs.com/mrMoney/mobile/invite/activity/listActivityComment.html";
/**
 *  申请提现
 */
const NSString* M_URL_withdraw = @"https://www.qianxs.com/mrMoney/mobile/invite/withdraw/confirmWithDraw.html";
/**
 *  使用钱宝宝购买
 */
const NSString* M_URL_useBalanceToBuy = @"https://www.qianxs.com/mrMoney/mobile/invite/sdo/useBalanceToBuy.html";

/**
 *  首页查询产品
 */
const NSString* M_URL_queryProduct = @"https://www.qianxs.com/mrMoney/mobile/invite/member/queryAnotherProd.html";
/**
 *  充值订单
 */
const NSString* M_URL_rechargeOrder = @"https://www.qianxs.com/mrMoney/mobile/invite/ysb/initYsbRechargeOrder.html";
//const NSString* M_URL_rechargeOrder = @"https://www.qianxs.com/mrMoney/mobile/invite/sdo/initRechargeOrder.html";
/**
 *  一键签约余额宝
 */
const NSString* M_URL_signAlipay =@"https://www.qianxs.com/mrMoney/mobile/invite/member/ transMoneyToAlipay.html";

/**
 * 认证qq
 */
const NSString* M_URL_qqoauth =@"https://www.qianxs.com/mrMoney/mobile/qqoauth/checkin";
/**
 *  绑定接口
 */
const NSString* M_URL_binding =@"https://www.qianxs.com/mrMoney/mobile/qqoauth/binduser";
/**
 *  分享返还现金
 */
const NSString* M_URL_presentedPrincipal = @"https://www.qianxs.com/mrMoney/mobile/invite/activity/presentedPrincipal";


/**
 *  公用字段
 */
const NSString* M_KEY_REQUESTID=@"RequestId";//请求标识，由客户端产生，客户端唯一
const NSString* M_KEY_MSGTOKEN=@"MsgToken";//信息校验令牌
const NSString* M_KEY_DEVICEID=@"DeviceId";//客户端设备标识
const NSString* M_KEY_APPVERSION=@"AppVersion";//客户端版本号
const NSString* M_VALUE_APPVERSION=@"1.0.0";//客户端版本号
const NSString* M_KEY_DEVICEMODEL=@"DeviceModel";//终端设备的型号信息
const NSString* M_KEY_PLATTYPE=@"PlatType";//系统平台类型
const NSString* M_VALUE_PLATTYPE=@"i";//系统平台类型
const NSString* M_KEY_PLATDESC=@"PlatDesc";//系统平台信息描述,比如ios4.0
const NSString* M_KEY_CHANNELCODE=@"ChannelCode";//推广渠道编号
const NSString* M_VALUE_CHANNELCODE=@"AppStore";//推广渠道编号

const NSString* M_KEY_USERID=@"UserId";//用户唯一标示
const NSString* M_KEY_LOGINNAME=@"LoginName";//用户名或email地址
const NSString* M_KEY_PASSWORD=@"Password";//密码
const NSString* M_KEY_EMAILREGLIMIT=@"EmailRegLimit";//注册用户名限制，只能邮件地址
const NSString* M_KEY_DOWNLOADURL=@"DownloadUrl";//下载地址
const NSString* M_KEY_PRODUCTDISPLAYIMG=@"ProductDisplay";//购物车商品展示图片
const NSString* M_KEY_ISREMEMBERUSER=@"isRememberUserInfo";//是否记录用户信息
const NSString* M_KEY_DEVICETOKEN=@"DeviceToken";//设备deviceToken

  

@implementation MDataInterface
static NSMutableDictionary* commonParams;

+(void) initialize{
	commonParams = [[NSMutableDictionary alloc] init];
	[[self class] initializeCommonParams];
}

+(void)initializeCommonParams{
	CGFloat screenWidth = 320.0f;
	CGFloat screenHeight = 480.0f;
	UIScreen* _screen = [UIScreen mainScreen];
	
	if (isRetina) {
		UIScreenMode* _mode = [_screen currentMode];
		screenWidth = _mode.size.width;
		screenHeight = _mode.size.height;
	}
	
	[commonParams setValuesForKeysWithDictionary:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSString stringWithFormat:@"%.0f*%.0f", screenWidth, screenHeight], @"screensize",
      M_VALUE_APPVERSION,M_KEY_APPVERSION,
      M_VALUE_PLATTYPE,M_KEY_PLATTYPE,
      [NSString stringWithFormat:@"%.0f",[[[UIDevice currentDevice] systemVersion] floatValue]],M_KEY_PLATDESC,
      nil]];
}
// 获取数据字典
+(NSMutableDictionary *)commonParams{
	return commonParams;
}

+(void)setCommonParam:(id)key value:(id)value{
	[commonParams setValue:value forKey:key];
//	[[self class] walkDataInterface];
}

+(id)commonParam:(id) key{
	return [commonParams objectForKey:key];
}

+(void)walkDataInterface{
	NSLog(@"= walkDataInterface =");
	for (id _k in [commonParams allKeys]) {
		NSLog(@"key:<%@>, value:<%@>",_k, [commonParams objectForKey:_k]);
	}
	NSLog(@"= end walkDataInterface =");
}
@end
 
