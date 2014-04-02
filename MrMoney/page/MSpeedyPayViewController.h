//
//  MSpeedyPayViewController.h
//  MrMoney
//
//  Created by xingyong on 14-4-2.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MBalanceAction.h"
#import "MSubmitOrderAction.h"
#import "MFinanceProductData.h"
#import "MDropDownListView.h"
#import "MMoneyBabyData.h"

typedef void(^SpeedPayBlock)(MOrderData *orderData , float amount);
typedef void(^PaySuccessBlock)(NSString *orderNo);
@class MHomeViewController;

@interface MSpeedyPayViewController : MBaseViewController<MBalanceActionDelegate,MSubmitOrderActionDelegate,UIAlertViewDelegate,MDropDownListViewDelegate>{


    MSubmitOrderAction *submitAction;
    MBalanceAction *balanceAction;
    
}
 
@property (nonatomic, strong) MStarData *starData;

@property(nonatomic,weak)IBOutlet UIImageView *backImageView;
@property(nonatomic,weak)IBOutlet UIImageView *backImageView2;

@property(nonatomic,weak)IBOutlet UITextField *passwordTf;
@property(nonatomic,weak)IBOutlet UITextField *balanceTf;

@property(nonatomic,weak)IBOutlet UILabel *balanceLabel;

@property(nonatomic,weak)IBOutlet UILabel *bankLabel;
@property(nonatomic,weak)IBOutlet UILabel *unuseLabel;

@property(nonatomic,assign)float canInvestMoney;

@property (nonatomic,strong)MHomeViewController *controller;

@property(nonatomic,copy)SpeedPayBlock payBlock;

@property(nonatomic,copy)PaySuccessBlock successBlock;

-(IBAction)onSpeedPayAction:(id)sender;

-(IBAction)onSwitchPayAction:(id)sender;

@end
