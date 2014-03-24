//
//  MRelateAccountViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-16.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MAuthCodeData.h"
#import "MRelateAccountAction.h"
#import "MAuthCodeAction.h"
#import "MAppendAssetAccountAction.h"
@interface MRelateAccountViewController : MBaseViewController<MRelateAccountActionDelegate,UITextFieldDelegate,MAuthCodeActionDelegate,UIAlertViewDelegate,MAppendAssetAccountActionDelegate>{
    MAuthCodeAction *getCodeAction;
    MRelateAccountAction *relateAction;
    MAppendAssetAccountAction *appendAccountAction;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) MAuthCodeData *authCodeData;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *bank_identifie;


@property (strong, nonatomic) NSString *cardNo;
@property (strong, nonatomic) NSString *cardPassword;
@property (strong, nonatomic) NSString *authCode;
@property (strong, nonatomic) NSString *cardUserName;
@property (strong, nonatomic) NSString *cardAddress;

-(IBAction)onSubmitAction:(id)sender;
@end
