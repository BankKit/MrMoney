//
//  MPublishCommentAction.h
//  MrMoney
//
//  Created by xingyong on 14-4-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@protocol MPublishCommentActionDelegate

-(NSDictionary*)onRequestPublishCommentAction;
-(void)onResponsePublishCommentActionSuccess;
-(void)onResponsePublishCommentActionFail;

@end
@interface MPublishCommentAction : MBaseAction
{
    
    ASIHTTPRequest *m_request;
    
    __weak id<MPublishCommentActionDelegate> m_delegate;
    
}
@property(nonatomic,weak)id<MPublishCommentActionDelegate> m_delegate;

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
