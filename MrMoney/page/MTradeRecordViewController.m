//
//  MTradeRecordVViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MTradeRecordViewController.h"
 
#import "MTradeRecodsCell.h"
#import "MTradeDetailsViewController.h"
#import "MPageData.h"
@interface MTradeRecordViewController ()
@property (nonatomic,assign) int     totalNum;
@property (nonatomic,assign) int     currPageNum;
@end

@implementation MTradeRecordViewController

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
    [self createNavBarTitle:@"账户明细"];
     
    self.tableView.rowHeight = 60.;
    
    _currPageNum = 1;
    
    tradeAction = [[MTradeRecordAction alloc] init];
    tradeAction.m_delegate = self;
    [tradeAction requestAction];
    [self showHUD];
    
  
}
-(NSDictionary*)onRequestTradeRecordAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:[NSNumber numberWithInt:_currPageNum] forKey:@"pageIdx"];
    
    [dict setSafeObject:[NSNumber numberWithInt:20] forKey:@"pageSize"];
    
    return dict;
}
 
-(void)onResponseTradeRecordSuccess:(MPageData *)page{
    
    [self hideHUD];
    
    self.totalNum = page.mnumFound;
    
    [self.dataArray addObjectsFromArray:page.mpageArray];
    
    [self.tableView reloadData];
    
}
-(void)onResponseTradeRecordFail{
    [self hideHUD];
}
#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MTradeRecodsCell";

    MTradeRecodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
 
        cell = [MTradeRecodsCell loadFromNIB];
   
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         

    }
    
    cell.data = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MTradeDetailsViewController *details = [[MTradeDetailsViewController alloc] initWithNibName:@"MTradeDetailsViewController" bundle:nil];
    details.data = [self.dataArray safeObjectAtIndex:indexPath.row];
    details.typeValue = 1;
    [self.navigationController pushViewController:details animated:YES];
 
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([self.dataArray count] - 1 == indexPath.row )&&(indexPath.row < self.totalNum - 1)) {
        
        self.currPageNum ++ ;
        
        [tradeAction requestAction];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    tradeAction.m_delegate = nil;
}
@end
