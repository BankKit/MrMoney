//
//  MActionUtility.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MActionUtility : NSObject

+ (void)showAlert:(NSString *)message;

+ (void)showAlert:(NSString *)aTitle message:(NSString *)aMessage delegate:(id<UIAlertViewDelegate>)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;//显示alert

/**
 *	@brief	mac地址字符串
 *
 *	mac地址字符串作为requestId
 *
 *	@return	mac地址字符串
 */
+ (NSString *) macAddress;

/**
 *	@brief	签名
 *
 *	组装令牌
 *
 *	@param 	keyDic 	参数字典
 *
 *	@return	签名字符串
 */
+(NSString*)creatMsgTokenStr:(NSDictionary*)keyDic;

/**
 *	@brief	公共请求参数
 *
 *	requestId \ userId
 *
 *	@return	公共请求参数字典
 */
+(NSDictionary*)getRequestCommonDict;

/**
 *	@brief	所有请求参数
 *
 *
 *
 *	@return	所有请求参数字典
 */
+(NSDictionary*)getRequestAllDict:(NSDictionary*)l_dict_other;

/**
 *	@brief	判断是否有网络
 *	@return
 */
+(BOOL)isNetworkReachable;

/**
 *	@brief 判断请求JSON是否成功
 *	失败时通知请求失败
 */
+(BOOL)isRequestJSONSuccess:(NSDictionary*)jsonDict;

/**
 *	@brief 判断请求JSON是否成功
 *	失败时通知请求失败
 */
+(BOOL)isRequestNoAlertJSONSuccess:(NSDictionary*)jsonDict;
  
/**
 *	@brief	初始化userDefault 并赋值
 *
 *
 *	@param 	value
 *	@param 	key
 */
+ (void)setObject:(id)value  forKey:(NSString*)key;

+(id)getObjectForKey:(NSString*)key;

+(void)removeObjectForKey:(NSString*)key;

/**
 * 设置用户mid 到 全局的字典中
 */
+(void)recoverUserDataFromDB;

/**
 *  注销登录
 */
+(void)userLogout;

+ (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
+ (UIImage *)cellSelectedBackgroundViewForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end
