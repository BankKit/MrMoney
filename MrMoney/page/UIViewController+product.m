//
//  UIViewController+product.m
//  MrMoney
//
//  Created by xingyong on 14-3-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "UIViewController+product.h"
#import "MProductTopView.h"
@implementation UIViewController (product)
-(UIView *)topView:(MFinanceProductData *)data{
    MProductTopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"MProductTopView" owner:self options:nil] lastObject];
    
    topView.data = data;
    
    return topView;
 
}
@end
