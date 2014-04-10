//
//  MHomeViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MHomeViewController.h"
#import "MMoneyBabyData.h"
#import "UIColor+MCategory.h"
#import "MFinanceProductData.h"
#import "MMDrawerController.h"
#import "MCenterCalendarViewController.h"
#import "MEvaluateViewController.h"
#import "MCalendarData.h"
#import "UIViewController+MMDrawerController.h"
#import "MPageData.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BlurView.h"
#import "ShareEngine.h"
#import "MCountView.h"
#import "CycleScrollView.h"
#import "MHomeViewController+Style.h"
#import "NSTimer+Addition.h"
#import "MAnimation.h"
#import "MInternetData.h"
#import "MLabel.h"
#import "UIViewController+MaryPopin.h"
#import "MSpeedyPayViewController.h"
#import "MPayViewController.h"
#import "UIResponder+MotionRecognizers.h"


@interface MHomeViewController ()<PDTSimpleCalendarViewDelegate,MPayViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *customDates;

@property (nonatomic, strong) PDTSimpleCalendarViewController *calendarViewController;
@property (nonatomic, strong) MCenterCalendarViewController *center;
@property (nonatomic, strong) MCountView *countView;
@property (nonatomic,assign) float todayIncome;
@property (nonatomic,assign) float           canInvestMoney;
@property (nonatomic,assign) double          total;
@property (nonatomic,assign) int             currentNum;
@property (nonatomic,assign) BOOL            isFlag;
@property (nonatomic,strong) NSArray         *starArray;
@property (nonatomic,strong) NSArray         *internetArray;
@property (nonatomic,strong) NSTimer         *timer;
@property (nonatomic,assign) BOOL            isAnmation;
@property (nonatomic,strong) CycleScrollView *mainScorllView;

@property (nonatomic,strong) MStarData *starData;

@property (nonatomic,strong) NSString *orderNo;
@end

@implementation MHomeViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
 
    self.isFlag = NO;
    
    [_countView start];
    
    [self addMotionRecognizerWithAction:@selector(motionWasRecognized:)];
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self showView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 
    [_countView stop];
    
    [self removeMotionRecognizer];
}

-(void)showView{
    NSString *todayStr =[MUtility stringForDate:[zoneDate([NSDate date]) dateToday]];
    
    NSString *dateString  =  user_defaults_get_string(@"ktoday");
    if (![todayStr isEqualToString:dateString]) {
 
        BlurView *blurView =[[BlurView alloc] initWithFrame:CGRectMake(0, 0, 250, 375) withXib:@"MPopView" action:^{
            [MGo2PageUtility go2MFinanceProductsViewController:self pushType:MPopType];

        }];
        
        [blurView show];
  
    }
    user_defaults_set_string(@"ktoday", todayStr);
}

#pragma mark --
#pragma mark -- setCycleScrollView
-(void)setCycleScrollView{
    
    NSInteger count =  [_internetArray count];
     _internetView.hidden = (count == 0) ? NO : YES;
    if (count == 0) {
        _internetView.hidden = NO;
        return;
    }else{
        _internetView.hidden = YES;
    }
    
  
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:count];
    
    CGRect rect = CGRectMake(0, 0, 154, 82);
    for (int i = 0; i < count; i++) {
       
        MInternetData *internetData = _internetArray[i];

        [viewsArray addObject: [self cyleViewWithInternetData:internetData]];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:rect animationDuration:4];
    self.mainScorllView.backgroundColor = KCLEAR_COLOR;

    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return count;
    };
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    __weak MHomeViewController *wself = self;
 
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        
        
        CAKeyframeAnimation *popAnimation = [MAnimation getKeyframeAnimation];
        [wself.moneyBabyView.layer addAnimation:popAnimation forKey:nil];
        [wself touchControlView];
        
        [wself bk_performBlock:^(id obj) {

            [wself removeControlView];
        
            [MGo2PageUtility go2MFinanceProductsViewController:wself pushType:MInternetType];
            
        } afterDelay:0.6];

    };
    [self.moneyBabyView addSubview:self.mainScorllView];
}


-(IBAction)onFundAction:(id)sender{
    NSInteger index = [(UIButton*)sender tag];
    CAKeyframeAnimation *popAnimation = [MAnimation getKeyframeAnimation];
    [self.mainFundView.layer addAnimation:popAnimation forKey:nil];
    [self touchControlView];
    __weak MHomeViewController *wself = self;
    [self bk_performBlock:^(id obj) {
     [wself removeControlView];
        if (index == 1) {
            
            [MGo2PageUtility go2MWebBrowser:wself title:nil webUrl:@"http://hb.jsfund.cn/xsds/play/hqb/tyyl.jsp"];
            
        }else{
            [MGo2PageUtility go2MFinanceProductsViewController:wself pushType:MFundType];

        }

    } afterDelay:0.6];
    
}
-(void)animationTimerStar:(NSTimer *)timer{
  
    self.isAnmation = !self.isAnmation;
    if (self.isAnmation) {
        [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _mainSlideView.frameY = -82.0;
        } completion:nil];
    
    }else{
        [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _mainSlideView.frameY = 0.0;
        } completion:nil];
    }
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.timer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                           target:self
                                                         selector:@selector(animationTimerStar:)
                                                         userInfo:nil
                                                          repeats:YES];
    [self.timer pauseTimer];
    
    _mainSlideView.frameY = -82.0;
    [_mainFundView addSubview:_mainSlideView];
    
    
    self.customDates = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
    self.view.backgroundColor              = [UIColor blackColor];
    
    self.scrollView.frameY = IsIOS7 ? KHEIGHT_STATUSBAR : 0.0f;
    
    CGSize size =  CGSizeMake(320, self.securityAssuranceView.frame.size.height + self.securityAssuranceView.frameY + ((IsIOS7) ? KHEIGHT_STATUSBAR : 0.0f));
    self.scrollView.contentSize = size;
 
    
    [self setHomeColorButtonView];
    
    if (isUserLogin()) {
        [self startQueryAction];
    }
    
    productAction = [[MQueryProductAction alloc] init];
    productAction.m_delegate = self;
    [productAction requestAction];
    
    [self setNewProductNumber];
    
    [MDataInterface setCommonParam:@"increase" value:@"YES"];
  
    _topContentView.frameY = -self.topContentView.frameHeight;
    [self.topView addSubview:self.topContentView];
    
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(update:) name:KNOTITICATION_BLANCE object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateCalendar:) name:@"kcalendar" object:nil];
 
    
}


- (void) motionWasRecognized:(NSNotification*)notif {
    UIButton *btn = (UIButton *)[self.topContentView viewWithTag:1];
    [self onPromptBuyAction:btn];
}
#pragma mark --
#pragma mark -- queryProductDelegate 
-(void)onResponseQueryProductSuccess:(MMoneyBabyData *)moneyData{
    
    [UIView animateWithDuration:2.0 animations:^{
        _topContentView.frameY = 0.0;
    }];
    

    self.starArray     = moneyData.mstartArray;
    self.internetArray = moneyData.minternetArray;
    
    _fundLabel.text = moneyData.mjiashiReturnRate;
    
    [self.timer resumeTimerAfterTimeInterval:3.0];
    
    [self setStarView];
    
    [self setCycleScrollView];
    
    [self.timer resumeTimer];
    
}
-(void)onResponseQueryProductFail{
    [UIView animateWithDuration:2.0 animations:^{
        _topContentView.frameY =  -self.topContentView.frameHeight;
    }];
    
    [self setCycleScrollView];
    [self.timer pauseTimer];
}

 
-(void)setNewProductNumber{
    NSString *isYes =  [MDataInterface commonParam:@"increase"];
    
    if (![isYes isEqualToString:@"YES"]) {
        _increaseImageView.hidden = NO;
        _increaseLabel.hidden = NO;
        _increaseLabel.text = STRING_FORMAT(@"%d",arc4random() % 9 + 1);
    }else{
        _increaseImageView.hidden = YES;
        _increaseLabel.hidden = YES;
    }
    
}
-(void)update:(NSNotification*) notification{
 
    [self startQueryAction];
    
}
-(void)startQueryAction{
    if (queryAction == nil) {
        queryAction = [[MQueryInvestAction alloc] init];
        queryAction.m_delegate = self;
    }
   
    [queryAction requestAction];
    
    [self.activityView startAnimating];
    
}


-(void)setBalanceLabelValue{
  
    if (_countView) {
        [_countView removeFromSuperview];
    }
    _countView =  [[MCountView alloc] initWithFrame:Rect(0.,32.,151., 21.) balance:_total todayIncome:_todayIncome type:MHomeType];
        
    [_walletView addSubview:_countView];
    
}
#pragma mark ------------- 摇一摇 快捷支付购买 -----------------

-(IBAction)onPromptBuyAction:(id)sender{

 
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
       
        if (_topContentView.frameY == 0.0) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [button.layer addAnimation:[MAnimation shakeAnimation] forKey:@"imageView"];
            
            [UIView animateWithDuration:3.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:Nil completion:^(BOOL finished) {
                [self setStarView];
            }];
        }
        
    }else{
        __weak MHomeViewController *wself = self;
        MSpeedyPayViewController  *speedy = [[MSpeedyPayViewController alloc] initWithNibName:@"MSpeedyPayViewController" bundle:nil];
        
        speedy.payBlock = ^(MOrderData *orderData , float amount){
            self.orderNo = orderData.morderId;
            MPayViewController *pay = [[MPayViewController alloc] initWithNibName:@"MPayViewController" bundle:nil];
            pay.delegate            = wself;
            pay.order               = orderData;
            pay.amount              = amount;
            pay.ip                  = [MUtility deviceIPAdress];
            
            [self.navigationController  pushViewController:pay animated:YES];
        };
        
        speedy.successBlock = ^(NSString *orderNo){
 
            [UIAlertView showConfirmationDialogWithTitle:@"购买成功" message:@"您已经购买成功，是否查看订单?" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [MGo2PageUtility go2MWebBrowser:wself title:@"支付结果" webUrl:KSHOW_RECORD(orderNo)];
                }
            }];
          

        };
        
        [speedy setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
        [speedy setPopinOptions:BKTPopinDisableAutoDismiss];
        
        [speedy setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
        
        speedy.canInvestMoney = _canInvestMoney;
        
        speedy.starData = self.starData;
        
        speedy.controller = self;
        
        [self.mm_drawerController presentPopinController:speedy animated:YES completion:nil];
 
     }
    
}


#pragma mark ------------- 支付成功 通知  -----------------

-(void)payResultNotify{
    
    [MActionUtility showAlert:@"购买提示" message:@"请确认您这次购买产品的结果" delegate:self cancelButtonTitle:@"遇到问题？" otherButtonTitles:@"支付成功",nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
         
         [self startQueryAction];
        
        [MGo2PageUtility go2MWebBrowser:self title:@"支付结果" webUrl:KSHOW_RECORD(self.orderNo)];
        
    }
    
}


 
-(void)setStarView{
    if (![self.starArray isEmpty]) {
        return;
    }
    
    _currentNum++;
    
    if (_currentNum == [self.starArray count]) {
        _currentNum = 0;
    }

    MStarData *star            = [self.starArray safeObjectAtIndex:_currentNum];
    self.starData = star;
    self.star_bank_nameLabel.text = STRING_FORMAT(@"%@ %@", bankName(star.mstar_bankId),star.mstar_productName);
    self.star_bank_logo.image     = bankLogoImage(star.mstar_bankId);
    if (!IsIOS7) {
        self.star_earningsLabel.font =  FONT(kHelveticaLight, 40);
        self.star_cycleLabel.font = FONT(kHelveticaLight, 22);

    }

    self.star_earningsLabel.text  = STRING_FORMAT(@"%.1f",[star.mstar_returnRate floatValue]/100);
    self.star_cycleLabel.text     = STRING_FORMAT(@"%@天",star.mstar_investCycle);

    [self.star_cycleLabel setFont:SYSTEMFONT(14) string:@"天"];
}

#pragma mark --
#pragma mark -- QueryInvestDelegate
-(NSDictionary*)onRequestQueryInvestAction{
    
    MutableOrderedDictionary  *dict = [MutableOrderedDictionary dictionaryWithCapacity:2];
    
    [dict setObject:userMid() forKey:@"mId"];
    
    [dict setObject:[NSNumber numberWithInt:6] forKey:@"prodNums"];
    
    return dict;
}
-(void)onResponseQueryInvestSuccess:(MMoneyBabyData *)money{
    
    
    [self.activityView stopAnimating];
    
    self.moneyData = money;
  
    _canInvestMoney =  [money.mcanInvestMoney floatValue]/100;
 
    float qbbAssets    = [money.mQbbAssets   floatValue]/100;
    float presentMoney = [money.mpresentMoney floatValue]/100;
    _todayIncome       = [money.mtodayIncome floatValue]/100;
    
    _total   = presentMoney + qbbAssets;
    
//    @property (nonatomic,weak)   IBOutlet UILabel      * star_bank_nameLabel;
    _VIPLabel.text = strOrEmpty(self.moneyData.mcustLevel);
    
    
    [self setBalanceLabelValue];
    
}

-(void)onResponseQueryInvestFail{

 
    [self.activityView stopAnimating];
   
}
#pragma mark -------------  colorViewClick -----------------

-(void)colorButtonClick:(int)index{
    
    NSLog(@"---------------index----------------%d \n\n",index);
 
    [self touchControlView];
    __weak MHomeViewController *wself = self;
    
    [self bk_performBlock:^(id obj) {
         [wself removeControlView];
        if (index == 1) {
            [self setNewProductNumber];
            [MGo2PageUtility go2MFinanceProductsViewController:wself pushType:MFinanceProductsType];
            
        }else if (index == 2){
            [MGo2PageUtility go2MFinanceProductsViewController:wself pushType:MFundType];

        }else if (index == 3){
            if (![self.starArray isEmpty] ) {
                [productAction requestAction];
            }
            [MGo2PageUtility go2MFinanceProductsViewController:wself pushType:MInternetType];

        }else if (index == 4){
            if (isUserLogin()) {
                if (!self.moneyData) {
                    [self startQueryAction];
                }
                else
                {
                    [MGo2PageUtility go2MMoneyBabyViewController:wself data:wself.moneyData pushType:MMoneyBabyType];
                }
                
            }else{
                
                [MGo2PageUtility go2MLoginViewController:wself completionHandler:^{
                    [self startQueryAction];
                    
                }];
            }
        }else if (index == 5){
            if (!isUserLogin()) {
                [MGo2PageUtility go2MLoginViewController:wself completionHandler:^{
                    [wself initCalenderUI];
                }];
            }else  {
                [wself initCalenderUI];
            }

        }else if (index == 6){
            if (!isUserLogin()) {
                [MGo2PageUtility go2MLoginViewController:wself completionHandler:^{
                
                }];
            }else  {
                [[ShareEngine sharedInstance] sendShareMessage:@"123" WithType:sinaWeibo];
            }
    
        }else if (index == 7){
            if (!isUserLogin()) {
                [MGo2PageUtility go2MLoginViewController:wself completionHandler:^{
                    
                }];
            }else  {

                [[ShareEngine sharedInstance] sendWeChatMessage:@"123" WithUrl:nil WithType:weChatFriend];

            }
            
        }else if (index == 8){
            [MGo2PageUtility go2MSecurityAssuranceViewController:wself pushType:MFavoriteType];
        }
 
    } afterDelay:0.6];
     
}

-(void)initCalenderUI{
  
    
    _calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    _calendarViewController.calendar = [NSCalendar currentCalendar];
    
    [_calendarViewController setDelegate:self];
    
    NSDate *currentDate = [NSDate date];
    
    _calendarViewController.firstDate = [currentDate dateBySettingYear:[currentDate year] - 1];
    _calendarViewController.lastDate =  [currentDate  dateBySettingMonth: [currentDate month] + 1];
    
    
    _center = [[MCenterCalendarViewController alloc] initWithNibName:@"MCenterCalendarViewController" bundle:nil];
    UINavigationController  *centerNav= [[UINavigationController alloc] initWithRootViewController:_center];
    
    MEvaluateViewController *evaluate = [[MEvaluateViewController alloc] initWithNibName:@"MEvaluateViewController" bundle:nil];
    
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:_calendarViewController rightDrawerViewController:evaluate];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    drawerController.showsShadow = NO;
    [drawerController setMaximumRightDrawerWidth:270.0];
    [drawerController setMaximumLeftDrawerWidth:270.0];
     
    [self.navigationController pushViewController:drawerController animated:YES];
    
}


-(void)updateCalendar:(NSNotification *)notification{

    [self.customDates removeAllObjects];
    NSArray *notificationArray = notification.object;
    self.dataArray =[NSMutableArray arrayWithArray:notificationArray];
    for (MCalendarData *l_data in notificationArray) {
        
        [self.customDates addObject:[l_data.minvestDate dateToday]];
    }

    
    MCalendarData *lastData = [notificationArray safeObjectAtIndex:[notificationArray count] -1];
    _calendarViewController.selectedDate = lastData.minvestDate;
}


#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewDidSelectDate:(NSDate *)date
{
    
    NSMutableArray *l_array = [NSMutableArray arrayWithCapacity:0];
    
  
    if ([self.customDates containsObject:[date dateToday]]) {
        
        for (MCalendarData *data in self.dataArray) {
           
            if ([[date dateToday] isEqualToDate:[data.minvestDate dateToday]]) {
                
                [l_array addObject:data];
            }
        }
        
        if (self.isFlag) {
            [_calendarViewController.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleDrawerSide" object:l_array];
                    
              
            }];
        }
    
        self.isFlag = YES;
    }
}

 
- (BOOL)simpleCalendarShouldUseCustomColorsForDate:(NSDate *)date
{
    
    if ([self.customDates containsObject:[date dateToday]]) {
        return YES;
    }
    return NO;
}

- (UIColor *)simpleCalendarCircleColorForDate:(NSDate *)date
{
    return KLIGHTBLUE;
}

- (UIColor *)simpleCalendarTextColorForDate:(NSDate *)date
{
    return [UIColor whiteColor];
}
 
-(void)viewDidUnload{
    [super viewDidUnload];
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shake" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTITICATION_BLANCE object:nil];
    
}
@end
