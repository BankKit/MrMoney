//
//  MForgetPasswordViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-15.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MForgetPasswordViewController.h"
#import "MSecurityView.h"
#import "RDVTabBarController.h"
#import "AppDelegate.h"
#import "UIViewController+style.h"
#define kTimeInterval 60


@interface MForgetPasswordViewController ()
@property(assign,nonatomic)int count;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation MForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ---
#pragma mark --- 获取验证码
- (IBAction)onObtainCodeAction:(id)sender{
    _count = kTimeInterval;
    UIButton *button = (UIButton *)sender;
    //短信已发送,剩下40秒
    button.userInteractionEnabled = NO;
    
    [self  bk_performBlock:^(id obj) {
        
        button.userInteractionEnabled = YES;
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button.titleLabel setFont:SYSTEMFONT(14)];
        [button setBackgroundImage:KDEFAULT_BTN forState:UIControlStateNormal];
        
    } afterDelay:kTimeInterval];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    obtainAction = [[MObtainCodeAction alloc] init];
    obtainAction.m_delegate = self;
    [obtainAction requestAction];
}
-(void)updateUI:(NSTimer *)timer{
    if (_count == 0) {
        [timer invalidate];
        
    }else{
        
        NSString *title = STRING_FORMAT(@"短信已发送,剩下%d秒",--_count);
        [_codeBtn setTitle:title forState:UIControlStateNormal];
        [_codeBtn.titleLabel setFont:SYSTEMFONT(12)];
        [_codeBtn setBackgroundImage:KDEFAULT_GRAY_BTN forState:UIControlStateNormal];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

-(NSDictionary*)onRequestObtainCodeAction{
    return [MutableOrderedDictionary dictionaryWithObjectsAndKeys:_mobileTf.text,@"mobileNum", nil];
}
-(void)onResponseObtainCodeSuccess{
    NSLog(@"获取验证码成功：");
}
-(void)onResponseObtainCodeFail{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createNavBarTitle:@"找回密码"];
    
    
    [_topView.layer borderWidth:1. borderColor:KVIEW_BORDER_COLOR cornerRadius:6.];
    
    MSecurityView *securityView = [self securityView:_topView];
    
    [self.scrollView  addSubview:securityView];
    
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, securityView.frameY + securityView.frameHeight + 5);
    
    
}
- (IBAction)onNextStepAction:(id)sender{
    if ([_mobileTf.text isEqualToString:KEMPTY_STR]) {
        [MActionUtility showAlert:@"手机号码不能为空"];
        return;
    }
    if (![MStringUtility isPhoneNum:_mobileTf.text]) {
        [MActionUtility showAlert:@"手机号不合法"];
        
        return;
    }
    if ([_codeTf.text isEqualToString:KEMPTY_STR]) {
        [MActionUtility showAlert:@"验证码不能为空"];
        
        return;
    }

    
    UIButton *button = (UIButton *)sender;
    
    [button setTitle:@"完成" forState:UIControlStateNormal];
 
    _resetView.hidden = NO;
    _forgetView.hidden = YES;
    self.isFlag = !self.isFlag;
    
    if (!self.isFlag) {
        resetAction = [[MForgetPasswordAction alloc] init];
        resetAction.m_delegate = self;
        [resetAction requestAction];
    }
    
}
#pragma mark -
#pragma mark - 重设密码 delegate
-(NSDictionary*)onRequestForgetPasswordAction{
    MutableOrderedDictionary  *dict = [MutableOrderedDictionary dictionary];
    
    [dict setSafeObject:_mobileTf.text forKey:@"mobile"];

    [dict setSafeObject:_codeTf.text forKey:@"verifyCode"];
    
    [dict setSafeObject:_passwordTf.text forKey:@"pwd"];
  
    return dict;
}
-(void)onResponseForgetPasswordSuccess{
    //重新登录

    self.isFlag = NO;
    [MActionUtility showAlert:nil message:@"重设密码成功" delegate:self cancelButtonTitle:nil otherButtonTitles:KCONFIRM_STR,nil];
    
 
}
-(void)onResponseForgetPasswordFail{
    self.isFlag = NO;
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //重新登录
        loginAction  = [[MLoginAction alloc] init];
        loginAction.m_delegate_userLogin = self;
        [loginAction requestUserLogin];
    }
}
#pragma mark -
#pragma mark - login delegate
-(NSDictionary*)onRequestUserLoginAction{
    
    MutableOrderedDictionary *requestDic =  [MutableOrderedDictionary dictionary];
    
    [requestDic setObject:_mobileTf.text forKey:@"username"];
    [requestDic setObject:_passwordTf.text forKey:@"password"];
    
    return requestDic;
}

-(void)onResponseUserLoginSuccess{
    [self hideHUD];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    RDVTabBarController *tabBarController = (RDVTabBarController *)kAppDelegate.viewController;
    
    if (tabBarController.selectedIndex != 1) {
        [tabBarController setSelectedIndex:1];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];
    }];
    
}
-(void)onResponseUserLoginFail{
    [self hideHUD];
    [MActionUtility showAlert:@"网络异常"];
    
}

-(void)dealloc{
    loginAction.m_delegate_userLogin = nil;
    resetAction.m_delegate = nil;
    obtainAction.m_delegate = nil;
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
