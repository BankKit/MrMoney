//
//  MMoneyBabyData.h
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MMoneyBabyData : MBaseData
@property (nonatomic,copy)NSString *  mbalance ;
@property (nonatomic,copy)NSString *  mcanDrawMoney ;
@property (nonatomic,copy)NSString *  mcanInvestMoney ;
@property (nonatomic,copy)NSString *  mcurrentIncomeMoney ;
@property (nonatomic,copy)NSString *  mcurrentInvestMoney ;
@property (nonatomic,copy)NSString *  mdrawMoney ;
@property (nonatomic,copy)NSString *  mloadMoney ;
@property (nonatomic,copy)NSString *  mofficialBalance ;
@property (nonatomic,copy)NSString *  msumIncomeMoney ;
@property (nonatomic,copy)NSString *  msumInvestMoney ;
@property (nonatomic,copy)NSString *  mtodayIncome ;
@property (nonatomic,copy)NSString *  muserCount ;
@property (nonatomic,copy)NSString *  myestodayIncome ;
@property (nonatomic,copy)NSString *  mReal7Int;
@property (nonatomic,copy)NSString *  mfCyclBal;
@property (nonatomic,copy)NSString *  mcyclBal;
@property (nonatomic,copy)NSString *  mpresentMoney;
@property (nonatomic,copy)NSString *  mjiashiDate;
@property (nonatomic,copy)NSString *  mjiashiReturnRate;

@property (nonatomic,strong)NSArray * mstartArray;
@property (nonatomic,strong)NSArray * minternetArray;


@end

@interface MStarData : MBaseData

@property (nonatomic,copy)NSString * mstar_bankId;
@property (nonatomic,copy)NSString * mstar_investCycle ;
@property (nonatomic,copy)NSString * mstar_multiple ;
@property (nonatomic,copy)NSString * mstar_productName ;
@property (nonatomic,copy)NSString * mstar_returnRate;
@property (nonatomic,copy)NSString * mstar_pid;

@end

@interface MInternetData : MBaseData

@property (nonatomic,copy)NSString * me_bankId;
@property (nonatomic,copy)NSString * me_investCycle ;
@property (nonatomic,copy)NSString * me_pid ;
@property (nonatomic,copy)NSString * me_productName ;
@property (nonatomic,copy)NSString * me_returnRate;


@end