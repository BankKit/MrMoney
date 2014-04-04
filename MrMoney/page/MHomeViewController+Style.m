//
//  MHomeViewController+Style.m
//  MrMoney
//
//  Created by xingyong on 14-3-19.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MHomeViewController+Style.h"

@implementation MHomeViewController (Style)

-(UIView *)cyleViewWithInternetData:(MInternetData *)internetData{
    
    CGRect rect = CGRectMake(0, 0, 154, 82);
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = KCLEAR_COLOR;
    
    
    NSString *imageName = STRING_FORMAT(@"logo_%@",[internetData.msite_id lowercaseString]);
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Rect(2, 55., image.width*2/3, image.height*2/3)];
    imageView.image = image;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:Rect(imageView.frameWidth + 5,52.,154- imageView.frameWidth,21)];
    nameLabel.backgroundColor = KCLEAR_COLOR;
    nameLabel.font = SYSTEMFONT(14);
    nameLabel.textColor = [UIColor whiteColor];
    
    
    nameLabel.text = STRING_FORMAT(@"%@ %@",[KTREASURE_DICT objectForKey:[internetData.msite_id lowercaseString]],internetData.mproduct_name);
    
    MLabel *incomeLabel = [[MLabel  alloc] initWithFrame:Rect(0, 13, 154, 40)];
    incomeLabel.backgroundColor = KCLEAR_COLOR;
    incomeLabel.font = FONT(kHelveticaLight, 24);
    incomeLabel.textColor = [UIColor whiteColor];
    incomeLabel.text = STRING_FORMAT(@"%.2f%%",[internetData.mthis_year_return_rate floatValue]/100);
    
    [incomeLabel setFont:FONT(kHelveticaLight, 14) string:@"%"];
    
    incomeLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:incomeLabel];
    [view addSubview:nameLabel];
    [view addSubview:imageView];
    
    return view;

}
-(void)touchControlView{
    
    UIView *controlView = [[UIView alloc] initWithFrame:self.view.bounds];
    controlView.backgroundColor = KCLEAR_COLOR;
    controlView.userInteractionEnabled  = YES;
    controlView.tag = 100000;
    [self.view addSubview:controlView];
    
}
-(void)removeControlView{
    UIView *view = [self.view viewWithTag:100000];
    [view removeFromSuperview];
}

-(void)setHomeColorButtonView{
    
    MColorButton *color_financeProductsView = [[MColorButton alloc] initWithFrame:CGRectMake(0,0, 312, 164) buttonTag:1];
    color_financeProductsView.delegate = self;
    color_financeProductsView.startColor  = [UIColor colorWithRed:0.15 green:0.58 blue:0.78 alpha:1.00];
    color_financeProductsView.endColor    = [UIColor colorWithRed:0.17 green:0.63 blue:0.87 alpha:1.00];
    
    [self.financeProductsView insertSubview:color_financeProductsView  atIndex:0];
    
    
    CGRect colorRect = CGRectMake(0,0, 154, 82);
    
    MColorButton *color_fundView = [[MColorButton alloc] initWithFrame:colorRect buttonTag:2];
    color_fundView.delegate = self;
    color_fundView.startColor  = [UIColor colorWithRed:0.43 green:0.65 blue:0.15 alpha:1.00];
    color_fundView.endColor    = [UIColor colorWithRed:0.45 green:0.71 blue:0.18 alpha:1.00];
    
    [self.fundView insertSubview:color_fundView atIndex:0];
   
    
    MColorButton *color_slideView = [[MColorButton alloc] initWithFrame:colorRect buttonTag:2];
    color_slideView.delegate = self;
    color_slideView.startColor  = [UIColor colorWithRed:0.82 green:0.16 blue:0.10 alpha:1.00];
    color_slideView.endColor    = [UIColor colorWithRed:0.82 green:0.16 blue:0.10 alpha:1.00];
    
    [self.slideView insertSubview:color_slideView atIndex:0];
    
    
    MColorButton *color_moneyBabyView = [[MColorButton alloc] initWithFrame:colorRect buttonTag:3 ];
    color_moneyBabyView.delegate = self;
    color_moneyBabyView.startColor  = [UIColor colorWithRed:0.73 green:0.73 blue:0.18 alpha:1.00];
    color_moneyBabyView.endColor    = [UIColor colorWithRed:0.78 green:0.79 blue:0.20 alpha:1.00];
    [self.moneyBabyView insertSubview:color_moneyBabyView atIndex:0];
    
    MColorButton *color_walletView = [[MColorButton alloc] initWithFrame:colorRect buttonTag:4];
    color_walletView.delegate = self;
    color_walletView.startColor  = [UIColor colorWithRed:0.16 green:0.34 blue:0.61 alpha:1.00];
    color_walletView.endColor    = [UIColor colorWithRed:0.19 green:0.38 blue:0.66 alpha:1.00];
    [self.walletView insertSubview:color_walletView atIndex:0];
    
    
    MColorButton *color_favoriteView = [[MColorButton alloc] initWithFrame:colorRect buttonTag:5];
    color_favoriteView.delegate = self;
    color_favoriteView.startColor  = [UIColor colorWithRed:0.11 green:0.72 blue:0.55 alpha:1.00];
    color_favoriteView.endColor    = [UIColor colorWithRed:0.12 green:0.79 blue:0.60 alpha:1.00];
    [self.favoriteView insertSubview:color_favoriteView atIndex:0];
    
    
    MColorButton *color_sinaView = [[MColorButton alloc] initWithFrame:CGRectMake(0,0, 75, 82) buttonTag:6];
    color_sinaView.delegate = self;
    color_sinaView.startColor  = [UIColor colorWithRed:0.56 green:0.26 blue:0.54 alpha:1.00];
    color_sinaView.endColor    = [UIColor colorWithRed:0.61 green:0.29 blue:0.60 alpha:1.00];
    [self.sinaView insertSubview:color_sinaView atIndex:0];
    
    
    MColorButton *color_weixinView = [[MColorButton alloc] initWithFrame:CGRectMake(0,0,75,82) buttonTag:7];
    color_weixinView.delegate = self;
    color_weixinView.startColor =[UIColor colorWithRed:0.10 green:0.65 blue:0.69 alpha:1.00];
    color_weixinView.endColor    = [UIColor colorWithRed:0.11 green:0.70 blue:0.76 alpha:1.00];
    [self.weixinView insertSubview:color_weixinView atIndex:0];
    
    
    MColorButton *color_securityAssuranceView = [[MColorButton alloc] initWithFrame:colorRect buttonTag:8];
    color_securityAssuranceView.delegate = self;
    color_securityAssuranceView.startColor  = [UIColor colorWithRed:0.63 green:0.61 blue:0.57 alpha:1.00];
    color_securityAssuranceView.endColor    = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1.00];
    [self.securityAssuranceView insertSubview:color_securityAssuranceView atIndex:0];
}



@end
