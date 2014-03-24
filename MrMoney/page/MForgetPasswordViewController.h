//
//  MForgetPasswordViewController.h
//  MrMoney
//
//  Created by xingyong on 14-2-15.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MObtainCodeAction.h"
#import "MForgetPasswordAction.h"
#import "MLoginViewController.h"
@interface MForgetPasswordViewController : MBaseViewController<MObtainCodeActionDelegate,MForgetPasswordActionDelegate,MUserLoginActionDelegate,UIAlertViewDelegate>{
    
    MObtainCodeAction *obtainAction;
    MForgetPasswordAction *resetAction;
    MLoginAction *loginAction;
    
}


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *realNameTf;
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;


@property(weak,nonatomic)IBOutlet UITextField *passwordTf;
@property(weak,nonatomic)IBOutlet UITextField *confirmPasswordTf;

@property (weak, nonatomic) IBOutlet UIView *resetView;
@property (weak, nonatomic) IBOutlet UIView *forgetView;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (assign, nonatomic) BOOL isFlag;

- (IBAction)onObtainCodeAction:(id)sender;
- (IBAction)onNextStepAction:(id)sender;

@end
