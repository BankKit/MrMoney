//
//  MFinanceProductData.h
//  MrMoney
//
//  Created by xingyong on 13-12-10.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseData.h"
@class MSubFinanceData;
@interface MFinanceProductData : MBaseData
/**
 *  产品id
 */
@property(nonatomic,strong) NSString *mpid;
/**
 *  产品名称
 */
@property(nonatomic,strong) NSString *mproduct_name;
/**
 *  产品代码
 */
@property(nonatomic,strong) NSString *mproduct_code;
/**
 *  币种
 */
@property(nonatomic,strong) NSString *mcurrency;
/**
 *  1=保本;0=不保本
 */
@property(nonatomic,strong) NSString *mbreak_even;
/**
 *  销售区域
 */
@property(nonatomic,strong) NSString *msales_region;
/**
 *  投资周期（天）：-1=灵活周期/N天滚动等特殊周期
 */
@property(nonatomic,strong) NSString *minvest_cycle;
/**
 *  起息日
 */
@property(nonatomic,strong) NSString *mvalue_date;
/**
 *  起售金额(分)
 */
@property(nonatomic,strong) NSString *mlowest_amount;
/**
 *  预期收益率（扩大1w倍，以int存储，即4.55%=455），0=收益不确定（详见说明书），-1=产品收益以净值方式计量
 */
@property(nonatomic,strong) NSString *mreturn_rate;
/**
 *  收益说明
 */
@property(nonatomic,strong) NSString *mreturn_info;
/**
 *  产品投资类型
 */
@property(nonatomic,strong) NSString *mproduct_type;
/**
 *  所属银行代码
 */
@property(nonatomic,strong) NSString *mbank_id;
/**
 *  是否支持风险担保：0，不支持；1，支持
 */
@property(nonatomic,strong) NSString *mhas_guarantee;
/**
 *  人气
 */
@property(nonatomic,strong) NSString *mpopularity;
/**
 *  站内销量
 */
@property(nonatomic,strong) NSString *minside_sales;
/**
 *  更新时间戳
 */
@property(nonatomic,strong) NSString *mlast_update;

/**
 *  进度
 */
@property(nonatomic,strong) NSString *mprogress_value;
/**
 *  已团购金额
 */
@property(nonatomic,strong) NSString *mprodBalance;

@property(nonatomic,assign) BOOL mStar;


-(id)initWithFinanceProductData:(MSubFinanceData *)l_data;

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
          withProdBalance:(NSString *)prodBalance;

@end
