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
    CGFloat height                     = [MStringUtility getStringHight:_data.mproduct_name font:SYSTEMFONT(16) width:260.];

    self.product_nameLabel.frameHeight = height + 5.;

    UIView *contentView                = [_topView viewWithTag:1];

    contentView.frameY                 = self.product_nameLabel.frameY + self.product_nameLabel.frameHeight - 5.;

    _topView.frameHeight               = contentView.frameY + contentView.frameHeight ;

    self.bank_logo_iv.image            = bankLogoImage(_data.msite_id);

    self.bank_logo_iv.frameWidth       = [bankLogoImage(_data.msite_id) size].width/2;

    NSString *name                     = strOrEmpty([KTREASURE_DICT objectForKey:[_data.msite_id lowercaseString]]);

    self.bankNameLabel.text            = name;

    CGSize size                        = [MStringUtility getStringSize:name font:SYSTEMFONT(14) width:300.];


    self.bank_logo_iv.frameX           = 150 - size.width/2 - self.bank_logo_iv.frameWidth - 2;


    self.expect_earningsLabel.text     = STRING_FORMAT(@"%.1f%%",[_data.mweek_return_rate floatValue]);
    
    
    self.middleLabel1.text = STRING_FORMAT(@"￥%@",formatValue([_data.mlowest_amount floatValue]));
    self.middleLabel2.text = strOrEmpty(_data.mfund_name);
    self.middleLabel3.text = [MUtility dateString:strOrEmpty(_data.mestablish_date)];
 
    self.middleLabel4.text = strOrEmpty(@"人民币");
    self.middleLabel5.text = strOrEmpty(_data.mnet_value);
    self.middleLabel6.text = strOrEmpty(_data.mcumulative_value);
    self.middleLabel7.text = [MUtility dateString:strOrEmpty(_data.mnet_date)] ;
    self.middleLabel8.text = strOrEmpty(_data.mproduct_code);
    
    NSString *product_type = nil;
//    00=不确定，01=货币型，02=债券型，03=理财型，04=股票型，05=指数型，06=混合型，07=封闭式，08=QDII，
    if ([_data.mproduct_type isEqualToString:@"00"]) {
        product_type = @"不确定";
    }else if([_data.mproduct_type isEqualToString:@"01"]){
        product_type = @"货币型";
    }else if([_data.mproduct_type isEqualToString:@"02"]){
        product_type = @"债券型";
    }else if([_data.mproduct_type isEqualToString:@"03"]){
        product_type = @"理财型";
    }else if([_data.mproduct_type isEqualToString:@"04"]){
        product_type = @"股票型";
    }else if([_data.mproduct_type isEqualToString:@"05"]){
        product_type = @"指数型";
    }else if([_data.mproduct_type isEqualToString:@"06"]){
        product_type = @"混合型";
    }else if([_data.mproduct_type isEqualToString:@"07"]){
        product_type = @"封闭型";
    }else if([_data.mproduct_type isEqualToString:@"08"]){
        product_type = @"QDII";
    }
    self.middleLabel9.text = product_type;
    
    
    
    self.bottomLabel1.text = m_dictionaryValueToString(_data.mincome_10th);
    self.bottomLabel2.text = m_dictionaryValueToString(_data.mmonth_return_rate);
    self.bottomLabel3.text = m_dictionaryValueToString(_data.mhalf_year_return_rate);
    self.bottomLabel4.text = m_dictionaryValueToString(_data.myear_return_rate);
    self.bottomLabel5.text = m_dictionaryValueToString(_data.mthis_year_return_rate);
    self.bottomLabel6.text = m_dictionaryValueToString(_data.mestablish_return_rate);
    self.bottomLabel7.text = m_dictionaryValueToString(_data.mrise_and_decline);
    
     

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
