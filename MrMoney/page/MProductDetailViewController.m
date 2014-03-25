//
//  MProductDetailViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MProductDetailViewController.h"
#import "MCommentCell.h"
#import "MFinanceProductData.h"
#import "MPurchaseViewController.h"
#import "MCommentListViewController.h"
#import "MPageData.h"
#import "MUserData.h"
#import "MRiskAssessmentViewController.h"
#import "NSDate+Calendar.h"
#import "MMapViewController.h"


@interface MProductDetailViewController ()
@property(nonatomic,assign)BOOL isSoldout;//下架
@end

@implementation MProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSDictionary*)onRequestProductDetailAction{
    return @{@"pid": self.data.mpid};
}
-(void)onResponseProductDetailSuccess:(MFinanceProductData *)product{
    [self hideHUD];
    
    commentListAction = [[MCommentListAction alloc] init];
    commentListAction.m_delegate = self;
    [commentListAction requestAction];
 
    
    [self setViewData:product];
  
   [self.tableView reloadData];
}
-(void)onResponseProductDetailFail{
    [self hideHUD];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavBarTitle:@"产品详情"];

//    [self initRightButtonItem:@"nav_more.png" title:@"更多选项" completionHandler:^{
//        
//    }];
     
    
    if (self.data.mStar) {
        detailAction = [[MProductDetailAction alloc] init];
        detailAction.m_delegate = self;
        [detailAction requestAction];
        [self showHUD];
    }else{
        
        commentListAction = [[MCommentListAction alloc] init];
        commentListAction.m_delegate = self;
        [commentListAction requestAction];
        [self showHUD];
        
        
        [self setViewData:self.data];
       
    }
 
     [self addContainerAction];
    
}
-(NSDictionary*)onRequestCommentListAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:self.data.mpid forKey:@"pId"];
    
    [dict setSafeObject:[NSNumber numberWithInt:1] forKey:@"pageIdx"];
    
    return dict;
    
}
-(void)onResponseCommentListSuccess:(MPageData *)pageData{
    [self hideHUD];
    
    [self.dataArray addObjectsFromArray:pageData.mpageArray];
    
    [self addContainerAction];
    
    [self.tableView reloadData];
}
-(void)onResponseCommentListFail{
    [self hideHUD];
}
-(void)addContainerAction{
    
    
    
    _topContainer.frameX     = 10.;
    _topContainer.frameY     = 10.;
    _middleContainer.frameX  = 10.;
    _commentContainer.frameX = 10.;
    
    if ([self.dataArray count] > 0) {
        MCommentData *data = [self.dataArray safeObjectAtIndex:0];
        MCommentData *data1 = [self.dataArray safeObjectAtIndex:1];
        
        float height  = [MCommentCell heightForCommentCell:data];
        float height1 = [MCommentCell heightForCommentCell:data1];
        
        _commentContainer.frameHeight = 45 + height + height1;
    }
    else{
        _commentContainer.frameHeight = 40;
    }
    
    
    [_middleContainer lockDistance:10. toView:_topContainer measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
 
    
    [_commentContainer lockDistance:10. toView:_middleContainer measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
    [self.scrollView addSubview:_middleContainer];
    [self.scrollView addSubview:_topContainer];
    [self.scrollView addSubview:_commentContainer];
    
    
    [self.scrollView setContentSize:CGSizeMake(320,  _commentContainer.frameY + _commentContainer.frameHeight + 10.)];
    
    
}

-(IBAction)onBuyAction:(id)sender{
    __weak MProductDetailViewController *wself = self;
    if (!isUserLogin()) {
       
        [MGo2PageUtility go2MLoginViewController:self completionHandler:^{
            [wself pushViewControllerAction];
        }];
    }else{
        
        [self pushViewControllerAction];
        
    }
    
}
-(void)pushViewControllerAction{
    NSArray *array = [MUserData allDbObjects];
    
    MUserData *user =[array isEmpty] ? [array objectAtIndex:0]: nil;
    
    if ([user.mriskEvalue intValue] == 0) {
        MRiskAssessmentViewController *risk = [[MRiskAssessmentViewController alloc] initWithNibName:@"MRiskAssessmentViewController" bundle:nil];
        risk.data = _data;
        risk.bankType = self.bankType;
        [self.navigationController pushViewController:risk animated:YES];
    }
    else
    {
        if (self.isSoldout) {
            MMapViewController *map = [[MMapViewController alloc] initWithNibName:@"MMapViewController" bundle:nil];
            map.navTitle = bankName(self.data.mbank_id);
            [self.navigationController pushViewController:map animated:YES];

        }else{
            [MGo2PageUtility  go2PurchaseViewController:self data:_data pushType:MProductDetailsType buyMoney:@""];
        }
    }
    
}
-(void)setViewData:(MFinanceProductData *)data{
    
    NSString *bank_name = nil;
    
    NSArray *keyArray =    [KTREASURE_DICT allKeys];
    
    if ([keyArray containsObject:[_data.mbank_id lowercaseString]]) {
        bank_name = [KTREASURE_DICT objectForKey:[_data.mbank_id lowercaseString]];
    }else{
        bank_name            = bankName(_data.mbank_id);
    }
    

    
    
    self.product_nameLabel.text        = strOrEmpty(data.mproduct_name);
    
    CGFloat height = [MStringUtility getStringHight:data.mproduct_name font:SYSTEMFONT(16) width:260.];
    
    self.product_nameLabel.frameHeight = height + 5.;
    
    UIView *contentView                = [_topContainer viewWithTag:1];
    
    contentView.frameY                 = self.product_nameLabel.frameY + self.product_nameLabel.frameHeight - 5.;
    
    _topContainer.frameHeight          = contentView.frameY + contentView.frameHeight ;
    
    
    self.bank_logo_iv.image            = bankLogoImage(data.mbank_id);
    
    self.bank_logo_iv.frameWidth       = [bankLogoImage(_data.mbank_id) size].width/2;
    
    self.bankNameLabel.frameX          = self.bank_logo_iv.frameX +  self.bank_logo_iv.frameWidth  + 5;
    
    
    self.bankNameLabel.text            = bank_name;
    
    self.befromLabel.text             = STRING_FORMAT(@"来自于【%@网上银行】",bankName(_data.mbank_id));
 
    self.expect_earningsLabel.text     =STRING_FORMAT(@"%.1f%%",[data.mreturn_rate floatValue]/100);
    
    if ([_data.minvest_cycle intValue] == -1) {
        self.invest_cycleLabel.text             = @"灵活周期";
    }else{
        self.invest_cycleLabel.text        = STRING_FORMAT(@"%@天",strOrEmpty(data.minvest_cycle));
    }

    
    
    self.has_guaranteeLabel.text       = [strOrEmpty(data.mbreak_even) intValue] == 0 ?@"不保本" :@"保本";
    self.sales_regionLabel.text        = strOrEmpty(data.msales_region);
    
    self.currency_typeLabel.text       = strOrEmpty(data.mcurrency);
 
    
    //无法购买 起息日前一天 12点之后 就不能购买
    
    NSDate *dateToday= [[MUtility dateFormatter:data.mvalue_date formatter:kDefaultDateFormat2] dateToday];
  
    self.value_dateLabel.text     = [MUtility stringForDate:dateToday];
    NSDate *yesterday = [dateToday dateYesterday];
    
    NSDate *expireDate =[self zoneDate:[NSDate dateWithYear:[yesterday year] month:[yesterday month] day:[yesterday day] hour:12 minute:0 second:0]];
    
    NSDate *nowDate =[self zoneDate:[NSDate date]];
 
 
    if (![MUtility filterKeyword:self.data.mproduct_name bankId:[self.data.mbank_id uppercaseString]]) {
        [_bottomBtn setBackgroundImage:KDEFAULT_BTN forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"钱先生带您去附近网点购买" forState:UIControlStateNormal];
        _bottomBtn.userInteractionEnabled = YES;
        self.isSoldout = YES;
    }else
        if ([expireDate isLessDate:nowDate]) {
        [_bottomBtn setBackgroundImage:KDEFAULT_GRAY_BTN forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"产品过期无法购买" forState:UIControlStateNormal];
        _bottomBtn.userInteractionEnabled = NO;
    }
 
    
}
-(NSDate *)zoneDate:(NSDate *)date{
  
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];

    return  [date dateByAddingTimeInterval:interval];
}

-(void)prformButtonClick:(id)sender{
    CGPoint point =   CGPointMake(300, 0);
    [PopoverView showPopoverAtPoint:point
                             inView:self.view
                    withStringArray:[NSArray arrayWithObjects:@" 收  藏    ",@" 分  享  ",@" 评  论  ",@" 复  制  ", nil]
                           delegate:self];
}
#pragma mark - PopoverViewDelegate Methods

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    
    [popoverView dismiss];
}



-(IBAction)onCommentListAction:(id)sender{
    MCommentListViewController *commentList = [[MCommentListViewController alloc] init];
    commentList.pid = self.data.mpid;
    [self.navigationController  pushViewController:commentList animated:YES];
}

#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MCommentCell";
    MCommentCell *cell = (MCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [MCommentCell loadFromNIB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.data = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCommentData *data = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    return [MCommentCell heightForCommentCell:data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
