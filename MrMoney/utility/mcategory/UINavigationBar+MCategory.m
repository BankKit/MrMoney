//
//  UINavigationBar+MCategory.m
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "UINavigationBar+MCategory.h"
#define KNaviBarBg_Tag 785478647
#define KNaviDefaultHeight 44.0
#import <mach/mach.h>
#import <mach/mach_time.h>

#if OBJC_API_VERSION >= 2
#import <objc/runtime.h>
#else
#import <objc/objc-class.h>
#endif

static IMP originalMethodOfdrawRect = nil;

static IMP originalMethodOfSizeThatFits = nil;

@implementation UINavigationBar (MCategory)

- (void)setDefaultBackground
{
    [self setBackground:[UIImage imageNamed:@""]];
    
    if (originalMethodOfSizeThatFits == nil) {
        originalMethodOfSizeThatFits = [self methodForSelector:@selector(sizeThatFits:)];
        class_replaceMethod([self class], @selector(sizeThatFits:), [self methodForSelector:@selector(customSizeThatFits:)], nil);
    }
}

// Junshuang added.控制是否需要使用自定义导航栏
- (void)useCustomNavBar:(BOOL)yesOrNo
{
    if (yesOrNo) {
        class_replaceMethod([self class], @selector(sizeThatFits:),
                            [self methodForSelector:@selector(customSizeThatFits:)], nil);
    }
    else {
        class_replaceMethod([self class],@selector(sizeThatFits:), originalMethodOfSizeThatFits, nil);
    }
}

- (void)setBackground:(UIImage*)image
{
	self.backgroundColor = [UIColor clearColor];
	if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
	{
		// set globablly for all UINavBars
		//UIBarMetricsDefault
		[self setBackgroundImage:image forBarMetrics:0];
	}
	else
	{
		if (originalMethodOfdrawRect == nil)
		{
			originalMethodOfdrawRect = [self methodForSelector:@selector(drawRect:)];
			class_replaceMethod([self class],@selector(drawRect:), [self methodForSelector:@selector(customDrawRect:)],nil);
		}
		
		UIImageView* bgview = [self testAndGetBgView];
		if (!image)
		{
			[bgview removeFromSuperview];
			return;
		}
		
		if (!bgview)
		{
			bgview = [[UIImageView alloc] init];
			bgview.tag = KNaviBarBg_Tag;
			[self addSubview:bgview];
			[self sendSubviewToBack:bgview];
		}
		[bgview setImage:image];
		bgview.frame = CGRectMake(0, 0, self.bounds.size.width, image.size.height);
	}
}

-(UIImageView *)testAndGetBgView
{
    return (UIImageView *)[self viewWithTag:KNaviBarBg_Tag];
}

- (BOOL)isUsedCustomerBg
{
	if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
	{
		UIImage* bgimage = [self backgroundImageForBarMetrics:0];
		if (bgimage) {
			return YES;
		}
	}
	else
	{
		if ([self testAndGetBgView]) {
			return YES;
		}
	}
	return NO;
}

//for other views
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    [self sendSubviewToBack:[self testAndGetBgView]];
}

/* input: The tag you chose to identify the view */
-(void)resetBackground
{
    [self sendSubviewToBack:[self viewWithTag:KNaviBarBg_Tag]];
}

- (void)customDrawRect:(CGRect)rect
{
	if (![self testAndGetBgView])
	{
        if (originalMethodOfdrawRect) {
            originalMethodOfdrawRect(self,@selector(drawRect:),rect);
        }
	}
}

//// the real navigationBar height
//- (CGSize)sizeThatFits:(CGSize)size
- (CGSize)customSizeThatFits:(CGSize)size
{
	self.frame = CGRectMake(0, 0, 320, [self getFitHeight]);
	
	if (![self isUsedCustomerBg])
	{
		CGSize newSize = CGSizeMake(320, KNaviDefaultHeight);
		return newSize;
	}
	else
	{
		CGSize newSize = CGSizeMake(320, 44.0);
		return newSize;
	}
}

- (CGFloat)getFitHeight
{
	if (![self isUsedCustomerBg])
	{
		return KNaviDefaultHeight;
	}
	else
	{
		CGFloat height = 44.0;
        
		return height;
	}
}

static CGPoint oldNavBarPoint;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // get the timebase info -- different on phone and OSX
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    // get the time
    uint64_t absTime = mach_absolute_time();
    
    // apply the timebase info
    absTime *= info.numer;
    absTime /= info.denom;
    
	NSTimeInterval system = (NSTimeInterval) ((double) absTime / 1000000000.0);
	
	CGPoint nowpoint = point;
	if (system - event.timestamp < 0.1 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
	{
		nowpoint = oldNavBarPoint;
	}
	oldNavBarPoint = point;
    
	if ([self pointInside:nowpoint withEvent:event])
	{
		for (UIView* vi in self.subviews)
		{
			CGPoint realpoint = [self convertPoint:nowpoint toView:vi];
			UIView* realview = [vi hitTest:realpoint withEvent:event];
			if (realview)
			{
				return realview;
			}
		}
		return self;
	}
	return nil;
}

- (void)setNavBackground:(UIImage *)img{
    // 判断系统版本
	if ( [[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        // 修改NavigationBar背景
		if ( [self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
        {
            [self setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }
	}
    else
    {
        // 背景View
        UIImageView *bgView_ = [[UIImageView alloc] initWithFrame:self.bounds];
//        [bgView_ setBackgroundColor:[UIColor clearColor]];
        [bgView_ setImage:img];
        [self insertSubview:bgView_ atIndex:0];
        
    }
}

@end
