//
//  MLoginAction.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@protocol MUserLoginActionDelegate

-(NSDictionary*)onRequestUserLoginAction;
-(void)onResponseUserLoginSuccess;
-(void)onResponseUserLoginFail;


@end
@interface MLoginAction : MBaseAction{
    ASIHTTPRequest *m_request_userLogin;
    __weak id<MUserLoginActionDelegate> m_delegate_userLogin;
}
@property(nonatomic,weak)id<MUserLoginActionDelegate> m_delegate_userLogin;

/**
 *	@brief	发出请求
 *
 *	请求用户登陆
 */
-(void)requestUserLogin;

/**
 *	@brief	请求成功
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserLoginFinishResponse:(ASIHTTPRequest*)request;
/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserLoginFailResponse:(ASIHTTPRequest*)request;
@end
