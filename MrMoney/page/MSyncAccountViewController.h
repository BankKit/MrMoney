//
//  MPopupViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-15.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MAccountsData;
@class MAuthCodeData;
#import "MRelateAccountAction.h"
#import "MAuthCodeAction.h"
#import "MAgreementView.h"
#import "MSyncAssetAccountAction.h"



@interface MSyncAccountViewController : UIViewController<MRelateAccountActionDelegate,MAuthCodeActionDelegate,UITextFieldDelegate,UIAlertViewDelegate,MAgreementViewDelegate,MSyncAssetAccountActionDelegate>{
    
    MAuthCodeAction *getCodeAction;
    MRelateAccountAction *relateAction;
    MSyncAssetAccountAction *syncAccountAction;
    
}

@property (strong, nonatomic) MAuthCodeData          * authCodeData;

@property (nonatomic,strong) MAccountsData           * account;
 
@property (strong, nonatomic) NSString               * bank_identifie;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;

@property (assign, nonatomic) BOOL  isCheck;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)onButtonAction:(id)sender;
 
@end
