//
//  MAccountsData.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MAccountsData : MBaseData
/**
 *  此账户在mrmoney中的id
 */
@property(nonatomic,strong) NSString *maid;
/**
 *  银行id
 */
@property(nonatomic,strong) NSString *mbankId;
/**
 *  账户id
 */
@property(nonatomic,strong) NSString *mbankCardNo;
/**
 *  币种及余额
 */
@property(nonatomic,strong) NSString *mcurrency;

/**
 *  币种及余额 美元
 */
@property(nonatomic,strong) NSString *mdollar;
/**
 *  户名
 */
@property(nonatomic,strong) NSString *mname;
/**
 *  开户行，具体到支行
 */
@property(nonatomic,strong) NSString *mopeningBank;
/**
 *  开户地址编号
 */
@property(nonatomic,strong) NSString *maddress;
/**
 *  网银查询密码
 */
@property(nonatomic,strong) NSString *mqueryPwd;
/**
 *  网银登录名
 */
@property(nonatomic,strong) NSString *mnickName;
/**
 *  身份证号
 */
@property(nonatomic,strong) NSString *midCardNum;



/**
 *  卡号
 */
@property(nonatomic,strong) NSString *mAccNum;
/**
 *  币种及余额 array
 */
@property(nonatomic,strong) NSString *mBalance;

/**
 *  币种及余额 array
 */
@property(nonatomic,strong) NSArray *mProducts;





@end
