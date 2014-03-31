//
//  MActionUtility.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MActionUtility.h"
#import "MUserData.h"
#import <netinet/in.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#import <SystemConfiguration/SCNetworkReachability.h>

static UIAlertView *_alertView = nil;

@implementation MActionUtility


+(NSDictionary*)getRequestCommonDict{
    //    NSString *l_str_userId=[QMDataInterface commonParam:QM_KEY_USERID];
    //
    //    NSDictionary *l_dict=[NSDictionary dictionaryWithObjectsAndKeys:
    //                          [[self class] createRequestID],QM_KEY_REQUESTID,
    //                          strOrEmpty(l_str_userId),QM_KEY_USERID,
    //                          nil];
    return nil;
}


+ (NSString*)joinParams:(MutableOrderedDictionary *)getParams{
 
    NSMutableString* _paramList = [[NSMutableString alloc] init];
    
 
    for ( int i = 0; i<[getParams count]; i++ ) {
//        NSArray *sortArray = [[getParams allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        NSString* key = [[getParams allKeys] objectAtIndex:i];
 
        NSString* formatString = nil;
        
        if ( i == 0 ) {
            formatString = @"%@=%@"; //启始位置以?开始
        }else{
            formatString = @"&%@=%@"; //参数之间用&连接
        }
        
        NSString* _appendParamStr = [NSString stringWithFormat:formatString,key,(NSString*)[getParams objectForKey:key]];
        
        [_paramList appendString:_appendParamStr];
        
    }
    
    NSString* resultUrl = [NSString stringWithFormat:@"%@", _paramList];
    
    
    return resultUrl;
}


/**
 *	@brief	所有请求参数
 *
 *
 *
 *	@return	所有请求参数字典
 */
+(NSDictionary*)getRequestAllDict:(NSDictionary*)l_dict_other{
    
 
    //加入其他参数
    MutableOrderedDictionary *l_dict_noSign= [MutableOrderedDictionary dictionary];
    
   
    if (l_dict_other!=nil) {
        for (NSString *l_key in [l_dict_other allKeys]) {
            [l_dict_noSign setObject:[l_dict_other objectForKey:l_key] forKey:l_key];
        }
    }
    
    //组装签名
    NSString *l_str_token = [[self class] creatMsgTokenStr:l_dict_noSign];
    //创建请求参数字典
    
    MutableOrderedDictionary *l_dict=[MutableOrderedDictionary dictionaryWithDictionary:l_dict_noSign];
    
    [l_dict setObject:l_str_token forKey:KSIGN_BODY];
    
//    NSLog(@"l_dict ----------- %@",l_dict);
    
    return l_dict;
}

+(NSString*)creatMsgTokenStr:(MutableOrderedDictionary*)keyDic{
//    NSLog(@"keyDic --有序的--------- %@",keyDic);
    NSString *string = [[self  class] joinParams:keyDic];
    
    NSMutableString *keyStr = [NSMutableString stringWithString:string];
 
    [keyStr appendFormat:@"%@",KLOCAL_KEY];
    
    NSLog(@"signBody ：：： %@",keyStr);
    
    return [MSMD5(keyStr) uppercaseString];
}



+ (void)showAlert:(NSString *)message{
    [[self class] showAlert:KEMPTY_STR message:message delegate:nil cancelButtonTitle:KCONFIRM_STR otherButtonTitles:nil];
 
}
+ (void)showAlert:(NSString *)aTitle message:(NSString *)aMessage delegate:(id<UIAlertViewDelegate>)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    if (_alertView.isVisible) {
        return;
    }
    if (_alertView != nil) {
         _alertView = nil;
    }
    _alertView = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:aDelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (otherButtonTitles != nil) {
        va_list args;
        va_start(args, otherButtonTitles);
        NSString* arg = nil;
        [_alertView addButtonWithTitle:otherButtonTitles];
        while ( ( arg = va_arg( args, NSString*) ) != nil ) {
            [_alertView addButtonWithTitle:arg];
        }
        va_end(args);
    }
    [_alertView show];
}

+ (NSString *) macAddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
/**
 *	@brief	判断是否有网络
 *	@return
 */
+(BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

/**
 *	@brief 判断请求JSON是否成功
 *	失败时通知请求失败
 */
+(BOOL)isRequestJSONSuccess:(NSDictionary*)jsonDict{
    
    BOOL isSuccess = YES;
	if (jsonDict==nil) { // 网络错误
        
        if (![[self class] isNetworkReachable]){
            [[self class] showAlert:@"提示"
                               message:@"网络连接失败，请确保设备已经连网"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
        }else{
            [[self class] showAlert:@"提示"
                               message:@"网络连接失败，请稍后再试"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
            }
        isSuccess = NO;
	}else{
 
        NSString *resultCode = [jsonDict objectForKey:@"returnCode"];
 
        if ([resultCode intValue] != 0 ) {
            
 
            [[self class] showAlert:KEMPTY_STR message:@"服务器异常" delegate:nil cancelButtonTitle:KCONFIRM_STR otherButtonTitles:nil];
            isSuccess = NO;
        }
        
    }
	return isSuccess;
}

/**
 *	@brief 判断请求JSON是否成功
 *	失败时通知请求失败
 */
+(BOOL)isRequestNoAlertJSONSuccess:(NSDictionary*)jsonDict{
    
    BOOL isSuccess = YES;
//	if (jsonDict==nil) { // 网络错误
//        
//        isSuccess = NO;
//	}else{
//        QMResultData* _data = [[[QMResultData alloc] init] autorelease];
//        
//        _data.mresultCode=[jsonDict objectForKey:@"ResultCode"];
//        _data.mresultMsg=[jsonDict objectForKey:@"ResultMsg"];
//        
//        if (![_data.mresultCode isEqualToString:@"0"]) {
//            isSuccess = NO;
//        }
//    }
	return isSuccess;
}

 


//
///**
// *	@brief	拼接字符串
// *
// *	商品规格字符串,xx|xx|xx
// *
// *	@param 	l_arr_products 	商品数组
// */
//+(NSString*)getProductDetailCodeStr:(NSArray *)l_arr_products{
//    NSMutableString *l_str=[NSMutableString stringWithCapacity:0];
//    for (int i=0; i<[l_arr_products count]; i++) {
//        QMShoppingCartItemData *l_data_product=[l_arr_products objectAtIndex:i];
//        if (i==0) {
//            [l_str appendString:l_data_product.mdetailCode];
//        }else{
//            [l_str appendFormat:@"|%@",l_data_product.mdetailCode];
//        }
//    }
//    NSLog(@"商品规格字符串----%@", l_str);
//    return l_str;
//}
//
+ (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    
    NSInteger sectionRows = [tableView numberOfRowsInSection:indexPath.section];
	NSInteger row = indexPath.row;
    UIImage *background = nil;
    
	if (row == 0 && sectionRows == 1)
		background = [UIImage imageNamed:@"ZHCellSingleNormal"];
	else if (row == 0)
		background = [UIImage imageNamed:@"ZHCellTopNormal"];
	else if (row == sectionRows - 1)
        background = [UIImage imageNamed:@"ZHCellBottomNormal"];
	else
		background = [UIImage imageNamed:@"ZHCellMiddleNormal"];
    
    
    return [background stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

+ (UIImage *)cellSelectedBackgroundViewForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    
    NSInteger sectionRows = [tableView numberOfRowsInSection:indexPath.section];
	NSInteger row = indexPath.row;
    UIImage *background = nil;
    
	if (row == 0 && sectionRows == 1)
		background = [UIImage imageNamed:@"ZHCellSingleHighlight"];
	else if (row == 0)
		background = [UIImage imageNamed:@"ZHCellTopHighlight"];
	else if (row == sectionRows - 1)
        background = [UIImage imageNamed:@"ZHCellBottomHighlight"];
	else
		background = [UIImage imageNamed:@"ZHCellMiddleHighlight"];
    
    
    return [background stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}


+ (void)setObject:(id)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)getObjectForKey:(NSString*)key{
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
}
+(void)removeObjectForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+(void)recoverUserDataFromDB{
    MUserData *l_data=[[MUserData allDbObjects] objectAtIndex:0];
    [MDataInterface setCommonParam:@"kmobile" value:l_data.mmobile];
    [MDataInterface setCommonParam:@"mid" value:l_data.mmid];
 
}

+(void)userLogout{
    for (MUserData *l_data in [MUserData allDbObjects]) {
        if ([l_data removeFromDb]) {
             [MDataInterface setCommonParam:@"mid" value:@""];
        }
    }
   


}
 

@end
