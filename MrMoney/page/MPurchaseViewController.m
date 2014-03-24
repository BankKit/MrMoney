//
//  MPurchaseViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-7.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MPurchaseViewController.h"
#import "MProductBriefCell.h"
#import "MFinanceProductData.h"
#import "MProductDetailViewController.h"
#import "MAccountCell.h"
#import "MFieldCell.h"
#import "MBankCell.h"
#import "MProtocolCell.h"
#import "MUserData.h"
#import "rmb_convert.h"
#import "IPAddress.h"
#import "MBankViewController.h"
#define KBTN_TAG 1000

@interface MPurchaseViewController ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *editFieldArray;
@property(nonatomic,strong)NSMutableArray *upperArray;
@property(nonatomic,strong)MOrderData *orderData;
@property(nonatomic,copy)NSString *deviceIP;
@property(nonatomic,copy)NSString *emailAddress;
@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,copy)NSString *bankPayStyle;
@property(nonatomic,assign)int  buttonIndex;

@end

@implementation MPurchaseViewController

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
    
    [self createNavBarTitle:@"购买理财产品"];
    
    self.buttonIndex = 100;
    self.tableView.backgroundView = nil;
    
    self.titleArray       = @[@"购买金额 : ",@"预期收益 : "];
    
    self.bankArray        = [KPAY_DICT allKeys];
     
    self.deviceIP         = [MUtility deviceIPAdress];
    
//    NSLog(@"-------- self.deviceIP---- %@", self.deviceIP);
    
    if ([self.deviceIP isEqualToString:@"(null)"]){
       self.deviceIP  = @"192.168.1.100";
    }
  
    
    NSString *upper_money  = [NSString stringWithUTF8String:to_upper_rmb([self.buyMoney floatValue])];

    
    float value = [MUtility expectEarning:self.data];
    
    NSString *earn =  [NSString stringWithFormat:@"%.2f",value * [self.buyMoney floatValue]];

    self.editFieldArray   = [NSMutableArray arrayWithObjects:self.buyMoney,earn,nil];
    
    self.isChecked        = YES;

    _nextStepBtn.enabled  = self.isChecked;
   
    NSString *upperStr = STRING_FORMAT(@"金额大写: %@",upper_money);
    self.upperArray = [NSMutableArray arrayWithObjects:upperStr, nil];
    
}


-(IBAction)nextStepAction:(id)sender{
    
    int  amount =  [[self.editFieldArray safeObjectAtIndex:0] intValue];
  
    self.payTypeName = [MUtility payName:self.bankPayStyle];
    if (amount <= 0) {
        
        [MActionUtility showAlert:@"购买金额不能为空"];
        return;
    }
    
    if (!self.payTypeName) {
        
        [MActionUtility showAlert:@"请选择支付方式"];
        return;
    }
    
    if (![self.bankArray containsObject:self.bankPayStyle]) {
        if (amount > [self.bankPayStyle intValue]) {
            [MActionUtility showAlert:@"购买金额过大"];
            return;
        }
        balanceAction = [[MBalanceAction alloc] init];
        balanceAction.m_delegate = self;
        [balanceAction requestAction];
        [self showHUD];
    }else{
        
        if ([self.payTypeName isEqualToString:@"OTHERBANKS"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入邮箱地址" message:@"产品购买链接将会发送到您的邮箱，请在电脑上根据邮件提示完成购买" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:KCONFIRM_STR, nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *oldTf=[alert textFieldAtIndex:0];
            alert.tag =200;
            MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
            oldTf.text = user.memail;
            
            [alert show];
        }else{
            submitAction = [[MSubmitOrderAction alloc] init];
            submitAction.m_delegate = self;
            [submitAction requestAction];
            [self showHUD];
            
        }

    }
    
}
#pragma mark --
#pragma mark -- 余额购买 delegate
-(NSDictionary*)onRequestBalanceAction{
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:3];
    
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:self.data.mpid forKey:@"pid"];
    
    int  amount =  [[self.editFieldArray safeObjectAtIndex:0] intValue];
    
    [dict setSafeObject:[NSNumber numberWithInt:amount] forKey:@"investMoney"];
    
    return dict;
}
-(void)onResponseBalanceSuccess:(NSString *)orderNo{
 
    __weak MPurchaseViewController *wself = self;
    [self hideHUDWithCompletionMessage:@"交易成功" finishedHandler:^{
//        NSString *url = [NSString stringWithFormat:@"http://www.qianxs.com/mrMoney/portal/payOrder/showRecord.html?OrderNo=%@",orderNo];

        [MGo2PageUtility go2MWebBrowser:wself title:@"支付结果" webUrl:KSHOW_RECORD(orderNo)];
    }];
}

-(void)onResponseBalanceFail{
    
    [self hideHUDWithCompletionFailMessage:@"交易失败"];

}

#pragma mark --
#pragma mark -- 初始化订单购买 delegate
-(NSDictionary*)onRequestSubmitOrderAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:userMid()                           forKey:@"mId"];
    [dict setSafeObject:_data.mpid                          forKey:@"pid"];
    [dict setSafeObject:self.payTypeName                    forKey:@"instCode"];
    [dict setSafeObject:self.deviceIP                       forKey:@"buyerIp"];
    int  amount =  [[self.editFieldArray safeObjectAtIndex:0] intValue] *100;
    [dict setSafeObject:[NSNumber numberWithInt:amount]    forKey:@"money"];
    [dict setSafeObject:[MDataInterface commonParam:@"kmobile"] forKey:@"mobile"];
    [dict setSafeObject:[NSNumber numberWithInt:0]          forKey:@"quickPass"];
     
    return dict;
}
-(void)onResponseSubmitOrderSuccess:(MOrderData *)orderData{
    
    [self hideHUD];
    
    
    self.orderData              = orderData;
    
    MPayViewController *pay = [[MPayViewController alloc] initWithNibName:@"MPayViewController" bundle:nil];
    pay.order               = orderData;
    pay.product_name        = self.data.mproduct_name;
    pay.amount              = [[self.editFieldArray safeObjectAtIndex:0] floatValue] ;
    pay.ip                  = self.deviceIP;
    pay.delegate            = self;
  
    [self.navigationController pushViewController:pay animated:YES];
}
-(void)onResponseSubmitOrderFail{
    [self hideHUD];
}
#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(section == 1) return 2;
    
    return 1;
}
-(void)setCellBackground:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    UIImage *background = [MActionUtility cellBackgroundForRowAtIndexPath:indexPath tableView:tableView];
    cell.backgroundView = [[UIImageView alloc] initWithImage:background];
    
    cell.backgroundColor = KVIEW_BACKGROUND_COLOR;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int section = indexPath.section;
    
    int row = indexPath.row;
    
    if (section == 0) {
        static NSString *CellIdentifier = @"MProductBriefCell";
        
        MProductBriefCell *cell = (MProductBriefCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell== nil) {
            
            cell = [MProductBriefCell loadFromNIB];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (IsIOS7)   [self setCellBackground:cell indexPath:indexPath tableView:tableView];

        }
        
        cell.data = self.data;
        
        
        return cell;
        
    }else if(section == 1){
        
        
        static NSString *CellIdentifier = @"MFieldCell";
        MFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell== nil) {
            cell = [MFieldCell loadFromNIB];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (IsIOS7)[self setCellBackground:cell indexPath:indexPath tableView:tableView];
 
        }
        
        cell.label.text = [self.titleArray safeObjectAtIndex:row];
        
        cell.amountLabel.tag = row + 100;
        
        cell.delegate = self;
        
        if (row == 0) {
            cell.amountLabel.hidden = YES;
            cell.field.hidden = NO;
            cell.upperLabel.hidden = NO;
            cell.markLabel.hidden = NO;
            cell.upperLabel.text = [self.upperArray safeObjectAtIndex:0];
        
            cell.field.text = [self.editFieldArray safeObjectAtIndex:0];
 
            if (!_resignFirst) {
                 [cell.field becomeFirstResponder];
                _resignFirst = YES;
            }

            
        }else if (row == 1) {
        
            cell.amountLabel.hidden = NO;
            cell.field.hidden = YES;
            cell.amountLabel.textColor = [UIColor orangeColor];
            float value = [[self.editFieldArray safeObjectAtIndex:row] floatValue];
            cell.amountLabel.text =STRING_FORMAT(@"￥%@", formatValue(value));
        }
//
        
        return cell;
        
    }else if(section == 2){
        static NSString *CellIdentifier = @"MBankCell";
        
        MBankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell== nil) {
            
            cell = [MBankCell loadFromNIB];
            
            if (IsIOS7) {
                
                [self setCellBackground:cell indexPath:indexPath tableView:tableView];
                
                UIImage *imageSelectedBack = [MActionUtility cellSelectedBackgroundViewForRowAtIndexPath:indexPath tableView:tableView];
                cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:imageSelectedBack];
            }
            
            
        }
        
        BOOL isEmpty = [strOrEmpty(self.bankPayStyle) isEqualToString:@""];
        cell.bank_logo.hidden = isEmpty;
        cell.bankNameLabel.hidden = isEmpty;
        if (![self.bankArray containsObject:self.bankPayStyle]) {
         
            cell.bank_logo.image   =  [UIImage imageNamed:@"round_logo"];
            cell.bankNameLabel.text = STRING_FORMAT(@"￥%@",self.bankPayStyle);
        }else{
  
            cell.bank_logo.image   = bankLogoImage(self.bankPayStyle);
            cell.bankNameLabel.text = bankName(self.bankPayStyle);
        }
       
        
        return cell;
        
    }else if(section == 3){
        static NSString *CellIdentifier = @"MProtocolCell";
        
        MProtocolCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell== nil) {
            cell = [MProtocolCell loadFromNIB];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (IsIOS7)   [self setCellBackground:cell indexPath:indexPath tableView:tableView];
        }
        
      
        cell.checkButton.selected = self.isChecked;
        
        [cell.checkButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return  cell;
        
    }
    
    return nil;
    
}

 
-(void)checkAction:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    

    self.isChecked  = ! self.isChecked;
    
    button.selected = self.isChecked ;
    
    _nextStepBtn.enabled = self.isChecked;
    
}

-(void)payResultNotify{
    
    [MActionUtility showAlert:@"购买提示" message:@"请确认您这次购买产品的结果" delegate:self cancelButtonTitle:@"遇到问题？" otherButtonTitles:@"支付成功",nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            self.emailAddress = [[alertView textFieldAtIndex:0] text];
            
            sendEmail = [[MSendEmailAction alloc] init];
            sendEmail.m_delegate = self;
            [sendEmail requestAction];
            [self showHUD];
        }
    }else{
        if (buttonIndex == 1) {
            //支付成功  发送通知 让首页更改数据显示
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];
            

            [MGo2PageUtility go2MWebBrowser:self title:@"支付结果" webUrl:KSHOW_RECORD(self.orderData.morderId)];
             
        }
    }
    
}
#pragma mark
#pragma mark ---sendeEmail delegate --------
-(NSDictionary*)onRequestSendEmailAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    NSString *bank_name    = strOrEmpty([KBANK_DICT objectForKey:[_data.mbank_id lowercaseString]]);
    
    NSString *emailContent = [NSString stringWithFormat:@"[%@] %@  购买地址：http://www.qianxs.com/mrMoney/portal/payOrder/initOrder?pid=%@",bank_name,_data.mproduct_name,_data.mpid];
    
    [dict setSafeObject:@"钱先生带您购买理财产品" forKey:@"subject"];
    [dict setSafeObject:emailContent forKey:@"content"];
    [dict setSafeObject:self.emailAddress forKey:@"toAddress"];
    [dict setSafeObject:@"TP000" forKey:@"tmNo"];
    [dict setSafeObject:@"001" forKey:@"ts"];
    [dict setSafeObject:@"com.qianxs.mail.service.MailHost.sendEmail" forKey:@"service"];
    return dict;
}
-(void)onResponseSendEmailSuccess{
    [self hideHUDWithCompletionMessage:@"发送邮件成功"];
    
}
-(void)onResponseSendEmailFail{
    
    [self hideHUDWithCompletionFailMessage:@"发送邮件失败"];
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//    MFieldCell *cell = (MFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//    for (UIView *views in [cell.contentView subviews]) {
//        if ([views isKindOfClass:[TSCurrencyTextField class]]) {
//            
//            [views resignFirstResponder];
//            if (_resignFirst) {
//                [self.tableView reloadData];
//                _resignFirst = NO;
//            }
//            
//        }
//    }
//}
- (void)amountChangedValue:(NSString *)amountStr{
    _resignFirst = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    MFieldCell *cell = (MFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *amountLabel =(UILabel *)[cell.contentView viewWithTag:101];
    
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:1];
    MFieldCell *cell0 = (MFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath0];
 

    
    float value = [MUtility expectEarning:self.data];
    
    NSString *earn =  [NSString stringWithFormat:@"%.2f",value * [amountStr floatValue]];
    amountLabel.text = STRING_FORMAT(@"￥%@",formatValue(value * [amountStr floatValue]));
    
    NSString *upper_money  = [NSString stringWithUTF8String:to_upper_rmb([amountStr floatValue])];

    cell0.upperLabel.text = STRING_FORMAT(@"金额大写: %@",upper_money);

    [self.upperArray replaceObjectAtIndex:0 withObject: STRING_FORMAT(@"金额大写: %@",upper_money)];

    //金额大写
 
    [self.editFieldArray replaceObjectAtIndex:0 withObject:amountStr];
    
    [self.editFieldArray replaceObjectAtIndex:1 withObject:earn];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        MBankViewController *bank = [[MBankViewController alloc] initWithNibName:@"MBankViewController" bundle:nil];
  
        bank.blockBank = ^(NSString *bank_id){
            self.bankPayStyle = bank_id;
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:bank animated:YES];
        
    }
    if (indexPath.section == 3) {
        
           [MGo2PageUtility go2MWebBrowser:self title:@"使用条款和隐私政策" webUrl:@"http://www.qianxs.com/mrMoney/mobile/invite/member/license.html"];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section =  indexPath.section;
    if (section == 0) {
        
        CGFloat height = [MStringUtility getStringHight:self.data.mproduct_name font:SYSTEMFONT(16) width:260.];
        
        return height + 5.+ 60.;
        
    }else if (section == 3){
        return 80.;
    }else if (section == 1){
        if (indexPath.row == 0) {
            return 62.;
        }else {
            return 44.;
        }
    }
    
    return 44.;
    
}
-(void)onButtonActionBack:(id)sender{
    if (self.pushType == MRiskType) {
        NSArray *array = [self.navigationController viewControllers];
        MBaseViewController *viewController = (MBaseViewController *)[array objectAtIndex:2];
        
        if ([viewController isKindOfClass:[MProductDetailViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
