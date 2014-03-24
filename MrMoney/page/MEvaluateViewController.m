//
//  MEvaluateViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-12.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MEvaluateViewController.h"
#import "MCalendarData.h"
#import "TTTAttributedLabel.h"
#import "NSDate+Compare.h"
@interface MEvaluateViewController ()
@property (nonatomic,strong) TTTAttributedLabel   * contentLabel;
@property (nonatomic,strong) UIButton *lastBtn;
@end

@implementation MEvaluateViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    
    if (!IsIOS7) {
        _contentView.frameY = _contentView.frameY - 20;
        _contentView.frameHeight = _contentView.frameHeight + 20;
  
    }
    
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_diary_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_diary_light"] stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateHighlighted];
    
    _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(5,IsIOS7 ? 75 : 55,265,21)];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.backgroundColor = KCLEAR_COLOR;
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.kern = 1;
    _contentLabel.leading = 10;
    
    [self.view addSubview:_contentLabel];
    
}
#pragma mark ----
#pragma mark ---- viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *incomeMoney = formatValue([self.data.mincomeMoney floatValue]/100);
    NSDate *expireDate = [self formatterDateString:self.data.mcallDate];
    
    if ([zoneDate(expireDate) isLessDate:zoneDate([NSDate date])]) {
        
        _expireLabel.hidden = YES;
        
        _mainView.hidden = NO;
        _contentLabel.hidden = NO;
        
        NSString *content = [NSString stringWithFormat:@"钱先生助我买的【%@】今天到期了，成功收益%@元。我觉得很：",self.data.mname,incomeMoney];
        float height = [MStringUtility getStringHight:content font:SYSTEMFONT(14) width:265];
        _contentLabel.frameHeight = (height/21) *10 + height + 21 + 10;
      
        [_contentLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString  *(NSMutableAttributedString *mutableAttributedString) {
            
            
            NSRange incomeRange = [[mutableAttributedString string] rangeOfString:incomeMoney options:NSCaseInsensitiveSearch];
            
            UIFont *boldSystemFont = [UIFont systemFontOfSize:18];
            CTFontRef font = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:incomeRange];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor orangeColor] CGColor] range:incomeRange];
                
                
                CFRelease(font);
            }
            
            
            return mutableAttributedString;
        }];
        
    }else{
        
        _mainView.hidden = YES;
        _expireLabel.hidden = NO;
                _contentLabel.hidden = YES;
    }
    
}


-(IBAction)onShareAction:(id)sender{
 
}
-(IBAction)onCheckAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    button.selected = YES;
    
    _lastBtn.selected = NO;
    
    _lastBtn = button;
}
- (NSDate *)formatterDateString:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat       = @"yyyyMMdd";
    NSDate *date               = [formatter dateFromString:dateStr];
  
    return date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
