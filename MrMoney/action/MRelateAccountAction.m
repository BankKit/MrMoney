//
//  MBuyProductAction.m
//  MrMoney
//
//  Created by xingyong on 13-12-11.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MRelateAccountAction.h"
#import "MAccountsData.h"
@implementation MRelateAccountAction

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
    
    NSDictionary *l_dict_request=[m_delegate  onRequestRelateAccountAction];
    
 
     NSString *url = [NSString stringWithFormat:@"%@?%@_%@_%@_%@_%@_%@_%@_%@_%@_%@_%@",
                     (NSString *)M_URL_BuyProduct,
                     strOrEmpty([l_dict_request objectForKey:@"AccessId"]),
                     strOrEmpty([l_dict_request objectForKey:@"Channel"]),
                     strOrEmpty([l_dict_request objectForKey:@"AccNum"]),
                     strOrEmpty([l_dict_request objectForKey:@"Password"]),
                     strOrEmpty([l_dict_request objectForKey:@"VerifCode"]),
                     strOrEmpty([l_dict_request objectForKey:@"BankCode"]),
                     strOrEmpty([l_dict_request objectForKey:@"ADD"]),
                     strOrEmpty([l_dict_request objectForKey:@"ViewID"]),
                     strOrEmpty([l_dict_request objectForKey:@"NickName"]),
                     strOrEmpty([l_dict_request objectForKey:@"LoginType"]),
                     strOrEmpty([l_dict_request objectForKey:@"verifyType"])
                     
                     ];
 
    NSLog(@"l_dict_request-------- %@",l_dict_request);
    m_request  = [[KDATAWORLD httpEngine] buildDistributeRequest:(NSString *)url
                                                       getParams:l_dict_request
                                                          object:self
                                                onFinishedAction:@selector(onRequestFinishResponse:)
                                                  onFailedAction:@selector(onRequestFailResponse:)];
    
    m_request.timeOutSeconds = 180;
    
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
    
    NSLog(@"--------- 关联账户 ------ %@",l_dict_response);
  
    if ([MActionUtility isRequestJSONSuccess:l_dict_response]) {

        if ([[l_dict_response objectForKey:@"Result"] intValue] == 1) {
            MAccountsData *account = [[MAccountsData alloc] init];
            account.mAccNum = m_dictionaryValueToString([l_dict_response objectForKey:@"AccNum"]);
        
            account.mname = m_dictionaryValueToString([l_dict_response objectForKey:@"CustomerName"]);
            account.mProducts = [l_dict_response objectForKey:@"Products"];
            account.mbankId = m_dictionaryValueToString([l_dict_response objectForKey:@"BankCode"]);
            
            NSDictionary *balanceDict  = [l_dict_response objectForKey:@"Balance"];
             NSString *balanceStr =  [balanceDict  objectForKey:@"CNY"];
            account.mBalance  = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"CNY",balanceStr];

            if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseRelateAccountSuccess:)]) {
                [m_delegate onResponseRelateAccountSuccess:account];
            }
        }else{
            
            [MActionUtility showAlert:[l_dict_response objectForKey:@"CHSReason"]];
            
            if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseRelateAccountFail)]) {
                [m_delegate onResponseRelateAccountFail];
            }
                  
            return;
        }
    
    }else{
        
        if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseRelateAccountFail)]) {
            [m_delegate onResponseRelateAccountFail];
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
    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseRelateAccountFail)]) {
        [m_delegate  onResponseRelateAccountFail];
    }
    m_request = nil;
}

@end
