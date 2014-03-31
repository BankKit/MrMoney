//
//  MAuthCode.m
//  MrMoney
//
//  Created by xingyong on 13-12-11.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MAuthCodeAction.h"
#import "MAuthCodeData.h"
#import "GTMBase64.h"
@implementation MAuthCodeAction

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
    
    NSDictionary *l_dict_request = [m_delegate  onRequestAuthCodeAction];
    
    
    NSString *code_url = [NSString stringWithFormat:@"%@?%@_%@",M_URL_GetAuthCode,
                          [l_dict_request  objectForKey:@"bankCode"],
                          [l_dict_request  objectForKey:@"channel"]];
    
    NSLog(@"code_url--------- %@",code_url);
    
    
    m_request  = [[KDATAWORLD httpEngine] buildDistributeRequest:(NSString *)code_url
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
  
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
         DLog(@"获取验证码------------ %@",l_dict_response);
        MAuthCodeData *code = [[MAuthCodeData alloc] init];
        code.mviewId = m_dictionaryValueToString([l_dict_response objectForKey:@"viewId"]);
        code.maccessId =m_dictionaryValueToString([l_dict_response objectForKey:@"accessId"]);
        NSData *imgData = [GTMBase64 decodeString:[l_dict_response objectForKey:@"img"]];
        
 
         code.mimg =  [UIImage imageWithData:imgData];
        
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseAuthCodeSuccess:)]) {
              
            [m_delegate  onResponseAuthCodeSuccess:code];
        }
        
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseAuthCodeFail)]) {
            [m_delegate onResponseAuthCodeFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseAuthCodeFail)]) {
        [m_delegate  onResponseAuthCodeFail];
    }
    m_request = nil;
}

@end

