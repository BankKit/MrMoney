//
//  MStringUtility.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MStringUtility : NSObject
 
/**
 去掉首尾空格
 @param str 字符串
 @returns 去掉首尾空格的字符串
 */
+(NSString*)stripWhiteSpace:(NSString*)str;
 
/**
 *  返回64位的字符串
 *
 *  @param data NSData
 *
 *  @return 64位的字符串
 */
+ (NSString *)stringWithBase64ForData:(NSData *)data;

/**
 *  返回label的size
 *
 *  @param input 内容
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return size
 */
+(CGSize )getStringSize:(NSString*)input font:(UIFont*)font width:(CGFloat)width;
/**
 根据指定的字体，和宽度计算字符串的高度
 @param input 字符串
 @param font  使用的字体
 @param width 宽度
 */
+(CGFloat)getStringHight:(NSString*)input font:(UIFont*)font width:(CGFloat)width;

/**
 根据指定字符串进行base64编码
 @param input 字符串
 */
+(NSString*)encodeBase64:(NSString*)input;
/**
 *  在字符串中插入字符
 *
 *  @param str 长度大约4的字符串
 *
 *  @return 衔接后的字符串
 */
+ (NSString *)joinString:(float)floatValue;

 
/**
 *  格式化时间
 *
 *  @param str 时间字符串
 *
 *  @return 时间格式的字符串
 */
+ (NSString *)formatterDateString:(NSString *)str;

/**
 判断字符串是否符合手机号格式。
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+(BOOL)isPhoneNum:(NSString *)input;


@end
/**
 *  判断用户是否登录
 *
 */
extern BOOL isUserLogin();
/*
 如果字符串==nil 返回 @"" 否则返回 str
 */
extern BOOL stringIsEmpty(NSString* str);
extern NSString* strOrEmpty(NSString *str);
/*
 返回当前时间
 */
extern NSString* nowTimestamp(void);
extern NSString* MSMD5(NSString *str);
extern NSString* stripWhiteSpace(NSString *str);
extern NSString* CCSSHA1( NSString *str );

extern NSString* userMid(void);
extern NSString* formatStr(NSString *str);
extern NSString* formatValue(float value);
extern NSString* formatCardNo(NSString *str);
extern NSString* formatIntValue(double value,int fractionDigits);
extern NSDate  * zoneDate(NSDate *date);

extern NSString* bankName(NSString *bankName);
extern UIImage* bankLogoImage(NSString *bankName);
 
