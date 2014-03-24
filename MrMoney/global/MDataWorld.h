//
//  MDataWorld.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHttpEngine.h"

#define KDATAWORLD [MDataWorld sharedInstance]

@interface MDataWorld : NSObject{

    MHttpEngine *m_httpEngine;
}

+ (MDataWorld*) sharedInstance;

// 服务器Http请求引擎

- (MHttpEngine *)httpEngine;
@end
