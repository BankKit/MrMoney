//
//  MTextFieldCell.m
//  MrMoney
//
//  Created by xingyong on 13-12-11.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MTextFieldCell.h"

@implementation MTextFieldCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _field = [[UITextField alloc] initWithFrame:CGRectZero];
	_field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_field.backgroundColor = [UIColor clearColor];
    _field.borderStyle = UITextBorderStyleRoundedRect;
    
    _field.font = [UIFont systemFontOfSize:14.0];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
	_label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont systemFontOfSize:14.0];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.baselineAdjustment = UIBaselineAdjustmentNone;
    _label.numberOfLines = 1;
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_field.frameWidth + _field.frameX + 5 ,5, 60, 30)];
    _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
    _codeImageView.hidden = YES;
    _codeImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uesrClicked:)];
    [_codeImageView addGestureRecognizer:singleTap];
    
 

    [self.contentView addSubview:_codeImageView];
 
    [self.contentView addSubview:_field];
	[self.contentView addSubview:_label];
    
    
    return self;
}

-(void)uesrClicked:(id)sender{
    if (self.touchCompletionBlock) {
        self.touchCompletionBlock();
    }
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}



- (void) layoutSubviews {
    [super layoutSubviews];
	 _field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    CGRect rect = CGRectInset(self.contentView.bounds, IsIOS7 ? 14: 8, 4);
	rect.size = CGSizeMake(65,27);
	_label.frame = rect;
    if (_codeImageView.hidden == NO)
         
        _field.frame = CGRectMake(65 + _label.frameX , 6, self.contentView.frameWidth - 170, 26);
   
    else
        _field.frame = CGRectMake(65 + _label.frameX , 6, self.contentView.frameWidth - 100, 26);
    

    _codeImageView.frame = CGRectMake(_field.frameWidth + _field.frameX + 10 ,5, 60, 30);
    
//    _field.returnKeyType = UIReturnKeyDone;
//    _field.delegate = self;
}


 
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	_field.textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
}
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	_field.textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
