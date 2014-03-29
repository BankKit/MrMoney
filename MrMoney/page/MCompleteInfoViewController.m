//
//  MCompleteInfoViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-21.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCompleteInfoViewController.h"
#import "MSecurityView.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "UIViewController+style.h"
@interface MCompleteInfoViewController ()

@end

@implementation MCompleteInfoViewController

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
    [self createNavBarTitle:@"完善信息"];
 
   MSecurityView *securityView = [self securityView:_confirmPasswordTf];
   
    [self.scrollView  addSubview:securityView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, securityView.frameY + securityView.frameHeight + 5);

    

}
- (IBAction)onSubmitAction:(id)sender {
    if ([_nameTf.text length] == 0) {
        [MActionUtility showAlert:@"姓名不能为空"];
        return;
    }
    if ([_mobileTf.text length] == 0) {
        [MActionUtility showAlert:@"手机号码不能为空"];
        return;
    }
    if (![_passwordTf.text isEqualToString:_confirmPasswordTf.text]) {
        [MActionUtility showAlert:@"两次输入密码不一致"];
        return;
    }
    bindAction = [[MBindingAction alloc] init];
    bindAction.m_delegate = self;
    [bindAction requestAction];
    [self showHUD];
}
-(NSDictionary*)onRequestBindingAction{
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:4];
    
    [dict setSafeObject:self.openid forKey:@"openid"];
    
    [dict setSafeObject:_mobileTf.text forKey:@"mobile"];
    
    [dict setSafeObject:_passwordTf.text forKey:@"password"];

    [dict setSafeObject:_nameTf.text forKey:@"realname"];

    return dict;
}
-(void)onResponseBindingActionSuccess{
    [self hideHUD];
    user_defaults_set_string(@"KPASSWORD",MSMD5(_passwordTf.text));
    RDVTabBarController *tabBarController = (RDVTabBarController *)kAppDelegate.viewController;
    if (tabBarController.selectedIndex != 1) {
        [tabBarController setSelectedIndex:1];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
//        if (self.completionHandler) {
//            self.completionHandler();
//        }
         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];
    }];
    
}
-(void)onResponseBindingActionFail{
    [self hideHUDWithCompletionFailMessage:@"绑定失败"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
