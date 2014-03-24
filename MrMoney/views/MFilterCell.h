//
//  MFilterCell.h
//  MrMoney
//
//  Created by xingyong on 14-1-21.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustomButton.h"
 

@interface MFilterCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *titleLabel;
@property(nonatomic,weak)IBOutlet MCustomButton *checkBoxBtn;


@property(nonatomic,strong) NSString *groupId;

@end
