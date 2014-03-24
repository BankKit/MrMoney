//
//  MChatViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MListActivityAction.h"
@interface MChatViewController : MBaseViewController<MListActivityActionDelegate>{
    MListActivityAction *listActivityAction;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
