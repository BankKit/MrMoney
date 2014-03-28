//
//  MWalletViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MQueryAccountAction.h"
#import "UICountingLabel.h"
#import "MPopupViewController.h"
#import "MCustomButton.h"
#import "MUnbindAccountAction.h"



@interface MWalletViewController : MBaseViewController<MQueryAccountActionDelegate,MPopupViewDelegate,UIGestureRecognizerDelegate,MUnbindAccountActionDelegate,UIAlertViewDelegate>{
    MQueryAccountAction *queryAction;
    MUnbindAccountAction *unbindAction;
     
}

@property (nonatomic,assign)  MHomeViewControllerPushType   type;
@property (weak, nonatomic)   IBOutlet UITableView        * tableView;
@property (assign,nonatomic) BOOL                          isFlag;
@property (weak,nonatomic)    IBOutlet UICountingLabel    * totalAssetLabel;
 

@property (weak, nonatomic) IBOutlet UIButton             * bottomButton;
@property (weak, nonatomic) IBOutlet MCustomButton        * lastBtn;

@property(copy,nonatomic)NSString *canWithdrawMoney;


 
-(IBAction)go2MoneyBabyAction:(id)sender;
-(IBAction)onAddAccountAction:(id)sender;
@end
