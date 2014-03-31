//
//  MQueryInvestAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-12.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MQueryInvestAction.h"
#import "MMoneyBabyData.h"
@implementation MQueryInvestAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate  onRequestQueryInvestAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_queryInvestState
                                             getParams:l_dict_request
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
    
    NSLog(@" 我的钱宝宝  ------------ %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        

        MMoneyBabyData *money     = [[MMoneyBabyData alloc] init];
 
        money.mReal7Int          = m_dictionaryValueToString([l_dict_response objectForKey:@"Real7Int"]);

        money.mfCyclBal          = m_dictionaryValueToString([l_dict_response objectForKey:@"fCyclBal"]);

        money.mcyclBal          = m_dictionaryValueToString([l_dict_response objectForKey:@"cyclBal"]);
 
        money.mbalance            = m_dictionaryValueToString([l_dict_response objectForKey:@"balance"]);
        money.mcanDrawMoney       = m_dictionaryValueToString([l_dict_response objectForKey:@"canDrawMoney"]);
        money.mcanInvestMoney     = m_dictionaryValueToString([l_dict_response objectForKey:@"canInvestMoney"]);
        money.mcurrentIncomeMoney = m_dictionaryValueToString([l_dict_response objectForKey:@"currentIncomeMoney"]);
        money.mcurrentInvestMoney = m_dictionaryValueToString([l_dict_response objectForKey:@"currentInvestMoney"]);
        money.mdrawMoney          = m_dictionaryValueToString([l_dict_response objectForKey:@"drawMoney"]);
        money.mloadMoney          = m_dictionaryValueToString([l_dict_response objectForKey:@"loadMoney"]);
        money.mofficialBalance    = m_dictionaryValueToString([l_dict_response objectForKey:@"officialBalance"]);
        money.msumIncomeMoney     = m_dictionaryValueToString([l_dict_response objectForKey:@"sumIncomeMoney"]);
        money.msumInvestMoney     = m_dictionaryValueToString([l_dict_response objectForKey:@"sumInvestMoney"]);
        money.mtodayIncome        = m_dictionaryValueToString([l_dict_response objectForKey:@"todayIncome"]);
        money.muserCount          = m_dictionaryValueToString([l_dict_response objectForKey:@"userCount"]);
        money.myestodayIncome     = m_dictionaryValueToString([l_dict_response objectForKey:@"yestodayIncome"]);
        money.msumInvestMoney     = m_dictionaryValueToString([l_dict_response objectForKey:@"sumInvestMoney"]);
        
        money.mQbbAssets        = m_dictionaryValueToString([l_dict_response objectForKey:@"QbbAssets"]);

        money.mQbbPrincipal     = m_dictionaryValueToString([l_dict_response objectForKey:@"QbbPrincipal"]);
          money.mpresentMoney          = m_dictionaryValueToString([l_dict_response objectForKey:@"presentMoney"]);
 
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryInvestSuccess:)]) {
                [m_delegate onResponseQueryInvestSuccess:money];
        }
         
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryInvestFail)]) {
            [m_delegate onResponseQueryInvestFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryInvestFail)]) {
        [m_delegate  onResponseQueryInvestFail];
    }
    m_request = nil;
}

@end
