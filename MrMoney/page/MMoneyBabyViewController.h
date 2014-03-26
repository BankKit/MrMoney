//
//  MMoneyBabyViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MCategory.h"
#import "MQueryInvestAction.h"
#import "MSignAlipayAction.h"
#import "MScrollFullScreen.h"
@class MMoneyBabyData;
@class UICountingLabel;

@interface MMoneyBabyViewController : MBaseViewController<MQueryInvestActionDelegate,MSignAlipayActionDelegate,UIScrollViewDelegate,MScrollFullScreenDelegate>{
    MQueryInvestAction *queryAction;
    MSignAlipayAction *signAlipayAction;
}
@property (nonatomic,strong) MMoneyBabyData *money;
@property (nonatomic,assign) MHomeViewControllerPushType   type;

//累计收益
@property (weak, nonatomic) IBOutlet UICountingLabel  * sumIncomeMoneyLabel;
//今日收益
@property (weak, nonatomic) IBOutlet IBOutlet UILabel * todayIncomeLabel;
@property (weak, nonatomic) IBOutlet IBOutlet UILabel * todayInvestLabel;

@property (weak, nonatomic) IBOutlet IBOutlet UILabel * balanceTreasureLabel;
@property (weak, nonatomic) IBOutlet IBOutlet UILabel * rate7Label;
@property (weak, nonatomic) IBOutlet IBOutlet UILabel * unusedMoneyLabel;

@property (weak, nonatomic) IBOutlet UICountingLabel  * userCountLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel  * canDrawMoneyLabel;

@property (weak, nonatomic) IBOutlet UIView           * bottomView;
@property (weak, nonatomic) IBOutlet UIView           * topView;
@property (weak, nonatomic) IBOutlet UIView           * middleView;
@property (weak, nonatomic) IBOutlet UIScrollView     * scrollView;
@property (nonatomic,weak) IBOutlet UIView *toolBarView;



- (IBAction)onWithdrawAction:(id)sender;
- (IBAction)onRechargeAction:(id)sender;
- (IBAction)investRecordAction:(id)sender;
- (IBAction)onSignAlipayAction:(id)sender;
@end


