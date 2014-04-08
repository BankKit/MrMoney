//
//  UIResponder+MotionRecognizers.h
//  MrMoney
//
//  Created by xingyong on 14-4-8.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (MotionRecognizers)
- (void) addMotionRecognizerWithAction:(SEL)action;

/** You must call this before deallocating the receiver. */
- (void) removeMotionRecognizer;
@end
