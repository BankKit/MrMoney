//
//  MCompleteInfoViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-21.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MBindingAction.h"
@interface MCompleteInfoViewController : MBaseViewController<MBindingActionDelegate>{
    MBindingAction *bindAction;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
 
@property(nonatomic,copy)NSString *openid;

- (IBAction)onSubmitAction:(id)sender;

@end
