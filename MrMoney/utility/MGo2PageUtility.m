//
//  MGo2PageUtility.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MGo2PageUtility.h"
#import "MFinanceProductsViewController.h"
#import "MWalletViewController.h"
#import "MInvestRecordViewController.h"
#import "MMoneyBabyViewController.h"
#import "MSecurityAssuranceViewController.h"
#import "MLoginViewController.h"
#import "DZWebBrowser.h"
#import "MProductDetailViewController.h"
#import "MPurchaseViewController.h"
@implementation MGo2PageUtility

+ (void)go2MFinanceProductsViewController:(MBaseViewController *)viewCtrl
                                 pushType:(MHomeViewControllerPushType)type{
    MFinanceProductsViewController *financeProducts = [[MFinanceProductsViewController alloc] initWithNibName:@"MFinanceProductsViewController" bundle:nil];
    financeProducts.type = type;
    [viewCtrl.navigationController pushViewController:financeProducts animated:YES];
    
}
+ (void)go2MProductDetailViewController:(MBaseViewController *)viewCtrl
                                   data:(MFinanceProductData *)data{
    
    MProductDetailViewController *controller = [[MProductDetailViewController alloc] initWithNibName:@"MProductDetailViewController" bundle:nil];
    controller.data = data;
    
    [viewCtrl.navigationController pushViewController:controller animated:YES];
    
}



+ (void)go2MSecurityAssuranceViewController:(MBaseViewController *)viewCtrl
                                   pushType:(MHomeViewControllerPushType)type{
    MSecurityAssuranceViewController *controller = [[MSecurityAssuranceViewController alloc] initWithNibName:@"MSecurityAssuranceViewController" bundle:nil];
    controller.type = type;
    [viewCtrl.navigationController pushViewController:controller animated:YES];
}
+ (void)go2MWalletViewController:(MBaseViewController *)viewCtrl
                        pushType:(MHomeViewControllerPushType)type
                     canWithdraw:(NSString *)drawMoney{
    MWalletViewController *wallet = [[MWalletViewController alloc] initWithNibName:@"MWalletViewController" bundle:nil];
    wallet.type = type;
    wallet.canWithdrawMoney = drawMoney;
    [viewCtrl.navigationController pushViewController:wallet animated:YES];
}
+ (void)go2MTreasureViewController:(MBaseViewController *)viewCtrl
                        pushType:(MHomeViewControllerPushType)type{
    MInvestRecordViewController *controller = [[MInvestRecordViewController alloc] initWithNibName:@"MTreasureViewController" bundle:nil];
    controller.type = type;
    [viewCtrl.navigationController pushViewController:controller animated:YES];
}
+ (void)go2MMoneyBabyViewController:(MBaseViewController *)viewCtrl
                               data:(MMoneyBabyData *)money
                           pushType:(MHomeViewControllerPushType)type{
    MMoneyBabyViewController *controller = [[MMoneyBabyViewController alloc] initWithNibName:@"MMoneyBabyViewController" bundle:nil];
    controller.type = type;
    controller.money = money;
    [viewCtrl.navigationController pushViewController:controller animated:YES];
}
+ (void)go2MLoginViewController:(MBaseViewController *)viewCtrl
              completionHandler:(loginBlockHandler)handler{
    
    MLoginViewController *login = [[MLoginViewController alloc] initWithNibName:@"MLoginViewController" bundle:nil];
 
    login.loadType = BaseVC_PresentType;
    login.completionHandler = handler;

     UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:login];
    
    [viewCtrl presentViewController:nc animated:YES completion:nil];
 
}
 

+ (void)go2MWebBrowser:(MBaseViewController *)viewCtrl
                        title:(NSString *)title
                       webUrl:(NSString *)url{

    NSURL *URL = [NSURL URLWithString:url];
    DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:URL];
    webBrowser.showProgress = YES;
    webBrowser.allowSharing = NO;
    webBrowser.navTitle = title;
    
    [viewCtrl.navigationController pushViewController:webBrowser animated:YES];
    
}
+ (void)go2PurchaseViewController:(MBaseViewController *)viewCtrl
                             data:(MFinanceProductData *)data
                         pushType:(MHomeViewControllerPushType)type
                          buyMoney:(NSString *)buyMoney{
    
 
    MPurchaseViewController *purchase = [[MPurchaseViewController alloc] initWithNibName:@"MPurchaseViewController" bundle:nil];
    purchase.data = data;
    purchase.pushType = type;
    purchase.buyMoney = buyMoney;
    [viewCtrl.navigationController pushViewController:purchase animated:YES];
}
@end
