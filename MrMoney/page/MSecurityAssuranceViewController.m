//
//  MSecurityAssuranceViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MSecurityAssuranceViewController.h"
#import "MLineView.h"
@interface MSecurityAssuranceViewController ()

@end

@implementation MSecurityAssuranceViewController

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
    [self createNavBarTitle:@"安全保证"];
  
    self.scrollView.contentSize = CGSizeMake(320, self.bottomView.frameY + self.bottomView.frameHeight);
   
     
    if (IsIOS7) {
        _topView.frameHeight = 180.;
        _bottomView.frameHeight = 260.;
    }else{
        _topView.frameHeight = 230;
         _bottomView.frameHeight = 320.;
    }
    [_bottomView lockDistance:20. toView:_topView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    [self.scrollView setContentSize:CGSizeMake(320, self.bottomView.frameY + self.bottomView.frameHeight + 10)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
