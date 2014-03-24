//
//  MFinanceProductAction.h
//  MrMoney
//
//  Created by xingyong on 13-12-10.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@class MFinanceProductData;
@class MActProductData;
@class MPageData;
@protocol MFinanceProductActionDelegate

-(NSDictionary*)onRequestFinanceProductAction;
-(void)onResponseFinanceProductSuccess:(MPageData *)pageData actData:(MActProductData *)actData;
-(void)onResponseFinanceProductFail;


@end
@interface MFinanceProductAction : MBaseAction{
    ASIHTTPRequest *m_request;
 
}
@property(nonatomic,weak)id<MFinanceProductActionDelegate> m_delegate;

/**
 *	@brief	发出请求
 *
 *	请求用户登陆
 */
-(void)requestAction:(NSString *)requestUrl;

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

