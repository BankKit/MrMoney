//
//  MHomeViewController+Style.h
//  MrMoney
//
//  Created by xingyong on 14-3-19.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MHomeViewController.h"
#import "MCountView.h"
#import "MInternetData.h"
@interface MHomeViewController (Style)

-(void)setHomeColorButtonView;

-(void)touchControlView;

-(void)removeControlView;

-(UIView *)cyleViewWithInternetData:(MInternetData *)internetData;

@end
