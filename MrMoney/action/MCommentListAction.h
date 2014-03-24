//
//  MCommentListAction.h
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@class MPageData;
@protocol MCommentListActionDelegate

-(NSDictionary*)onRequestCommentListAction;
-(void)onResponseCommentListSuccess:(MPageData *)pageData;
-(void)onResponseCommentListFail;

@end

@interface MCommentListAction : MBaseAction{
    
    ASIHTTPRequest *m_request;
    
    __weak id<MCommentListActionDelegate> m_delegate;
}
@property(nonatomic,weak)id<MCommentListActionDelegate> m_delegate;

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
