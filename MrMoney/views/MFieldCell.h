//
//  MFieldCell.h
//  MrMoney
//
//  Created by xingyong on 14-1-8.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTextField.h"

@protocol MFieldCellDelegate <NSObject>

- (void)amountChangedValue:(NSString *)amountStr;

@end

@interface MFieldCell : UITableViewCell
@property(nonatomic,weak) IBOutlet  MTextField  *field;
@property(nonatomic,weak) IBOutlet  UILabel *amountLabel;
@property(nonatomic,weak) IBOutlet  UILabel *label;
@property(nonatomic,weak) IBOutlet  UILabel *upperLabel;
@property(nonatomic,weak) IBOutlet  UILabel *markLabel;

@property(nonatomic,weak) id<MFieldCellDelegate>delegate;

- (IBAction)amountChanged:(UITextField*)sender;
@end
