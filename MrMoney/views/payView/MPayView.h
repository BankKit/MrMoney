//
//  MPayView.h
//  KDropDownMultipleSelection
//
//  Created by xingyong on 14-3-5.
//  Copyright (c) 2014年 macmini17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPayView : UIView
@property(nonatomic,weak)IBOutlet UIButton *payBtn;
@property(nonatomic,weak)IBOutlet UIButton *switchBtn;
@property(nonatomic,weak)IBOutlet UIButton *backBtn;
@property(nonatomic,weak)IBOutlet UIImageView *backImageView;
@property(nonatomic,weak)IBOutlet UIImageView *backImageView2;

@property(nonatomic,weak)IBOutlet UILabel *investMoneyLabel;
@property(nonatomic,weak)IBOutlet UILabel *titleMarkLabel;
@property(nonatomic,weak)IBOutlet UILabel *bankLabel;

@property(nonatomic,weak)IBOutlet UITextField *moneyTf;
@property(nonatomic,weak)IBOutlet UITextField *passwordTf;
@end
