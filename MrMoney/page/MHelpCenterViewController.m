//
//  MHelpCenterViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-19.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MHelpCenterViewController.h"
#import "MHelpCell.h"
@interface MHelpCenterViewController ()
@property (strong, nonatomic) NSIndexPath *selectedRowIndexPath;
@property(nonatomic,strong)NSDictionary *dataDict;
@end

@implementation MHelpCenterViewController

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
    [self createNavBarTitle:@"帮助中心"];
   
    self.tableViewStyle = UITableViewStyleGrouped;
     
    
    NSString *filePath = [NSString getBundlePathForFile:@"question.plist"];
    
    self.dataDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.dataArray =[NSMutableArray arrayWithArray:[self.dataDict allKeys]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MHelpCell";
    MHelpCell *cell = (MHelpCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell =   [MHelpCell loadFromNIB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    if (IsIOS7) {
        UIImage *background = [MActionUtility cellBackgroundForRowAtIndexPath:indexPath tableView:tableView];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:background];
        
        UIImage *imageSelectedBack = [MActionUtility cellSelectedBackgroundViewForRowAtIndexPath:indexPath tableView:tableView];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:imageSelectedBack];
        
    }
    cell.answerLabel.hidden = ![self isSelectedIndexPath:indexPath];
  
    NSString *key = [self.dataArray objectAtIndex:indexPath.row];
    cell.questionLabel.text = key;
    float height = [MStringUtility getStringHight:key font:SYSTEMFONT(14) width:280];
    cell.questionLabel.frameHeight = height;
 
    NSString *content = [self.dataDict objectForKey:key];
    float contentHeight = [MStringUtility getStringHight:content font:SYSTEMFONT(14) width:275];
    
    cell.answerLabel.frameHeight = contentHeight + 20;
    cell.answerLabel.text = content;
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView beginUpdates];
    _selectedRowIndexPath = indexPath;

    
    [self.tableView reloadData];
    [self.tableView endUpdates];
}
- (BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.selectedRowIndexPath)
    {
        if (indexPath.row == self.selectedRowIndexPath.row && indexPath.section == self.selectedRowIndexPath.section)
        {
            return YES;
        }
    }
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.dataArray objectAtIndex:indexPath.row];

    
    if ([self isSelectedIndexPath:indexPath]) {
        NSString *content = [self.dataDict objectForKey:key];
         float height = [MStringUtility getStringHight:content font:SYSTEMFONT(14) width:275];
        
        return height + 50;
    }else{
        
        float height = [MStringUtility getStringHight:key font:SYSTEMFONT(14) width:280];
        
        return fmax(height + 18, 44);
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)  return 20.0;
    return 5;
}

@end
