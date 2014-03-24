//
//  MChatViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MChatViewController.h"
#import "MActivityCell.h"
#import "MPageData.h"
@interface MChatViewController ()

@end

@implementation MChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"聊天";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏navBack
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem.leftBarButtonItem.customView setHidden:YES];

    
    [self createNavBarTitle:@"活动聊天"];
    
//    [self initRightButtonItem:@"nav_notificationBtn.png" title:@"系统通知" completionHandler:^{
//        
//    }];

    self.tableView.rowHeight = 64.0f;
    self.tableView.backgroundColor = self.view.backgroundColor;

//    listActivityAction = [[MListActivityAction alloc] init];
//    listActivityAction.m_delegate = self;
//    [listActivityAction requestAction];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
     
}

-(NSDictionary*)onRequestListActivityAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:@"1" forKey:@"pageIdx"];
    
    [dict setSafeObject:@"" forKey:@"actName"];
    
    return dict;
}
-(void)onResponseListActivitySuccess:(MPageData *)pageData{
    [self.dataArray addObjectsFromArray:pageData.mpageArray];
    
    [self.tableView reloadData];
}
-(void)onResponseListActivityFail{
    
}
#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MActivityCell";
    MActivityCell *cell = (MActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [MActivityCell loadFromNIB];
        
    }
    cell.data = [self.dataArray safeObjectAtIndex:indexPath.row];
     
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
