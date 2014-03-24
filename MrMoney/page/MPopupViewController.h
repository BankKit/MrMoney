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
@protocol MPopupViewDelegate <NSObject>

-(void)popupBtnClick:(int)index;

@end

@interface MPopupViewController : UIViewController<MRelateAccountActionDelegate,MAuthCodeActionDelegate,UITextFieldDelegate,UIAlertViewDelegate,MAgreementViewDelegate,MSyncAssetAccountActionDelegate>{
    
    MAuthCodeAction *getCodeAction;
    MRelateAccountAction *relateAction;
    MSyncAssetAccountAction *syncAccountAction;
    
}

@property (strong, nonatomic) MAuthCodeData          * authCodeData;
@property (weak, nonatomic)   IBOutlet UIButton      * confirmBtn;
@property (weak, nonatomic)   IBOutlet UIButton      * cancelBtn;
@property (nonatomic,weak)   id<MPopupViewDelegate>   delegate;
@property (nonatomic,strong) MAccountsData           * account;
@property (weak, nonatomic)   IBOutlet UITableView   * tableView;
@property (strong, nonatomic) NSString               * bank_identifie;
@property (assign, nonatomic) BOOL  isCheck;

@property (strong, nonatomic) NSString *cardPassword;
@property (strong, nonatomic) NSString *authCode;
@property (strong, nonatomic) NSString *cardUserName;
@property (strong, nonatomic) NSString *cardAddress;

- (IBAction)onButtonAction:(id)sender;
- (IBAction)onClearKeyAction:(id)sender;
@end
