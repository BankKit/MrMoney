//
//  MCenterCalendarViewController.h
//  MrMoney
//
//  Created by xingyong on 14-2-12.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MCalendarAction.h"
#import "TTTAttributedLabel.h"
#import "PDTSimpleCalendarViewController.h"
@interface MCenterCalendarViewController : MBaseViewController<MCalendarActionDelegate,UIActionSheetDelegate>{
        MCalendarAction *calendarAction;
}
@property (nonatomic,weak)  IBOutlet UITableView  * tableView;
@property (nonatomic,weak)  IBOutlet UIScrollView * scrollView;
@property (nonatomic,weak)  IBOutlet UILabel      * dateLabel;
@property (nonatomic,strong) TTTAttributedLabel   * contentLabel;
@property (nonatomic,assign)BOOL                    isHidden;

@property (nonatomic,weak)  IBOutlet UILabel      * bankNameLabel;
@property (nonatomic,weak)  IBOutlet UILabel      * expectRateLabel;
@property (nonatomic,weak)  IBOutlet UILabel      * cycleLabel;
@property (nonatomic,weak)  IBOutlet UIImageView  * logo_iv;
@property (nonatomic,weak)  IBOutlet UIView       * bottomView;
@property (nonatomic,weak)  IBOutlet UIButton *shareBtn;


-(IBAction)onShareAction:(id)sender;
@end
