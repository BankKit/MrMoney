//
//  MQQAuthAction.m
//  MrMoney
//
//  Created by xingyong on 14-3-21.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MQQAuthAction.h"
#import "MUserData.h"
@implementation MQQAuthAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate onRequestQQAuthAction]];
    
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_qqoauth
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
    
    NSLog(@"一 认证 -----  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        
         NSInteger flag = [[l_dict_response objectForKey:@"flag"] integerValue];
        
        if (flag == 1) {
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

        }
       
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQQAuthActionSuccess:)]) {
 
            [m_delegate onResponseQQAuthActionSuccess:flag];
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQQAuthActionFail)]) {
            [m_delegate onResponseQQAuthActionFail];
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
    
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseQQAuthActionFail)]) {
        [m_delegate  onResponseQQAuthActionFail];
    }
    m_request = nil;
}


@end
