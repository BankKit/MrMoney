//
//  MMapper.h
//  MrMoney
//
//  Created by xingyong on 14-3-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MMapperDelegate <NSObject>

@optional

// Allow properties to be excluded from parsing data
- (NSArray *)rm_excludedProperties;

// Mapping for properties keys to class properties
- (NSDictionary *)rm_dataKeysForClassProperties;

@end
@interface MMapper : NSObject
+ (NSDictionary *)propertiesForClass:(Class)cls;

/** Populate existing object with values from dictionary
 */
+ (id) populateObject:(id)obj fromDictionary:(NSDictionary*)dict;
+ (id) populateObject:(id)obj fromDictionary:(NSDictionary*)dict exclude:(NSArray*)excludeArray;


/** Create a new object with given class and populate it with value from dictionary
 */
+ (id) objectWithClass:(Class)cls fromDictionary:(NSDictionary*)dict;

/** Convert an object to a dictionary
 */
+ (NSDictionary*) dictionaryForObject:(id)obj;
+ (NSDictionary*) dictionaryForObject:(id)obj include:(NSArray*)includeArray;
+ (NSMutableDictionary*) mutableDictionaryForObject:(id)obj;
+ (NSMutableDictionary*) mutableDictionaryForObject:(id)obj include:(NSArray*)includeArray;


/** Convert an array of dict to array of object with predefined class
 */
+ (NSArray*) arrayOfClass:(Class)cls fromArrayOfDictionary:(NSArray*)array;
+ (NSMutableArray*) mutableArrayOfClass:(Class)cls fromArrayOfDictionary:(NSArray*)array;


@end
