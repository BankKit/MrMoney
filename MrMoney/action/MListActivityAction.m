//
//  MListActivityAction.m
//  MrMoney
//
//  Created by xingyong on 14-2-26.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MListActivityAction.h"
#import "MActivityData.h"
#import "MPageData.h"
@implementation MListActivityAction

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
    
    NSDictionary *l_dict_request= [MActionUtility getRequestAllDict:[m_delegate onRequestListActivityAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_listActivity
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
    
    NSLog(@"活动聊天 ------------  %@",l_dict_response);
    
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray array];
        
        NSArray *listArray = [l_dict_response objectForKey:@"activities"];
        
        for (NSDictionary *l_dict in listArray) {
            
            MActivityData *data = [[MActivityData alloc] init];
            
            data.mactId        = m_dictionaryValueToString([l_dict objectForKey:@"actId"]);
            data.mactName      = m_dictionaryValueToString([l_dict objectForKey:@"actName"]);
            data.mactType      = m_dictionaryValueToString([l_dict objectForKey:@"actType"]);
            data.mcommentCount = m_dictionaryValueToString([l_dict objectForKey:@"actType"]);
            data.mcontent      = m_dictionaryValueToString([l_dict objectForKey:@"content"]);
            data.miconPath     = m_dictionaryValueToString([l_dict objectForKey:@"iconPath"]);
            data.mlastPostTime = m_dictionaryValueToString([l_dict objectForKey:@"lastPostTime"]);
            data.mownerId      = m_dictionaryValueToString([l_dict objectForKey:@"ownerId"]);
            data.mrealName     = m_dictionaryValueToString([l_dict objectForKey:@"realName"]);
          
            [l_array_response addObject:data];
            
        }
        
        MPageData *pageData = [[MPageData alloc] init];
        pageData.mpageArray = l_array_response;
        pageData.mnumFound = [[l_dict_response objectForKey:@"numFound"] intValue];
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseListActivitySuccess:)]) {
            [m_delegate onResponseListActivitySuccess:pageData];
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseListActivityFail)]) {
            [m_delegate onResponseListActivityFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseListActivityFail)]) {
        [m_delegate  onResponseListActivityFail];
    }
    m_request = nil;
}


@end
