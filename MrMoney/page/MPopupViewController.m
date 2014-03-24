//
//  MPopupViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-15.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MPopupViewController.h"
#import "MTextFieldCell.h"
#import "MAuthCodeData.h"
#import "MAccountsData.h"
#import "MUserData.h"
#define  TEXTFIELDTAG 600
@interface MPopupViewController ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)NSString *mAid;
@end

@implementation MPopupViewController

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
    [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"btn_account_bind"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_account_bind"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
    self.view.backgroundColor = KVIEW_BACKGROUND_COLOR;

    self.bank_identifie = [self.account.mbankId lowercaseString];
    self.tableView.rowHeight = 40.0f;
    
 
    if ([self.bank_identifie isEqualToString:@"pabacct"]) {
        self.bank_identifie = @"pab";
    }
//      NSLog(@"-------------------------------%@ \n\n",self.bank_identifie);
    
    if ([self.bank_identifie isEqualToString:@"icbc"] || //工商
        [self.bank_identifie isEqualToString:@"spdb"] || //浦发
        [self.bank_identifie isEqualToString:@"cmbc"] || //民生
        [self.bank_identifie isEqualToString:@"cgb"] || //广发
        [self.bank_identifie isEqualToString:@"cib"] || //兴业
        [self.bank_identifie isEqualToString:@"cncb"] || //中信
        [self.bank_identifie isEqualToString:@"bob"] || //北京
        [self.bank_identifie isEqualToString:@"ceb"] || //光大
        [self.bank_identifie isEqualToString:@"srcb"] || //农商
        [self.bank_identifie isEqualToString:@"alipay"]  //支付宝
        
        ) {
        
        self.titleArray =  @[@"查询密码:",@"验证码:"];
        self.placeholderArray = @[ @"输入大众版网银查询密码",@"验证码"];
    }else if([self.bank_identifie isEqualToString:@"bocom"] ||  //交通
             [self.bank_identifie isEqualToString:@"abc"] ||    //农业
             [self.bank_identifie isEqualToString:@"psbc"] ||    //邮政
             [self.bank_identifie isEqualToString:@"hxb"] ||    //华夏
             [self.bank_identifie isEqualToString:@"boc"] ||    //中国银行
             [self.bank_identifie isEqualToString:@"pab"] ||    //平安
             [self.bank_identifie isEqualToString:@"ccb"]      //建设
             ){
        
        self.titleArray =  @[ @"用户名:",@"查询密码:",@"验证码:"];
        self.placeholderArray = @[ @"输入大众版网银登录用户名",@"输入大众版网银查询密码",@"验证码"];
    }else if([self.bank_identifie isEqualToString:@"cmb"]
             
             ){
        self.titleArray =  @[ @"卡开户地:",@"查询密码:",@"验证码:"];
        self.placeholderArray = @[ @"请选择开户地",@"输入大众版网银查询密码",@"验证码"];
        
        
    }
    self.mAid = self.account.maid;

    self.tableView.backgroundView = nil;
    
    getCodeAction = [[MAuthCodeAction alloc] init];
    getCodeAction.m_delegate = self;
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
    
    [self.tableView reloadData];
}
-(void)onResponseAuthCodeFail{
    [self hideHUD];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    MTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int row = [indexPath row];
    if (cell == nil) {
        cell = [[MTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int count = [self.titleArray count];
    
    if (row == 0) {
        cell.field.secureTextEntry = YES;
//       cell.field.text = self.account.mqueryPwd;
 
    }else if (row == count - 1) {
        
        cell.codeImageView.hidden = NO;
        cell.codeImageView.tag = 888;
        cell.codeImageView.image =  self.authCodeData.mimg ? self.authCodeData.mimg : [UIImage imageNamed:@"btn_refresh_code"];
        cell.touchCompletionBlock = ^{
             [getCodeAction requestAction];
        };
    }
    
    [cell.field setTag:TEXTFIELDTAG + row];
    cell.field.delegate = self;
    cell.field.placeholder = self.placeholderArray[row];
    cell.label.text = self.titleArray[row];
    
    return cell;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    int tag = textField.tag-TEXTFIELDTAG;
    
    int count = [self.titleArray count];
    
    
    if(tag == 0){
        self.cardPassword = textField.text;
    }else if(tag == count - 1){
        self.authCode = textField.text;
    }else {
        self.cardUserName = textField.text;
    }
//    http://robot.qianxs.com:888/mrServer/IronRobot_Login?1163_2_6222021001126425427_xy723511_Apjx_icbc_shanghai_00105086__1_1
    
}
 

-(NSDictionary*)onRequestRelateAccountAction{
    NSLog(@"(self.account.mbankCardNo)=------%@",self.account.mbankCardNo);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setSafeObject:_authCodeData.maccessId     forKey:@"AccessId"];
    [dict setSafeObject:@"2"                        forKey:@"Channel"];
    [dict setSafeObject:[MStringUtility stripWhiteSpace:(self.account.mbankCardNo)]    forKey:@"AccNum"];
    [dict setSafeObject:self.cardPassword           forKey:@"Password"];
    [dict setSafeObject:self.authCode               forKey:@"VerifCode"];
    [dict setSafeObject:[self.bank_identifie lowercaseString]         forKey:@"BankCode"];
    [dict setSafeObject:@"1"                    forKey:@"ADD"];
    [dict setSafeObject:_authCodeData.mviewId       forKey:@"ViewID"];
    [dict setSafeObject:self.cardUserName           forKey:@"NickName"];
    [dict setSafeObject:@"1"                        forKey:@"LoginType"];
    [dict setSafeObject:@"1"                        forKey:@"verifyType"];
    
    return dict;
}
-(void)onResponseRelateAccountSuccess:(MAccountsData *)account{
    [self hideHUD];
     self.account = account;
    
    syncAccountAction = [[MSyncAssetAccountAction alloc] init];
    syncAccountAction.m_delegate = self;
    [syncAccountAction requestAction];

}
-(void)onResponseRelateAccountFail{
    [self hideHUD];

}


/**
 * 同步银行信息
 */
-(NSDictionary*)onRequestSyncAssetAccountAction{
    MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
 
    
    [dict setSafeObject:self.mAid forKey:@"aid"];
    [dict setSafeObject:self.account.mbankId forKey:@"bankId"];
    [dict setSafeObject:self.account.mBalance forKey:@"balances"];
    [dict setSafeObject:@"" forKey:@"products"];
    [dict setSafeObject:user.mmid forKey:@"mid"];
    [dict setSafeObject:user.msessionId forKey:@"sessionId"];
    [dict setSafeObject:@"" forKey:@"nickName"];
    [dict setSafeObject:@"" forKey:@"accountAddress"];
    [dict setSafeObject:[MSMD5(self.cardPassword) uppercaseString]  forKey:@"accountPwd"];
 
    
    return dict;

}
-(void)onResponseSyncAssetAccountSuccess{
    [MActionUtility showAlert:KEMPTY_STR message:@"同步成功" delegate:self cancelButtonTitle:KCONFIRM_STR otherButtonTitles:nil];
}
-(void)onResponseSyncAssetAccountFail{
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupBtnClick:)]) {
            [self.delegate popupBtnClick:2];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClearKeyAction:(id)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.titleArray count] - 1 inSection:0];
    MTextFieldCell *cell = (MTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}
-(void)agreementViewButtonClick:(BOOL)check{
    self.isCheck = check;
}
- (IBAction)onButtonAction:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.titleArray count] - 1 inSection:0];
    MTextFieldCell *cell = (MTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    int index = [(UIButton *)sender tag];
    if (self.isCheck) {
        if (index == 2) {
            relateAction = [[MRelateAccountAction alloc] init];
            relateAction.m_delegate = self;
            [relateAction requestAction];
            [self showHUD];
        }else if(index == 1){
            if (self.delegate && [self.delegate respondsToSelector:@selector(popupBtnClick:)]) {
                [self.delegate popupBtnClick:1];
            }
        }
        
    }else{
        
        [MActionUtility showAlert:@"请阅读并同意 使用条款和隐私政策"];
        return ;
    }
   }
@end
