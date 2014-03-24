//
//  RadioButton.m
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MButtonRadio.h"

@interface MButtonRadio()
-(void)defaultInit;
-(void)otherButtonSelected:(id)sender;
-(void)handleButtonTap:(id)sender;
@end

@implementation MButtonRadio

@synthesize groupId=_groupId;
@synthesize index=_index;

static const NSUInteger kRadioButtonWidth=20;
static const NSUInteger kRadioButtonHeight=20;

static NSMutableArray *rb_instances=nil;
static NSMutableDictionary *rb_instancesDic=nil;  // 识别不同的组
static NSMutableDictionary *rb_observers=nil;
#pragma mark - Observer

-(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }
    
    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
      
    }
}

#pragma mark - Manage Instances

+(void)registerInstance:(MButtonRadio*)radioButton withGroupID:(NSString *)aGroupID{

    if(!rb_instancesDic){
        rb_instancesDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    }
    
    if ([rb_instancesDic objectForKey:aGroupID]) {
        [[rb_instancesDic objectForKey:aGroupID] addObject:radioButton];
        [rb_instancesDic setObject:[rb_instancesDic objectForKey:aGroupID] forKey:aGroupID];
   
    }else {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:16];
        [arr addObject:radioButton];
    
        [rb_instancesDic setObject:arr forKey:aGroupID];
    }
}

#pragma mark - Class level handler

+(void)buttonSelected:(MButtonRadio*)radioButton{
    
    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];
        
        if(observer && [observer respondsToSelector:@selector(buttonRadioSelectedAtIndex:inGroup:)]){
            [observer buttonRadioSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
        }
    }
    
    // Unselect the other radio buttons

    // 初始化按钮数组
    rb_instances = [rb_instancesDic objectForKey:radioButton.groupId];
    
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            MButtonRadio *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Object Lifecycle

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index{
    self = [self init];
    if (self) {
        _groupId = groupId;
        _index = index;
        
        [self defaultInit];  // 移动至此
    }
    return  self;
}

- (id)init{
    self = [super init];
    if (self) {
 //       [self defaultInit];
    }
    return self;
}

- (void)dealloc
{
    
}


#pragma mark - Set Default Checked

- (void) setChecked:(BOOL)isChecked
{
    if (isChecked) {
        [_button setSelected:YES];
    }else {
        [_button setSelected:NO];
    }
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
    [_button setSelected:YES];
    [MButtonRadio buttonSelected:self];
}

-(void)otherButtonSelected:(id)sender{
    // Called when other radio button instance got selected
    if(_button.selected){
        [_button setSelected:NO];        
    }
}

#pragma mark - RadioButton init

-(void)defaultInit{
    // Setup container view
    self.frame = CGRectMake(0, 0, kRadioButtonWidth, kRadioButtonHeight);
    
    // Customize UIButton
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0,kRadioButtonWidth, kRadioButtonHeight);
    _button.adjustsImageWhenHighlighted = NO; 
    
    [_button setImage:[UIImage imageNamed:@"btn_radio_normal"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"btn_radio_focus"] forState:UIControlStateSelected];
    
    [_button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    
 //   [RadioButton registerInstance:self];
    
    // update follow:
    [MButtonRadio registerInstance:self withGroupID:self.groupId];

}


@end
