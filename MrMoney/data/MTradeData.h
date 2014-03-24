//
//  MTradeData.h
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MTradeData : MBaseData


@property(nonatomic,strong)NSString *mCrDr;
@property(nonatomic,strong)NSString *mTrxCode;
@property(nonatomic,strong)NSString *mbalance;
@property(nonatomic,strong)NSString *mid;
@property(nonatomic,strong)NSString *morderNo; 
@property(nonatomic,strong)NSString *mtran_amount;
@property(nonatomic,strong)NSString *mtran_memo;
@property(nonatomic,strong)NSString *mtran_time;
@property(nonatomic,copy)NSString *mtrans_status;
@property(nonatomic,copy)NSString *mtransTypeDesc;



@end
