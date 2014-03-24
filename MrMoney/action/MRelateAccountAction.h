//
//  MBuyProductAction.h
//  MrMoney
//
//  Created by xingyong on 13-12-11.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@class MAccountsData;
@protocol MRelateAccountActionDelegate

-(NSDictionary*)onRequestRelateAccountAction;
-(void)onResponseRelateAccountSuccess:(MAccountsData *)account;
-(void)onResponseRelateAccountFail;


@end
@interface MRelateAccountAction : MBaseAction
{
    ASIHTTPRequest *m_request;
    
}
@property(nonatomic,weak)id<MRelateAccountActionDelegate> m_delegate;

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
