//
//  MPublishCommentViewController.m
//  MrMoney
//
//  Created by xingyong on 14-4-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MPublishCommentViewController.h"

@interface MPublishCommentViewController ()

@end

@implementation MPublishCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavBarTitle:@"发表评论"];
    
    [_textView becomeFirstResponder];
    
    [_textView.layer borderWidth:1 borderColor:[UIColor whiteColor] cornerRadius:1];
    
 
}
-(NSDictionary*)onRequestPublishCommentAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:4];
    [dict setSafeObject:self.pId forKey:@"pId"];

    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:_textView.text forKey:@"content"];
    
    [dict setSafeObject:[NSNumber numberWithInt:0] forKey:@"rootId"];
    
    return dict;
}
-(void)onResponsePublishCommentActionSuccess{
    [self hideHUD];
    [MActionUtility showAlert:@"评论成功"];
}
-(void)onResponsePublishCommentActionFail{
        [self hideHUD];
        [MActionUtility showAlert:@"评论失败"];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([stripWhiteSpace(textView.text) length] == 0) {
        [MActionUtility showAlert:@"评论内容不能为空"];
        return NO;
    }
    
    if ([@"\n"isEqualToString:text] == YES) {
        [textView resignFirstResponder];
     
        publishAction = [[MPublishCommentAction alloc] init];
        publishAction.m_delegate = self;
        [publishAction requestAction];
        [self showHUD];
        
        return NO;
    }
    return YES;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    publishAction.m_delegate = nil;
}

@end
