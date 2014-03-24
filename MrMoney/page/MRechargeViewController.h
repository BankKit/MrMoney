//
//  MRechargeViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MFieldCell.h"
#import "MSubmitOrderAction.h"
#import "MPayViewController.h"
#import "MSendEmailAction.h"
#import "MRechargeAction.h"
@interface MRechargeViewController : MBaseViewController<UITextFieldDelegate,MFieldCellDelegate,MPayViewControllerDelegate,UIAlertViewDelegate,MSendEmailActionDelegate,MRechargeActionDelegate>{
    
    MSubmitOrderAction *submitAction;
    MSendEmailAction   *sendEmail;
    MRechargeAction *rechargeAction;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)   MFinanceProductData  * data;
@property (strong,nonatomic)   NSIndexPath          * currentIndexPath;
@property (nonatomic,assign)   MBankType              bankType;
@property (weak, nonatomic)    IBOutlet UIButton    * nextStepBtn;
@property (weak, nonatomic)    IBOutlet UIView      * topView;
@property (strong, nonatomic)  NSArray              * bankArray;
@property (strong, nonatomic)  NSString             * payTypeName;
@property (strong, nonatomic)  NSString             * buyMoney;
@property (assign, nonatomic)  BOOL                   isChecked;
@property (assign, nonatomic ) BOOL                   resignFirst;

@end
