//
//  MTreasureViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MInvestRecordViewController.h"
#import "MRecordCell.h"
#import "MPageData.h"
#import "MTradeDetailsViewController.h"
@interface MInvestRecordViewController ()
@property(nonatomic,strong) NSString *investType;
@property (nonatomic,assign) int     totalNum;
@property (nonatomic,assign) int     currPageNum;
@end

@implementation MInvestRecordViewController

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
    [self createNavBarTitle:@"我的投资记录"];
 
    NSArray *itemArray = @[@"全部",@"充值",@"投资",@"提现"];
    
    NSMutableArray *tabItems = [NSMutableArray arrayWithCapacity:0];
    for (int i= 0 ;i < [itemArray count] ; i ++ ) {
        
        RKTabItem *item =  [RKTabItem createUsualItemWithImageEnabled:
                            [UIImage imageNamed:STRING_FORMAT(@"btn_tade_orange%d",i)]
                                                        imageDisabled:[UIImage imageNamed:STRING_FORMAT(@"btn_tade_gray%d",i)]];
        item.titleString = [itemArray safeObjectAtIndex:i];
        item.titleFontColor = [UIColor whiteColor];
        if (i == 0) {
            item.tabState = TabStateEnabled;
        }
        [tabItems addObject:item];
        
        if (i< [itemArray count] -1) {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(((i+1) * 80) - 0.5 , 0.5, 1, 49)];
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
    
    
    self.tableView.rowHeight = 120.0f;
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    _currPageNum =1;
    investAction = [[MInvestRecordAction alloc] init];
    investAction.m_delegate = self;
    [investAction requestAction];
    [self showHUD];
   
}
- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
    
    
    if (index== 0) {
        self.investType = @"0"; //全部
    }else if (index == 1){
        self.investType = @"1";       //充值
    }else if (index == 2){
        self.investType = @"2";       //投资
    }if (index == 3){
        self.investType = @"3";       //提现
    }if (index == 3){
        self.investType = @"4";       //提现
    }
    
    [self.dataArray removeAllObjects];
    [investAction requestAction];
    [self showHUD];
    
}


-(NSDictionary*)onRequestInvestRecordAction{
    MutableOrderedDictionary  *dict = [MutableOrderedDictionary dictionary];
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:[NSNumber numberWithInt:_currPageNum] forKey:@"pageIdx"];

    [dict setSafeObject:[NSNumber numberWithInt:20] forKey:@"pageSize"];
     
    [dict setSafeObject:self.investType forKey:@"tran_type"];

    return dict;
}
-(void)onResponseInvestRecordSuccess:(MPageData *)pageData{
    [self hideHUD];
    self.totalNum = pageData.mnumFound;
    [self.dataArray addObjectsFromArray:pageData.mpageArray];
    
    [self.tableView reloadData];
}
-(void)onResponseInvestRecordFail{
    [self hideHUD];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MRecordCell";
    MRecordCell *cell = (MRecordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [MRecordCell loadFromNIB];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.data = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MTradeDetailsViewController *details = [[MTradeDetailsViewController alloc] initWithNibName:@"MTradeDetailsViewController" bundle:nil];
    details.investData = [self.dataArray safeObjectAtIndex:indexPath.row];
    details.typeValue = 2;
    [self.navigationController pushViewController:details animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([self.dataArray count] - 1 == indexPath.row )&&(indexPath.row < self.totalNum - 1)) {
        
        self.currPageNum ++ ;
        
        [investAction requestAction];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    investAction.m_delegate = nil;
}

@end
