//
//  MCommentCell.h
//  MrMoney
//
//  Created by xingyong on 13-12-6.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCommentData.h"
@interface MCommentCell : UITableViewCell

@property(nonatomic,strong)MCommentData *data;

@property(nonatomic,weak)IBOutlet UILabel *nameLabel;

@property(nonatomic,weak)IBOutlet UILabel *dateLabel;

@property(nonatomic,weak)IBOutlet UILabel *contentLabel;

@property(nonatomic,weak)IBOutlet UIImageView *thumbnail;

+(float)heightForCommentCell:(MCommentData *)data;

@end
