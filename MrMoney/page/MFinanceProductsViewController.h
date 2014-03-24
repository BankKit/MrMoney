//
//  MFinanceProductsViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MFinanceProductAction.h"
#import "RKTabView.h"
#import "MSegmentView.h"
#import "MFundAction.h"

@interface MFinanceProductsViewController : MBaseViewController<MFinanceProductActionDelegate,RKTabViewDelegate,UIAlertViewDelegate,MFundActionDelegate>{
    MFinanceProductAction *financeAction;
    MFundAction *fundAction;
 
}

@property (nonatomic, weak)  IBOutlet RKTabView          * standardView;
@property (nonatomic,weak,)  IBOutlet UIView             * myView;
@property (weak, nonatomic)  IBOutlet UITableView        * tableView;
@property (weak, nonatomic)  IBOutlet UIButton           * filterBtn;

@property (nonatomic,assign) MHomeViewControllerPushType   type;
@property (nonatomic,assign) int                           totalNum;
@property (nonatomic,assign) int                           currPageNum;
@property (nonatomic,strong) MSegmentView                  *segmentView;
@property (nonatomic,strong) NSString                      *sortType;
@property (nonatomic,weak) IBOutlet UIImageView            *shadeImageView;

@property (nonatomic,weak) IBOutlet UIView *headerView;

@property (nonatomic,weak) IBOutlet UIImageView *secBank_logo;
@property (nonatomic,weak) IBOutlet UILabel *secProduct_nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *secExpectedReturnRateLabel;
@property (nonatomic,weak) IBOutlet UILabel *secDRateLabel;
@property (nonatomic,weak) IBOutlet UILabel *secProdRateLabel;

- (IBAction)onFilterAction:(id)sender;
- (IBAction)onSeckillAction:(id)sender;


@end
