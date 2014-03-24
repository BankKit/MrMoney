//
//  MTextFieldCell.h
//  MrMoney
//
//  Created by xingyong on 13-12-11.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageViewTouchCompletionBlock)(void);


@interface MTextFieldCell : UITableViewCell

@property(nonatomic,strong) UITextField *field;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIImageView *codeImageView;
 
@property(nonatomic,copy)   imageViewTouchCompletionBlock touchCompletionBlock;

@end
