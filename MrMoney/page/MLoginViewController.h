//
//  MLoginViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MLoginAction.h"
#import "MQQAuthAction.h"
@interface MLoginViewController : MBaseViewController<MUserLoginActionDelegate,TencentSessionDelegate,MQQAuthActionDelegate>{
    MLoginAction  *loginAction;
    TencentOAuth* _tencentOAuth;
    MQQAuthAction *authAction;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (copy, nonatomic) loginBlockHandler completionHandler;

- (IBAction)onLoginAction:(id)sender;
- (IBAction)onRegistAction:(id)sender;
- (IBAction)onForgetPasswordAction:(id)sender;
- (IBAction)onClickTencentOAuth:(id)sender;

@property (nonatomic,strong)NSMutableArray* permissions;

@end
