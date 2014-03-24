//
//  MActivityData.h
//  MrMoney
//
//  Created by xingyong on 14-2-26.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MActivityData : MBaseData

@property (nonatomic,strong)NSString * mactId;
@property (nonatomic,strong)NSString * mactName;
@property (nonatomic,strong)NSString * mactType;
@property (nonatomic,strong)NSString * mcommentCount;
@property (nonatomic,strong)NSString * mcontent;
@property (nonatomic,strong)NSString * miconPath;
@property (nonatomic,strong)NSString * mlastPostTime;
@property (nonatomic,strong)NSString * mownerId;
@property (nonatomic,strong)NSString * mrealName;

@end
