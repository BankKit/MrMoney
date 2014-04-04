//
//  MColorView.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@protocol MColorButtonDelegate <NSObject>

-(void)colorButtonClick:(int)index;

@end

@interface MColorButton : UIButton
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property(nonatomic,weak)id<MColorButtonDelegate>delegate;

- (id)initWithFrame:(CGRect)frame buttonTag:(NSInteger )tag;
 
@end
