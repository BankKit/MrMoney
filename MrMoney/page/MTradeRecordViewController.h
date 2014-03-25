//
//  MTradeRecordVViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MTradeRecordAction.h"

@interface MTradeRecordViewController : MBaseTableViewController<MTradeRecordActionDelegate>{
    
    MTradeRecordAction *tradeAction;
}
@property(nonatomic,strong)NSString *tradeType;
 
 
@end
