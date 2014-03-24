//
//  UIButton+MCategory.m
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "UIButton+MCategory.h"

@implementation UIButton (MCategory)

+ (id) buttonWithFrame:(CGRect)frame{
	return [UIButton buttonWithFrame:frame title:nil];
}
+ (id) buttonWithFrame:(CGRect)frame title:(NSString*)title{
	return [UIButton buttonWithFrame:frame title:title backgroundImage:nil];
}
+ (id) buttonWithFrame:(CGRect)frame title:(NSString*)title backgroundImage:(UIImage*)backgroundImage{
	return [UIButton buttonWithFrame:frame title:title backgroundImage:backgroundImage highlightedBackgroundImage:nil];
}
+ (id) buttonWithFrame:(CGRect)frame title:(NSString*)title backgroundImage:(UIImage*)backgroundImage highlightedBackgroundImage:(UIImage*)highlightedBackgroundImage{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = frame;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	[btn setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
	return btn;
}

+ (id) buttonWithFrame:(CGRect)frame image:(UIImage*)image{
	return [UIButton buttonWithFrame:frame image:image highlightedImage:nil];
}
+ (id) buttonWithFrame:(CGRect)frame image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = frame;
	[btn setImage:image forState:UIControlStateNormal];
	[btn setImage:highlightedImage forState:UIControlStateHighlighted];
	return btn;
}


@end
