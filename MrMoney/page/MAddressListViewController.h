//
//  MAddressListViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-31.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
typedef void (^dismissCurrentBlock) (NSString *addressName);

@interface MAddressListViewController : MBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *bankArray;
@property(nonatomic,copy)dismissCurrentBlock completionBlock;
@end
