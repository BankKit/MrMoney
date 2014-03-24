//
//  MDataWorld.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MDataWorld.h"

static MDataWorld *sharedObj = nil; //第一步：静态实例，并初始化。

@implementation MDataWorld

+ (MDataWorld*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj =  [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}


- (MHttpEngine *)httpEngine{
    @synchronized(self)
	{
        
		if (m_httpEngine==nil)
		{
			m_httpEngine = [MHttpEngine engineWithHeaderParams:nil];
             [m_httpEngine setM_timeInterval_timeout:15.0f];
		}
	}
	return m_httpEngine;
}

@end
