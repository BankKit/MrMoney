//
//  MPurchaseViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-7.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MFieldCell.h"
#import "MSubmitOrderAction.h"
#import "MPayViewController.h"
#import "MBalanceAction.h"
#import "MSendEmailAction.h"

@class MFinanceProductData;


@interface MPurchaseViewController : MBaseViewController<UITextFieldDelegate,MFieldCellDelegate,UIScrollViewDelegate,MSubmitOrderActionDelegate,MPayViewControllerDelegate,UIAlertViewDelegate,MSendEmailActionDelegate,MBalanceActionDelegate>{
    
    MSubmitOrderAction  *submitAction;
    MSendEmailAction *sendEmail;
    MBalanceAction *balanceAction;
    
}


@property (strong,nonatomic)   MFinanceProductData  * data;
@property (strong,nonatomic)   NSIndexPath          * currentIndexPath;
 
@property (weak, nonatomic)    IBOutlet UIButton    * nextStepBtn;
@property (weak, nonatomic)    IBOutlet UITableView * tableView;
@property (weak, nonatomic)    IBOutlet UIView      * topView;
@property (strong, nonatomic)  NSArray              * bankArray;
@property (copy, nonatomic)  NSString             * payTypeName;

@property (assign, nonatomic)  BOOL                   isChecked;
@property (assign, nonatomic ) BOOL                   resignFirst; //判断键盘弹出  reload 表
@property (assign, nonatomic ) MHomeViewControllerPushType pushType;
@property (copy, nonatomic ) NSString *buyMoney;

-(IBAction)nextStepAction:(id)sender;

@end
