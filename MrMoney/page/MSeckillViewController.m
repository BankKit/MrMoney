//
//  MSeckillViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSeckillViewController.h"
#import "MActProductData.h"
#import "MFinanceProductData.h"
#import "NSDate+Calendar.h"
#import "MRechargeViewController.H"
#import "BlurView.h"
#import "JDFlipClockView.h"
#import "SGActionView.h"
#import "ShareEngine.h"
@interface MSeckillViewController ()
@property (nonatomic) JDFlipClockView *flipView;

@end

@implementation MSeckillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, KHEIGHT_NAVGATIONBAR)];
    titleView.backgroundColor = [UIColor clearColor];

    UIImageView *imageView =  [[UIImageView alloc] initWithFrame:Rect(50,10, 96, 22)];
    imageView.image = [UIImage imageNamed:@"sec_topBg"];
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
 
    
    
    _topView.frameY = 0.;
    _topView.frameHeight = 100.;
    _middleView.frameY = 100.;
    _middleView.frameHeight = 200.;
    
    _bottomView.frameY = 300.;

   
    [_submitBtn setBackgroundImage:[[UIImage imageNamed:@"grabBuyBtn"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    
    self.scrollView.contentSize = CGSizeMake(320, _bottomView.frameHeight + _bottomView.frameY);
 
      
    
    self.secBank_logo.image = bankLogoImage(self.actData.mbankId);
    self.secProduct_nameLabel.text =STRING_FORMAT(@"%@ %@",bankName(self.actData.mbankId),self.actData.mproductName);
    
 
    self.secExpectedReturnRateLabel.text = STRING_FORMAT(@"%.2f%%",[self.actData.mexpectedReturnRate floatValue]/100);

    self.secDRateLabel.text =  STRING_FORMAT(@"%.2f%%",[self.actData.mdRate floatValue]/100);
    
    self.balanceLabel.text = STRING_FORMAT(@"%@元",formatValue([self.actData.mactRmAmount floatValue]/100));
    

    self.dayLabel.text = STRING_FORMAT(@"（%@天）",self.actData.minvestCycle);
    
    if ([self.actData.mactRmAmount floatValue] <= 0.0) {
        _balanceLabel.hidden = YES;
        _balanceTitleLabel.hidden = YES;
    }
    
    _checkBtn.selected = YES;
    
 
    JDFlipClockView *flipView  = [[JDFlipClockView alloc] initWithImageBundleName:@"JDFlipNumberViewIOS6"];
    flipView.showsSeconds = YES;
    flipView.frame = Rect(0, 22, 200, 36);
    [self.middleView addSubview:flipView];
    self.flipView = flipView;
 
}
-(void)createBackNavBar{
    
    UIImage *normalImage=[UIImage imageNamed:@"home_backBtn.png"];
    
    UIButton *l_btn_back = [UIButton buttonWithFrame:CGRectMake((50 - normalImage.width)/2, 0, normalImage.width, KHEIGHT_NAVGATIONBAR) image:normalImage highlightedImage:nil];
    
    
    
	UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, KHEIGHT_NAVGATIONBAR)];
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = backView.bounds;
    [touchBtn addTarget:self action:@selector(onButtonActionBack:) forControlEvents:UIControlEventTouchUpInside];
	[backView addSubview:l_btn_back];
    [backView addSubview:touchBtn];
    
    
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [self addLeftBarButtonItem:leftButtonItem];
    
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
    } else {
        
        negativeSpacer.width = 0;
        
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}


-(IBAction)onCheckAction:(id)sender{
    self.isFlag = !self.isFlag;
    if (self.isFlag) {
        _checkBtn.selected = NO;
    }else{
        _checkBtn.selected = YES;
    }
    
}
-(IBAction)onGrabBuyAction:(id)sender{
    MFinanceProductData *data = [[MFinanceProductData alloc] init];
    data.mpid = self.actData.mpid;

    data.mbank_id = self.actData.mbankId;
    data.mproduct_name = self.actData.mproductName;
    data.mproduct_code = self.actData.mproductCode;
    data.mproduct_type = self.actData.mproductType;
    data.minvest_cycle = self.actData.minvestCycle;
    data.mreturn_rate = self.actData.mprodRate;
    
    if (self.isFlag) {
        [MActionUtility showAlert:@"请先同意活动协议"];
        return ;
    }
    
    if ([_textField.text length] > 0) {
        if ([self.actData.mactRmAmount intValue] > 0) {
            [MGo2PageUtility go2PurchaseViewController:self data:data pushType:MGrabBuyType buyMoney:_textField.text];
        }else{
            [_textField resignFirstResponder];
            BlurView *blurView =[[BlurView alloc] initWithFrame:CGRectMake(0, 0, 294, 165) withXib:@"MSecKillView" action:^{
                
                MRechargeViewController *record = [[MRechargeViewController alloc] initWithNibName:@"MRechargeViewController" bundle:nil];
                record.buyMoney = _textField.text ? _textField.text : @"";
                [self.navigationController pushViewController:record animated:YES];
            
                
            }];
            
            [blurView show];
            
        }
        
    }else{

        [MActionUtility showAlert:@"购买金额不能为空"];
        return;
    }
    
}

- (IBAction)textFieldDidChange:(UITextField *)textField
{
    NSString *temp = textField.text;
    
    if (temp.length > 8) {
        textField.text = [temp substringToIndex:8];
    }
   
}


-(IBAction)onProudctDetailsAction:(id)sender{
    MFinanceProductData *data = [[MFinanceProductData alloc] init];
    data.mpid = self.actData.mpid;
    data.mbank_id = self.actData.mbankId;
    data.mproduct_name = self.actData.mproductName;
    data.mproduct_code = self.actData.mproductCode;
    data.mproduct_type = self.actData.mproductType;
    data.minvest_cycle = self.actData.minvestCycle;
    data.mreturn_rate = self.actData.mprodRate;
    data.mcurrency= self.actData.mcurrency;
    data.mvalue_date = self.actData.mvalueDate;
    data.msales_region = self.actData.msalesRegion_desc;
    
    [MGo2PageUtility go2MProductDetailViewController:self data:data];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        UIImage *navImage = [[UIImage imageNamed:@"nav_redBg"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:navImage];
 
    
    [self.navigationController.navigationBar setBackground:navImage];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    UIImage *navImage = nil;
    if (IsIOS7) {
        navImage = [UIImage imageNamed:@"navigationBg"];
    }else{
        navImage = [UIImage imageNamed:@"bg_nav"];
    }
    
    [self.navigationController.navigationBar setBackground:navImage];
    
 
}
-(IBAction)onShareAction:(id)sender{
 
     NSString *sms =STRING_FORMAT(@"我刚在全新的钱先生理财平台上获得了100块理财本金,也推荐你赶快下载钱先生安卓app,注册即可开始精彩的理财之旅。http://m.qianxs.com/?rMid=%@",userMid());
    
    [SGActionView showGridMenuWithTitle:@"分享" itemTitles:@[@"邮件", @"短信",@"新浪",@"微信"] images:@[ [UIImage imageNamed:@"night_share_platform_email"],[UIImage imageNamed:@"night_share_platform_imessage"],
                                                                                               [UIImage imageNamed:@"night_share_platform_sina"],
                                                                                               [UIImage imageNamed:@"night_share_platform_wechattimeline"]
                                                                                               ]
                         selectedHandle:^(NSInteger index) {
                             
                             if (index == 1) {
                                 [[ShareEngine sharedInstance] sendEmailViewCtrl:self content:nil WithType:emailType];
                             }else if (index == 2){
                                 [[ShareEngine sharedInstance] sendEmailViewCtrl:self content:sms   WithType:smsType];
                             }else if (index == 3){
                                 [[ShareEngine sharedInstance] sendShareMessage:@"123" WithType:sinaWeibo];
                             }else if (index == 4){
                                 [[ShareEngine sharedInstance] sendWeChatMessage:nil WithUrl:nil WithType:weChatFriend];
                             }
                             
                         }];

}

-(IBAction)onProtocolAction:(id)sender{
    int index = [(UIButton *)sender tag];
    if (index == 1) {
        [MGo2PageUtility go2MWebBrowser:self title:@"活动规则" webUrl:@"http://qianxs.com/mrMoney/actRule.html"];
    }else {
         [MGo2PageUtility go2MWebBrowser:self title:@"用户服务协议" webUrl:@"http://qianxs.com/mrMoney/actAgreement.html"];
    }
    
 
     
 
}

-(IBAction)onGoBackAction:(id)sender{
  
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
