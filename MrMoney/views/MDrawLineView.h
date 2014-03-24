//
//  MDrawLineView.h
//  MrMoney
//
//  Created by xingyong on 14-2-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDrawLineView : UIView

- (void)_initialize;


///--------------------
/// @name Drawing Lines
///--------------------

/**
 The primary color of the line.
 
 The default is `[UIColor grayColor]`.
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 The color of the line inset.
 
 The default is 50% opaque white.
 */
@property (nonatomic, strong) UIColor *insetColor;


///---------------------
/// @name Drawing Dashes
///---------------------

/**
 A float that specifies how far into the dash pattern the line starts, in points.
 
 For example, passing a value of 3 means the line is drawn with the dash pattern starting at 3 points from its
 beginning. Passing a value of 0 draws a line starting with the beginning of a dash pattern.
 
 The default is `0.0`.
 */
@property (nonatomic, assign) CGFloat dashPhase;

/**
 An array of values that specify the lengths of the painted segments and unpainted segments, respectively, of the
 dash pattern—or `nil` for no dash pattern.
 
 For example, passing an array with the values [2,3] sets a dash pattern that alternates between a 2 point long painted
 segment and a 3 point long unpainted segment. Passing the values [1,3,4,2] sets the pattern to a 1 point painted
 segment, a 3 point unpainted segment, a 4 oiunt painted segment, and a 2 point unpainted segment.
 
 The default is `nil`.
 */
@property (nonatomic, copy) NSArray *dashLengths;


@end
