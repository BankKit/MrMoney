//
//  MQueryProductAction.m
//  MrMoney
//
//  Created by xingyong on 14-3-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MQueryProductAction.h"
#import "MMoneyBabyData.h"
@implementation MQueryProductAction

@synthesize m_delegate;

-(void)dealloc{
    m_delegate  = nil;
    [m_request  clearDelegatesAndCancel];
}

/**
 *	@brief	发出请求
 *
 *	请求用户登陆
 */
-(void)requestAction{
    if (m_request !=nil && [m_request  isFinished]) {
        return;
    }
    
//    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate onRequestQueryProductAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_queryProduct
                                            postParams:nil
                                                object:self
                                      onFinishedAction:@selector(onRequestFinishResponse:)
                                        onFailedAction:@selector(onRequestFailResponse:)];
    
    
    [m_request  startAsynchronous];
}

/**
 *	@brief	请求成功
 *
 *	回调函数
 *	@param 	request 	请求对象
 */
-(void)onRequestFinishResponse:(ASIHTTPRequest*)request{
    NSString *l_str_response=[request responseString];
    
    NSDictionary *l_dict_response=[l_str_response objectFromJSONString];
    
    NSLog(@"首页产品查询 -----  %@",l_dict_response);

    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_star = [NSMutableArray array];
        NSMutableArray *l_array_internet = [NSMutableArray array];
        
        NSArray *starArray = [l_dict_response objectForKey:@"starProducts"];
        
        NSArray *internetArray = [l_dict_response objectForKey:@"internetProducts"];
        
        MMoneyBabyData *money = [[MMoneyBabyData alloc] init];
        
         money.mjiashiDate         = m_dictionaryValueToString([l_dict_response objectForKey:@"jiashiDate"]);
         money.mjiashiReturnRate   = m_dictionaryValueToString([l_dict_response objectForKey:@"jiashiReturnRate"]);
        
          
        for (NSDictionary *starDict in starArray) {
           
            MStarData *star = [[MStarData alloc] init];
            star.mstar_bankId      = m_dictionaryValueToString([starDict objectForKey:@"star_bankId"]);
            star.mstar_investCycle = m_dictionaryValueToString([starDict objectForKey:@"star_investCycle"]);
            star.mstar_multiple    = m_dictionaryValueToString([starDict objectForKey:@"star_multiple"]);
            star.mstar_productName = m_dictionaryValueToString([starDict objectForKey:@"star_productName"]);
            star.mstar_returnRate  = m_dictionaryValueToString([starDict objectForKey:@"star_returnRate"]);
            star.mstar_pid         = m_dictionaryValueToString([starDict objectForKey:@"star_pid"]);
            
            [l_array_star addObject:star];
        }
        
        for (NSDictionary *l_dict in internetArray) {
            
            MInternetData *internet = [[MInternetData alloc] init];
            
            internet.me_returnRate  = m_dictionaryValueToString([l_dict objectForKey:@"e_returnRate"]);
            internet.me_productName = m_dictionaryValueToString([l_dict objectForKey:@"e_productName"]);
            internet.me_bankId      = m_dictionaryValueToString([l_dict objectForKey:@"e_bankId"]);
            internet.me_investCycle = m_dictionaryValueToString([l_dict objectForKey:@"e_investCycle"]);
            internet.me_pid         = m_dictionaryValueToString([l_dict objectForKey:@"e_pid"]);
    
            [l_array_internet addObject:internet];
        }
        
        money.mstartArray = l_array_star;
        money.minternetArray = l_array_internet;
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryProductSuccess:)]) {
            
            [m_delegate onResponseQueryProductSuccess:money];
        }
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryProductFail)]) {
            [m_delegate onResponseQueryProductFail];
        }
        
    }
    m_request = nil;

}

/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestFailResponse:(ASIHTTPRequest*)request{
    
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryProductFail)]) {
        [m_delegate  onResponseQueryProductFail];
    }
    m_request = nil;
}


@end
