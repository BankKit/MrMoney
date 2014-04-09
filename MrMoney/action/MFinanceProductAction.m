//
//  MFinanceProductAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-10.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MFinanceProductAction.h"
#import "MFinanceProductData.h"
#import "MPageData.h"
#import "MActProductData.h"
#import "MMapper.h"
#import "MInternetData.h"
@implementation MFinanceProductAction

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
-(void)requestAction:(NSString *)requestUrl{
    if (m_request !=nil && [m_request  isFinished]) {
        return;
    }
    
    if ([requestUrl isEqualToString:(NSString *)M_URL_FinanceProduct]) {
        ret = YES;
    }
    NSDictionary *l_dict_request= [MActionUtility getRequestAllDict:[m_delegate  onRequestFinanceProductAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:[MActionUtility getURL:requestUrl]
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
    
    DLog(@"理财产品列表 ------------  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        NSMutableArray *l_array_response = [NSMutableArray array];
        
        NSArray *docsArray = [l_dict_response objectForKey:@"docs"];
        
        NSArray *actArray = [l_dict_response objectForKey:@"actProd"];
        
        MActProductData *act = [[MActProductData alloc] init];
        
        for (NSDictionary *l_dict in actArray) {
  
            act.mactRmAmount        = m_dictionaryValueToString([l_dict objectForKey:@"actRmAmount"]);
            act.mbankId             = m_dictionaryValueToString([l_dict objectForKey:@"bankId"]);
            act.mbreakEven          = m_dictionaryValueToString([l_dict objectForKey:@"breakEven"]);
            act.mcallDate           = m_dictionaryValueToString([l_dict objectForKey:@"callDate"]);
            act.mcurrency           = m_dictionaryValueToString([l_dict objectForKey:@"currency"]);
            act.mdRate              = m_dictionaryValueToString([l_dict objectForKey:@"dRate"]);
            act.mendTime            = m_dictionaryValueToString([l_dict objectForKey:@"endTime"]);
            act.mexpectedReturnRate = m_dictionaryValueToString([l_dict objectForKey:@"expectedReturnRate"]);
            act.minvestCycle        = m_dictionaryValueToString([l_dict objectForKey:@"investCycle"]);
            act.mpid                = m_dictionaryValueToString([l_dict objectForKey:@"pid"]);
            act.mprodRate           = m_dictionaryValueToString([l_dict objectForKey:@"prodRate"]);
            act.mproductCode        = m_dictionaryValueToString([l_dict objectForKey:@"productCode"]);
            act.mproductName        = m_dictionaryValueToString([l_dict objectForKey:@"productName"]);
            act.mproductType        = m_dictionaryValueToString([l_dict objectForKey:@"productType"]);
            act.msalesRegion_desc   = m_dictionaryValueToString([l_dict objectForKey:@"salesRegion_desc"]);
            act.mvalueDate          = m_dictionaryValueToString([l_dict objectForKey:@"valueDate"]);
            
            act.mstartTime          = m_dictionaryValueToString([l_dict objectForKey:@"startTime"]);
        }
        //             l_array_response = [MMapper mutableArrayOfClass:[MFinanceProductData class]
//    fromArrayOfDictionary:docsArray];
        
        if (ret) {
            for (NSDictionary *product_dict in docsArray) {
                
                MFinanceProductData *product = [[MFinanceProductData alloc] init];
                product.mbank_id       = [product_dict objectForKey:@"bank_id"];
                product.mbreak_even    = [product_dict objectForKey:@"break_even"];
                product.mcurrency      = [product_dict objectForKey:@"currency"];
                product.mhas_guarantee = [product_dict objectForKey:@"has_guarantee"];
                product.minside_sales  = [product_dict objectForKey:@"inside_sales"];
                product.minvest_cycle  = [product_dict objectForKey:@"invest_cycle"];
                product.mlast_update   = [product_dict objectForKey:@"last_update"];
                product.mlowest_amount = [product_dict objectForKey:@"lowest_amount"];
                product.mpid           = [product_dict objectForKey:@"pid"];
                product.mpopularity    = [product_dict objectForKey:@"popularity"];
                product.mproduct_code  = [product_dict objectForKey:@"product_code"];
                product.mproduct_name  = [product_dict objectForKey:@"product_name"];
                product.mproduct_type  = [product_dict objectForKey:@"product_type"];
                product.mreturn_info   = [product_dict objectForKey:@"return_info"];
                product.mreturn_rate   = [product_dict objectForKey:@"return_rate"];
                product.msales_region  = [product_dict objectForKey:@"sales_region_desc"];
                product.mvalue_date    = [product_dict objectForKey:@"value_date"];
                
                [l_array_response addObject:product];
                
            }

        }else{
           
            l_array_response = [MMapper mutableArrayOfClass:[MInternetData class]
                                 fromArrayOfDictionary:docsArray];

        }
        
        MPageData *pageData = [[MPageData alloc] init];
        pageData.mpageArray = l_array_response;
        pageData.mnumFound = [[l_dict_response objectForKey:@"numFound"] intValue];
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFinanceProductSuccess:actData:)]) {
            [m_delegate onResponseFinanceProductSuccess:pageData actData:act];
        }
          
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFinanceProductFail)]) {
            [m_delegate onResponseFinanceProductFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseFinanceProductFail)]) {
        [m_delegate  onResponseFinanceProductFail];
    }
    m_request = nil;
}

@end
