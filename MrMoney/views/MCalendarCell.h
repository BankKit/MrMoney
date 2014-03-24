//
//  MCalendarCell.h
//  MrMoney
//
//  Created by xingyong on 14-2-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageViewTap)(int tag);

@class MCalendarData;
@interface MCalendarCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView *bgImageView1;
@property(nonatomic,weak)IBOutlet UIImageView *bgImageView2;

@property(nonatomic,weak)IBOutlet UILabel *bankNameLabel1;
@property(nonatomic,weak)IBOutlet UILabel *bankNameLabel2;

@property(nonatomic,weak)IBOutlet UILabel *productNameLabel1;
@property(nonatomic,weak)IBOutlet UILabel *productNameLabel2;

@property(nonatomic,weak)IBOutlet UILabel *amountLabel1;
@property(nonatomic,weak)IBOutlet UILabel *amountLabel2;


@property(nonatomic,weak)IBOutlet UIImageView *logo_iv1;
@property(nonatomic,weak)IBOutlet UIImageView *logo_iv2;

@property(nonatomic,weak)IBOutlet UIView *leftView;
@property(nonatomic,weak)IBOutlet UIView *rightView;

@property(nonatomic,copy)imageViewTap imageViewBlock;



@property(nonatomic,strong)MCalendarData *data;
@property(nonatomic,strong)MCalendarData *data2;
@end
