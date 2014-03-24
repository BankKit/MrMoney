//
//  JingRoundView.m
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#import "MRoundView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define kRotationDuration 8.0

@interface MRoundView ()

@property (strong, nonatomic) UIImageView *roundImageView;
@property (strong, nonatomic) CABasicAnimation* rotationAnimation;
@end

@implementation MRoundView

-(void) initRound
{
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
    //set JingRoundView
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    
    self.layer.cornerRadius = center.x;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
 
    
    //set roundImageView
    UIImage *roundImage = self.roundImage;
    self.roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.roundImageView setCenter:center];
    [self.roundImageView setImage:roundImage];
    [self addSubview:self.roundImageView];
    
    //set play state
    UIImage *stateImage;
    if (self.isPlay) {
        stateImage = [UIImage imageNamed:@"start"];
    }else{
        stateImage = [UIImage imageNamed:@"pause"];
    }
 
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0, 0, 1.0) ];
    animation.duration = 1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = YES;
    
    //关键帧，旋转，透明度组合起来执行
    
    if (self.rotationDuration == 0) {
        self.rotationDuration = kRotationDuration;
    }
    
    animation.duration = self.rotationDuration;
    
    [self.roundImageView.layer addAnimation:animation forKey:nil];
    
    
    //pause
    if (!self.isPlay) {
        self.layer.speed = 0.0;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self initRound];
}

//setter
-(void)setIsPlay:(BOOL)aIsPlay
{
    _isPlay = aIsPlay;
    
    if (self.isPlay) {
        [self startRotation];
    }else{
        [self pauseRotation];
    }
}
-(void)setRoundImage:(UIImage *)aRoundImage
{
    _roundImage = aRoundImage;
    self.roundImageView.image = self.roundImage;
}

//touchesBegan
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPlay = !self.isPlay;
    [self.delegate playStatuUpdate:self.isPlay];
}

-(void) startRotation
{
    //start Animation
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
    
 
}

-(void) pauseRotation
{
    //set ImgView
 
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         self.playStateView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:1.0 animations:^{
//                                 self.playStateView.alpha = 0;
                                 //pause
                                 CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                                 self.layer.speed = 0.0;
                                 self.layer.timeOffset = pausedTime;
                             }];
                         }
                     }
     ];
    
}

-(void)play
{
    self.isPlay = YES;
}
-(void)pause
{
    self.isPlay = NO;
}

@end
