//
//  MRegistViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MRegistAction.h"
#import "MObtainCodeAction.h"
#import "MLoginAction.h"
@interface MRegistViewController : MBaseViewController<MUserRegisterActionDelegate,MObtainCodeActionDelegate,UIAlertViewDelegate,MUserLoginActionDelegate>{
    MRegistAction *registAction;
    MObtainCodeAction *obtainAction;
    
    MLoginAction  *loginAction;
}

@property (weak, nonatomic) IBOutlet UIView *topContainerView;
 @property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *realNameTf;
@property (weak, nonatomic) IBOutlet UITextField *pwsTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
 
- (IBAction)onRegistAction:(id)sender;

- (IBAction)onObtainCodeAction:(id)sender;

-(IBAction)makingCallAction:(id)sender;

@end
