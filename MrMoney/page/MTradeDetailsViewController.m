//
//  MTradeDetailsViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-16.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MTradeDetailsViewController.h"
#import "NSDate+DateTools.h"
@interface MTradeDetailsViewController ()

@end

@implementation MTradeDetailsViewController

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
    
    
    UIImage *bgImage = [PNGIMAGE(@"detailsBg") stretchableImageWithLeftCapWidth:10 topCapHeight:100];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    imageView.image = bgImage;
    
    [_contentView insertSubview:imageView atIndex:0];
//    [_contentView.layer borderWidth:1.0 borderColor:KVIEW_BORDER_COLOR cornerRadius:6.0];
    
    
    self.contentView.frameY = 20;
    
    
    if (self.typeValue == 1) {
        
        [self createNavBarTitle:@"账户明细"];
         
        if ([strOrEmpty(_data.mtran_amount) floatValue] > 0.00) {
            self.amountLabel.textColor = [UIColor orangeColor];
            
        }
        
        
        if ([self isNumberString:_data.morderNo]) {
    
             self.monadButton.hidden = NO;
        }

        NSLog(@"-------------statusLabel------------------%@ \n\n",_data.mtransTypeDesc);
        self.titleStatusLabel.text = _data.mtransTypeDesc;
        
        if ([_data.mtrans_status intValue] == 0) {
            self.statusLabel.text = @"交易成功";
        }

   
        self.amountLabel.text =STRING_FORMAT(@"￥%@",formatValue([_data.mtran_amount floatValue]));
        
    

        NSDate *tran_date = [MUtility dateFormatter:_data.mtran_time formatter:kDefaultTimeStampFull];
        NSString *tran_time =  [tran_date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
  
        self.dateLabel.text = tran_time;
        
        
        self.productNameLabel.text = _data.mtran_memo;
        
        float height = [MStringUtility getStringHight:_data.mtran_memo font:SYSTEMFONT(14) width:180.0];
        
        self.productNameLabel.frameHeight = height + 5;
        
     
        self.contentView.frameHeight = self.productNameLabel.frameHeight + self.productNameLabel.frameY + 20;
        
        self.monadButton.frameY = self.contentView.frameHeight + self.contentView.frameY + 30;
        
        
    }
    
    else if(self.typeValue == 2) {
        
        [self createNavBarTitle:@"投资记录详细"];
        
        if ([strOrEmpty(_data.mtran_amount) floatValue] > 0.00) {
            
            self.amountLabel.textColor = [UIColor orangeColor];
            
        }
        
        if ([self isNumberString:_investData.mPayId]) {
            self.monadButton.hidden = NO;
        }
        
        self.titleStatusLabel.text = _investData.mtransTypeDesc;
        
        if ([_investData.mBsnsStsDesc length] == 0) {
            self.statusLabel.text = @"充值成功";
        }else   {
         self.statusLabel.text =_investData.mBsnsStsDesc;   
        }
        

        if ([_investData.mTrxType intValue]==2) {
            self.amountLabel.textColor = [UIColor orangeColor];

        }else if([_investData.mTrxType intValue]==5) {
            self.amountLabel.textColor = [UIColor blackColor];
        }
        self.amountLabel.text =STRING_FORMAT(@"￥%@",formatValue([_investData.mtran_amount floatValue]));
        
         NSDate *tran_date = [MUtility dateFormatter:_investData.mtran_time formatter:kDefaultTimeStampFull];
        NSString *tran_time = [tran_date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
        
        self.dateLabel.text = tran_time;
  
        
        self.productNameLabel.text = _investData.mtran_memo;
        
        float height = [MStringUtility getStringHight:_investData.mtran_memo font:SYSTEMFONT(14) width:180.0];
        
        self.productNameLabel.frameHeight = height + 5;
       
        self.contentView.frameHeight = self.productNameLabel.frameHeight + self.productNameLabel.frameY + 20;
        
        self.monadButton.frameY = self.contentView.frameHeight + self.contentView.frameY + 30;
        
    }
    
}



-(BOOL)isNumberString:(NSString *)input{
    
    if ([input length] == 0) {
        return NO;
    }
    return  [input matchesPatternRegexPattern:@"[A-Za-z]"] && [input matchesPatternRegexPattern:@"[0-9]"];
 
}


-(IBAction)onSeeMonadAction:(id)sender{
    if (self.typeValue == 1) {

        [MGo2PageUtility go2MWebBrowser:self title:@"回执单" webUrl:KSHOW_RECORD(_data.morderNo)];
    }else {
 
        [MGo2PageUtility go2MWebBrowser:self title:@"回执单" webUrl:KSHOW_RECORD(_investData.mPayId)];
    }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
