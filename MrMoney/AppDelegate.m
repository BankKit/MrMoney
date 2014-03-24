//
//  AppDelegate.m
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "MHomeViewController.h"
#import "MChatViewController.h"
#import "MSetupViewController.h"
#import "RDVTabBarItem.h"
#import "SDWebImageManager.h"
#import "KKNavigationController.h"
#import "MMDrawerController.h"
#import "MFilterViewController.h"
#import "MSubFinanceData.h"
#import "MYCustomPanel.h"
#import "MYBlurIntroductionView.h"
#import "MLockViewController.h"
#import "MWindow.h"
#import "ShareEngine.h"
 

@implementation AppDelegate
@synthesize drawerController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[MWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
 
    lastSecond =   [MUtility getTimeInterval];

    if (isUserLogin()) {
        [MActionUtility recoverUserDataFromDB];
    }

    updateAction = [[MUpdateAction alloc] init];
    updateAction.m_delegate = self;
    [updateAction requestAction];
    
 
    
     [[ShareEngine sharedInstance] registerApp];
    
    
    SDWebImageManager.sharedManager.cacheKeyFilter = ^(NSURL *url)
    {
        url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
        return [url absoluteString];
    };
    
    
    MFilterViewController * rightViewController = [[MFilterViewController alloc] initWithNibName:@"MFilterViewController" bundle:nil];
    
    
    self.window.backgroundColor = [UIColor blackColor];
    [self setupViewControllers];
    
    drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.viewController rightDrawerViewController:rightViewController];
    
    drawerController.showsShadow = NO;
    [drawerController setMaximumRightDrawerWidth:270.0];
    
    [self.window setRootViewController:drawerController];
    [self.window makeKeyAndVisible];
    
 
    
    if (!user_defaults_get_bool(@"introduction")) {
        [self setIntroductionPanel];
    }
 

    return YES;
}

-(void)setIntroductionPanel{
    
    
     MYCustomPanel *panel1 = [[MYCustomPanel alloc] initWithFrame:self.window.bounds nibNamed:@"MYCustomPanel"];
    
    MYCustomPanel *panel2 = [[MYCustomPanel alloc] initWithFrame:self.window.bounds nibNamed:@"MYCustomPanel"];
 
    panel2.imageView.image = [UIImage imageNamed:@"guide_2.jpg"];
    
    MYCustomPanel *panel3 = [[MYCustomPanel alloc] initWithFrame:self.window.bounds nibNamed:@"MYCustomPanel"];
    panel3.introductionBtn.hidden = NO;
     panel3.imageView.image = [UIImage imageNamed:@"guide_3.jpg"];
    
    
    NSArray *panels = @[panel1, panel2,panel3];
    
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:self.window.bounds];
//    introductionView.delegate = self;

    [introductionView setBackgroundColor:KVIEW_BACKGROUND_COLOR];

    [introductionView buildIntroductionWithPanels:panels];
    
    user_defaults_set_bool(@"introduction", YES);
    
    [self.window addSubview:introductionView];
    
}
//-(void)copyDB{
//    NSFileManager *manger = [NSFileManager defaultManager];
//    
//    NSString *documentPath = [NSString getDocumentsDirectoryForFile:ksqlite_name];
//    NSString *bundlePath = [NSString getBundlePathForFile:ksqlite_name];
//    
//    NSArray *dataArray = [MSubFinanceData allDbObjects];
//    
//    BOOL success;
// 
//    NSError *error;
//    
//    if ([dataArray count] == 0) {
//        
//       [manger removeItemAtPath:documentPath error:&error];
//
//       success =  [manger copyItemAtPath:bundlePath toPath:documentPath error:&error];
//        
//        NSLog(@"success ------- %d",success);
//    }
//  
//}

#pragma mark - Methods

- (void)setupViewControllers {
    MHomeViewController *home = [[MHomeViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:home];
    [homeNavigationController setNavigationBarHidden:YES animated:YES];
     
    homeNavigationController.delegate = self;
    
    
    MChatViewController *chat = [[MChatViewController alloc] init];
    UINavigationController *chatNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:chat];
    chatNavigationController.delegate = self;
    
    MSetupViewController *setup = [[MSetupViewController alloc] init];
    UINavigationController *setupNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:setup];
    setupNavigationController.delegate = self;
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[chatNavigationController, homeNavigationController,
                                           setupNavigationController]];
    [tabBarController setSelectedIndex:1];
    
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [[UIImage imageNamed:@"tabbar_selected_background"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *unfinishedImage = [[UIImage imageNamed:@"tabbar_normal_background"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    NSArray *tabBarItemImages = @[@"icon_chat", @"icon_home", @"icon_setting"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}
//
//- (void)customizeInterface {
//    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    
//    UIImage *navImage = [[UIImage imageNamed:@"bg_nav.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
//    
//    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
//        
//        [navigationBarAppearance setBackgroundImage:navImage
//                                      forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [navigationBarAppearance setBackgroundImage:navImage
//                                      forBarMetrics:UIBarMetricsDefault];
//        
//        NSDictionary *textAttributes = nil;
//        
//        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
//            textAttributes = @{
//                               NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
//                               NSForegroundColorAttributeName: [UIColor blackColor],
//                               };
//        } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//            textAttributes = @{
//                               UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
//                               UITextAttributeTextColor: [UIColor blackColor],
//                               UITextAttributeTextShadowColor: [UIColor clearColor],
//                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
//                               };
//#endif
//        }
//        
//        
//        [navigationBarAppearance setTitleTextAttributes:textAttributes];
//    }
//}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    RDVTabBarController *tabBarController = (RDVTabBarController *)self.viewController;
    if (navigationController.viewControllers.count > 1) {
        
        [tabBarController setTabBarHidden:YES animated:NO];
    } else {
        
        [tabBarController setTabBarHidden:NO animated:NO];
    }
    
}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    NSLog(@"=====WBBaseResponse= 微博分享 ===== ");
//    
//    if([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
//    {
//        if (response.statusCode == 0) {
//            
//            [MActionUtility showAlert:@"微博分享成功"];
//            
//        }
//        else
//        {
//            [MActionUtility showAlert:@"微博分享失败"];
//        }
//        
//    }
//    
////    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
////    {
////        NSString *title = @"发送结果";
////        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:@"确定"
////                                              otherButtonTitles:nil];
////        [alert show];
////      
////    }
////    else if ([response isKindOfClass:WBAuthorizeResponse.class])
////    {
////        NSString *title = @"认证结果";
////        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:@"确定"
////                                              otherButtonTitles:nil];
////        
////        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
////        [alert show];
////   
////    }
//}



//-(void) onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        if (resp.errCode == 0)
//            
//            [MActionUtility showAlert:@"微信分享成功"];
// 
//            [MActionUtility showAlert:@"微信分享失败"];
//    }
//}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
// 
//    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
//    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
//    return  isSuc;
//}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
 
    if ([url.absoluteString containsString:@"tencent101027370"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
     return [[ShareEngine sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"-------------------------------%@ \n\n",url);
    if ([url.absoluteString containsString:@"tencent101027370"]) {
         return [TencentOAuth HandleOpenURL:url];
    }

   return [[ShareEngine sharedInstance] handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    float currentSecond = [MUtility getTimeInterval];
    NSLog(@"currentSecond-lastSecond------- %f",currentSecond-lastSecond);

    if (!isFirst) {
        
        NSString * pattern = user_defaults_get_string(kCurrentPattern);
        
        MLockViewController *lockVc = [[MLockViewController alloc]initWithNibName:@"MLockViewController" bundle:nil];
        
        if(self.window.rootViewController.presentingViewController == nil && ![pattern isEqualToString:@""]){
            
            lockVc.infoLabelStatus = InfoStatusNormal;
            
        }else{
            
            lockVc.infoLabelStatus = InfoStatusFirstTimeSetting;
            
        }
        
        [self.window.rootViewController presentViewController:lockVc animated:YES completion:^{
            
        }];
        
        isFirst = YES;
        
    }else if((currentSecond-lastSecond)> 600){
        
        NSString * pattern = user_defaults_get_string(kCurrentPattern);
        
        MLockViewController *lockVc = [[MLockViewController alloc]initWithNibName:@"MLockViewController" bundle:nil];
        
        if(self.window.rootViewController.presentingViewController == nil && ![pattern isEqualToString:@""]){
            
            lockVc.infoLabelStatus = InfoStatusNormal;
            
        }else{
            
            lockVc.infoLabelStatus = InfoStatusFirstTimeSetting;
            
        }
        
        [self.window.rootViewController presentViewController:lockVc animated:YES completion:^{
            
        }];
        lastSecond = currentSecond;
    }
  
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
