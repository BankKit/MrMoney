//
//  MActProductData.m
//  MrMoney
//
//  Created by xingyong on 14-3-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MActProductData.h"

@implementation MActProductData
-(void)dealloc{
    self.mactRmAmount        = nil;
    self.mbankId             = nil;
    self.mbreakEven          = nil;
    self.mcallDate           = nil;
    self.mcurrency           = nil;
    self.mdRate              = nil;
    self.mendTime            = nil;
    self.mexpectedReturnRate = nil;
    self.minvestCycle        = nil;
    self.mpid                = nil;
    self.mprodRate           = nil;
    self.mproductCode        = nil;
    self.mproductName        = nil;
    self.mproductType        = nil;
    self.msalesRegion_desc   = nil;
    self.mvalueDate          = nil;
}
@end
