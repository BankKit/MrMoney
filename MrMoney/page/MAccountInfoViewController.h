//
//  MAccountInfoViewController.h
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MModifyPasswordAction.h"
#import "MModifyEmailAction.h"
#import "MUploadIconAction.h"
@class MUserData;

@interface MAccountInfoViewController : MBaseTableViewController <UIAlertViewDelegate,MModifyPasswordActionDelegate,MModifyEmailActionDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MUploadIconActionDelegate>{
    MModifyPasswordAction *modifyAction;
    MModifyEmailAction   *emailAction;
    MUploadIconAction *uploadAction;
}
  
@property (weak, nonatomic)   IBOutlet UIView      * footView;
  
@property (strong, nonatomic) MUserData            * user;

- (IBAction)onLogoutAction:(id)sender;
@end
