//
//  MBankViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-11.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MQueryInvestAction.h"

typedef void (^BlockBank_id)(NSString *bankId,float accountBalance);

@interface MBankViewController : MBaseViewController<MQueryInvestActionDelegate>{
    MQueryInvestAction *queryAction;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bank_logo;

@property(copy,nonatomic)BlockBank_id blockBank;

@property(assign,nonatomic)MHomeViewControllerPushType pushType;
 
@end
