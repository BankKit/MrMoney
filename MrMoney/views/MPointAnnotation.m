//
//  MPointAnnotation.m
//  MrMoney
//
//  Created by xingyong on 14-3-5.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MPointAnnotation.h"

@implementation MPointAnnotation


- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}


@end
