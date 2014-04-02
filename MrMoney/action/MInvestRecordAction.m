//
//  MActivityListAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-13.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MInvestRecordAction.h"
#import "MInvestRecordData.h"
#import "MPageData.h"
@implementation MInvestRecordAction

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
    
    NSDictionary *l_dict_request =[MActionUtility getRequestAllDict:[m_delegate  onRequestInvestRecordAction]];
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:[MActionUtility getURL:(NSString*)M_URL_queryTransStreams]
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
    
    DLog(@"我的投资记录 %@",l_dict_response);
 
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray array];

        NSArray *listArray = [l_dict_response objectForKey:@"records"];
        
        for (NSDictionary *l_dict in listArray) {

            
            MInvestRecordData *record = [[MInvestRecordData alloc] init];
            record.mBsnsSts     = m_dictionaryValueToString([l_dict objectForKey:@"BsnsSts"]);
            record.mOriTrxCode  = m_dictionaryValueToString([l_dict objectForKey:@"OriTrxCode"]);
            record.mPayId       = m_dictionaryValueToString([l_dict objectForKey:@"PayId"]);
            record.mSTAN        = m_dictionaryValueToString([l_dict objectForKey:@"STAN"]);
            record.mTrxDate     = m_dictionaryValueToString( [l_dict objectForKey:@"TrxDate"]);
            record.mTrxType     = m_dictionaryValueToString([l_dict objectForKey:@"TrxType"]);
            record.mid          = m_dictionaryValueToString([l_dict objectForKey:@"id"]);
            record.mstatus      = m_dictionaryValueToString([l_dict objectForKey:@"status"]);
            record.mtran_amount = m_dictionaryValueToString( [l_dict objectForKey:@"tran_amount"]);
            record.mtran_memo   = m_dictionaryValueToString( [l_dict objectForKey:@"tran_memo"]);
            record.mtran_time   = m_dictionaryValueToString([l_dict objectForKey:@"tran_time"]);
            record.mtran_type   = m_dictionaryValueToString([l_dict objectForKey:@"tran_type"]);
            record.mBsnsStsDesc =  m_dictionaryValueToString([l_dict objectForKey:@"BsnsStsDesc"]);
            record.mtransTypeDesc =  m_dictionaryValueToString([l_dict objectForKey:@"transTypeDesc"]);
            [l_array_response addObject:record];
        }
        
        MPageData *pageData = [[MPageData alloc] init];
        
        pageData.mpageArray = l_array_response;
        pageData.mnumFound = [[l_dict_response objectForKey:@"numFound"] intValue];
         
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseInvestRecordSuccess:)]) {
            [m_delegate onResponseInvestRecordSuccess:pageData];
        }
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseInvestRecordFail)]) {
            [m_delegate onResponseInvestRecordFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseInvestRecordFail)]) {
        [m_delegate  onResponseInvestRecordFail];
    }
    m_request = nil;
}

@end
