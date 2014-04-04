//
//  DesUtil.h
//  Author:spring sky
//  QQ:840950105
//  Email:vipa1888@163.com
//

#import <Foundation/Foundation.h>

@interface DesUtil : NSObject
/**
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 DES解密
 */
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;



@end
