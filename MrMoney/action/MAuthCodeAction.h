//
//  MAuthCode.h
//  MrMoney
//
//  Created by xingyong on 13-12-11.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@class MAuthCodeData;
@protocol MAuthCodeActionDelegate

-(NSDictionary*)onRequestAuthCodeAction;
-(void)onResponseAuthCodeSuccess:(MAuthCodeData*)authCode;
-(void)onResponseAuthCodeFail;


@end
@interface MAuthCodeAction : MBaseAction
{
    ASIHTTPRequest *m_request;
    
}
@property(nonatomic,weak)id<MAuthCodeActionDelegate> m_delegate;

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