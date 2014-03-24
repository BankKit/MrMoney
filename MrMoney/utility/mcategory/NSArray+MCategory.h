//
//  NSArray+MCategory.h
//  MrMoney
//
//  Created by xingyong on 13-12-12.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MCategory)

- (id)initWithDictionaries:(NSArray *)anotherArray forKey:(NSString *)key;

- (id)safeObjectAtIndex:(NSUInteger)index;
- (NSArray *)sortByKey:(NSString *)key;
- (id)objectSortedByKey:(NSString *)key atIndex:(NSUInteger)index;

- (NSArray *)reversedArray;

- (void)saveArrayToFile:(NSString *)filename;
+ (NSArray *)loadArrayfromFile:(NSString *)fileName;

- (NSArray *)removeAllObjects;

-(BOOL)isEmpty;
@end
