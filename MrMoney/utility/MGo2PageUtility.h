//
//  MGo2PageUtility.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMoneyBabyData;
@class MFinanceProductData;
typedef void(^loginBlockHandler)(void);

/**
 *  定义跳转枚举
 */
typedef enum  {
    /**
     *  银行理财产品
     */
    MFinanceProductsType = 1,
    /**
     *  金融理财产品
     */
    MInternetType,
    /**
     *  钱宝宝
     */
    MMoneyBabyType,
    /**
     * 财富中心
     */
    MWalletType ,
    /**
     *  我的收藏
     */
    MFavoriteType,
    /**
     *  安全保证
     */
    MSecurityAssuranceType,
    /**
     *  基金
     */
    MFundType,
    /**
     *  抢购
     */
    MGrabBuyType,
    /**
     *  风险评估
     */
    MRiskType,
    /**
     *  产品详情
     */
    MProductDetailsType,
    /**
     *  pop
     */
    MPopType,
    /**
     *  充值
     */
    MRechargeType,
    /**
     *  首页
     */
    MHomeType
    
} MHomeViewControllerPushType;

/**
 *  银行
 */
typedef enum {
    /**
     *  招商银行
     */
    MBank_CMB =1,
    /**
     *  民生银行
     */
    MBank_CMBC ,
    /**
     *  平安银行
     */
    MBank_PAB 
    
}MBankType;

#import "MBaseViewController.h"

@interface MGo2PageUtility : NSObject
/**
 *  压栈到银行理财产品
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转--->子控制器
 */
+ (void)go2MFinanceProductsViewController:(MBaseViewController *)viewCtrl
                                 pushType:(MHomeViewControllerPushType)type;

/**
 *  压栈到银行理财产品详情
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转--->子控制器
 */
+ (void)go2MProductDetailViewController:(MBaseViewController *)viewCtrl
                                   data:(MFinanceProductData *)data;
    
/**
 *  压栈到安全保证
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转--->子控制器
 */
+ (void)go2MSecurityAssuranceViewController:(MBaseViewController *)viewCtrl
                                 pushType:(MHomeViewControllerPushType)type;

/**
 *  压栈到我的钱包
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转--->子控制器
 */

+ (void)go2MWalletViewController:(MBaseViewController *)viewCtrl
                        pushType:(MHomeViewControllerPushType)type
                     canWithdraw:(NSString *)drawMoney;

/**
 *  压栈到聚财迷
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转--->子控制器
 */
+ (void)go2MTreasureViewController:(MBaseViewController *)viewCtrl
                          pushType:(MHomeViewControllerPushType)type;
/**
 *  压栈到钱宝宝
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转--->子控制器
 */
+ (void)go2MMoneyBabyViewController:(MBaseViewController *)viewCtrl
                               data:(MMoneyBabyData *)money
                           pushType:(MHomeViewControllerPushType)type;


/**
 *  到登陆界面
 *
 *  @param viewCtrl 主控制器
 *  @param type     跳转方式 是压栈 or 模态
 */
+ (void)go2MLoginViewController:(MBaseViewController *)viewCtrl
              completionHandler:(loginBlockHandler)handler;

 
/**
 *  web控制器
 *
 *  @param viewCtrl 主控制器
 *  @param title    nav title
 *  @param url      url链接
 */
+ (void)go2MWebBrowser:(MBaseViewController *)viewCtrl
                 title:(NSString *)title
                webUrl:(NSString *)url;

/**
 *  购买理财产品控制器
 *
 *  @param viewCtrl 主控制器
 *  @param data     产品数据
 *  @param type     跳转--->子控制器
 */
+ (void)go2PurchaseViewController:(MBaseViewController *)viewCtrl
                             data:(MFinanceProductData *)data
                         pushType:(MHomeViewControllerPushType)type
                         buyMoney:(NSString *)buyMoney;

@end
