//
//  NSMutableDictionary+MCategory.h
//  MrMoney
//
//  Created by xingyong on 13-12-12.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MCategory)

- (void)setSafeObject:(id)object forKey:(id<NSCopying>)aKey;

@end
