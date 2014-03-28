//
//  MColorView.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@protocol MColorViewDelegate <NSObject>

-(void)colorViewClick:(int)index;

@end

@interface MColorView : UIView
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property(nonatomic,weak)id<MColorViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame buttonTag:(NSInteger )tag;
 
@end
