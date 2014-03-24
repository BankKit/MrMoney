//
//  MCenterCalendarViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-12.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCenterCalendarViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MCalendarData.h"
#import "MCalendarCell.h"
#import "MEvaluateViewController.h"
@interface MCenterCalendarViewController ()
@property(nonatomic,strong) MEvaluateViewController *evaluate;
@property(nonatomic,strong) MCalendarData *calendarData;
@end

@implementation MCenterCalendarViewController

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
    
    [self createNavBarTitle:@"       投资日记"];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.tableView.frame;
    self.scrollView.hidden = YES;
    [_bottomView.layer borderWidth:1.0 borderColor:KVIEW_BORDER_COLOR cornerRadius:6.];
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_diary_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_diary_light"] stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateHighlighted];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 150.;
 
  
    _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10,0,300,21)];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.backgroundColor = KCLEAR_COLOR;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.kern = 1;
    _contentLabel.leading = 10;
 
    
    [self.scrollView addSubview:_contentLabel];
 
    _evaluate = (MEvaluateViewController *)self.mm_drawerController.rightDrawerViewController;
    
    [self.mm_drawerController setRightDrawerViewController:nil];
 
  
 
    calendarAction =  [[MCalendarAction alloc] init];
    calendarAction.m_delegate = self;
    [calendarAction requestAction];
    [self showHUD];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(notification:) name:@"toggleDrawerSide" object:nil];
}

-(void)notification:(NSNotification *)notification{
 
    self.dataArray = [NSMutableArray arrayWithArray:notification.object];
    
    MCalendarData *data = [self.dataArray safeObjectAtIndex:0];
    
    _dateLabel.text = [MUtility stringForDate:data.minvestDate];
    
    if ([self.dataArray count]>0) {
        [self.tableView reloadData];        
    }
    

    
}


-(NSDictionary*)onRequestCalendarAction{
    return [OrderedDictionary  dictionaryWithObjectsAndKeys:userMid(),@"mId", nil];
}
-(void)onResponseCalendarSuccess:(NSMutableArray *)dataArray{
    [self hideHUD];
    
    if ([dataArray count]>0) {
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kcalendar" object:dataArray];

        MCalendarData *data = [dataArray objectAtIndex:[dataArray count]-1];

        _dateLabel.text = [MUtility stringForDate:data.minvestDate];
        
        [self.dataArray addObject:data];
        [self.tableView reloadData];
    }
    
}
-(void)onResponseCalendarFail{
        [self hideHUD];
}
#pragma mark ---------------------
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.dataArray.count%2==0)?(self.dataArray.count/2):(self.dataArray.count/2+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MCalendarCell";
    
    MCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [MCalendarCell loadFromNIB];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    int count = self.dataArray.count;
    int row = indexPath.row;
    //每行2个
    
    int l_row_count=2;
    
    int index1 = row*l_row_count;
    int index2 = row*l_row_count+1;
 
    if (index1 < count ) {
         cell.data = [self.dataArray safeObjectAtIndex:index1];
        cell.bgImageView1.tag = index1;
     
    }
    if (index2 < count) {
        cell.data2 = [self.dataArray safeObjectAtIndex:index2];
        cell.bgImageView2.tag = index2;
    }
    
    cell.imageViewBlock = ^(int tag){
 
        [self setScrollViewUI:tag];
        
        
    };
    
    
    return cell;
}

-(void)setScrollViewUI:(int)index{
    self.isHidden = YES;
    self.tableView.hidden = YES;
    self.scrollView.hidden = NO;
    
    
    self.calendarData = [self.dataArray objectAtIndex:index];
    
    _dateLabel.text = [MUtility stringForDate:_calendarData.minvestDate];
    
    [self.mm_drawerController setRightDrawerViewController:_evaluate];
    
    _evaluate.data = self.calendarData;

    [self initRightButtonItem:@"nav_evaluate.png" title:@"投资评价" completionHandler:^{
        
      
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
        
    }];
    
    __weak MCenterCalendarViewController *wself = self;
    [self.mm_drawerController setGestureCompletionBlock:^(MMDrawerController *drawerController, UIGestureRecognizer *gesture) {
        
        if (drawerController.visibleLeftDrawerWidth == 270.0) {
            wself.isHidden = NO;
            wself.tableView.hidden = NO;
            wself.scrollView.hidden = YES;
            [drawerController setRightDrawerViewController:nil];
            wself.navigationItem.rightBarButtonItems = nil;
        }
        
        
    }];
    
    
    
    NSString *bank_name         = strOrEmpty([KBANK_DICT objectForKey:[_calendarData.mbankId lowercaseString]]);
    NSString *investMoney = formatValue([_calendarData.minvestMoney floatValue]/100);
    NSString *incomeMoney = formatValue([_calendarData.mincomeMoney floatValue]/100);
 
    NSString *expireDate = [self formatterDateString:_calendarData.mcallDate];
 
    
    NSString *content = [NSString stringWithFormat:@"      今天我在钱先生的帮助下购买了【%@】的【%@】，理财金额为:%@元，预期收益为:%@元，到期时间为%@。我希望到时候能达到这个收益，期待！",bank_name,_calendarData.mname,investMoney,incomeMoney,expireDate];
    
    float height = [MStringUtility getStringHight:content font:SYSTEMFONT(14) width:300];
    _contentLabel.frameHeight = (height/21) *10 + height + 21 + 10;

    
    
    [_contentLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString  *(NSMutableAttributedString *mutableAttributedString) {
       
        
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:investMoney options:NSCaseInsensitiveSearch];
        
        NSRange incomeRange = [[mutableAttributedString string] rangeOfString:incomeMoney options:NSCaseInsensitiveSearch];
        
        UIFont *boldSystemFont = [UIFont systemFontOfSize:18];
        CTFontRef font = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor orangeColor] CGColor] range:boldRange];
            
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:incomeRange];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor orangeColor] CGColor] range:incomeRange];
            
            
            CFRelease(font);
        }
        
        
        return mutableAttributedString;
    }];

    
    NSString *bank_name_info       = STRING_FORMAT(@"%@ %@",bank_name,strOrEmpty(_calendarData.mname));
     
    self.bankNameLabel.text       = bank_name_info;
    
    
    NSString *logoName             = STRING_FORMAT(@"logo_%@",strOrEmpty([_calendarData.mbankId  lowercaseString]));
    
    self.logo_iv.image        = [UIImage imageNamed:logoName];
    
    
    _bottomView.frameY = _contentLabel.frameBottom + 20;
    
    _shareBtn.frameY = _bottomView.frameBottom + 20;
 
    _scrollView.frameHeight = self.tableView.frameHeight;
    [_scrollView setContentSize:CGSizeMake(320, _shareBtn.frameBottom + 15)];
    
}
- (NSString *)formatterDateString:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSDate *date =    [formatter dateFromString:dateStr];
    
    formatter.dateFormat = @"yyyy年MM月dd日";
    
    return [formatter stringFromDate:date];
}

-(void)onButtonActionBack:(id)sender{
    if (self.isHidden) {
        self.isHidden = NO;
        self.tableView.hidden = NO;
        self.scrollView.hidden = YES;
        
        self.navigationItem.rightBarButtonItems = nil;
        
        [self.mm_drawerController setRightDrawerViewController:nil];
    }else{
        __weak MBaseViewController *bself = self;
        
        [self bk_performBlock:^(id obj) {
            [bself.mm_drawerController.navigationController popViewControllerAnimated:YES];
        } afterDelay:0.3];
    }
 
}

-(IBAction)onShareAction:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮箱",@"短信", nil];
    [sheet showInView:self.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"toggleDrawerSide" object:nil];
}
@end
