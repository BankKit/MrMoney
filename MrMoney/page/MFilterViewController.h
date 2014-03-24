//
//  MFilterViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MCheckBox.h"
@interface MFilterViewController : MBaseViewController<MCheckBoxDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic)  MCheckBox *checkBoxBtn;

@property (assign, nonatomic)  MHomeViewControllerPushType type;


-(IBAction)onConfirmAction:(id)sender;

@end
