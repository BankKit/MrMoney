//
//  MLoginAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MLoginAction.h"
#import "MUserData.h"
@implementation MLoginAction
@synthesize m_delegate_userLogin;

-(void)dealloc{
    m_delegate_userLogin = nil;
    [m_request_userLogin clearDelegatesAndCancel];
}

/**
 *	@brief	发出请求
 *
 *	请求用户登陆
 */
-(void)requestUserLogin{
    if (m_request_userLogin!=nil && [m_request_userLogin isFinished]) {
        return;
    }
    
    NSDictionary *l_dict_request = [MActionUtility getRequestAllDict:[m_delegate_userLogin onRequestUserLoginAction]];
    
    m_request_userLogin = [[KDATAWORLD httpEngine] buildRequest:[MActionUtility getURL:(NSString *)M_URL_Login]
                                                      getParams:l_dict_request
                                                         object:self
                                               onFinishedAction:@selector(onRequestUserLoginFinishResponse:)
                                                 onFailedAction:@selector(onRequestUserLoginFailResponse:)];
    
    
    [m_request_userLogin startAsynchronous];
}

/**
 *	@brief	请求成功
 *
 *	回调函数
 *	@param 	request 	请求对象
 */
-(void)onRequestUserLoginFinishResponse:(ASIHTTPRequest*)request{
    NSString *l_str_response=[request responseString];
    
    NSDictionary *l_dict_response=[l_str_response objectFromJSONString];
    
    
    DLog(@"returnMsg---- 登录返回 %@",l_dict_response);
    
    
	if (l_dict_response != nil) {
        
 
        NSString *resultCode = [l_dict_response objectForKey:@"returnCode"];
        
        if ([resultCode intValue] == 1001 ) {
            
            [MActionUtility showAlert:@"密码错误"];
            
            if ([(UIViewController*)m_delegate_userLogin respondsToSelector:@selector(onResponseUserLoginFail)]) {
                [m_delegate_userLogin onResponseUserLoginFail];
            }
            
            
        }else if ([resultCode intValue] == 1002){
            [MActionUtility showAlert:@"账号不存在"];
            if ([(UIViewController*)m_delegate_userLogin respondsToSelector:@selector(onResponseUserLoginFail)]) {
                
                [m_delegate_userLogin onResponseUserLoginFail];
            }
            
        }else{
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
            
            if ([(UIViewController*)m_delegate_userLogin respondsToSelector:@selector(onResponseUserLoginSuccess)]) {
                [m_delegate_userLogin onResponseUserLoginSuccess];
            }
        }
        
    }else{

         
        if ([(UIViewController*)m_delegate_userLogin respondsToSelector:@selector(onResponseUserLoginFail)]) {
            
            [m_delegate_userLogin onResponseUserLoginFail];
        }
    }
 
    m_request_userLogin=nil;
}

/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserLoginFailResponse:(ASIHTTPRequest*)request{
    if ([(UIViewController*)m_delegate_userLogin respondsToSelector:@selector(onResponseUserLoginFail)]) {
        [m_delegate_userLogin onResponseUserLoginFail];
    }
    m_request_userLogin=nil;
}
@end
