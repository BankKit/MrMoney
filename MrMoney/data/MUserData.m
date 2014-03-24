//
//  MUserData.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MUserData.h"

@implementation MUserData
-(void)dealloc{
    self.memail        = nil;
    self.mcanInvite    = nil;
    self.miconPath     = nil;
    self.misFirst      = nil;
    self.mrealName     = nil;
    self.mmid          = nil;
    self.mregisterTime = nil;
    self.mriskEvalue   = nil;
    self.msessionId    = nil;
}
@end
