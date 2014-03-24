//
//  MFundAction.h
//  MrMoney
//
//  Created by xingyong on 14-2-22.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@class MPageData;
@protocol MFundActionDelegate

-(NSDictionary*)onRequestFundAction;
-(void)onResponseFundSuccess:(MPageData *)pageData;
-(void)onResponseFundFail;


@end

@interface MFundAction : MBaseAction
{
    
    ASIHTTPRequest *m_request;
    
}
@property(nonatomic,weak)id<MFundActionDelegate> m_delegate;

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

