//
//  MBankViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-11.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBankViewController.h"
#import "DropDownViewCell.h"
#import "MMoneyBabyData.h"
@interface MBankViewController ()

@property(nonatomic,copy)NSString *balance;
@end

@implementation MBankViewController

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
    [self createNavBarTitle:@"选择支付方式"];
    _tableView.rowHeight = 50.0f;
    
    
    self.dataArray =[NSMutableArray arrayWithArray:[KPAY_DICT allKeys]];
 
    if (self.pushType != MRechargeType) {
   
        self.tableView.tableHeaderView = _headerView;
        
        queryAction = [[MQueryInvestAction alloc] init];
        queryAction.m_delegate = self;
        [queryAction requestAction];
        [self showHUD];
    }

    
}
-(void)setHeaderViewUI{
    self.balanceLabel.text =STRING_FORMAT(@"可投资金额：%@",_balance);
    self.nameLabel.text = @"钱宝宝账户支付";
}
-(NSDictionary*)onRequestQueryInvestAction{
    return @{@"mId": userMid()};
}
-(void)onResponseQueryInvestSuccess:(MMoneyBabyData *)money{
    [self hideHUD];
 
    _balance = formatValue([money.mcanInvestMoney floatValue]/100);
    _bank_logo.image =  [UIImage imageNamed:@"round_logo"];
   
    
     [self setHeaderViewUI];
    
    [self.tableView reloadData];
    
}
-(void)onResponseQueryInvestFail{
    [self hideHUD];
}
#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    DropDownViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==nil) {
        cell = [[DropDownViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    int row = [indexPath row];
    NSString *bank_id =  [self.dataArray safeObjectAtIndex:row];
    cell.imageView.image = bankLogoImage(bank_id);
    cell.textLabel.text = bankName(bank_id);
    cell.detailTextLabel.text = [KPAY_DICT objectForKey:bank_id];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *bank_id =  [self.dataArray safeObjectAtIndex:indexPath.row];

    if (self.blockBank) {
        
        self.blockBank(bank_id);
        
        [self onButtonActionBack:nil];

    }
   
}

-(IBAction)onButtonAction:(id)sender{
    if ([_balance floatValue]> 0.0) {
        if (self.blockBank) {
            
            self.blockBank(_balance);
            
            [self onButtonActionBack:nil];
            
        }
    }else{
        [MActionUtility showAlert:@"投资金额为空"];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
