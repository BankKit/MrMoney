//
//  MSubFinanceData.m
//  MrMoney
//
//  Created by xingyong on 14-1-26.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSubFinanceData.h"

@implementation MSubFinanceData

+(void)saveProductWithPid:(NSString*)pid
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
    
    MSubFinanceData* product = [[MSubFinanceData alloc] init];
    
    product.mpid            = pid;
    product.mproduct_name   = product_name;
    product.mproduct_code   = product_code;
    product.mcurrency       = currency;
    product.mbreak_even     = break_even;
    product.msales_region   = sales_region;
    product.minvest_cycle   = invest_cycle;
    product.mvalue_date     = value_date;
    product.mlowest_amount  = lowest_amount;
    
    product.mreturn_rate    = return_rate;
    product.mreturn_info    = return_info;
    product.mproduct_type   = product_type;
    product.mbank_id        = bank_id;
    product.mhas_guarantee  = has_guarantee;
    product.mpopularity     = popularity;
    product.minside_sales   = inside_sales;
    product.mlast_update    = last_update;
    product.mprogress_value = progress_value;
    product.mprodBalance    = prodBalance;
    
    [product insertToDb];
    
}

@end
