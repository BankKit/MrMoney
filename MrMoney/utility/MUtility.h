//
//  MUtility.h
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFinanceProductData;
@class UICountingLabel;
@interface MUtility : NSObject
+(NSString *)payName:(NSString *)bankId;
/**
 *  获取设备IP地址
 *
 *  @return ip地址
 */
+ (NSString *)deviceIPAdress;
+(float )expectEarning:(MFinanceProductData *)data;
+(void)setLabelFormat:(UICountingLabel *)label value:(float)value prefix:(NSString *)prefix;


/**
 *  关键字筛选
 *
 *  @param keyword 银行关键字
 *  @param bankId 银行代码
 *
 *  @return 判断银行是否在条件内
 */
+(BOOL)filterKeyword:(NSString *)keyword bankId:(NSString *)bankId;

 
/**
 *  返回筛选内容条件
 *
 *  @return 筛选条件
 */
+(NSDictionary *)filterDict;
+(NSDictionary *)filterFundDict;
+(NSDictionary *)payStyleDict;
+(NSDictionary *)treasureDict;

/**
 *  安全的电话号码
 *
 *  @param phoneNumber 电话号码
 *
 *  @return 返回安全的电话号码
 */
+(NSString *)securePhoneNumber:(NSString *)phoneNumber;

/**
 *  时间间隔
 *
 *  @return float 时间
 */
+(float )getTimeInterval;
/**
 *  当天的秒数
 *
 *  @return 秒数
 */
+(float )getSecond;
/**
 *  返回日期格式的字符串
 *
 *  @param date 日期
 *
 *  @return 日期字符串
 */
+ (NSString *)stringForDate:(NSDate *)date;

+ (NSDate *)dateForString:(NSString *)dateString;

+ (NSString *)dateString:(NSString *)dateStr;

/**
 *  返回日期格式的字符串
 *
 *  @param date 日期
 *  @param format 日期格式
 *
 *  @return 日期字符串
 */
+ (NSDate *)dateFormatter:(NSString *)dateString formatter:(NSString *)formatter;

/**
 *	@brief	压缩图片
 *
 *
 *
 *	@param 	image 	压缩图片
 *	@param 	newSize 	设置压缩的大小
 *
 *	@return	压缩后的图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *	@brief	存储图片
 *
 *
 *
 *	@param 	tempImage 	图片
 *	@param 	imageName 	图片名称
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *	@brief	获得资源
 *
 *
 *
 *	@param 	tempImage 	图片
 *	@param 	imageName 	图片名称
 *
 *	@return	图片路径
 */
+ (NSString *)getImageWithName:(NSString *)imageName;

/**
 *	@brief	给保存的图片命名
 *
 *	@return	图片名称
 */

+(NSString *)getImageName;

@end
