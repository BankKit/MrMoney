//
//  MTreasureViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MInvestRecordAction.h"
#import "RKTabView.h"
@interface MInvestRecordViewController : MBaseTableViewController<MInvestRecordActionDelegate,RKTabViewDelegate>{
    MInvestRecordAction *investAction;
}
@property (nonatomic,assign) MHomeViewControllerPushType   type;
 
@property (nonatomic, weak)  IBOutlet RKTabView          * standardView;


@end
