//
//  MQueryAccountAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-13.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MQueryAccountAction.h"
#import "MAccountsData.h"
@implementation MQueryAccountAction

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
    
    NSDictionary *l_dict_request =[MActionUtility getRequestAllDict:[m_delegate  onRequestQueryAccountAction]];
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_queryAssetAccount
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
    
    DLog(@"关联账户 ----------- %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray array];
        
        NSArray *docsArray = [l_dict_response objectForKey:@"accounts"];
        
        
        for (NSDictionary *l_dict_account in docsArray) {
            MAccountsData *account = [[MAccountsData alloc] init];

            account.mbankCardNo    = [l_dict_account objectForKey:@"bankCardNo"];
            account.mbankId        = [l_dict_account objectForKey:@"bankId"];
            account.mname          = [l_dict_account objectForKey:@"name"];
            account.mnickName      = [l_dict_account objectForKey:@"nickName"];
            account.maddress       = [l_dict_account objectForKey:@"address"];
            account.maid           = [l_dict_account objectForKey:@"aid"];
            account.mopeningBank   = [l_dict_account objectForKey:@"openingBank"];
            account.mqueryPwd      = [l_dict_account objectForKey:@"queryPWD"];
            NSArray *l_array       = [l_dict_account objectForKey:@"currency"];
            
            account.mcurrency      = m_dictionaryValueToString([[l_array safeObjectAtIndex:0] objectForKey:@"balance"]);
            if ([l_array count] > 1) {
                account.mdollar        = m_dictionaryValueToString([[l_array safeObjectAtIndex:1] objectForKey:@"balance"]);
            }
 
            [l_array_response addObject:account];
        }
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryAccountSuccess:)]) {
            
            [m_delegate onResponseQueryAccountSuccess:l_array_response];
        }
        
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryAccountFail)]) {
            [m_delegate onResponseQueryAccountFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQueryAccountFail)]) {
        [m_delegate  onResponseQueryAccountFail];
    }
    m_request = nil;
}

@end
