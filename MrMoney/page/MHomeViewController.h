//
//  MHomeViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MQueryInvestAction.h"
#import "MColorView.h"
#import "MCalendarAction.h"
#import "DropDownListView.h"
#import "MSubmitOrderAction.h"
#import "MBalanceAction.h"
#import "MQueryProductAction.h"
#import "MLabel.h"
@class MMoneyBabyData;


@interface MHomeViewController : MBaseViewController<UIScrollViewDelegate,MQueryInvestActionDelegate,MColorViewDelegate,kDropDownListViewDelegate,MSubmitOrderActionDelegate,UIAlertViewDelegate,MBalanceActionDelegate,MQueryProductActionDelegate>{
    MQueryInvestAction *queryAction;
    MSubmitOrderAction *submitAction;
    MBalanceAction *balanceAction;
    MQueryProductAction *productAction;

}

@property (nonatomic,weak)   IBOutlet UIScrollView * scrollView;
@property (nonatomic,weak)   IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic,weak)   IBOutlet UIView       * slideView;
@property (nonatomic,weak)   IBOutlet UIView       * mainFundView;
@property (nonatomic,weak)   IBOutlet UIView       * mainSlideView;
;
@property (nonatomic,weak)   IBOutlet UIView       * financeProductsView;
@property (nonatomic,weak)   IBOutlet UIView       * fundView;
@property (nonatomic,weak)   IBOutlet UIView       * moneyBabyView;
@property (nonatomic,weak)   IBOutlet UIView       * walletView;
@property (nonatomic,weak)   IBOutlet UIView       * favoriteView;
@property (nonatomic,weak)   IBOutlet UIView       * securityAssuranceView;
@property (nonatomic,weak)   IBOutlet UIView       * sinaView;
@property (nonatomic,weak)   IBOutlet UIView       * weixinView;

@property (nonatomic,weak)   IBOutlet UIView       * topView;
@property (nonatomic,weak)   IBOutlet UIView       * topContentView;
@property (nonatomic,weak)   IBOutlet UIView       * internetView;
@property (nonatomic,weak)   IBOutlet UIImageView  * increaseImageView;
@property (nonatomic,weak)   IBOutlet UILabel      * increaseLabel;
 
@property (nonatomic,weak)   IBOutlet UILabel      * fundLabel;
@property (nonatomic,weak)   IBOutlet UILabel      * star_earningsLabel;
@property (nonatomic,weak)   IBOutlet UILabel      * star_bank_nameLabel;
@property (nonatomic,weak)   IBOutlet MLabel      * star_cycleLabel;
@property (nonatomic,weak)   IBOutlet UIImageView  * star_bank_logo;

@property (nonatomic,strong) MMoneyBabyData        * moneyData;

@property (nonatomic,strong) NSArray *arryList;
@property (nonatomic,strong) DropDownListView *listView;

-(IBAction)onPromptBuyAction:(id)sender;

-(IBAction)onFundAction:(id)sender;
 

@end
