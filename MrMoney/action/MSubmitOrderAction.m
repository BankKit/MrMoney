//
//  MSubmitOrderAction.m
//  MrMoney
//
//  Created by xingyong on 14-1-8.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSubmitOrderAction.h"

@implementation MSubmitOrderAction

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
    
    NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate  onRequestSubmitOrderAction]];
    
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)M_URL_SubmitOrder
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
    
    DLog(@"订单提交-----   %@",l_dict_response);
   
         
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {
        if ([[l_dict_response objectForKey:@"result"] intValue] > 0) {
            if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseSubmitOrderFail)]) {
                [m_delegate onResponseSubmitOrderFail];
            }
 
            [MActionUtility showAlert:[l_dict_response objectForKey:@"message"]];
            return;
        }
        MOrderData *order = [[MOrderData alloc] init];
        
        order.mamount       =[l_dict_response objectForKey:@"amount"];
        order.massuredPay   =[l_dict_response objectForKey:@"assuredPay"];
        order.mb2b          =[l_dict_response objectForKey:@"b2b"];
        order.mbankCode     =[l_dict_response objectForKey:@"bankCode"];
        order.mcardAssured  =[l_dict_response objectForKey:@"cardAssured"];
        order.mcommodity    =[l_dict_response objectForKey:@"commodity"];
        order.mcurrencyType =[l_dict_response objectForKey:@"currencyType"];
        order.mmac          =[l_dict_response objectForKey:@"mac"];
        order.mmerchantId   =[l_dict_response objectForKey:@"merchantId"];
        order.mmerchantUrl  =[l_dict_response objectForKey:@"merchantUrl"];
        order.mmessage      =[l_dict_response objectForKey:@"message"];
        order.morderId      =[l_dict_response objectForKey:@"orderId"];
        order.morderUrl     =[l_dict_response objectForKey:@"orderUrl"];
        order.mremark       =[l_dict_response objectForKey:@"remark"];
        order.mresponseMode =[l_dict_response objectForKey:@"responseMode"];
        order.mtime         =[l_dict_response objectForKey:@"time"];
        order.mversion      =[l_dict_response objectForKey:@"version"];
        
//        order.mBuyerContact = [l_dict_response objectForKey:@"BuyerContact"];
//        order.mCharset      = [l_dict_response objectForKey:@"Charset"];
//        order.mExt1         = [l_dict_response objectForKey:@"Ext1"];
//        order.mMsgSender    = [l_dict_response objectForKey:@"MsgSender"];
//        order.mName         = [l_dict_response objectForKey:@"Name"];
//        order.mNotifyUrl    = [l_dict_response objectForKey:@"NotifyUrl"];
//        order.mOrderNo      = [l_dict_response objectForKey:@"OrderNo"];
//        order.mOrderTime    = [l_dict_response objectForKey:@"OrderTime"];
//        order.mPayChannel   = [l_dict_response objectForKey:@"PayChannel"];
//        order.mSendTime     = [l_dict_response objectForKey:@"SendTime"];
//        order.mSignMsg      = [l_dict_response objectForKey:@"SignMsg"];
//        order.mSignType     = [l_dict_response objectForKey:@"SignType"];
//        order.mTranceNo     = [l_dict_response objectForKey:@"TranceNo"];
//        order.mVersion      = [l_dict_response objectForKey:@"Version"];
//        order.mPageUrl      = [l_dict_response objectForKey:@"PageUrl"];
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseSubmitOrderSuccess:)]) {
            
            [m_delegate onResponseSubmitOrderSuccess:order];
        }
        
        
        
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseSubmitOrderFail)]) {
            [m_delegate onResponseSubmitOrderFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseSubmitOrderFail)]) {
        [m_delegate  onResponseSubmitOrderFail];
    }
    m_request = nil;
}

@end
