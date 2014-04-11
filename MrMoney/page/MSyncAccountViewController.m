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
#import "MDesUtility.h"


#define  TEXTFIELDTAG 600

@interface MSyncAccountViewController ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)NSString *mAid;
@property(nonatomic,copy)NSString *balance;

@property(nonatomic,assign) BOOL ret;
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
    _codeImageView.userInteractionEnabled = YES;
    [_codeImageView addGestureRecognizer:singleTap];
    
    
    getCodeAction = [[MAuthCodeAction alloc] init];
    getCodeAction.m_delegate = self;
    [getCodeAction requestAction];
    [self showHUD];
    
}

-(void)uesrClicked:(id)sender{
  
    [getCodeAction requestAction];
    [self showHUD];
}


-(NSDictionary*)onRequestAuthCodeAction{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self.bank_identifie lowercaseString],@"bankCode",@"2",@"channel", nil];
}
-(void)onResponseAuthCodeSuccess:(MAuthCodeData *)authCode{
    [self hideHUD];
 
    self.authCodeData = authCode;
    self.codeImageView.image = authCode.mimg ? authCode.mimg : [UIImage imageNamed:@"btn_refresh_code"];
    
}
-(void)onResponseAuthCodeFail{
    [MActionUtility showAlert:@"网络异常"];
    [self hideHUD];
}

#pragma mark -------------  关联银行卡 delegate -----------------

-(NSDictionary*)onRequestRelateAccountAction{
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:11];
    
    [dict setSafeObject:_authCodeData.maccessId     forKey:@"AccessId"];
    [dict setSafeObject:@"2"                        forKey:@"Channel"];
    [dict setSafeObject:[MStringUtility stripWhiteSpace:(self.account.mbankCardNo)]  forKey:@"AccNum"];
    
    
    if (_ret) {
        [dict setSafeObject:[_passwordTf text]      forKey:@"Password"];
    }else {
        if (![strOrEmpty(_account.mqueryPwd) isEqualToString:@""]) {
            
            NSString *password = [MDesUtility decrypt:_account.mqueryPwd];
            
            [dict setSafeObject:password   forKey:@"Password"];
        }else{
            [dict setSafeObject:[_passwordTf text]      forKey:@"Password"];
        }
    }

    [dict setSafeObject:_codeTf.text             forKey:@"VerifCode"];
    [dict setSafeObject:self.bank_identifie      forKey:@"BankCode"];
    [dict setSafeObject:@"none"                  forKey:@"ADD"];
    [dict setSafeObject:_authCodeData.mviewId    forKey:@"ViewID"];
    
    
    if (_ret) {
         [dict setSafeObject:_nameTf.text         forKey:@"NickName"];
    }else {
        if ([strOrEmpty(_account.mname) length] == 0) {
            
            [dict setSafeObject:_nameTf.text         forKey:@"NickName"];
            
        }else{
           [dict setSafeObject:_account.mnickName         forKey:@"NickName"];
        }
    }
    
 
    
    [dict setSafeObject:@"1"                     forKey:@"LoginType"];
    [dict setSafeObject:@"1"                     forKey:@"verifyType"];
    
    return dict;
}
-(void)onResponseRelateAccountSuccess:(MAccountsData *)account{
    [self hideHUD];
    
    self.balance = account.mBalance;
    
    syncAccountAction = [[MSyncAssetAccountAction alloc] init];
    syncAccountAction.m_delegate = self;
    [syncAccountAction requestAction];
    
}
- (BOOL) isUserName{
    if([self.bank_identifie isEqualToString:@"bocom"] ||  //交通
       [self.bank_identifie isEqualToString:@"abc"] ||    //农业
       [self.bank_identifie isEqualToString:@"psbc"] ||    //邮政
       [self.bank_identifie isEqualToString:@"hxb"] ||    //华夏
       [self.bank_identifie isEqualToString:@"boc"] ||    //中国银行
       [self.bank_identifie isEqualToString:@"pab"] ||    //平安
       [self.bank_identifie isEqualToString:@"ccb"]      //建设
       )
    {
        return YES;
    }
    return NO;
}
-(void)onResponseRelateAccountFail{
    [self hideHUD];
    //重新更新UI界面
    
    _ret = YES;
    _codeTf.text = @"";
    [getCodeAction requestAction];
    
    if([self isUserName]){
        _topView.frameY = 40;
        
        _topView.frameHeight = 40.;
        _topView.hidden = NO;
        
        _middleView.frameHeight = 40.;
        _middleView.hidden = NO;
        
        _bottomView.frameHeight = 40.;
        _bottomView.hidden = NO;
        
        self.view.frameHeight = 250;
    }else {
       
        
        _topView.frameY = 40;
        
        _topView.frameHeight = 0.;
        _topView.hidden = YES;
        
        _middleView.frameHeight = 40.;
        _middleView.hidden = NO;
        
        _bottomView.frameHeight = 40.;
        _bottomView.hidden = NO;
        
        self.view.frameHeight = 215;
    }
    
    
    _middleView.frameY = _topView.frameBottom + 10;
    
    _bottomView.frameY = _middleView.frameBottom + 10;
    
    _submitBtn.frameY = _bottomView.frameBottom + 20;
    
    
//    self.codeImageView.image = [UIImage imageNamed:@"btn_refresh_code"];
    
}

#pragma mark ------------- 保存信息到本地 delegate  -----------------

-(NSDictionary*)onRequestSyncAssetAccountAction{
    MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:self.mAid forKey:@"aid"];
    [dict setSafeObject:[self.account.mbankId lowercaseString] forKey:@"bankId"];
    [dict setSafeObject:self.balance forKey:@"balances"];
    [dict setSafeObject:@"" forKey:@"products"];
    [dict setSafeObject:user.mmid forKey:@"mid"];
    [dict setSafeObject:user.msessionId forKey:@"sessionId"];
    
    if ([self isUserName]) {
        if (_ret) {
             [dict setSafeObject:_nameTf.text          forKey:@"nickName"];
        }else{
            if ([_account.mnickName length] == 0) {
                [dict setSafeObject:_nameTf.text          forKey:@"nickName"];
            }else {
                [dict setSafeObject:_account.mnickName          forKey:@"nickName"];
            }
        }
        
    }else{
          [dict setSafeObject:@"none"          forKey:@"nickName"];
    }
    

    [dict setSafeObject:@"" forKey:@"accountAddress"];
 
    if (_ret) {
        NSString *password = [MDesUtility encrypt:_passwordTf.text];
        [dict setSafeObject:password forKey:@"accountPwd"];
    }else{
        if (![strOrEmpty(_account.mqueryPwd)  isEqualToString:@""]) {
            [dict setSafeObject:_account.mqueryPwd        forKey:@"accountPwd"];
            
        }else{
            
            NSString *password = [MDesUtility encrypt:_passwordTf.text];
            [dict setSafeObject:password forKey:@"accountPwd"];
            
        }
    }

    
    return dict;
    
}
-(void)onResponseSyncAssetAccountSuccess{
     [MActionUtility showAlert:KEMPTY_STR message:@"同步成功" delegate:self cancelButtonTitle:KCONFIRM_STR otherButtonTitles:nil];
     
}
-(void)onResponseSyncAssetAccountFail{
 
//     [MActionUtility showAlert:@"同步失败"];
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
