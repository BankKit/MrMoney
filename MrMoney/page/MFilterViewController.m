//
//  MFilterViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFilterViewController.h"
#import "MFilterCell.h"
#import "MRadioButton.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#define KBTNWIDTH 30
@interface MFilterViewController ()
@property(nonatomic,strong)NSMutableDictionary *filterDict;
@property(nonatomic,strong)NSMutableDictionary *editDict;
@property(nonatomic,strong)NSMutableArray *boxArray;
@property(nonatomic,strong)NSMutableDictionary  *bankDict;

@end

@implementation MFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)onConfirmAction:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kfilter" object:self userInfo:self.editDict];
    }];
    
}
-(void)initCheckBoxView{
    _checkBoxBtn.selected = YES;
    for (int i = 0 ; i< [self.bankDict count]; i++) {
        MCheckBox *button      =   [[MCheckBox alloc] initWithDelegate:self];
        
        button.tag            = i;
        
        button.frameWidth     = KBTNWIDTH;//设置按钮坐标及大小
        
        button.frameHeight    = KBTNWIDTH;
        
        button.frameX         = (i%2)*(KBTNWIDTH+96)+98;
        
        button.frameY         = floor(i/2)*(KBTNWIDTH - 3);
        
        
        UILabel *label        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 21)];
        label.textColor       = [UIColor lightGrayColor];
        label.backgroundColor = KCLEAR_COLOR;
        label.font            = SYSTEMFONT(14);
        label.textAlignment   = NSTextAlignmentRight;
        
        label.frameX          = button.frameX - 90;
        label.frameY          = button.frameY + 3;
        NSString *key         = [[self.bankDict allKeys] objectAtIndex:i];
        label.text            = [self.bankDict objectForKey:key];
        
        
        [_buttonView addSubview:button];
        [_buttonView addSubview:label];
    }
    
    int count = [self.bankDict count];
    
    _headerView.frameHeight = (count/2) *(KBTNWIDTH -3) + (count%2==0 ? 74 : 100);
    
    self.tableView.tableHeaderView = _headerView;

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"------------viewWillAppear----------------%d",self.type);
    
    [_buttonView removeAllSubviews];
    [self.filterDict removeAllObjects];
    [self.boxArray removeAllObjects];
    [self.editDict removeAllObjects];
    
    
    if (self.type == MFundType) {
        
        NSDictionary *t_dict =  @{@"bosera": @"博时基金",@"jsfund":@"嘉实基金",@"nfund": @"南方基金",@"lionfund":@"诺安基金",@"efmc": @"易方基金",@"camc": @"华夏基金",@"cmb":@"招商银行"};
        
        self.bankDict = [NSMutableDictionary  dictionaryWithDictionary:t_dict];
        self.filterDict =[NSMutableDictionary dictionaryWithDictionary:[MUtility filterFundDict]];
        
        
    }
    else if (self.type == MFinanceProductsType){
        
        self.bankDict = [NSMutableDictionary  dictionaryWithDictionary:KBANK_DICT];
        [_bankDict removeObjectForKey:@"bosera"];
        [_bankDict removeObjectForKey:@"jsfund"];
        [_bankDict removeObjectForKey:@"lionfund"];
        [_bankDict removeObjectForKey:@"nfund"];
        [_bankDict removeObjectForKey:@"efmc"];
        [_bankDict removeObjectForKey:@"camc"];
        self.filterDict =[NSMutableDictionary dictionaryWithDictionary:[MUtility filterDict]];
        
    }else if (self.type == MInternetType){
        self.bankDict = [NSMutableDictionary  dictionaryWithDictionary:KTREASURE_DICT];

    }
    
    [self initCheckBoxView];
    
    
    [self.tableView reloadData];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.20 green:0.21 blue:0.23 alpha:1.00];
    self.topView.backgroundColor = self.tableView.backgroundColor;
    
 
    if (!IsIOS7) {
        _topView.frameY = _topView.frameY - 20;
        _tableView.frameY = _tableView.frameY - 20;
        _tableView.frameHeight = _tableView.frameHeight + 20;
    }
    
    
    self.tableView.backgroundView = nil;
    
    self.filterDict =[NSMutableDictionary dictionaryWithDictionary:[MUtility filterDict]];
    
    [_confirmBtn  setBackgroundImage:[[UIImage imageNamed:@"btn_black_normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    
    self.editDict = [NSMutableDictionary dictionary];
    
    self.boxArray = [NSMutableArray arrayWithCapacity:0];
    
    _checkBoxBtn      =   [[MCheckBox alloc] initWithDelegate:self];
    [_checkBoxBtn setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    [_checkBoxBtn setImage:[UIImage imageNamed:@"btn_check_light"] forState:UIControlStateSelected];
    _checkBoxBtn.frame = Rect(229,40, 30, 30);
    _checkBoxBtn.tag = 100;
    _checkBoxBtn.selected = YES;
    [self.headerView addSubview:_checkBoxBtn];
    
    [self initCheckBoxView];
    
 
}

#pragma mark - MCheckBoxDelegate

- (void)didSelectedCheckBox:(MCheckBox *)checkbox checked:(BOOL)checked{
    
    if (checkbox.tag == 100) {
        checkbox.selected= YES;
        [self.boxArray removeAllObjects];
        
        for (MCheckBox *view in [_buttonView subviews]) {
            if ([view isKindOfClass:[MCheckBox class]]) {
                view.selected = NO;
            }
        }
        
        [self.boxArray addObject:@"none"];
        
    }
    else
    {
        _checkBoxBtn.selected = NO;
        
        NSArray *keyArray = [self.bankDict allKeys];
        NSString *key = [keyArray objectAtIndex:checkbox.tag];
        
        if ([self.boxArray containsObject:@"none"]) {
            [self.boxArray removeObject:@"none"];
        }
        if ([self.boxArray containsObject:[key uppercaseString]]) {
            [self.boxArray removeObject:[key uppercaseString]];
        }else{
            [self.boxArray addObject:[key uppercaseString]];
        }
        
    }
    
    NSString *content = [self.boxArray componentsJoinedByString:@","];
    
    if ([content isEqualToString:@""]) {
        _checkBoxBtn.selected = YES;
        content = @"none";
    }
  
    NSString *l_key = nil;
    if (self.type == MFundType) {
        l_key = @"fund_id";
    }else if (self.type == MFinanceProductsType){
        l_key = @"bank_id";
    }else{
        l_key = @"site_id";
    }
    [self.editDict setSafeObject:content forKey:l_key];
    
}
#pragma mark - MRadio delegate
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    
    
    NSArray *keyArray       = [self.filterDict allKeys];
    NSString *key           = [keyArray objectAtIndex:[groupId intValue]];
    NSMutableArray *countArray     =[NSMutableArray arrayWithArray:[self.filterDict objectForKey:key]];
    
    
    
    for (int i = 0 ; i <[countArray count] ; i ++) {
        
        NSMutableDictionary *replaceDict =[NSMutableDictionary dictionaryWithDictionary:[countArray objectAtIndex:i]];
        
        if (i != index) {
            
            [replaceDict setObject:@"NO" forKey:@"selected"];
        }else{
            [replaceDict setObject:@"YES" forKey:@"selected"];
            
        }
        [countArray replaceObjectAtIndex:i withObject:replaceDict];
    }
    
    [self.filterDict setObject:countArray forKey:key];
    
    
    NSDictionary *radioDict = [countArray objectAtIndex:index];
    NSString *content =  [radioDict objectForKey:@"content"];
    NSString *radioKey = nil;
    if (self.type == MFundType) {
        if ([key isEqualToString:@"选择基金类型"]) {
            radioKey = @"product_type";
        }
    }else if(self.type == MFinanceProductsType){
        if ([key isEqualToString:@"选择起售金额"]) {
            radioKey = @"lowest_amount";
        }else if([key isEqualToString:@"选择货币"]){
            radioKey = @"currency";
        }if([key isEqualToString:@"选择期限"]){
            radioKey = @"invest_cycle";
        }if([key isEqualToString:@"选择保本类型"]){
            radioKey = @"break_even";
        }if([key isEqualToString:@"选择收益率"]){
            radioKey = @"return_rate";
        }if([key isEqualToString:@"选择区域"]){
            radioKey = @"sales_region";
        }
        
    }
    
    NSLog(@"----------content -----%@ ------- key ----- %@",content,radioKey);
    
    [self.editDict setObject:content forKey:radioKey];
    
}

#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.filterDict count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keyArray = [self.filterDict allKeys];
    NSString *key = [keyArray objectAtIndex:section];
    NSArray *countArray = [self.filterDict objectForKey:key];
    
    return [countArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MFilterCell";
    
    MFilterCell *cell = (MFilterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell== nil) {
        
        cell = [MFilterCell loadFromNIB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSArray *keyArray    = [self.filterDict allKeys];
    NSString *key        = [keyArray objectAtIndex:indexPath.section];
    NSArray *countArray  = [self.filterDict objectForKey:key];
    NSDictionary *cellDict = [countArray  objectAtIndex:indexPath.row];
    NSString *groupId = STRING_FORMAT(@"%d",indexPath.section);
    MRadioButton *radioBtn = [[MRadioButton alloc] initWithGroupId:groupId index:indexPath.row];
    radioBtn.frame = CGRectMake(230,2,30,30);
    
    [MRadioButton addObserverForGroupId:groupId observer:self];
    [cell.contentView  addSubview:radioBtn];
 
    if ([[cellDict objectForKey:@"selected"] isEqualToString:@"YES"]) {
      [radioBtn setChecked:YES];
    }
     
    
    cell.titleLabel.text = [cellDict objectForKey:@"title"];
    
    return cell;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *keyArray   = [self.filterDict allKeys];
    NSString *key       = [keyArray objectAtIndex:section];
    
    UIView *view                = [[UIView alloc] initWithFrame:Rect(0., 0., 270., 35.)];
    view.backgroundColor        =  [UIColor colorWithRed:0.20 green:0.21 blue:0.23 alpha:1.00];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_border"]];
    imageView.frame = Rect(0., 30., 270., 5.);
    [view addSubview:imageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:Rect(10., 5., 200., 25.)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = view.backgroundColor;
    label.font = SYSTEMFONT(14);
    label.text = key;
    [view addSubview:label];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
