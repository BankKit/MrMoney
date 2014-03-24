//
//  MBaseViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-2.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"

@interface MBaseViewController ()

@end

@implementation MBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
 
  
    self.dataArray = [NSMutableArray array];
    
    //    self.navigationController.navigationBar.translucent = NO;
    //
//        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    //    UIColor * titleColor = [UIColor whiteColor];
    //
    //    NSDictionary * titleDict = [NSDictionary dictionaryWithObject:titleColor forKey:UITextAttributeTextColor];
    
    /**
     *  设置导航栏的内容(字体，颜色等)
     */
    if (IsIOS7) {
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        
    }
 

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor],UITextAttributeTextColor,
                                                                     [UIFont boldSystemFontOfSize:14.0f], NSFontAttributeName, nil]];
     [self SetSubViewExternNone:self];
 
    
    UIImage *navImage = nil;
    if (IsIOS7) {
        navImage = [UIImage imageNamed:@"navigationBg"];
    }else{
        navImage = [UIImage imageNamed:@"bg_nav"];
    }
 
    [self.navigationController.navigationBar setBackground:navImage];
  
    [self createBackNavBar];
    
}
 
-(void)createNavBarTitle:(NSString *)title{
    
    NSArray *viewControllers =  [self.navigationController viewControllers];
 
    BOOL isFlag = ([viewControllers count] > 1 || (self.loadType == BaseVC_PresentType)) ? YES : NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isFlag ? 2 : -30, 0, 200, KHEIGHT_NAVGATIONBAR)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textColor = [UIColor whiteColor];
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, KHEIGHT_NAVGATIONBAR)];
    rightView.backgroundColor = [UIColor clearColor];
    [rightView addSubview:label];
    self.navigationItem.titleView = rightView;
    
}

- (void)setnavcorner
{
    CALayer *capa = [self.navigationController navigationBar].layer;
  
 
    CGRect bounds = capa.bounds;
    bounds.size.height += 10.0f;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
 
    maskLayer.path = maskPath.CGPath;
    capa.mask = maskLayer;
}

-(void)initRightButtonItem:(NSString *)buttonImage title:(NSString*)title completionHandler:(buttonHandler)handler{
    
    UIImage *image = [UIImage imageNamed:buttonImage];
    
    UIButton *rightBtn= [UIButton buttonWithFrame:CGRectMake((50 - image.width)/2 + 4, -5, image.width, KHEIGHT_NAVGATIONBAR) image:image highlightedImage:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, KHEIGHT_NAVGATIONBAR)];
    label.backgroundColor = [UIColor clearColor];
    label.centerX = rightBtn.centerX;
    label.frameY = 12;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:11.0f];
    label.textColor = [UIColor whiteColor];
    
    
    self.buttonHander = handler;
    
 
    
    UIImageView *l_imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_verticalBg.png"]];
    [l_imageV setFrame:CGRectMake(0, 0, 2, KHEIGHT_NAVGATIONBAR)];
    
    
	UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, KHEIGHT_NAVGATIONBAR)];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = rightView.frame;
  
    [actionBtn addTarget:self action:@selector(prformButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
	[rightView addSubview:rightBtn];
    [rightView addSubview:l_imageV];
    [rightView addSubview:label];
    [rightView addSubview:actionBtn];
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [self addRightBarButtonItem:rightButtonItem];
    
}

-(void)prformButtonClick:(id)sender{
    if (self.buttonHander) {
        self.buttonHander();
    }
    //子类重写该方法
}
 
#pragma -
#pragma mark 返回上一个视图
-(void)onButtonActionBack:(id)sender{
    
    __weak MBaseViewController *bself = self;
    
    if (BaseVC_PresentType == self.loadType)
    {
        [self bk_performBlock:^(id obj) {
            [bself dismissViewControllerAnimated:YES completion:nil];
 
        } afterDelay:0.3];
        
    }
    else
    {
        [self bk_performBlock:^(id obj) {
            [bself.navigationController popViewControllerAnimated:YES];
        } afterDelay:0.3];

    }
    
    
    
}

/**
 *  创建自定义返回按钮
 */
-(void)createBackNavBar{
    
    UIImage *normalImage=[UIImage imageNamed:@"home_backBtn.png"];
    
    UIButton *l_btn_back = [UIButton buttonWithFrame:CGRectMake((50 - normalImage.width)/2, 0, normalImage.width, KHEIGHT_NAVGATIONBAR) image:normalImage highlightedImage:nil];
    
    
    
    UIImageView *l_imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_verticalBg.png"]];
    [l_imageV setFrame:CGRectMake(48,0, 2, 43)];
    
	UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, KHEIGHT_NAVGATIONBAR)];
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = backView.bounds;
    [touchBtn addTarget:self action:@selector(onButtonActionBack:) forControlEvents:UIControlEventTouchUpInside];
	[backView addSubview:l_btn_back];
    [backView addSubview:l_imageV];
    [backView addSubview:touchBtn];
    
    
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [self addLeftBarButtonItem:leftButtonItem];
    
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
    } else {
        
        negativeSpacer.width = 0;
        
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
        
    } else {
        negativeSpacer.width = 0;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
}



-(void)SetSubViewExternNone:(UIViewController *)viewController
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IsIOS7)
    {
        
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        
//        viewController.automaticallyAdjustsScrollViewInsets = YES;
        viewController.extendedLayoutIncludesOpaqueBars = NO;
        viewController.modalPresentationCapturesStatusBarAppearance = NO;
        viewController.navigationController.navigationBar.translucent = NO;
        
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    [super viewDidUnload];
    self.dataArray = nil;
    
}

@end
