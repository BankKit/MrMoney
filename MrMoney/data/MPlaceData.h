//
//  MPlaceData.h
//  MrMoney
//
//  Created by xingyong on 14-3-20.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MPlaceData : MBaseData

@property (nonatomic,copy) NSString *maddress   ;
@property (nonatomic,copy) NSString *mlocation  ;
@property (nonatomic,copy) NSString *mname      ;
@property (nonatomic,copy) NSString *mstreet_id ;
@property (nonatomic,copy) NSString *mtelephone ;
@property (nonatomic,copy) NSString *muid       ;
@property (nonatomic,assign) double mlat       ;
@property (nonatomic,assign) double mlng       ;

@end
