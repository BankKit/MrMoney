//
//  MAddAccountViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-16.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"

@class SMPageControl;

@interface MAddAccountViewController : MBaseViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) UIButton *currentButton;
 @property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
 
@property (strong, nonatomic) SMPageControl *pageControl;
@property (assign, nonatomic) int  buttonIndex;

@property(nonatomic,assign)MPushType ptype;
  
-(IBAction)onNextStepAction:(id)sender;
@end
