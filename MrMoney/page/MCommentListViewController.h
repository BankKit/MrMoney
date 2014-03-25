//
//  MCommentListViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MCommentListAction.h"
@interface MCommentListViewController : MBaseTableViewController<MCommentListActionDelegate>{
    MCommentListAction *commentListAction;
}


@property (nonatomic,assign) int                           totalNum;
@property (nonatomic,assign) int                           currPageNum;

@property (strong, nonatomic) NSString *pid;
@end
