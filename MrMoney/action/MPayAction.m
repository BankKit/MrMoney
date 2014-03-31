//
//  MPayAction.m
//  MrMoney
//
//  Created by xingyong on 14-1-9.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MPayAction.h"

@implementation MPayAction

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
    
    NSDictionary *l_dict_request=[m_delegate  onRequestPayAction];
    
//    
//    NSString *pay_url = [NSString stringWithFormat:
//                         @"%@?Name=%@&Version=%@&Charset=%@&MsgSender=%@&SendTime=%@&OrderNo=%@&OrderAmount=%@&OrderTime=%@&PageUrl=%@&NotifyUrl=%@&ProductName=%@&BuyerContact=%@&BuyerIp=%@&SignType=%@&Ext1=%@&SignMsg=%@&PayType=%@&PayChannel=%@&InstCode=%@",
//                         (NSString *)M_URL_Pay,
//                         strOrEmpty( [l_dict_request objectForKey:@"Name"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"Version"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"Charset"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"MsgSender"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"SendTime"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"OrderNo"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"OrderAmount"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"OrderTime"]),
//                         
//                         strOrEmpty( [l_dict_request objectForKey:@"PageUrl"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"NotifyUrl"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"ProductName"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"BuyerContact"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"BuyerIp"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"SignType"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"Ext1"]),
//                         
//                         strOrEmpty( [l_dict_request objectForKey:@"SignMsg"]),
//                         
//                         strOrEmpty( [l_dict_request objectForKey:@"PayType"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"PayChannel"]),
//                         strOrEmpty( [l_dict_request objectForKey:@"InstCode"])
//                         ];
    
    
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_Pay
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
    
    DLog(@"支付-----  %@",l_str_response);
    //    DLog(@"支付-----  %@",        [l_dict_response objectForKey:@"message"]);
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponsePaySuccess)]) {
            [m_delegate onResponsePaySuccess];
        }
        
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponsePayFail)]) {
            [m_delegate onResponsePayFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponsePayFail)]) {
        [m_delegate  onResponsePayFail];
    }
    m_request = nil;
}


@end
