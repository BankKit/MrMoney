//
//  MBindingAction.m
//  MrMoney
//
//  Created by xingyong on 14-3-21.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBindingAction.h"
#import "MUserData.h"
@implementation MBindingAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate onRequestBindingAction]];
    
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_binding
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
    
    DLog(@"一 qq绑定 --2035296092---  %@",l_dict_response);
    
    NSLog(@"-------------------------------%@ \n\n",[l_dict_response objectForKey:@"message"]);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        
        
        MUserData *user = [[MUserData alloc] init];
        
        user.mcanInvite    = m_dictionaryValueToString([l_dict_response objectForKey:@"canInvite"]);
        user.memail        = m_dictionaryValueToString([l_dict_response objectForKey:@"email"]);
        user.miconPath     = m_dictionaryValueToString([l_dict_response objectForKey:@"iconPath"]);
        user.misFirst      = m_dictionaryValueToString([l_dict_response objectForKey:@"isFirst"]);
        user.mmid          = m_dictionaryValueToString([l_dict_response objectForKey:@"mid"]);
        user.mrealName     = m_dictionaryValueToString([l_dict_response objectForKey:@"realName"]);
        user.mregisterTime = m_dictionaryValueToString([l_dict_response objectForKey:@"isFirst"]);
        user.mmobile       = m_dictionaryValueToString([l_dict_response objectForKey:@"mobile"]);
        user.mriskEvalue   = m_dictionaryValueToString(([l_dict_response objectForKey:@"riskEvalue"]));
        user.msessionId    = m_dictionaryValueToString(([l_dict_response objectForKey:@"sessionId"]));
        
        [MDataInterface setCommonParam:@"kmobile" value:user.mmobile];
        [MDataInterface setCommonParam:@"mid" value:user.mmid];
        
        [user insertToDb];
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseBindingActionSuccess)]) {
            
            [m_delegate onResponseBindingActionSuccess];
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseBindingActionFail)]) {
            [m_delegate onResponseBindingActionFail];
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
    
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseBindingActionFail)]) {
        [m_delegate  onResponseBindingActionFail];
    }
    m_request = nil;
}

 
@end
