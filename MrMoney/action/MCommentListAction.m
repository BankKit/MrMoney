//
//  MCommentListAction.m
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCommentListAction.h"
#import "MCommentData.h"
#import "MPageData.h"
@implementation MCommentListAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate  onRequestCommentListAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_AllComment
                                             getParams:l_dict_request
                                                object:self
                                      onFinishedAction:@selector(onRequestFinishResponse:)
                                        onFailedAction:@selector(onRequestFailResponse:)];
    
    
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
    
    NSLog(@" 产品评论 -----  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray arrayWithCapacity:0];
   
        NSArray *commentArray = [l_dict_response objectForKey:@"message"];

        for (NSDictionary *l_dict in commentArray) {
            MCommentData *comment = [[MCommentData alloc] init];
            comment.mcontent   = m_dictionaryValueToString([l_dict objectForKey:@"content"]);
            comment.miconPath  = m_dictionaryValueToString([l_dict objectForKey:@"iconPath"]);
            comment.mid        = m_dictionaryValueToString([l_dict objectForKey:@"id"]);
            comment.mloginName = m_dictionaryValueToString([l_dict objectForKey:@"loginName"]);
            comment.mpid       = m_dictionaryValueToString([l_dict objectForKey:@"pid"]);
            comment.mpostDate  = m_dictionaryValueToString([l_dict objectForKey:@"postDate"]);
            comment.mrealName  = m_dictionaryValueToString([l_dict objectForKey:@"realName"]);
            comment.mrootId    = m_dictionaryValueToString([l_dict objectForKey:@"rootId"]);
            comment.mrootName  = m_dictionaryValueToString([l_dict objectForKey:@"rootName"]);
            comment.mmid       = m_dictionaryValueToString([l_dict objectForKey:@"mid"]);
            
            [l_array_response addObject:comment];
            
        }
        
        MPageData *pageData = [[MPageData alloc] init];
        pageData.mpageArray = l_array_response;
        pageData.mnumFound = [[l_dict_response objectForKey:@"numCount"] intValue];
        
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseCommentListSuccess:)]) {
            
            [m_delegate onResponseCommentListSuccess:pageData];
        }
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseCommentListFail)]) {
            [m_delegate onResponseCommentListFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseCommentListFail)]) {
        [m_delegate  onResponseCommentListFail];
    }
    m_request = nil;
}


@end
