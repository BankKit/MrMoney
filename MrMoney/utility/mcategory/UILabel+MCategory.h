//
//  UILabel+MCategory.h
//  MrMoney
//
//  Created by xingyong on 14-1-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MCategory)
+(UILabel *) labelWithText:(NSString *)text;
+(UILabel *) labelWithText:(NSString *)text font:(UIFont *)font;
- (CGSize)contentSize;
@end
