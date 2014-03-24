//
//  MTradeData.m
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MTradeData.h"

@implementation MTradeData
-(void)dealloc{
   self.mCrDr         = nil;
   self.mTrxCode      = nil;
   self.mbalance      = nil;
   self.mid           = nil;
   self.morderNo      = nil;
   self.mtran_amount  = nil;
   self.mtran_memo    = nil;
   self.mtran_time    = nil;
   self.mtrans_status = nil;
}
@end
