//
//  MFundData.h
//  MrMoney
//
//  Created by xingyong on 14-2-22.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MFundData : MBaseData
@property(nonatomic,strong) NSString *mcumulative_value;
@property(nonatomic,strong) NSString *mestablish_date;
@property(nonatomic,strong) NSString *mestablish_return;
@property(nonatomic,strong) NSString *mfund_id;
@property(nonatomic,strong) NSString *mnet_date;
@property(nonatomic,strong) NSString *mnet_value;
@property(nonatomic,strong) NSString *mpid;
@property(nonatomic,strong) NSString *mproduct_code;
@property(nonatomic,strong) NSString *mproduct_name;
@property(nonatomic,strong) NSString *mproduct_type;
@property(nonatomic,strong) NSString *mtran_status;
@property(nonatomic,strong) NSString *mweek_return;
@property(nonatomic,strong) NSString *myear_return;
@end
