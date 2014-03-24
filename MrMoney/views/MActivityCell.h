//
//  MActivityCell.h
//  MrMoney
//
//  Created by xingyong on 14-2-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MActivityData;

@interface MActivityCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *titleLabel;
@property(nonatomic,weak)IBOutlet UILabel *contentLabel;
@property(nonatomic,weak)IBOutlet UILabel *dateLabel;
@property(nonatomic,weak)IBOutlet UIImageView *thumb;

@property(nonatomic,strong) MActivityData *data;
@end
