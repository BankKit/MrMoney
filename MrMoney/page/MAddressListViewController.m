//
//  MAddressListViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-31.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MAddressListViewController.h"
#import "UIViewController+MaryPopin.h"
@interface MAddressListViewController ()

@end

@implementation MAddressListViewController

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

    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bankArray.count;
}

 
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = SYSTEMFONT(14);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [self.bankArray objectAtIndex:indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *addressName =    [self.bankArray objectAtIndex:indexPath.row];
    if (self.completionBlock) {
        self.completionBlock(addressName);
    }
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
