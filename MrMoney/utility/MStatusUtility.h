//
//  MStatusUtility.h
//  MrMoney
//
//  Created by xingyong on 14-1-17.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MFinanceProductData;
@class MSubFinanceData;
@interface MStatusUtility : NSObject
 
/**
 *   清除我的收藏
 */

+(void)clearCollectData;
 
/**
 *	@brief	 保存产品
 *
 *	保存收藏产品
 *
 *	@param 	l_data 	收藏
 */

+(void)saveCollectData:(MFinanceProductData *)l_data;

+(void)saveSubData:(MFinanceProductData *)l_data;


/**
 *	@brief	删除收藏内容
 *
 *	删除收藏
 *
 */
+(void)deleteBrowerData:(MFinanceProductData*)l_data;


@end
