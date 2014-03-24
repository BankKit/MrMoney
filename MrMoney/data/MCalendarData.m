//
//  MCalendarData.m
//  MrMoney
//
//  Created by xingyong on 14-2-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCalendarData.h"

@implementation MCalendarData
-(void)dealloc{
    self.mactId       = nil;
    self.mbankId      = nil;
    self.mcallDate    = nil;
    self.mexpectRate  = nil;
    self.mincomeMoney = nil;
    self.minvestCycle = nil;
    self.minvestDate  = nil;
    self.minvestMoney = nil;
    self.mname        = nil;
    self.mpid         = nil;
    self.mvalueDate   = nil;
}
@end
