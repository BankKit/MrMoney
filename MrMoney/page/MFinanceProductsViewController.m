//
//  MFinanceProductsViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MFinanceProductsViewController.h"
#import "MInternetDetailViewController.h"
#import "MFinanceProductsCell.h"
#import "MProductDetailViewController.h"
#import "MFilterViewController.h"
#import "MPageData.h"
#import "MFinanceProductData.h"
#import "UIViewController+MMDrawerController.h"
#import "MStatusUtility.h"
#import "MFundDetailViewController.h"
#import "MActProductData.h"
#import "MSeckillViewController.h"
#import "MLogoView.h"
#import "UIViewController+style.h"
@interface MFinanceProductsViewController ()
@property(nonatomic,strong)NSDictionary *editDict;
@property(nonatomic,strong)MActProductData *actData;
@property(nonatomic,assign)BOOL isFirst;
@property (nonatomic,strong) MScrollFullScreen *scrollProxy;
@end

@implementation MFinanceProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setHeaderViewUI{
    self.secBank_logo.image = bankLogoImage(self.actData.mbankId);
    self.secProduct_nameLabel.text =STRING_FORMAT(@"%@ %@",bankName(self.actData.mbankId),strOrEmpty(self.actData.mproductName));
    self.secProdRateLabel.text = STRING_FORMAT(@"%.1f",[self.actData.mprodRate floatValue]/100);
    self.secExpectedReturnRateLabel.text = STRING_FORMAT(@"%.2f%%",[self.actData.mexpectedReturnRate floatValue]/100);
    self.secDRateLabel.text =  STRING_FORMAT(@"%.2f%%",[self.actData.mdRate floatValue]/100);;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.isFirst = YES;
    
    _scrollProxy = [[MScrollFullScreen alloc] initWithForwardTarget:self];
     
      self.tableView.delegate = (id)_scrollProxy;
    
    _scrollProxy.delegate = self;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.backgroundColor = self.tableView.frameHeight - 49.;
    
    NSArray *itemArray = nil;
    if (self.type == MFundType) {
        itemArray = @[@"周回报率",@"年回报率",@"累计回报率",@"筛选"];
    }else if (self.type == MInternetType){
        itemArray = @[@"七日年化收益",@"投资起售金额",@"筛选"];
    }else{
          itemArray = @[@"收益率",@"期限",@"热度",@"筛选"];

    }
    
    int count = [itemArray count];
    NSMutableArray *tabItems = [NSMutableArray arrayWithCapacity:0];
    
    for (int i= 0 ;i < count ; i ++ ) {
        
        NSString *selected_name = self.type == MFundType ? STRING_FORMAT(@"fund_selected_%d",i+1):STRING_FORMAT(@"btn_segment_selected%d",i+1);
        
        NSString *normal_name = self.type == MFundType ? STRING_FORMAT(@"fund_normal_%d",i+1):STRING_FORMAT(@"btn_segment_normal%d",i+1);
        
        RKTabItem *item =  [RKTabItem createUsualItemWithImageEnabled:
                            [UIImage imageNamed:selected_name] imageDisabled:[UIImage imageNamed:normal_name]];
        item.titleString = [itemArray objectAtIndex:i];
        item.titleFontColor = [UIColor whiteColor];
        if (i == 0) {
            item.tabState = TabStateEnabled;
        }
        [tabItems addObject:item];
        
        if (i< count - 1) {
            CGRect rect;
            if (self.type ==MInternetType) {
                _filterBtn.frameWidth = 106;
                _filterBtn.frameX = 212;
                rect = CGRectMake(((i+1) * 107) - 0.8 , 0.8, 1, 49);
            }else{
               rect =  CGRectMake(((i+1) * 80) - 0.5 , 0.5, 1, 49);
            }

            UILabel *lineLabel = [[UILabel alloc] initWithFrame:rect];
            lineLabel.tag = i + 1 + 100;
            lineLabel.backgroundColor =  [UIColor lightGrayColor];;
            lineLabel.alpha = 0.3;
            
            [self.standardView addSubview:lineLabel];
        }
        
    }
 
 
    self.standardView.backgroundColor  = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.standardView.enabledTabBackgrondColor = [UIColor colorWithRed:0.20 green:0.21 blue:0.23 alpha:1.00];
    self.standardView.darkensBackgroundForEnabledTabs = YES;
    self.standardView.drawSeparators = YES;
    
    self.standardView.tabItems = tabItems;
    
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
     self.currPageNum = 1;
    
    if (self.type == MFundType) {
        [self createNavBarTitle:@"基金产品"];
        
        self.sortType = @"week_return";
        fundAction = [[MFundAction alloc] init];
        fundAction.m_delegate = self;
        [fundAction requestAction];
       
    }else if(self.type == MInternetType){
        self.sortType = @"week_return_rate";
        financeAction = [[MFinanceProductAction alloc] init];
        financeAction.m_delegate = self;
        [self createNavBarTitle:@"互联网产品"];
        [financeAction requestAction:(NSString*)M_URL_internetProduct];
 
        
    }else{
        [self createNavBarTitle:@"理财产品"];
        self.sortType = @"return_rate";
        
        financeAction = [[MFinanceProductAction alloc] init];
        financeAction.m_delegate = self;
        self.tableView.tableHeaderView = self.headerView;
        _headerView.hidden = YES;
        [financeAction requestAction:(NSString*)M_URL_FinanceProduct];
        
    }
    
    [self showHUD];
    
    if (!user_defaults_get_bool(@"isShade")) {
        _shadeImageView.hidden = NO;
        _shadeImageView.userInteractionEnabled = YES;
        [self.view insertSubview:_shadeImageView aboveSubview:self.tableView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_shadeImageView addGestureRecognizer:singleTap];
    }
    
    [self.view insertSubview:_filterBtn aboveSubview:self.tableView];
    [self.view insertSubview:_standardView aboveSubview:self.tableView];
    [self.view insertSubview:_shadeImageView aboveSubview:_standardView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterAction:) name:@"kfilter" object:nil];
    
}
//秒杀
- (IBAction)onSeckillAction:(id)sender{
    NSLog(@"-------------onSeckillAction-----------------");
    MSeckillViewController *seckill = [[MSeckillViewController alloc] initWithNibName:@"MSeckillViewController" bundle:nil];
    seckill.actData = self.actData;
    [self.navigationController pushViewController:seckill animated:YES];
}
-(void)singleTap:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)[sender view];
    imageView.hidden = YES;
    user_defaults_set_bool(@"isShade", YES);
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [MStatusUtility clearCollectData];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }
    
}
- (void) filterAction:(NSNotification*) notification{
    
    self.editDict = [notification userInfo];//获取到传递的对象
    
    [self.dataArray removeAllObjects];
    self.currPageNum = 1;
    if (self.type == MFundType)
        [fundAction requestAction];
    else if(self.type == MInternetType)
        [financeAction requestAction:(NSString *)M_URL_internetProduct];
    else
        [financeAction requestAction:(NSString *)M_URL_FinanceProduct];
    [self showHUD];
    
}

#pragma mark - RKTabViewDelegate

- (IBAction)onFilterAction:(id)sender {
    
    MFilterViewController *filter =(MFilterViewController *)self.mm_drawerController.rightDrawerViewController;
    filter.type = self.type;
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
    
}
- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
    
    if (index== 0) {
        if (self.type == MFundType) {
            self.sortType = @"week_return";
        }else if (self.type == MInternetType){
            self.sortType = @"week_return_rate";
        }else{
            self.sortType = @"return_rate";
        }

    }else if (index == 1){
        if (self.type == MFundType) {
            self.sortType = @"year_return";
        }else if (self.type == MFinanceProductsType){
            self.sortType = @"invest_cycle";
        }else{
            self.sortType = @"lowest_amount";
        }
   
    }else if (index == 2){
        self.sortType =self.type == MFundType ? @"establish_return": @"progress_value";//进度
    }
    
    
    [self.dataArray removeAllObjects];
    self.currPageNum = 1;
    
    if (self.type == MFundType ) [fundAction requestAction];
    else if(self.type == MInternetType)
        [financeAction requestAction:(NSString *)M_URL_internetProduct];
    else
        [financeAction requestAction:(NSString *)M_URL_FinanceProduct];
    
    [self showHUD];
    
}
#pragma mark
#pragma mark 基金产品 delegate
-(NSDictionary*)onRequestFundAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    NSString *product_type = [self.editDict objectForKey:@"product_type"];
    NSString *sort         = [self.editDict objectForKey:@"sort"];
    NSString *fund_id      = [self.editDict objectForKey:@"fund_id"];
    
    
    [dict setSafeObject:fund_id?fund_id:@"none" forKey:@"fund_id"];
    [dict setSafeObject:product_type?product_type : @"none" forKey:@"product_type"];
    [dict setSafeObject:sort?sort:self.sortType forKey:@"sort"];
    [dict setSafeObject:[NSNumber numberWithInt:self.currPageNum] forKey:@"pageIdx"];
    
    return dict;
}
-(void)onResponseFundSuccess:(MPageData *)pageData{
    [self hideHUD];
    self.totalNum = pageData.mnumFound;
    
    [self.dataArray addObjectsFromArray:pageData.mpageArray];
    
    [self.tableView reloadData];
    
}
-(void)onResponseFundFail{
    [self hideHUD];
}

#pragma mark
#pragma mark 理财产品 delegate
-(NSDictionary*)onRequestFinanceProductAction{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.type == MInternetType) {
        NSString *site_id = [self.editDict objectForKey:@"site_id"];
        
        [dict setSafeObject:site_id?site_id:@"none" forKey:@"site_id"];
        [dict setSafeObject:@"none" forKey:@"week_return_rate"];
        [dict setSafeObject:@"none" forKey:@"lowest_amount"];
        [dict setSafeObject:@"none" forKey:@"keywords"];
        [dict setSafeObject:self.sortType forKey:@"sort"];
        
    }else{
        NSString *bank_id       = [self.editDict objectForKey:@"bank_id"];
        NSString *currency      = [self.editDict objectForKey:@"currency"];
        NSString *sales_region  = [self.editDict objectForKey:@"sales_region"];
        NSString *return_rate   = [self.editDict objectForKey:@"return_rate"];
        NSString *lowest_amount = [self.editDict objectForKey:@"lowest_amount"];
        NSString *invest_cycle  = [self.editDict objectForKey:@"invest_cycle"];
        NSString *break_even    = [self.editDict objectForKey:@"break_even"];
        
        [dict setSafeObject:bank_id?bank_id:@"none" forKey:@"bank_id"];
        [dict setSafeObject:currency?currency:@"none" forKey:@"currency"];
        [dict setSafeObject:sales_region?sales_region:@"none" forKey:@"sales_region"];
        [dict setSafeObject:return_rate?return_rate:@"none" forKey:@"return_rate"];
        [dict setSafeObject:lowest_amount?lowest_amount:@"none" forKey:@"lowest_amount"];
        [dict setSafeObject:invest_cycle?invest_cycle:@"none" forKey:@"invest_cycle"];
        [dict setSafeObject:break_even?break_even:@"none" forKey:@"break_even"];
        [dict setSafeObject:self.sortType forKey:@"sort"];
       
    }
   

    [dict setSafeObject:[NSNumber numberWithInt:self.currPageNum] forKey:@"pageIdx"];
    
    return dict;
}

-(void)onResponseFinanceProductSuccess:(MPageData *)pageData actData:(MActProductData *)actData{
    
    [self hideHUD];
    
    _headerView.hidden = NO;
    
    self.actData = actData;
    
    self.totalNum = pageData.mnumFound;
    
    [self.dataArray addObjectsFromArray:pageData.mpageArray];
    
    if (self.isFirst) {
        
        [self setHeaderViewUI];
        
        if (self.type==MPopType) {
            [self bk_performBlock:^(id obj) {
                [self onSeckillAction:nil];
            } afterDelay:0.6];
        }
        
    }
    
    self.isFirst = NO;
    
    
    [self.tableView reloadData];
}
-(void)onResponseFinanceProductFail{
    [self hideHUD];
    [MActionUtility showAlert:@"网络异常"];

}
 
#pragma mark -----------tableView delegate----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MFinanceProductsCell";
    MFinanceProductsCell *cell = (MFinanceProductsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [MFinanceProductsCell loadFromNIB];
        
    }
    
    if (self.type == MFundType) {
        cell.sortType = self.sortType;
        cell.fund =  [self.dataArray safeObjectAtIndex:indexPath.row];
        
    }else if(self.type == MInternetType){
        cell.sortType = self.sortType;
        cell.internet =  [self.dataArray safeObjectAtIndex:indexPath.row];

    }else{
        cell.data =  [self.dataArray safeObjectAtIndex:indexPath.row];;       
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == MFundType) {
        MFundData *fund = [self.dataArray safeObjectAtIndex:indexPath.row];
        if (fund) {
            MFundDetailViewController *detail = [[MFundDetailViewController alloc] initWithNibName:@"MFundDetailViewController" bundle:nil];
            detail.fund = fund;
            [self.navigationController pushViewController:detail animated:YES];
            
        }
   
    }else if(self.type ==  MInternetType){
        
        MInternetData *data = [self.dataArray safeObjectAtIndex:indexPath.row];
        if (data) {
            MInternetDetailViewController *internet = [[MInternetDetailViewController alloc] initWithNibName:@"MInternetDetailViewController" bundle:nil];
            internet.data = data;
            [self.navigationController pushViewController:internet animated:YES];
        }

    }else{
        
        MFinanceProductData *data = [self.dataArray safeObjectAtIndex:indexPath.row];
        if (data) {
            [MGo2PageUtility go2MProductDetailViewController:self data:data];
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([self.dataArray count] - 1 == indexPath.row )&&(indexPath.row < self.totalNum - 1)) {
        
        self.currPageNum ++ ;
        if (self.type == MFundType)
            [fundAction requestAction];
        else if(self.type == MInternetType)
            [financeAction requestAction:(NSString *)M_URL_internetProduct];
        else
            [financeAction requestAction:(NSString *)M_URL_FinanceProduct];
    }
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68.0f;
}

#pragma mark -
#pragma mark - MScrollFullScreenDelegate

- (void)scrollFullScreen:(MScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    
    [self move:_standardView height:-deltaY]; // move to revese direction
        [self move:_filterBtn height:-deltaY];
}

- (void)scrollFullScreen:(MScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self showBarView:_standardView];
    [self showBarView:_filterBtn];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(MScrollFullScreen *)proxy
{
    [self hiddenBarView:_standardView];
        [self hiddenBarView:_filterBtn];

}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(MScrollFullScreen *)proxy
{
    [self showBarView:_standardView];
       [self showBarView:_filterBtn];
}


-(void)dealloc{
    financeAction.m_delegate = nil;
    fundAction.m_delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kfilter" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
