//
//  MBankViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-11.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBankViewController.h"
#import "MDropDownViewCell.h"
#import "MMoneyBabyData.h"
#import "MLogoView.h"
@interface MBankViewController ()

@property(nonatomic,assign)float canInvestMoney;
@property(nonatomic,strong)NSMutableDictionary *dataDict;

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
    
    self.dataDict = [NSMutableDictionary dictionaryWithDictionary:KPAY_DICT];
    
    if (self.pushType == MRechargeType) {
        [self.dataDict removeObjectForKey:@"0"];
    }
    
    self.dataArray =[NSMutableArray arrayWithArray:[[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
     
    if (self.pushType != MRechargeType) {
    
        queryAction = [[MQueryInvestAction alloc] init];
        queryAction.m_delegate = self;
        [queryAction requestAction];
        [self showHUD];
    }

    
}

-(NSDictionary*)onRequestQueryInvestAction{
    return @{@"mId": userMid()};
}
-(void)onResponseQueryInvestSuccess:(MMoneyBabyData *)money{
    [self hideHUD];

    self.canInvestMoney  = [money.mcanInvestMoney floatValue]/100;

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
    
    MDropDownViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==nil) {
        cell = [[MDropDownViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    int row = [indexPath row];
    NSString *bankOrderkey =  [self.dataArray safeObjectAtIndex:row];
    NSDictionary *cellDict = [self.dataDict objectForKey:bankOrderkey];
    cell.imageView.image = bankLogoImage([cellDict objectForKey:@"bank"]);
    cell.textLabel.text = [cellDict objectForKey:@"name"];
    if ((self.pushType != MRechargeType) && (row == 0)) {
       
        cell.detailTextLabel.text = STRING_FORMAT(@"%@%@",[cellDict objectForKey:@"content"], formatValue(_canInvestMoney));

        cell.detailTextLabel.textColor = [UIColor orangeColor];
    }else{
        cell.detailTextLabel.text =[cellDict objectForKey:@"content"];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *bankOrderkey =  [self.dataArray safeObjectAtIndex:indexPath.row];
    NSDictionary *cellDict = [self.dataDict objectForKey:bankOrderkey];
    
    if (self.blockBank) {
        
        if ((self.pushType != MRechargeType) && (indexPath.row == 0)) {
        self.blockBank(nil,_canInvestMoney);
        }else {
            self.blockBank([cellDict objectForKey:@"bank"],0.0);
        }

        
        [self onButtonActionBack:nil];

    }
   
}
//
//-(IBAction)onButtonAction:(id)sender{
//    if (_canInvestMoney> 0.0) {
//        
//        if (self.blockBank) {
//            
//            self.blockBank(nil,_canInvestMoney);
//            
//            [self onButtonActionBack:nil];
//            
//        }
//    }else{
//        [MActionUtility showAlert:@"投资金额为空"];
//        return;
//    }
//}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
