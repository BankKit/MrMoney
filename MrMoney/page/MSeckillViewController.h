//
//  MSeckillViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
@class MActProductData;

@interface MSeckillViewController : MBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,weak) IBOutlet  UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,strong) MActProductData *actData;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (nonatomic,weak) IBOutlet UIImageView *secBank_logo;
@property (nonatomic,weak) IBOutlet UILabel *secProduct_nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *secExpectedReturnRateLabel;
@property (nonatomic,weak) IBOutlet UILabel *secDRateLabel;
@property (nonatomic,weak) IBOutlet UILabel *secProdRateLabel;
@property (nonatomic,weak) IBOutlet UILabel *secValueDateLabel;

@property (nonatomic,weak) IBOutlet UILabel *remainingLabel;
@property (nonatomic,weak) IBOutlet UIView *remainingView;


@property (assign, nonatomic) BOOL isFlag;

-(IBAction)onShareAction:(id)sender;

-(IBAction)onCheckAction:(id)sender;

-(IBAction)onGrabBuyAction:(id)sender;

-(IBAction)onProudctDetailsAction:(id)sender;

-(IBAction)onGoBackAction:(id)sender;
 
-(IBAction)onProtocolAction:(id)sender;

- (IBAction)textFieldDidChange:(UITextField *)textField;

@end
