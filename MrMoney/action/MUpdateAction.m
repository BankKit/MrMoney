//
//  MUpdateAction.m
//  MrMoney
//
//  Created by xingyong on 14-3-7.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MUpdateAction.h"
#import "GDataXMLNode.h"
@implementation MUpdateAction

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
   
//  NSDictionary *l_dict_request=[MActionUtility getRequestAllDict:[m_delegate onRequestBalanceAction]];
    
    NSString *update_rul = @"http://www.qianxs.com/mmgr/updata/mrMoneyUpdateIphone.xml";
    
    m_request  = [[KDATAWORLD httpEngine] buildRequest:(NSString*)update_rul
                                            getParams:nil
                                                object:self
                                      onFinishedAction:@selector(onRequestFinishResponse:)
                                        onFailedAction:@selector(onRequestFailResponse:)];
    
    
    [m_request  startAsynchronous];
}
-(void)update{
   
    minVersion = [minVersion stringByReplacingOccurrencesOfString:@"." withString:@""];

    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *newVersion = [APP_VERSION stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if (![isUpdate  isEqualToString:@"false"]) {
        
        [MActionUtility showAlert:@"更新提示" message:log delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
        
    }else  if ([version intValue] > [newVersion intValue]) {
        NSLog(@"log----- %@",log);

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:log delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 100;
        [alert show];
        
    }else if([minVersion intValue] < [@"304" intValue]){
        
        [MActionUtility showAlert:@"更新提示" message:log delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KITUNES_URL]];
            
        }
    }else{
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KITUNES_URL]];
            
        }
    }
    
}

/**
 *	@brief	请求成功
 *
 *	回调函数
 *	@param 	request 	请求对象
 */
-(void)onRequestFinishResponse:(ASIHTTPRequest*)request{
    request.responseEncoding = NSUTF8StringEncoding;
    NSString *l_str_response=[request responseString];
    
//    NSDictionary *l_dict_response=[l_str_response objectFromJSONString];
    
    
//    <update>
//    
//    <version>5.0.14030400</version>
//    
//    <name>MrMoney14030400.apk</name>
//    <minversion>5.0.14022800</minversion>
//    
//    <mustupdate>false</mustupdate>
//    
//    <publish>2014-03-04</publish>
//    
//    <url>http://m.qianxs.com/mrmoney14030400.apk</url>
//    
//    <log>首页明星产品快捷购买,\n 摇一摇换产品 \n ui调整及其他优化！推荐升级！</log>
//    
//    </update>
    
   NSLog(@"版本更新 -----  %@",l_str_response);


    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:l_str_response options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *array = [xmlEle children];
 
   
  
    
    for (int i = 0; i < [array count]; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        
 
        if ([[ele name] isEqualToString:@"mustupdate"]) {
            
            isUpdate = (NSString *)[ele  stringValue];
            
        }else  if ([[ele name] isEqualToString:@"log"]) {
           
            log = [ele stringValue];
        }else  if ([[ele name] isEqualToString:@"version"]) {
            
            version = [ele stringValue];
            
        }else  if ([[ele name] isEqualToString:@"minversion"]) {
            
            minVersion = [ele stringValue];
            
        }
        
    }
    
  
    [self update];
    
    
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
    
//    if ([(UIViewController*)m_delegate  respondsToSelector:@selector(onResponseUpdateFail)]) {
//        [m_delegate  onResponseUpdateFail];
//    }
    m_request = nil;
}

@end

