//
//  MRegistAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MRegistAction.h"

@implementation MRegistAction
@synthesize m_delegate_userRegister;
-(void)dealloc{
    m_delegate_userRegister = nil;
    [m_request_userRegister clearDelegatesAndCancel];
}

/**
 *	@brief	发出请求
 *
 *	请求用户注册
 */
-(void)requestUserRegister{
    if (m_request_userRegister!=nil && [m_request_userRegister isFinished]) {
        return;
    }
    
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate_userRegister onRequestUserRegisterAction]];
    
    //  NSString *l_str_url=[MActionUtility getUserRquestURLWithMethod:(NSString*)M_URL_Regist];
    
    m_request_userRegister=[[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_Regist
                                                      postParams:l_dict_request
                                                          object:self
                                                onFinishedAction:@selector(onRequestUserRegisterFinishResponse:)
                                                  onFailedAction:@selector(onRequestUserRegisterFailResponse:)];
    [m_request_userRegister startAsynchronous];
}

/**
 *	@brief	请求成功
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserRegisterFinishResponse:(ASIHTTPRequest*)request{
    NSString *str_response=[request responseString];
    
    
    NSDictionary *l_dict_response = [str_response objectFromJSONString];
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        if ([[l_dict_response objectForKey:@"result"] intValue]== 0) {
            
            if ([(UIViewController*)m_delegate_userRegister  respondsToSelector:@selector(onResponseUserRegisterSuccess)]) {
                
                [m_delegate_userRegister onResponseUserRegisterSuccess];
            }
        }else{
            [MActionUtility showAlert:[l_dict_response objectForKey:@"message"]];
            return;
        }
    }
    
    
    m_request_userRegister=nil;
}

/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserRegisterFailResponse:(ASIHTTPRequest*)request{
    if ([(UIViewController*)m_delegate_userRegister respondsToSelector:@selector(onResponseUserRegisterFail)]) {
        [m_delegate_userRegister onResponseUserRegisterFail];
    }
    m_request_userRegister=nil;
}

@end
