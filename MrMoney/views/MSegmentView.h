//
//  MSegmentView.h
//  MrMoney
//
//  Created by xingyong on 14-1-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSegmentView;

@protocol MSegmentViewDelegate <NSObject>
- (void)segmentView:(MSegmentView *)segmentView didSelectedSegmentAtIndex:(int)index;
@end
@interface MSegmentView : UIView{
    UIButton *_currentBtn;
    UILabel *_currentLabel;
    UIView *sliderView;
}

@property (nonatomic, weak) id<MSegmentViewDelegate> delegate;

@end
