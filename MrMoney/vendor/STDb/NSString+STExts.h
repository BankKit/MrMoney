/*
 * NSString+STExts.h
 * NSString+STExts
 *
 * version 1.0-beta create 9-Aug-2013
 *
 * https://github.com/yanglishuan/Common+Utils
 *
 * BSD license follows (http://www.opensource.org/licenses/bsd-license.php)
 *
 * Copyright (c) 2013-2015 lishuan yang All Rights Reserved.
 *
 * if u find anything wrong or bug, please email to 2008.yls@163.com
 * or contact me on QQ 603291699, i will appreciate it.
 *
 */

#import <Foundation/Foundation.h>

@interface NSString (STExts)

////////////////////////////// 加密、解密  /////////////////////////////////

/** md5 */
- (NSString *)md5;

/** base64 */
- (NSString *)base64;
- (NSString *)stringFromBase64;

/** aes256 */
- (NSString *)encryptWithKey:(NSString *)key;
- (NSString *)decryptWithKey:(NSString *)key;

///////////////////////////// 正则表达式相关  ///////////////////////////////

/** 邮箱验证 */
- (BOOL)isEmail;

/** 手机号码验证 */
- (BOOL)isPhoneNum;

/** 车牌号验证 */
- (BOOL)isCarNo;

/** 网址验证 */
- (BOOL)isUrl;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

@end



