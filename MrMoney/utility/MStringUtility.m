//
//  MStringUtility.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MStringUtility.h"
#import "MUserData.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "NSString+MCategory.h"

const NSString* REG_POST = @"^[1-9][0-9]{5}$";
const NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
const NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$";
const NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";
@implementation MStringUtility
 
+(BOOL)isPhoneNum:(NSString *)input{
    if ([input length] == 0) {
        
        return NO;
        
    }
     
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:input];
    
    if (!isMatch) {
 
        return NO;
        
    }
     
    return YES;
}


/**
 去掉首尾空格
 @param str 字符串
 @returns 去掉首尾空格的字符串
 */
+(NSString*)stripWhiteSpace:(NSString*)str{

    return  [str stringByReplacingOccurrencesOfString:@" " withString:@""];

}
 
+ (NSString *)stringWithBase64ForData:(NSData *)data {
    
    if (data == nil) return nil;
    
    const uint8_t* input = [data bytes];
    NSUInteger length = [data length];
    
    NSUInteger bufferSize = ((length + 2) / 3) * 4;
    NSMutableData* buffer = [NSMutableData dataWithLength:bufferSize];
    
    uint8_t* output = [buffer mutableBytes];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    NSString *result = [[NSString alloc] initWithData:buffer
                                             encoding:NSASCIIStringEncoding];
    return result;
}

+(CGSize )getStringSize:(NSString*)input font:(UIFont*)font width:(CGFloat)width{
    if (input == nil || font == nil || width <= 0) {
        return CGSizeMake(0., 0.);
    }
    
    CGSize size ;
    if (IsIOS7) {
        size  = [strOrEmpty(input) boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }else {
        size = [strOrEmpty(input) sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
	return size;
}


+(CGFloat)getStringHight:(NSString*)input font:(UIFont*)font width:(CGFloat)width
{
    if (input == nil || font == nil || width <= 0) {
        return 0.0f;
    }
    
    CGSize size ;
    if (IsIOS7) {
        size  = [strOrEmpty(input) boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }else {
        size = [strOrEmpty(input) sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
	return size.height;
}

+(NSString*)encodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String ;
}

+ (NSString *)joinString:(float)floatValue{
    NSString *str =  [NSString stringWithFormat:@"%.0f",floatValue];
    
    NSMutableString *string=[NSMutableString stringWithString:str];
    
    if([string length] > 6){
        
        int length = [string length] - 3;
        
        [string insertString:@"," atIndex:length];
        
        int length2 = [string length] - 7;
        
        [string insertString:@"," atIndex:length2];
        
        return [NSString stringWithFormat:@"￥%@",string];
        
        
    }else  if ([string length]>3) {
        
        int length = [string length] - 3;
        
        [string insertString:@"," atIndex:length];
        
        return [NSString stringWithFormat:@"￥%@",string];
        
    }else{
        return  [NSString stringWithFormat:@"￥%@",string];
    }
    
    return nil;
    
}

+ (NSString *)formatterDateString:(NSString *)str{
    
    NSString *year  = [str substringToIndex:4];
    
    NSString *month = [str substringWithRange:NSMakeRange(4,2)];
    
    NSString *day   = [str substringWithRange:NSMakeRange(6,2)];
    
    
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}


@end

/*
 字符串是否没有内容
 */
inline BOOL stringIsEmpty(NSString* str){
	BOOL ret=NO;
	if(str==nil){
		ret=YES;
	}else{
		NSString * temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if([temp length]<1){
			ret=YES;
		}
	}
	return ret;
}

inline NSString* strOrEmpty(NSString* str){
	return (str==nil?@"":str);
}

inline NSString* stripWhiteSpace(NSString *str){
	/* 去掉首尾空格
	 */
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/*
 返回当前时间
 */
NSString* nowTimestamp(void){
	NSString* format=@"yyyyMMddHHmmss";
	assert(format!=nil);
	NSDate* nowDate=[NSDate date];
	NSDateFormatter* dateFormater=[[NSDateFormatter alloc] init];
	[dateFormater setDateFormat:format];
	[dateFormater stringFromDate:nowDate];
	NSString* timestamp=[[dateFormater stringFromDate:nowDate] copy];
    
	return timestamp;
}

NSString* MSMD5( NSString *str ) {
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [[NSString
			 stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1],
			 result[2], result[3],
			 result[4], result[5],
			 result[6], result[7],
			 result[8], result[9],
			 result[10], result[11],
			 result[12], result[13],
			 result[14], result[15]
			 ] lowercaseString];
}

NSString* CCSSHA1( NSString *str ){
    const char *cStr = [str cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data=[NSData dataWithBytes:cStr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *output=[NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}
extern NSString* userMid(void){
    NSString *mid = [MDataInterface commonParam:@"mid"];
    
    if (![strOrEmpty(mid) isEqualToString:KEMPTY_STR]) {
        return strOrEmpty(mid);
    }
    
    return nil;
}

inline BOOL isUserLogin(){
    
    if ([[MUserData allDbObjects] count]==0) {
        return NO;
    }
    return YES;
}

NSString* formatStr(NSString *str){
    float value =  [strOrEmpty(str) floatValue]/100;
    
    return STRING_FORMAT(@"%.2f",value);
}
NSString* formatValue(float value){
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    formatter.minimumFractionDigits = 3;

    NSString *formatted = [formatter stringFromNumber:@((float)value)];
    
    NSString *l_str =  [formatted substringFromIndex:1];
    
    return [l_str substringToIndex:[l_str length]-1];
}
NSString* formatIntValue(double value,int fractionDigits){
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
  
    formatter.minimumFractionDigits = fractionDigits + 1;
    
    NSString *formatted = [formatter stringFromNumber:@((double)value)];
    
    NSString *l_str =  [formatted substringFromIndex:1];
 
    return [l_str substringToIndex:[l_str length]-1];
     
}

NSString* formatCardNo(NSString *str){
    
    NSString *cardNo  = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([cardNo containsString:@"@"] || [MStringUtility isPhoneNum:cardNo]) {
        return cardNo;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    int length = [cardNo length];
    
    int remainder = length % 4;
    
    NSString *lastStr = [cardNo substringFromIndex: length - remainder];
    
    for (int i = 0; i< length- remainder ; i +=4) {
        NSRange range = NSMakeRange(i, 4);
        
        NSString *m_string = [cardNo substringWithRange:range];
        
        [array addObject:m_string];
    }
    
    [array addObject:lastStr];
    
    NSString *string = [array componentsJoinedByString:@" "];
    
    return string;
}
NSDate  * zoneDate(NSDate *date){
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    return  [date dateByAddingTimeInterval:interval];
}

NSString* bankName(NSString *bankName){
    
    return strOrEmpty([KBANK_DICT objectForKey:[bankName lowercaseString]]);

}

UIImage* bankLogoImage(NSString *bankName){
    
    NSString *name = STRING_FORMAT(@"logo_%@",strOrEmpty([bankName lowercaseString]));
    
    return PNGIMAGE(name);
}


