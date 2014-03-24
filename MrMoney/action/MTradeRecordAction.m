//
//  MTradeRecordAction.m
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MTradeRecordAction.h"
#import "MTradeData.h"
#import "MPageData.h"
@implementation MTradeRecordAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate  onRequestTradeRecordAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_TradeRecords
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
    
    NSLog(@"交易明细-----  %@",l_dict_response);

    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *recordArray = [l_dict_response objectForKey:@"records"];
 
        MPageData *pageData = [[MPageData alloc] init];
        
        for (NSDictionary *l_dict in recordArray) {
            MTradeData *record = [[MTradeData alloc] init];
 
            record.mCrDr  = m_dictionaryValueToString([l_dict objectForKey:@"CrDr"]);
            record.morderNo  = m_dictionaryValueToString([l_dict objectForKey:@"orderNo"]);

            record.mid          = m_dictionaryValueToString([l_dict objectForKey:@"id"]);
            record.mtran_amount = m_dictionaryValueToString([l_dict objectForKey:@"tran_amount"]);
            record.mtran_memo   = m_dictionaryValueToString([l_dict objectForKey:@"tran_memo"]);
            record.mtran_time   = m_dictionaryValueToString([l_dict objectForKey:@"tran_time"]);
            record.mtrans_status= m_dictionaryValueToString([l_dict objectForKey:@"trans_status"]);
            record.mbalance     = m_dictionaryValueToString([l_dict objectForKey:@"balance"]);
            record.mtransTypeDesc = m_dictionaryValueToString([l_dict objectForKey:@"transTypeDesc"]);
            [l_array_response addObject:record];
 
  
        }
        pageData.mpageArray = l_array_response;
        pageData.mnumFound = [[l_dict_response objectForKey:@"numFound"] intValue];

        
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseTradeRecordSuccess:)]) {
            
            [m_delegate onResponseTradeRecordSuccess:pageData];
        }
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseTradeRecordFail)]) {
            [m_delegate onResponseTradeRecordFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseTradeRecordFail)]) {
        [m_delegate  onResponseTradeRecordFail];
    }
    m_request = nil;
}


@end
