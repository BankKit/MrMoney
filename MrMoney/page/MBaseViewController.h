//
//  MBaseViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "MCategory.h"
#import "UIViewController+MBProgressHUD.h" 

 
typedef void(^buttonHandler)(void);

typedef enum  {
    BaseVC_PushType           = 333127,
    BaseVC_PresentType        = 333128
   
}BaseVC_LoadType;

@interface MBaseViewController : UIViewController{
   
}

@property(nonatomic,copy)buttonHandler buttonHander;
 
/**
 *  创建导航条右侧按钮
 *
 *  @param normalImagename   按钮名称
 *  @param highlighImagename 高亮按钮名称
 *  @param buttonTitle       按钮名称
 */

-(void)initRightButtonItem:(NSString *)buttonImage title:(NSString*)title completionHandler:(buttonHandler)handler;
/**
 *  创建导航栏标题
 *
 *  @param title 标题内容
 */
-(void)createNavBarTitle:(NSString *)title;

/** 视图控制器加载类型 */
@property (nonatomic,assign) BaseVC_LoadType loadType;


@property(nonatomic,strong)NSMutableArray *dataArray;

-(void)onButtonActionBack:(id)sender;

@end
