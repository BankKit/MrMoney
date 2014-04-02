//
//  MUploadIconAction.m
//  MrMoney
//
//  Created by xingyong on 14-2-18.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MUploadIconAction.h"

@implementation MUploadIconAction

@synthesize m_delegate;

-(void)dealloc{
    m_delegate  = nil;
    [m_request  clearDelegatesAndCancel];
}

/**
 *	@brief	发出请求
 *
 *	请求用户登陆
 */
-(void)requestAction{
    if (m_request !=nil && [m_request  isFinished]) {
        return;
    }
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate onRequestUploadIconAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:[MActionUtility getURL:(NSString*)M_URL_uploadIcon]
                                            postParams:l_dict_request
                                                object:self
                                      onFinishedAction:@selector(onRequestFinishResponse:)
                                        onFailedAction:@selector(onRequestFailResponse:)];
    
    //    NSDictionary *pathDic=[m_delegate_sendAnnouncement  onResponseSendAnnouncementListAction];
    
    NSString *path=[MUtility getImageWithName:@"uploadImage.jpg"];
    
    [m_request setFile:path forKey:@"imageFile"];
    [m_request  startAsynchronous];
}

/**
 *	@brief	请求成功
 *
 *	回调函数
 *	@param 	request 	请求对象
 */
-(void)onRequestFinishResponse:(ASIHTTPRequest*)request{
    NSString *l_str_response=[request responseString];
    
    NSDictionary *l_dict_response=[l_str_response objectFromJSONString];
    
    DLog(@" 上传头像 -----  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        
        int result = [[l_dict_response objectForKey:@"result"] intValue];
        if (result == 0) {
            
            if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseUploadIconSuccess:)]) {
                [m_delegate onResponseUploadIconSuccess:[l_dict_response objectForKey:@"iconPath"]];
            }
            
        }else {
            if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseUploadIconFail)]) {
                [m_delegate onResponseUploadIconFail];
            }
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseUploadIconFail)]) {
            [m_delegate onResponseUploadIconFail];
        }
        
    }
    m_request = nil;
}

/**
 *	@brief	请求失败
 *
 *	回调函数
 *
 *	@param 	request 	请求对象
 */
-(void)onRequestFailResponse:(ASIHTTPRequest*)request{
    
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseUploadIconFail)]) {
        [m_delegate  onResponseUploadIconFail];
    }
    m_request = nil;
}



@end
