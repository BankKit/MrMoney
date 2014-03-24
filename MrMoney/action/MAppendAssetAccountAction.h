//
//  MAppendAssetAccountAction.h
//  MrMoney
//
//  Created by xingyong on 14-2-20.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@protocol MAppendAssetAccountActionDelegate

-(NSDictionary*)onRequestAppendAssetAccountAction;
-(void)onResponseAppendAssetAccountSuccess;
-(void)onResponseAppendAssetAccountFail;
//-(void)onResponseUserRegisterNoNetFail;

@end
@interface MAppendAssetAccountAction : MBaseAction
{
    
    ASIHTTPRequest *m_request;
    
    __weak id<MAppendAssetAccountActionDelegate> m_delegate;
}
@property(nonatomic,weak)id<MAppendAssetAccountActionDelegate> m_delegate;

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
