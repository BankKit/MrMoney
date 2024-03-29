//
//  MUpdateAction.h
//  MrMoney
//
//  Created by xingyong on 14-3-7.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseAction.h"
@protocol MUpdateActionDelegate

//-(void)onResponseUpdateSuccess:(NSString *)orderNo;
//-(void)onResponseUpdateFail;

@end

@interface MUpdateAction : MBaseAction<UIAlertViewDelegate>
{
    
    ASIHTTPRequest *m_request;
    
    __weak id<MUpdateActionDelegate> m_delegate;
    
    NSString *log;
    NSString *isUpdate;
    NSString *version;
    NSString *minVersion;
    
}
@property(nonatomic,weak)id<MUpdateActionDelegate> m_delegate;

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

