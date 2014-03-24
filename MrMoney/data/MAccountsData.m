//
//  MAccountsData.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MAccountsData.h"

@implementation MAccountsData

-(void)dealloc{
 
    self.maid         = nil;
    self.mbankId      = nil;
    self.mbankCardNo  = nil;
    self.mcurrency    = nil;
    self.mname        = nil;
    self.mopeningBank = nil;
    self.maddress     = nil;
    self.mqueryPwd    = nil;
    self.mnickName    = nil;
    self.midCardNum   = nil;
    self.mdollar = nil;
}
@end
