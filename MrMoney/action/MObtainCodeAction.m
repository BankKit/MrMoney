//
//  MObtainCodeAction.m
//  MrMoney
//
//  Created by xingyong on 14-1-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MObtainCodeAction.h"

@implementation MObtainCodeAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate  onRequestObtainCodeAction]];
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString *)M_URL_ObtainCode
                                             postParams:l_dict_request
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
    
    NSLog(@"=======获取短信验证码=== %@",l_dict_response);
    
    
    if ([[l_dict_response objectForKey:@"result"] intValue]== 1) {
        
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseObtainCodeSuccess)]) {
            [m_delegate  onResponseObtainCodeSuccess];
        }
        
    }else{
        [MActionUtility showAlert:[l_dict_response objectForKey:@"message"]];
         
        return;
         
//        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseObtainCodeFail)]) {
//            [m_delegate onResponseObtainCodeFail];
//        }
        
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseObtainCodeFail)]) {
        [m_delegate  onResponseObtainCodeFail];
    }
    m_request = nil;
}


@end
