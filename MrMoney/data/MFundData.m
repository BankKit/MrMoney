//
//  MFundData.m
//  MrMoney
//
//  Created by xingyong on 14-2-22.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFundData.h"

@implementation MFundData
-(void)dealloc{
    self.mcumulative_value = nil;
    self.mestablish_date   = nil;
    self.mestablish_return = nil;
    self.mfund_id          = nil;
    self.mnet_date         = nil;
    self.mnet_value        = nil;
    self.mpid              = nil;
    self.mproduct_code     = nil;
    self.mproduct_name     = nil;
    self.mproduct_type     = nil;
    self.mtran_status      = nil;
    self.mweek_return      = nil;
    self.myear_return      = nil;
}
@end
