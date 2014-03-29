//
//  MProductDetailViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "PopoverView.h"
#import "MCommentListAction.h"
#import "MLineView.h"
#import "MProductDetailAction.h"
@class MFinanceProductData;
@class LDProgressView;
@interface MProductDetailViewController : MBaseViewController<PopoverViewDelegate,MCommentListActionDelegate,MProductDetailActionDelegate>{

    MCommentListAction *commentListAction;
    
    MProductDetailAction *detailAction;
}

@property(nonatomic,weak)IBOutlet UIView *topContainer;
@property(nonatomic,weak)IBOutlet UIView *middleContainer;
 @property(nonatomic,weak)IBOutlet UIView *commentContainer;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIImageView *bank_logo_iv;
//@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *expect_earningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currency_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *invest_cycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *has_guaranteeLabel;

@property (weak, nonatomic) IBOutlet UILabel *product_codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *value_dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sales_regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *befromLabel;
 
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;


@property (strong, nonatomic) MFinanceProductData *data;

@property(nonatomic,assign)MBankType bankType;

-(IBAction)onCommentListAction:(id)sender;

-(IBAction)onBuyAction:(id)sender;



@end
