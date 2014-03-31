//
//  MRelateAccountViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-16.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MRelateAccountViewController.h"
#import "MTextFieldCell.h"
#import "MAccountsData.h"
#import "MAuthCodeData.h"
#import "MWalletViewController.h"
#import "MSecurityView.h"
#import "MUserData.h"
#import "UIViewController+style.h"
#ifndef TEXTFIELDTAG
#define TEXTFIELDTAG 2000
#endif
@interface MRelateAccountViewController ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)MAccountsData *account;
@property(nonatomic,assign) NSInteger buttonIndex;
@end

@implementation MRelateAccountViewController

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
    
    [self createNavBarTitle:@"关联账号"];
    
    self.tableView.rowHeight = 40.0f;
    
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
        
        self.titleArray =  @[ [self.bank_identifie isEqualToString:@"alipay"]?@"用户名:":@"卡号:",@"查询密码:",@"验证码:"];
        self.placeholderArray = @[@"输入银行卡号",@"输入大众版网银查询密码",@"验证码"];
    }else if([self.bank_identifie isEqualToString:@"bocom"] ||  //交通
             [self.bank_identifie isEqualToString:@"abc"] ||    //农业
             [self.bank_identifie isEqualToString:@"psbc"] ||    //邮政
             [self.bank_identifie isEqualToString:@"hxb"] ||    //华夏
             [self.bank_identifie isEqualToString:@"boc"] ||    //中国银行
             [self.bank_identifie isEqualToString:@"pab"] ||    //平安
             [self.bank_identifie isEqualToString:@"ccb"]      //建设
             ){
        
        self.titleArray =  @[@"卡号:",@"用户名:",@"查询密码:",@"验证码:"];
        self.placeholderArray = @[@"输入银行卡号",@"输入大众版网银登录用户名",@"输入大众版网银查询密码",@"验证码"];
    }else if([self.bank_identifie isEqualToString:@"cmb"]
             
             ){
        self.titleArray =  @[@"卡号:",@"卡开户地:",@"查询密码:",@"验证码:"];
        self.placeholderArray = @[@"输入银行卡号",@"请选择开户地",@"输入大众版网银查询密码",@"验证码"];
        
        
    }
    
    if (self.ptype == MPushWalletType) {
        _contentView.hidden = NO;
        
        
        
    }else{
        _contentView.hidden = YES;
        _mainView.frame = CGRectMake(10, 20, 300, 233);
        
        [self.scrollView addSubview:_mainView];
    }
    
    MSecurityView *securityView = [self securityView:_contentView];
    
    securityView.backgroundColor = [UIColor whiteColor];
    [self.scrollView  addSubview:securityView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, securityView.frameY + securityView.frameHeight + 5);
    
    self.tableView.backgroundView = nil;
    
    
    if (self.ptype == MPushWalletType) {
        getCodeAction = [[MAuthCodeAction alloc] init];
        getCodeAction.m_delegate = self;
        [getCodeAction requestAction];
        [self showHUD];
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
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
    
    if (row == count - 1) {
        
        cell.codeImageView.hidden = NO;
        cell.codeImageView.tag = 888;
        cell.codeImageView.image =  self.authCodeData.mimg ? self.authCodeData.mimg : [UIImage imageNamed:@"btn_refresh_code"];
        cell.touchCompletionBlock = ^{
            [getCodeAction requestAction];
        };
    }else if(row == count - 2){
        cell.field.secureTextEntry = YES;
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
        self.cardNo = textField.text;
    }else if(tag == count - 2){
        self.cardPassword = textField.text;
    }else if(tag == count - 1){
        self.authCode = textField.text;
    }else {
        self.cardUserName = textField.text;
    }
    
}


-(void)onSubmitAction:(id)sender{
    self.buttonIndex =  [(UIButton *)sender tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.titleArray count] - 1 inSection:0];
    MTextFieldCell *cell = (MTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    
    if (self.buttonIndex == 1) {
        relateAction = [[MRelateAccountAction alloc] init];
        relateAction.m_delegate = self;
        [relateAction requestAction];
        [self showHUD];
    }else{
        appendAccountAction = [[MAppendAssetAccountAction alloc] init];
        
        appendAccountAction.m_delegate = self;
        
        [appendAccountAction requestAction];
        [self showHUD];
    }
    
}

#pragma mark -------------  关联银行账户 -----------------

-(NSDictionary*)onRequestRelateAccountAction{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setSafeObject:_authCodeData.maccessId     forKey:@"AccessId"];
    [dict setSafeObject:@"2"                        forKey:@"Channel"];
    [dict setSafeObject:self.cardNo                 forKey:@"AccNum"];
    [dict setSafeObject:self.cardPassword           forKey:@"Password"];
    [dict setSafeObject:self.authCode               forKey:@"VerifCode"];
    [dict setSafeObject:[self.bank_identifie lowercaseString]         forKey:@"BankCode"];
    [dict setSafeObject:@"none"                    forKey:@"ADD"];
    [dict setSafeObject:_authCodeData.mviewId       forKey:@"ViewID"];
    [dict setSafeObject:self.cardUserName           forKey:@"NickName"];
    [dict setSafeObject:@"1"                        forKey:@"LoginType"];
    [dict setSafeObject:@"1"                        forKey:@"verifyType"];
    
    return dict;
}
-(void)onResponseRelateAccountSuccess:(MAccountsData *)account{
    [self hideHUD];
    self.account = account;
    
    
    appendAccountAction = [[MAppendAssetAccountAction alloc] init];
    
    appendAccountAction.m_delegate = self;
    
    [appendAccountAction requestAction];
    [self showHUD];
    
    
}

-(void)onResponseRelateAccountFail{
    [self hideHUD];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.titleArray count] - 1 inSection:0];
    MTextFieldCell *cell = (MTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:888];
    imageView.image = [UIImage imageNamed:@"btn_refresh_code"];
    [MActionUtility showAlert:@"请求超时"];
}



#pragma mark ------------- 关联银行账户信息到本地 -----------------

-(NSDictionary*)onRequestAppendAssetAccountAction{
    
    MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:13];
    
    if (_buttonIndex == 1) {
        [dict setSafeObject:[self.account.mbankId uppercaseString] forKey:@"bankId"];
        [dict setSafeObject:@"00" forKey:@"accountType"];
        [dict setSafeObject:self.account.mAccNum   forKey:@"accountNum"];
        [dict setSafeObject:self.account.mname forKey:@"aName"];
        [dict setSafeObject:self.account.mBalance forKey:@"balances"];
        [dict setSafeObject:@"" forKey:@"products"];
        [dict setSafeObject:user.mmid forKey:@"mid"];
        [dict setSafeObject:user.msessionId forKey:@"sessionId"];
        [dict setSafeObject:@"" forKey:@"accountAddress"];
        [dict setSafeObject:[MSMD5(self.cardPassword) uppercaseString]  forKey:@"queryPwd"];
        [dict setSafeObject:@"" forKey:@"nickName"];
        [dict setSafeObject:@"" forKey:@"openAddress"];
        [dict setSafeObject:@"0" forKey:@"loginType"];
    }else{
        [dict setSafeObject:self.bank_identifie forKey:@"bankId"];
        [dict setSafeObject:@"00" forKey:@"accountType"];
        [dict setSafeObject:_cardNoTf.text   forKey:@"accountNum"];
        [dict setSafeObject:_cardNameTf.text forKey:@"aName"];
        [dict setSafeObject:@"" forKey:@"balances"];
        [dict setSafeObject:@"" forKey:@"products"];
        [dict setSafeObject:user.mmid forKey:@"mid"];
        [dict setSafeObject:user.msessionId forKey:@"sessionId"];
        [dict setSafeObject:@"" forKey:@"accountAddress"];
        [dict setSafeObject:@""  forKey:@"queryPwd"];
        [dict setSafeObject:_cardNameTf.text forKey:@"nickName"];
        [dict setSafeObject:_cardAddressTf.text forKey:@"openAddress"];
        [dict setSafeObject:@"0" forKey:@"loginType"];
    }
     
    return dict;
}
-(void)onResponseAppendAssetAccountSuccess{
    [self hideHUD];
    [MActionUtility showAlert:KEMPTY_STR message:@"添加成功" delegate:self cancelButtonTitle:KCONFIRM_STR otherButtonTitles:nil];
}
-(void)onResponseAppendAssetAccountFail{
    [self hideHUD];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSArray *array =  [self.navigationController viewControllers];
        MBaseViewController *viewController = [array objectAtIndex:2];
        if ([viewController isKindOfClass:[MWalletViewController class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_ADDCOUNT object:self];
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
    }
}
-(void)dealloc{
    getCodeAction.m_delegate = nil;
    relateAction.m_delegate = nil;
    appendAccountAction.m_delegate = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
