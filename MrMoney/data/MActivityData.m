//
//  MActivityData.m
//  MrMoney
//
//  Created by xingyong on 14-2-26.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MActivityData.h"

@implementation MActivityData
-(void)dealloc{
    self.mactId        = nil;
    self.mactName      = nil;
    self.mactType      = nil;
    self.mcommentCount = nil;
    self.mcontent      = nil;
    self.miconPath     = nil;
    self.mlastPostTime = nil;
    self.mownerId      = nil;
    self.mrealName     = nil;
}

@end
