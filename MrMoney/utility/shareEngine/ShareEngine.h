//
//  ShareEngine.h
//  ShareEngineExample
//
//  Created by 陈欢 on 13-10-8.
//  Copyright (c) 2013年 陈欢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareEngineDefine.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>
#import "MFeedbackAction.h"

@protocol ShareEngineDelegate;

@interface ShareEngine : NSObject<WXApiDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,MFeedbackActionDelegate,UIAlertViewDelegate,WeiboSDKDelegate>{
    
    MFeedbackAction *feedbackAction;
}
@property (nonatomic, assign) id<ShareEngineDelegate> delegate;

@property (nonatomic, assign) WeiboType weiboType;

//@property (nonatomic, strong) NSNumber *valueNumber;

@property (nonatomic, strong) MBaseViewController *viewCtrl;

+ (ShareEngine *)sharedInstance;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)registerApp;

- (void)sendWeChatMessage:(NSString*)message WithUrl:(NSString*)url WithType:(WeiboType)weiboType;

/**
 *@description 发送微博成功
 *@param message:文本消息 weibotype:微博类型
 */
- (void)sendShareMessage:(NSString*)message WithType:(WeiboType)weiboType;

- (void)sendEmailViewCtrl:(MBaseViewController *)viewCtrl content:(NSString*)message WithType:(WeiboType)weiboType;

@end

/**
 * @description 微博登录及发送微博类容结果的回调
 */
@protocol ShareEngineDelegate <NSObject>
@optional
/**
 *@description 发送微博成功
 *@param weibotype:微博类型
 */
- (void)shareEngineDidLogIn:(WeiboType)weibotype;

/**
 *@description 发送微博成功
 *@param weibotype:微博类型
 */
- (void)shareEngineDidLogOut:(WeiboType)weibotype;

/**
 *@description 发送微博成功
 */
- (void)shareEngineSendSuccess;

/**
 *@descrition 发送微博失败
 *@param error:失败代码
 */
- (void)shareEngineSendFail:(NSError *)error;
@end
