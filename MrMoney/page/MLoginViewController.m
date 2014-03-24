//
//  MLoginViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MLoginViewController.h"
#import "MRegistViewController.h"
#import "RDVTabBarController.h"
#import "MActionUtility.h"
#import "MSecurityView.h"
#import "AppDelegate.h"
#import "MForgetPasswordViewController.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import "MCompleteInfoViewController.h"
@interface MLoginViewController ()
@property(nonatomic,copy)NSString *openId;
@end

@implementation MLoginViewController

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
 
    [self createNavBarTitle:@"用户登录"];
     
    [_registBtn setBackgroundImage:KDEFAULT_GRAY_BTN forState:UIControlStateNormal];
    
    MSecurityView *securityView = [[MSecurityView alloc] initWithFrame:Rect(10, _registBtn.frameHeight + _registBtn.frameY + 75, 300, 208)];

    [self.scrollView  addSubview:securityView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, securityView.frameY + securityView.frameHeight + 5);
    
 
}

-(NSDictionary*)onRequestQQAuthAction{
    return @{@"openid": self.openId};
}
-(void)onResponseQQAuthActionSuccess:(NSInteger)bindingValue{
    if (bindingValue== 0) {
        MCompleteInfoViewController *info = [[MCompleteInfoViewController alloc] initWithNibName:@"MCompleteInfoViewController" bundle:nil];
        info.openid = self.openId;
        [self.navigationController pushViewController:info animated:YES];
        
     
    }else{
        user_defaults_set_string(@"KPASSWORD",MSMD5(_passwordTf.text));
        
        RDVTabBarController *tabBarController = (RDVTabBarController *)kAppDelegate.viewController;
        if (tabBarController.selectedIndex != 1) {
            [tabBarController setSelectedIndex:1];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.completionHandler) {
                self.completionHandler();
            }
        }];

    }
 
}
-(void)onResponseQQAuthActionFail{
    
}
 
- (IBAction)onClickTencentOAuth:(id)sender {
 
    _permissions = [NSMutableArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    
	_tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101027370"
											andDelegate:self];
    
	[_tencentOAuth authorize:_permissions inSafari:NO];
}
#pragma mark --- ---
#pragma mark --- qq登录回调 ---
- (void)tencentDidLogin {
	// 登录成功
    
    
    if (_tencentOAuth.openId  && 0 != [_tencentOAuth.openId length])
    {
        self.openId = _tencentOAuth.openId;
        NSLog(@"----openId---------------------------%@ \n\n",_tencentOAuth.openId);
        
        authAction = [[MQQAuthAction alloc] init];
        authAction.m_delegate = self;
        [authAction requestAction];
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginAction:(id)sender {
    [_passwordTf resignFirstResponder];
    [_usernameTf resignFirstResponder];
//    if (![MStringUtility isPhoneNum:[_usernameTf text]]) {
//
//        [MActionUtility showAlert:@"账号不合法"];
//        return;
//    }
    
    if ([_usernameTf.text isEqualToString:KEMPTY_STR]) {
        [MActionUtility showAlert:@"账号不能为空"];
        return;
    }
    if ([_passwordTf.text isEqualToString:KEMPTY_STR]) {
        
        [MActionUtility showAlert:@"密码不能为空"];
         
        return;
    }
 
    
    loginAction = [[MLoginAction alloc] init];
    loginAction.m_delegate_userLogin = self;
    [loginAction requestUserLogin];
    [self showHUD];
    
    
    
}


#pragma mark - 
#pragma mark - login delegate
-(NSDictionary*)onRequestUserLoginAction{
     
    MutableOrderedDictionary *requestDic =  [MutableOrderedDictionary dictionary];
    
    [requestDic setObject:_usernameTf.text forKey:@"username"];
    [requestDic setObject:_passwordTf.text forKey:@"password"];
    
 
    return requestDic;
}

-(void)onResponseUserLoginSuccess{
    [self hideHUD];
    
    user_defaults_set_string(@"KPASSWORD",MSMD5(_passwordTf.text));
    
    RDVTabBarController *tabBarController = (RDVTabBarController *)kAppDelegate.viewController;
    if (tabBarController.selectedIndex != 1) {
        [tabBarController setSelectedIndex:1];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completionHandler) {
            self.completionHandler();
        }
    }];
    
}
-(void)onResponseUserLoginFail{
    [self hideHUD];
    [MActionUtility showAlert:@"网络异常"];
    
}

- (IBAction)onRegistAction:(id)sender {
    MRegistViewController *regist = [[MRegistViewController alloc] initWithNibName:@"MRegistViewController" bundle:nil];
    [self.navigationController pushViewController:regist animated:YES];
    
}
- (IBAction)onForgetPasswordAction:(id)sender{
    MForgetPasswordViewController *forget = [[MForgetPasswordViewController alloc] initWithNibName:@"MForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forget animated:YES];
}
-(void)dealloc{
    loginAction.m_delegate_userLogin = nil;
}
@end
