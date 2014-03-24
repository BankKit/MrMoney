//
//  MPayViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-9.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MPayViewController.h"
#import "MOrderData.h"

@interface MPayViewController ()

@end

@implementation MPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//
//    if ([self.payTypeName isEqualToString:@"COMM"]) {
//        bankTitle = @"交通银行";
//    }else if ([self.payTypeName isEqualToString:@"SZPAB"]) {
//        bankTitle = @"平安银行";
//    }else if ([self.payTypeName isEqualToString:@"BCCB"]) {
//        bankTitle = @"北京银行";
//    }
   NSString *navTitle = [_order.mbankCode lowercaseString];
    NSString *bankCode = [_order.mbankCode lowercaseString];
    if ([bankCode isEqualToString:@"srcb"]) {
        bankCode = @"shrcb";
    }else if ([bankCode isEqualToString:@"bccb"]){
        bankCode = @"bob";
    }
    
    if([navTitle isEqualToString:@"comm"]){
        navTitle = @"bocom";
    }else if ([navTitle isEqualToString:@"bccb"]){
        navTitle = @"bob";
    }
    
    [self createNavBarTitle:STRING_FORMAT(@"%@手机支付",bankName(navTitle))];
    
    
    NSString *postString = [NSString stringWithFormat:@"version=%@&merchantId=%@&merchantUrl=%@&responseMode=%@&orderId=%@&currencyType=%@&amount=%@&assuredPay=%@&time=%@&remark=%@&mac=%@&bankCode=%@&b2b=%@&commodity=%@&orderUrl=%@&cardAssured=%@",_order.mversion,
                            _order.mmerchantId,[_order.mmerchantUrl URLEncode],_order.mresponseMode,
                            _order.morderId,_order.mcurrencyType,_order.mamount,
                            _order.massuredPay,_order.mtime,_order.mremark,_order.mmac,
                            bankCode,_order.mb2b,[_order.mcommodity URLEncode],
                            [_order.morderUrl URLEncode],_order.mcardAssured];
    
//    [NSString stringWithFormat:@"Name=%@&Version=%@&Charset=%@&MsgSender=%@&SendTime=%@&OrderNo=%@&OrderAmount=%.2f&OrderTime=%@&PageUrl=%@&NotifyUrl=%@&ProductName=%@&BuyerContact=%@&BuyerIp=%@&SignType=%@&Ext1=%@&SignMsg=%@&PayType=%@&PayChannel=%@&InstCode=%@",_order.mName, _order.mVersion,_order.mCharset,_order.mMsgSender,_order.mSendTime,_order.mOrderNo,self.amount,_order.mOrderTime,[_order.mPageUrl URLEncode],[_order.mNotifyUrl URLEncode],_product_name,_order.mBuyerContact,self.ip,_order.mSignType,_order.mExt1,_order.mSignMsg,@"PT001",_order.mPayChannel,self.payTypeName]; 测试账号： 62270012 1462 0273 762    851113    9234
  
     NSLog(@"postString -------- %@",postString);
     
    
    NSData *postData = [postString  dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"https://www.unspay.com/unspay/page/linkbank/payRequest.do"]];
    
//    [request setURL:[NSURL URLWithString:@"https://mas.sdo.com/web-acquire-channel/cashier.htm"]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [self.webView loadRequest:request];
 
    [self showHUD];
}
-(void)onButtonActionBack:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(payResultNotify)]) {
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate payResultNotify];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showHUD];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHUD];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
//    if ([self.payTypeName isEqualToString:@"CMB"]) {
//        //获取切换按钮
//        [webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit(); "];
//    }else if([self.payTypeName isEqualToString:@"COMM"]){
//        //获取中文按钮
//       [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('中文')[0].submit(); "];
//    }
    if ([_order.mbankCode isEqualToString:@"CMB"]) {
        //获取切换按钮
        [webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit(); "];
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
