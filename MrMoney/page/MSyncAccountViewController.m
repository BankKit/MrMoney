//
//  MPopupViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-15.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSyncAccountViewController.h"
#import "MTextFieldCell.h"
#import "MAuthCodeData.h"
#import "MAccountsData.h"
#import "MUserData.h"
#import "UIViewController+MaryPopin.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "GTMBase64.h"
#import "DesUtil.h"
#import "Utility.h"

#define  TEXTFIELDTAG 600

@interface MSyncAccountViewController ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)NSString *mAid;
@property(nonatomic,copy)NSString *balance;
@end

@implementation MSyncAccountViewController

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
    
    self.isCheck = YES;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bank_identifie = [self.account.mbankId lowercaseString];
 
    self.mAid = self.account.maid;
    
//   NSString *kpwd = STRING_FORMAT(@"%@%@",MSMD5(userMid()),PWD_K2);
//    
//    NSString *password = [Utility decryptStr:_account.mqueryPwd key:kpwd];
    NSString *password  = [Utility TripleDES:@"abcdefg" encryptOrDecrypt:kCCEncrypt];
//    NSString *password  =  [Utility encryptStr:@"abcdefg" key:PWD_K2];

     NSLog(@"---------- 加密 ------------------%@ \n\n",MSMD5(@"abcdefg"));
 
    _topView.frameY = 40;
    
    
    if ([strOrEmpty(_account.mname) isEqualToString:@""]) {
           self.view.frameHeight = 250;
    }else if (![strOrEmpty(_account.mqueryPwd) isEqualToString:@""]) {
        
        _topView.frameHeight = 0.;
        _topView.hidden = YES;
        _middleView.frameHeight = 0.;
        _middleView.hidden = YES;
        
        self.view.frameHeight = 175;
        
    }else{
        _topView.frameHeight = 0.;
        _topView.hidden = YES;
        
        self.view.frameHeight = 215;
        
    }
    
    
    _middleView.frameY = _topView.frameBottom + 10;
    
    _bottomView.frameY = _middleView.frameBottom + 10;
    
    _submitBtn.frameY = _bottomView.frameBottom + 20;
    
    self.scrollView.frame = self.view.bounds;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uesrClicked:)];
    [_codeImageView addGestureRecognizer:singleTap];
    
    
    getCodeAction = [[MAuthCodeAction alloc] init];
    getCodeAction.m_delegate = self;
    [getCodeAction requestAction];
    [self showHUD];
    
}

-(void)uesrClicked:(id)sender{
      [getCodeAction requestAction];
}


-(NSDictionary*)onRequestAuthCodeAction{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self.bank_identifie lowercaseString],@"bankCode",@"2",@"channel", nil];
}
-(void)onResponseAuthCodeSuccess:(MAuthCodeData *)authCode{
    [self hideHUD];
    self.authCodeData = authCode;
    self.codeImageView.image =  authCode.mimg ? authCode.mimg : [UIImage imageNamed:@"btn_refresh_code"];
    
}
-(void)onResponseAuthCodeFail{
    [self hideHUD];
}

#pragma mark -------------  关联银行卡 delegate -----------------

-(NSDictionary*)onRequestRelateAccountAction{
    
    
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:11];
    
    [dict setSafeObject:_authCodeData.maccessId     forKey:@"AccessId"];
    [dict setSafeObject:@"2"                        forKey:@"Channel"];
    [dict setSafeObject:[MStringUtility stripWhiteSpace:(self.account.mbankCardNo)]  forKey:@"AccNum"];
    
     
    if (![strOrEmpty(_account.mqueryPwd) isEqualToString:@""]) {
        
        NSString *kpwd = STRING_FORMAT(@"%@%@",MSMD5(userMid()),PWD_K2);
        
        NSString *password = [Utility decryptStr:_account.mqueryPwd key:kpwd];

        [dict setSafeObject:password   forKey:@"Password"];
    }else{
        [dict setSafeObject:[_passwordTf text]      forKey:@"Password"];
    }
    
    [dict setSafeObject:_codeTf.text               forKey:@"VerifCode"];
    
    [dict setSafeObject:self.bank_identifie        forKey:@"BankCode"];
    [dict setSafeObject:@"none"                        forKey:@"ADD"];
    [dict setSafeObject:_authCodeData.mviewId       forKey:@"ViewID"];
    
    [dict setSafeObject:@""         forKey:@"NickName"];
    [dict setSafeObject:@"1"                        forKey:@"LoginType"];
    [dict setSafeObject:@"1"                        forKey:@"verifyType"];
    
    return dict;
}
-(void)onResponseRelateAccountSuccess:(MAccountsData *)account{
    [self hideHUD];
    
    self.balance = account.mBalance;
    
    syncAccountAction = [[MSyncAssetAccountAction alloc] init];
    syncAccountAction.m_delegate = self;
    [syncAccountAction requestAction];
    
}
-(void)onResponseRelateAccountFail{
    [self hideHUD];
    
     self.codeImageView.image = [UIImage imageNamed:@"btn_refresh_code"];
    
}

#pragma mark ------------- 同步银行卡号到本地 delegate  -----------------

-(NSDictionary*)onRequestSyncAssetAccountAction{
    MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:self.mAid forKey:@"aid"];
    [dict setSafeObject:[self.account.mbankId lowercaseString] forKey:@"bankId"];
    [dict setSafeObject:self.balance forKey:@"balances"];
    [dict setSafeObject:@"" forKey:@"products"];
    [dict setSafeObject:user.mmid forKey:@"mid"];
    [dict setSafeObject:user.msessionId forKey:@"sessionId"];
    [dict setSafeObject:@"none"          forKey:@"nickName"];
    [dict setSafeObject:@"" forKey:@"accountAddress"];
 
    if (![strOrEmpty(_account.mqueryPwd)  isEqualToString:@""]) {
        [dict setSafeObject:_account.mqueryPwd        forKey:@"accountPwd"];
       
    }else{
        NSString *kpwd = STRING_FORMAT(@"%@%@",MSMD5(userMid()),PWD_K2);
        
        NSString *password = [Utility encryptStr:[_passwordTf text] key:kpwd];
        
        [dict setSafeObject:password forKey:@"accountPwd"];
    
    }
    
    return dict;
    
}
-(void)onResponseSyncAssetAccountSuccess{
     [MActionUtility showAlert:KEMPTY_STR message:@"同步成功" delegate:self cancelButtonTitle:KCONFIRM_STR otherButtonTitles:nil];
     
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        __weak MSyncAccountViewController *wself = self;
        
        [self bk_performBlock:^(id obj) {
            [wself.navigationController dismissCurrentPopinControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_ADDCOUNT object:wself];
                
            }];
        } afterDelay:0.6];
      
      
    }
}

-(void)onResponseSyncAssetAccountFail{
//    [MActionUtility showAlert:@"同步失败"];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)agreementViewButtonClick:(BOOL)check{
    self.isCheck = check;
}
- (IBAction)onButtonAction:(id)sender {
    [_passwordTf resignFirstResponder];
    [_codeTf resignFirstResponder];
    
    NSInteger index = [(UIButton *)sender tag];
    
    if (self.isCheck) {
        if (index == 2) {
            relateAction = [[MRelateAccountAction alloc] init];
            relateAction.m_delegate = self;
            [relateAction requestAction];
            [self showHUD];
        }else if(index == 1){
            
            [self.navigationController dismissCurrentPopinControllerAnimated:YES completion:^{
                
            }];
            
        }
        
    }else{
        
        [MActionUtility showAlert:@"请阅读并同意 使用条款和隐私政策"];
        return ;
    }
}




@end
