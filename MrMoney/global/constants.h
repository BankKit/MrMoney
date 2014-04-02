//
//  constants.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#ifndef MrMoney_constants_h
#define MrMoney_constants_h

#import "MGo2PageUtility.h"
#import "MStringUtility.h"
#import "MUtility.h"
#import "MDataInterface.h"
#import "MActionUtility.h"
#import "JSONKit.h"
#import "STDbObject.h"
#import "OrderedDictionary.h"
#import "MBorderView.h"
 


#ifndef IsIOS7
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#endif

#ifndef KHEIGHT_STATUSBAR
#define KHEIGHT_STATUSBAR 20.0f
#endif

#ifndef KHEIGHT_NAVGATIONBAR
#define KHEIGHT_NAVGATIONBAR 44.0f
#endif

#ifndef KSELECTBACKGROUND_COLOR
#define KSELECTBACKGROUND_COLOR [UIColor colorWithRed:0.96 green:0.57 blue:0.15 alpha:0.60]
#endif

#ifndef KCLEAR_COLOR
#define KCLEAR_COLOR [UIColor clearColor]
#endif

#ifndef KFONT_COLOR
#define KFONT_COLOR [UIColor colorWithRed:0.97 green:0.58 blue:0.14 alpha:0.60]
#endif


#ifndef KVIEW_BORDER_COLOR
#define KVIEW_BORDER_COLOR [UIColor colorWithWhite:0.8 alpha:0.8]
#endif

#ifndef KVIEW_BACKGROUND_COLOR
#define KVIEW_BACKGROUND_COLOR [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00]
#endif

#ifndef KITUNES_URL
#define KITUNES_URL @"https://itunes.apple.com/de/app/qian-xian-sheng/id583292699?mt=8"
#endif


#ifndef KDEFAULT_BTN
#define KDEFAULT_BTN [PNGIMAGE(@"default_btn_bg") stretchableImageWithLeftCapWidth:5 topCapHeight:10]
#endif


#ifndef KDEFAULT_GRAY_BTN
#define KDEFAULT_GRAY_BTN [PNGIMAGE(@"btn_selected_gray") stretchableImageWithLeftCapWidth:5 topCapHeight:10]
#endif


#ifndef isiPhone5
#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif



#ifndef KBANKNAME_PATH
#define KBANKNAME_PATH [[NSBundle mainBundle] pathForResource:@"bankName" ofType:@"plist"]
#endif

#ifndef KBANK_DICT
#define KBANK_DICT [NSDictionary dictionaryWithContentsOfFile:KBANKNAME_PATH]
#endif

#ifndef KPAY_DICT
#define KPAY_DICT [NSDictionary dictionaryWithContentsOfFile:[NSString getBundlePathForFile:@"payBankOrder.plist"]]
#endif

#ifndef KTREASURE_DICT
#define KTREASURE_DICT [NSDictionary dictionaryWithContentsOfFile:[NSString getBundlePathForFile:@"treasure.plist"]]
#endif

#define KGeneratingEnvironmentURL    @"https://www.qianxs.com"
#define KDebuggingEnvironmentURL     @"http://www.huchao.org:8088"



#define KSHOW_RECORD(orderNo) STRING_FORMAT(@"%@/mrMoney/portal/payOrder/showRecord.html?OrderNo=%@",KDebuggingEnvironmentURL,orderNo)


#define KAVATAR_PATH(mId,iconPath) [NSURL URLWithString:[NSString stringWithFormat:@"%@/mrMoney/mobile/invite/file/showMemIcon.html?mId=%@&pic=%@",KDebuggingEnvironmentURL,mId,iconPath]]

#ifndef KLOCAL_KEY
#define KLOCAL_KEY @"HU8W3N09J24NQ7KL"
#endif

#ifndef KSIGN_BODY
#define KSIGN_BODY @"signBody"
#endif

#ifndef KBLANCE
#define KBLANCE @"kblance"
#endif

#ifndef KNOTITICATION_BLANCE
#define KNOTITICATION_BLANCE @"knotitication"
#endif

#ifndef KNOTITICATION_ADDCOUNT
#define KNOTITICATION_ADDCOUNT @"knotitication_addcount"
#endif

 
#define kCurrentPattern			@"KeyForCurrentPatternToUnlock"
#define kCurrentPatternTemp		@"KeyForCurrentPatternToUnlockTemp"

// date formate
#define kDefaultDateFormat1          @"yyyy-MM-dd"
#define kDefaultDateFormat2          @"yyyyMMdd"
#define kDefaultTimeStampFormatHms   @"HH:mm:ss"

#define kHelveticaLight              @"HelveticaNeue-Light"


#pragma mark - 常用字符串

#define KEMPTY_STR                                    @""

#define KALERT_STR                                    @"提示"

#define KCONFIRM_STR                                  @"确定"

#define STRING_FORMAT(...) [NSString stringWithFormat: __VA_ARGS__]

// 加载图片
#define PNGIMAGE(NAME)   [UIImage imageNamed:NAME]
//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]


// 字体大小(常规/粗体)
#define BOLDFONT(FONTSIZE)      [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define ScreenHeight           [UIScreen mainScreen].applicationFrame.size.height

#define KLIGHTRED [UIColor colorWithRed:0.96 green:0.45 blue:0.45 alpha:1.00]
#define KLIGHTBLUE [UIColor colorWithRed:0.56 green:0.76 blue:0.76 alpha:1.00]
 

#ifndef DLog
#if DEBUG
#define DLog( s, ... ) NSLog( @"\n\n************************************* DEBUG *************************************\n\t<%p %@:(%d)>\n\n\t%@\n*********************************************************************************\n\n", self, \
[[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], __LINE__, \
[NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif
#endif


#endif
