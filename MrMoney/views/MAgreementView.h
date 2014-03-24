//
//  MAgreementView.h
//  MrMoney
//
//  Created by xingyong on 14-1-20.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAgreementViewDelegate <NSObject>

-(void)agreementViewButtonClick:(BOOL)check;

@end

@interface MAgreementView : UIView
@property(nonatomic,assign)BOOL isFlag;

@property(nonatomic,weak) IBOutlet id<MAgreementViewDelegate>delegate;
@end
