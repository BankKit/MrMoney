//
//  MScrollFullScreen.h
//  MrMoney
//
//  Created by xingyong on 14-3-25.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MScrollFullScreenDelegate;

@interface MScrollFullScreen : NSObject<UIScrollViewDelegate>

@property (nonatomic, weak) id<MScrollFullScreenDelegate> delegate;

@property (nonatomic) CGFloat upThresholdY; // up distance until fire. default 0 px.
@property (nonatomic) CGFloat downThresholdY; // down distance until fire. default 200 px.

- (id)initWithForwardTarget:(id)forwardTarget;
- (void)reset;

@end

@protocol MScrollFullScreenDelegate <NSObject>
- (void)scrollFullScreen:(MScrollFullScreen *)fullScreenProxy scrollViewDidScrollUp:(CGFloat)deltaY;
- (void)scrollFullScreen:(MScrollFullScreen *)fullScreenProxy scrollViewDidScrollDown:(CGFloat)deltaY;
- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(MScrollFullScreen *)fullScreenProxy;
- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(MScrollFullScreen *)fullScreenProxy;
@end