//
//  MRechargeCell.h
//  MrMoney
//
//  Created by xingyong on 14-3-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTextField.h"
@interface MRechargeCell : UITableViewCell

@property(nonatomic,weak) IBOutlet  MTextField *field;
@property(nonatomic,weak) IBOutlet  UILabel *label;
@property(nonatomic,weak) IBOutlet  UILabel *upperLabel;

- (IBAction)textFieldDidChange:(UITextField *)textField;
@end
