//
//  MPointAnnotation.h
//  MrMoney
//
//  Created by xingyong on 14-3-5.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//


#import <MapKit/MapKit.h>

@interface MPointAnnotation :  NSObject <MKAnnotation>
@property(nonatomic,assign)NSUInteger tag;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) NSString *locationType;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
