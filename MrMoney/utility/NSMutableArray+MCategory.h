//
//  NSMutableArray+MCategory.h
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MCategory)
- (id)safeObjectAtIndex:(NSUInteger)index;
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
 
+ (NSMutableArray *)loadArrayfromFile:(NSString *)fileName;
@end
