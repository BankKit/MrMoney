//
//  MProductDetailAction.m
//  MrMoney
//
//  Created by xingyong on 14-2-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MProductDetailAction.h"
#import "MFinanceProductData.h"
@implementation MProductDetailAction

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
    
    NSDictionary *l_dict_request= [MActionUtility getRequestAllDict:[m_delegate  onRequestProductDetailAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_productDetail
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
    
    DLog(@"理财产品详情 ------------  %@",l_dict_response);
    
    
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        
        NSDictionary *product_dict = [l_dict_response objectForKey:@"product"];
        
        MFinanceProductData *product = [[MFinanceProductData alloc] init];
        
//        acceptedDateType = 0;
 
//        buyEndTime = 1700;
//        buyStartTime = 0930;
//        callDate = 20140429;
//        collectEnd = 20140224;
//        collectStart = 20140218;
//        createTime = "2014-02-18 00:01:49.0";
//        currency = "\U4eba\U6c11\U5e01";
//        customerType = "\U6240\U6709\U5ba2\U6237";
//        expectedReturnInfo = "";
//        expectedReturnRate = 580;
//        flexibleCycle = "";
//        hasGuarantee = 0;
//        increment = 1000000;
//        lowestAmount = 5000000;
//        manualUrl = "http://www.qianxs.com/manuals/bank/SPDB_2301143179.pdf";
//        netDate = "";
//        netValue = "";
//        pid = FB0000203424;
//        poundage = "";
//        preference = "";
//        purchaseType = 1;
//        purchaseUrl = "";
//        pversion = 20140218000044;
//        riskLevel = "\U8f83\U4f4e\U98ce\U9669";
//        salesRegion = 10000;
 
 
        
        product.mbank_id       = [product_dict objectForKey:@"bankId"];
        product.mbreak_even    = [product_dict objectForKey:@"breakEven"];
        product.mcurrency      = [product_dict objectForKey:@"currency"];
        product.mhas_guarantee = [product_dict objectForKey:@"hasGuarantee"];
        product.minside_sales  = [product_dict objectForKey:@"inside_sales"];
        product.minvest_cycle  = [product_dict objectForKey:@"investCycle"];
        product.mlast_update   = [product_dict objectForKey:@"lastUpdate"];
        product.mlowest_amount = [product_dict objectForKey:@"lowestAmount"];
        product.mpid           = [product_dict objectForKey:@"pid"];
        product.mpopularity    = [product_dict objectForKey:@"popularity"];
        product.mproduct_code  = [product_dict objectForKey:@"productCode"];
        product.mproduct_name  = [product_dict objectForKey:@"productName"];
        product.mproduct_type  = [product_dict objectForKey:@"productType"];
        product.mreturn_info   = [product_dict objectForKey:@"expectedReturnInfo"];
        product.mreturn_rate   = [product_dict objectForKey:@"expectedReturnRate"];
        product.msales_region  = [product_dict objectForKey:@"salesRegion_desc"];
        product.mvalue_date    = [product_dict objectForKey:@"valueDate"];
        product.mprogress_value= [product_dict objectForKey:@"progressValue"];
        product.mprodBalance   = [product_dict objectForKey:@"prodBalance"];
        
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseProductDetailSuccess:)]) {
            [m_delegate  onResponseProductDetailSuccess:product];
        }
        
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseProductDetailFail)]) {
            [m_delegate onResponseProductDetailFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseProductDetailFail)]) {
        [m_delegate  onResponseProductDetailFail];
    }
    m_request = nil;
}

@end
