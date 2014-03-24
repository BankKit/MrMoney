//
//  MMoneyBabyData.m
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MMoneyBabyData.h"

@implementation MMoneyBabyData
-(void)dealloc{
    self. mbalance            = nil;
    self. mcanDrawMoney       = nil;
    self. mcanInvestMoney     = nil;
    self. mcurrentIncomeMoney = nil;
    self. mcurrentInvestMoney = nil;
    self. mdrawMoney          = nil;
    self. mloadMoney          = nil;
    self. mofficialBalance    = nil;
    self. msumIncomeMoney     = nil;
    self. msumInvestMoney     = nil;
    self. mtodayIncome        = nil;
    self. muserCount          = nil;
    self. myestodayIncome     = nil;
    self.mReal7Int            = nil;
    self.mcyclBal             = nil;
    self.mpresentMoney        = nil;
    self.mfCyclBal            = nil;
    self.mstartArray          = nil;
}
@end

@implementation MStarData
-(void)dealloc{
    self.mstar_bankId      = nil;
    self.mstar_investCycle = nil;
    self.mstar_multiple    = nil;
    self.mstar_productName = nil;
    self.mstar_returnRate  = nil;
    self.mstar_pid         = nil;
    
}


@end

@implementation MInternetData
-(void)dealloc{
    
    self.me_bankId      = nil;
    self.me_investCycle = nil;
    self.me_pid         = nil;
    self.me_productName = nil;
    self.me_returnRate  = nil;
    
    
}


@end



