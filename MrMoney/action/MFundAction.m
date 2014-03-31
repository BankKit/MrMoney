//
//  MFundAction.m
//  MrMoney
//
//  Created by xingyong on 14-2-22.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFundAction.h"
#import "MFundData.h"
#import "MPageData.h"
@implementation MFundAction

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
    
    NSDictionary *l_dict_request= [MActionUtility getRequestAllDict:[m_delegate  onRequestFundAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_fund
                                             postParams:l_dict_request
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
    
    DLog(@"基金列表 ------------  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray array];
        
        NSArray *docsArray = [l_dict_response objectForKey:@"docs"];
        
        
        for (NSDictionary *l_dict in docsArray) {
            
            MFundData *fund = [[MFundData alloc] init];
            fund.mcumulative_value = m_dictionaryValueToString([l_dict objectForKey:@"cumulative_value"]);
            fund.mestablish_date   = m_dictionaryValueToString([l_dict objectForKey:@"establish_date"]);
            fund.mestablish_return = m_dictionaryValueToString([l_dict objectForKey:@"establish_return"]);
            fund.mfund_id          = m_dictionaryValueToString([l_dict objectForKey:@"fund_id"]);
            fund.mnet_date         = m_dictionaryValueToString([l_dict objectForKey:@"net_date"]);
            fund.mnet_value        = m_dictionaryValueToString([l_dict objectForKey:@"net_value"]);
            fund.mpid              = m_dictionaryValueToString([l_dict objectForKey:@"pid"]);
            fund.mproduct_code     = m_dictionaryValueToString([l_dict objectForKey:@"product_code"]);
            fund.mproduct_name     = m_dictionaryValueToString([l_dict objectForKey:@"product_name"]);
            fund.mproduct_type     = m_dictionaryValueToString([l_dict objectForKey:@"product_type"]);
            fund.mtran_status      = m_dictionaryValueToString([l_dict objectForKey:@"tran_status"]);
            fund.mweek_return      = m_dictionaryValueToString([l_dict objectForKey:@"week_return"]);
            fund.myear_return      = m_dictionaryValueToString([l_dict objectForKey:@"year_return"]);
 
            
            [l_array_response addObject:fund];
            
        }
        
        MPageData *pageData = [[MPageData alloc] init];
        pageData.mpageArray = l_array_response;
        pageData.mnumFound = [[l_dict_response objectForKey:@"numFound"] intValue];
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFundSuccess:)]) {
            [m_delegate  onResponseFundSuccess:pageData];
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFundFail)]) {
            [m_delegate onResponseFundFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFundFail)]) {
        [m_delegate  onResponseFundFail];
    }
    m_request = nil;
}


@end
