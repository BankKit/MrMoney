//
//  MWalletViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MWalletViewController.h"
#import "UIViewController+CWPopup.h"
#import "MAddAccountViewController.h"
#import "MWalletCell.h"
#import "MAccountsData.h"
#import "MLineView.h"
#import "MCustomButton.h"
#import "FXNotifications.h"
#import "MPopupViewController.h"
#import "MWithdrawViewController.h"
#import "MWalletViewController+Style.h"


@interface MWalletViewController ()
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) NSDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableArray *editArray;
@property (copy, nonatomic) NSString *aid;
@end

@implementation MWalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)onAddAccountAction:(id)sender{
    
    if (self.type == MWalletType) {
        [MGo2PageUtility go2AddCountViewController:self pushType:MPushWalletType];
 
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入开户行" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:KCONFIRM_STR, nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *oldTf=[alert textFieldAtIndex:0];
        oldTf.placeholder = @"例如 北京分行";
        
        UITextField *newTf=[alert textFieldAtIndex:1];
        newTf.secureTextEntry = NO;
        newTf.placeholder = @"例如 徐家汇分行";
        
        alert.tag = 100;
        [alert show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex--------- %d",buttonIndex);
    
    if (buttonIndex == 0) return;
    NSString *bankAddress = [[alertView textFieldAtIndex:0] text];
    if ([bankAddress isEqualToString:@""]) {
        [MActionUtility showAlert:@"请输入开户行省市"];
        return;
    }
    NSString *subsidiaryAddress= [[alertView textFieldAtIndex:1] text];
    if ([subsidiaryAddress isEqualToString:@""]) {
        [MActionUtility showAlert:@"请输入开户分行地址"];
        return;
    }
    
    NSArray *array  = [self arrayIndexPath:_lastIndexPath.section];
    MAccountsData *data = [array objectAtIndex:_lastIndexPath.row];
    
    MWithdrawViewController *draw = [[MWithdrawViewController alloc] initWithNibName:@"MWithdrawViewController" bundle:nil];
    draw.data = data;
    draw.bankAddress = bankAddress;
    draw.subsidiaryAddress = subsidiaryAddress;
    draw.canWithdrawMoney = self.canWithdrawMoney;
    [self.navigationController  pushViewController:draw animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.editArray = [NSMutableArray array];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    if (self.type == MWalletType) {
        [self createNavBarTitle:@"资产列表"];
     }else{
        [self createNavBarTitle:@"选择到账账户"];
        [self.bottomButton setTitle:@"下一步" forState:UIControlStateNormal];

         [self initRightButtonItem:@"nav_addBtn" title:@"添加账户" completionHandler:^{
             
             [MGo2PageUtility go2AddCountViewController:self pushType:MPushWithdrawType];
         }];
    }
    
   
    
    if (isUserLogin()) {
        queryAction = [[MQueryAccountAction alloc] init];
        queryAction.m_delegate = self;
        [queryAction requestAction];
        [self showHUD];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              forName:KNOTITICATION_ADDCOUNT
                                               object:nil
                                                queue:[NSOperationQueue mainQueue]
                                           usingBlock:^(NSNotification *note, __weak MWalletViewController *bself) {
                                               
                                               [queryAction requestAction];
                                               [bself showHUD];
                                           }];
}

-(IBAction)go2MoneyBabyAction:(id)sender{
    __weak MWalletViewController *wself = self;
    if (isUserLogin()) {
        [MGo2PageUtility go2MMoneyBabyViewController:self data:nil pushType:MMoneyBabyType];
    }
    else
    {
        [MGo2PageUtility go2MLoginViewController:self completionHandler:^{
            
            [MGo2PageUtility go2MMoneyBabyViewController:wself data:nil pushType:MMoneyBabyType];
            
        }];
    }
    
}
-(NSDictionary*)onRequestQueryAccountAction{
    return @{@"mId": userMid()};
}
-(void)onResponseQueryAccountSuccess:(NSMutableArray *)queryArray{
    [self hideHUD];
    
    self.dataDictionary =[self indexed:queryArray];
    
    
    [self.tableView reloadData];
    
}
- (NSDictionary *)indexed:(NSArray *)data{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *index = nil;
    NSMutableArray *arr = nil;
    
    for (MAccountsData *item in data) {
        
        index =  [item.mbankId lowercaseString];
        if ([index isEqualToString:@"PABACCT"]) {
            index = @"PAB";
        }
        if (self.type == MMoneyBabyType) {
            if (![index isEqualToString:@"ALIPAY"]) {
                arr = [dict objectForKey:index];
                if (arr.count == 0) {
                    NSMutableArray *l_arr = [NSMutableArray arrayWithObject:item];
                    [dict setObject:l_arr forKey:index];
                } else {
                    [arr addObject:item];
                }
            }
        }else{
            arr = [dict objectForKey:index];
            if (arr.count == 0) {
                NSMutableArray *l_arr = [NSMutableArray arrayWithObject:item];
                [dict setObject:l_arr forKey:index];
            } else {
                [arr addObject:item];
            }
        }
        
    }
    
    return dict;
}

-(void)onResponseQueryAccountFail{
    [self hideHUD];
}


#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataDictionary count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self arrayIndexPath:section];
    
    return  [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MWalletCell";
    
    MWalletCell *cell = (MWalletCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [MWalletCell loadFromNIB];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSInteger sectionRows = [tableView numberOfRowsInSection:indexPath.section];
	NSInteger row = indexPath.row;
    
    if (row == 0 && sectionRows == 1)
        cell.lineView.hidden = YES;
    else if (row == 0)
        cell.lineView.hidden = NO;
    else if (row == sectionRows - 1)
        cell.lineView.hidden = YES;
    else
        cell.lineView.hidden = NO;
    
    
    if (self.type != MWalletType) {
        
        if ([self isSelectedIndexPath:indexPath]) {
            cell.checkButton.selected = YES;
        }else{
            cell.checkButton.selected = NO;
        }
    }else{
  
        cell.roundButton.indexPath = indexPath;
        
        __weak MWalletViewController *wself = self;
        
        cell.btnHandler = ^(NSIndexPath *index,MRoundView *roundView){
            [roundView play];
            NSArray *array               = [wself arrayIndexPath:index.section];
            
            MPopupViewController  *popup = [[MPopupViewController alloc] initWithNibName:@"MPopupViewController" bundle:nil];
            popup.delegate               = wself;
            
            popup.account                = [array objectAtIndex:indexPath.row];
            
            [wself presentPopupViewController:popup animated:YES completion:^(void) {
                
            }];
            
            
            
        };
        
    }
    
    if (self.type == MMoneyBabyType) {
        cell.checkButton.hidden = NO;
        cell.roundButton.hidden = YES;
         cell.roundView.hidden = YES;
    }else{
        cell.roundButton.hidden = NO;
        cell.roundView.hidden = NO;
        cell.checkButton.hidden = YES;
    }
    
    NSArray *array = [self arrayIndexPath:indexPath.section];
    cell.data  =  [array objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == MWalletType) {
        return;
    }
    
    if (![self isSelectedIndexPath:indexPath])
    {
        
        MWalletCell *oldCell  = (MWalletCell *)[tableView cellForRowAtIndexPath:_lastIndexPath];
        oldCell.checkButton.selected = NO;
        
        MWalletCell *cell  = (MWalletCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.checkButton.selected = YES;
        
        _lastIndexPath = indexPath;
        
    }
    
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [self viewForTableViewHeaderWithText:self.dataDictionary section:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 68.;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}


-(void)popupBtnClick:(int)index{
    if (index == 1) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            [self.tableView reloadData];
        }];
        
    }else{
        [self dismissPopupViewControllerAnimated:YES completion:^{
            [queryAction requestAction];
        }];
    }
    
}
- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
    }
}
-(NSArray *)arrayIndexPath:(NSInteger )section{
    
    NSArray *keyArray  = [self.dataDictionary allKeys];
    
    NSString *key = [keyArray objectAtIndex:section];
    
    return  [self.dataDictionary objectForKey:key];
    
}
- (BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.lastIndexPath)
    {
        if (indexPath.row == self.lastIndexPath.row && indexPath.section == self.lastIndexPath.section)
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.type == MWalletType) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *key          = [[self.dataDictionary allKeys] objectAtIndex:indexPath.section];
        NSMutableArray *array  = [self.dataDictionary objectForKey:key];
        MAccountsData *account = [array objectAtIndex:indexPath.row];
        
        self.aid = account.maid;
        
        [array removeObjectAtIndex:indexPath.row];
        
        if (indexPath && self.aid) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            unbindAction = [[MUnbindAccountAction alloc] init];
            unbindAction.m_delegate = self;
            [unbindAction requestAction];
            [self showHUD];
        }

        
    }
    
}


-(NSDictionary*)onRequestUnbindAccountAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:2];
    [dict setSafeObject:userMid() forKey:@"mid"];
    [dict setSafeObject:self.aid forKey: @"aid"];
    return dict;
}
-(void)onResponseUnbindAccountSuccess{
    [self hideHUD];
//    [self.tableView reloadData];
}
-(void)onResponseUnbindAccountFail{
    [self hideHUD];
//    [self.tableView reloadData];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"解除绑定";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTITICATION_ADDCOUNT object:nil];
    queryAction.m_delegate = nil;
}
@end
