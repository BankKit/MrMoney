//
//  UIButton+MCategory.h
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MCategory)

/** Creates and returns a new button of type `UIButtonCustom` with the specified frame.
 @param frame The frame for the button view.
 @return A newly create button.
 */
+ (id) buttonWithFrame:(CGRect)frame;

/** Creates and returns a new button of type `UIButtonCustom` with the specified frame and title.
 @param frame The frame for the button view.
 @param title The title for `UIControlStateNormal`.
 @return A newly create button.
 */
+ (id) buttonWithFrame:(CGRect)frame title:(NSString*)title;

/** Creates and returns a new button of type `UIButtonCustom` with the specified frame, title and background image.
 @param frame The frame for the button view.
 @param title The title for `UIControlStateNormal`.
 @param backgroundImage The background image for `UIControlStateNormal`.
 @return A newly create button.
 */
+ (id) buttonWithFrame:(CGRect)frame title:(NSString*)title backgroundImage:(UIImage*)backgroundImage;

/** Creates and returns a new button of type `UIButtonCustom` with the specified frame, title and background image.
 @param frame The frame for the button view.
 @param title The title for `UIControlStateNormal`.
 @param backgroundImage The background image for `UIControlStateNormal`.
 @param highlightedBackgroundImage The background image for `UIControlStateHighlighted`
 @return A newly create button.
 */
+ (id) buttonWithFrame:(CGRect)frame title:(NSString*)title backgroundImage:(UIImage*)backgroundImage highlightedBackgroundImage:(UIImage*)highlightedBackgroundImage;


/** Creates and returns a new button of type `UIButtonCustom` with the specified frame and image.
 @param frame The frame for the button view.
 @param image The image for `UIControlStateNormal`.
 @return A newly create button.
 */
+ (id) buttonWithFrame:(CGRect)frame image:(UIImage*)image;

/** Creates and returns a new button of type `UIButtonCustom` with the specified frame, title and background image.
 @param frame The frame for the button view.
 @param image The image for `UIControlStateNormal`.
 @param highlightedImage The image for `UIControlStateHighlighted`.
 @return A newly create button.
 */
+ (id) buttonWithFrame:(CGRect)frame image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage;


@end
