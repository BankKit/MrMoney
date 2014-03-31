//
//  ShareEngine.m
//  ShareEngineExample
//
//  Created by 陈欢 on 13-10-8.
//  Copyright (c) 2013年 陈欢. All rights reserved.
//

#import "ShareEngine.h"
#import "UIViewController+MMDrawerController.h"

@implementation ShareEngine

static ShareEngine *sharedSingleton_ = nil;

+ (ShareEngine *) sharedInstance
{
    if (sharedSingleton_ == nil)
    {
        sharedSingleton_ =  [[self alloc] init];
    }
    
    return sharedSingleton_;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedSingleton_ == nil) {
            sharedSingleton_ = [super allocWithZone:zone];
            return sharedSingleton_;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}



- (id)init
{
    self = [super init];
    if (nil != self)
    {
        
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL weiboRet = NO;
    NSLog(@"--------------url.absoluteString-- %@",url.absoluteString);
   
    if([url.absoluteString hasPrefix:@"wb"])
    {
            weiboRet = [WeiboSDK handleOpenURL:url delegate:self];
    }
    else
    {
        weiboRet = [WXApi handleOpenURL:url delegate:self];
    }
    return weiboRet;
}

#pragma mark - weibo method

/**
 * @description 存储内容读取
 */
- (void)registerApp
{
    //向微信注册
    
    [WXApi registerApp:kWeChatAppId withDescription:@"钱先生 3.0.4"];
    
    [WeiboSDK enableDebugMode:YES];
    
    [WeiboSDK registerApp:kAppKey];
    
}

- (void)sendWeChatMessage:(NSString*)message WithUrl:(NSString*)url WithType:(WeiboType)weiboType
{
    self.weiboType = weiboType;
    
    if(weChat == weiboType)
    {
        [self sendAppContentWithMessage:message WithUrl:url WithScene:WXSceneSession];
        return;
    }
    else if(weChatFriend == weiboType)
    {
        [self sendAppContentWithMessage:message WithUrl:url WithScene:WXSceneTimeline];
        return;
    }
}

- (void)sendShareMessage:(NSString*)message WithType:(WeiboType)weiboType
{
    self.weiboType = weiboType;
    
    if (sinaWeibo == weiboType)
    {
        if (![WeiboSDK isWeiboAppInstalled]) {
            [MActionUtility showAlert:@"您还没安装新浪微博"];
            return;
        }
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
        
        [WeiboSDK sendRequest:request];
        
    }
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text =  [NSString stringWithFormat:@"钱先生-理财了、赚钱了、开心了 \n 立即注册并下载钱先生，获得100元理财本金。 http://www.qianxs.com/mrMoney/wap/wapProduct/prodsearch?rMid=%@",userMid()];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_home_press" ofType:@"png"]];
    
    message.imageObject = image;
    
    return message;
}

#pragma mark ---------------- sina delegate--------------

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
    {
        if (response.statusCode == 0) {
           
            [MActionUtility showAlert:@"分享提示" message:@"微博分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            
        }
        else
        {
            [MActionUtility showAlert:@"微博分享失败"];
        }
        
    }
}

#pragma mark - weibo respon
- (void)loginSuccess:(WeiboType)weibotype
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(shareEngineDidLogIn:)])
    {
        [self.delegate shareEngineDidLogIn:weibotype];
    }
}

- (void)logOutSuccess:(WeiboType)weibotype
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(shareEngineDidLogOut:)])
    {
        [self.delegate shareEngineDidLogOut:weibotype];
    }
}

#pragma mark ---------------- wechat delegate--------------

- (void)weChatPostStatus:(NSString*)message
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)weChatFriendPostStatus:(NSString*)message
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)sendAppContentWithMessage:(NSString*)appMessage WithUrl:(NSString*)appUrl WithScene:(int)scene
{
    // 发送内容给微信
    if (![WXApi isWXAppInstalled]) {
        [MActionUtility showAlert:@"您还没安装微信"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"钱先生-理财了、赚钱了、开心了\nwww.qianxs.com";
    message.description = @"立即注册并下载钱先生，获得100元理财本金.";
    
    [message setThumbImage:PNGIMAGE(@"icon_home_press")];
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = STRING_FORMAT(@"http://www.qianxs.com/mrMoney/wap/wapProduct/prodsearch?rMid=%@",userMid());
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
    
}

#pragma mark ------------------------
#pragma mark ------ 微信回调成功
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0){
            [MActionUtility showAlert:@"分享提示" message:@"微信分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];

        }else{
            [MActionUtility showAlert:@"微信分享失败"];
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    if (buttonIndex == 0) {
        feedbackAction = [[MFeedbackAction alloc] init];
        feedbackAction.m_delegate = self;
        [feedbackAction requestAction];
    }
}
-(NSDictionary*)onRequestFeedbackAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:2];
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    NSNumber *value = [NSNumber numberWithInt:0];
    if (self.weiboType == weChat) {
        value = [NSNumber numberWithInt:0];
    }else if(self.weiboType == weChatFriend){
        value = [NSNumber numberWithInt:1];
    }else{
        value = [NSNumber numberWithInt:2];
    }
    [dict setSafeObject:value forKey:@"channel"];
    return dict;
}
-(void)onResponseFeedbackActionSuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];

}
-(void)onResponseFeedbackActionFail{
    
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    //    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    //    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    //    [alert release];
    
}

//-(void) onSentMediaMessage:(BOOL) bSent
//{
//    // 通过微信发送消息后， 返回本App
//    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%u", bSent];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    
//    
//}
//
//-(void) onShowMediaMessage:(WXMediaMessage *) message
//{
//    // 微信启动， 有消息内容。
//    //    WXAppExtendObject *obj = message.mediaObject;
//    
//    //    shopDetailViewController *sv = [[shopDetailViewController alloc] initWithNibName:@"shopDetailViewController" bundle:nil];
//    //    sv.m_sShopID = obj.extInfo;
//    //    [self.navigationController pushViewController:sv animated:YES];
//    //    [sv release];
//    
//    //    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
//    //    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", message.title, message.description, obj.extInfo, message.thumbData.length];
//    //
//    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    //    [alert show];
//    //    [alert release];
//}
//
//-(void) onRequestAppMessage
//{
//    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//}
//
//-(void) onReq:(BaseReq*)req
//{
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        [self onRequestAppMessage];
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        [self onShowMediaMessage:temp.message];
//    }
//    
//}

- (void)sendEmailViewCtrl:(MBaseViewController *)viewCtrl content:(NSString*)message WithType:(WeiboType)weiboType{
    
    self.viewCtrl = viewCtrl;
    
    if (emailType == weiboType) {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (!mailClass) {
            [MActionUtility showAlert:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
            return;
        }
        if (![mailClass canSendMail]) {
            [MActionUtility showAlert:@"用户没有设置邮件账户"];
            return;
        }
        
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        
        //设置主题
        [mailPicker setSubject: @"钱先生"];
        
        UIImage *addPic = [UIImage imageNamed:@"icon_qianxs.jpg"];
        NSData *imageData = UIImagePNGRepresentation(addPic);            // png
        
        [mailPicker addAttachmentData: imageData mimeType:@"" fileName:@"icon_qianxs.jpg"];
        
        //添加一个pdf附件
        
        NSString *emailBody = [NSString stringWithFormat:@"<font color='black'> 我刚在全新的钱先生理财平台上获得了100块理财本金,也推荐你赶快下载钱先生安卓app,注册即可开始精彩的理财之旅。 http://m.qianxs.com/?rMid=%@</font>",userMid()];
        
        [mailPicker setMessageBody:emailBody isHTML:YES];
        [viewCtrl presentViewController:mailPicker animated:YES completion:^{
            
        }];
        
    }
    else if (smsType == weiboType){
        [self sendSMS:message recipientList:nil];
    }
    
    
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self.viewCtrl  dismissViewControllerAnimated:YES completion:^{
        
        NSString *msg;
        switch (result) {
            case MFMailComposeResultCancelled:
                msg = @"用户取消编辑邮件";
                break;
            case MFMailComposeResultSaved:
                msg = @"用户成功保存邮件";
                break;
            case MFMailComposeResultSent:
                msg = @"用户点击发送，将邮件放到队列中，还没发送";
                msg = @"发送成功";
                break;
            case MFMailComposeResultFailed:
                msg = @"用户试图保存或者发送邮件失败";
                break;
            default:
                msg = @"";
                break;
        }
        
        [MActionUtility showAlert:msg];
    }];
    
    
}

#pragma mark -
#pragma mark - 发送短信

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self.viewCtrl presentViewController:controller animated:YES completion:nil];
        
        
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.viewCtrl dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultCancelled){
            [MActionUtility showAlert:@"取消发送"];
        }
        else if (result == MessageComposeResultSent){
            [MActionUtility showAlert:@"发送成功"];
        }
        else
        {
            [MActionUtility showAlert:@"发送失败"];
        }
    }];
    
    
}



@end
