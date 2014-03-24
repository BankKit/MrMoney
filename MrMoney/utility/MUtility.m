//
//  MUtility.m
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MUtility.h"
#import "MFinanceProductData.h"
#import "UICountingLabel.h"
#import "MAccountsData.h"
#import "IPAddress.h"
@implementation MUtility

+(NSString *)payName:(NSString *)bankId{
    NSString *bankName = [bankId uppercaseString];
    if ([bankName isEqualToString:@"BOCOM"]) {
        return  @"COMM";
    }else if ([bankName isEqualToString:@"PAB"]) {
        return   @"SZPAB";
    }else if ([bankName isEqualToString:@"BOB"]) {
        return  @"BCCB";
    }
    return bankName;
    
}

+(NSString *)securePhoneNumber:(NSString *)phoneNumber{

    if ([phoneNumber length]> 0) {
        NSRange range = NSMakeRange(3, 4);
        
        return  [phoneNumber stringByReplacingCharactersInRange:range withString:@"****"];
    }
    return phoneNumber;
    
}
+ (NSString *)deviceIPAdress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s",ip_names[1]];
}

+ (NSDate *)dateForString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

+ (NSDate *)dateFormatter:(NSString *)dateString formatter:(NSString *)formatter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatter];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}
+ (NSString *)dateString:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat       = @"yyyyMMdd";
    NSDate *date               = [formatter dateFromString:dateStr];
    
    return    [[self class] stringForDate:date];
}

+ (NSString *)stringForDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+(NSDictionary *)filterDict{
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"filter" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
    
}
+(NSDictionary *)filterFundDict{
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"filterFund" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}
+(NSDictionary *)payStyleDict{
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"payStyle" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}
+(NSDictionary *)treasureDict{
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"treasure" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+(float )expectEarning:(MFinanceProductData *)data {
    
    float value =  ([data.mreturn_rate floatValue]/ (100 * 365)) * [data.minvest_cycle floatValue];
    
    return value/100;
}


+(void)setLabelFormat:(UICountingLabel *)label value:(float)value prefix:(NSString *)prefix{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    label.format = @"%.2f%";
    [label countFrom:value to:value];
    label.formatBlock = ^NSString* (float value)
    {
        NSString* formatted = [formatter stringFromNumber:@((float)value)];
        return [NSString stringWithFormat:@"%@%@",prefix,formatted];
    };
    
}

+(BOOL)filterKeyword:(NSString *)keyword bankId:(NSString *)bankId{
  
    
    if ([bankId isEqualToString:@"ICBC"]
        || [bankId isEqualToString:@"HXB"]
        || [bankId isEqualToString:@"CMBC"]
        || [bankId isEqualToString:@"BOB"]
        || [bankId isEqualToString:@"ALIPAY"]
        ) {
        
        return NO;
    }
//    if ([bankId isEqualToString:@"BOCOM"]){
//        if ([keyword containsString:@"至尊系列"]) {
//            return NO;
//        }else if([bankId isEqualToString:@"BOC"]){
//            if ([keyword containsString:@"专享系列"]) {
//                return NO;
//            }
//        }else if([bankId isEqualToString:@"CMB"]){
//            if ([keyword containsString:@"岁月流金"]||[keyword containsString:@"岁月流金"]) {
//                return NO;
//            }
//        }else if([bankId isEqualToString:@"CGB"]){
//            if ([keyword containsString:@"欢欣股舞"]) {
//                return NO;
//            }
//        }else if([bankId isEqualToString:@"BOS"]){
//            if ([keyword containsString:@"白金系列"]) {
//                return NO;
//            }
//        }else if([bankId isEqualToString:@"SPDB"]){
//            if ([keyword containsString:@"尊享盈计划"]) {
//                return NO;
//            }
//        }else if([bankId isEqualToString:@"PAB"]){
//            if ([keyword containsString:@"私行专享尊贵"]) {
//                return NO;
//            }
//        }else if([bankId isEqualToString:@"NBCB"]){
//            if ([keyword containsString:@"惠财"]||[keyword containsString:@"至尊"]||[keyword containsString:@"专属"]) {
//                return NO;
//            }
//        }
//    }
    
    return YES;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    CGSize oldsize = tempImage.size;
    CGSize newsize;
    if (oldsize.height+oldsize.width>2000) {
        float i = (float)(oldsize.height+oldsize.width)/2000.0f;
        newsize = CGSizeMake(oldsize.width/i, oldsize.height/i);
    }else{
        newsize = oldsize;
    }
//    UIImage *thumbImage = [UIImage KsiThumbImage:tempImage withSize:newsize withMode:KsiThumbImageModeResize];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString* cachessDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [cachessDirectory stringByAppendingPathComponent:imageName];
    
    
    [UIImageJPEGRepresentation(tempImage, 0.2) writeToFile:fullPathToFile atomically:YES];
    
    
    // and then we write it out
    //    [imageData writeToFile:fullPathToFile atomically:NO];
}
+ (NSString *)getImageWithName:(NSString *)imageName{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    return fullPathToFile;
}

+(void)removeImageWithImageName:(NSString *)l_str_imageName{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:l_str_imageName];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = [[NSError alloc] init];
    if ([manager fileExistsAtPath:fullPathToFile]) {
        [manager removeItemAtPath:fullPathToFile error:&error];
    }
}

+(NSString *)getImageName{
    NSDate *date=[NSDate date];
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    NSString *imageName=[formatter stringFromDate: date];
    imageName=[imageName  stringByReplacingOccurrencesOfString:@":" withString:@""];
 
    
    return imageName;
}


+(float )getSecond{
    NSDate * startDate = [NSDate date];;
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |
    NSSecondCalendarUnit | NSDayCalendarUnit  |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
    NSUInteger second = [cps second];
//    NSUInteger day = [cps day];
//    NSUInteger month = [cps month];
//    NSUInteger year = [cps year];
 
    float currentSecond  = (hour * 3600 + minute * 60 + second);
 
    return currentSecond/(24*3600);
    
}
+(float )getTimeInterval{
    NSDate * startDate = [NSDate date];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |
    NSSecondCalendarUnit | NSDayCalendarUnit  |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
    NSUInteger second = [cps second];
 
    
    float currentSecond  = (hour * 3600 + minute * 60 + second);
    
    return currentSecond;
    
}
 
@end
