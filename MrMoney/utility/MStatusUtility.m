//
//  MStatusUtility.m
//  MrMoney
//
//  Created by xingyong on 14-1-17.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MStatusUtility.h"
#import "MFinanceProductData.h"
#import "MSubFinanceData.h"
@implementation MStatusUtility

+(void)clearCollectData;
{
    for (MFinanceProductData *l_data in [MFinanceProductData allDbObjects]) {
            [l_data removeFromDb];
        }
}

+(void)saveCollectData:(MFinanceProductData *)data{
         
    NSString *where = STRING_FORMAT(@"mpid='%@'",data.mpid);
    
    if (![MFinanceProductData existDbObjectsWhere:where]) {
        [data insertToDb];
    }
    
}

+(void)saveSubData:(MFinanceProductData *)l_data{
    
    NSString *where = STRING_FORMAT(@"mpid='%@'",l_data.mpid);
    
    if (![MSubFinanceData existDbObjectsWhere:where]) {
        
        [MSubFinanceData removeDbObjectsWhere:where];
        
        [MSubFinanceData saveProductWithPid:l_data.mpid  withProduct_name:l_data.mproduct_name withProduct_code:l_data.mproduct_code withCurrency:l_data.mcurrency withBreak_even:l_data.mbreak_even withSales_region:l_data.msales_region withInvest_cycle:l_data.minvest_cycle withValue_date:l_data.mvalue_date withLowest_amount:l_data.mlowest_amount withReturn_rate:l_data.mreturn_rate withReturn_info:l_data.mreturn_info withProduct_type:l_data.mproduct_type withBank_id:l_data.mbank_id withHas_guarantee:l_data.mhas_guarantee withPopularity:l_data.mpopularity withInside_sales:l_data.minside_sales withLast_update:l_data.mlast_update withProgress_value:l_data.mprogress_value withProdBalance:l_data.mprodBalance];

    }
    
}
+(void)deleteBrowerData:(MFinanceProductData*)l_data{
    //     [l_data deleteObject];
}

@end
