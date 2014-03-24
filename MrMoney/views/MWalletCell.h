//
//  MWalletCell.h
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRoundView.h"
#import "MCustomButton.h"
#import "MDrawLineView.h"
typedef void(^buttonBlockHandler)(NSIndexPath *index, MRoundView *roundView);

@class MAccountsData;
@class MCustomButton;

@interface MWalletCell : UITableViewCell<MRoundViewDelegate>

@property(nonatomic,strong)MAccountsData *data;

@property(nonatomic,weak) IBOutlet UILabel *bankNoLabel;

@property(nonatomic,weak) IBOutlet UILabel *balanceLabel;
@property(nonatomic,weak) IBOutlet UILabel *dollarLabel;
@property(nonatomic,weak) IBOutlet UILabel  *dollarTitleLabel;
@property(nonatomic,weak) IBOutlet MDrawLineView  *lineView;

@property(nonatomic,weak) IBOutlet MCustomButton *checkButton;

@property(nonatomic,weak) IBOutlet MCustomButton *roundButton;

  
@property (weak, nonatomic) IBOutlet MRoundView *roundView;

@property(copy,nonatomic) buttonBlockHandler btnHandler;

-(IBAction)buttonClick:(id)sender;
@end


