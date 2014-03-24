//
//  MRiskAssessmentViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-19.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MRiskAssessmentViewController.h"
#import "MUserData.h"
#import "MPurchaseViewController.h"

#define KRADIOHEIGHT 20.0
#define KLEFTWIDTH 10.0
#define KPADDING 24.0
#define KTOPHEIGHT 10.0

@interface MRiskAssessmentViewController ()
@property(nonatomic,strong)NSMutableDictionary *editDict;
@end

@implementation MRiskAssessmentViewController

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
    
    [self createNavBarTitle:@"在线风险评估"];
    __weak MRiskAssessmentViewController *wself = self;
    [self initRightButtonItem:@"nav_skip" title:@"跳过评估" completionHandler:^{
        [MGo2PageUtility  go2PurchaseViewController:wself data:_data pushType:MRiskType buyMoney:@""];

    }];
    
     _topView.frameX     = KTOPHEIGHT;
    _topView.frameY     = KTOPHEIGHT;
    
    [self.scrollView addSubview:_topView];
    
     _value1View.frameX     = KTOPHEIGHT;
    
    [self.scrollView addSubview:_value1View];
     [_value1View lockDistance:KTOPHEIGHT toView:_topView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
    
     _value2View.frameX     = KTOPHEIGHT;
    
    [self.scrollView addSubview:_value2View];
    
    [_value2View lockDistance:KTOPHEIGHT toView:_value1View measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
     _value3View.frameX     = KTOPHEIGHT;
    [self.scrollView addSubview:_value3View];
    [_value3View lockDistance:KTOPHEIGHT toView:_value2View measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
    
     _value4View.frameX     = KTOPHEIGHT;
    [self.scrollView addSubview:_value4View];
    [_value4View lockDistance:KTOPHEIGHT toView:_value3View measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
   
    
     _value5View.frameX     = KTOPHEIGHT;
    [self.scrollView addSubview:_value5View];
    [_value5View lockDistance:KTOPHEIGHT toView:_value4View measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
    self.editDict = [NSMutableDictionary dictionary];
    
    [self setUI];
    
    [self.scrollView setContentSize:CGSizeMake(320,_value5View.frameHeight + _value5View.frameY + KTOPHEIGHT)];
 
}
-(void)setUI{
    
    MButtonRadio *rb1 = [[MButtonRadio alloc] initWithGroupId:@"value01" index:0];
    MButtonRadio *rb2 = [[MButtonRadio alloc] initWithGroupId:@"value01" index:1];
    MButtonRadio *rb3 = [[MButtonRadio alloc] initWithGroupId:@"value01" index:2];
    MButtonRadio *rb4 = [[MButtonRadio alloc] initWithGroupId:@"value01" index:3];
    
    rb1.frame = CGRectMake(KLEFTWIDTH,68,KRADIOHEIGHT,KRADIOHEIGHT);
    rb2.frame = CGRectMake(KLEFTWIDTH,68+KPADDING,KRADIOHEIGHT,KRADIOHEIGHT);
    rb3.frame = CGRectMake(KLEFTWIDTH,68+KPADDING*2,KRADIOHEIGHT,KRADIOHEIGHT);
    rb4.frame = CGRectMake(KLEFTWIDTH,68+KPADDING*3,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value1View addSubview:rb1];
    [_value1View addSubview:rb2];
    [_value1View addSubview:rb3];
    [_value1View addSubview:rb4];
    
    
    MButtonRadio *rb2_1 = [[MButtonRadio alloc] initWithGroupId:@"value02" index:0];
    MButtonRadio *rb2_2 = [[MButtonRadio alloc] initWithGroupId:@"value02" index:1];
    MButtonRadio *rb2_3 = [[MButtonRadio alloc] initWithGroupId:@"value02" index:2];
    MButtonRadio *rb2_4 = [[MButtonRadio alloc] initWithGroupId:@"value02" index:3];
    MButtonRadio *rb2_5 = [[MButtonRadio alloc] initWithGroupId:@"value02" index:4];
    rb2_1.frame = CGRectMake(KLEFTWIDTH,188,KRADIOHEIGHT,KRADIOHEIGHT);
    rb2_2.frame = CGRectMake(KLEFTWIDTH,188+KPADDING,KRADIOHEIGHT,KRADIOHEIGHT);
    rb2_3.frame = CGRectMake(KLEFTWIDTH,188+KPADDING*2,KRADIOHEIGHT,KRADIOHEIGHT);
    rb2_4.frame = CGRectMake(KLEFTWIDTH,188+KPADDING*3,KRADIOHEIGHT,KRADIOHEIGHT);
    rb2_5.frame = CGRectMake(KLEFTWIDTH,188+KPADDING*4,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value1View addSubview:rb2_1];
    [_value1View addSubview:rb2_2];
    [_value1View addSubview:rb2_3];
    [_value1View addSubview:rb2_4];
    [_value1View addSubview:rb2_5];
    
    MButtonRadio *rb3_1 = [[MButtonRadio alloc] initWithGroupId:@"value03" index:0];
    MButtonRadio *rb3_2 = [[MButtonRadio alloc] initWithGroupId:@"value03" index:1];
    MButtonRadio *rb3_3 = [[MButtonRadio alloc] initWithGroupId:@"value03" index:2];
    MButtonRadio *rb3_4 = [[MButtonRadio alloc] initWithGroupId:@"value03" index:3];
    rb3_1.frame = CGRectMake(KLEFTWIDTH,343,KRADIOHEIGHT,KRADIOHEIGHT);
    rb3_2.frame = CGRectMake(KLEFTWIDTH,343+KPADDING,KRADIOHEIGHT,KRADIOHEIGHT);
    rb3_3.frame = CGRectMake(KLEFTWIDTH,343+KPADDING*2,KRADIOHEIGHT,KRADIOHEIGHT);
    rb3_4.frame = CGRectMake(KLEFTWIDTH,343+KPADDING*3,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value1View addSubview:rb3_1];
    [_value1View addSubview:rb3_2];
    [_value1View addSubview:rb3_3];
    [_value1View addSubview:rb3_4];
    
    
    MButtonRadio *rb4_1 = [[MButtonRadio alloc] initWithGroupId:@"value04" index:0];
    MButtonRadio *rb4_2 = [[MButtonRadio alloc] initWithGroupId:@"value04" index:1];
    MButtonRadio *rb4_3 = [[MButtonRadio alloc] initWithGroupId:@"value04" index:2];
    MButtonRadio *rb4_4 = [[MButtonRadio alloc] initWithGroupId:@"value04" index:3];
    rb4_1.frame = CGRectMake(KLEFTWIDTH,65,KRADIOHEIGHT,KRADIOHEIGHT);
    rb4_2.frame = CGRectMake(KLEFTWIDTH,65+KPADDING + 18,KRADIOHEIGHT,KRADIOHEIGHT);
    rb4_3.frame = CGRectMake(KLEFTWIDTH,65+KPADDING*2 + 36,KRADIOHEIGHT,KRADIOHEIGHT);
    rb4_4.frame = CGRectMake(KLEFTWIDTH,65+KPADDING*3 + 54,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value2View addSubview:rb4_1];
    [_value2View addSubview:rb4_2];
    [_value2View addSubview:rb4_3];
    [_value2View addSubview:rb4_4];
    
    
    
    MButtonRadio *rb5_1 = [[MButtonRadio alloc] initWithGroupId:@"value05" index:0];
    MButtonRadio *rb5_2 = [[MButtonRadio alloc] initWithGroupId:@"value05" index:1];
    MButtonRadio *rb5_3 = [[MButtonRadio alloc] initWithGroupId:@"value05" index:2];
    MButtonRadio *rb5_4 = [[MButtonRadio alloc] initWithGroupId:@"value05" index:3];
    MButtonRadio *rb5_5 = [[MButtonRadio alloc] initWithGroupId:@"value05" index:4];
    rb5_1.frame = CGRectMake(KLEFTWIDTH,271,KRADIOHEIGHT,KRADIOHEIGHT);
    rb5_2.frame = CGRectMake(KLEFTWIDTH,271+KPADDING ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb5_3.frame = CGRectMake(KLEFTWIDTH,271+KPADDING*2 ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb5_4.frame = CGRectMake(KLEFTWIDTH,271+KPADDING*3 ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb5_5.frame = CGRectMake(KLEFTWIDTH,271+KPADDING*4 ,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value2View addSubview:rb5_1];
    [_value2View addSubview:rb5_2];
    [_value2View addSubview:rb5_3];
    [_value2View addSubview:rb5_4];
    [_value2View addSubview:rb5_5];
    
    
    
    
    
    MButtonRadio *rb6_1 = [[MButtonRadio alloc] initWithGroupId:@"value06" index:0];
    MButtonRadio *rb6_2 = [[MButtonRadio alloc] initWithGroupId:@"value06" index:1];
    MButtonRadio *rb6_3 = [[MButtonRadio alloc] initWithGroupId:@"value06" index:2];
    MButtonRadio *rb6_4 = [[MButtonRadio alloc] initWithGroupId:@"value06" index:3];
    rb6_1.frame = CGRectMake(KLEFTWIDTH,65,KRADIOHEIGHT,KRADIOHEIGHT);
    rb6_2.frame = CGRectMake(KLEFTWIDTH,65+KPADDING + 18,KRADIOHEIGHT,KRADIOHEIGHT);
    rb6_3.frame = CGRectMake(KLEFTWIDTH,65+KPADDING*2 + 36,KRADIOHEIGHT,KRADIOHEIGHT);
    rb6_4.frame = CGRectMake(KLEFTWIDTH,65+KPADDING*3 + 54,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value3View addSubview:rb6_1];
    [_value3View addSubview:rb6_2];
    [_value3View addSubview:rb6_3];
    [_value3View addSubview:rb6_4];
    
    
    
    MButtonRadio *rb7_1 = [[MButtonRadio alloc] initWithGroupId:@"value07" index:0];
    MButtonRadio *rb7_2 = [[MButtonRadio alloc] initWithGroupId:@"value07" index:1];
    MButtonRadio *rb7_3 = [[MButtonRadio alloc] initWithGroupId:@"value07" index:2];
    MButtonRadio *rb7_4 = [[MButtonRadio alloc] initWithGroupId:@"value07" index:3];
    rb7_1.frame = CGRectMake(KLEFTWIDTH,261,KRADIOHEIGHT,KRADIOHEIGHT);
    rb7_2.frame = CGRectMake(KLEFTWIDTH,261+KPADDING ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb7_3.frame = CGRectMake(KLEFTWIDTH,261+KPADDING*2 ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb7_4.frame = CGRectMake(KLEFTWIDTH,261+KPADDING*3 ,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value3View addSubview:rb7_1];
    [_value3View addSubview:rb7_2];
    [_value3View addSubview:rb7_3];
    [_value3View addSubview:rb7_4];
    
    
    
    
    MButtonRadio *rb8_1 = [[MButtonRadio alloc] initWithGroupId:@"value08" index:0];
    MButtonRadio *rb8_2 = [[MButtonRadio alloc] initWithGroupId:@"value08" index:1];
    MButtonRadio *rb8_3 = [[MButtonRadio alloc] initWithGroupId:@"value08" index:2];
    MButtonRadio *rb8_4 = [[MButtonRadio alloc] initWithGroupId:@"value08" index:3];
    rb8_1.frame = CGRectMake(KLEFTWIDTH,68,KRADIOHEIGHT,KRADIOHEIGHT);
    rb8_2.frame = CGRectMake(KLEFTWIDTH,68+KPADDING ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb8_3.frame = CGRectMake(KLEFTWIDTH,68+KPADDING*2 ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb8_4.frame = CGRectMake(KLEFTWIDTH,68+KPADDING*3 ,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value4View addSubview:rb8_1];
    [_value4View addSubview:rb8_2];
    [_value4View addSubview:rb8_3];
    [_value4View addSubview:rb8_4];


    
    MButtonRadio *rb9_1 = [[MButtonRadio alloc] initWithGroupId:@"value09" index:0];
    MButtonRadio *rb9_2 = [[MButtonRadio alloc] initWithGroupId:@"value09" index:1];
    MButtonRadio *rb9_3 = [[MButtonRadio alloc] initWithGroupId:@"value09" index:2];
    rb9_1.frame = CGRectMake(KLEFTWIDTH,188,KRADIOHEIGHT,KRADIOHEIGHT);
    rb9_2.frame = CGRectMake(KLEFTWIDTH,188+KPADDING,KRADIOHEIGHT,KRADIOHEIGHT);
    rb9_3.frame = CGRectMake(KLEFTWIDTH,188+KPADDING*2,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value4View addSubview:rb9_1];
    [_value4View addSubview:rb9_2];
    [_value4View addSubview:rb9_3];

    
    MButtonRadio *rb10_1 = [[MButtonRadio alloc] initWithGroupId:@"value010" index:0];
    MButtonRadio *rb10_2 = [[MButtonRadio alloc] initWithGroupId:@"value010" index:1];
    MButtonRadio *rb10_3 = [[MButtonRadio alloc] initWithGroupId:@"value010" index:2];
    MButtonRadio *rb10_4 = [[MButtonRadio alloc] initWithGroupId:@"value010" index:3];
    MButtonRadio *rb10_5 = [[MButtonRadio alloc] initWithGroupId:@"value010" index:4];
    rb10_1.frame = CGRectMake(KLEFTWIDTH,78,KRADIOHEIGHT,KRADIOHEIGHT);
    rb10_2.frame = CGRectMake(KLEFTWIDTH,78+KPADDING ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb10_3.frame = CGRectMake(KLEFTWIDTH,78+KPADDING*2 ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb10_4.frame = CGRectMake(KLEFTWIDTH,78+KPADDING*3 ,KRADIOHEIGHT,KRADIOHEIGHT);
    rb10_5.frame = CGRectMake(KLEFTWIDTH,78+KPADDING*4 ,KRADIOHEIGHT,KRADIOHEIGHT);
    [_value5View addSubview:rb10_1];
    [_value5View addSubview:rb10_2];
    [_value5View addSubview:rb10_3];
    [_value5View addSubview:rb10_4];
    [_value5View addSubview:rb10_5];

    
//    [MButtonRadio addObserverForGroupId:@"value01" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value02" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value03" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value04" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value05" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value06" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value07" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value08" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value09" observer:self];
//    [MButtonRadio addObserverForGroupId:@"value010" observer:self];
//
    
}
-(void)buttonRadioSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId{
    NSLog(@"---------index: %d ------ groupId : %@",index,groupId);
    NSString *content = nil;
    if (index == 0) {
        content = @"A";
    }else if (index == 1) {
        content = @"B";
    }else if (index == 2) {
        content = @"C";
    }else if (index == 3) {
        content = @"D";
    }else if (index == 4) {
        content = @"E";
    }
    [self.editDict setObject:content forKey:groupId];
    
}
-(IBAction)onSubmitRiskAction:(id)sender{
    for (int i = 1 ; i<11;i++) {
        NSString *name = STRING_FORMAT(@"value0%d",i);
 
        NSString *conent = strOrEmpty([self.editDict objectForKey:name]);
        if ([conent isEqualToString:@""]) {
            [MActionUtility showAlert:STRING_FORMAT(@"题目%d还没选择",i)];
            return;
        }
    }
   


    
    riskAction = [[MRiskAction alloc] init];
    riskAction.m_delegate = self;
    [riskAction requestAction];
    [self showHUD];
}
-(NSDictionary*)onRequestRiskAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    for (int i= 1; i<11 ; i++) {
        NSString *key = STRING_FORMAT(@"value0%d",i);
        
        NSString *value = nil;
        
        if (i == 10) {
            value =  STRING_FORMAT(@"value%d",i);
        }
        else
        {
            value = STRING_FORMAT(@"value0%d",i);
        }
        
        [dict setSafeObject:[self.editDict objectForKey:key] forKey:value];
    }
    
     [dict setSafeObject:@"png" forKey:@"imageType"];
   
    
    return dict;
}
-(void)onResponseRiskSuccess{
    
//    MUserData *user = [[MUserData allDbObjects] objectAtIndex:0];
//    user.mriskEvalue = @"1";
//    
//    if ([user updatetoDb]) {
    __weak MRiskAssessmentViewController *wself = self;
    
    [self hideHUDWithCompletionMessage:@"评估成功" finishedHandler:^{
            [MGo2PageUtility go2PurchaseViewController:wself data:wself.data pushType:MRiskType buyMoney:@""];
         }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)onResponseRiskFail{
    [self hideHUD];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
