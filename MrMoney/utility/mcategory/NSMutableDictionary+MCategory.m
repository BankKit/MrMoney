//
//  NSMutableDictionary+MCategory.m
//  MrMoney
//
//  Created by xingyong on 13-12-12.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "NSMutableDictionary+MCategory.h"

@implementation NSMutableDictionary (MCategory)

- (void)setSafeObject:(id)object forKey:(id<NSCopying>)aKey{
    
    if (object) {
        [self setObject:object forKey:aKey];
    }

}
@end
