//
//  UILabel+MCategory.m
//  MrMoney
//
//  Created by xingyong on 14-1-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "UILabel+MCategory.h"

@implementation UILabel (MCategory)

+(UILabel *) labelWithText:(NSString *)text {
    return [UILabel labelWithText:text font:[UIFont systemFontOfSize:14]];
}

+(UILabel *) labelWithText:(NSString *)text font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    
    return label;
}

@end
