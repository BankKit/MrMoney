//
//  MRechargeViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MRechargeViewController.h"
#import "MProductBriefCell.h"
#import "MFinanceProductData.h"
#import "MProductDetailViewController.h"
#import "MAccountCell.h"
#import "MRechargeCell.h"
#import "MBankCell.h"
#import "MProtocolCell.h"
#import "MUserData.h"
#import "rmb_convert.h"
#import "MBankViewController.h"

@interface MRechargeViewController ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *editFieldArray;
@property(nonatomic,strong)NSMutableArray *upperArray;
@property(nonatomic,strong)MOrderData *orderData;
@property(nonatomic,copy)NSString *deviceIP;
@property(nonatomic,copy)NSString *bankPayStyle;
@property(nonatomic,copy)NSString *emailAddress;
@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,assign)int  buttonIndex;
@end

@implementation MRechargeViewController

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
    
    [self createNavBarTitle:@"钱宝宝账户充值"];
    
    self.buttonIndex = 100;
    self.tableView.backgroundView = nil;
    
    self.titleArray       = @[@"购买金额 : ",@"金额大写 : "];
    
    
    self.deviceIP         = [MUtility deviceIPAdress];
 
    
    if ([self.deviceIP isEqualToString:@"(null)"]){
        self.deviceIP  = @"192.168.1.100";
    }
    _buyMoney  = _buyMoney?_buyMoney:@"";
    
    NSString *upper_money  = [NSString stringWithUTF8String:to_upper_rmb([_buyMoney floatValue])];

    self.editFieldArray   = [NSMutableArray arrayWithObjects:_buyMoney,upper_money, nil];
    
    self.isChecked        = YES;
 
    
}

-(IBAction)nextStepAction:(id)sender{
    
    self.payTypeName = [MUtility payName:self.bankPayStyle];
    
    int  amount =  [[self.editFieldArray safeObjectAtIndex:0] intValue] *100;
    
    if (amount <= 0) {
        
        [MActionUtility showAlert:@"购买金额不能为空"];
        return;
    }
    
    if (!self.payTypeName) {
        
        [MActionUtility showAlert:@"请选择支付方式"];
        return;
    }
 
    
    if ([self.payTypeName isEqualToString:@"OTHERBANKS"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入邮箱地址" message:@"产品购买链接将会发送到您的邮箱，请在电脑上根据邮件提示完成购买" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:KCONFIRM_STR, nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *oldTf=[alert textFieldAtIndex:0];
        alert.tag =200;
        MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
        oldTf.text = user.memail;
        
        [alert show];
    }else{
        rechargeAction = [[MRechargeAction alloc] init];
        rechargeAction.m_delegate = self;
        [rechargeAction requestAction];
        
     
        [self showHUD];
        
    }
    
}

-(NSDictionary*)onRequestRechargeAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
//    [dict setSafeObject:userMid()                           forKey:@"mId"];
////    [dict setSafeObject:_data.mpid                          forKey:@"pid"];
//    
//    int  amount =  [[self.editFieldArray objectAtIndex:0] intValue] *100;
//    
//    [dict setSafeObject:[NSNumber numberWithInt:amount]    forKey:@"money"];
//    [dict setSafeObject:@"PT001"                            forKey:@"payType"];
//    [dict setSafeObject:self.payTypeName                    forKey:@"instCode"];
//    
//    [dict setSafeObject:self.deviceIP    forKey:@"buyerIp"];
//    [dict setSafeObject:[MDataInterface commonParam:@"kmobile"] forKey:@"mobile"];
//    [dict setSafeObject:[NSNumber numberWithInt:0]          forKey:@"quickPass"];

    [dict setSafeObject:userMid()                           forKey:@"mId"];
//    [dict setSafeObject:_data.mpid                          forKey:@"pid"];
    [dict setSafeObject:self.payTypeName                    forKey:@"instCode"];
    [dict setSafeObject:self.deviceIP                       forKey:@"buyerIp"];
    int  amount =  [[self.editFieldArray safeObjectAtIndex:0] intValue] *100;
    [dict setSafeObject:[NSNumber numberWithInt:amount]    forKey:@"money"];
    [dict setSafeObject:[MDataInterface commonParam:@"kmobile"] forKey:@"mobile"];
    [dict setSafeObject:[NSNumber numberWithInt:0]          forKey:@"quickPass"];
    
    
    return dict;

}
-(void)onResponseRechargeActionSuccess:(MOrderData *)orderData{
    [self hideHUD];
    _orderData              = orderData;
    MPayViewController *pay = [[MPayViewController alloc] initWithNibName:@"MPayViewController" bundle:nil];
    pay.order               = orderData;
    pay.product_name        = orderData.mcommodity;//bug
    pay.amount              = [[self.editFieldArray objectAtIndex:0] floatValue] ;
    pay.ip                  = self.deviceIP;
    pay.delegate            = self;
    
    [self.navigationController pushViewController:pay animated:YES];
}

-(void)onResponseRechargeActionFail{
    [self hideHUD];
}

#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0) return 2;
    
//
//    
    return 1;
}
-(void)setCellBackground:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    UIImage *background = [MActionUtility cellBackgroundForRowAtIndexPath:indexPath tableView:tableView];
    cell.backgroundView = [[UIImageView alloc] initWithImage:background];
    
    cell.backgroundColor = KVIEW_BACKGROUND_COLOR;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int section = indexPath.section;
    int row = indexPath.row;
    
     if(section ==0){
         
        static NSString *CellIdentifier = @"MRechargeCell";
        MRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell== nil) {
            cell = [MRechargeCell loadFromNIB];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (IsIOS7)[self setCellBackground:cell indexPath:indexPath tableView:tableView];

        }
        
        cell.label.text = [self.titleArray safeObjectAtIndex:row];
 
        
        cell.field.delegate = self;
        
         
        if (row == 0) {
            
            cell.field.hidden = NO;
            cell.field.delegate = self;
            cell.upperLabel.hidden = YES;
            cell.field.text = [self.editFieldArray safeObjectAtIndex:0];
 
            if (!_resignFirst) {
                [cell.field becomeFirstResponder];
                _resignFirst = YES;
            }
            
            
        }else if (row == 1) {
            
            cell.field.hidden = YES;
            cell.upperLabel.hidden = NO;
            cell.upperLabel.text = [self.editFieldArray safeObjectAtIndex:1];
  
         }
        
        
        return cell;
        
    }else if(section == 1){
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
     
        cell.bank_logo.image   = bankLogoImage(self.bankPayStyle);
        cell.bankNameLabel.text = bankName(self.bankPayStyle);
        
        
        return cell;
        
    }else if(section == 2){
        static NSString *CellIdentifier = @"MProtocolCell";
        
        MProtocolCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell== nil) {
            cell = [MProtocolCell loadFromNIB];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        if (IsIOS7)   [self setCellBackground:cell indexPath:indexPath tableView:tableView];
        
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
            
            
            NSString *url = [NSString stringWithFormat:@"http://www.qianxs.com/mrMoney/portal/payOrder/showRecord.html?OrderNo=%@",_orderData.morderId];
            [MGo2PageUtility go2MWebBrowser:self title:@"支付结果" webUrl:url];
            
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
      
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    MRechargeCell *cell1 = (MRechargeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *upper_money  = [NSString stringWithUTF8String:to_upper_rmb([textField.text floatValue])];

    cell1.upperLabel.text = upper_money;
    
    [self.editFieldArray replaceObjectAtIndex:0 withObject:textField.text];
    
    [self.editFieldArray replaceObjectAtIndex:1 withObject:upper_money];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        MBankViewController *bank = [[MBankViewController alloc] initWithNibName:@"MBankViewController" bundle:nil];
        bank.pushType =  MRechargeType;
        
        bank.blockBank = ^(NSString *bank_id){
            self.bankPayStyle = bank_id;
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:bank animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        
        [MGo2PageUtility go2MWebBrowser:self title:@"使用条款和隐私政策" webUrl:@"http://www.qianxs.com/mrMoney/mobile/invite/member/license.html"];
        
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section =  indexPath.section;
    if (section == 2){
        return 80.0f;
    }
    
    return 44.;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
