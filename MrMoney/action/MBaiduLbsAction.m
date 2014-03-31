//
//  MBaiduLbsAction.m
//  MrMoney
//
//  Created by xingyong on 14-3-20.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaiduLbsAction.h"
#import "MPlaceData.h"
@implementation MBaiduLbsAction

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
    
    NSDictionary *l_dict_request=[m_delegate onRequestBaiduLbsAction];
    
    
    NSString *M_URL_lbs = @"http://api.map.baidu.com/place/v2/search";
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_lbs
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
    
    DLog(@"一 百度地图 -----  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *response_array = [NSMutableArray array];
        NSArray *result_array = [l_dict_response objectForKey:@"results"];
        
        for (NSDictionary *placeDict in result_array) {
            MPlaceData *place = [[MPlaceData alloc] init];
            place.mname = [placeDict objectForKey:@"name"];
            
            place.mtelephone = [placeDict objectForKey:@"telephone"];
            place.muid = [placeDict objectForKey:@"uid"];
            place.mstreet_id = [placeDict objectForKey:@"street_id"];
            place.maddress = [placeDict objectForKey:@"address"];
            NSDictionary *l_dict = [placeDict objectForKey:@"location"];
            place.mlat = [[l_dict objectForKey:@"lat"] doubleValue];
            place.mlng = [[l_dict objectForKey:@"lng"] doubleValue];
            
            [response_array addObject:place];
        }
 
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseBaiduLbsActionSuccess:)]) {
                
            [m_delegate onResponseBaiduLbsActionSuccess:response_array];
            }
 
 
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseBaiduLbsActionFail)]) {
            [m_delegate onResponseBaiduLbsActionFail];
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
    
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseBaiduLbsActionFail)]) {
        [m_delegate  onResponseBaiduLbsActionFail];
    }
    m_request = nil;
}


@end

