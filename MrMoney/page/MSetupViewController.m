//
//  MSetupViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MSetupViewController.h"
#import "MAccountCell.h"
#import "MLoginViewController.h"
#import "MAccountInfoViewController.h"
#import "MAboutViewController.h"
#import "AppDelegate.h"
#import "MHelpCenterViewController.h"
#import "SGActionView.h"
#import "ShareEngine.h"
@interface MSetupViewController ()

@end

@implementation MSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏navBack
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
    
    [self createNavBarTitle:@"系统设置"];
    
    self.tableView.backgroundColor = KVIEW_BACKGROUND_COLOR;
    
    self.tableView.rowHeight = 45.0f;
    self.tableView.backgroundView = nil;
    
    
    self.imageArray = [NSArray arrayWithObjects:PNGIMAGE(@"setup_account"),PNGIMAGE(@"setup_upgrade"),PNGIMAGE(@"setup_share"),PNGIMAGE(@"setup_help"),PNGIMAGE(@"setup_about"),nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.titleArray = [NSArray arrayWithObjects:isUserLogin() ? @"账户信息":@"账户登录",@"在线升级",@"推荐给好友",@"帮助中心",@"关于", nil];
    
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
        if (IsIOS7) {
            UIImage *background = [[UIImage imageNamed:@"ZHCellSingleNormal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            cell.backgroundView = [[UIImageView alloc] initWithImage:background];
            cell.backgroundColor = KVIEW_BACKGROUND_COLOR;
            
            UIImage *imageSelectedBack = [MActionUtility cellSelectedBackgroundViewForRowAtIndexPath:indexPath tableView:tableView];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:imageSelectedBack];
            
        }
   
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor =[UIColor blackColor];
        
        cell.detailTextLabel.textColor =[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:0.6];
        cell.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];

       
    }
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.section];
    
    cell.imageView.image =[self.imageArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 1) {
        cell.detailTextLabel.text = STRING_FORMAT(@"当前版本:v%@",APP_VERSION);
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        if (isUserLogin()) {
            MAccountInfoViewController *info = [[MAccountInfoViewController alloc] initWithNibName:@"MAccountInfoViewController" bundle:nil];
            [self.navigationController pushViewController:info animated:YES];
            
        }
        else
        {
            
            [MGo2PageUtility go2MLoginViewController:self completionHandler:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];
                
            }];
            
        }
        
    }else if (indexPath.section == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KITUNES_URL]];
    }else if (indexPath.section == 4) {
        MAboutViewController *about = [[MAboutViewController alloc] initWithNibName:@"MAboutViewController" bundle:nil];
        
        [self.navigationController pushViewController:about animated:YES];
    }else if (indexPath.section == 2){
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

        
    }else if(indexPath.section == 3){
        MHelpCenterViewController *help = [[MHelpCenterViewController alloc] initWithNibName:@"MHelpCenterViewController" bundle:nil];
        [self.navigationController pushViewController:help animated:YES];
    }
    
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)  return 20.0;
 
    return 0.;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

