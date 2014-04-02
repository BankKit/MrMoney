//
//  MFeedbackAction.m
//  MrMoney
//
//  Created by xingyong on 14-3-23.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFeedbackAction.h"

@implementation MFeedbackAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate onRequestFeedbackAction]];
    
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:[MActionUtility getURL:(NSString*)M_URL_presentedPrincipal]
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
    
    DLog(@"--- 分享返还现金 ---  %@",l_dict_response);
    
    DLog(@"-------------------------------%@ \n\n",[l_dict_response objectForKey:@"message"]);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        
        
                 
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFeedbackActionSuccess)]) {
            
            [m_delegate onResponseFeedbackActionSuccess];
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFeedbackActionFail)]) {
            [m_delegate onResponseFeedbackActionFail];
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
    
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFeedbackActionFail)]) {
        [m_delegate  onResponseFeedbackActionFail];
    }
    m_request = nil;
}

@end
