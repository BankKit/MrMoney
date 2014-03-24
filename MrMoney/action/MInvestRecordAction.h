//
//  MActivityListAction.h
//  MrMoney
//
//  Created by xingyong on 13-12-13.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@class MPageData;
@protocol MInvestRecordActionDelegate

-(NSDictionary*)onRequestInvestRecordAction;
-(void)onResponseInvestRecordSuccess:(MPageData *)pageData;
-(void)onResponseInvestRecordFail;


@end
@interface MInvestRecordAction : MBaseAction
{
    ASIHTTPRequest *m_request;
    
}
@property(nonatomic,weak)id<MInvestRecordActionDelegate> m_delegate;

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
