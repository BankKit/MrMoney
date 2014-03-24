//
//  MCommentListViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MCommentListAction.h"
@interface MCommentListViewController : MBaseViewController<MCommentListActionDelegate>{
    MCommentListAction *commentListAction;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) int                           totalNum;
@property (nonatomic,assign) int                           currPageNum;

@property (strong, nonatomic) NSString *pid;
@end
