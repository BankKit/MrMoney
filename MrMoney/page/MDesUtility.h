//
//  DesUtil.h
//  Author:spring sky
//  QQ:840950105
//  Email:vipa1888@163.com
//

#import <Foundation/Foundation.h>

@interface MDesUtility : NSObject
/**
 DES加密
 */
//+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString*)encrypt:(NSString*)plainText;

/**
 DES解密
 */
//+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString*)decrypt:(NSString*)encryptText;


@end
