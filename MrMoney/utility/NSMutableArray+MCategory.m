//
//  NSMutableArray+MCategory.m
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "NSMutableArray+MCategory.h"
#import "NSString+MCategory.h"
@implementation NSMutableArray (MCategory)

-(id)safeObjectAtIndex:(NSUInteger)index
{
    //NSLog(@"safeObjectAtIndex: %d",index);
    
    if ([self count] > 0) return [self objectAtIndex:index];
    else return nil;
    
    /*
     @try {
     return [self objectAtIndex:index];
     }
     @catch (id theException) {
     NSLog(@"*** safeObjectAtIndex exception: %@", theException);
     return nil;
     }
     */
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from)
    {
        id obj = [self safeObjectAtIndex:from];
        [self removeObjectAtIndex:from];
        
        if (to >= [self count]) [self addObject:obj];
        else [self insertObject:obj atIndex:to];
    }
}

- (void)saveArrayToFile:(NSString *)filename;
{
    NSString *path = [NSString getLibraryDirectoryForFile:[NSString stringWithFormat:@"%@.plist",filename]];
    //NSLog(@"saveArrayToFile : %@",path);
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (NSMutableArray *)loadArrayfromFile:(NSString *)fileName
{
    NSString *path = [NSString getLibraryDirectoryForFile:[NSString stringWithFormat:@"%@.plist",fileName]];
    //NSLog(@"loadArrayfromFile : %@",path);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
