//
//  MUserData.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MUserData : MBaseData

/**
 *  手机
 */
@property(nonatomic,strong) NSString *mmobile;
/**
 *  邮箱
 */
@property(nonatomic,strong) NSString *memail;
/**
 *  是否有权限发起活动
 */
@property(nonatomic,strong) NSString *mcanInvite;
/**
 *  用户头像路径
 */
@property(nonatomic,strong) NSString *miconPath;
/**
 *  是否自动注册用户，且第一次登录
 */
@property(nonatomic,strong) NSString *misFirst;
/**
 *  用户真实姓名
 */
@property(nonatomic,strong) NSString *mrealName;
/**
 *  用户id
 */
@property(nonatomic,strong) NSString *mmid;
/**
 *  注册时间
 */
@property(nonatomic,strong) NSString *mregisterTime;

@property(nonatomic,strong) NSString *msessionId;
/**
 *  风险评估
 */
@property(nonatomic,strong) NSString *mriskEvalue;



@end
