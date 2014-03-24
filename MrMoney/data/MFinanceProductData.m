//
//  MFinanceProductData.m
//  MrMoney
//
//  Created by xingyong on 13-12-10.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MFinanceProductData.h"
#import "MSubFinanceData.h"
@implementation MFinanceProductData

-(void)dealloc{
    
    self.mpid            = nil;
    self.mproduct_name   = nil;
    self.mproduct_code   = nil;
    self.mcurrency       = nil;
    self.mbreak_even     = nil;
    self.msales_region   = nil;
    self.minvest_cycle   = nil;
    self.mvalue_date     = nil;
    self.mlowest_amount  = nil;
    self.mreturn_rate    = nil;
    self.mreturn_info    = nil;
    self.mproduct_type   = nil;
    self.mbank_id        = nil;
    self.mhas_guarantee  = nil;
    self.mpopularity     = nil;
    self.minside_sales   = nil;
    self.mlast_update    = nil;
    self.mprogress_value = nil;
}

//DECLARE_PROPERTIES(
//				   DECLARE_PROPERTY(@"mpid",@"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mproduct_name",@"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mproduct_code",@"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mcurrency",@"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mbreak_even",@"@\"NSString\""),
//                   DECLARE_PROPERTY(@"msales_region",@"@\"NSString\""),
//                   DECLARE_PROPERTY(@"minvest_cycle",@"@\"NSString\""),
//				   DECLARE_PROPERTY(@"mvalue_date", @"@\"NSString\""),
//
//                   DECLARE_PROPERTY(@"mlowest_amount", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mreturn_rate", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mreturn_info", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mproduct_type", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mbank_id", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mhas_guarantee", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mpopularity", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"minside_sales", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mlast_update", @"@\"NSString\""),
//                   DECLARE_PROPERTY(@"mprogress_value", @"@\"NSString\"")
//				   )
//

-(id)initWithFinanceProductData:(MSubFinanceData *)l_data{
    if (self = [super init]) {
        [self initWithPid:l_data.mpid withProduct_name:l_data.mproduct_name withProduct_code:l_data.mproduct_code withCurrency:l_data.mcurrency withBreak_even:l_data.mbreak_even withSales_region:l_data.msales_region withInvest_cycle:l_data.minvest_cycle withValue_date:l_data.mvalue_date withLowest_amount:l_data.mlowest_amount withReturn_rate:l_data.mreturn_rate withReturn_info:l_data.mreturn_info withProduct_type:l_data.mproduct_type withBank_id:l_data.mbank_id withHas_guarantee:l_data.mhas_guarantee withPopularity:l_data.mpopularity withInside_sales:l_data.minside_sales withLast_update:l_data.mlast_update withProgress_value:l_data.mprogress_value withProdBalance:l_data.mprodBalance];
    }
    return self;
}

-(void)initWithPid:(NSString*)pid
  withProduct_name:(NSString*)product_name
  withProduct_code:(NSString*)product_code
      withCurrency:(NSString*)currency
    withBreak_even:(NSString*)break_even
  withSales_region:(NSString*)sales_region
  withInvest_cycle:(NSString*)invest_cycle
    withValue_date:(NSString*)value_date
 withLowest_amount:(NSString*)lowest_amount
   withReturn_rate:(NSString*)return_rate
   withReturn_info:(NSString*)return_info
  withProduct_type:(NSString*)product_type
       withBank_id:(NSString*)bank_id
 withHas_guarantee:(NSString*)has_guarantee
    withPopularity:(NSString*)popularity
  withInside_sales:(NSString*)inside_sales
   withLast_update:(NSString*)last_update
withProgress_value:(NSString*)progress_value
   withProdBalance:(NSString *)prodBalance{


    self.mpid            = pid;
    self.mproduct_name   = product_name;
    self.mproduct_code   = product_code;
    self.mcurrency       = currency;
    self.mbreak_even     = break_even;
    self.msales_region   = sales_region;
    self.minvest_cycle   = invest_cycle;
    self.mvalue_date     = value_date;
    self.mlowest_amount  = lowest_amount;
    self.mreturn_rate    = return_rate;
    self.mreturn_info    = return_info;
    self.mproduct_type   = product_type;
    self.mbank_id        = bank_id;
    self.mhas_guarantee  = has_guarantee;
    self.mpopularity     = popularity;
    self.minside_sales   = inside_sales;
    self.mlast_update    = last_update;
    self.mprogress_value = progress_value;
    self.mprodBalance    = prodBalance;
 
}


@end
