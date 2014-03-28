//
//  MInternetDetailViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MInternetDetailViewController.h"
#import "MInternetData.h"
@interface MInternetDetailViewController ()

@end

@implementation MInternetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setViewData{

    self.product_nameLabel.text        = strOrEmpty(_data.mproduct_name);
    
    CGFloat height = [MStringUtility getStringHight:_data.mproduct_name font:SYSTEMFONT(16) width:260.];
    
    self.product_nameLabel.frameHeight = height + 5.;
    
    UIView *contentView                = [_topView viewWithTag:1];
    
    contentView.frameY                 = self.product_nameLabel.frameY + self.product_nameLabel.frameHeight - 5.;
    
    _topView.frameHeight          = contentView.frameY + contentView.frameHeight ;
    
    
    self.bank_logo_iv.image            = bankLogoImage(_data.msite_id);
    
    self.bank_logo_iv.frameWidth       = [bankLogoImage(_data.msite_id) size].width/2;
    
    self.bankNameLabel.frameX          = self.bank_logo_iv.frameX +  self.bank_logo_iv.frameWidth  + 5;
    
    self.bankNameLabel.text            = bankName(_data.msite_id);
    
    
    self.expect_earningsLabel.text     =STRING_FORMAT(@"%.1f%%",[_data.mweek_return_rate floatValue]);
    
    
//    self.invest_cycleLabel.text        = STRING_FORMAT(@"%@天",strOrEmpty(data.minvest_cycle));
   


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavBarTitle:@"产品详情"];
    
    self.topView.frameX = 10;
    
    [_middleView lockDistance:10. toView:_topView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    [_bottomView lockDistance:10. toView:_middleView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _bottomView.frameBottom + 10);
   
    [self setViewData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
