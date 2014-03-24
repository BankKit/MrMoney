//
//  MEvaluateViewController.h
//  MrMoney
//
//  Created by xingyong on 14-2-12.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
@class MCalendarData;
@interface MEvaluateViewController : MBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong) MCalendarData *data;

-(IBAction)onShareAction:(id)sender;
-(IBAction)onCheckAction:(id)sender;
@end
