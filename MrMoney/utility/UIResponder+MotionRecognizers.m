//
//  UIResponder+MotionRecognizers.m
//  MrMoney
//
//  Created by xingyong on 14-4-8.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "UIResponder+MotionRecognizers.h"

@implementation UIResponder (MotionRecognizers)
- (void) addMotionRecognizerWithAction:(SEL)action {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:action name:@"CPDeviceShaken" object:nil];
}

- (void) removeMotionRecognizer {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CPDeviceShaken" object:nil];
}
@end
