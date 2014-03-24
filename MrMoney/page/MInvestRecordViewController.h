//
//  MTreasureViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MInvestRecordAction.h"
#import "RKTabView.h"
@interface MInvestRecordViewController : MBaseViewController<MInvestRecordActionDelegate,RKTabViewDelegate>{
    MInvestRecordAction *investAction;
}
@property (nonatomic,assign) MHomeViewControllerPushType   type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak)  IBOutlet RKTabView          * standardView;


@end
