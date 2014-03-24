//
//  MSetupViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"

@interface MSetupViewController : MBaseViewController<UIActionSheetDelegate>

@property (nonatomic,strong) NSArray              * titleArray;
@property (nonatomic,strong) NSArray              * imageArray;
@property (weak, nonatomic)  IBOutlet UITableView * tableView;
 
@end
