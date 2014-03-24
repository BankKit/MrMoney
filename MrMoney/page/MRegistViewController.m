//
//  MRegistViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MRegistViewController.h"
#import "MSecurityView.h"
#import "RDVTabBarController.h"
#import "AppDelegate.h"
#define kTimeInterval 60
@interface MRegistViewController ()
@property(assign,nonatomic)BOOL isCheck;
@property(assign,nonatomic)int count;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation MRegistViewController

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
    
    [self createNavBarTitle:@"新用户注册"];
    
    [_codeBtn setBackgroundImage:KDEFAULT_BTN forState:UIControlStateNormal];
    
    [_topContainerView.layer borderWidth:1. borderColor:KVIEW_BORDER_COLOR cornerRadius:6.];
    
      
    MSecurityView *securityView = [[MSecurityView alloc] initWithFrame:Rect(10, _topContainerView.frameHeight + _topContainerView.frameY + 20, 300, 208)];
    
    [self.scrollView  addSubview:securityView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, securityView.frameY + securityView.frameHeight + 5);
    
    
    self.isCheck = YES;
    
 
}

-(IBAction)makingCallAction:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006576676"]];
}

-(void)agreementViewButtonClick:(BOOL)check{
    self.isCheck = check;
}
#pragma mark ---
#pragma mark --- 获取验证码
- (IBAction)onObtainCodeAction:(id)sender{
    
    if ([_mobileTf.text isEqualToString:KEMPTY_STR]) {
        [MActionUtility showAlert:@"手机号不能为空"];
        
        return;
    }
    
    if (![MStringUtility isPhoneNum:_mobileTf.text]) {
        [MActionUtility showAlert:@"手机号不合法"];
        
        return;
    }
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
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"price"])
    {
//        myLabel.text = [stockForKVO valueForKey:@"price"];
//        codeBtn
    }
}

-(NSDictionary*)onRequestObtainCodeAction{
    return [MutableOrderedDictionary dictionaryWithObjectsAndKeys:_mobileTf.text,@"mobileNum", nil];
}
-(void)onResponseObtainCodeSuccess{
    NSLog(@"获取验证码成功：");
}
-(void)onResponseObtainCodeFail{
    
}
- (IBAction)onRegistAction:(id)sender {
 
    if (!self.isCheck) {
        [MActionUtility showAlert:@"请阅读并同意 使用条款和隐私政策"];
        return;
    }
    if ([_realNameTf.text isEqualToString:KEMPTY_STR]) {
        
        [MActionUtility showAlert:@"用户名不能为空"];
        return;
    }
    if (![MStringUtility isPhoneNum:_mobileTf.text]) {
            [MActionUtility showAlert:@"手机号不合法"];
       
        return;
    }
    if ([_pwsTf.text isEqualToString:KEMPTY_STR]) {
        [MActionUtility showAlert:@"密码不能为空"];
        
        return;
    }

    
    
    registAction = [[MRegistAction alloc] init];
    registAction.m_delegate_userRegister = self;
    [registAction requestUserRegister];
    
}

#pragma mark -
#pragma mark - regist delegate
-(NSDictionary*)onRequestUserRegisterAction{
    
    MutableOrderedDictionary *requestDic = [MutableOrderedDictionary dictionary];
    [requestDic setObject:strOrEmpty(_mobileTf.text) forKey:@"mobile"];
    [requestDic setObject:strOrEmpty(_realNameTf.text) forKey:@"realName"];
    [requestDic setObject:strOrEmpty(_codeTf.text) forKey:@"verifyCode"];
    [requestDic setObject:strOrEmpty(_pwsTf.text) forKey:@"pwd"];
    [requestDic setObject:@"03" forKey:@"regChannel"];
    
    return requestDic;
    
    
}
-(void)onResponseUserRegisterSuccess{
    [MActionUtility showAlert:nil message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:KCONFIRM_STR,nil];
}
-(void)onResponseUserRegisterFail{
    [MActionUtility showAlert:@"注册失败"];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    
    if (buttonIndex == 0) {
        loginAction = [[MLoginAction alloc] init];
        loginAction.m_delegate_userLogin = self;
        [loginAction requestUserLogin];

    }
}


#pragma mark -
#pragma mark - login delegate
-(NSDictionary*)onRequestUserLoginAction{
    
    MutableOrderedDictionary *requestDic =  [MutableOrderedDictionary dictionary];
    
    [requestDic setObject:_mobileTf.text forKey:@"username"];
    [requestDic setObject:_pwsTf.text forKey:@"password"];
    
    
    return requestDic;
}

-(void)onResponseUserLoginSuccess{
    [self hideHUD];
    [self.navigationController popViewControllerAnimated:YES];

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
    registAction.m_delegate_userRegister = nil;
    obtainAction.m_delegate = nil;
    loginAction.m_delegate_userLogin = nil;
    [_timer invalidate];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
