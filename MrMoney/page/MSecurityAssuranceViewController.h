//
//  MSecurityAssuranceViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MLineView.h"

@interface MSecurityAssuranceViewController : MBaseViewController
@property(nonatomic,assign)MHomeViewControllerPushType type;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet MLineView *lineView;

@end
