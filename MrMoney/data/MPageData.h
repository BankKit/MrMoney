//
//  MPageData.h
//  MrMoney
//
//  Created by xingyong on 13-12-10.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MPageData : MBaseData

@property(nonatomic,strong)NSMutableArray *mpageArray;
/**
 *  搜索结果总数
 */
@property(nonatomic,assign) int mnumFound;

/**
 *  搜索结果覆盖到的银行个数
 */
@property(nonatomic,assign) int mfacetCount;

/**
 *  start
 */
@property(nonatomic,assign) int mstart;
/**
 *  搜索结果分页序号，从1开始
 */
@property(nonatomic,assign) int mpageIdx;



@end
