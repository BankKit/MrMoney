//
//  MPublishCommentViewController.h
//  MrMoney
//
//  Created by xingyong on 14-4-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MPublishCommentAction.h"
@interface MPublishCommentViewController : MBaseViewController<MPublishCommentActionDelegate>
{
    MPublishCommentAction *publishAction;
}
@property (nonatomic,weak) IBOutlet UITextView *textView;
@property (nonatomic,strong) NSString *pId;

@end
