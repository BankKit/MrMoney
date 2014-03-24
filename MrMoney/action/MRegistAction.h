//
//  MRegistAction.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseAction.h"

@protocol MUserRegisterActionDelegate

-(NSDictionary*)onRequestUserRegisterAction;
-(void)onResponseUserRegisterSuccess;
-(void)onResponseUserRegisterFail;
//-(void)onResponseUserRegisterNoNetFail;

@end

@interface MRegistAction : MBaseAction {
    ASIHTTPRequest *m_request_userRegister;
    __weak id<MUserRegisterActionDelegate> m_delegate_userRegister;
}
@property(nonatomic,weak)id<MUserRegisterActionDelegate> m_delegate_userRegister;

/**
 *	@brief	发出请求
 *
 *	请求用户注册
 */
-(void)requestUserRegister;

/**
 *	@brief	请求成功
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserRegisterFinishResponse:(ASIHTTPRequest*)request;
/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestUserRegisterFailResponse:(ASIHTTPRequest*)request;


@end
