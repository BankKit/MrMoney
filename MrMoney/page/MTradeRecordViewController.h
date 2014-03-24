//
//  MTradeRecordVViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MTradeRecordAction.h"

@interface MTradeRecordViewController : MBaseViewController<MTradeRecordActionDelegate>{
    
    MTradeRecordAction *tradeAction;
}
@property(nonatomic,strong)NSString *tradeType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
 
@end
