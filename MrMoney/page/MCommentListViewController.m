//
//  MCommentListViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCommentListViewController.h"
#import "MCommentCell.h"
#import "MPageData.h"
@interface MCommentListViewController ()

@end

@implementation MCommentListViewController

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
    
    [self createNavBarTitle:@"产品评论"];
    
    self.tableViewStyle = UITableViewStylePlain;

    self.currPageNum = 1;
    commentListAction = [[MCommentListAction alloc] init];
    commentListAction.m_delegate = self;
    [commentListAction requestAction];
    [self showHUD];
}
-(NSDictionary*)onRequestCommentListAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:self.pid forKey:@"pId"];

    [dict setSafeObject:[NSNumber numberWithInt:self.currPageNum] forKey:@"pageIdx"];

    return dict;

}
-(void)onResponseCommentListSuccess:(MPageData *)pageData{
    [self hideHUD];
    
    self.totalNum = pageData.mnumFound;
    
//    [self.dataArray addObjectsFromArray:pageData.mpageArray];
    [self setTableDataArray:pageData.mpageArray];
   
}
-(void)onResponseCommentListFail{
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([self.dataArray count] - 1 == indexPath.row )&&(indexPath.row < self.totalNum - 1)) {
        
        self.currPageNum ++ ;
        
        [commentListAction requestAction];
    }
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
