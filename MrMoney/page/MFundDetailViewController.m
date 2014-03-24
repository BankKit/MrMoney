//
//  MFundDetailViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-22.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFundDetailViewController.h"
#import "MFundData.h"

@interface MFundDetailViewController ()

@end

@implementation MFundDetailViewController

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
    
    [self createNavBarTitle:@"产品详情"];
    
    
    
    _topView.frameX    = 10.;
    _topView.frameY    = 10.;

    _middleView.frameX = 10.;
    _middleView.frameY = 10.;

    _bottomView.frameX = 10.;
    _bottomView.frameY = 10.;

    [_middleView lockDistance:10. toView:_topView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    [_bottomView lockDistance:10. toView:_middleView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
    
    self.scrollView.contentSize = CGSizeMake(320, _bottomView.frameBottom + 10);

    [self setViewData];
    
}
-(void)setViewData{
    NSString *bank_name            = strOrEmpty([KBANK_DICT objectForKey:[_fund.mfund_id lowercaseString]]);
    
     
    self.bank_nameLabel.text       = _fund.mproduct_name;
    
    self.fund_nameLabel.text = bank_name;
    
    NSString *logoName             = STRING_FORMAT(@"logo_%@",strOrEmpty([_fund.mfund_id lowercaseString]));
    self.bank_logo_iv.image        = [UIImage imageNamed:logoName];
     
    
    self.netValueLabel.text        = _fund.mnet_value;
    
    self.dateLabel.text            = [MUtility dateString:_fund.mnet_date];
  
    
    _fundCodeLabel.text = _fund.mproduct_code;
    _fundTypeLabel.text = _fund.mproduct_type;
    _totalNetValueLabel.text =  _fund.mcumulative_value;

    _establishDateLabel.text = [MUtility dateString:_fund.mestablish_date];
    
    _weekReturnLabel.text = STRING_FORMAT(@"%@%@",formatValue([_fund.mweek_return floatValue]/100),@"%");
    _yearReturnLabel.text =  STRING_FORMAT(@"%@%@",formatValue([_fund.myear_return floatValue]/100),@"%");
    _establishReturnLabel.text = STRING_FORMAT(@"%@%@",formatValue([_fund.mestablish_return floatValue]/100),@"%");

    
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
