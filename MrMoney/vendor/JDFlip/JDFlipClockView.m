//
//  JDFlipClockView.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 09.11.13.
//  Copyright (c) 2013 markusemrich. All rights reserved.
//

#import "JDFlipNumberView.h"
#import "JDFlipClockView.h"

@interface JDFlipClockView ()
@property (nonatomic, copy) NSString *imageBundleName;
@property (nonatomic, strong) JDFlipNumberView* hourFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* minuteFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* secondFlipNumberView;

@property (nonatomic, strong) NSTimer *animationTimer;
@end

@implementation JDFlipClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithImageBundleName:nil];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (id)initWithImageBundleName:(NSString*)imageBundleName;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // view setup
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
		
        // setup flipviews
        _imageBundleName = imageBundleName;
        self.hourFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        self.minuteFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        self.secondFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        
        // set maximum values
        self.hourFlipNumberView.maximumValue = 23;
        self.minuteFlipNumberView.maximumValue = 59;
        self.secondFlipNumberView.maximumValue = 59;
        
        // disable reverse flipping
        self.hourFlipNumberView.reverseFlippingDisabled = YES;
        self.minuteFlipNumberView.reverseFlippingDisabled = YES;
        self.secondFlipNumberView.reverseFlippingDisabled = YES;
        
        // initial settings
        [self setZDistance:60];
        self.showsSeconds = NO;
        self.animationsEnabled = YES;
        self.relativeDigitMargin = 0.1;
        
        // set inital frame
        CGRect frame = self.hourFlipNumberView.frame;
        CGFloat digitMargin = self.hourFlipNumberView.frame.size.width * self.relativeDigitMargin;
        self.frame = CGRectMake(0, 0, frame.size.width*([self digitCount]/2.0)+digitMargin, frame.size.height);
        
        // add subviews
        for (JDFlipNumberView* view in @[self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
            [self addSubview:view];
        }
        
        // set inital value
        [self updateValuesAnimated:NO];
    }
    return self;
}

#pragma mark UIView

- (void)didMoveToSuperview;
{
    if (self.superview != nil) {
        [self setupUpdateTimer];
    } else {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

#pragma mark Getter

- (NSInteger)digitCount;
{
    return self.showsSeconds ? 6 : 4;
}

#pragma mark Setter

- (void)setRelativeDigitMargin:(CGFloat)relativeDigitMargin;
{
    _relativeDigitMargin = MAX(0,MIN(1,relativeDigitMargin));
    [self setNeedsLayout];
}

- (void)setShowsSeconds:(BOOL)showsSeconds;
{
    _showsSeconds = showsSeconds;
    self.secondFlipNumberView.hidden = !showsSeconds;
    [self setNeedsLayout];
}

- (NSUInteger)zDistance;
{
    return self.hourFlipNumberView.zDistance;
}

- (void)setZDistance:(NSUInteger)zDistance;
{
    for (JDFlipNumberView* view in @[self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
        [view setZDistance:zDistance];
    }
}

#pragma mark layout

- (CGSize)sizeThatFits:(CGSize)size;
{
    if (self.hourFlipNumberView == nil) {
        return [super sizeThatFits:size];
    }
    
    CGFloat margin = (size.width/[self digitCount])*self.relativeDigitMargin;
    CGFloat marginCount = self.showsSeconds ? 2 : 1;
    CGFloat digitWidth = (size.width-margin*marginCount)/([self digitCount]);
    CGFloat currentX   = 0;
    
    // check first number size
    CGSize firstSize = CGSizeMake(digitWidth * 2, size.height);
    firstSize = [self.hourFlipNumberView sizeThatFits:firstSize];
    currentX += firstSize.width;
    
    // check other numbers
    CGSize nextSize;
    for (JDFlipNumberView* view in @[self.minuteFlipNumberView, self.secondFlipNumberView]) {
        if (!self.showsSeconds && view == self.secondFlipNumberView) continue;
        currentX += firstSize.width*self.relativeDigitMargin;
        nextSize = CGSizeMake(digitWidth*2, size.height);
        nextSize = [view sizeThatFits:nextSize];
        currentX += nextSize.width;
    }
    
    // use bottom right of last number
    size.width  = ceil(currentX);
    size.height = ceil(nextSize.height);
    
    return size;
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    if (self.hourFlipNumberView == nil) {
        return;
    }
    
    CGSize size = [self sizeThatFits:self.bounds.size];
    CGFloat margin = (size.width/[self digitCount])*self.relativeDigitMargin;
    CGFloat marginCount = self.showsSeconds ? 2 : 1;
    CGFloat digitWidth = (size.width-margin*marginCount)/[self digitCount];
    CGFloat currentX = round((self.bounds.size.width - size.width)/2.0);
    
    // resize first flipview
    self.hourFlipNumberView.frame = CGRectMake(currentX, 0, digitWidth * 2, size.height);
    currentX += self.hourFlipNumberView.frame.size.width;
    
    // update flipview frames
    for (JDFlipNumberView* view in @[self.minuteFlipNumberView, self.secondFlipNumberView]) {
        if (!self.showsSeconds && view == self.secondFlipNumberView) continue;
        currentX   += margin;
        view.frame = CGRectMake(currentX, 0, digitWidth*2, size.height);
        currentX   += view.frame.size.width;
    }
}

#pragma mark Update Timer

- (void)setupUpdateTimer;
{
    self.animationTimer = [NSTimer timerWithTimeInterval:1.0 target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer*)timer;
{
    [self updateValuesAnimated:YES];
}

- (void)updateValuesAnimated:(BOOL)animated;
{
    animated &= self.animationsEnabled;
    
    
    NSDate *currentDate =  zoneDate([NSDate date]);
    
    NSTimeInterval secondsPerDay = 24*60*60;
    NSDate *tomorrows = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
    
    
    NSDate *toDate =  zoneDate([NSDate dateWithYear:tomorrows.year month:tomorrows.month day:tomorrows.day hour:0 minute:0 second:0]);
    
    NSDate *timeval =   [self intervalFromLastDate:currentDate toTheDate:toDate];

//    NSLog(@"--------------------- %@",timeval);

    [self.hourFlipNumberView setValue:[timeval hour] animated:animated];
    [self.minuteFlipNumberView setValue:[timeval minute] animated:animated];
    [self.secondFlipNumberView setValue:[timeval second] animated:animated];
}

- (NSDate *)intervalFromLastDate: (NSDate *) d1 toTheDate:(NSDate *) d2
{
    
    NSTimeInterval late1 = [d1 timeIntervalSinceNow];
    
    NSTimeInterval late2= [d2 timeIntervalSinceNow];
    
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    // min = [min substringToIndex:min.length-7];
    // 秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    // min = [min substringToIndex:min.length-7];
    // 分
    min=[NSString stringWithFormat:@"%@", min];
    
    
    // 小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    // house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    return  [MUtility dateFormatter:timeString formatter:kDefaultTimeStampFormatHms];;

}
- (void)start
{
    if (self.animationTimer == nil) {
        [self setupUpdateTimer];
    }
}

- (void)stop
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}


@end
