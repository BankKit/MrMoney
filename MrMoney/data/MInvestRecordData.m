//
//  MInvestRecordData.m
//  MrMoney
//
//  Created by xingyong on 14-1-23.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MInvestRecordData.h"

@implementation MInvestRecordData
-(void)dealloc{
    self.mBsnsSts     = nil;
    self.mOriTrxCode  = nil;
    self.mPayId       = nil;
    self.mSTAN        = nil;
    self.mTrxDate     = nil;
    self.mTrxType     = nil;
    self.mid          = nil;
 
    self.mstatus      = nil;
    self.mtran_amount = nil;
    self.mtran_memo   = nil;
    self.mtran_time   = nil;
    self.mtran_type   = nil;
 
}
@end
