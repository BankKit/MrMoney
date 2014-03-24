//
//  AppDelegate.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "MUpdateAction.h"
#import <TencentOpenAPI/TencentOAuth.h>
@class MMDrawerController;
@class MWindow;



#define kAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))


@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,MUpdateActionDelegate>{
    MUpdateAction *updateAction;
    float lastSecond;
    BOOL isFirst;
}

@property (strong, nonatomic) MWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) MMDrawerController *drawerController;

@property (strong, nonatomic) NSString *wbtoken;


@end
