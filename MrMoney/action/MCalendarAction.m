//
//  MCalendarAction.m
//  MrMoney
//
//  Created by xingyong on 14-2-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCalendarAction.h"
#import "MUtility.h"
#import "MCalendarData.h"
@implementation MCalendarAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate  onRequestCalendarAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_Calendar
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
    
    DLog(@"投资日记-----  %@",l_dict_response);
    
   
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *listArray = [l_dict_response objectForKey:@"list"];
 
        for (NSDictionary *l_dict in listArray) {
            
            
            NSDate *investdate = [NSDate dateWithTimeIntervalSince1970:([[l_dict objectForKey:@"investDate"] doubleValue]/1000)];
             

            MCalendarData *data = [[MCalendarData alloc] init];
            data.minvestDate  = [investdate dateToday];
            data.minvestCycle = m_dictionaryValueToString([l_dict objectForKey:@"investCycle"]);
            data.mincomeMoney = m_dictionaryValueToString([l_dict objectForKey:@"incomeMoney"]);
            data.mexpectRate  = m_dictionaryValueToString([l_dict objectForKey:@"expectRate"]);
            data.mcallDate    = m_dictionaryValueToString([l_dict objectForKey:@"callDate"]);
            data.mactId       = m_dictionaryValueToString([l_dict objectForKey:@"actId"]);
            data.mbankId      = m_dictionaryValueToString([l_dict objectForKey:@"bankId"]);
            data.mname        = m_dictionaryValueToString([l_dict objectForKey:@"name"]);
            data.mpid         = m_dictionaryValueToString([l_dict objectForKey:@"pid"]);
            data.mvalueDate   = m_dictionaryValueToString([l_dict objectForKey:@"valueDate"]);
            data.minvestMoney = m_dictionaryValueToString([l_dict objectForKey:@"investMoney"]);
//            [data insertToDb];
            

            [l_array_response addObject:data];
            
        }
        
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseCalendarSuccess:)]) {
            
            [m_delegate onResponseCalendarSuccess:l_array_response];
        }
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseCalendarFail)]) {
            [m_delegate onResponseCalendarFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseCalendarFail)]) {
        [m_delegate  onResponseCalendarFail];
    }
    m_request = nil;
}

@end
