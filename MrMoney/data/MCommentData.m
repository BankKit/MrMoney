//
//  MCommentData.m
//  MrMoney
//
//  Created by xingyong on 14-1-14.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCommentData.h"

@implementation MCommentData
-(void)dealloc{
    self.mcontent   = nil;
    self.miconPath  = nil;
    self.mid        = nil;
    self.mloginName = nil;
    self.mmid       = nil;
    self.mpid       = nil;
    self.mpostDate  = nil;
    self.mrealName  = nil;
    self.mrootId    = nil;
    self.mrootName  = nil;
}
@end
