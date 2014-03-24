//
//  MLockViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-3.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "KKGestureLockView.h"


typedef enum {
	InfoStatusFirstTimeSetting = 0,
	InfoStatusConfirmSetting,
	InfoStatusFailedConfirm,
	InfoStatusNormal,
	InfoStatusFailedMatch,
	InfoStatusSuccessMatch
}	InfoStatus;



@interface MLockViewController : MBaseViewController<KKGestureLockViewDelegate,UIAlertViewDelegate>

@property (nonatomic,weak) IBOutlet KKGestureLockView *lockView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic) InfoStatus infoLabelStatus;

@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;


-(IBAction)onGesturePasswordAction:(id)sender;
-(IBAction)onResetGesturePasswordAction:(id)sender;
@end
