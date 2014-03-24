//
//  MPayAction.h
//  MrMoney
//
//  Created by xingyong on 14-1-9.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@protocol MPayActionDelegate

-(NSDictionary*)onRequestPayAction;
-(void)onResponsePaySuccess;
-(void)onResponsePayFail;
//-(void)onResponseUserRegisterNoNetFail;

@end
@interface MPayAction : MBaseAction{
    
    ASIHTTPRequest *m_request;
    
    __weak id<MPayActionDelegate> m_delegate;
}
@property(nonatomic,weak)id<MPayActionDelegate> m_delegate;

/**
 *	@brief	发出请求
 *
 *	请求用户登陆
 */
-(void)requestAction;

/**
 *	@brief	请求成功
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestFinishResponse:(ASIHTTPRequest*)request;
/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestFailResponse:(ASIHTTPRequest*)request;



@end
