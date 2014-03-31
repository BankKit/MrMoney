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
#import "MPayViewController.h"
#import "BlurView.h"
#import "ShareEngine.h"
#import "MCountView.h"
#import "CycleScrollView.h"
#import "MHomeViewController+Style.h"
#import "NSTimer+Addition.h"
#import "MAnimation.h"
#import "MInternetData.h"
#import "MLabel.h"


@interface MHomeViewController ()<PDTSimpleCalendarViewDelegate,MPayViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *customDates;
@property (nonatomic, strong) MFinanceProductData *starData;
@property (nonatomic, strong) PDTSimpleCalendarViewController *calendarViewController;
@property (nonatomic, strong) MCenterCalendarViewController *center;
@property (nonatomic, strong) MCountView *countView;
@property (nonatomic,assign)float todayIncome;
@property (nonatomic,assign) float           canInvestMoney;
@property (nonatomic,assign) double          total;
@property (nonatomic,assign) int             currentNum;
@property (nonatomic,assign) BOOL            isFlag;
@property (nonatomic,strong) NSArray         *starArray;
@property (nonatomic,strong) NSArray         *internetArray;
@property (nonatomic,assign) float           star_balance;
@property (nonatomic,copy  ) NSString        *star_bankId;
@property (nonatomic,copy  ) NSString        *deviceIP;
@property (nonatomic,copy  ) NSString        *orderNo;
@property (nonatomic,strong) NSTimer         *timer;
@property (nonatomic,assign) BOOL            isAnmation;
@property (nonatomic,strong) CycleScrollView *mainScorllView;
@end

@implementation MHomeViewController
-(void)payResultNotify{
    
    [MActionUtility showAlert:@"购买提示" message:@"请确认您这次购买产品的结果" delegate:self cancelButtonTitle:@"遇到问题？" otherButtonTitles:@"支付成功",nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
        if (buttonIndex == 1) {
            //支付成功  发送通知 让首页更改数据显示
            [self startQueryAction];
            
            [MGo2PageUtility go2MWebBrowser:self title:@"支付结果" webUrl:KSHOW_RECORD(self.orderNo)];
            
        }
   
}

- (void)DropDownListViewDidButtonClick:(float )money bankId:(NSString *)bank_id{
    
    self.star_balance = money * 100;
    self.star_bankId = bank_id;

    if ([self.arryList containsObject:bank_id]) {
        submitAction = [[MSubmitOrderAction alloc] init];
        submitAction.m_delegate = self;
        [submitAction requestAction];
       
    }
    else
    {
        balanceAction = [[MBalanceAction alloc] init];
        balanceAction.m_delegate = self;
        [balanceAction requestAction];
    }

    [_listView fadeOut];
    
    [self showHUD];
    
}
#pragma mark --
#pragma mark -- balance delegate
-(NSDictionary*)onRequestBalanceAction{

    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:3];
    
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:self.starData.mpid forKey:@"pid"];

    [dict setSafeObject:[NSNumber numberWithFloat:self.star_balance/100] forKey:@"investMoney"];

    return dict;
}
-(void)onResponseBalanceSuccess:(NSString *)orderNo{
 
    __weak MHomeViewController *wself = self;
    [self hideHUDWithCompletionMessage:@"交易成功" finishedHandler:^{
  
        [MGo2PageUtility go2MWebBrowser:wself title:@"支付结果" webUrl:KSHOW_RECORD(orderNo)];
    }];
}
-(void)onResponseBalanceFail{
 
    [self hideHUDWithCompletionFailMessage:@"交易失败"];
}
-(NSString *)payName:(NSString *)bankId{
    NSString *bankName = [bankId uppercaseString];
    if ([bankName isEqualToString:@"BOCOM"]) {
        return  @"COMM";
    }else if ([bankName isEqualToString:@"PAB"]) {
        return   @"SZPAB";
    }else if ([bankName isEqualToString:@"BOB"]) {
        return  @"BCCB";
    }
    return bankName;

}
#pragma mark --
#pragma mark -- submitOrder delegate
-(NSDictionary*)onRequestSubmitOrderAction{
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];

    [dict setSafeObject:userMid()                           forKey:@"mId"];
    [dict setSafeObject:self.starData.mpid                  forKey:@"pid"];
    [dict setSafeObject:self.star_bankId     forKey:@"instCode"];
    [dict setSafeObject:self.deviceIP                       forKey:@"buyerIp"];
 
    [dict setSafeObject:[NSNumber numberWithFloat:self.star_balance]    forKey:@"money"];
    [dict setSafeObject:[MDataInterface commonParam:@"kmobile"] forKey:@"mobile"];
    [dict setSafeObject:[NSNumber numberWithInt:0]          forKey:@"quickPass"];

    
//    [dict setSafeObject:userMid()                       forKey:@"mId"];
//    [dict setSafeObject:self.starData.mpid              forKey:@"pid"];
//    [dict setSafeObject:[NSNumber numberWithFloat:self.star_balance]    forKey:@"money"];
//    [dict setSafeObject:@"PT001"                            forKey:@"payType"];
//    [dict setSafeObject:[self payName:self.star_bankId]            forKey:@"instCode"];
//    [dict setSafeObject:self.deviceIP    forKey:@"buyerIp"];
//    [dict setSafeObject:[MDataInterface commonParam:@"kmobile"] forKey:@"mobile"];
//    [dict setSafeObject:[NSNumber numberWithInt:0]          forKey:@"quickPass"];
    
    
    return dict;
}
-(void)onResponseSubmitOrderSuccess:(MOrderData *)orderData{
 
    [self hideHUD];
    self.orderNo = orderData.morderId;
    MPayViewController *pay = [[MPayViewController alloc] initWithNibName:@"MPayViewController" bundle:nil];
    pay.delegate            = self;
    pay.order               = orderData;
    pay.amount              = self.star_balance/100;
    pay.ip                  = self.deviceIP;
 
    [self.navigationController pushViewController:pay animated:YES];
}
-(void)onResponseSubmitOrderFail{

    [self hideHUD];
}


-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    _listView = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    _listView.delegate = self;
    [_listView showInView:self.view animated:YES];
    
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    
    [_listView fadeOut];
    
    NSString *title = nil;
    if (anIndex == 0) {
        title = STRING_FORMAT(@"￥%@",formatValue(_canInvestMoney));
    }else{
 
        title =  [self.arryList safeObjectAtIndex:anIndex - 1];
        
    }
     
    [self showPopUpWithTitle:title withOption:_arryList xy:CGPointMake(5, 20) size:CGSizeMake(300, 240) isMultiple:YES];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
  
    [_listView fadeOut];
   
    NSString *canInvestMoney = STRING_FORMAT(@"可投资金额：￥%@",formatValue(_canInvestMoney));
    [self showPopUpWithTitle:canInvestMoney withOption:_arryList xy:CGPointMake(5, 20) size:CGSizeMake(300, 320) isMultiple:NO];
    
}


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
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self showView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 
    [_countView stop];
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
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = KCLEAR_COLOR;
        
        
        MInternetData *internetData = _internetArray[i];
        
        NSString *imageName = STRING_FORMAT(@"logo_%@",[internetData.msite_id lowercaseString]);
        
        UIImage *image = [UIImage imageNamed:imageName];
        

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:Rect(2, 55., image.width*2/3, image.height*2/3)];
        imageView.image = image; 
 
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:Rect(imageView.frameWidth + 5,52.,154- imageView.frameWidth,21)];
        nameLabel.backgroundColor = KCLEAR_COLOR;
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = [UIColor whiteColor];
        

        nameLabel.text = STRING_FORMAT(@"%@ %@",[KTREASURE_DICT objectForKey:[internetData.msite_id lowercaseString]],internetData.mproduct_name);
       
        MLabel *incomeLabel = [[MLabel  alloc] initWithFrame:Rect(0, 13, 154, 40)];
        incomeLabel.backgroundColor = KCLEAR_COLOR;
        incomeLabel.font = FONT(kHelveticaLight, 24);
        incomeLabel.textColor = [UIColor whiteColor];
        incomeLabel.text = STRING_FORMAT(@"%.2f%%",[internetData.mthis_year_return_rate floatValue]/100);
       
        [incomeLabel setFont:FONT(kHelveticaLight, 14) string:@"%"];
        
        incomeLabel.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:incomeLabel];
        [view addSubview:nameLabel];
        [view addSubview:imageView];
        [viewsArray addObject:view];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:rect animationDuration:3];
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
    
  
    self.arryList =[NSMutableArray arrayWithArray:[KPAY_DICT allKeys]];
    
    self.deviceIP = [MUtility deviceIPAdress];
    
    self.customDates = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
    self.view.backgroundColor              = [UIColor blackColor];
    
    self.scrollView.frameY = IsIOS7 ? KHEIGHT_STATUSBAR : 0.0f;
    
    CGSize size =  CGSizeMake(320, self.securityAssuranceView.frame.size.height + self.securityAssuranceView.frameY + ((IsIOS7) ? KHEIGHT_STATUSBAR : 0.0f));
    self.scrollView.contentSize = size;
 
    
    [self setHomeColorView];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeAnimations) name:@"shake" object:nil];
    
    
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
-(void)shakeAnimations{
 
    UIButton *btn = (UIButton *)[self.topContentView viewWithTag:1];
    [self onPromptBuyAction:btn];
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
    queryAction = [[MQueryInvestAction alloc] init];
    queryAction.m_delegate = self;
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
#pragma mark ------------- 摇一摇 -----------------

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
        NSString *canInvestMoney = STRING_FORMAT(@"￥%@",formatValue(_canInvestMoney));

        [self showPopUpWithTitle:canInvestMoney withOption:_arryList xy:CGPointMake(5, 20) size:CGSizeMake(300, 240) isMultiple:YES];
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
    
     MFinanceProductData *l_data = [[MFinanceProductData alloc] init];
    l_data.mpid = star.mstar_pid;
    l_data.mproduct_name = star.mstar_productName;
    
     l_data.mStar = YES;
    self.starData = l_data;
    
    self.star_bank_nameLabel.text = STRING_FORMAT(@"%@ %@", bankName(star.mstar_bankId),star.mstar_productName);
    self.star_bank_logo.image     = bankLogoImage(star.mstar_bankId);
    if (!IsIOS7) {
        self.star_earningsLabel.font =  FONT(kHelveticaLight, 40);
        self.star_cycleLabel.font = FONT(kHelveticaLight, 22);

    }

    self.star_earningsLabel.text  = STRING_FORMAT(@"%.1f",[star.mstar_returnRate floatValue]/100);
     self.star_cycleLabel.text     = STRING_FORMAT(@"%@",star.mstar_investCycle);
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
    
    NSLog(@"--------------------------_total-----%f \n\n",_total);
    
    [self setBalanceLabelValue];
    
}

-(void)onResponseQueryInvestFail{

 
    [self.activityView stopAnimating];
   
}
#pragma mark -------------  colorViewClick -----------------

-(void)colorViewClick:(int)index{
 
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
