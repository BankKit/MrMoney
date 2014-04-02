//
//  BlurView.m
//  TestBlurView
//
//  Created by xingyong on 14-3-11.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "BlurView.h"
#import "UIImage+ImageEffects.h"
#import "MPopView.h"
#import "MSecKillView.h"
#import "MOrderView.h"
#import "MRechargeView.h"


#define kButtonHeight 50.f
#define kCancelButtonHeight 60.f
#define kAnimationDuration 0.35f
#define kSeparatorWidth .5f
#define kMargin 10.f
#define kBottomMargin 10.f

static UIWindow *__sheetWindow = nil;

@implementation BlurView

- (id)initWithFrame:(CGRect)frame withXib:(NSString *)xib action:(blurViewBlock )actionBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.actionBlock = actionBlock;
        
        _blurView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenSize.width, self.screenSize.height)];
        
        _blurView.alpha = 0.f;
        
        _blurView.userInteractionEnabled = YES;
        
        self.xib = xib;
        
        self.clipsToBounds = YES;
        
        if ([xib isEqualToString:@"MPopView"]) {
            MPopView *popView = [[[NSBundle mainBundle] loadNibNamed:xib owner:self options:nil] lastObject];
            [popView.fadeOutBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
            [popView.fadeOutBuyBtn addTarget:self action:@selector(onFadeBuyAction) forControlEvents:UIControlEventTouchUpInside];
            popView.center = self.center;
            [self addSubview:popView];
            
        }
        
        
        if([xib isEqualToString:@"MSecKillView"]){
            
             MSecKillView *seckillView = [[[NSBundle mainBundle] loadNibNamed:xib owner:self options:nil] lastObject];
            [seckillView.fadeOutBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
            [seckillView.fadeOutBuyBtn addTarget:self action:@selector(onFadeBuyAction) forControlEvents:UIControlEventTouchUpInside];
            seckillView.center = self.center;
            [self addSubview:seckillView];
            
        }
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        self.center =window.center;
      
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withXib:(NSString *)xib action:(blurViewBlock )actionBlock orderData:(MFinanceProductData *)data amount:(int )amount payStyle:(NSString *)pay{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.actionBlock = actionBlock;
        

        self.xib = xib;
 
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        
        
        if ([xib isEqualToString:@"MOrderView"]) {
            MOrderView *orderView = [[[NSBundle mainBundle] loadNibNamed:xib owner:self options:nil] lastObject];
            
            orderView.data = data;
            
            orderView.amount = amount;
            
            orderView.payStyle = pay;
            
            [orderView.cancelBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
            
            [orderView.submitBtn addTarget:self action:@selector(onFadeBuyAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:orderView];
        }
        
        if ([xib isEqualToString:@"MRechargeView"]) {
            MRechargeView *rechargeView =  [[[NSBundle mainBundle] loadNibNamed:xib owner:self options:nil] lastObject];
            rechargeView.amount = amount;
            
            rechargeView.payStyle = pay ;
            
            [rechargeView.cancelBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
            
            [rechargeView.submitBtn addTarget:self action:@selector(onFadeBuyAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:rechargeView];

        }
        
        [_overlayView addSubview:self];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        self.center =window.center;

    }
    return self;
}
-(void)onFadeBuyAction{
    [self fadeOut];
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark - Show
- (CGSize)screenSize {
    return [[UIScreen mainScreen] bounds].size;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [self layoutIfNeeded];
  
    
    if ([self.xib isEqualToString:@"MOrderView"] || [self.xib isEqualToString:@"MRechargeView"]) {
        [window addSubview:self.overlayView];
        
     }else{

         [window addSubview:self.blurView];
         
         [window addSubview:self];
      
        
        [self loadBlurViewContents];
    }

    
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 1;
        self.blurView.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1, 1);
        
    }];
    
  
}


- (void)fadeOut
{
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
        self.blurView.alpha = 0.0;
        self.overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self.overlayView removeFromSuperview];
            [self.blurView removeFromSuperview];
        }
    }];
}


- (void)loadBlurViewContents {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIImage *image = nil;
     UIGraphicsBeginImageContextWithOptions(keyWindow.bounds.size, YES, 0);
    if (IsIOS7) {
        
        [keyWindow drawViewHierarchyInRect:keyWindow.frame afterScreenUpdates:NO];
  
    }else{

        [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
       
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    
    UIImage *blurredImage = [image applyBlurWithRadius:4.f tintColor:self.blurTintColor saturationDeltaFactor:1.f maskImage:nil];
    
    self.blurView.image = blurredImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
