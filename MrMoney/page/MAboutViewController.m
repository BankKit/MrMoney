//
//  MAboutViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-13.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MAboutViewController.h"

@interface MAboutViewController ()

@end

@implementation MAboutViewController

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
    
    [self createNavBarTitle:@"关于"];
    // Do any additional setup after loading the view from its nib.
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
